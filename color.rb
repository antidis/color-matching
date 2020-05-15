require 'color-rgb'
require 'matrix'

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

paints = {
  "Abaddon Black" => "000000",
  "Averland Sunset" => "fbba00",
  "Caledor Sky" => "3a679b",
  "Caliban Green" => "003b1e",
  "Castellan Green" => "3a4c21",
  "Catachan Fleshtone" => "4e3831",
  "Celestra Grey" => "9baeae",
  "Ceramite White" => "ffffff",
  "Corax White" => "ececec",
  "Corvus Black" => "1d1d1b",
  "Daemonette Hide" => "746e8b",
  "Death Guard Green" => "737a51",
  "Death Korps Drab" => "4a4c40",
  "Deathworld Forest" => "686d2d",
  "Dryad Bark" => "3b352e",
  "Gal Vorbak Red" => "55323e",
  "Grey Seer" => "c6c6c6",
  "Incubi Darkness" => "0e4445",
  "Ionrach Skin" => "ddccb9",
  "Jokaero Orange" => "e52d12",
  "Kantor Blue" => "0d244e",
  "Khorne Red" => "6b0e02",
  "Lupercal Green" => "022c2f",
  "Macragge Blue" => "193a79",
  "Mechanicus Standard Grey" => "454f50",
  "Mephiston Red" => "9b130b",
  "Morghast Bone" => "c9b483",
  "Mournfang Brown" => "681409",
  "Naggaroth Night" => "443655",
  "Night Lords Blue" => "043660",
  "Nocturne Green" => "1e322b",
  "Phoenician Purple" => "471352",
  "Rakarth Flesh" => "aca394",
  "Ratskin Flesh" => "b36d48",
  "Rhinox Hide" => "4e3433",
  "Screamer Pink" => "821a41",
  "Screaming Bell" => "ae430a",
  "Steel Legion Drab" => "685733",
  "Stegadon Scale Green" => "014360",
  "The Fang" => "4a667b",
  "Thousand Sons Blue" => "025573",
  "Wraithbone" => "e6dbbe",
  "Zandri Dust" => "a89757",
  "Administratum Grey" => "9da099",
  "Ahriman Blue" => "007c8f",
  "Alaitoc Blue" => "305688",
  "Altdorf Guard Blue" => "2a4b9b",
  "Baharroth Blue" => "64bfce",
  "Balor Brown" => "925e06",
  "Baneblade Brown" => "99816b",
  "Bestigor Flesh" => "d68c50",
  "Bloodreaver Flesh" => "784d4b",
  "Blue Horror" => "b0c2d8",
  "Cadian Fleshtone" => "cb7853",
  "Calgar Blue" => "456eb4",
  "Dark Reaper" => "425553",
  "Dawnstone" => "7a7d74",
  "Deathclaw Brown" => "b96a52",
  "Dechala Lilac" => "c0a8d0",
  "Deepkin Flesh" => "deded2",
  "Doombull Brown" => "5e0c0a",
  "Dorn Yellow" => "fff054",
  "Elysian Green" => "81932f",
  "Eshin Grey" => "545658",
  "Evil Sunz Scarlet" => "bf1111",
  "Fenrisian Grey" => "789dbb",
  "Fire Dragon Bright" => "f0844b",
  "Flash Gitz Yellow" => "ffed00",
  "Flayed One Flesh" => "e8c087",
  "Fulgrim Pink" => "f4b7d3",
  "Gauss Blaster Green" => "90c4aa",
  "Genestealer Purple" => "7c5ba3",
  "Gorthor Brown" => "c07009",
  "Hoeth Blue" => "507eb4",
  "Kabalite Green" => "008560",
  "Kakophoni Purple" => "9173ae",
  "Karak Stone" => "c1a068",
  "Kislev Flesh" => "c9a073",
  "Krieg Khaki" => "c9c17e",
  "Loren Forest" => "5c7426",
  "Lothern Blue" => "3ba1d0",
  "Lugganath Orange" => "f4a188",
  "Moot Green" => "56aa2e",
  "Nurgling Green" => "8fa15f",
  "Ogryn Camo" => "a9ae40",
  "Pallid Wych Flesh" => "d6d5c4",
  "Phalanx Yellow" => "fede32",
  "Pink Horror" => "96325c",
  "Russ Grey" => "54758a",
  "Screaming Skull" => "dad8a6",
  "Skarsnik Green" => "5f8f67",
  "Skavenblight Dinge" => "4f4740",
  "Skrag Brown" => "944b07",
  "Slaanesh Grey" => "958f9a",
  "Sons of Horus Green" => "08566a",
  "Sotek Green" => "0e6875",
  "Squig Orange" => "af4d3e",
  "Stormvermin Fur" => "7c7269",
  "Straken Green" => "6f8515",
  "Sybarite Green" => "3aa063",
  "Tallarn Sand" => "aa7d00",
  "Tau Light Ochre" => "c16f09",
  "Teclis Blue" => "397bbf",
  "Temple Guard Blue" => "39998d",
  "Thunderhawk Blue" => "467379",
  "Troll Slayer Orange" => "eb641e",
  "Tuskgor Fur" => "8e3733",
  "Ulthuan Grey" => "d3e3de",
  "Ungor Flesh" => "dbac62",
  "Ushabti Bone" => "c5c180",
  "Vulkan Green" => "304635",
  "Warboss Green" => "3c7c54",
  "Warpfiend Grey" => "757179",
  "Warpstone Glow" => "277227",
  "Wazdakka Red" => "8d1207",
  "White Scar" => "ffffff",
  "Wild Rider Red" => "e12318",
  "Word Bearers Red" => "650c12",
  "Xereus Purple" => "4b225b",
  "Yriel Yellow" => "ffd900",
  "Zamesi Desert" => "e0a407"
}

