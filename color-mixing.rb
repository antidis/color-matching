require 'matrix'

class ColorMixing

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

  def self.matrix_from_one_dimensional_array(array)
    Matrix.build(array.size, 1) { |row, col| array[row] }
  end

  def self.curve_to_rgb(curve)
    (T * curve).to_a.flatten.map do |component|
      value = component.real? ? component : component.real
      [(value * 255).to_i, 255].min
    end
  end

  def self.reflectance_curve_for_color(color)
    rgb = Matrix[
      [ color[:rgb][:red] / 255.0 ],
      [ color[:rgb][:green] / 255.0 ],
      [ color[:rgb][:blue] / 255.0 ]
    ]
    B12 * rgb
  end

  def self.mix_color_curves(curves, weights)
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
    self.matrix_from_one_dimensional_array(stepper_curve)
  end

  def self.find_inverse_curve(target_color, other_color, mixing_ratios)
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

    self.matrix_from_one_dimensional_array(inverse_curve_as_a)
  end

  def self.mix_colors(colors, ratio)
    curves = colors.map { |color| self.reflectance_curve_for_color(color) }
    self.curve_to_rgb(self.mix_color_curves(curves, ratio))
  end


end
