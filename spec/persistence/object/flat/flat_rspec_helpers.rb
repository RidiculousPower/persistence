
shared_examples "a flat object with Persistence" do
  before :each do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :each do
    ::Persistence.disable_port( :mock )
  end

  context "#class" do
    it "should be a Persistence Flat Object" do
      object.should be_kind_of(::Persistence::Object::Flat)
    end
  end

  context "#persist!" do
    it "should persist without error" do
      object.persist!
    end
  end

  context "#persist" do
    it "should return the object" do
      object.persist!
      object.class.persist( object.persistence_id ).should == object
    end
  end

  context "#cease!" do
    it "should delete the object" do
      object.persist!
      object.cease!
      object.class.persist( object.persistence_id ).should == nil
    end
  end

  context "with index key" do
    it "should persist! and persist" do
      object.persist!( :explicit_index => storage_key )
      object.class.persist( :explicit_index => storage_key ).should == object
    end

    it "should cease!" do
      object.persist!( :explicit_index => storage_key )
      object.class.cease!( :explicit_index => storage_key )
      object.class.persist( :explicit_index => storage_key ).should == nil
    end
  end

end
