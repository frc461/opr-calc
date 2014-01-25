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

require "minitest/autorun"
require "opr-calc"

class ScoreSetTest < Minitest::Test
	def setup
		# Team 0 opr: 0
		# Team 1 opr: 1
		# Team 2 opr: 2
		# ...

		# I don't think any team is every playing on both blue and red at the same time, but I might be wrong.

		# 0 1 2 3 4 5 6 7 8 9
		test_ared = Matrix[[1, 0, 1, 0, 1, 0, 0, 0, 0, 0],
		                   [0, 1, 0, 1, 0, 1, 0, 0, 0, 0],
		                   [0, 0, 0, 0, 1, 1, 1, 0, 0, 0],
		                   [0, 0, 0, 0, 0, 0, 0, 1, 1, 1],
		                   [0, 1, 0, 0, 0, 1, 1, 0, 0, 0],
		                   [1, 0, 0, 1, 0, 0, 1, 0, 0, 0]]

		# 0 1 2 3 4 5 6 7 8 9
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

		@score_set = OPRCalc::ScoreSet.new test_ared, test_ablue, test_scorered, test_scoreblue
	end

	def test_opr
		expected_opr = Matrix[[0],
		                      [1],
		                      [2],
		                      [3],
		                      [4],
		                      [5],
		                      [6],
		                      [7],
		                      [8],
		                      [9]]

		assert_equal expected_opr, @score_set.opr.round
	end

	def test_dpr
		@score_set.dpr.each do |cell|
			assert (cell.is_a? Numeric) && cell.finite?
		end
	end

	def test_ccwm
		@score_set.ccwm.each do |cell|
			assert (cell.is_a? Numeric) && cell.finite?
		end
	end

	def test_compare_opr_dpr_ccwm
		assert_equal @score_set.ccwm.round(2), (@score_set.opr - @score_set.dpr).round(2)
	end

	# Ensure that a TypeError will get thrown when an argument to
	# the constructor is not a Matrix.
	def test_constructor_not_matrix
		assert_raises(TypeError) { OPRCalc::ScoreSet.new "this", "will", "raise", "TypeError" }
	end
end
