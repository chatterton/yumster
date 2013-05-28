require 'spec_helper'

describe Record do

  before do
    @import = FactoryGirl.create :import
    @record = @import.records.build(data_key: "dk")
    @location = FactoryGirl.create :location
    @record.location = @location
    @record.save
  end

  it 'should retain the proper values' do
    rec = Record.find :last
    rec.location.id.should == @location.id
    rec.import.id.should == @import.id
    rec.data_key.should == "dk"
  end

end
