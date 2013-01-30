describe "locations/near" do

  before do
    assign(:g4r_options, {})
  end

  it 'shows a map' do
    render
    rendered.should have_selector '.map_container #map'
  end

end
