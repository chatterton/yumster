require 'spec_helper'

describe "locations/show" do

  before do
    @location = stub_model Location, :latitude => 40, :longitude => 42, :description => 'fooo', :category => "Plant"
    assign(:location, @location)
    assign(:tips, [])
    view.stub(:user_signed_in?).and_return(false)
  end

  it 'displays category and description' do
    render
    rendered.should =~ /fooo/
    rendered.should =~ /Plant/
  end

  it 'shows a map' do
    render
    rendered.should have_selector '.map_container #map_canvas'
  end

  context 'when a user is not signed in' do
    it 'shows the add tip form' do
      render
      rendered.should_not have_selector "form[action='#{tips_path}']"
    end
  end
  context 'when a user is signed in' do
    before do
      view.stub(:user_signed_in?).and_return(true)
      user = FactoryGirl.create :user
      view.stub(:current_user).and_return(user)
    end
    it 'shows the add tip form' do
      render
      rendered.should have_selector "form[action='#{tips_path}']"
    end
  end

  context "when there are tips" do
    before do
      tips = []
      tip = FactoryGirl.create :tip
      tip2 = FactoryGirl.create :tip
      tips = [tip, tip2]
      view.stub(:current_user).and_return false
      assign(:tips, tips)
    end
    it "renders _tip partial for each" do
      render
      expect(view).to render_template(:partial => "_tip", :count => 2)
    end
  end

end
