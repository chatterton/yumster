require 'spec_helper'

describe Tip do
  before do
    location = nil
    user = FactoryGirl.create :user do |u|
      location = u.locations.create FactoryGirl.attributes_for(:location)
    end
    @tip = location.tips.create(text: "some text")
  end

  subject { @tip }

  it { should be_valid }

end
