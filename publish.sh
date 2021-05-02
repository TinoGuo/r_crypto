#!/bin/bash

if [ "$1" == 'true' ]; then
  echo start copy
  cp rust/target/x86_64-apple-darwin/release/librcrypto.dylib macos/librcrypto.dylib
  echo end copy
  flutter pub publish -f
else
  flutter pub publish --dry-run
fi