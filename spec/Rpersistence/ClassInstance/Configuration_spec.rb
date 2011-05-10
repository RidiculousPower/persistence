require_relative '../../../lib/rpersistence.rb'

describe Rpersistence::ClassInstance::Configuration do

  ##############################
  #  Klass.persistence_bucket  #
  #  persistence_bucket        #
  ##############################

  it "can set and get its persistence bucket" do
    class Rpersistence::ClassInstance::Configuration::Mock01
    end
    Rpersistence::ClassInstance::Configuration::Mock01.persistence_bucket.should == Class.to_s
    Rpersistence::ClassInstance::Configuration::Mock01.persistence_bucket = 'another bucket'
    Rpersistence::ClassInstance::Configuration::Mock01.persistence_bucket.should == 'another bucket'
  end

  #######################################
  #  Klass.instance_persistence_bucket  #
  #  instance_persistence_bucket        #
  #######################################

  it "can set and get a persistence bucket to be used for instances" do
    class Rpersistence::ClassInstance::Configuration::Mock02
    end
    Rpersistence::ClassInstance::Configuration::Mock02.instance_persistence_bucket.should == Rpersistence::ClassInstance::Configuration::Mock02.to_s
    Rpersistence::ClassInstance::Configuration::Mock02.instance_persistence_bucket = 'another bucket'
    Rpersistence::ClassInstance::Configuration::Mock02.instance_persistence_bucket.should == 'another bucket'
  end
  
end
