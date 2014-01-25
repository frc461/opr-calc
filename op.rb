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
					l[i][k] = val.nan? ? 0 : val
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
		self
	end
end



class ScoreSet
=begin
 base matrix equation: [A][OPR] = [SCORE]
 define [A]^t to be [A] transpose
 define [P] to be [A]^t[A]
 define [S] to be [A]^t[SCORE]
 equation is now [P][OPR] = [S]
 refactor [P] as [L][L]^t using cholesky
 [L] is a lower triangular matrix and [L]^t an upper
 Therefore [L][L]^t[OPR] = [S]
 define [Y] = [L]^t[OPR]
 equation is now [L][Y] = [S]
 find [Y] through forward substitution
 find [OPR] through back substitution
=end

	attr_accessor :ared
	attr_accessor :ablue
	attr_accessor :scorered
	attr_accessor :scoreblue

	def initialize(ared, ablue, scorered, scoreblue)
		@ared = ared
		@ablue = ablue
		@scorered = scorered
		@scoreblue = scoreblue
	end

	def alliance_smooshey(redmatrix, bluematrix)
		throw ArgumentError "Matrices must have same dimensions" unless (redmatrix.row_size == bluematrix.row_size) && (redmatrix.column_size == bluematrix.column_size)

		# puts "Both should have #{redmatrix.row_size} rows and #{redmatrix.column_size} columns"

		column_count = redmatrix.column_size
		row_count = redmatrix.row_size

		Matrix.build(row_count * 2, column_count) do
			|row, column|

			# note: no need to alternate, instead put all red, then all blue
			if row < row_count
				redmatrix[row, column]
			else 
				bluematrix[row - row_count, column]
			end
		end
	end

	private :alliance_smooshey

	# Solve equation of form [l][x] = [s] for [x]
	# l must be a lower triangular matrix.
	# Based off of algorithm given at http://en.wikipedia.org/wiki/Triangular_matrix#Forward_and_back_substitution
	def forward_substitute(l, s)
		raise "l must be a lower triangular matrix" unless l.lower_triangular?

		x = Array.new s.row_size

		x.size.times do |i|
			x[i] = s[i, 0]
			i.times do |j|
				x[i] -= l[i, j] * x[j]
			end
			x[i] /= l[i, i]
		end

		Matrix.column_vector x
	end

	# Solve equation of form [u][x] = [s] for [x]
	# u must be a upper triangular matrix.
	def back_substitute(u, s)
		raise "u must be an upper triangular matrix" unless u.upper_triangular?

		x = Array.new s.row_size

		(x.size - 1).downto 0 do |i|
			x[i] = s[i, 0]
			(i + 1).upto (x.size - 1) do |j|
				x[i] -= u[i, j] * x[j]
			end
			x[i] /= u[i, i]
		end

		Matrix.column_vector x
	end

	private :forward_substitute, :back_substitute

	def opr_calculate(a, score)
		p = a.t * a
		s = a.t * score

		l = p.cholesky_factor

		# l.output
		# l.t.output

		y = forward_substitute l, s
		back_substitute l.t, y
	end

	def opr(recalc = false)
		if !@opr || recalc
			a = alliance_smooshey @ared, @ablue
			score = alliance_smooshey @scorered, @scoreblue
			
			@opr = opr_calculate a, score
		else
			@opr
		end
	end

	def dpr(recalc = false)
		if !@dpr || recalc
			a = alliance_smooshey @ared, @ablue
			score = alliance_smooshey @scoreblue, @scorered # intentionally swapped, that's how dpr works
			
			@dpr = opr_calculate a, score
		else
			@dpr
		end
	end

	def ccwm(recalc = false)
		if !@ccwm || recalc
			a = alliance_smooshey @ared, @ablue
			
			red_wm = Matrix.build(@scorered.row_size, @scorered.column_size) do |row, column|
				@scorered[row, column] - @scoreblue[row, column]
			end
			blue_wm = Matrix.build(@scoreblue.row_size, @scoreblue.column_size) do |row, column|
				@scoreblue[row, column] - @scorered[row, column]
			end

			score = alliance_smooshey red_wm, blue_wm

			@ccwm = opr_calculate a, score
		else
			@ccwm
		end
	end

end


def test_stuff
	# Team 0 opr: 0
	# Team 1 opr: 1
	# Team 2 opr: 2
	# ...

	# I don't think any team is every playing on both blue and red at the same time, but I might be wrong

	#                   0  1  2  3  4  5  6  7  8  9
	test_ared = Matrix[[1, 0, 1, 0, 1, 0, 0, 0, 0, 0],
	                   [0, 1, 0, 1, 0, 1, 0, 0, 0, 0],
	                   [0, 0, 0, 0, 1, 1, 1, 0, 0, 0],
	                   [0, 0, 0, 0, 0, 0, 0, 1, 1, 1],
	                   [0, 1, 0, 0, 0, 1, 1, 0, 0, 0],
	                   [1, 0, 0, 1, 0, 0, 1, 0, 0, 0]]

	#                    0  1  2  3  4  5  6  7  8  9
	test_ablue = Matrix[[0, 0, 1, 0, 0, 0, 0, 1, 0, 1],
	                    [1, 0, 0, 0, 1, 0, 0, 0, 1, 0],
	                    [1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
	                    [0, 0, 1, 0, 0, 1, 1, 0, 0, 0],
	                    [0, 0, 0, 1, 0, 0, 0, 0, 1, 1],
	                    [0, 1, 0, 0, 1, 0, 0, 1, 0, 0]]

	test_scorered = Matrix[[6],
	                       [9],
	                       [15],
	                       [24],
	                       [12],
	                       [9]]

	test_scoreblue = Matrix[[18],
	                        [12],
	                        [3],
	                        [13],
	                        [20],
	                        [12]]

	test_expectedopr = Matrix[[0],
	                          [1],
	                          [2],
	                          [3],
	                          [4],
	                          [5],
	                          [6],
	                          [7],
	                          [8],
	                          [9]]

	test = ScoreSet.new test_ared, test_ablue, test_scorered, test_scoreblue

	puts "Expected OPR:"
	test_expectedopr.output
	puts "Actual OPR:"
	test.opr.output
	
	puts "DPR:"
	test.dpr.output
	
	puts "CCWM:"
	test.ccwm.output
	puts "CCWM by OPR - DPR:"
	(test.opr - test.dpr).output
end
