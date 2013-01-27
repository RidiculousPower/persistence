
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Port::Bucket::BucketInterface do

  before :each do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    class ::Persistence::Port::Bucket::BucketInterface::Mock
      include ::Persistence::Port::Bucket::BucketInterface
    end

    class ::Persistence::Port::Bucket::BucketInterface::MockClass
      attr_accessor :persistence_port, :persistence_id
      def instance_variable_hash
        persistence_hash = { }
        instance_variables.each do |this_variable|
          persistence_hash[ this_variable ] = instance_variable_get( this_variable )
        end
        return persistence_hash
      end
      alias_method :persistence_hash_to_port, :instance_variable_hash
      def load_persistence_hash( port, persistence_hash )
        self.persistence_port = port
        persistence_hash.each do |this_variable, this_value|
          instance_variable_set( this_variable, this_value )
        end
        return self
      end
      def self.instance_persistence_bucket
        return @bucket ||= ::Persistence::Port::Bucket.new( :mock, self.to_s )
      end
      def persistence_bucket
        return self.class.instance_persistence_bucket
      end
      def self.non_atomic_attribute_readers
        return [ ]
      end
    end

    class ::Persistence::Port::Bucket::BucketInterface::MockHash
      include ::CascadingConfiguration::Hash
      attr_accessor :persistence_port, :persistence_bucket, :persistence_id
      def persistence_hash_to_port
        persistence_hash = { :simple_var => @simple_var }
        return persistence_hash
      end
      def load_persistence_hash( port, persistence_hash )
        self.persistence_port = port
        persistence_hash.each do |this_variable, this_value|
          instance_variable_set( this_variable, this_value )
        end
        return self
      end
    end

    class StringMock < String
      attr_accessor :persistence_id
      def self.instance_persistence_bucket
        return @bucket ||= ::Persistence::Port::Bucket.new( :mock, self.to_s )
      end
      def persistence_bucket
        return self.class.instance_persistence_bucket
      end
      def persistence_hash_to_port
        return { self.class.to_s => self }
      end
    end

    @instance = ::Persistence::Port::Bucket::BucketInterface::Mock.new( :mock, :some_bucket )
    @object = ::Persistence::Port::Bucket::BucketInterface::MockClass.new
  end

  after :each do
    #clear all mocked work, will need to provide a better solution to cleaning specs.
    ::Persistence.disable_port( :mock )
  end

  ################
  #  initialize            #
  ################
  it 'should initialize with a bucket name' do
    @instance.parent_port.should == ::Persistence.port( :mock )
  end

  it "should initialize with an adapter bucket name" do
    @instance.adapter_bucket.name.should == :some_bucket
  end


  #####################
  #  put_object!                   #
  #  count                            #
  #  get_object                    #
  #  get_flat_object             #
  #  delete_object!              #
  #####################

  context "#put_object!" do
    it "should add object to bucket" do
      @instance.put_object!( @object )
      @object.persistence_id.should_not == nil
    end
  end

  context "#count" do
    it "should return the number of object in the bucket" do
      @instance.put_object!( @object )
      @instance.count.should == 1
    end
  end
  
  context "#get_object!" do
    it "should return the specified object from the bucket" do
      @instance.put_object!( @object )
      @instance.get_object( @object.persistence_id ).instance_variable_hash.should == @object.instance_variable_hash
    end
  end

  context "#delete_object!" do
    it "should remove the specified object from the bucket" do
      @instance.delete_object!( @object.persistence_id )
      @instance.get_object( @object.persistence_id ).should == nil
    end
  end

  context "#get_flat_object" do
    it "should return a flat object from the bucket" do
      string_object = StringMock.new( 'some string' )
      @instance.put_object!( string_object )
      @instance.get_flat_object( string_object.persistence_id ).should == string_object
    end
  end

  ###################################
  #  delete_cascades?                                     #
  #  get_attribute                                           #
  #  put_attribute!                                          #
  #  delete_attribute!                                      #
  #  primary_key_for_attribute_name             #
  ###################################

  context "with object_hash" do

    #can serve as an adapter to a persistence bucket @instance in an adapter @instance
    before :each do
      @sub_object = ::Persistence::Port::Bucket::BucketInterface::MockHash.new.instance_eval do
        @simple_var = :value
        self
      end
      @sub_object.persistence_port = ::Persistence.port( :mock )
      @sub_object.persistence_bucket = @instance

      @object_hash = ::Persistence::Port::Bucket::BucketInterface::MockHash.new.instance_eval do
        @simple_var = :some_value
        self
      end
      @object_hash.persistence_port = ::Persistence.port( :mock )
      @object_hash.persistence_bucket = @instance
      @object_hash.persistence_port.persistence_bucket( :some_bucket ).put_object!( @object_hash )
    end

    context "#delete_cascades?" do
      #Prior specs did not test delete_cascades...
      it "is this still relevant to buckets? If so add specs!"
    end

    context "#get_attribute!" do
      it "should return an attribute from the bucket" do
        @instance.get_attribute( @object_hash, :simple_var ).should == :some_value
      end      
    end

    context "#put_attribute!" do
      it  "should put an attribute into the bucket" do
        @instance.put_attribute!( @object_hash, :simple_var, @sub_object )
        @instance.get_attribute( @object_hash, :simple_var ).persistence_hash_to_port.should == @sub_object.persistence_hash_to_port
      end      
    end

    context "#delete_attribute!" do
      it "should remove an attribute from the bucket" do
        @instance.put_attribute!( @object_hash, :simple_var, @sub_object )
        @instance.delete_attribute!( @object_hash, :simple_var )
        @instance.get_attribute( @object_hash, :simple_var ).should == nil
      end
    end

    context "#primary_key_for_attribute_name" do
      it "should return the primary key for an attribute given its name" do
        @instance.primary_key_for_attribute_name( @object_hash, :simple_var ).should == :simple_var
      end
    end
  end

end
