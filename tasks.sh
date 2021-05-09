#!/usr/bin/env bash

case $1 in
  deps*)
    set -ex
    mix deps.get
    set +ex
    ;;
  test*)
    set -ex
    mix coveralls
    set +ex
    ;;
  coverage*)
    set -ex
    mix coveralls.detail
    set +ex
    ;;
  docs*)
    set -ex
    mix docs
    set +ex
    ;;
  build*)
    $0 deps
    set -ex
    if [[ $(grep -c ' escript\: ' $(dirname $0)/mix.exs) -ge 1 ]]; then
      MIX_ENV=prod mix escript.build
    else
      MIX_ENV=prod mix run
    fi
    set +ex
    ;;
  push*)
    $0 deps
    $0 hexpm
    $0 hexdoc
    ;;
  hexpm*)
    $0 deps
    $0 build
    set -ex
    MIX_ENV=prod mix hex.publish package
    set +ex
    ;;
  hexdoc*)
    $0 deps
    $0 docs
    set -ex
    MIX_ENV=prod mix hex.publish docs
    set +ex
    ;;
  **)
    echo "usage: $0 <deps|test|coverage|docs|build|push|hexpm|hexdoc>"
    ;;
esac
