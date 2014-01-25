opr-calc
========

[![Gem Version](https://badge.fury.io/rb/opr-calc.png)](http://badge.fury.io/rb/opr-calc)

A rubygem for calculating the OPR, DPR, and CCWM of FRC teams.

Usage
-----

Define a new ScoreSet with `ScoreSet.new`. This takes four matrices: `ared`, `ablue`, `scorered`, and `scoreblue`. 
The `a` matrices define what teams are in what matches. 
The `score` matrices define what the final match scores are.
For example, consider the following match.
The first, third, and fifth team are on the red alliance, which scores 26.
The zeroth, second, and fourth team are on the blue alliance, which scores 56.
This would result in the following rows the various matrices.

`ared`: `[0, 1, 0, 1, 0, 1]`

`scorered`: `[26]`

`ablue`: `[1, 0, 1, 0, 1, 0]`

`scoreblue`: `[56]`

For another example, see the function `test_stuff` in `lib/opr-calc.rb`.
