require 'color-rgb'
require 'matrix'
require_relative 'color-mixing'
require_relative 'color-library'

# Based on this work mostly:
# http://scottburns.us/subtractive-color-mixture/
#
# Copyright 2020 David Barrett
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

$stdout.sync = true

puts "This software is somewhat vocal about its internal work, but could take some time"
puts

MAX_RANGE = 5
MAX_RATIO_PART = 10
MIXING_RATIOS_TO_ATTEMPT = [
  [1, 1],
  [2, 1],
  [3, 2],
  [3, 1],
  [4, 1],
  [4, 3],
  [5, 1],
  [5, 2],
  [5, 3],
  [5, 4],
  [6, 1],
  [6, 5],
  [7, 1],
  [7, 2],
  [7, 3],
  [7, 4],
  [7, 5],
  [7, 6],
  [8, 1],
  [8, 3],
  [8, 5],
  [8, 7],
  [9, 1],
  [9, 2],
  [9, 4],
  [9, 5],
  [9, 7],
  [9, 8],
  [10, 1],
  [10, 3],
  [10, 7],
  [10, 9]
]

# Find nearest color
target_hex = ARGV[0]
red = target_hex[0, 2].to_i(16)
green = target_hex[2, 2].to_i(16)
blue = target_hex[4, 2].to_i(16)
target_color = {
  name: 'Target',
  hex: target_hex,
  color_rgb: Color::RGB.new(red, green, blue),
  rgb: {
    red: red,
    green: green,
    blue: blue
  }
}
target_color[:lab] = target_color[:color_rgb].to_lab

nearest_colors = ColorLibrary.nearest_colors(target_color, MAX_RANGE)

def matrix_from_one_dimensional_array(array)
  Matrix.build(array.size, 1) { |row, col| array[row] }
end

def mix_color_curves(curves, weights)
  if weights.nil?
    weights = Array.new(curves.size, 1)
  end

  weights.map! { |weight| weight.to_f }

  # Multiply out the weighted curves
  sum_of_weights = weights.sum.to_f
  stepper_curve = Array.new(curves[0].to_a.size, 1.0)
  curves.map.with_index do |curve, weight_index|
    curve.to_a.flatten.each.with_index do |entry, index|
      stepper_curve[index] *= entry ** (weights[weight_index] / sum_of_weights)
    end
  end

  # Output new matrix
  matrix_from_one_dimensional_array(stepper_curve)
end

def reflectance_curve_for_color(color)
  rgb = Matrix[
    [ color[:rgb][:red] / 255.0 ],
    [ color[:rgb][:green] / 255.0 ],
    [ color[:rgb][:blue] / 255.0 ]
  ]
  ColorMixing::B12 * rgb
end

def curve_to_rgb(curve)
  (ColorMixing::T * curve).to_a.flatten.map do |component|
    value = component.real? ? component : component.real
    [(value * 255).to_i, 255].min
  end
end

def find_inverse_curve(target_color, other_color, mixing_ratios)
  target_curve_as_a = reflectance_curve_for_color(target_color).to_a.flatten
  other_curve_as_a = reflectance_curve_for_color(other_color).to_a.flatten

  sum_of_weights = mixing_ratios.sum(0.0)
  weight_of_other_color = mixing_ratios[0].to_f
  weight_of_unknown_color = mixing_ratios[1].to_f
  inverse_curve_as_a = []
  target_curve_as_a.each_index do |index|
    inverse_curve_as_a[index] = (
      target_curve_as_a[index] / (
        other_curve_as_a[index] ** (
          weight_of_other_color / sum_of_weights
        )
      )
    ) ** (
      sum_of_weights / weight_of_unknown_color
    )
    inverse_curve_as_a[index] = inverse_curve_as_a[index].real? ? inverse_curve_as_a[index] : inverse_curve_as_a[index].real
  end

  matrix_from_one_dimensional_array(inverse_curve_as_a)
end

def mix_colors(colors, ratio)
  curves = colors.map { |color| reflectance_curve_for_color(color) }
  mix_color_curves(curves, ratio)
end

def highest_common_divider(array)
  highest_divider = 0
  for i in 1..array.min
    if array.map { |number| number.modulo(i) }.sum == 0
      highest_divider = i
    end
  end
  highest_divider
end

def generate_extra_level_of_ratios(array)
  (array * (MAX_RATIO_PART + 1)).map.with_index do |ratio, index|
    ratio.dup.push(index / array.size)
  end
end

def mix_colors_and_ratio_description(mix)
  (
    mix[:colors].map { |color| color[:name] }.join(":") +
    " " +
    mix[:ratio].map { |ratio_part| ratio_part.to_i }.join(":")
  )
end

def print_matches(matches)
  matches.each do |match|
    description = "#{match[:hex]}: (D: #{match[:distance].round(4)}) "
    if match[:colors]
      description += mix_colors_and_ratio_description(match)
    else
      description += "#{match[:name]}"
    end
    if match[:distance] == 0.0
      description += " (EXACT)"
    elsif match[:distance] < 2.3
      description += " (PERCEPTUALLY THE SAME)"
    end
    puts description
  end
