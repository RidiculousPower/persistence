
require_relative '../lib/persistence.rb'

require 'date'

require_relative 'persistence/adapter/mock_helpers.rb'

# FIX - Date needs to be treated as a string in and out

describe ::Persistence do

	before(:all)	{ ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new ) }
	after(:all)		{ ::Persistence.disable_port( :mock ) }
	
	before :each  do 
		@user = ::Persistence::Adapter::Abstract::Mock::User.new.persist!
    @user.populate
	end
		
	context "#top_object" do 

		it "should have a valid persistence_bucket" do
		  @user.persistence_bucket.should == ::Persistence::Adapter::Abstract::Mock::User.instance_persistence_bucket
		
		end
		
		it "persistence_bucket name should be the full class name of its object" do
		
		  @user.persistence_bucket.name.should == ::Persistence::Adapter::Abstract::Mock::User.to_s.to_sym
		
		end
		
	end
	

	#To avoid redundant code the following integrations tests will loop over this object variable	
	objects = [:sub_object, :multiple_sub_objects, :object_array, :object_hash]

	object_method = {}
	object_klass	= {}
	
	object_method[:sub_object]	= "address"
	object_klass[:sub_object] 	= ::Persistence::Adapter::Abstract::Mock::User::Address
	
	object_method[:multiple_sub_objects]	= "alternate_address"
	object_klass[:multiple_sub_objects] 	= ::Persistence::Adapter::Abstract::Mock::User::Address
	
	object_method[:object_array]	= "notes"
	object_klass[:object_array] 	= ::Persistence::Adapter::Abstract::Mock::NotesArray
	
	object_method[:object_hash]	= "dictionary"
	object_klass[:object_hash] 	= ::Persistence::Adapter::Abstract::Mock::DictionaryHash
	
	objects.each do |object|
		context "##{object}" do 
			it "should have a valid persistence_bucket"  do 
			  
			  @user.send(object_method[object]).persistence_bucket.should == object_klass[object].instance_persistence_bucket
			
			end
			
			it "persistence_bucket name should be the full class name of its object" do 
			
			  @user.send(object_method[object]).persistence_bucket.name.should == object_klass[object].to_s.to_sym
			
			end
			context "#persisted" do 
				let(:persisted_instance) { object_klass[object].persist( @user.send(object_method[object]).persistence_id )}
				it "should be the original instance" do 
						persisted_instance.should == @user.send(object_method[object])
				end
			end
		end
	end

	context "#complex_object" do 
	
		it "should have a valid persistence_bucket" do 
		  
		  @user.notes[0].persistence_bucket.should == ::Persistence::Adapter::Abstract::Mock::Note.instance_persistence_bucket
		
		end
		
		it "persistence_bucket name should be the full class name of its object" do 
		
		  @user.notes[0].persistence_bucket.name.should == ::Persistence::Adapter::Abstract::Mock::Note.to_s.to_sym
		
		end
		
		context "#persisted" do 
		
			let(:persisted_user) { ::Persistence::Adapter::Abstract::Mock::User.persist( @user.persistence_id ) }
		  
		  it "should be the original instance" do 
		    
		    persisted_user.should == @user
		    
		  end
		  
			#redundant test given prior instance test
		  it "should be the same class as the original object" do 
		  
		    persisted_user.class.should == ::Persistence::Adapter::Abstract::Mock::User
		    
		  end
		  
		end
	
	end

end

