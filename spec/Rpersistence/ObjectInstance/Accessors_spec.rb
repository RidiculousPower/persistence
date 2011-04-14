require_relative '../../../lib/rpersistence.rb'

describe Rpersistence::ObjectInstance::Accessors do

  #########################
  #  Klass.attr_accessor  #
  #  attr_accessor        #
  #########################
  
  it "will declare attribute accessors as atomic accessors if declare_atomic_by_default?" do
    class Rpersistence::ObjectInstance::Accessors::Mock01
      attr_accessor :attribute1
    end
    Rpersistence::ObjectInstance::Accessors::Mock01.atomic_attribute?( :attribute1 ).should == false
    class Rpersistence::ObjectInstance::Accessors::Mock01
      persists_atomic_by_default!
      attr_accessor :attribute1
    end
    Rpersistence::ObjectInstance::Accessors::Mock01.atomic_attribute?( :attribute1 ).should == true    
    Rpersistence::ObjectInstance::Accessors::Mock01.atomic_attribute_accessor?( :attribute1 ).should == true
    Rpersistence::ObjectInstance::Accessors::Mock01.atomic_attribute_writer?( :attribute1 ).should == true
    Rpersistence::ObjectInstance::Accessors::Mock01.atomic_attribute_reader?( :attribute1 ).should == true
  end
  
  #######################
  #  Klass.attr_reader  #
  #  attr_reader        #
  #######################

  it "will declare attribute readers as atomic readers if declare_atomic_by_default?" do
    class Rpersistence::ObjectInstance::Accessors::Mock02
      attr_reader :attribute1
    end
    Rpersistence::ObjectInstance::Accessors::Mock02.atomic_attribute?( :attribute1 ).should == false
    class Rpersistence::ObjectInstance::Accessors::Mock02
      persists_atomic_by_default!
      attr_reader :attribute1
    end
    Rpersistence::ObjectInstance::Accessors::Mock02.atomic_attribute?( :attribute1 ).should == true    
    Rpersistence::ObjectInstance::Accessors::Mock02.atomic_attribute_accessor?( :attribute1 ).should == false
    Rpersistence::ObjectInstance::Accessors::Mock02.atomic_attribute_writer?( :attribute1 ).should == false
    Rpersistence::ObjectInstance::Accessors::Mock02.atomic_attribute_reader?( :attribute1 ).should == true
  end

  #######################
  #  Klass.attr_writer  #
  #  attr_writer        #
  #######################

  it "will declare attribute writers as atomic writers if declare_atomic_by_default?" do
    class Rpersistence::ObjectInstance::Accessors::Mock03
      attr_reader :attribute1
    end
    Rpersistence::ObjectInstance::Accessors::Mock03.atomic_attribute?( :attribute1 ).should == false
    class Rpersistence::ObjectInstance::Accessors::Mock03
      persists_atomic_by_default!
      attr_writer :attribute1
    end
    Rpersistence::ObjectInstance::Accessors::Mock03.atomic_attribute?( :attribute1 ).should == true
    Rpersistence::ObjectInstance::Accessors::Mock03.atomic_attribute_accessor?( :attribute1 ).should == false
    Rpersistence::ObjectInstance::Accessors::Mock03.atomic_attribute_writer?( :attribute1 ).should == true
    Rpersistence::ObjectInstance::Accessors::Mock03.atomic_attribute_reader?( :attribute1 ).should == false
  end
  
end
