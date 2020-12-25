#!/usr/bin/env bash

echo "Installing ruby..."
rbenv install 2.7.2
rbenv install 3.0.0 
rbenv global 3.0.0

gem install bundler foreman middleman rails irbtools amazing_print pry
