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

cd $RPERSISTENCE
gem build rpersistence.gemspec
mv rpersistence*.gem $GEMS/

cd $RPERSISTENCE_PORT
gem build rpersistence-port.gemspec
mv rpersistence-port*.gem $GEMS/

cd $RPERSISTENCE_PORT_INDEXING
gem build rpersistence-port-indexing.gemspec
mv rpersistence-port-indexing*.gem $GEMS/

cd $RPERSISTENCE_CURSOR
gem build rpersistence-cursor.gemspec
mv rpersistence-cursor*.gem $GEMS/

cd $RPERSISTENCE_CURSOR_INDEXING
gem build rpersistence-cursor-indexing.gemspec
mv rpersistence-cursor-indexing*.gem $GEMS/

cd $RPERSISTENCE_OBJECT
gem build rpersistence-object.gemspec
mv rpersistence-object*.gem $GEMS/

cd $RPERSISTENCE_OBJECT_INDEXING
gem build rpersistence-object-indexing.gemspec
mv rpersistence-object-indexing*.gem $GEMS/

cd $RPERSISTENCE_FLAT
gem build rpersistence-object-flat.gemspec
mv rpersistence-object-flat*.gem $GEMS/

cd $RPERSISTENCE_FLAT_INDEXING
gem build rpersistence-object-flat-indexing.gemspec
mv rpersistence-object-flat-indexing*.gem $GEMS/

cd $RPERSISTENCE_COMPLEX
gem build rpersistence-object-complex.gemspec
mv rpersistence-object-complex*.gem $GEMS/

cd $RPERSISTENCE_COMPLEX_INDEXING
gem build rpersistence-object-complex-indexing.gemspec
mv rpersistence-object-complex-indexing*.gem $GEMS/

cd $RPERSISTENCE_ADAPTER_ABSTRACT
gem build rpersistence-adapter-abstract.gemspec
mv rpersistence-adapter-abstract*.gem $GEMS/

cd $RPERSISTENCE_ADAPTER_ABSTRACT_FLAT_FILE
gem build rpersistence-adapter-abstract-flat-file.gemspec
mv rpersistence-adapter-abstract-flat-file*.gem $GEMS/

cd $RPERSISTENCE_ADAPTER_MOCK
gem build rpersistence-adapter-mock.gemspec
mv rpersistence-adapter-mock*.gem $GEMS/

cd $RPERSISTENCE_ADAPTER_MARSHAL_FLAT_FILE
gem build rpersistence-adapter-marshal-flat-file.gemspec
mv rpersistence-adapter-marshal-flat-file*.gem $GEMS/

cd $RPERSISTENCE_ADAPTER_YAML_FLAT_FILE
gem build rpersistence-adapter-yaml-flat-file.gemspec
mv rpersistence-adapter-yaml-flat-file*.gem $GEMS/

cd $RPERSISTENCE_ADAPTER_KYOTOCABINET
gem build rpersistence-adapter-kyotocabinet.gemspec
mv rpersistence-adapter-kyotocabinet*.gem $GEMS/

cd $ROOTDIR
