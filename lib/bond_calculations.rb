require "bond_calculations/version"
require "csv"

module BondCalculations::Core
  TERM_REGEX    = /([0-9.]+)\syear[s]?/
  YIELD_REGEX   = /([0-9.]+)%/
  YIELD_FORMAT  = '%.2f'

  def self.yield_spread(csv_input)
    bonds = {:corporate => [], :government => []}

    # Parses CSV and separates corporate and government bonds
    CSV.foreach(csv_input, {:headers => true, :header_converters => :symbol}) do |row|
      bond_type = row[:type].to_sym
      bond_data = {
                    :name => row[:bond],
                    :term => term_to_float(row[:term]),
                    :yield => yield_to_float(row[:yield])
                  }
      bonds[bond_type] << bond_data
    end

    # Initializes floor and ceiling benchmarks for target corporate bonds
    # as well as return output array
    floor_index   = -1
    ceiling_index = 0

    ceiling = floor = nil

    output  = [['bond', 'benchmark', 'spread_to_benchmark']]

    # Iterates through each corporate bond and calculates the spread against
    # the closet benchmark based on maturity
    bonds[:corporate].each_with_index do |bond, index|

      # Checks current floor and ceiling benchmarks and shifts them if necessary
      while (floor == nil || bond[:term] > ceiling[:term])
        floor_index += 1
        ceiling_index += 1

        floor   = {
          :term => bonds[:government][floor_index][:term],
          :yield => bonds[:government][floor_index][:yield]
        }
        ceiling = {
          :term => bonds[:government][ceiling_index][:term],
          :yield => bonds[:government][ceiling_index][:yield]
        }
      end

      # Compares floor and ceiling benchmarks against current target bond
      floor_diff = {
        :term => (bond[:term] - floor[:term]).abs.round(2),
        :spread => (bond[:yield] - floor[:yield]).abs.round(2),
        :index => floor_index
      }
      ceiling_diff = {
        :term => (bond[:term] - ceiling[:term]).abs.round(2),
        :spread => (bond[:yield] - ceiling[:yield]).abs.round(2),
        :index => ceiling_index
      }

      # Selects the benchmark that is closest to the target bond
      # i.e. lowest absolute difference between terms
      benchmark = floor_diff[:term] >= ceiling_diff[:term] ? ceiling_diff : floor_diff
      output << [bond[:name], bonds[:government][benchmark[:index]][:name], float_to_yield(benchmark[:spread])]
    end

    # Serializes and returns output
    output.each_with_object('') do |line, serialized|
      serialized << "#{line.join(',')}\n"
    end
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
