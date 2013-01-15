require 'spec_helper'

describe "locations/show" do

  it 'displays lat, long, and description' do
    location = stub_model Location, :latitude => 40, :longitude => 42, :description => 'fooo'
    assign(:location, location)
    render
    rendered.should =~ /40/
    rendered.should =~ /42/
    rendered.should =~ /fooo/
  end

end
