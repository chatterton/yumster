require 'spec_helper'

describe ApplicationHelper do

  describe "on_front_page?" do
    before do
      params[:controller] = 'pages'
      params[:action] = 'home'
    end
    context "when on front page" do
      it "returns true" do
        helper.on_front_page?.should be_true
      end
    end
    context "when controller is not pages" do
      it "returns false" do
        params[:controller] = 'whatever'
        helper.on_front_page?.should_not be_true
      end
    end
    context "when the action is not home" do
      it "returns false" do
        params[:action] = 'whatever'
        helper.on_front_page?.should_not be_true
      end
    end
  end

  describe "gravatar_for(user)" do
    before do
      helper.stub(:forem_avatar).and_return "gravatar here"
    end
    context "user is null" do
      it "returns nothing" do
        check = helper.gravatar_for(nil)
        check.should be_nil
      end
    end
    context "when there is a user" do
      it "uses forem's gravatar output" do
        check = helper.gravatar_for "whatever"
        check.should =~ /gravatar here/
      end
      it "wraps it in a gravatar_for_container span" do
        check = helper.gravatar_for "whatever"
        check.should have_selector "span.user_icon_container"
      end
    end
  end

end
