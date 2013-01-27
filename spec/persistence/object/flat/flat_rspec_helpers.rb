
shared_examples "a flat object with Persistence" do
  before :each do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :each do
    object.cease! #would be better if mock memory was dumped
    ::Persistence.disable_port( :mock )
  end

  context "#class" do
    it "should be a Persistence Flat Object" do
      object.should be_kind_of(::Persistence::Object::Flat)
    end
  end

  context "#persist!" do
    it "should persist with persistence_id" do
      object.persist!
      object.persistence_id.should_not == nil
    end
  end

  context "#persist" do
    it "should return the object" do
      object.persist!
      object.class.persist( object.persistence_id ).should == object
    end

    it "should return the first object given argument 0" do
      object.persist!
      object.class.persist( 0 ).should == object
    end
  end

  context "#cease!" do
    it "should delete the object" do
      object.persist!
      object.cease!
      object.class.persist( object.persistence_id ).should == nil
    end
  end

  context "#persist?" do
    it "should not return true if there is no persisted object" do
      begin
        object.class.persisted?( object ).should == false  
      rescue ArgumentError => e
        p "'should not return true if there is no persisted object.' Passed by ArgumentError, did not return true: #{e}"
      end
    end

    it "should return the true given at least one persisted object and argument 0" do
      object.persist!
      object.class.persisted?( 0 ).should == true
    end

    it "should return true if the object has been persisted" do
      object.persist!
      object.class.persisted?( object.persistence_id ).should == true    
    end

    it "should not return true if the object has been ceased" do
      object.persist!
      persistence_id = object.persistence_id
      object.cease!
      object.class.persist( persistence_id ).should == nil
    end
  end

  context "with index key" do
    it "should persist!" do
      object.persist!( :explicit_index => storage_key )
      object.persistence_id.should_not == nil
    end

    it "should persist" do
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
