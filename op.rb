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
		raise ArgumentError, "You must provide symmetric matrix" unless symmetric?

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

# original = Matrix[[ 25, 15, -5],
#                   [ 15, 18,  0],
#                   [ -5,  0, 11]]

# l = original.cholesky_factor

# lt = l.t

# puts "Original"
# original.output

# puts "L"
# l.output
# puts "L^T"
# lt.output

# puts "Original (from teh other stuffies)"
# (l * lt).output

=begin
base matrix equation: [A][OPR] = [SCORE]
define [A]^t to be [A] transpose
define [P] to be [A]^t[A]
define [S] to be [A]^t[SCORE]
equation is now [P][OPR] = [S]
refactor [P] as [L][L]^t using cholesky
[L] is a lower triangular matrix
Therefore [L][L]^t[OPR] = [S]
define [Y] = [L]^t[OPR]
equation is now [L][Y] = [S]
find [Y] through forward substitution
find [OPR] through backward substitution
=end

def alliance_smooshey(redmatrix, bluematrix)
	throw ArgumentError "Matrices must have same dimensions" unless (redmatrix.row_size == bluematrix.row_size) && (redmatrix.column_size == bluematrix.column_size)

	puts "Both should have #{redmatrix.row_size} rows and #{redmatrix.column_size} columns"

	column_count = redmatrix.column_size
	row_count = redmatrix.row_size

	matrix = []

	Matrix.build(row_count * 2, column_count) {
		|row, column|

		if row % 2 == 0 # we're going to add red row (red-first)
			redmatrix[row / 2, column]
		elsif row % 2 == 1 # we're going to add blue row (blue-second)
			bluematrix[row / 2, column]
		end
	}
end

def opr_calculate(ared, ablue, scorered, scoreblue)
end

test_redmatrix = Matrix[[0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                        [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                        [1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

test_bluematrix = Matrix[[0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

test_redscores = Matrix[[11],
                        [13],
                        [17],
                        [19],
                        [23]]

test_bluescores = Matrix[[11],
                         [13],
                         [17],
                         [19],
                         [23]]

alliance_smooshey(test_redmatrix, test_bluematrix).output
alliance_smooshey(test_redscores, test_bluescores).output
