require 'spec_helper'

describe 'opr-calc/matrix' do
	it 'can be required without error' do
		expect { require subject }.not_to raise_error
	end
end

require 'opr-calc/matrix'

describe Matrix do
	context 'when symmetric' do
		subject :symmetric_matrix do
			Matrix[[   4,  12, -16 ],
			       [  12,  37, -43 ],
			       [ -16, -43,  98 ]]
		end

		describe '#symmetric?' do
			it 'returns true' do
				expect(symmetric_matrix.symmetric?).to be(true)
			end
		end

		describe '#cholesky_factor' do
			let :expected_cholesky_factorization do
				Matrix[[ 2, 0, 0],
				       [ 6, 1, 0],
				       [-8, 5, 3]]
			end

			it 'returns a Matrix' do
				expect(symmetric_matrix.cholesky_factor).to be_a(Matrix)
			end

			it 'properly calculates the Cholesky factorization' do
				expect(symmetric_matrix.cholesky_factor).to eq(expected_cholesky_factorization)
			end
		end
	end

	context 'when asymmetric' do
		subject :asymmetric_matrix do
			Matrix[[3, 5, 3],
			       [2, 4, 2],
			       [5, 2, 1]]
		end

		describe '#symmetric?' do
			it 'returns false' do
				expect(asymmetric_matrix.symmetric?).to be(false)
			end
		end

		describe '#cholesky_factor' do
			it 'raises an error' do
				expect { asymmetric_matrix.cholesky_factor }.to raise_error(ArgumentError, 'must provide a symmetric matrix')
			end
		end
	end
end
