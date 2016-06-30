require 'spec_helper'

describe 'opr-calc/score_set' do
	it 'can be required without error' do
		expect { require subject }.not_to raise_error
	end
end

require 'opr-calc/score_set'
require 'opr-calc/matrix'

describe OPRCalc::ScoreSet do
	context 'taking 4 valid arguments' do
		let :ared do
			Matrix[[1, 0, 1, 0, 1, 0, 0, 0, 0, 0],
			       [0, 1, 0, 1, 0, 1, 0, 0, 0, 0],
			       [0, 0, 0, 0, 1, 1, 1, 0, 0, 0],
			       [0, 0, 0, 0, 0, 0, 0, 1, 1, 1],
			       [0, 1, 0, 0, 0, 1, 1, 0, 0, 0],
			       [1, 0, 0, 1, 0, 0, 1, 0, 0, 0]]
		end

		let :ablue do
			Matrix[[0, 0, 1, 0, 0, 0, 0, 1, 0, 1],
			       [1, 0, 0, 0, 1, 0, 0, 0, 1, 0],
			       [1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
			       [0, 0, 1, 0, 0, 1, 1, 0, 0, 0],
			       [0, 0, 0, 1, 0, 0, 0, 0, 1, 1],
			       [0, 1, 0, 0, 1, 0, 0, 1, 0, 0]]
		end

		let :scorered do
			Matrix[[6],
			       [9],
			       [15],
			       [24],
			       [12],
			       [9]]
		end

		let :scoreblue do
			Matrix[[18],
			       [12],
			       [3],
			       [13],
			       [20],
			       [12]]
		end

		subject do
			OPRCalc::ScoreSet.new ared, ablue, scorered, scoreblue
		end

		describe '#opr' do
			let :expected do
				Matrix[[0],
				       [1],
				       [2],
				       [3],
				       [4],
				       [5],
				       [6],
				       [7],
				       [8],
				       [9]]
			end

			it 'produces a fully Numeric OPR vector that is finite' do
				subject.opr.each do |cell|
					expect(cell).to be_a(Numeric)
					expect(cell).to be_finite
				end
			end

			it 'produces the expected OPR' do
				expect(subject.opr.round).to eq(expected)
			end
		end

		describe '#dpr' do
			it 'produces a fully Numeric DPR vector that is finite' do
				subject.dpr.each do |cell|
					expect(cell).to be_a(Numeric)
					expect(cell).to be_finite
				end
			end
		end

		describe '#ccwm' do
			it 'produces a fully Numeric CCWM vector that is finite' do
				subject.ccwm.each do |cell|
					expect(cell).to be_a(Numeric)
					expect(cell).to be_finite
				end
			end

			it 'produces the correct OPR-DPR values' do
				expect(subject.ccwm.round(2)).to eq((subject.opr - subject.dpr).round(2))
			end
		end
	end
end
