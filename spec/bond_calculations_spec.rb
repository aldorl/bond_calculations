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

  it 'calculates spread to curve' do
    csv_file = File.expand_path('../../docs/sample_input.csv', __FILE__)
    expected_output = "bond,spread_to_curve\nC1,1.43%\nC2,1.63%\nC3,2.47%\nC4,2.27%\nC5,1.90%\nC6,1.57%\nC7,2.83%\n"
    
    serialized_output = BondCalculations::Core.spread_to_curve(csv_file)
    expect(serialized_output).to eq(expected_output)
  end
end
