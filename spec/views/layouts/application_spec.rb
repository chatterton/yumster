require 'spec_helper'

describe 'layouts/application' do
  before do
    view.stub(:user_signed_in?).and_return(false)
  end
  it "should show the container" do
    render
    rendered.should have_selector "div.container"
  end
end
