require 'spec_helper'

def render_partial(tip)
  render :partial => "/tips/tip", :locals => { :tip => tip }
end

describe "tips/_tip" do

  before do
    view.stub(:user_signed_in?).and_return(false)
    @current_user = stub_model User, :username => "wacky_earl"
    @other_user = stub_model User, :username => "big_fredd"
    @tip = stub_model Tip, :text => 'yackety', :user => @other_user, :created_at => Time.now()
    view.stub(:current_user).and_return(@current_user)
  end

  it 'should show the text' do
    render_partial(@tip)
    rendered.should =~ /yackety/
  end

  it 'should add linebreaks to the text' do
    @tip.text = "yackety\nschmackety"
    render_partial(@tip)
    rendered.should =~ /yackety<br>schmackety/
  end

  context "when the user created the tip" do
    before do
      @tip2 = stub_model Tip, :user => @current_user, :created_at => Time.now()
      render_partial(@tip2)
    end
    it "should show a delete button" do
      rendered.should have_selector "form[action='#{tip_path(@tip2)}']"
    end
  end

  it "should show the creator's username" do
    render_partial(@tip)
    rendered.should =~ /big_fredd/
  end

end
