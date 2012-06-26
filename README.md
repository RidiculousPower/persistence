# Persistence #

http://rubygems.org/gems/persistence

# Summary #

Persistence layer designed to take advantage of Ruby's object model. The back-end is abstracted so that many different adapters can be created.

# Description #

Store and retrieve Ruby objects without thinking twice about how they are stored. Designed for maximum in flexibility and intuitive interface.

# Install #

Persistence is broken into the core 'persistence' gem and additional adapters. Persistence provides the Ruby interface, adapters provide the storage implementation.

## Pre-Beta Warning ##

This code is very early pre-beta non-production code. It *should* be near production ready but is offered with no promises. 

If you find something broken, **please submit a failing test or code snippet and we will work on getting it fixed as soon as possible**.

## Persistence ##

* sudo gem install persistence

## Adapters ##

The persistence gem has a single "Mock" adapter built in. It also has abstract interfaces to assist in creating new adapters.

To actually use Persistence you will want to install a real adapter. Currently, two are available:

* <a href="https://rubygems.org/gems/persistence-adapter-kyotocabinet">KyotoCabinet Adapter</a> (<a href="https://github.com/RidiculousPower/persistence-adapter-kyotocabinet">on GitHub</a>).
* <a href="https://rubygems.org/gems/persistence-adapter-flat_file">Flat File Adapter</a> (<a href="https://github.com/RidiculousPower/persistence-adapter-flat_file">on GitHub</a>).

# Usage #

## Before Anything Else ##

Enable a port with an adapter:

```ruby
adapter_instance = Persistence::Adapter::Mock.new
port_name = :some_port

Persistence.enable_port( port_name, adapter_instance )
```

## The Basics ##

Enable a class for persistence:

```ruby
require 'persistence'

class SomeClass
  include Persistence
end
```

Declare persistent properties:

```ruby
class SomeClass

  # non-atomic properties will only update when explicitly told to do so via :persist!
  attr_non_atomic_accessor :name, :some_non_atomic_property, :some_other_non_atomic_property

  # atomic properties will update as they change
  attr_atomic_accessor :some_atomic_property, :some_other_atomic_property

end
```

Assign some data to our object. First, symbols and string (or other basic types):

```ruby
object = SomeClass.new
object.name = :some_name

# Basic "flat" objects can be stored without declaring anything else
object.some_non_atomic_property = 'some string'
```

But let's also try out storing nested objects:

```ruby
# Other objects need to be enabled for persistence:
class SomeOtherClass
  include Persistence
  attr_atomic_accessor :some_atomic_property
end

object.some_other_non_atomic_property = SomeOtherClass.new
```

Now we want to store the object data for the first time:

```ruby
# Call :persist! to get our Object Persistence ID and store non-atomic data.
object.persist!
```

Once we have our Object Persistence ID atomic data will be instantly updated in the storage port as it changes.

At this point we can get a second copy of our object from the storage port:

```ruby
# Retrieving by Object Persistence ID isn't very useful, but we start with it for the basics
object_copy = SomeClass.persist( object.persistence_id )

# object_copy.should == object
# object_copy.name.should == object.name
# object_copy.some_non_atomic_property.should == object.some_non_atomic_property
# object_copy.some_other_non_atomic_property.should == object.some_other_non_atomic_property
# object_copy.some_atomic_property.should == object.some_atomic_property
# object_copy.some_other_atomic_property.should == object.some_other_atomic_property
```

Non-atomic properties do not update until :persist! is called:

```ruby
object.some_non_atomic_property = 'some other string'
# object_copy.some_non_atomic_property.should_not == object.some_non_atomic_property
```

Atomic properties update immediately (as long as object has a Persistence ID):

```ruby
object.some_atomic_property = 'some value'
# object_copy.some_atomic_property.should == object.some_atomic_property

object.some_other_atomic_property = SomeOtherClass.new
# object_copy.some_other_atomic_property.should == object.some_other_atomic_property
```

## Indexes ##

We could retrieve our object simply by its Object Persistence ID (a unique identifier created for each object), but most likely we will want to retrieve the object by way of some arbitrary descriptor (for instance a username).

To do this, we declare an index. 

There are three types of indexes on objects: explicit indexes, block indexes, and attribute indexes. There is also a fourth type of index - the bucket index - but it is really just a block index owned by a bucket instead of by an object.

Once we have an indexed key, the object is retrieved in the same way regardless of index type:

```ruby
# if we already have an index called :name with an indexed value :some_name then we can retrieve the object:
object_copy = SomeClass.persist( :name, :some_name )
```

Indexes can be unique or permit duplicates. They can be unordered or ordered. Ordered indexes are only partially implemented at this point and will be available soon.

Unique indexes will throw an exception in the event a duplicate would be created.

### Explicit Indexes ###

Explicit indexes require that a key be provided explicitly. Any number of keys can refer to the same object.

```ruby
class SomeClass
  explicit_index :name
end

object = SomeClass.new
object.name = :some_name
object.some_atomic_property = :some_value
object.persist!( :name, object.name )

object_copy = SomeClass.persist( :name, :some_value )
```

### Block Indexes ###

Block indexes take a block, which they then run on each object in order to generate index key(s).

```ruby
class SomeClass
  block_index :name do |object|
    object.name
  end
end

object = SomeClass.new
object.name = :some_name
object.some_atomic_property = :some_value
object.persist!

object_copy = SomeClass.persist( :name, :some_value )
```

### Attribute Indexes ###

Attribute indexes refer to a getter/setter method on the object. This operates on the same principle as Ruby's attr_accessor.

```ruby
class SomeClass
  attr_index :name
end

object = SomeClass.new
object.name = :some_name
object.some_atomic_property = :some_value
object.persist!

object_copy = SomeClass.persist( :name, :some_value )
```

### Bucket Indexes ###

Bucket indexes are block indexes owned by a bucket instead of an object. This permits multiple object types to be stored in the same bucket and to be indexed by the same block.

```ruby
class SomeClass
  instance_persistence_bucket.create_index( :name ) do |object|
    object.name
  end
end

object = SomeClass.new
object.name = :some_name
object.some_atomic_property = :some_value
object.persist!

object_copy = SomeClass.persist( :name, :some_value )
```

# Outline of General Premises #

## Storage Ports and Adapters ##

* Storage is managed by a "port"
* Objects are stored in "buckets" owned by the port.
* Objects are stored by unique Global ID, which can be anything other than a {::Hash}. Currently adapters use {::Integer}s for Global IDs.
* Objects can be indexed, which allows any object to be used as a reference to the primary storage of the object's properties (by Global ID).
* Actual storage is provided by an "adapter", which implements the specific terms by which data is stored (ie a database, in files, etc.).

## Classes and Instances ##

* Persistence-enabled Classes act as controllers for their instances.
* Data storage takes place through instances.
* Data retrieval takes place through Class singleton.

## Properties ##

* Properties are either atomic or non-atomic.
* Objects can be nested to any degree.

# License #

  (The MIT License)

  Copyright (c) 2012, Asher, Ridiculous Power

  Permission is hereby granted, free of charge, to any person obtaining
  a copy of this software and associated documentation files (the
  'Software'), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
