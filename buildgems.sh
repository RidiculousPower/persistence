#!/bin/bash

ROOTDIR=$PWD
GEMS=$ROOTDIR/gems/

RPERSISTENCE=$ROOTDIR

RPERSISTENCE_PORT=$RPERSISTENCE/port
RPERSISTENCE_PORT_INDEXING=$RPERSISTENCE_PORT/indexing

RPERSISTENCE_CURSOR=$RPERSISTENCE/cursor
RPERSISTENCE_CURSOR_INDEXING=$RPERSISTENCE_CURSOR/indexing

RPERSISTENCE_OBJECT=$RPERSISTENCE/object
RPERSISTENCE_OBJECT_INDEXING=$RPERSISTENCE_OBJECT/indexing
RPERSISTENCE_FLAT=$RPERSISTENCE_OBJECT/flat
RPERSISTENCE_FLAT_INDEXING=$RPERSISTENCE_FLAT/indexing
RPERSISTENCE_COMPLEX=$RPERSISTENCE_OBJECT/complex
RPERSISTENCE_COMPLEX_INDEXING=$RPERSISTENCE_COMPLEX/indexing

RPERSISTENCE_ADAPTERS=$RPERSISTENCE/adapters
RPERSISTENCE_ADAPTER_ABSTRACT=$RPERSISTENCE_ADAPTERS/abstract
RPERSISTENCE_ADAPTER_ABSTRACT_FLAT_FILE=$RPERSISTENCE_ADAPTER_ABSTRACT/flat-file
RPERSISTENCE_ADAPTER_MOCK=$RPERSISTENCE_ADAPTERS/mock
RPERSISTENCE_ADAPTER_MARSHAL_FLAT_FILE=$RPERSISTENCE_ADAPTERS/marshal/flat-file
RPERSISTENCE_ADAPTER_YAML_FLAT_FILE=$RPERSISTENCE_ADAPTERS/yaml/flat-file
RPERSISTENCE_ADAPTER_KYOTOCABINET=$RPERSISTENCE_ADAPTERS/kyotocabinet
RPERSISTENCE_ADAPTER_KYOTOCABINET_MARSHAL=$RPERSISTENCE_ADAPTER_KYOTOCABINET/marshal

cd $RPERSISTENCE
gem build persistence.gemspec
mv persistence*.gem $GEMS/

cd $RPERSISTENCE_PORT
gem build persistence-port.gemspec
mv persistence-port*.gem $GEMS/

cd $RPERSISTENCE_PORT_INDEXING
gem build persistence-port-indexing.gemspec
mv persistence-port-indexing*.gem $GEMS/

cd $RPERSISTENCE_CURSOR
gem build persistence-cursor.gemspec
mv persistence-cursor*.gem $GEMS/

cd $RPERSISTENCE_CURSOR_INDEXING
gem build persistence-cursor-indexing.gemspec
mv persistence-cursor-indexing*.gem $GEMS/

cd $RPERSISTENCE_OBJECT
gem build persistence-object.gemspec
mv persistence-object*.gem $GEMS/

cd $RPERSISTENCE_OBJECT_INDEXING
gem build persistence-object-indexing.gemspec
mv persistence-object-indexing*.gem $GEMS/

cd $RPERSISTENCE_FLAT
gem build persistence-object-flat.gemspec
mv persistence-object-flat*.gem $GEMS/

cd $RPERSISTENCE_FLAT_INDEXING
gem build persistence-object-flat-indexing.gemspec
mv persistence-object-flat-indexing*.gem $GEMS/

cd $RPERSISTENCE_COMPLEX
gem build persistence-object-complex.gemspec
mv persistence-object-complex*.gem $GEMS/

cd $RPERSISTENCE_COMPLEX_INDEXING
gem build persistence-object-complex-indexing.gemspec
mv persistence-object-complex-indexing*.gem $GEMS/

cd $RPERSISTENCE_ADAPTER_ABSTRACT
gem build persistence-adapter-abstract.gemspec
mv persistence-adapter-abstract*.gem $GEMS/

cd $RPERSISTENCE_ADAPTER_ABSTRACT_FLAT_FILE
gem build persistence-adapter-abstract-flat-file.gemspec
mv persistence-adapter-abstract-flat-file*.gem $GEMS/

cd $RPERSISTENCE_ADAPTER_MOCK
gem build persistence-adapter-mock.gemspec
mv persistence-adapter-mock*.gem $GEMS/

cd $RPERSISTENCE_ADAPTER_MARSHAL_FLAT_FILE
gem build persistence-adapter-marshal-flat-file.gemspec
mv persistence-adapter-marshal-flat-file*.gem $GEMS/

cd $RPERSISTENCE_ADAPTER_YAML_FLAT_FILE
gem build persistence-adapter-yaml-flat-file.gemspec
mv persistence-adapter-yaml-flat-file*.gem $GEMS/

cd $RPERSISTENCE_ADAPTER_KYOTOCABINET
gem build persistence-adapter-kyotocabinet.gemspec
mv persistence-adapter-kyotocabinet*.gem $GEMS/

cd $RPERSISTENCE_ADAPTER_KYOTOCABINET_MARSHAL
gem build persistence-adapter-kyotocabinet-marshal.gemspec
mv persistence-adapter-kyotocabinet-marshal*.gem $GEMS/

cd $ROOTDIR
