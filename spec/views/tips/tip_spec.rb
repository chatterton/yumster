require 'spec_helper'

def render_partial(tip)
  render :partial => "/tips/tip", :locals => { :tip => tip }
end

describe "tips/_tip" do

  before do
    @tip = stub_model Tip, :text => 'yackety'
    view.stub(:user_signed_in?).and_return(false)
  end

  it 'should show the text' do
    render_partial(@tip)
    rendered.should =~ /yackety/
  end

end
