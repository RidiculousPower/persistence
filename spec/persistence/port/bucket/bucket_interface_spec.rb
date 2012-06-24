
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Port::Bucket::BucketInterface do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  ################
  #  initialize  #
  ################
  
  it 'can initialize with an adapter and bucket name' do
    class ::Persistence::Port::Bucket::BucketInterface::Mock
      include ::Persistence::Port::Bucket::BucketInterface
    end
    instance_two = ::Persistence::Port::Bucket::BucketInterface::Mock.new( :mock, :some_bucket )
    instance_two.parent_port.should == ::Persistence.port( :mock )
    instance_two.adapter_bucket.name.should == :some_bucket
  end

  #####################
  #  put_object!      #
  #  count            #
  #  get_object       #
  #  get_flat_object  #
  #  delete_object!   #
  #####################

  it 'can serve as an adapter to a persistence bucket instance in an adapter instance' do
    module ::Persistence::Port::Bucket::BucketInterface::PutGetDeleteObjectMock
    
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
      instance = ::Persistence::Port::Bucket::BucketInterface::Mock.new( :mock, :some_bucket )
      object = ::Persistence::Port::Bucket::BucketInterface::MockClass.new
      instance.put_object!( object )
      object.persistence_id.should_not == nil
      instance.count.should == 1
      instance.get_object( object.persistence_id ).instance_variable_hash.should == object.instance_variable_hash
      instance.delete_object!( object.persistence_id )
      instance.get_object( object.persistence_id ).should == nil
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
      string_object = StringMock.new( 'some string' )
      instance.put_object!( string_object )
      instance.get_flat_object( string_object.persistence_id ).should == string_object
      instance.delete_object!( string_object.persistence_id )
    
    end
  end

  ###################################
  #  delete_cascades?               #
  #  get_attribute                   #
  #  put_attribute!                  #
  #  delete_attribute!               #
  #  primary_key_for_attribute_name  #
  ###################################
  
  it 'can serve as an adapter to a persistence bucket instance in an adapter instance' do
    class ::Persistence::Port::Bucket::BucketInterface::Mock
      include ::Persistence::Port::Bucket::BucketInterface
    end
    class ::Persistence::Port::Bucket::BucketInterface::MockClass
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
    instance = ::Persistence::Port::Bucket::BucketInterface::Mock.new( :mock, :some_bucket )
    sub_object = ::Persistence::Port::Bucket::BucketInterface::MockClass.new.instance_eval do
      @simple_var = :value
      self
    end
    sub_object.persistence_port = ::Persistence.port( :mock )
    sub_object.persistence_bucket = instance
    object = ::Persistence::Port::Bucket::BucketInterface::MockClass.new.instance_eval do
      @simple_var = :some_value
      self
    end
    object.persistence_port = ::Persistence.port( :mock )
    object.persistence_bucket = instance
    object.persistence_port.persistence_bucket( :some_bucket ).put_object!( object )
    object.persistence_id.should_not == nil
    instance.get_attribute( object, :simple_var ).should == :some_value
    instance.put_attribute!( object, :simple_var, sub_object )
    instance.get_attribute( object, :simple_var ).persistence_hash_to_port.should == sub_object.persistence_hash_to_port
    instance.delete_attribute!( object, :simple_var )
    instance.get_attribute( object, :simple_var ).should == nil
    instance.primary_key_for_attribute_name( object, :simple_var ).should == :simple_var
  end
  
end
