#!/bin/bash

gem build rpersistence.gemspec
gem build port/rpersistence-port.gemspec
gem build port/indexing/rpersistence-port-indexing.gemspec
gem build persistence/cursor/rpersistence-persistence-cursor.gemspec
gem build persistence/cursor/indexing/rpersistence-persistence-cursor-indexing.gemspec
gem build persistence/object/rpersistence-persistence-object.gemspec
gem build persistence/object/indexing/rpersistence-persistence-object-indexing.gemspec
gem build persistence/flat/rpersistence-persistence-flat.gemspec
gem build persistence/flat/indexing/rpersistence-persistence-flat-indexing.gemspec
gem build persistence/complex/rpersistence-persistence-complex.gemspec
gem build persistence/complex/indexing/rpersistence-persistence-complex-indexing.gemspec
gem build adapters/abstract/rpersistence-adapters-abstract.gemspec
gem build adapters/abstract/flat_file/rpersistence-adapters-abstract-flat-file.gemspec
gem build adapters/marshal/flat-file/rpersistence-adapters-marshal-flat-file.gemspec
gem build adapters/yaml/flat-file/rpersistence-adapters-yaml-flat-file.gemspec
gem build adapters/kyotocabinet/rpersistence-adapters-kyotocabinet.gemspec

