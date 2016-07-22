# BondCalculations

Welcome to the BondCalculations package, a ruby gem built to perform a series of calculations on bond issues. The two main functions that this gem serves are the following:

* spread_to_benchmark: Given a list of corporate and government bonds in a csv file as input, this finds a benchmark bond for each corporate bond and calculates the spread to benchmark.

* spread_to_curve: Given a list of corporate and government bonds in a csv file as input, this calculates the spread to the interpolated curve based on its closest upper and lower benchmarks.

For a detailed explanation of how the calculations work, please check this [challenge's instructions](docs/instructions.md)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bond_calculations', :git => "git://github.com/aldorl/bond_calculations"
```

And then execute:

    $ bundle

## Usage

1. Include `BondCalculations::Core` in the controller where you desire to perform the calculations

```ruby
class MyController < ApplicationController
    include BondCalculations::Core

    ...
```

2. Call the function you desire along with a csv file as a parameter

```ruby
serialized_spread_to_benchmark  = yield_spread(csv_file)
serialized_spread_to_curve      = spread_to_curve(csv_file)
```

## Development & Testing

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Further information on the gem's creation

### Reasoning behind technical choice (i.e. ruby gem)
Given that the problem presented is meant to be implemented for a production service, it is necessary for the integration of this functionality extension to be really easy to include. A ruby gem is a simple and straightforward answer to this requirement.

### Additional changes for future
To keep the development and testing of this gem simple enough (due to a constraint in time), each function requires a new csv file as an input. However, it would make sense for this gem to allow the user to instantiate it with a csv file. Like this...

```ruby
bonds_instance = BondCalculations::Core.new(csv_file)
serialized_spread_to_benchmark  = bonds_instance.yield_spread
serialized_spread_to_curve      = bonds_instance.spread_to_curve
```

This way the execution time would be reduced, since the parsing of the csv would happen only once. Also, it would be easier for the other attributes and functions to be accessed by the user if this gem's functionalities were to be expanded.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aldorl/bond_calculations. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
