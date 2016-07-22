# BondCalculations

Welcome to the BondCalculations package, a ruby gem built to perform a series of calculations on bond issues. The two main functions that this gem serves are the following:

* spread_to_benchmark: Given a list of corporate and government bonds in a csv file as input, this finds a benchmark bond for each corporate bond and calculates the spread to benchmark.

* spread_to_curve: Given a list of corporate and government bonds in a csv file as input, this calculates the spread to the interpolated curve based on its closest upper and lower benchmarks.


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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aldorl/bond_calculations. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