end

def create_mix_object(colors, ratio, target_color)
  actual_mix = curve_to_rgb(mix_colors(colors, ratio))
  rgb = {
    red: actual_mix[0],
    green: actual_mix[1],
    blue: actual_mix[2]
  }
  actual_mix_color_rgb = Color::RGB.new(rgb[:red], rgb[:green], rgb[:blue])

  hcd = highest_common_divider(ratio.reject { |p| p == 0 })
  colors_with_ratio = colors.map.with_index do |color, index|
    {
      color: color,
      ratio_part: ratio[index] / hcd
    }
  end.reject do |cr|
    cr[:ratio_part] == 0
  end.sort do |a, b|
    b[:ratio_part] <=> a[:ratio_part]
  end

  {
    actual_mix: actual_mix,
    actual_mix_color_rgb: actual_mix_color_rgb,
    rgb: rgb,
    hex: "#{rgb[:red].to_s(16)}#{rgb[:green].to_s(16)}#{rgb[:blue].to_s(16)}",
    colors: colors_with_ratio.map { |item| item[:color] },
    ratio: colors_with_ratio.map { |item| item[:ratio_part] },
    distance: Color::Comparison.distance(target_color[:color_rgb], actual_mix_color_rgb)
  }
end

def generate_color_mixes(colors, target_color)
  ratio_array = (1..MAX_RATIO_PART).to_a.map { |el| Array.new(1, el) }
  if colors.size > 1
    for i in 2..(colors.size)
      ratio_array = generate_extra_level_of_ratios(ratio_array)
    end
  end

  # Remove max of array = sum of array, which are 1 color arrays!
  # Removes ratios with HCD > 1, as these would be superfluous
  ratio_array
    .reject { |ratio| ratio.max == ratio.sum }
    .reject { |ratio| highest_common_divider(ratio) > 1 }
    .push( [1].concat(Array.new(colors.size - 1, 0)) )
    .map do |ratio|
      actual_mix = curve_to_rgb(mix_colors(colors, ratio))
      actual_mix_color_rgb = Color::RGB.new(actual_mix[0], actual_mix[1], actual_mix[2])
      create_mix_object(colors, ratio, target_color)
    end
    .reject do |mix|
      mix[:colors].size == 0
    end
end

def progress_bar_dot
  print "."
end

def generate_icr(color_a, color_b, ratio)
  inverse_curve = find_inverse_curve(color_a, color_b, ratio)
  {
    inverse_curve: inverse_curve,
    ratio: ratio
  }
end

def icr_invalid?(icr)
  icr[:inverse_curve].to_a.flatten.any? { |curve_part| curve_part.nan? || (!curve_part.finite?) }
end

# Mixes
all_mixes = nearest_colors.map do |query_color|
  puts
  puts "Checking mixes with #{query_color[:name]}"
  MIXING_RATIOS_TO_ATTEMPT.map do |ratio|
    # Get nearest color to perfect complement
    generate_icr(target_color, query_color, ratio)
  end.reject do |icr|
    icr_invalid?(icr)
  end.map do |icr|
    r, g, b = curve_to_rgb(icr[:inverse_curve])
    nearest_mix_color = ColorLibrary.nearest_available_color(Color::RGB.new(r, g, b))
    create_mix_object([query_color, nearest_mix_color], icr[:ratio], target_color)
  end.reject do |two_color_mix|
    two_color_mix[:colors].uniq.size == 1
  end.map do |two_color_mix|
    [two_color_mix] + MIXING_RATIOS_TO_ATTEMPT.map do |ratio|
      generate_icr(target_color, two_color_mix, ratio)
    end.reject do |icr|
      icr_invalid?(icr)
    end.map do |icr|
      r, g, b = curve_to_rgb(icr[:inverse_curve])
      ColorLibrary.nearest_available_color(Color::RGB.new(r, g, b))
    end.uniq.reject do |third_color|
      two_color_mix[:colors].map { |color| color[:name] }.include? third_color[:name]
    end.map do |third_color|
      progress_bar_dot
      generate_color_mixes(two_color_mix[:colors] + [third_color], target_color)
    end
  end
end.flatten.uniq do |mix|
  mix_colors_and_ratio_description(mix)
end.sort do |a, b|
  a[:distance] <=> b[:distance]
end

puts
puts
puts "NEAREST COLORS:"
puts
print_matches(nearest_colors)

# Bail out if safe
if nearest_colors[0][:hex] == target_color[:hex]
  puts "Exact matches found"
  exit
elsif Color::Comparison.distance(nearest_colors[0][:color_rgb], target_color[:color_rgb]) < 2.3
  puts "Nearest color is not noticeably different than target color"
  exit
end

puts
puts "BEST TWO COLOR MIXES:"
puts
print_matches(all_mixes.reject { |mix| mix[:colors].size != 2 }.slice(0, MAX_RANGE))

puts
puts "BEST THREE COLOR MIXES:"
puts
print_matches(all_mixes.reject { |mix| mix[:colors].size != 3 }.slice(0, MAX_RANGE))
