require 'spec_helper'

describe BondCalculations do
  it 'has a version number' do
    expect(BondCalculations::VERSION).not_to be nil
  end

  describe '::Core' do
    describe "with proper input file and proper data" do
      let(:csv_file) { File.expand_path('../../docs/sample_input.csv', __FILE__) }

      let(:bond_term_one) { 5.2 }
      let(:bond_term_two) { 9.0 }

      let(:bond_yield_one) { 5.3 }
      let(:bond_yield_two) { 6.2 }

      let(:gov_bonds) {[
        {:name=>"G2", :term=>2.3, :yield=>2.3},
        {:name=>"G3", :term=>7.8, :yield=>3.3},
        {:name=>"G4", :term=>12.0, :yield=>5.5}
      ]}

      let(:init_floor_index)    { -1 }
      let(:init_ceiling_index)  { 0 }
      let(:init_floor)          { nil }
      let(:init_ceiling)        { nil }

      let(:benchmarks_one) {[
        0, 1,
        {:term=>2.3, :yield=>2.3},
        {:term=>7.8, :yield=>3.3}
      ]}
      let(:benchmarks_two) {[
        1, 2,
        {:term=>7.8, :yield=>3.3},
        {:term=>12.0, :yield=>5.5}
      ]}

      let(:benchmark_selection_one) {
        {:term=>2.6, :spread=>2.0, :index=>1}
      }

      let(:benchmark_selection_two) {
        {:term=>1.2, :spread=>2.9, :index=>1}
      }

      it 'reads csv' do
        result = BondCalculations::Core.csv_data_filter(csv_file)

        expect(result.is_a?(Hash)).to eq(true)
        expect(result[:corporate].is_a?(Array)).to eq(true)
        expect(result[:government].is_a?(Array)).to eq(true)
      end

      it "initializes benchmarks" do
        result = BondCalculations::Core.initialize_benchmarks
        expect(result).to eq([init_floor_index, init_ceiling_index, init_floor, init_ceiling])
      end

      it "updates benchmarks" do
        result_one = BondCalculations::Core.update_benchmarks(
          bond_term_one, gov_bonds, init_floor_index, init_ceiling_index, init_floor, init_ceiling
        )
        result_two = BondCalculations::Core.update_benchmarks(
          bond_term_two, gov_bonds, init_floor_index, init_ceiling_index, init_floor, init_ceiling
        )

        expect(result_one).to eq(benchmarks_one)
        expect(result_two).to eq(benchmarks_two)
      end

      it "selects closest benchmark" do
        floor_index_one, ceiling_index_one, floor_one, ceiling_one = benchmarks_one
        floor_term_one, floor_yield_one     = floor_one[:term], floor_one[:yield]
        ceiling_term_one, ceiling_yield_one = ceiling_one[:term], ceiling_one[:yield]

        floor_index_two, ceiling_index_two, floor_two, ceiling_two = benchmarks_two
        floor_term_two, floor_yield_two     = floor_two[:term], floor_two[:yield]
        ceiling_term_two, ceiling_yield_two = ceiling_two[:term], ceiling_two[:yield]

        result_one = BondCalculations::Core.select_benchmark(
          bond_term_one, bond_yield_one, floor_term_one, floor_yield_one,
          ceiling_term_one, ceiling_yield_one, floor_index_one, ceiling_index_one
        )

        result_two = BondCalculations::Core.select_benchmark(
          bond_term_two, bond_yield_two, floor_term_two, floor_yield_two,
          ceiling_term_two, ceiling_yield_two, floor_index_two, ceiling_index_two
        )

        expect(result_one).to eq(benchmark_selection_one)
        expect(result_two).to eq(benchmark_selection_two)
      end

      it "performs linear interpolation" do
        y0, y1, x, x0, x1 = [6, 7, 8, 9, 10]
        result = BondCalculations::Core.linear_interpolation(y0, y1, x, x0, x1)

        expect(result).to eq(5)
      end

      it "serializes output" do
        output = [
          ['name', 'date', 'awesomeness'],
          ['Aldo', 'today', 'tons']
        ]
        expected = "name,date,awesomeness\nAldo,today,tons\n"

        result = BondCalculations::Core.serialize(output)

        expect(result).to eq(expected)
      end

      it "converts formatted term string to float" do
        result_one = BondCalculations::Core.term_to_float('42.9 years')
        result_two = BondCalculations::Core.term_to_float('1.0 year')

        expect(result_one).to eq(42.9)
        expect(result_two).to eq(1.0)
      end

      it "converts formatted yield string to float" do
        result_one = BondCalculations::Core.yield_to_float('6.40%')
        result_two = BondCalculations::Core.yield_to_float('12.30%')

        expect(result_one).to eq(6.4)
        expect(result_two).to eq(12.3)
      end

      it "converts float to formatted yield string" do
        result_one = BondCalculations::Core.float_to_yield(6.4)
        result_two = BondCalculations::Core.float_to_yield(12.3)

        expect(result_one).to eq('6.40%')
        expect(result_two).to eq('12.30%')
      end

      it 'calculates spread to benchmark' do
        expected_output = "bond,benchmark,spread_to_benchmark\nC1,G1,1.60%\nC2,G2,1.50%\nC3,G3,2.00%\nC4,G3,2.90%\nC5,G4,0.90%\nC6,G5,1.80%\nC7,G6,2.50%\n"

        serialized_output = BondCalculations::Core.yield_spread(csv_file)
        expect(serialized_output).to eq(expected_output)
      end

      it 'calculates spread to curve' do
        expected_output = "bond,spread_to_curve\nC1,1.43%\nC2,1.63%\nC3,2.47%\nC4,2.27%\nC5,1.90%\nC6,1.57%\nC7,2.83%\n"

        serialized_output = BondCalculations::Core.spread_to_curve(csv_file)
        expect(serialized_output).to eq(expected_output)
      end
    end
  end
end
