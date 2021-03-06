# Coding Challenge

Here are two exercises that will give us some insight into your coding and problem solving abilities. 

## Challenge #1

Calculate the yield spread (return) between a corporate bond and its government bond benchmark. 

A government bond is a good benchmark if it is as close as possible to the corporate bond in terms of years to maturity (term).

### Sample input

| bond   | type       | term        | yield |
|--------|------------|-------------|-------|
| C1     | corporate  | 10.3 years  | 5.30% |
| G1     | government | 9.4 years   | 3.70% |
| G2     | government | 12 years    | 4.80% |

### Sample output

```
bond,benchmark,spread_to_benchmark
C1,G1,1.60%
```

To explain, the best candidate for a benchmark for C1 (corporate bond) is the G1 (government bond) since their difference in term is only 0.9 years vs G2 that is 1.7 years away. Hence, the `spread_to_benchmark` for C1 is C1.yield - G1.yield = 1.60%.

Given a list of corporate and government bonds, find a benchmark bond for each corporate bond and calculate the spread to benchmark.

## Challenge #2

The next challenge is calculate the spread to the government bond curve.

Since the corporate bond term is not exactly the same as its benchmark term, we need to use linear interpolation to dermine the spread to the curve.

### Sample input

| bond   | type       | term        | yield |
|--------|------------|-------------|-------|
| C1     | corporate  | 10.3 years  | 5.30% |
| C2     | corporate  | 15.2 years  | 8.30% |
| G1     | government | 9.4 years   | 3.70% |
| G2     | government | 12 years    | 4.80% |
| G3     | government | 16.3 years  | 5.50% |

### Sample output

```
bond,spread_to_curve
C1,1.22%
C2,2.23%
```

Image below (attached) will help you visualize how to calcualte spread to curve. The formula is:

```
C1.spread_to_curve = A - B
C2.spread_to_curve = X - Y
```

Where `A = C1.yield = 5.30%` and `X = C2.yield = 8.30%`. Values of C and Z require linear interpolation to determine. We leave this as an exercise to the challenger.

## Technical spec

Use any language with which you are most comfortable. Overbond is a Rails shop, so if you can write the solution in Ruby, great! But it's not required.

No UI is necessary. You can read and write the output to standard in/out.

Please organize, design, test and document your code as if it were going into production. Write your README as if it was for a production service and include the following items:

* Reasoning behind your technical choices
* Trade-offs you might have made or what you might do differently if you were to spend additional time on the project

## How we review

The aspects of your code we will judge include:

* Functionality: Does the application do what was asked?
* Code quality: Is the code simple and easy to understand?
* Testing: Are there automated tests? Will they be difficult to change if the requirements of the application were to change?
* Technical choices: Do choices of libraries, frameworks, etc. seem appropriate for the chosen application?