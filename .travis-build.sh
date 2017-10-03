#!/bin/bash
ROOT=$TRAVIS_BUILD_DIR/..

# Required argument $1 is one of:
#   formatter, interning, lock, nullness, regex, signature, nothing


# Fail the whole script if any command fails
set -e

## Short version, intended to be used when triggering downstream Travis jobs.
echo "Should next trigger downstream jobs."
true

## Build Checker Framework
(cd $ROOT && git clone --depth 1 https://github.com/typetools/checker-framework.git)
# This also builds annotation-tools and jsr308-langtools
(cd $ROOT/checker-framework/ && ./.travis-build-without-test.sh downloadjdk)
export CHECKERFRAMEWORK=$ROOT/checker-framework

## Obtain guava
(cd $ROOT && git clone --depth 1 https://github.com/smillst/guava.git

if [[ "$1" == "formatter" ]]; then
  (cd guava/guava && maven compile -Dcheckerframework.annotationprocessors=org.checkerframework.checker.formatter.FormatterChecker)
elif [[ "$1" == "interning" ]]; then
  (cd guava/guava && maven compile -Dcheckerframework.annotationprocessors=org.checkerframework.checker.interning.InterningChecker)
elif [[ "$1" == "lock" ]]; then
  (cd guava/guava && maven compile -Dcheckerframework.annotationprocessors=org.checkerframework.checker.lock.LockChecker)
elif [[ "$1" == "nullness-fbc" ]]; then
  (cd guava/guava && maven compile -Dcheckerframework.annotationprocessors=org.checkerframework.checker.nullness.NullnessChecker)
elif [[ "$1" == "nullness-raw" ]]; then
  (cd guava/guava && maven compile -Dcheckerframework.annotationprocessors=org.checkerframework.checker.nullness.NullnessRawnessChecker)
elif [[ "$1" == "regex" ]]; then
  (cd guava/guava && maven compile -Dcheckerframework.annotationprocessors=org.checkerframework.checker.regex.RegexChecker)
elif [[ "$1" == "signature" ]]; then
  (cd guava/guava && maven compile -Dcheckerframework.annotationprocessors=org.checkerframework.checker.signature.SignatureChecker)
elif [[ "$1" == "index" ]]; then
  (cd guava/guava && maven compile -Dcheckerframework.annotationprocessors=org.checkerframework.checker.index.IndexChecker)
elif [[ "$1" == "nothing" ]]; then
  true
else
  echo "Bad argument '$1' to travis-build.sh"
  false
fi
