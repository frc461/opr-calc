#!/usr/bin/env ruby

require 'matrix'

# Props to http://rosettacode.org/wiki/Cholesky_decomposition#Ruby :L
class Matrix
	# Returns whether or not the Matrix is symmetric (http://en.wikipedia.org/wiki/Symmetric_matrix)
	def symmetric?

		# Matrices can't be symmetric if they're not square.
		return false if not square?

		(0...row_size).each do |i|
			(0..i).each do |j|
				return false if self[i,j] != self[j,i]
			end
		end

		true
	end

	def cholesky_factor
		# We need a symmetric matrix for Cholesky.
		raise ArgumentError, "You must provide symmetric matrix" unless symmetric?

		# Make a new matrix to return
		l = Array.new(row_size) { Array.new(row_size, 0) }

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

	# A helpful debug function for Matrices
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

# A generic function for smooshing two matrices (one red, one blue).
# Each should have the same dimensions.
def alliance_smooshey(redmatrix, bluematrix)
	throw ArgumentError "Matrices must have same dimensions" unless (redmatrix.row_size == bluematrix.row_size) && (redmatrix.column_size == bluematrix.column_size)

	# Then we just pull the column and row size from the red matrix because we can.
	column_count = redmatrix.column_size
	row_count = redmatrix.row_size

	# Our output matrix
	matrix = []

	# Use a block function to generate the new matrix
	matrix = Matrix.build(row_count * 2, column_count) {
		|row, column|

		# If the current row number is even, add red row (red-first)
		if row % 2 == 0
			redmatrix[row / 2, column]

		# If the current row number is odd, add blue row (blue-second)
		elsif row % 2 == 1
			bluematrix[row / 2, column]
		end
	}

	# This will end up looking like as follows:

	# [[red[0]],
	#  [blue[0]],
	#  [red[1]],
	#  [blue[1]],
	#  [red[2]],
	#  [blue[2]],
	#  ...]
	return matrix
end

def opr_calculate(ared, ablue, scorered, scoreblue)
end

test_redmatrix = Matrix[[0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                        [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                        [1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

test_bluematrix = Matrix[[0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

test_redscores = Matrix[[10],
                        [18],
                        [22]]

test_bluescores = Matrix[[11],
                         [19],
                         [23]]

alliance_smooshey(test_redmatrix, test_bluematrix).output
alliance_smooshey(test_redscores, test_bluescores).output