B12 = Matrix[
  [0.0933, -0.1729, 1.0796],
  [0.0933, -0.1728, 1.0796],
  [0.0932, -0.1725, 1.0794],
  [0.0927, -0.1710, 1.0783],
  [0.0910, -0.1654, 1.0744],
  [0.0854, -0.1469, 1.0615],
  [0.0723, -0.1031, 1.0308],
  [0.0487, -0.0223, 0.9736],
  [0.0147, 0.0980, 0.8873],
  [-0.0264, 0.2513, 0.7751],
  [-0.0693, 0.4234, 0.6459],
  [-0.1080, 0.5983, 0.5097],
  [-0.1374, 0.7625, 0.3749],
  [-0.1517, 0.9032, 0.2486],
  [-0.1437, 1.0056, 0.1381],
  [-0.1080, 1.0581, 0.0499],
  [-0.0424, 1.0546, -0.0122],
  [0.0501, 0.9985, -0.0487],
  [0.1641, 0.8972, -0.0613],
  [0.2912, 0.7635, -0.0547],
  [0.4217, 0.6129, -0.0346],
  [0.5455, 0.4616, -0.0071],
  [0.6545, 0.3238, 0.0217],
  [0.7421, 0.2105, 0.0474],
  [0.8064, 0.1262, 0.0675],
  [0.8494, 0.0692, 0.0814],
  [0.8765, 0.0330, 0.0905],
  [0.8922, 0.0121, 0.0957],
  [0.9007, 0.0006, 0.0987],
  [0.9052, -0.0053, 0.1002],
  [0.9073, -0.0082, 0.1009],
  [0.9083, -0.0096, 0.1012],
  [0.9088, -0.0102, 0.1014],
  [0.9090, -0.0105, 0.1015],
  [0.9091, -0.0106, 0.1015],
  [0.9091, -0.0107, 0.1015]
]

T = Matrix[
  [ 5.47813 * (10 ** -5), 0.000184722, 0.000935514, 0.003096265, 0.009507714, 0.017351596, 0.022073595, 0.016353161, 0.002002407, -0.016177731, -0.033929391, -0.046158952, -0.06381706, -0.083911194, -0.091832385, -0.08258148, -0.052950086, -0.012727224, 0.037413037, 0.091701812, 0.147964686, 0.181542886, 0.210684154, 0.210058081, 0.181312094, 0.132064724, 0.093723787, 0.057159281, 0.033469657, 0.018235464, 0.009298756, 0.004023687, 0.002068643, 0.00109484, 0.000454231, 0.000255925 ],
  [ -4.65552 * (10 ** -5), -0.000157894, -0.000806935, -0.002707449, -0.008477628, -0.016058258, -0.02200529, -0.020027434, -0.011137726, 0.003784809, 0.022138944, 0.038965605, 0.063361718, 0.095981626, 0.126280277, 0.148575844, 0.149044804, 0.14239936, 0.122084916, 0.09544734, 0.067421931, 0.035691251, 0.01313278, -0.002384996, -0.009409573, -0.009888983, -0.008379513, -0.005606153, -0.003444663, -0.001921041, -0.000995333, -0.000435322, -0.000224537, -0.000118838, -4.93038 * (10 ** -5), -2.77789 * (10 ** -5) ],
  [ 0.00032594, 0.001107914, 0.005677477, 0.01918448, 0.060978641, 0.121348231, 0.184875618, 0.208804428, 0.197318551, 0.147233899, 0.091819086, 0.046485543, 0.022982618, 0.00665036, -0.005816014, -0.012450334, -0.015524259, -0.016712927, -0.01570093, -0.013647887, -0.011317812, -0.008077223, -0.005863171, -0.003943485, -0.002490472, -0.001440876, -0.000852895, -0.000458929, -0.000248389, -0.000129773, -6.41985 * (10 ** -5), -2.71982 * (10 ** -5), -1.38913 * (10 ** -5), -7.35203 * (10 ** -6), -3.05024 * (10 ** -6), -1.71858 * (10 ** -6) ]
]

