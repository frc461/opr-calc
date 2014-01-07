#!/usr/bin/env ruby

require 'matrix'

=begin
base matrix equation: [A][OPR] = [SCORE]

define [A]^t to be [A] transpose

define [P] to be [A][A]^t

define [S] to be [SCORE][A]^t

equation is now [P][OPR] = [S]

refactor [P] as [L][L]^t using cholesky

Therefore [L][L]^t[OPR] = [S]

define [Y] = [L]^t[OPR]

equation is now [L][Y] = [S]

find [Y] through forward substitution

find [OPR] through backward substitution
=end
