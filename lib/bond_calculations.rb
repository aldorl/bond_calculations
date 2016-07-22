require "bond_calculations/version"
require "csv"

module BondCalculations::Core
  TERM_REGEX    = /([0-9.]+)\syear[s]?/
  YIELD_REGEX   = /([0-9.]+)%/
  YIELD_FORMAT  = '%.2f'

  FLOOR_INIT_INDEX    = -1
  CEILING_INIT_INDEX  = 0

  def self.yield_spread(csv_input)
    bonds = csv_data_filter(csv_input)

    floor_index, ceiling_index, floor, ceiling = initialize_benchmarks
    output = [['bond', 'benchmark', 'spread_to_benchmark']]

    # Iterates through each corporate bond and calculates the spread against
    # the closet benchmark based on maturity
    bonds[:corporate].each_with_index do |bond, index|
      floor_index, ceiling_index, floor, ceiling = update_benchmarks(
        bond[:term], bonds[:government], floor_index, ceiling_index, floor, ceiling
      )

      benchmark = select_benchmark(
        bond[:term], bond[:yield], floor[:term], floor[:yield],
        ceiling[:term], ceiling[:yield], floor_index, ceiling_index
      )

      output << [bond[:name], bonds[:government][benchmark[:index]][:name], float_to_yield(benchmark[:spread])]
    end

    serialize(output)
  end

  def self.spread_to_curve(csv_input)
    bonds = csv_data_filter(csv_input)

    floor_index, ceiling_index, ceiling, floor = initialize_benchmarks
    output  = [['bond', 'spread_to_curve']]

    # Iterates through each corporate bond and calculates the spread against
    # the closet benchmark based on maturity
    bonds[:corporate].each_with_index do |bond, index|
      floor_index, ceiling_index, floor, ceiling = update_benchmarks(
        bond[:term], bonds[:government], floor_index, ceiling_index, floor, ceiling
      )

      curve_yield   = linear_interpolation(floor[:yield], ceiling[:yield], bond[:term], floor[:term], ceiling[:term])
      curve_spread  = (bond[:yield] - curve_yield).round(2)
      output       << [bond[:name], float_to_yield(curve_spread)]
    end

    serialize(output)
  end

  private

  # Parses CSV and separates corporate and government bonds
  def self.csv_data_filter(csv_input)
    bonds = {:corporate => [], :government => []}
    CSV.foreach(csv_input, {:headers => true, :header_converters => :symbol}) do |row|
      bond_type = row[:type].to_sym
      bond_data = {
                    :name => row[:bond],
                    :term => term_to_float(row[:term]),
                    :yield => yield_to_float(row[:yield])
                  }
      bonds[bond_type] << bond_data
    end
    bonds
  end

  # Initializes floor and ceiling benchmarks for target corporate bonds
  def self.initialize_benchmarks
    # floor_index, ceiling_index, floor, ceiling
    [FLOOR_INIT_INDEX, CEILING_INIT_INDEX, nil, nil]
  end

  # Checks current floor and ceiling benchmarks and shifts them if necessary
  def self.update_benchmarks(bond_term, gov_bonds, floor_index, ceiling_index, floor, ceiling)
    while (floor == nil || bond_term > ceiling[:term])
      floor_index   += 1
      ceiling_index += 1

      floor   = {
        :term   => gov_bonds[floor_index][:term],
        :yield  => gov_bonds[floor_index][:yield]
      }
      ceiling = {
        :term   => gov_bonds[ceiling_index][:term],
        :yield  => gov_bonds[ceiling_index][:yield]
      }
    end
    [floor_index, ceiling_index, floor, ceiling]
  end

  # Selects the benchmark that is closest to the target bond
  # i.e. lowest absolute difference between terms
  def self.select_benchmark(bond_term, bond_yield, floor_term, floor_yield,
    ceiling_term, ceiling_yield, floor_index, ceiling_index)

    # Compares floor and ceiling benchmarks against current target bond
    floor_diff = {
      :term   => (bond_term - floor_term).abs.round(2),
      :spread => (bond_yield - floor_yield).abs.round(2),
      :index  => floor_index
    }
    ceiling_diff = {
      :term   => (bond_term - ceiling_term).abs.round(2),
      :spread => (bond_yield - ceiling_yield).abs.round(2),
      :index  => ceiling_index
    }

    floor_diff[:term] >= ceiling_diff[:term] ? ceiling_diff : floor_diff
  end

  # Formula for linerar interpolation
  def self.linear_interpolation(y0, y1, x, x0, x1)
    y0 + (y1 - y0)*((x-x0) / (x1-x0))
  end

  # Serializes and returns output
  def self.serialize(output)
    output.each_with_object('') { |line, result| result << "#{line.join(',')}\n" }
  end

  def self.term_to_float(term_string)
    term_string.downcase.match(TERM_REGEX)[1].to_f
  end

  def self.yield_to_float(yield_string)
    yield_string.match(YIELD_REGEX)[1].to_f
  end

  def self.float_to_yield(float)
    "#{format(YIELD_FORMAT, float)}%"
  end
end
