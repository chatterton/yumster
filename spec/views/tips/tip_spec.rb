require 'spec_helper'

def render_partial(tip)
  render :partial => "/tips/tip", :locals => { :tip => tip }
end

describe "tips/_tip" do

  before do
    @tip = stub_model Tip, :text => 'yackety'
    view.stub(:user_signed_in?).and_return(false)
    @current_user = stub_model User
    @other_user = stub_model User
    @tip.stub(:user).and_return(@other_user)
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
      @tip.stub(:user).and_return(@current_user)
      @current_user.tips.stub(:find_by_id).and_return(@tip)
      render_partial(@tip)
    end
    it "should show a delete button" do
      rendered.should have_selector "form[action='#{tip_path(@tip)}']"
    end
  end

end
