require 'spec_helper'

describe BondCalculations do
  it 'has a version number' do
    expect(BondCalculations::VERSION).not_to be nil
  end

  it 'calculates spread to benchmark' do
    csv_file = File.expand_path('../../docs/sample_input.csv', __FILE__)
    expected_output = "bond,benchmark,spread_to_benchmark\nC1,G1,1.60%\nC2,G2,1.50%\nC3,G3,2.00%\nC4,G3,2.90%\nC5,G4,0.90%\nC6,G5,1.80%\nC7,G6,2.50%\n"

    serialized_output = BondCalculations::Core.yield_spread(csv_file)
    expect(serialized_output).to eq(expected_output)
  end
end
