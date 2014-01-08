#!/usr/bin/env ruby

require 'matrix'

# props to http://rosettacode.org/wiki/Cholesky_decomposition#Ruby :L

class Matrix
	def symmetric?
		return false if not square?
		(0...row_size).each do |i|
			(0..i).each do |j|
				return false if self[i,j] != self[j,i]
			end
		end
		true
	end

	def cholesky_factor
		raise ArgumentError, "must provide symmetric matrix" unless symmetric?

		l = Array.new(row_size) {Array.new(row_size, 0)}

		(0...row_size).each do |k|
			(0...row_size).each do |i|
				if i == k
					sum = (0..k-1).inject(0.0) {|sum, j| sum + l[k][j] ** 2}
					val = Math.sqrt(self[k,k] - sum)
					l[k][k] = val
				elsif i > k
					sum = (0..k-1).inject(0.0) {|sum, j| sum + l[i][j] * l[k][j]}
					val = (self[k,i] - sum) / l[k][k]
					l[i][k] = val
				end
			end
		end
		Matrix[*l]
	end

	def output
		(0..self.row_size - 1).each do |row_number|
			(0..self.column_size - 1).each do |column_number|
				printf("%8.4f ", self[row_number, column_number])
			end
			printf("\n")
		end
	end
end

original = Matrix[[ 25, 15, -5],
                  [ 15, 18,  0],
                  [ -5,  0, 11]]

l = original.cholesky_factor

lt = l.t

puts "Original"
original.output

puts "L"
l.output
puts "L^T"
lt.output

puts "Original (from teh other stuffies)"
(l * lt).output

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
