require_relative '../../../lib/rpersistence.rb'

describe Rpersistence::ObjectInstance::Attributes do

  class Rpersistence::ObjectInstance::Attributes::Mock

    attr_atomic                   :attribute1,  :attribute2,  :attribute3,  :attribute4
    attr_atomic_reader            :attribute5,  :attribute6,  :attribute7,  :attribute8
    attr_atomic_writer            :attribute9,  :attribute10, :attribute11, :attribute12

    attr_non_atomic               :attribute13, :attribute14, :attribute15, :attribute16
    attr_non_atomic_reader        :attribute17, :attribute18, :attribute19, :attribute20
    attr_non_atomic_writer        :attribute21, :attribute22, :attribute23, :attribute24

    attr_non_persistent           :attribute22, :attribute23, :attribute24, :attribute25
    attr_non_persistent_reader    :attribute9,  :attribute10, :attribute11, :attribute12
    attr_non_persistent_writer    :attribute5,  :attribute6,  :attribute7,  :attribute8

  end
    
  #############################
  #  Klass.atomic_attributes  #
  #  atomic_attributes        #
  #############################

  it "can report which attributes are atomic (whether :accessor, :reader, or :writer)" do
    class Rpersistence::ObjectInstance::Attributes::Mock01 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock01.atomic_attributes.sort.should      == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                              :attribute5,  :attribute6,  :attribute7,  :attribute8,
                                                                                              :attribute9,  :attribute10, :attribute11, :attribute12 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock01.new
    instance.atomic_attributes.sort.should == Rpersistence::ObjectInstance::Attributes::Mock01.atomic_attributes.sort
    instance.attr_non_atomic( :attribute5,  :attribute6,  :attribute7,  :attribute8 )
    instance.attr_atomic( :attribute22, :attribute23, :attribute24, :attribute25 )
    instance.atomic_attributes.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                 :attribute9,  :attribute10, :attribute11, :attribute12,
                                                 :attribute22, :attribute23, :attribute24, :attribute25 ].sort
    class Rpersistence::ObjectInstance::Attributes::Mock01s1 < Rpersistence::ObjectInstance::Attributes::Mock01
      attr_non_atomic       :attribute5,  :attribute6,  :attribute7,  :attribute8
      attr_non_persistent   :attribute1,  :attribute2,  :attribute3,  :attribute4
    end
    Rpersistence::ObjectInstance::Attributes::Mock01s1.atomic_attributes.sort.should == [  :attribute9,  :attribute10, :attribute11, :attribute12 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock01s1.new
    instance.atomic_attributes.sort.should == Rpersistence::ObjectInstance::Attributes::Mock01s1.atomic_attributes.sort
    instance.attr_non_atomic( :attribute9,  :attribute10 )
    instance.atomic_attributes.sort.should == [  :attribute11, :attribute12 ].sort
  end

  ######################################
  #  Klass.atomic_attribute_accessors  #
  #  atomic_attribute_accessors        #
  ######################################

  it "can report which attributes have atomic accessors" do
    class Rpersistence::ObjectInstance::Attributes::Mock02 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock02.atomic_attribute_accessors.sort.should  == [  :attribute1,  :attribute2,  :attribute3,  :attribute4 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock02.new
    instance.atomic_attribute_accessors.sort.should == Rpersistence::ObjectInstance::Attributes::Mock02.atomic_attribute_accessors.sort
    instance.attr_atomic( :attribute5,  :attribute6,  :attribute7,  :attribute8 )
    instance.atomic_attribute_accessors.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                          :attribute5,  :attribute6,  :attribute7,  :attribute8 ].sort
    class Rpersistence::ObjectInstance::Attributes::Mock02S1 < Rpersistence::ObjectInstance::Attributes::Mock02
      attr_non_persistent :attribute6,  :attribute7
      attr_non_atomic     :attribute2,  :attribute3
    end
    Rpersistence::ObjectInstance::Attributes::Mock02S1.atomic_attribute_accessors.sort.should  == [  :attribute1, :attribute4 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock02S1.new
    instance.atomic_attribute_accessors.sort.should == Rpersistence::ObjectInstance::Attributes::Mock02S1.atomic_attribute_accessors.sort
    instance.attr_atomic( :attribute7,  :attribute8 )
    instance.atomic_attribute_accessors.sort.should == [  :attribute1,  :attribute4,  :attribute7,  :attribute8 ].sort
  end

  ####################################
  #  Klass.atomic_attribute_readers  #
  #  atomic_attribute_readers        #
  ####################################

  it "can report which attributes have atomic readers" do
    class Rpersistence::ObjectInstance::Attributes::Mock03 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock03.atomic_attribute_readers.sort.should    == [   :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                                    :attribute5,  :attribute6,  :attribute7,  :attribute8 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock03.new
    instance.atomic_attribute_readers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock03.atomic_attribute_readers.sort
    class Rpersistence::ObjectInstance::Attributes::Mock03S1 < Rpersistence::ObjectInstance::Attributes::Mock03
      attr_non_atomic_reader  :attribute1,  :attribute2,  :attribute3,  :attribute4
    end
    Rpersistence::ObjectInstance::Attributes::Mock03S1.atomic_attribute_readers.sort.should  == [   :attribute5,  :attribute6,  :attribute7,  :attribute8 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock03S1.new
    instance.atomic_attribute_readers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock03S1.atomic_attribute_readers.sort
    instance.attr_non_atomic( :attribute7,  :attribute8 )
    instance.atomic_attribute_readers.sort.should == [  :attribute5,  :attribute6 ].sort
  end

  ####################################
  #  Klass.atomic_attribute_writers  #
  #  atomic_attribute_writers        #
  ####################################

  it "can report which attributes have atomic writers" do
    class Rpersistence::ObjectInstance::Attributes::Mock04 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock04.atomic_attribute_writers.sort.should    == [   :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                                    :attribute9,  :attribute10, :attribute11, :attribute12 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock04.new
    instance.atomic_attributes.sort.should == Rpersistence::ObjectInstance::Attributes::Mock04.atomic_attributes.sort
    class Rpersistence::ObjectInstance::Attributes::Mock04S1 < Rpersistence::ObjectInstance::Attributes::Mock04
      attr_non_atomic_writer  :attribute1,  :attribute2,  :attribute3,  :attribute4
    end
    Rpersistence::ObjectInstance::Attributes::Mock04S1.atomic_attribute_writers.sort.should  == [   :attribute9,  :attribute10, :attribute11, :attribute12 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock04S1.new
    instance.atomic_attribute_writers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock04S1.atomic_attribute_writers.sort
    instance.attr_non_atomic( :attribute9,  :attribute10 )
    instance.atomic_attribute_writers.sort.should == [  :attribute11, :attribute12 ].sort
  end

  #################################
  #  Klass.non_atomic_attributes  #
  #  non_atomic_attributes        #
  #################################

  it "can report which attributes are non-atomic (whether :accessor, :reader, or :writer)" do
    class Rpersistence::ObjectInstance::Attributes::Mock05 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock05.non_atomic_attributes.sort.should == [ :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                            :attribute17, :attribute18, :attribute19, :attribute20,
                                                                                            :attribute21 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock05.new
    instance.atomic_attributes.sort.should == Rpersistence::ObjectInstance::Attributes::Mock05.atomic_attributes.sort
    class Rpersistence::ObjectInstance::Attributes::Mock05S1 < Rpersistence::ObjectInstance::Attributes::Mock05
      attr_atomic         :attribute13, :attribute14, :attribute15, :attribute16
      attr_non_persistent :attribute17, :attribute18, :attribute19, :attribute20
    end
    Rpersistence::ObjectInstance::Attributes::Mock05S1.non_atomic_attributes.sort.should == [ :attribute21 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock05S1.new
    instance.non_atomic_attributes.sort.should == Rpersistence::ObjectInstance::Attributes::Mock05S1.non_atomic_attributes.sort
    instance.attr_non_atomic( :attribute13, :attribute14 )
    instance.non_atomic_attributes.sort.should == [ :attribute13, :attribute14, :attribute21 ].sort
  end

  ##########################################
  #  Klass.non_atomic_attribute_accessors  #
  #  non_atomic_attribute_accessors        #
  ##########################################

  it "can report which attributes have non-atomic accessors" do
    class Rpersistence::ObjectInstance::Attributes::Mock06 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock06.non_atomic_attribute_accessors.sort.should == [ :attribute13, :attribute14, :attribute15, :attribute16 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock06.new
    instance.non_atomic_attribute_accessors.sort.should == Rpersistence::ObjectInstance::Attributes::Mock06.non_atomic_attribute_accessors.sort
    class Rpersistence::ObjectInstance::Attributes::Mock06S1 < Rpersistence::ObjectInstance::Attributes::Mock06
      attr_non_atomic_reader  :attribute13, :attribute14
      attr_non_atomic         :attribute12
    end
    Rpersistence::ObjectInstance::Attributes::Mock06S1.non_atomic_attribute_accessors.sort.should == [ :attribute12, :attribute15, :attribute16 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock06S1.new
    instance.non_atomic_attribute_accessors.sort.should == Rpersistence::ObjectInstance::Attributes::Mock06S1.non_atomic_attribute_accessors.sort
    instance.attr_non_atomic( :attribute13, :attribute14 )
    instance.non_atomic_attribute_accessors.sort.should == [ :attribute12, :attribute13, :attribute14, :attribute15, :attribute16 ].sort
  end

  ########################################
  #  Klass.non_atomic_attribute_readers  #
  #  non_atomic_attribute_readers        #
  ########################################

  it "can report which attributes have non-atomic readers" do
    class Rpersistence::ObjectInstance::Attributes::Mock07 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock07.non_atomic_attribute_readers.sort.should == [  :attribute13, :attribute14, :attribute15, :attribute16, 
                                                                                                    :attribute17, :attribute18, :attribute19, :attribute20 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock07.new
    instance.non_atomic_attribute_readers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock07.non_atomic_attribute_readers.sort
    class Rpersistence::ObjectInstance::Attributes::Mock07S1 < Rpersistence::ObjectInstance::Attributes::Mock07
      attr_non_atomic_reader  :attribute21
      attr_non_persistent     :attribute17
      attr_atomic             :attribute18
    end
    Rpersistence::ObjectInstance::Attributes::Mock07S1.non_atomic_attribute_readers.sort.should == [  :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                                      :attribute19, :attribute20, :attribute21 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock07S1.new
    instance.non_atomic_attribute_readers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock07S1.non_atomic_attribute_readers.sort
    instance.attr_non_atomic( :attribute22, :attribute23 )
    instance.non_atomic_attribute_readers.sort.should == [  :attribute13, :attribute14, :attribute15, :attribute16, 
                                                            :attribute19, :attribute20, :attribute21, :attribute22, 
                                                            :attribute23 ].sort
  end

  ########################################
  #  Klass.non_atomic_attribute_writers  #
  #  non_atomic_attribute_writers        #
  ########################################

  it "can report which attributes have non-atomic writers" do
    class Rpersistence::ObjectInstance::Attributes::Mock08 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock08.non_atomic_attribute_writers.sort.should == [  :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                                    :attribute21 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock08.new
    instance.non_atomic_attribute_writers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock08.non_atomic_attribute_writers.sort
    class Rpersistence::ObjectInstance::Attributes::Mock08S1 < Rpersistence::ObjectInstance::Attributes::Mock08
      attr_atomic_writer      :attribute13, :attribute14
      attr_non_atomic_writer  :attribute1,  :attribute2
    end
    Rpersistence::ObjectInstance::Attributes::Mock08S1.non_atomic_attribute_writers.sort.should == [  :attribute1,  :attribute2,  :attribute15, :attribute16,
                                                                                                      :attribute21  ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock08S1.new
    instance.non_atomic_attribute_writers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock08S1.non_atomic_attribute_writers.sort
    instance.attr_atomic( :attribute15 )
    instance.non_atomic_attribute_writers.sort.should == [ :attribute1,  :attribute2, :attribute16,  :attribute21  ].sort    
  end

  #################################
  #  Klass.persistent_attributes  #
  #  persistent_attributes        #
  #################################

  it "can report which attributes are persistent (whether atomic or non-atomic)" do
    class Rpersistence::ObjectInstance::Attributes::Mock09 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock09.persistent_attributes.sort.should == [ :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                            :attribute5,  :attribute6,  :attribute7,  :attribute8,
                                                                                            :attribute9,  :attribute10, :attribute11, :attribute12,
                                                                                            :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                            :attribute17, :attribute18, :attribute19, :attribute20,
                                                                                            :attribute21 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock09.new
    instance.persistent_attributes.sort.should == Rpersistence::ObjectInstance::Attributes::Mock09.persistent_attributes.sort
    class Rpersistence::ObjectInstance::Attributes::Mock09S1 < Rpersistence::ObjectInstance::Attributes::Mock09
      attr_non_persistent         :attribute1,  :attribute2,  :attribute3,  :attribute4
      attr_non_persistent_reader  :attribute5,  :attribute6,  :attribute7,  :attribute8
    end
    Rpersistence::ObjectInstance::Attributes::Mock09S1.persistent_attributes.sort.should == [   :attribute9,  :attribute10, :attribute11, :attribute12,
                                                                                                :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                                :attribute17, :attribute18, :attribute19, :attribute20,
                                                                                                :attribute21 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock09S1.new
    instance.persistent_attributes.sort.should == Rpersistence::ObjectInstance::Attributes::Mock09S1.persistent_attributes.sort
    instance.attr_non_atomic( :attribute1, :attribute2 )
    instance.persistent_attributes.sort.should == [ :attribute1,  :attribute2,  :attribute9,  :attribute10, 
                                                    :attribute11, :attribute12, :attribute13, :attribute14, 
                                                    :attribute15, :attribute16, :attribute17, :attribute18, 
                                                    :attribute19, :attribute20, :attribute21 ].sort
  end

  ##########################################
  #  Klass.persistent_attribute_accessors  #
  #  persistent_attribute_accessors        #
  ##########################################

  it "can report which attributes have persistent accessors (whether atomic or non-atomic)" do
    class Rpersistence::ObjectInstance::Attributes::Mock10 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock10.persistent_attribute_accessors.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                                      :attribute13, :attribute14, :attribute15, :attribute16 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock10.new
    instance.persistent_attribute_accessors.sort.should == Rpersistence::ObjectInstance::Attributes::Mock10.persistent_attribute_accessors.sort
    class Rpersistence::ObjectInstance::Attributes::Mock10S1 < Rpersistence::ObjectInstance::Attributes::Mock10
      attr_non_atomic             :attribute1, :attribute2
      attr_atomic                 :attribute3, :attribute4
      attr_non_persistent_reader  :attribute5, :attribute6
      attr_non_persistent         :attribute11, :attribute12, :attribute13, :attribute14
    end
    Rpersistence::ObjectInstance::Attributes::Mock10S1.persistent_attribute_accessors.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                                        :attribute15, :attribute16 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock10S1.new
    instance.persistent_attribute_accessors.sort.should == Rpersistence::ObjectInstance::Attributes::Mock10S1.persistent_attribute_accessors.sort
    instance.attr_non_persistent( :attribute15, :attribute16 )
    instance.persistent_attribute_accessors.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4  ].sort
  end

  ########################################
  #  Klass.persistent_attribute_readers  #
  #  persistent_attribute_readers        #
  ########################################

  it "can report which attributes have persistent readers (whether atomic or non-atomic)" do
    class Rpersistence::ObjectInstance::Attributes::Mock11 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock11.persistent_attribute_readers.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                                    :attribute5,  :attribute6,  :attribute7,  :attribute8,
                                                                                                    :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                                    :attribute17, :attribute18, :attribute19, :attribute20 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock11.new
    instance.persistent_attribute_readers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock11.persistent_attribute_readers.sort
    class Rpersistence::ObjectInstance::Attributes::Mock11S1 < Rpersistence::ObjectInstance::Attributes::Mock11
      attr_non_atomic             :attribute1, :attribute2
      attr_atomic                 :attribute3, :attribute4
      attr_non_persistent_reader  :attribute5, :attribute6
      attr_non_persistent         :attribute11, :attribute12, :attribute13, :attribute14
    end
    Rpersistence::ObjectInstance::Attributes::Mock11S1.persistent_attribute_readers.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                                      :attribute7,  :attribute8,  :attribute15, :attribute16,
                                                                                                      :attribute17, :attribute18, :attribute19, :attribute20 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock11S1.new
    instance.persistent_attribute_readers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock11S1.persistent_attribute_readers.sort
    instance.attr_non_persistent_reader( :attribute1,  :attribute2,  :attribute3,  :attribute4 )
    instance.persistent_attribute_readers.sort.should == [  :attribute7,  :attribute8,  :attribute15, :attribute16,
                                                            :attribute17, :attribute18, :attribute19, :attribute20 ].sort
  end

  ########################################
  #  Klass.persistent_attribute_writers  #
  #  persistent_attribute_writers        #
  ########################################

  it "can report which attributes have persistent writers (whether atomic or non-atomic)" do
    class Rpersistence::ObjectInstance::Attributes::Mock12 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock12.persistent_attribute_writers.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                                    :attribute9,  :attribute10, :attribute11, :attribute12,
                                                                                                    :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                                    :attribute21 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock12.new
    instance.persistent_attribute_writers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock12.persistent_attribute_writers.sort
    class Rpersistence::ObjectInstance::Attributes::Mock12S1 < Rpersistence::ObjectInstance::Attributes::Mock12
      attr_non_persistent :attribute9,  :attribute10, :attribute11, :attribute12
    end
    Rpersistence::ObjectInstance::Attributes::Mock12S1.persistent_attribute_writers.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                                      :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                                      :attribute21  ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock12S1.new
    instance.persistent_attribute_writers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock12S1.persistent_attribute_writers.sort
    instance.attr_non_persistent( :attribute13, :attribute14 )
    instance.persistent_attribute_writers.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                            :attribute15, :attribute16, :attribute21 ].sort
  end

  #####################################
  #  Klass.non_persistent_attributes  #
  #  non_persistent_attributes        #
  #####################################

  it "can report which attributes are non-persistent" do
    class Rpersistence::ObjectInstance::Attributes::Mock13 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock13.non_persistent_attributes.sort.should == [ :attribute22, :attribute23, :attribute24, :attribute25,
                                                                                                :attribute9,  :attribute10, :attribute11, :attribute12,
                                                                                                :attribute5,  :attribute6,  :attribute7,  :attribute8 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock13.new
    instance.non_persistent_attributes.sort.should == Rpersistence::ObjectInstance::Attributes::Mock13.non_persistent_attributes.sort
    class Rpersistence::ObjectInstance::Attributes::Mock13S1 < Rpersistence::ObjectInstance::Attributes::Mock13
      attr_atomic :attribute9,  :attribute10, :attribute11, :attribute12
    end
    Rpersistence::ObjectInstance::Attributes::Mock13S1.non_persistent_attributes.sort.should == [   :attribute22, :attribute23, :attribute24, :attribute25,
                                                                                                    :attribute5,  :attribute6,  :attribute7,  :attribute8 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock13S1.new
    instance.non_persistent_attributes.sort.should == Rpersistence::ObjectInstance::Attributes::Mock13S1.non_persistent_attributes.sort
    instance.attr_non_atomic( :attribute22, :attribute23, :attribute24, :attribute25 )
    instance.non_persistent_attributes.sort.should == [  :attribute5,  :attribute6,  :attribute7,  :attribute8 ].sort
  end

  ##############################################
  #  Klass.non_persistent_attribute_accessors  #
  #  non_persistent_attribute_accessors        #
  ##############################################

  it "can report which attributes do not have persistent accessors" do
    class Rpersistence::ObjectInstance::Attributes::Mock14 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock14.non_persistent_attribute_accessors.sort.should == [ :attribute22, :attribute23, :attribute24, :attribute25 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock14.new
    instance.non_persistent_attribute_accessors.sort.should == Rpersistence::ObjectInstance::Attributes::Mock14.non_persistent_attribute_accessors.sort
    class Rpersistence::ObjectInstance::Attributes::Mock14S1 < Rpersistence::ObjectInstance::Attributes::Mock14
      attr_non_persistent :attribute5,  :attribute6,  :attribute7,  :attribute8
    end
    Rpersistence::ObjectInstance::Attributes::Mock14S1.non_persistent_attribute_accessors.sort.should == [  :attribute5,  :attribute6,  :attribute7,  :attribute8,
                                                                                                            :attribute22, :attribute23, :attribute24, :attribute25 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock14S1.new
    instance.non_persistent_attribute_accessors.sort.should == Rpersistence::ObjectInstance::Attributes::Mock14S1.non_persistent_attribute_accessors.sort
    instance.attr_atomic_reader( :attribute22, :attribute23 )
    instance.non_persistent_attribute_accessors.sort.should == [  :attribute5,  :attribute6,  :attribute7,  :attribute8,
                                                                  :attribute24, :attribute25 ].sort
  end

  ############################################
  #  Klass.non_persistent_attribute_readers  #
  #  non_persistent_attribute_readers        #
  ############################################

  it "can report which attributes do not have persistent readers" do
    class Rpersistence::ObjectInstance::Attributes::Mock15 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock15.non_persistent_attribute_readers.sort.should == [ :attribute22, :attribute23, :attribute24, :attribute25,
                                                                                                       :attribute9,  :attribute10, :attribute11, :attribute12 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock15.new
    instance.non_persistent_attribute_readers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock15.non_persistent_attribute_readers.sort
    class Rpersistence::ObjectInstance::Attributes::Mock15S1 < Rpersistence::ObjectInstance::Attributes::Mock15
      attr_non_persistent_reader :attribute5,  :attribute6,  :attribute7,  :attribute8
    end
    Rpersistence::ObjectInstance::Attributes::Mock15S1.non_persistent_attribute_readers.sort.should == [  :attribute5,  :attribute6,  :attribute7,  :attribute8,
                                                                                                          :attribute22, :attribute23, :attribute24, :attribute25,
                                                                                                          :attribute9,  :attribute10, :attribute11, :attribute12 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock15S1.new
    instance.non_persistent_attribute_readers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock15S1.non_persistent_attribute_readers.sort
    instance.attr_non_atomic_reader( :attribute11, :attribute12 )
    instance.non_persistent_attribute_readers.sort.should == [  :attribute5,  :attribute6,  :attribute7,  :attribute8,
                                                                :attribute22, :attribute23, :attribute24, :attribute25,
                                                                :attribute9,  :attribute10  ].sort
  end

  ############################################
  #  Klass.non_persistent_attribute_writers  #
  #  non_persistent_attribute_writers        #
  ############################################

  it "can report which attributes do not have persistent writers" do
    class Rpersistence::ObjectInstance::Attributes::Mock16 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock16.non_persistent_attribute_writers.sort.should == [  :attribute22, :attribute23, :attribute24, :attribute25,
                                                                                                        :attribute5,  :attribute6,  :attribute7,  :attribute8 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock16.new
    instance.non_persistent_attribute_writers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock16.non_persistent_attribute_writers.sort
    class Rpersistence::ObjectInstance::Attributes::Mock16S1 < Rpersistence::ObjectInstance::Attributes::Mock16
      attr_atomic_writer  :attribute5,  :attribute6
    end
    Rpersistence::ObjectInstance::Attributes::Mock16S1.non_persistent_attribute_writers.sort.should == [  :attribute22, :attribute23, :attribute24, :attribute25,
                                                                                                          :attribute7,  :attribute8  ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock16S1.new
    instance.non_persistent_attribute_writers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock16S1.non_persistent_attribute_writers.sort
    instance.attr_non_atomic_writer(  :attribute22 )
    instance.non_persistent_attribute_writers.sort.should == [  :attribute23, :attribute24, :attribute25, :attribute7,
                                                                :attribute8 ].sort
  end

  ###############################
  #  Klass.included_attributes  #
  #  included_attributes        #
  ###############################

  it "can report which attributes are explicitly included" do
    class Rpersistence::ObjectInstance::Attributes::Mock17 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock17.included_attributes.sort.should == [ :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                          :attribute5,  :attribute6,  :attribute7,  :attribute8,
                                                                                          :attribute9,  :attribute10, :attribute11, :attribute12,
                                                                                          :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                          :attribute17, :attribute18, :attribute19, :attribute20,
                                                                                          :attribute21 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock17.new
    instance.included_attributes.sort.should == Rpersistence::ObjectInstance::Attributes::Mock17.included_attributes.sort
    class Rpersistence::ObjectInstance::Attributes::Mock17S1 < Rpersistence::ObjectInstance::Attributes::Mock17
      attr_non_persistent :attribute17, :attribute18, :attribute19, :attribute20
    end
    Rpersistence::ObjectInstance::Attributes::Mock17S1.included_attributes.sort.should == [ :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                            :attribute5,  :attribute6,  :attribute7,  :attribute8,
                                                                                            :attribute9,  :attribute10, :attribute11, :attribute12,
                                                                                            :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                            :attribute21  ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock17S1.new
    instance.included_attributes.sort.should == Rpersistence::ObjectInstance::Attributes::Mock17S1.included_attributes.sort
    instance.attr_non_persistent( :attribute21 )
    instance.included_attributes.sort.should == [ :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                  :attribute5,  :attribute6,  :attribute7,  :attribute8,
                                                  :attribute9,  :attribute10, :attribute11, :attribute12,
                                                  :attribute13, :attribute14, :attribute15, :attribute16  ].sort
  end

  ########################################
  #  Klass.included_attribute_accessors  #
  #  included_attribute_accessors        #
  ########################################

  it "can report which attributes are explicitly included as accessors" do
    class Rpersistence::ObjectInstance::Attributes::Mock18 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock18.included_attribute_accessors.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                                    :attribute13, :attribute14, :attribute15, :attribute16 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock18.new
    instance.included_attribute_accessors.sort.should == Rpersistence::ObjectInstance::Attributes::Mock18.included_attribute_accessors.sort
    class Rpersistence::ObjectInstance::Attributes::Mock18S1 < Rpersistence::ObjectInstance::Attributes::Mock18
      attr_atomic :attribute5
    end
    Rpersistence::ObjectInstance::Attributes::Mock18S1.included_attribute_accessors.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                                      :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                                      :attribute5  ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock18S1.new
    instance.included_attribute_accessors.sort.should == Rpersistence::ObjectInstance::Attributes::Mock18S1.included_attribute_accessors.sort
    instance.attr_non_persistent_reader( :attribute16 )
    instance.included_attribute_accessors.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                            :attribute13, :attribute14, :attribute15, :attribute5 ].sort
  end

  ######################################
  #  Klass.included_attribute_readers  #
  #  included_attribute_readers        #
  ######################################

  it "can report which attributes are explicitly included as readers" do
    class Rpersistence::ObjectInstance::Attributes::Mock19 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock19.included_attribute_readers.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                                  :attribute5,  :attribute6,  :attribute7,  :attribute8,
                                                                                                  :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                                  :attribute17, :attribute18, :attribute19, :attribute20 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock19.new
    instance.included_attribute_readers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock19.included_attribute_readers.sort
    class Rpersistence::ObjectInstance::Attributes::Mock19S1 < Rpersistence::ObjectInstance::Attributes::Mock19
      attr_atomic_reader    :attribute21
    end
    Rpersistence::ObjectInstance::Attributes::Mock19S1.included_attribute_readers.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                                    :attribute5,  :attribute6,  :attribute7,  :attribute8,
                                                                                                    :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                                    :attribute17, :attribute18, :attribute19, :attribute20,
                                                                                                    :attribute21  ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock19S1.new
    instance.included_attribute_readers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock19S1.included_attribute_readers.sort
    instance.attr_non_persistent( :attribute17 )
    instance.included_attribute_readers.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                          :attribute5,  :attribute6,  :attribute7,  :attribute8,
                                                          :attribute13, :attribute14, :attribute15, :attribute16,
                                                          :attribute18, :attribute19, :attribute20, :attribute21  ].sort
  end

  ######################################
  #  Klass.included_attribute_writers  #
  #  included_attribute_writers        #
  ######################################

  it "can report which attributes are explicitly included as writers" do
    class Rpersistence::ObjectInstance::Attributes::Mock20 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock20.included_attribute_writers.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                                  :attribute9,  :attribute10, :attribute11, :attribute12,
                                                                                                  :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                                  :attribute21 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock20.new
    instance.included_attribute_writers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock20.included_attribute_writers.sort
    class Rpersistence::ObjectInstance::Attributes::Mock20S1 < Rpersistence::ObjectInstance::Attributes::Mock20
      attr_atomic_reader    :attribute5,  :attribute6,  :attribute7,  :attribute8
    end
    Rpersistence::ObjectInstance::Attributes::Mock20S1.included_attribute_writers.sort.should == [  :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                                    :attribute9,  :attribute10, :attribute11, :attribute12,
                                                                                                    :attribute13, :attribute14, :attribute15, :attribute16,
                                                                                                    :attribute21  ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock20S1.new
    instance.included_attribute_writers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock20S1.included_attribute_writers.sort
    instance.attr_non_persistent_writer( :attribute5,  :attribute6 )
    instance.included_attribute_writers.sort.should == [ :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                         :attribute9,  :attribute10, :attribute11, :attribute12,
                                                         :attribute13, :attribute14, :attribute15, :attribute16,
                                                         :attribute21  ].sort
  end

  ###############################
  #  Klass.excluded_attributes  #
  #  excluded_attributes        #
  ###############################

  it "can report which attributes are explicitly excluded" do
    class Rpersistence::ObjectInstance::Attributes::Mock21 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock21.excluded_attributes.sort.should == [ :attribute22, :attribute23, :attribute24, :attribute25,
                                                                                          :attribute9,  :attribute10, :attribute11, :attribute12,
                                                                                          :attribute5,  :attribute6,  :attribute7,  :attribute8 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock21.new
    instance.excluded_attributes.sort.should == Rpersistence::ObjectInstance::Attributes::Mock21.excluded_attributes.sort
    class Rpersistence::ObjectInstance::Attributes::Mock21S1 < Rpersistence::ObjectInstance::Attributes::Mock21
      attr_non_persistent_writer  :attribute1,  :attribute2,  :attribute3,  :attribute4
    end
    Rpersistence::ObjectInstance::Attributes::Mock21S1.excluded_attributes.sort.should == [ :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                                                            :attribute22, :attribute23, :attribute24, :attribute25,
                                                                                            :attribute9,  :attribute10, :attribute11, :attribute12,
                                                                                            :attribute5,  :attribute6,  :attribute7,  :attribute8  ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock21S1.new
    instance.excluded_attributes.sort.should == Rpersistence::ObjectInstance::Attributes::Mock21S1.excluded_attributes.sort
    instance.attr_non_atomic( :attribute7,  :attribute8 )
    instance.excluded_attributes.sort.should == [ :attribute1,  :attribute2,  :attribute3,  :attribute4,
                                                  :attribute22, :attribute23, :attribute24, :attribute25,
                                                  :attribute9,  :attribute10, :attribute11, :attribute12,
                                                  :attribute5,  :attribute6  ].sort
  end

  ########################################
  #  Klass.excluded_attribute_accessors  #
  #  excluded_attribute_accessors        #
  ########################################

  it "can report which attributes are explicitly excluded as accessors" do
    class Rpersistence::ObjectInstance::Attributes::Mock22 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock22.excluded_attribute_accessors.sort.should == [ :attribute22, :attribute23, :attribute24, :attribute25 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock22.new
    instance.excluded_attribute_accessors.sort.should == Rpersistence::ObjectInstance::Attributes::Mock22.excluded_attribute_accessors.sort
    class Rpersistence::ObjectInstance::Attributes::Mock22S1 < Rpersistence::ObjectInstance::Attributes::Mock22
      attr_atomic :attribute22, :attribute23
    end
    Rpersistence::ObjectInstance::Attributes::Mock22S1.excluded_attribute_accessors.sort.should == [  :attribute24, :attribute25 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock22S1.new
    instance.excluded_attribute_accessors.sort.should == Rpersistence::ObjectInstance::Attributes::Mock22S1.excluded_attribute_accessors.sort
    instance.attr_atomic_writer( :attribute23 )
    instance.excluded_attribute_accessors.sort.should == [ :attribute24, :attribute25  ].sort
  end
  
  ######################################
  #  Klass.excluded_attribute_readers  #
  #  excluded_attribute_readers        #
  ######################################

  it "can report which attributes are explicitly excluded as readers" do
    class Rpersistence::ObjectInstance::Attributes::Mock23 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock23.excluded_attribute_readers.sort.should == [  :attribute22, :attribute23, :attribute24, :attribute25,
                                                                                                  :attribute9,  :attribute10, :attribute11, :attribute12 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock23.new
    instance.excluded_attribute_readers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock23.excluded_attribute_readers.sort
    class Rpersistence::ObjectInstance::Attributes::Mock23S1 < Rpersistence::ObjectInstance::Attributes::Mock23
      attr_atomic :attribute22, :attribute23
    end
    Rpersistence::ObjectInstance::Attributes::Mock23S1.excluded_attribute_readers.sort.should == [  :attribute24, :attribute25, :attribute9,  :attribute10, 
                                                                                                    :attribute11, :attribute12  ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock23S1.new
    instance.excluded_attribute_readers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock23S1.excluded_attribute_readers.sort
    instance.attr_non_persistent( :attribute22, :attribute23 )
    instance.excluded_attribute_readers.sort.should == [  :attribute22, :attribute23, :attribute24, :attribute25,
                                                          :attribute9,  :attribute10, :attribute11, :attribute12 ].sort
  end

  ######################################
  #  Klass.excluded_attribute_writers  #
  #  excluded_attribute_writers        #
  ######################################

  it "can report which attributes are explicitly excluded as writers" do
    class Rpersistence::ObjectInstance::Attributes::Mock24 < Rpersistence::ObjectInstance::Attributes::Mock
    end
    Rpersistence::ObjectInstance::Attributes::Mock24.excluded_attribute_writers.sort.should == [  :attribute22, :attribute23, :attribute24, :attribute25,
                                                                                                  :attribute5,  :attribute6,  :attribute7,  :attribute8 ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock24.new
    instance.excluded_attribute_writers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock24.excluded_attribute_writers.sort
    class Rpersistence::ObjectInstance::Attributes::Mock24S1 < Rpersistence::ObjectInstance::Attributes::Mock24
      attr_atomic :attribute5,  :attribute6
    end
    Rpersistence::ObjectInstance::Attributes::Mock24S1.excluded_attribute_writers.sort.should == [  :attribute22, :attribute23, :attribute24, :attribute25,
                                                                                                    :attribute7,  :attribute8  ].sort
    instance = Rpersistence::ObjectInstance::Attributes::Mock24S1.new
    instance.excluded_attribute_writers.sort.should == Rpersistence::ObjectInstance::Attributes::Mock24S1.excluded_attribute_writers.sort
    instance.attr_non_atomic( :attribute22, :attribute23 )
    instance.excluded_attribute_writers.sort.should == [  :attribute24, :attribute25, :attribute7,  :attribute8 ].sort
  end
  
end
