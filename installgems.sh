#!/bin/bash

cd gems

sudo gem install ./persistence-port-0*.gem
sudo gem install ./persistence-port-indexing-0*.gem

sudo gem install ./persistence-cursor-0*.gem
sudo gem install ./persistence-cursor-indexing-0*.gem

sudo gem install ./persistence-object-0*.gem
sudo gem install ./persistence-object-indexing-0*.gem

sudo gem install ./persistence-object-flat-0*.gem
sudo gem install ./persistence-object-flat-indexing-0*.gem

sudo gem install ./persistence-object-complex-0*.gem
sudo gem install ./persistence-object-complex-indexing-0*.gem

sudo gem install ./persistence-adapter-abstract-0*.gem
sudo gem install ./persistence-adapter-abstract-flat-file-0*.gem
sudo gem install ./persistence-adapter-mock-0*.gem
sudo gem install ./persistence-adapter-marshal-flat-file-0*.gem
sudo gem install ./persistence-adapter-yaml-flat-file-0*.gem
sudo gem install ./persistence-adapter-kyotocabinet-0*.gem
sudo gem install ./persistence-adapter-kyotocabinet-marshal-0*.gem

sudo gem install ./persistence-0*.gem

cd ..
