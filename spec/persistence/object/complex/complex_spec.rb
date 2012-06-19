
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  it 'can persist complex objects' do
    class ::Persistence::Object::Complex::UserMock
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      attr_non_atomic_accessor :username, :firstname, :lastname, :address, :alternate_address
    end
    class ::Persistence::Object::Complex::AddressMock
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      attr_non_atomic_accessor :number, :street, :city, :state, :zipcode
    end
    
    user = ::Persistence::Object::Complex::UserMock.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'

    user.address = ::Persistence::Object::Complex::AddressMock.new
    user.address.number = 42
    user.address.street = 'Street'
    user.address.city = 'Some City'
    user.address.state = 'GA'
    user.address.zipcode = '30003'

    user.alternate_address = ::Persistence::Object::Complex::AddressMock.new
    user.alternate_address.number = 37
    user.alternate_address.street = 'Another Street'
    user.alternate_address.city = 'Some Other City'
    user.alternate_address.state = 'TX'
    user.alternate_address.zipcode = '70004'
    user.persist!
    
    ::Persistence::Object::Complex::UserMock.persist( user.persistence_id ).should == user

    user.alternate_address.number = 48

    user.alternate_address.persist!

    ::Persistence::Object::Complex::UserMock.persist( user.persistence_id ).should == user
    
  end

end