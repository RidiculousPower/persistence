require_relative '../../../lib/rpersistence.rb'

describe Rpersistence::ClassInstance::Configuration do

  ##############################

  ##############################

  it 'can set and get its persistence bucket' do
    class Rpersistence::ClassInstance::Configuration::Mock01
    end
    Rpersistence::ClassInstance::Configuration::Mock01.persistence_bucket.should == Class.to_s
    Rpersistence::ClassInstance::Configuration::Mock01.persistence_bucket = 'another bucket'
    Rpersistence::ClassInstance::Configuration::Mock01.persistence_bucket.should == 'another bucket'
  end

  #######################################

  #######################################

  it 'can set and get a persistence bucket to be used for instances' do
    class Rpersistence::ClassInstance::Configuration::Mock02
    end
    Rpersistence::ClassInstance::Configuration::Mock02.instance_persistence_bucket.should == Rpersistence::ClassInstance::Configuration::Mock02.to_s
    Rpersistence::ClassInstance::Configuration::Mock02.instance_persistence_bucket = 'another bucket'
    Rpersistence::ClassInstance::Configuration::Mock02.instance_persistence_bucket.should == 'another bucket'
  end

  ######################################
  #  Klass.attr_index          #
  #  Klass.has_index?          #
  #  Klass.index_permits_duplicates?   #
  #  Klass.delete_index        #
  ######################################
  
  it 'can declare an index on an attribute (unique or with duplicates) as well as report whether an index exists and if it support duplicates' do
    module Rpersistence::ClassInstance::Configuration
      # override cursor
      def create_index_for_existing_objects_on_attribute( attribute )( klass, attribute )
        # no testing of this here
    	end
    end
    Rpersistence.enable_port( :mock, Rpersistence::Adapter::Mock.new )
    class Rpersistence::ObjectInstance::Configuration::Mock04
      attr_index :indexed_attribute
      attr_index_with_duplicates :indexed_attribute_with_duplicates
    end
    Rpersistence::ObjectInstance::Configuration::Mock04.indexes.include?( :indexed_attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock04.indexes.include?( :indexed_attribute_with_duplicates ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock04.unique_indexes.include?( :indexed_attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock04.unique_indexes.include?( :indexed_attribute_with_duplicates ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock04.indexes_with_duplicates.include?( :indexed_attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock04.indexes_with_duplicates.include?( :indexed_attribute_with_duplicates ).should == true
    # adapter should report index exists
    Rpersistence::ObjectInstance::Configuration::Mock04.has_index?( :indexed_attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock04.has_index?( :indexed_attribute_with_duplicates ).should == true
    # adapter should report index is unique
    Rpersistence::ObjectInstance::Configuration::Mock04.index_permits_duplicates?( :indexed_attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock04.index_permits_duplicates?( :indexed_attribute_with_duplicates ).should == true
    # instance - inheritance
    instance = Rpersistence::ObjectInstance::Configuration::Mock04.new
    instance.class.indexes.include?( :indexed_attribute ).should == true
    instance.class.indexes.include?( :indexed_attribute_with_duplicates ).should == true
    instance.class.unique_indexes.include?( :indexed_attribute ).should == true
    instance.class.unique_indexes.include?( :indexed_attribute_with_duplicates ).should == false
    instance.class.indexes_with_duplicates.include?( :indexed_attribute ).should == false
    instance.class.indexes_with_duplicates.include?( :indexed_attribute_with_duplicates ).should == true
    instance.class.has_index?( :indexed_attribute ).should == true
    instance.class.has_index?( :indexed_attribute_with_duplicates ).should == true
    instance.class.index_permits_duplicates?( :indexed_attribute ).should == false
    instance.class.index_permits_duplicates?( :indexed_attribute_with_duplicates ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock04.delete_index( :indexed_attribute_with_duplicates )
    Rpersistence::ObjectInstance::Configuration::Mock04.indexes.include?( :indexed_attribute_with_duplicates ).should == false
  end
  
end
