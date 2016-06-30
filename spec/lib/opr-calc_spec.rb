require 'spec_helper'

describe 'opr-calc' do
	it 'can be required without error' do
		expect { require subject }.not_to raise_error
	end
end
