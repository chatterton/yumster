require 'spec_helper'

describe LocationsHelper do

  describe 'determine referrer URI' do
    context 'when referrer is valid' do
      before do
        @request.env["HTTP_REFERER"] = "http://slashdot.org"
        @uri = helper.http_referer_uri
      end
      it 'returns a ruby uri object' do
        assert(@uri.respond_to?(:path))
        assert(@uri.respond_to?(:host))
      end
      it 'returns the correct uri' do
        @uri.host.should == 'slashdot.org'
      end
    end
    context 'when there is no referer' do
      before do
        @request.env["HTTP_REFERER"] = nil
        @uri = helper.http_referer_uri
      end
      it 'returns false' do
        assert !@uri
      end 
    end
  end

  describe 'determine whether we were refered from a search' do
    before do
      helper.stub(:refered_from_our_site?).and_return true
    end
    context "when locations/near is on the path" do
      before do
        uri = {}
        uri.stub(:path).and_return "/locations/near?whatever"
        helper.stub(:http_referer_uri).and_return uri
      end
      it "returns true" do
        assert(helper.refered_from_a_search?)
      end
    end
    context "when something random is on the path" do
      before do
        uri = {}
        uri.stub(:path).and_return "/locatns/nr?whater"
        helper.stub(:http_referer_uri).and_return uri
      end
      it "returns true" do
        assert(!helper.refered_from_a_search?)
      end
    end
  end

end
