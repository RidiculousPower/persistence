
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Attributes do

  #######################
  #  atomic_attributes  #
  #######################

  it 'can declare atomic attribute readers, writers, accessors, and automatically update corresponding declarations' do
    class ::Persistence::Object::Complex::Attributes::AtomicAttributesMock

      include ::Persistence::Object::Complex

      atomic_attributes.empty?.should == true

      # reader
      atomic_attributes.add( :some_reader, :reader )
      atomic_attributes[ :some_reader ].should == :reader
      persistent_attributes[ :some_reader ].should == :reader
      atomic_attribute_readers.include?( :some_reader ).should == true
      atomic_attribute_writers.include?( :some_reader ).should == false
      atomic_attribute_accessors.include?( :some_reader ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_reader ).should == false
      non_atomic_attribute_writers.include?( :some_reader ).should == false
      non_atomic_attribute_accessors.include?( :some_reader ).should == false

      atomic_attributes[ :some_other_reader ] = :reader
      atomic_attributes[ :some_other_reader ].should == :reader
      persistent_attributes[ :some_other_reader ].should == :reader
      atomic_attribute_readers.include?( :some_other_reader ).should == true
      atomic_attribute_writers.include?( :some_other_reader ).should == false
      atomic_attribute_accessors.include?( :some_other_reader ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_other_reader ).should == false
      non_atomic_attribute_writers.include?( :some_other_reader ).should == false
      non_atomic_attribute_accessors.include?( :some_other_reader ).should == false
      
      atomic_attributes.add( :some_reader, :writer )
      atomic_attributes[ :some_reader ].should == :accessor
      persistent_attributes[ :some_reader ].should == :accessor
      atomic_attribute_readers.include?( :some_reader ).should == true
      atomic_attribute_writers.include?( :some_reader ).should == true
      atomic_attribute_accessors.include?( :some_reader ).should == true
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_reader ).should == false
      non_atomic_attribute_writers.include?( :some_reader ).should == false
      non_atomic_attribute_accessors.include?( :some_reader ).should == false

      atomic_attributes.subtract( :some_reader, :writer )
      atomic_attributes[ :some_reader ].should == :reader
      persistent_attributes[ :some_reader ].should == :reader
      atomic_attribute_readers.include?( :some_reader ).should == true
      atomic_attribute_writers.include?( :some_reader ).should == false
      atomic_attribute_accessors.include?( :some_reader ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_reader ).should == false
      non_atomic_attribute_writers.include?( :some_reader ).should == false
      non_atomic_attribute_accessors.include?( :some_reader ).should == false
      
      # writer
      atomic_attributes.add( :some_writer, :writer )
      atomic_attributes[ :some_writer ].should == :writer
      persistent_attributes[ :some_writer ].should == :writer
      atomic_attribute_readers.include?( :some_writer ).should == false
      atomic_attribute_writers.include?( :some_writer ).should == true
      atomic_attribute_accessors.include?( :some_writer ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_writer ).should == false
      non_atomic_attribute_writers.include?( :some_writer ).should == false
      non_atomic_attribute_accessors.include?( :some_writer ).should == false

      atomic_attributes[ :some_other_writer ] = :writer
      atomic_attributes[ :some_other_writer ].should == :writer
      persistent_attributes[ :some_other_writer ].should == :writer
      atomic_attribute_readers.include?( :some_other_writer ).should == false
      atomic_attribute_writers.include?( :some_other_writer ).should == true
      atomic_attribute_accessors.include?( :some_other_writer ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_other_writer ).should == false
      non_atomic_attribute_writers.include?( :some_other_writer ).should == false
      non_atomic_attribute_accessors.include?( :some_other_writer ).should == false
      
      atomic_attributes.add( :some_writer, :reader )
      atomic_attributes[ :some_writer ].should == :accessor
      persistent_attributes[ :some_writer ].should == :accessor
      atomic_attribute_readers.include?( :some_writer ).should == true
      atomic_attribute_writers.include?( :some_writer ).should == true
      atomic_attribute_accessors.include?( :some_writer ).should == true
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_writer ).should == false
      non_atomic_attribute_writers.include?( :some_writer ).should == false
      non_atomic_attribute_accessors.include?( :some_writer ).should == false
      
      atomic_attributes.subtract( :some_writer, :reader )
      atomic_attributes[ :some_writer ].should == :writer
      persistent_attributes[ :some_writer ].should == :writer
      atomic_attribute_readers.include?( :some_writer ).should == false
      atomic_attribute_writers.include?( :some_writer ).should == true
      atomic_attribute_accessors.include?( :some_writer ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_writer ).should == false
      non_atomic_attribute_writers.include?( :some_writer ).should == false
      non_atomic_attribute_accessors.include?( :some_writer ).should == false
      
      # accessor
      atomic_attributes.add( :some_accessor, :accessor )
      atomic_attributes[ :some_accessor ].should == :accessor
      persistent_attributes[ :some_accessor ].should == :accessor
      atomic_attribute_readers.include?( :some_accessor ).should == true
      atomic_attribute_writers.include?( :some_accessor ).should == true
      atomic_attribute_accessors.include?( :some_accessor ).should == true
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_accessor ).should == false
      non_atomic_attribute_writers.include?( :some_accessor ).should == false
      non_atomic_attribute_accessors.include?( :some_accessor ).should == false

      atomic_attributes[ :some_other_accessor ] = :accessor
      atomic_attributes[ :some_other_accessor ].should == :accessor
      persistent_attributes[ :some_other_accessor ].should == :accessor
      atomic_attribute_readers.include?( :some_other_accessor ).should == true
      atomic_attribute_writers.include?( :some_other_accessor ).should == true
      atomic_attribute_accessors.include?( :some_other_accessor ).should == true
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_other_accessor ).should == false
      non_atomic_attribute_writers.include?( :some_other_accessor ).should == false
      non_atomic_attribute_accessors.include?( :some_other_accessor ).should == false

      atomic_attributes.subtract( :some_other_accessor, :accessor )
      atomic_attribute_readers.include?( :some_other_accessor ).should == false
      atomic_attribute_writers.include?( :some_other_accessor ).should == false
      atomic_attribute_accessors.include?( :some_other_accessor ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_other_accessor ).should == false
      non_atomic_attribute_writers.include?( :some_other_accessor ).should == false
      non_atomic_attribute_accessors.include?( :some_other_accessor ).should == false
      
      # nil
      atomic_attributes[ :some_accessor ] = nil
      atomic_attribute_readers.include?( :some_accessor ).should == false
      atomic_attribute_writers.include?( :some_accessor ).should == false
      atomic_attribute_accessors.include?( :some_accessor ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_accessor ).should == false
      non_atomic_attribute_writers.include?( :some_accessor ).should == false
      non_atomic_attribute_accessors.include?( :some_accessor ).should == false
      
    end
  end

  ###########################
  #  non_atomic_attributes  #
  ###########################

  it 'can declare non-atomic attribute readers, writers, accessors, and automatically update corresponding declarations' do
    class ::Persistence::Object::Complex::Attributes::NonAtomicAttributesMock

      include ::Persistence::Object::Complex

      non_atomic_attributes.empty?.should == true

      # reader
      non_atomic_attributes.add( :some_reader, :reader )
      non_atomic_attributes[ :some_reader ].should == :reader
      persistent_attributes[ :some_reader ].should == :reader
      non_atomic_attribute_readers.include?( :some_reader ).should == true
      non_atomic_attribute_writers.include?( :some_reader ).should == false
      non_atomic_attribute_accessors.include?( :some_reader ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_reader ).should == false
      atomic_attribute_writers.include?( :some_reader ).should == false
      atomic_attribute_accessors.include?( :some_reader ).should == false

      non_atomic_attributes[ :some_other_reader ] = :reader
      non_atomic_attributes[ :some_other_reader ].should == :reader
      persistent_attributes[ :some_other_reader ].should == :reader
      non_atomic_attribute_readers.include?( :some_other_reader ).should == true
      non_atomic_attribute_writers.include?( :some_other_reader ).should == false
      non_atomic_attribute_accessors.include?( :some_other_reader ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_other_reader ).should == false
      atomic_attribute_writers.include?( :some_other_reader ).should == false
      atomic_attribute_accessors.include?( :some_other_reader ).should == false
      
      non_atomic_attributes.add( :some_reader, :writer )
      non_atomic_attributes[ :some_reader ].should == :accessor
      persistent_attributes[ :some_reader ].should == :accessor
      non_atomic_attribute_readers.include?( :some_reader ).should == true
      non_atomic_attribute_writers.include?( :some_reader ).should == true
      non_atomic_attribute_accessors.include?( :some_reader ).should == true
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_reader ).should == false
      atomic_attribute_writers.include?( :some_reader ).should == false
      atomic_attribute_accessors.include?( :some_reader ).should == false

      non_atomic_attributes.subtract( :some_reader, :writer )
      non_atomic_attributes[ :some_reader ].should == :reader
      persistent_attributes[ :some_reader ].should == :reader
      non_atomic_attribute_readers.include?( :some_reader ).should == true
      non_atomic_attribute_writers.include?( :some_reader ).should == false
      non_atomic_attribute_accessors.include?( :some_reader ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_reader ).should == false
      atomic_attribute_writers.include?( :some_reader ).should == false
      atomic_attribute_accessors.include?( :some_reader ).should == false
      
      # writer
      non_atomic_attributes.add( :some_writer, :writer )
      non_atomic_attributes[ :some_writer ].should == :writer
      persistent_attributes[ :some_writer ].should == :writer
      non_atomic_attribute_readers.include?( :some_writer ).should == false
      non_atomic_attribute_writers.include?( :some_writer ).should == true
      non_atomic_attribute_accessors.include?( :some_writer ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_writer ).should == false
      atomic_attribute_writers.include?( :some_writer ).should == false
      atomic_attribute_accessors.include?( :some_writer ).should == false

      non_atomic_attributes[ :some_other_writer ] = :writer
      non_atomic_attributes[ :some_other_writer ].should == :writer
      persistent_attributes[ :some_other_writer ].should == :writer
      non_atomic_attribute_readers.include?( :some_other_writer ).should == false
      non_atomic_attribute_writers.include?( :some_other_writer ).should == true
      non_atomic_attribute_accessors.include?( :some_other_writer ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_other_writer ).should == false
      atomic_attribute_writers.include?( :some_other_writer ).should == false
      atomic_attribute_accessors.include?( :some_other_writer ).should == false
      
      non_atomic_attributes.add( :some_writer, :reader )
      non_atomic_attributes[ :some_writer ].should == :accessor
      persistent_attributes[ :some_writer ].should == :accessor
      non_atomic_attribute_readers.include?( :some_writer ).should == true
      non_atomic_attribute_writers.include?( :some_writer ).should == true
      non_atomic_attribute_accessors.include?( :some_writer ).should == true
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_writer ).should == false
      atomic_attribute_writers.include?( :some_writer ).should == false
      atomic_attribute_accessors.include?( :some_writer ).should == false
      
      non_atomic_attributes.subtract( :some_writer, :reader )
      non_atomic_attributes[ :some_writer ].should == :writer
      persistent_attributes[ :some_writer ].should == :writer
      non_atomic_attribute_readers.include?( :some_writer ).should == false
      non_atomic_attribute_writers.include?( :some_writer ).should == true
      non_atomic_attribute_accessors.include?( :some_writer ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_writer ).should == false
      atomic_attribute_writers.include?( :some_writer ).should == false
      atomic_attribute_accessors.include?( :some_writer ).should == false
      
      # accessor
      non_atomic_attributes.add( :some_accessor, :accessor )
      non_atomic_attributes[ :some_accessor ].should == :accessor
      persistent_attributes[ :some_accessor ].should == :accessor
      non_atomic_attribute_readers.include?( :some_accessor ).should == true
      non_atomic_attribute_writers.include?( :some_accessor ).should == true
      non_atomic_attribute_accessors.include?( :some_accessor ).should == true
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_accessor ).should == false
      atomic_attribute_writers.include?( :some_accessor ).should == false
      atomic_attribute_accessors.include?( :some_accessor ).should == false

      non_atomic_attributes[ :some_other_accessor ] = :accessor
      non_atomic_attributes[ :some_other_accessor ].should == :accessor
      persistent_attributes[ :some_other_accessor ].should == :accessor
      non_atomic_attribute_readers.include?( :some_other_accessor ).should == true
      non_atomic_attribute_writers.include?( :some_other_accessor ).should == true
      non_atomic_attribute_accessors.include?( :some_other_accessor ).should == true
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_other_accessor ).should == false
      atomic_attribute_writers.include?( :some_other_accessor ).should == false
      atomic_attribute_accessors.include?( :some_other_accessor ).should == false

      non_atomic_attributes.subtract( :some_other_accessor, :accessor )
      non_atomic_attribute_readers.include?( :some_other_accessor ).should == false
      non_atomic_attribute_writers.include?( :some_other_accessor ).should == false
      non_atomic_attribute_accessors.include?( :some_other_accessor ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_other_accessor ).should == false
      atomic_attribute_writers.include?( :some_other_accessor ).should == false
      atomic_attribute_accessors.include?( :some_other_accessor ).should == false
      
      # nil
      non_atomic_attributes[ :some_accessor ] = nil
      non_atomic_attribute_readers.include?( :some_accessor ).should == false
      non_atomic_attribute_writers.include?( :some_accessor ).should == false
      non_atomic_attribute_accessors.include?( :some_accessor ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_accessor ).should == false
      atomic_attribute_writers.include?( :some_accessor ).should == false
      atomic_attribute_accessors.include?( :some_accessor ).should == false
      
    end
  end

  ###########################
  #  persistent_attributes  #
  ###########################

  it 'can declare persistent attribute readers, writers, accessors (which default to non-atomic or atomic), and automatically update corresponding declarations' do
    class ::Persistence::Object::Complex::Attributes::PersistentAttributesMock

      include ::Persistence::Object::Complex

      # Atomic

      atomic_attributes.empty?.should == true
      non_atomic_attributes.empty?.should == true
      persistent_attributes.empty?.should == true

      persistent_attributes.default_atomic!

      # reader
      persistent_attributes.add( :some_reader, :reader )
      atomic_attributes[ :some_reader ].should == :reader
      persistent_attributes[ :some_reader ].should == :reader
      atomic_attribute_readers.include?( :some_reader ).should == true
      atomic_attribute_writers.include?( :some_reader ).should == false
      atomic_attribute_accessors.include?( :some_reader ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_reader ).should == false
      non_atomic_attribute_writers.include?( :some_reader ).should == false
      non_atomic_attribute_accessors.include?( :some_reader ).should == false

      persistent_attributes[ :some_other_reader ] = :reader
      atomic_attributes[ :some_other_reader ].should == :reader
      persistent_attributes[ :some_other_reader ].should == :reader
      atomic_attribute_readers.include?( :some_other_reader ).should == true
      atomic_attribute_writers.include?( :some_other_reader ).should == false
      atomic_attribute_accessors.include?( :some_other_reader ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_other_reader ).should == false
      non_atomic_attribute_writers.include?( :some_other_reader ).should == false
      non_atomic_attribute_accessors.include?( :some_other_reader ).should == false
      
      persistent_attributes.add( :some_reader, :writer )
      atomic_attributes[ :some_reader ].should == :accessor
      persistent_attributes[ :some_reader ].should == :accessor
      atomic_attribute_readers.include?( :some_reader ).should == true
      atomic_attribute_writers.include?( :some_reader ).should == true
      atomic_attribute_accessors.include?( :some_reader ).should == true
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_reader ).should == false
      non_atomic_attribute_writers.include?( :some_reader ).should == false
      non_atomic_attribute_accessors.include?( :some_reader ).should == false

      persistent_attributes.subtract( :some_reader, :writer )
      atomic_attributes[ :some_reader ].should == :reader
      persistent_attributes[ :some_reader ].should == :reader
      atomic_attribute_readers.include?( :some_reader ).should == true
      atomic_attribute_writers.include?( :some_reader ).should == false
      atomic_attribute_accessors.include?( :some_reader ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_reader ).should == false
      non_atomic_attribute_writers.include?( :some_reader ).should == false
      non_atomic_attribute_accessors.include?( :some_reader ).should == false
      
      # writer
      persistent_attributes.add( :some_writer, :writer )
      atomic_attributes[ :some_writer ].should == :writer
      persistent_attributes[ :some_writer ].should == :writer
      atomic_attribute_readers.include?( :some_writer ).should == false
      atomic_attribute_writers.include?( :some_writer ).should == true
      atomic_attribute_accessors.include?( :some_writer ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_writer ).should == false
      non_atomic_attribute_writers.include?( :some_writer ).should == false
      non_atomic_attribute_accessors.include?( :some_writer ).should == false

      persistent_attributes[ :some_other_writer ] = :writer
      atomic_attributes[ :some_other_writer ].should == :writer
      persistent_attributes[ :some_other_writer ].should == :writer
      atomic_attribute_readers.include?( :some_other_writer ).should == false
      atomic_attribute_writers.include?( :some_other_writer ).should == true
      atomic_attribute_accessors.include?( :some_other_writer ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_other_writer ).should == false
      non_atomic_attribute_writers.include?( :some_other_writer ).should == false
      non_atomic_attribute_accessors.include?( :some_other_writer ).should == false
      
      persistent_attributes.add( :some_writer, :reader )
      atomic_attributes[ :some_writer ].should == :accessor
      persistent_attributes[ :some_writer ].should == :accessor
      atomic_attribute_readers.include?( :some_writer ).should == true
      atomic_attribute_writers.include?( :some_writer ).should == true
      atomic_attribute_accessors.include?( :some_writer ).should == true
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_writer ).should == false
      non_atomic_attribute_writers.include?( :some_writer ).should == false
      non_atomic_attribute_accessors.include?( :some_writer ).should == false
      
      persistent_attributes.subtract( :some_writer, :reader )
      atomic_attributes[ :some_writer ].should == :writer
      persistent_attributes[ :some_writer ].should == :writer
      atomic_attribute_readers.include?( :some_writer ).should == false
      atomic_attribute_writers.include?( :some_writer ).should == true
      atomic_attribute_accessors.include?( :some_writer ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_writer ).should == false
      non_atomic_attribute_writers.include?( :some_writer ).should == false
      non_atomic_attribute_accessors.include?( :some_writer ).should == false
      
      # accessor
      persistent_attributes.add( :some_accessor, :accessor )
      atomic_attributes[ :some_accessor ].should == :accessor
      persistent_attributes[ :some_accessor ].should == :accessor
      atomic_attribute_readers.include?( :some_accessor ).should == true
      atomic_attribute_writers.include?( :some_accessor ).should == true
      atomic_attribute_accessors.include?( :some_accessor ).should == true
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_accessor ).should == false
      non_atomic_attribute_writers.include?( :some_accessor ).should == false
      non_atomic_attribute_accessors.include?( :some_accessor ).should == false

      persistent_attributes[ :some_other_accessor ] = :accessor
      atomic_attributes[ :some_other_accessor ].should == :accessor
      persistent_attributes[ :some_other_accessor ].should == :accessor
      atomic_attribute_readers.include?( :some_other_accessor ).should == true
      atomic_attribute_writers.include?( :some_other_accessor ).should == true
      atomic_attribute_accessors.include?( :some_other_accessor ).should == true
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_other_accessor ).should == false
      non_atomic_attribute_writers.include?( :some_other_accessor ).should == false
      non_atomic_attribute_accessors.include?( :some_other_accessor ).should == false

      persistent_attributes.subtract( :some_other_accessor, :accessor )
      atomic_attribute_readers.include?( :some_other_accessor ).should == false
      atomic_attribute_writers.include?( :some_other_accessor ).should == false
      atomic_attribute_accessors.include?( :some_other_accessor ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_other_accessor ).should == false
      non_atomic_attribute_writers.include?( :some_other_accessor ).should == false
      non_atomic_attribute_accessors.include?( :some_other_accessor ).should == false
      
      # nil
      persistent_attributes[ :some_accessor ] = nil
      atomic_attribute_readers.include?( :some_accessor ).should == false
      atomic_attribute_writers.include?( :some_accessor ).should == false
      atomic_attribute_accessors.include?( :some_accessor ).should == false
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_readers.include?( :some_accessor ).should == false
      non_atomic_attribute_writers.include?( :some_accessor ).should == false
      non_atomic_attribute_accessors.include?( :some_accessor ).should == false

      atomic_attributes.clear
      non_atomic_attributes.clear
      persistent_attributes.clear

      #################################################

      # Non-Atomic

      atomic_attributes.empty?.should == true
      non_atomic_attributes.empty?.should == true
      persistent_attributes.empty?.should == true

      persistent_attributes.default_non_atomic!

      # reader
      persistent_attributes.add( :some_reader, :reader )
      non_atomic_attributes[ :some_reader ].should == :reader
      persistent_attributes[ :some_reader ].should == :reader
      non_atomic_attribute_readers.include?( :some_reader ).should == true
      non_atomic_attribute_writers.include?( :some_reader ).should == false
      non_atomic_attribute_accessors.include?( :some_reader ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_reader ).should == false
      atomic_attribute_writers.include?( :some_reader ).should == false
      atomic_attribute_accessors.include?( :some_reader ).should == false

      persistent_attributes[ :some_other_reader ] = :reader
      non_atomic_attributes[ :some_other_reader ].should == :reader
      persistent_attributes[ :some_other_reader ].should == :reader
      non_atomic_attribute_readers.include?( :some_other_reader ).should == true
      non_atomic_attribute_writers.include?( :some_other_reader ).should == false
      non_atomic_attribute_accessors.include?( :some_other_reader ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_other_reader ).should == false
      atomic_attribute_writers.include?( :some_other_reader ).should == false
      atomic_attribute_accessors.include?( :some_other_reader ).should == false
      
      persistent_attributes.add( :some_reader, :writer )
      non_atomic_attributes[ :some_reader ].should == :accessor
      persistent_attributes[ :some_reader ].should == :accessor
      non_atomic_attribute_readers.include?( :some_reader ).should == true
      non_atomic_attribute_writers.include?( :some_reader ).should == true
      non_atomic_attribute_accessors.include?( :some_reader ).should == true
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_reader ).should == false
      atomic_attribute_writers.include?( :some_reader ).should == false
      atomic_attribute_accessors.include?( :some_reader ).should == false

      persistent_attributes.subtract( :some_reader, :writer )
      non_atomic_attributes[ :some_reader ].should == :reader
      persistent_attributes[ :some_reader ].should == :reader
      non_atomic_attribute_readers.include?( :some_reader ).should == true
      non_atomic_attribute_writers.include?( :some_reader ).should == false
      non_atomic_attribute_accessors.include?( :some_reader ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_reader ).should == false
      atomic_attribute_writers.include?( :some_reader ).should == false
      atomic_attribute_accessors.include?( :some_reader ).should == false
      
      # writer
      persistent_attributes.add( :some_writer, :writer )
      non_atomic_attributes[ :some_writer ].should == :writer
      persistent_attributes[ :some_writer ].should == :writer
      non_atomic_attribute_readers.include?( :some_writer ).should == false
      non_atomic_attribute_writers.include?( :some_writer ).should == true
      non_atomic_attribute_accessors.include?( :some_writer ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_writer ).should == false
      atomic_attribute_writers.include?( :some_writer ).should == false
      atomic_attribute_accessors.include?( :some_writer ).should == false

      persistent_attributes[ :some_other_writer ] = :writer
      non_atomic_attributes[ :some_other_writer ].should == :writer
      persistent_attributes[ :some_other_writer ].should == :writer
      non_atomic_attribute_readers.include?( :some_other_writer ).should == false
      non_atomic_attribute_writers.include?( :some_other_writer ).should == true
      non_atomic_attribute_accessors.include?( :some_other_writer ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_other_writer ).should == false
      atomic_attribute_writers.include?( :some_other_writer ).should == false
      atomic_attribute_accessors.include?( :some_other_writer ).should == false
      
      persistent_attributes.add( :some_writer, :reader )
      non_atomic_attributes[ :some_writer ].should == :accessor
      persistent_attributes[ :some_writer ].should == :accessor
      non_atomic_attribute_readers.include?( :some_writer ).should == true
      non_atomic_attribute_writers.include?( :some_writer ).should == true
      non_atomic_attribute_accessors.include?( :some_writer ).should == true
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_writer ).should == false
      atomic_attribute_writers.include?( :some_writer ).should == false
      atomic_attribute_accessors.include?( :some_writer ).should == false
      
      persistent_attributes.subtract( :some_writer, :reader )
      non_atomic_attributes[ :some_writer ].should == :writer
      persistent_attributes[ :some_writer ].should == :writer
      non_atomic_attribute_readers.include?( :some_writer ).should == false
      non_atomic_attribute_writers.include?( :some_writer ).should == true
      non_atomic_attribute_accessors.include?( :some_writer ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_writer ).should == false
      atomic_attribute_writers.include?( :some_writer ).should == false
      atomic_attribute_accessors.include?( :some_writer ).should == false
      
      # accessor
      persistent_attributes.add( :some_accessor, :accessor )
      non_atomic_attributes[ :some_accessor ].should == :accessor
      persistent_attributes[ :some_accessor ].should == :accessor
      non_atomic_attribute_readers.include?( :some_accessor ).should == true
      non_atomic_attribute_writers.include?( :some_accessor ).should == true
      non_atomic_attribute_accessors.include?( :some_accessor ).should == true
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_accessor ).should == false
      atomic_attribute_writers.include?( :some_accessor ).should == false
      atomic_attribute_accessors.include?( :some_accessor ).should == false

      persistent_attributes[ :some_other_accessor ] = :accessor
      non_atomic_attributes[ :some_other_accessor ].should == :accessor
      persistent_attributes[ :some_other_accessor ].should == :accessor
      non_atomic_attribute_readers.include?( :some_other_accessor ).should == true
      non_atomic_attribute_writers.include?( :some_other_accessor ).should == true
      non_atomic_attribute_accessors.include?( :some_other_accessor ).should == true
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_other_accessor ).should == false
      atomic_attribute_writers.include?( :some_other_accessor ).should == false
      atomic_attribute_accessors.include?( :some_other_accessor ).should == false

      persistent_attributes.subtract( :some_other_accessor, :accessor )
      non_atomic_attribute_readers.include?( :some_other_accessor ).should == false
      non_atomic_attribute_writers.include?( :some_other_accessor ).should == false
      non_atomic_attribute_accessors.include?( :some_other_accessor ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_other_accessor ).should == false
      atomic_attribute_writers.include?( :some_other_accessor ).should == false
      atomic_attribute_accessors.include?( :some_other_accessor ).should == false
      
      # nil
      persistent_attributes[ :some_accessor ] = nil
      non_atomic_attribute_readers.include?( :some_accessor ).should == false
      non_atomic_attribute_writers.include?( :some_accessor ).should == false
      non_atomic_attribute_accessors.include?( :some_accessor ).should == false
      atomic_attributes.empty?.should == true
      atomic_attribute_readers.include?( :some_accessor ).should == false
      atomic_attribute_writers.include?( :some_accessor ).should == false
      atomic_attribute_accessors.include?( :some_accessor ).should == false
      
    end
  end

  ##############################
  #  atomic_attribute_readers  #
  ##############################

  it 'can declare atomic attribute accessors' do
    class ::Persistence::Object::Complex::Attributes::AtomicAttributeReaders

      include ::Persistence::Object::Complex

      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
      atomic_attributes.empty?.should == true
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true

      atomic_attribute_readers.push( :some_reader )
      atomic_attributes[ :some_reader ].should == :reader
      persistent_attributes[ :some_reader ].should == :reader
      atomic_attribute_readers.should == [ :some_reader ]
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true      
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true

      atomic_attributes[ :some_reader ] = :accessor
      atomic_attribute_writers.delete( :some_reader )
      atomic_attribute_readers.should == [ :some_reader ]
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true      
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
      
      atomic_attribute_readers.delete( :some_reader )
      atomic_attributes[ :some_reader ].should == nil
      persistent_attributes[ :some_reader ].should == nil
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true      
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
      
    end
  end


  ##############################
  #  atomic_attribute_writers  #
  ##############################

  it 'can declare atomic attribute accessors' do
    class ::Persistence::Object::Complex::Attributes::AtomicAttributeWriters

      include ::Persistence::Object::Complex

      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
      atomic_attributes.empty?.should == true
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true

      atomic_attribute_writers.push( :some_writer )
      atomic_attributes[ :some_writer ].should == :writer
      persistent_attributes[ :some_writer ].should == :writer
      atomic_attribute_writers.should == [ :some_writer ]
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true      
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
    
      atomic_attributes[ :some_writer ] = :accessor
      atomic_attribute_readers.delete( :some_writer )
      atomic_attribute_writers.should == [ :some_writer ]
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true      
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
    
      atomic_attribute_writers.delete( :some_writer )
      atomic_attributes[ :some_writer ].should == nil
      persistent_attributes[ :some_writer ].should == nil
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true      
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
    
    end
  end

  ################################
  #  atomic_attribute_accessors  #
  ################################

  it 'can declare atomic attribute accessors' do
    class ::Persistence::Object::Complex::Attributes::AtomicAttributeAccessors

      include ::Persistence::Object::Complex

      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
      atomic_attributes.empty?.should == true
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true

      atomic_attribute_accessors.push( :some_accessor )
      atomic_attributes[ :some_accessor ].should == :accessor
      persistent_attributes[ :some_accessor ].should == :accessor
      atomic_attribute_writers.should == [ :some_accessor ]
      atomic_attribute_readers.should == [ :some_accessor ]
      atomic_attribute_accessors.should == [ :some_accessor ]
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
    
      atomic_attribute_accessors.delete( :some_accessor )
      atomic_attributes[ :some_accessor ].should == nil
      persistent_attributes[ :some_accessor ].should == nil
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true      
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
    
    end
  end

  ##################################
  #  non_atomic_attribute_readers  #
  ##################################

  it 'can declare non-atomic attribute accessors' do
    class ::Persistence::Object::Complex::Attributes::NonAtomicAttributeReaders

      include ::Persistence::Object::Complex

      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
      non_atomic_attributes.empty?.should == true
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true

      non_atomic_attribute_readers.push( :some_reader )
      non_atomic_attributes[ :some_reader ].should == :reader
      persistent_attributes[ :some_reader ].should == :reader
      non_atomic_attribute_readers.should == [ :some_reader ]
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true      
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true

      non_atomic_attributes[ :some_reader ] = :accessor
      non_atomic_attribute_writers.delete( :some_reader )
      non_atomic_attribute_readers.should == [ :some_reader ]
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true      
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
      
      non_atomic_attribute_readers.delete( :some_reader )
      non_atomic_attributes[ :some_reader ].should == nil
      persistent_attributes[ :some_reader ].should == nil
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true      
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
      
    end
  end

  ##################################
  #  non_atomic_attribute_writers  #
  ##################################

  it 'can declare non-atomic attribute accessors' do
    class ::Persistence::Object::Complex::Attributes::NonAtomicAttributeWriters

      include ::Persistence::Object::Complex

      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
      non_atomic_attributes.empty?.should == true
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true

      non_atomic_attribute_writers.push( :some_writer )
      non_atomic_attributes[ :some_writer ].should == :writer
      persistent_attributes[ :some_writer ].should == :writer
      non_atomic_attribute_writers.should == [ :some_writer ]
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true      
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
    
      non_atomic_attributes[ :some_writer ] = :accessor
      non_atomic_attribute_readers.delete( :some_writer )
      non_atomic_attribute_writers.should == [ :some_writer ]
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true      
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
    
      non_atomic_attribute_writers.delete( :some_writer )
      non_atomic_attributes[ :some_writer ].should == nil
      persistent_attributes[ :some_writer ].should == nil
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true      
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
    
    end
  end

  ####################################
  #  non_atomic_attribute_accessors  #
  ####################################

  it 'can declare non-atomic attribute accessors' do
    class ::Persistence::Object::Complex::Attributes::NonAtomicAttributeAccessors

      include ::Persistence::Object::Complex

      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
      non_atomic_attributes.empty?.should == true
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true

      non_atomic_attribute_accessors.push( :some_accessor )
      non_atomic_attributes[ :some_accessor ].should == :accessor
      persistent_attributes[ :some_accessor ].should == :accessor
      non_atomic_attribute_writers.should == [ :some_accessor ]
      non_atomic_attribute_readers.should == [ :some_accessor ]
      non_atomic_attribute_accessors.should == [ :some_accessor ]
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
    
      non_atomic_attribute_accessors.delete( :some_accessor )
      non_atomic_attributes[ :some_accessor ].should == nil
      persistent_attributes[ :some_accessor ].should == nil
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true      
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
    
    end
  end

  ##################################
  #  persistent_attribute_readers  #
  ##################################

  it 'can declare persistent attribute readers' do
    class ::Persistence::Object::Complex::Attributes::PersistentAttributeReaders

      include ::Persistence::Object::Complex
      
        # Atomic
        
        persistent_attribute_readers.default_atomic!
        
        atomic_attribute_writers.empty?.should == true
        atomic_attribute_readers.empty?.should == true
        atomic_attribute_accessors.empty?.should == true
        atomic_attributes.empty?.should == true
        non_atomic_attributes.empty?.should == true
        non_atomic_attribute_writers.empty?.should == true
        non_atomic_attribute_readers.empty?.should == true
        non_atomic_attribute_accessors.empty?.should == true

        atomic_attribute_readers.push( :some_reader )
        atomic_attributes[ :some_reader ].should == :reader
        persistent_attributes[ :some_reader ].should == :reader
        atomic_attribute_readers.should == [ :some_reader ]
        atomic_attribute_writers.empty?.should == true
        atomic_attribute_accessors.empty?.should == true      
        non_atomic_attributes.empty?.should == true
        non_atomic_attribute_writers.empty?.should == true
        non_atomic_attribute_readers.empty?.should == true
        non_atomic_attribute_accessors.empty?.should == true

        atomic_attributes[ :some_reader ] = :accessor
        atomic_attribute_writers.delete( :some_reader )
        atomic_attribute_readers.should == [ :some_reader ]
        atomic_attribute_writers.empty?.should == true
        atomic_attribute_accessors.empty?.should == true      
        non_atomic_attributes.empty?.should == true
        non_atomic_attribute_writers.empty?.should == true
        non_atomic_attribute_readers.empty?.should == true
        non_atomic_attribute_accessors.empty?.should == true

        atomic_attribute_readers.delete( :some_reader )
        atomic_attributes[ :some_reader ].should == nil
        persistent_attributes[ :some_reader ].should == nil
        atomic_attribute_readers.empty?.should == true
        atomic_attribute_writers.empty?.should == true
        atomic_attribute_accessors.empty?.should == true      
        non_atomic_attributes.empty?.should == true
        non_atomic_attribute_writers.empty?.should == true
        non_atomic_attribute_readers.empty?.should == true
        non_atomic_attribute_accessors.empty?.should == true
        
        # Non-Atomic
        
        persistent_attribute_readers.default_non_atomic!
        
        non_atomic_attribute_writers.empty?.should == true
        non_atomic_attribute_readers.empty?.should == true
        non_atomic_attribute_accessors.empty?.should == true
        non_atomic_attributes.empty?.should == true
        atomic_attributes.empty?.should == true
        atomic_attribute_writers.empty?.should == true
        atomic_attribute_readers.empty?.should == true
        atomic_attribute_accessors.empty?.should == true

        non_atomic_attribute_readers.push( :some_reader )
        non_atomic_attributes[ :some_reader ].should == :reader
        persistent_attributes[ :some_reader ].should == :reader
        non_atomic_attribute_readers.should == [ :some_reader ]
        non_atomic_attribute_writers.empty?.should == true
        non_atomic_attribute_accessors.empty?.should == true      
        atomic_attributes.empty?.should == true
        atomic_attribute_writers.empty?.should == true
        atomic_attribute_readers.empty?.should == true
        atomic_attribute_accessors.empty?.should == true

        non_atomic_attributes[ :some_reader ] = :accessor
        non_atomic_attribute_writers.delete( :some_reader )
        non_atomic_attribute_readers.should == [ :some_reader ]
        non_atomic_attribute_writers.empty?.should == true
        non_atomic_attribute_accessors.empty?.should == true      
        atomic_attributes.empty?.should == true
        atomic_attribute_writers.empty?.should == true
        atomic_attribute_readers.empty?.should == true
        atomic_attribute_accessors.empty?.should == true

        non_atomic_attribute_readers.delete( :some_reader )
        non_atomic_attributes[ :some_reader ].should == nil
        persistent_attributes[ :some_reader ].should == nil
        non_atomic_attribute_readers.empty?.should == true
        non_atomic_attribute_writers.empty?.should == true
        non_atomic_attribute_accessors.empty?.should == true      
        atomic_attributes.empty?.should == true
        atomic_attribute_writers.empty?.should == true
        atomic_attribute_readers.empty?.should == true
        atomic_attribute_accessors.empty?.should == true
        
    end
  end

  ##################################
  #  persistent_attribute_writers  #
  ##################################

  it 'can declare persistent attribute writers' do
    class ::Persistence::Object::Complex::Attributes::PersistentAttributeWriters

      include ::Persistence::Object::Complex

      # Atomic
      
      persistent_attribute_writers.default_atomic!
      
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
      atomic_attributes.empty?.should == true
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true

      atomic_attribute_writers.push( :some_writer )
      atomic_attributes[ :some_writer ].should == :writer
      persistent_attributes[ :some_writer ].should == :writer
      atomic_attribute_writers.should == [ :some_writer ]
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true      
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
    
      atomic_attributes[ :some_writer ] = :accessor
      atomic_attribute_readers.delete( :some_writer )
      atomic_attribute_writers.should == [ :some_writer ]
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true      
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
    
      atomic_attribute_writers.delete( :some_writer )
      atomic_attributes[ :some_writer ].should == nil
      persistent_attributes[ :some_writer ].should == nil
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true      
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
      
      # Non-Atomic
      
      persistent_attribute_writers.default_non_atomic!

      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
      non_atomic_attributes.empty?.should == true
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true

      non_atomic_attribute_writers.push( :some_writer )
      non_atomic_attributes[ :some_writer ].should == :writer
      persistent_attributes[ :some_writer ].should == :writer
      non_atomic_attribute_writers.should == [ :some_writer ]
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true      
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
    
      non_atomic_attributes[ :some_writer ] = :accessor
      non_atomic_attribute_readers.delete( :some_writer )
      non_atomic_attribute_writers.should == [ :some_writer ]
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true      
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
    
      non_atomic_attribute_writers.delete( :some_writer )
      non_atomic_attributes[ :some_writer ].should == nil
      persistent_attributes[ :some_writer ].should == nil
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true      
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
      
    end
  end

  ####################################
  #  persistent_attribute_accessors  #
  ####################################

  it 'can declare persistent attribute accessors' do
    class ::Persistence::Object::Complex::Attributes::PersistentAttributeAccessors

      include ::Persistence::Object::Complex

      # Atomic
      
      persistent_attribute_accessors.default_atomic!
      
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
      atomic_attributes.empty?.should == true
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true

      atomic_attribute_accessors.push( :some_accessor )
      atomic_attributes[ :some_accessor ].should == :accessor
      persistent_attributes[ :some_accessor ].should == :accessor
      atomic_attribute_writers.should == [ :some_accessor ]
      atomic_attribute_readers.should == [ :some_accessor ]
      atomic_attribute_accessors.should == [ :some_accessor ]
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
    
      atomic_attribute_accessors.delete( :some_accessor )
      atomic_attributes[ :some_accessor ].should == nil
      persistent_attributes[ :some_accessor ].should == nil
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true      
      non_atomic_attributes.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
      
      
      # Non-Atomic
      
      persistent_attribute_accessors.default_non_atomic!
      
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true
      non_atomic_attributes.empty?.should == true
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true

      non_atomic_attribute_accessors.push( :some_accessor )
      non_atomic_attributes[ :some_accessor ].should == :accessor
      persistent_attributes[ :some_accessor ].should == :accessor
      non_atomic_attribute_writers.should == [ :some_accessor ]
      non_atomic_attribute_readers.should == [ :some_accessor ]
      non_atomic_attribute_accessors.should == [ :some_accessor ]
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
    
      non_atomic_attribute_accessors.delete( :some_accessor )
      non_atomic_attributes[ :some_accessor ].should == nil
      persistent_attributes[ :some_accessor ].should == nil
      non_atomic_attribute_readers.empty?.should == true
      non_atomic_attribute_writers.empty?.should == true
      non_atomic_attribute_accessors.empty?.should == true      
      atomic_attributes.empty?.should == true
      atomic_attribute_writers.empty?.should == true
      atomic_attribute_readers.empty?.should == true
      atomic_attribute_accessors.empty?.should == true
      
    end
  end

  #######################
  #  atomic_attribute?  #
  #######################
  
  it 'can report whether an attribute is atomic (:accessor, :reader, :writer).' do
    class ::Persistence::Object::Complex::Attributes::AtomicAttributeQ
      include ::Persistence::Object::Complex
      atomic_attributes[ :some_accessor ] = :accessor
      atomic_attributes[ :some_reader ] = :reader
      atomic_attributes[ :some_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::AtomicAttributeQ.new.instance_eval do

      atomic_attribute?( :some_accessor ).should == true
      atomic_attribute?( :some_reader ).should == true
      atomic_attribute?( :some_writer ).should == true
      atomic_attribute?( :some_other_accessor ).should == false
      atomic_attribute?( :some_other_reader ).should == false
      atomic_attribute?( :some_other_writer ).should == false

    end
  end

  ################################
  #  atomic_attribute_accessor?  #
  ################################
  
  it 'can report whether an attribute is a atomic :accessor' do
    class ::Persistence::Object::Complex::Attributes::AtomicAttributeAccessorQ
      include ::Persistence::Object::Complex
      atomic_attributes[ :some_accessor ] = :accessor
      atomic_attributes[ :some_reader ] = :reader
      atomic_attributes[ :some_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::AtomicAttributeAccessorQ.new.instance_eval do

      atomic_attribute_accessor?( :some_accessor ).should == true
      atomic_attribute_accessor?( :some_reader ).should == false
      atomic_attribute_accessor?( :some_writer ).should == false
      atomic_attribute_accessor?( :some_other_accessor ).should == false
      atomic_attribute_accessor?( :some_other_reader ).should == false
      atomic_attribute_accessor?( :some_other_writer ).should == false

    end
  end

  ##############################
  #  atomic_attribute_reader?  #
  ##############################
  
  it 'can report whether an attribute is a atomic :reader' do
    class ::Persistence::Object::Complex::Attributes::AtomicAttributeReaderQ
      include ::Persistence::Object::Complex
      atomic_attributes[ :some_accessor ] = :accessor
      atomic_attributes[ :some_reader ] = :reader
      atomic_attributes[ :some_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::AtomicAttributeReaderQ.new.instance_eval do

      atomic_attribute_reader?( :some_accessor ).should == true
      atomic_attribute_reader?( :some_reader ).should == true
      atomic_attribute_reader?( :some_writer ).should == false
      atomic_attribute_reader?( :some_other_accessor ).should == false
      atomic_attribute_reader?( :some_other_reader ).should == false
      atomic_attribute_reader?( :some_other_writer ).should == false

    end
  end

  ##############################
  #  atomic_attribute_writer?  #
  ##############################
  
  it 'can report whether an attribute is a atomic :writer' do
    class ::Persistence::Object::Complex::Attributes::AtomicAttributeWriterQ
      include ::Persistence::Object::Complex
      atomic_attributes[ :some_accessor ] = :accessor
      atomic_attributes[ :some_reader ] = :reader
      atomic_attributes[ :some_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::AtomicAttributeWriterQ.new.instance_eval do

      atomic_attribute_writer?( :some_accessor ).should == true
      atomic_attribute_writer?( :some_reader ).should == false
      atomic_attribute_writer?( :some_writer ).should == true
      atomic_attribute_writer?( :some_other_accessor ).should == false
      atomic_attribute_writer?( :some_other_reader ).should == false
      atomic_attribute_writer?( :some_other_writer ).should == false

    end
  end

  #############################
  #  atomic_attribute_status  #
  #############################
  
  it 'can report the current atomic status (:accessor, :reader, :writer) of an attribute' do
    class ::Persistence::Object::Complex::Attributes::AtomicAttributeStatus
      include ::Persistence::Object::Complex
      atomic_attributes[ :some_accessor ] = :accessor
      atomic_attributes[ :some_reader ] = :reader
      atomic_attributes[ :some_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::AtomicAttributeStatus.new.instance_eval do
$blah = true

      atomic_attribute_status( :some_accessor ).should == :accessor
      atomic_attribute_status( :some_reader ).should == :reader
      atomic_attribute_status( :some_writer ).should == :writer
      atomic_attribute_status( :some_other_accessor ).should == nil
      atomic_attribute_status( :some_other_reader ).should == nil
      atomic_attribute_status( :some_other_writer ).should == nil

    end
  end

  ###########################
  #  non_atomic_attribute?  #
  ###########################
  
  it 'can report whether an attribute is non_atomic (:accessor, :reader, :writer).' do
    class ::Persistence::Object::Complex::Attributes::NonAtomicAttributeQ
      include ::Persistence::Object::Complex
      non_atomic_attributes[ :some_accessor ] = :accessor
      non_atomic_attributes[ :some_reader ] = :reader
      non_atomic_attributes[ :some_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::NonAtomicAttributeQ.new.instance_eval do

      non_atomic_attribute?( :some_accessor ).should == true
      non_atomic_attribute?( :some_reader ).should == true
      non_atomic_attribute?( :some_writer ).should == true
      non_atomic_attribute?( :some_other_accessor ).should == false
      non_atomic_attribute?( :some_other_reader ).should == false
      non_atomic_attribute?( :some_other_writer ).should == false

    end
  end

  ####################################
  #  non_atomic_attribute_accessor?  #
  ####################################
  
  it 'can report whether an attribute is a non_atomic :accessor' do
    class ::Persistence::Object::Complex::Attributes::NonAtomicAttributeAccessorQ
      include ::Persistence::Object::Complex
      non_atomic_attributes[ :some_accessor ] = :accessor
      non_atomic_attributes[ :some_reader ] = :reader
      non_atomic_attributes[ :some_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::NonAtomicAttributeAccessorQ.new.instance_eval do

      non_atomic_attribute_accessor?( :some_accessor ).should == true
      non_atomic_attribute_accessor?( :some_reader ).should == false
      non_atomic_attribute_accessor?( :some_writer ).should == false
      non_atomic_attribute_accessor?( :some_other_accessor ).should == false
      non_atomic_attribute_accessor?( :some_other_reader ).should == false
      non_atomic_attribute_accessor?( :some_other_writer ).should == false

    end
  end

  ##################################
  #  non_atomic_attribute_reader?  #
  ##################################
  
  it 'can report whether an attribute is a non_atomic :reader' do
    class ::Persistence::Object::Complex::Attributes::NonAtomicAttributeReaderQ
      include ::Persistence::Object::Complex
      non_atomic_attributes[ :some_accessor ] = :accessor
      non_atomic_attributes[ :some_reader ] = :reader
      non_atomic_attributes[ :some_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::NonAtomicAttributeReaderQ.new.instance_eval do

      non_atomic_attribute_reader?( :some_accessor ).should == true
      non_atomic_attribute_reader?( :some_reader ).should == true
      non_atomic_attribute_reader?( :some_writer ).should == false
      non_atomic_attribute_reader?( :some_other_accessor ).should == false
      non_atomic_attribute_reader?( :some_other_reader ).should == false
      non_atomic_attribute_reader?( :some_other_writer ).should == false

    end
  end

  ##################################
  #  non_atomic_attribute_writer?  #
  ##################################
  
  it 'can report whether an attribute is a non_atomic :writer' do
    class ::Persistence::Object::Complex::Attributes::NonAtomicAttributeWriterQ
      include ::Persistence::Object::Complex
      non_atomic_attributes[ :some_accessor ] = :accessor
      non_atomic_attributes[ :some_reader ] = :reader
      non_atomic_attributes[ :some_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::NonAtomicAttributeWriterQ.new.instance_eval do

      non_atomic_attribute_writer?( :some_accessor ).should == true
      non_atomic_attribute_writer?( :some_reader ).should == false
      non_atomic_attribute_writer?( :some_writer ).should == true
      non_atomic_attribute_writer?( :some_other_accessor ).should == false
      non_atomic_attribute_writer?( :some_other_reader ).should == false
      non_atomic_attribute_writer?( :some_other_writer ).should == false

    end
  end

  #################################
  #  non_atomic_attribute_status  #
  #################################
  
  it 'can report the current non_atomic status (:accessor, :reader, :writer) of an attribute' do
    class ::Persistence::Object::Complex::Attributes::NonAtomicAttributeStatus
      include ::Persistence::Object::Complex
      non_atomic_attributes[ :some_accessor ] = :accessor
      non_atomic_attributes[ :some_reader ] = :reader
      non_atomic_attributes[ :some_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::NonAtomicAttributeStatus.new.instance_eval do

      non_atomic_attribute_status( :some_accessor ).should == :accessor
      non_atomic_attribute_status( :some_reader ).should == :reader
      non_atomic_attribute_status( :some_writer ).should == :writer
      non_atomic_attribute_status( :some_other_accessor ).should == nil
      non_atomic_attribute_status( :some_other_reader ).should == nil
      non_atomic_attribute_status( :some_other_writer ).should == nil

    end
  end

  ###########################
  #  persistent_attribute?  #
  ###########################
  
  it 'can report whether an attribute is persistent (:accessor, :reader, :writer).' do
    class ::Persistence::Object::Complex::Attributes::PersistentAttributeQ
      include ::Persistence::Object::Complex
      non_atomic_attributes[ :some_non_atomic_accessor ] = :accessor
      non_atomic_attributes[ :some_non_atomic_reader ] = :reader
      non_atomic_attributes[ :some_non_atomic_writer ] = :writer
      atomic_attributes[ :some_atomic_accessor ] = :accessor
      atomic_attributes[ :some_atomic_reader ] = :reader
      atomic_attributes[ :some_atomic_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::PersistentAttributeQ.new.instance_eval do

      persistent_attribute?( :some_non_atomic_accessor ).should == true
      persistent_attribute?( :some_non_atomic_reader ).should == true
      persistent_attribute?( :some_non_atomic_writer ).should == true
      persistent_attribute?( :some_non_atomic_other_accessor ).should == false
      persistent_attribute?( :some_non_atomic_other_reader ).should == false
      persistent_attribute?( :some_non_atomic_other_writer ).should == false

      persistent_attribute?( :some_atomic_accessor ).should == true
      persistent_attribute?( :some_atomic_reader ).should == true
      persistent_attribute?( :some_atomic_writer ).should == true
      persistent_attribute?( :some_atomic_other_accessor ).should == false
      persistent_attribute?( :some_atomic_other_reader ).should == false
      persistent_attribute?( :some_atomic_other_writer ).should == false

    end
  end

  ####################################
  #  persistent_attribute_accessor?  #
  ####################################
  
  it 'can report whether an attribute is a persistent :accessor' do
    class ::Persistence::Object::Complex::Attributes::PersistentAttributeAccessorQ
      include ::Persistence::Object::Complex
      non_atomic_attributes[ :some_non_atomic_accessor ] = :accessor
      non_atomic_attributes[ :some_non_atomic_reader ] = :reader
      non_atomic_attributes[ :some_non_atomic_writer ] = :writer
      atomic_attributes[ :some_atomic_accessor ] = :accessor
      atomic_attributes[ :some_atomic_reader ] = :reader
      atomic_attributes[ :some_atomic_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::PersistentAttributeAccessorQ.new.instance_eval do

      persistent_attribute_accessor?( :some_non_atomic_accessor ).should == true
      persistent_attribute_accessor?( :some_non_atomic_reader ).should == false
      persistent_attribute_accessor?( :some_non_atomic_writer ).should == false
      persistent_attribute_accessor?( :some_non_atomic_other_accessor ).should == false
      persistent_attribute_accessor?( :some_non_atomic_other_reader ).should == false
      persistent_attribute_accessor?( :some_non_atomic_other_writer ).should == false

      persistent_attribute_accessor?( :some_atomic_accessor ).should == true
      persistent_attribute_accessor?( :some_atomic_reader ).should == false
      persistent_attribute_accessor?( :some_atomic_writer ).should == false
      persistent_attribute_accessor?( :some_atomic_other_accessor ).should == false
      persistent_attribute_accessor?( :some_atomic_other_reader ).should == false
      persistent_attribute_accessor?( :some_atomic_other_writer ).should == false

    end
  end

  ##################################
  #  persistent_attribute_reader?  #
  ##################################
  
  it 'can report whether an attribute is a persistent :reader' do
    class ::Persistence::Object::Complex::Attributes::PersistentAttributeReaderQ
      include ::Persistence::Object::Complex
      non_atomic_attributes[ :some_non_atomic_accessor ] = :accessor
      non_atomic_attributes[ :some_non_atomic_reader ] = :reader
      non_atomic_attributes[ :some_non_atomic_writer ] = :writer
      atomic_attributes[ :some_atomic_accessor ] = :accessor
      atomic_attributes[ :some_atomic_reader ] = :reader
      atomic_attributes[ :some_atomic_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::PersistentAttributeReaderQ.new.instance_eval do

      persistent_attribute_reader?( :some_non_atomic_accessor ).should == true
      persistent_attribute_reader?( :some_non_atomic_reader ).should == true
      persistent_attribute_reader?( :some_non_atomic_writer ).should == false
      persistent_attribute_reader?( :some_non_atomic_other_accessor ).should == false
      persistent_attribute_reader?( :some_non_atomic_other_reader ).should == false
      persistent_attribute_reader?( :some_non_atomic_other_writer ).should == false

      persistent_attribute_reader?( :some_atomic_accessor ).should == true
      persistent_attribute_reader?( :some_atomic_reader ).should == true
      persistent_attribute_reader?( :some_atomic_writer ).should == false
      persistent_attribute_reader?( :some_atomic_other_accessor ).should == false
      persistent_attribute_reader?( :some_atomic_other_reader ).should == false
      persistent_attribute_reader?( :some_atomic_other_writer ).should == false

    end
  end

  ##################################
  #  persistent_attribute_writer?  #
  ##################################
  
  it 'can report whether an attribute is a persistent :writer' do
    class ::Persistence::Object::Complex::Attributes::PersistentAttributeWriterQ
      include ::Persistence::Object::Complex
      non_atomic_attributes[ :some_non_atomic_accessor ] = :accessor
      non_atomic_attributes[ :some_non_atomic_reader ] = :reader
      non_atomic_attributes[ :some_non_atomic_writer ] = :writer
      atomic_attributes[ :some_atomic_accessor ] = :accessor
      atomic_attributes[ :some_atomic_reader ] = :reader
      atomic_attributes[ :some_atomic_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::PersistentAttributeWriterQ.new.instance_eval do

      persistent_attribute_writer?( :some_non_atomic_accessor ).should == true
      persistent_attribute_writer?( :some_non_atomic_reader ).should == false
      persistent_attribute_writer?( :some_non_atomic_writer ).should == true
      persistent_attribute_writer?( :some_non_atomic_other_accessor ).should == false
      persistent_attribute_writer?( :some_non_atomic_other_reader ).should == false
      persistent_attribute_writer?( :some_non_atomic_other_writer ).should == false

      persistent_attribute_writer?( :some_atomic_accessor ).should == true
      persistent_attribute_writer?( :some_atomic_reader ).should == false
      persistent_attribute_writer?( :some_atomic_writer ).should == true
      persistent_attribute_writer?( :some_atomic_other_accessor ).should == false
      persistent_attribute_writer?( :some_atomic_other_reader ).should == false
      persistent_attribute_writer?( :some_atomic_other_writer ).should == false

    end
  end

  #################################
  #  persistent_attribute_status  #
  #################################
  
  it 'can report the current persistent status (:accessor, :reader, :writer) of an attribute' do
    class ::Persistence::Object::Complex::Attributes::PersistentAttributeStatus
      include ::Persistence::Object::Complex
      non_atomic_attributes[ :some_non_atomic_accessor ] = :accessor
      non_atomic_attributes[ :some_non_atomic_reader ] = :reader
      non_atomic_attributes[ :some_non_atomic_writer ] = :writer
      atomic_attributes[ :some_atomic_accessor ] = :accessor
      atomic_attributes[ :some_atomic_reader ] = :reader
      atomic_attributes[ :some_atomic_writer ] = :writer
    end
    ::Persistence::Object::Complex::Attributes::PersistentAttributeStatus.new.instance_eval do

      persistent_attribute_status( :some_non_atomic_accessor ).should == :accessor
      persistent_attribute_status( :some_non_atomic_reader ).should == :reader
      persistent_attribute_status( :some_non_atomic_writer ).should == :writer
      persistent_attribute_status( :some_non_atomic_other_accessor ).should == nil
      persistent_attribute_status( :some_non_atomic_other_reader ).should == nil
      persistent_attribute_status( :some_non_atomic_other_writer ).should == nil

      persistent_attribute_status( :some_atomic_accessor ).should == :accessor
      persistent_attribute_status( :some_atomic_reader ).should == :reader
      persistent_attribute_status( :some_atomic_writer ).should == :writer
      persistent_attribute_status( :some_atomic_other_accessor ).should == nil
      persistent_attribute_status( :some_atomic_other_reader ).should == nil
      persistent_attribute_status( :some_atomic_other_writer ).should == nil

    end
  end

end
