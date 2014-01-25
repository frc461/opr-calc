require "matrix"

# Props to http://rosettacode.org/wiki/Cholesky_decomposition#Ruby :L
class Matrix
	# Returns whether or not the Matrix is symmetric (http://en.wikipedia.org/wiki/Symmetric_matrix).
	def symmetric?
		# Matrices can't be symmetric if they're not square.
		return false unless square?

		(0...row_size).each do |i|
			(0..i).each do |j|
				return false if self[i,j] != self[j,i]
			end
		end

		true
	end

	def cholesky_factor
		# We need a symmetric matrix for Cholesky.
		raise ArgumentError, "You must provide a symmetric matrix." unless symmetric?

		# Make a new matrix to return.
		l = Array.new(row_size) { Array.new(row_size, 0) }

		(0...row_size).each do |k|
			(0...row_size).each do |i|
				if i == k
					sum = (0..k-1).inject(0.0) { |sum, j| sum + l[k][j] ** 2 }
					val = Math.sqrt(self[k,k] - sum)
					l[k][k] = val
				elsif i > k
					sum = (0..k-1).inject(0.0) { |sum, j| sum + l[i][j] * l[k][j] }
					val = (self[k,i] - sum) / l[k][k]
					l[i][k] = val
				end
			end
		end

		Matrix[*l]
	end

	# A helpful debug function for Matrices.
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
