require 'spec_helper'

describe "admin/locations.html.erb" do

  before do
    @location1 = stub_model Location,
      :latitude => 40,
      :longitude => 42,
      :description => 'fooood',
      :category => "Plant"
    @location2 = stub_model Location,
      :latitude => 40,
      :longitude => 42,
      :description => 'doooof',
      :category => "Plant"
    assign :locations, [@location1, @location2]
  end

  it "should display the locations" do
    render
    rendered.should =~ /fooood/
    rendered.should =~ /doooof/
  end

  it "should allow approval of each location" do
    render
    rendered.should have_link "approve", :href => approve_location_path(@location1)
    rendered.should have_link "approve", :href => approve_location_path(@location2)
  end


end
