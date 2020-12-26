#!/bin/bash

if [ "$1" == 'true' ]; then
  cd rust && make all
  cd .. && flutter pub publish
else
  flutter pub publish --dry-run
fi