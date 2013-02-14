require 'spec_helper'

describe ApplicationHelper do

  describe "on_front_page?" do
    before do
      params[:controller] = 'pages'
      params[:action] = 'home'
    end
    context "when on front page" do
      it "returns true" do
        on_front_page?.should be_true
      end
    end
    context "when controller is not pages" do
      it "returns false" do
        params[:controller] = 'whatever'
        on_front_page?.should_not be_true
      end
    end
    context "when the action is not home" do
      it "returns false" do
        params[:action] = 'whatever'
        on_front_page?.should_not be_true
      end
    end
  end

end
