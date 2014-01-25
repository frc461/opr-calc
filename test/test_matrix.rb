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

# Here is where the added functions to the Matrix class are tested.

require "minitest/autorun"
require "opr-calc"

class MatrixTest < Minitest::Test
	def setup
		# Matrix from Wikipedia
		@matrix = Matrix[[  4,  12, -16],
		                 [ 12,  37, -43],
		                 [-16, -43,  98]]
	end

	def test_symmetric_test
		non_symmetric_matrix = Matrix[[3, 5, 3],
		                              [2, 4, 2],
		                              [5, 2, 1]]
		
		assert @matrix.symmetric?
		refute non_symmetric_matrix.symmetric?
	end

	def test_cholesky_decomposition
		expected_decomposition = Matrix[[ 2, 0, 0],
		                                [ 6, 1, 0],
		                                [-8, 5, 3]]

		assert_equal expected_decomposition, @matrix.cholesky_factor
	end
end

# Not tested: output
