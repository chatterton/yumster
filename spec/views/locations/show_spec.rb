require 'spec_helper'

describe "locations/show" do

  before do
    @location = stub_model Location,
      :latitude => 40,
      :longitude => 42,
      :description => 'fooo',
      :category => "Plant"
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

  it 'links to directions on google' do
    render
    rendered.should have_link "", :href => 'https://maps.google.com/maps?daddr=40.0,42.0'
  end

  context 'when there is an address' do
    before do
      @location.stub(:address).and_return('somewheresville, UT')
    end
    it 'shows the address' do
      render
      rendered.should =~ /somewheresville/
    end
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

  context 'when there are no tips' do
    it 'does not show any mention of tips' do
      render
      rendered.should_not =~ / tip/
    end
  end
  context "when there are tips" do
    before do
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
    it 'shows and pluralizes tip count' do
      render
      rendered.should =~ /2 tips/
    end
  end

  describe "when the location is not approved" do
    it "shows a warning" do
      @location.approved = false
      render
      rendered.should =~ /was submitted anonymously/
    end
  end
  describe "when the location is approved" do
    it "does not show the warning" do
      @location.approved = true
      render
      rendered.should_not =~ /was submitted anonymously/
    end
  end

  describe "link back to search results" do
    before do
      @uri = {}
      view.stub(:http_referer_uri).and_return @uri
    end
    context "when the page was refered from a search" do
      before do
        @uri.stub(:request_uri).and_return "earl"
        view.stub(:refered_from_a_search?).and_return true
      end
      it "displays the link" do
        render
        rendered.should =~ /earl/
      end
    end
    context "when there is no referer" do
      before do
        view.stub(:http_referer_uri).and_return nil
        view.stub(:refered_from_a_search?).and_return true
      end
      it "does not display the link" do
        render
        rendered.should_not =~ /earl/
      end
    end
    context "when the referer is not a search" do
      before do
        view.stub(:http_referer_uri).and_return "earl"
        view.stub(:refered_from_a_search?).and_return false
      end
      it "does not display the link" do
        render
        rendered.should_not =~ /earl/
      end
    end
  end

  describe 'notes' do
    context 'when the notes are user-generated' do
      it 'sanitizes them' do
        @location.notes = "<a href=>some notes yo"
        render
        rendered.should =~ /Notes:/
        rendered.should =~ /&lt;a href=&gt;some notes yo/
      end
    end
    context 'when the notes are imported' do
      before do
        @import = stub_model Import, :credit_line => 'checkline'
        @record = stub_model Record, :import => @import
        @location.record = @record
      end
      it 'displays them as html' do
        @location.notes = '<a href="">checkit</a>'
        render
        rendered.should =~ /Notes:/
        rendered.should =~ /<a href="">checkit<\/a>/
      end
      it 'displays the credit line after the notes' do
        @location.notes = 'checknotes'
        render
        rendered.should =~ /checknotes checkline/
      end
    end
  end

end
