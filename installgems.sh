#!/bin/bash

cd gems

sudo gem install ./rpersistence-port-0*.gem
sudo gem install ./rpersistence-port-indexing-0*.gem

sudo gem install ./rpersistence-cursor-0*.gem
sudo gem install ./rpersistence-cursor-indexing-0*.gem

sudo gem install ./rpersistence-object-0*.gem
sudo gem install ./rpersistence-object-indexing-0*.gem

sudo gem install ./rpersistence-object-flat-0*.gem
sudo gem install ./rpersistence-object-flat-indexing-0*.gem

sudo gem install ./rpersistence-object-complex-0*.gem
sudo gem install ./rpersistence-object-complex-indexing-0*.gem

sudo gem install ./rpersistence-adapter-abstract-0*.gem
sudo gem install ./rpersistence-adapter-abstract-flat-file-0*.gem
sudo gem install ./rpersistence-adapter-mock-0*.gem
sudo gem install ./rpersistence-adapter-marshal-flat-file-0*.gem
sudo gem install ./rpersistence-adapter-yaml-flat-file-0*.gem
sudo gem install ./rpersistence-adapter-kyotocabinet-0*.gem
sudo gem install ./rpersistence-adapter-kyotocabinet-marshal-0*.gem

sudo gem install ./rpersistence-0*.gem

cd ..
