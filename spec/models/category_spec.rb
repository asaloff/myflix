require 'spec_helper'

describe Category do
  it { should have_many :videos }
  it { should validate_uniqueness_of :title }
end