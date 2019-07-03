#!/bin/bash
ROOT=$TRAVIS_BUILD_DIR/..

# Required argument $1 is one of:
#   formatter, interning, lock, nullness, regex, signature, nothing


# Fail the whole script if any command fails
set -e

## Build Checker Framework
cd $ROOT && git clone --depth 1 https://github.com/typetools/checker-framework.git
# This also builds annotation-tools and jsr308-langtools
cd $ROOT/checker-framework/ && ./.travis-build-without-test.sh downloadjdk
export CHECKERFRAMEWORK=$ROOT/checker-framework

## Obtain guava
cd $ROOT && git clone --depth 1 https://github.com/typetools/guava.git

if [[ "$1" == "lock" ]]; then
  cd $ROOT/guava/guava && mvn compile -P checkerframework-local -Dcheckerframework.checkers=org.checkerframework.checker.lock.LockChecker
elif [[ "$1" == "nullness" ]]; then
  cd $ROOT/guava/guava && mvn compile -P checkerframework-local -Dcheckerframework.checkers=org.checkerframework.checker.nullness.NullnessChecker
elif [[ "$1" == "misc" ]]; then
  cd $ROOT/guava/guava && mvn compile -P checkerframework-local -Dcheckerframework.checkers=org.checkerframework.checker.regex.RegexChecker,org.checkerframework.checker.interning.InterningChecker,org.checkerframework.checker.formatter.FormatterChecker,org.checkerframework.checker.signature.SignatureChecker
elif [[ "$1" == "index" ]]; then
  cd $ROOT/guava/guava && mvn compile -P checkerframework-local -Dcheckerframework.checkers=org.checkerframework.checker.index.IndexChecker
elif [[ "$1" == "nothing" ]]; then
  ## Short version, intended to be used when triggering downstream Travis jobs.
  true
else
  echo "Bad argument '$1' to travis-build.sh"
  false
fi