mixing_ratios_to_attempt = [
  [1, 1],
  [2, 1],
  [3, 2],
  [3, 1],
  [4, 1]
]

COLORS = []

paints.each_key do |name|
  paint_hex = paints[name]
  red = paint_hex[0, 2].to_i(16)
  green = paint_hex[2, 2].to_i(16)
  blue = paint_hex[4, 2].to_i(16)
  color = Color::RGB.new(red, green, blue)
  COLORS << {
    name: name,
    hex: paint_hex,
    color_rgb: color,
    lab: color.to_lab,
    rgb: {
      red: red / 255.0,
      green: green / 255.0,
      blue: blue / 255.0
    }
  }
end

def nearest_available_color(color_rgb)
  COLORS.sort do |a, b|
    Color::Comparison.distance(color_rgb, a[:color_rgb]) <=> Color::Comparison.distance(color_rgb, b[:color_rgb])
  end.first
end

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
    red: red / 255.0,
    green: green / 255.0,
    blue: blue / 255.0
  }
}
target_color[:lab] = target_color[:color_rgb].to_lab

sorted_colors = COLORS.sort do |a, b|
  Color::Comparison.distance(target_color[:color_rgb], a[:color_rgb]) <=> Color::Comparison.distance(target_color[:color_rgb], b[:color_rgb])
end

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
    [ color[:rgb][:red] ],
    [ color[:rgb][:green] ],
    [ color[:rgb][:blue] ]
  ]
  B12 * rgb
end

def curve_to_rgb(curve)
  (T * curve).to_a.flatten.map { |component| (component * 255).to_i }
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
  end

  matrix_from_one_dimensional_array(inverse_curve_as_a)
end

puts "Nearest colors:"
for i in 0..3
  puts "#{i}: #{
    if sorted_colors[i][:hex] == target_color[:hex]
      "EXACT MATCH - "
    else
      ""
    end
  }##{sorted_colors[i][:hex]} #{sorted_colors[i][:name]}"
end
puts

# Bail out if safe
if sorted_colors[0][:hex] == target_color[:hex]
  puts "Exact matches found"
  exit
elsif Color::Comparison.distance(sorted_colors[0][:color_rgb], target_color[:color_rgb]) < 2.3
  puts "Nearest color is not noticeably different than target color"
  exit
end

puts "Closest mixes:"

nearest_color = sorted_colors[0]

# Mixes
mixed_colors = mixing_ratios_to_attempt.map do |ratio|
  # Get nearest color to perfect complement
  r, g, b = curve_to_rgb(find_inverse_curve(target_color, nearest_color, ratio))
  nearest_mix_color = nearest_available_color(Color::RGB.new(r, g, b))

  # Find ACTUAL mix color
  curves = [
    reflectance_curve_for_color(nearest_color),
    reflectance_curve_for_color(nearest_mix_color)
  ]
  actual_mix = curve_to_rgb(mix_color_curves(curves, ratio))

  {
    actual_mix: actual_mix,
    actual_mix_color_rgb: Color::RGB.new(actual_mix[0], actual_mix[1], actual_mix[2]),
    nearest_mix_color: nearest_mix_color,
    ratio: ratio
  }
end.sort do |a, b|
  Color::Comparison.distance(target_color[:color_rgb], a[:actual_mix_color_rgb]) <=> Color::Comparison.distance(target_color[:color_rgb], b[:actual_mix_color_rgb])
end.each do |mix|
  actual_mix = mix[:actual_mix]
  ratio = mix[:ratio]
  mix_hex = "#{actual_mix[0].to_s(16)}#{actual_mix[1].to_s(16)}#{actual_mix[2].to_s(16)}"

  comparison_description = Color::Comparison.distance(target_color[:color_rgb], mix[:actual_mix_color_rgb])
  if comparison_description < 2.3
    comparison_description = "#{comparison_description} (not noticeably different)"
  end
  puts "D#{comparison_description}: ##{mix_hex} = #{ratio[0].to_i}:#{ratio[1].to_i} #{nearest_color[:name]}:#{mix[:nearest_mix_color][:name]}"
end
