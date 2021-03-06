=begin
	opr-calc is a tool for calculating OPR and other scouting stats for FRC teams.
	Copyright (C) 2014 Kristofer Rye and Christopher Cooper

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
=end

module OPRCalc
	class ScoreSet
		attr_reader :ared, :ablue, :scorered, :scoreblue

		def ared=(value)
			@ared = value
			@opr_recalc = @dpr_recalc = @ccwm_recalc = true
		end

		def ablue=(value)
			@ablue = value
			@opr_recalc = @dpr_recalc = @ccwm_recalc = true
		end

		def scorered=(value)
			@scorered = value
			@opr_recalc = @dpr_recalc = @ccwm_recalc = true
		end

		def scoreblue=(value)
			@scoreblue = value
			@opr_recalc = @dpr_recalc = @ccwm_recalc = true
		end

		def initialize(ared, ablue, scorered, scoreblue)
			raise TypeError, 'ared must be a Matrix' unless ared.is_a? Matrix
			raise TypeError, 'ablue must be a Matrix' unless ablue.is_a? Matrix
			raise TypeError, 'scorered must be a Matrix' unless scorered.is_a? Matrix
			raise TypeError, 'scoreblue must be a Matrix' unless scoreblue.is_a? Matrix

			@ared = ared
			@ablue = ablue
			@scorered = scorered
			@scoreblue = scoreblue
		end

		# A generic function for smooshing two matrices (one red, one blue).
		# Each should have the same dimensions.
		def alliance_smooshey(redmatrix, bluematrix)
			throw ArgumentError 'Matrices must have same dimensions' unless
				(redmatrix.row_size == bluematrix.row_size) &&
				(redmatrix.column_size == bluematrix.column_size)

			# Then we just pull the column and row size
			# from the red matrix because we can.
			column_count = redmatrix.column_size
			row_count = redmatrix.row_size

			# Use a block function to generate the new matrix.
			matrix = Matrix.build(row_count * 2, column_count) do
				|row, column|

				# note: no need to alternate, instead put all red, then all blue.
				if row < row_count 	# first half = red
					redmatrix[row, column]
				else                # second half = blue
					bluematrix[row - row_count, column]
				end
			end

			# This will end up looking like as follows:
			# [[red[0]],
			#  [red[1]],
			#  [red[2]],
			#  ...
			#  [red[n]],
			#  [blue[0]],
			#  [blue[1]],
			#  [blue[2]],
			#  ...
			#  [blue[n]]]
			return matrix
		end

		private :alliance_smooshey

		# Solve equation of form [l][x] = [s] for [x]
		# l must be a lower triangular matrix.
		# Based off of algorithm given at
		# `http://en.wikipedia.org/wiki/Triangular_matrix#Forward_and_back_substitution`.
		def forward_substitute(l, s)
			raise 'l must be a lower triangular matrix' unless l.lower_triangular?

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
			raise 'u must be an upper triangular matrix' unless u.upper_triangular?

			x = Array.new s.row_size

			(x.size - 1).downto 0 do |i|
				x[i] = s[i, 0]

				(i + 1).upto(x.size - 1) do |j|
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

		# Offensive power rating: the average amount of points that a team
		# contributes to their alliance's score.
		#
		# This is high for a good team.
		def opr(recalc = false)
			if !@opr || recalc || @opr_recalc
				a = alliance_smooshey @ared, @ablue
				score = alliance_smooshey @scorered, @scoreblue

				@opr = opr_calculate a, score
				@opr_recalc = false
			end

			@opr
		end

		# Defensive power rating: the average amount of points that a team lets
		# the other alliance score.
		#
		# This is low for a good team.
		def dpr(recalc = false)
			if !@dpr || recalc || @dpr_recalc
				a = alliance_smooshey @ared, @ablue

				# scoreblue and scorered are intentionally
				# swapped; that's how dpr works.
				score = alliance_smooshey @scoreblue, @scorered

				@dpr = opr_calculate a, score
				@dpr_recalc = false
			end

			@dpr
		end

		# Calculated contribution to winning margin: the average amount of
		# points that a team contributes to their alliance's winning margin.
		#
		# This value is high for a good team.
		def ccwm(recalc = false)
			if !@ccwm || recalc || @ccwm_recalc
				a = alliance_smooshey @ared, @ablue

				red_wm = Matrix.build(@scorered.row_size, @scorered.column_size) do |row, column|
					@scorered[row, column] - @scoreblue[row, column]
				end

				blue_wm = Matrix.build(@scoreblue.row_size, @scoreblue.column_size) do |row, column|
					@scoreblue[row, column] - @scorered[row, column]
				end

				score = alliance_smooshey red_wm, blue_wm

				@ccwm = opr_calculate a, score
				@ccwm_recalc = false
			end

			@ccwm
		end
	end
end
