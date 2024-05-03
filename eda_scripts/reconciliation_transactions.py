 """
    Find the closest pair of numbers in a list that sum up to a target value for transaction discprency 
    between postgres data and bank export data

    Args:
        numbers (list): A list of floating point numbers.
        target (float): The target sum value.

    Returns:
      The closest pair of numbers and their sum.
    """

    def find_closest_pair(numbers, target):

        closest_sum = float('inf')
        pair = None

        for i in range(len(numbers)):
            for j in range(i + 1, len(numbers)):
                current_sum = numbers[i] + numbers[j]
                if abs(target - current_sum) < abs(target - closest_sum):
                    closest_sum = current_sum
                    pair = (numbers[i], numbers[j])

        return pair, closest_sum


    numbers = [
        992.820, 983.420, 965.280, 952.880, 949.110, 942.060, 931.430, 913.750, 912.410, 909.380,
        907.910, 906.220, 857.490, 841.000, 840.980, 824.990, 822.850, 818.650, 814.980, 795.440,
        788.850, 788.640, 775.760, 767.120, 765.920, 757.800, 750.930, 723.570, 723.030, 705.410,
        698.930, 693.600, 681.320, 658.540, 656.070, 655.140, 635.250, 631.170, 619.770, 613.590,
        604.770, 588.810, 583.260, 568.220, 563.050, 561.220, 559.870, 541.910, 541.260, 533.640,
        524.490, 523.510, 509.820, 506.420, 502.830, 492.050, 487.510, 479.480, 475.840, 466.340,
        462.670, 459.600, 443.520, 438.850, 438.560, 435.680, 418.580, 409.470, 406.300, 395.970,
        383.080, 372.890, 368.650, 357.780, 349.730, 344.040, 338.480, 322.200, 318.880, 316.530,
        311.530, 309.450, 309.070, 305.280, 302.430, 296.690, 293.470, 278.990, 277.320, 276.300,
        269.660, 239.120, 219.760, 206.100, 204.150, 203.950, 195.120, 181.600, 177.910, 162.990,
        160.700, 155.630, 152.270, 123.310, 68.210, 62.190, 57.780, 47.660, 44.090, 40.170
    ]

    target = 1006.22

    pair, closest_sum = find_closest_pair(numbers, target)

    print("Closest pair:", pair)
    print("Sum:", closest_sum)