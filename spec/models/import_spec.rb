require 'spec_helper'

describe Import do

  before do
    @import = Import.new(credit_line: "cl", name: "nm", import_type: "it")
    @record1 = FactoryGirl.create :record
    @import.records << @record1
    @record2 = @import.records.build(data_key: "built")
    @import.save
  end

  it 'should retain the proper values' do
    import = Import.find :last
    import.credit_line.should == "cl"
    import.name.should == "nm"
    import.import_type.should == "it"
    import.records.count.should == 2
    import.records.should include @record1
    import.records.should include @record2
  end

end
