
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Attributes::Flat do

  ####################
  #  attr_flat       #
  #  persists_flat?  #
  #  attr_flat!      #
  ####################
  
  it 'can force storing a attribute as a flat object' do
    class ::Persistence::Object::Complex::Attributes::Flat::Mock01
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Flat
    end
    ::Persistence::Object::Complex::Attributes::Flat::Mock01.new.instance_eval do
      persists_flat?( :some_attribute ).should == nil
      attr_flat :some_attribute
      persists_flat?( :some_attribute ).should == true
      non_atomic_attributes[ :some_other_attribute ] = :accessor
      non_atomic_attributes[ :another_attribute ] = :accessor
      attr_flat!
      persists_flat?( :some_attribute ).should == true
      persists_flat?( :some_other_attribute ).should == true
      persists_flat?( :another_attribute ).should == true
    end
  end
    
end
