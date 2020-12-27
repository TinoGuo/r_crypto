#!/bin/bash

if [ "$1" == 'true' ]; then
  cd rust && make all
  cd ..
  echo start copy
  cp rust/target/x86_64-apple-darwin/release/librcrypto.dylib macos/librcrypto.dylib
  echo end copy
  flutter pub publish
else
  flutter pub publish --dry-run
fi