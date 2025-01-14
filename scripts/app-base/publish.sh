#!/bin/bash

ARG_DEFS=(
)

echo "##### "
echo "##### app-base/publish.sh"
echo "#####"

function init {
  APPBASE_DIR=$HOME/starters
  APPBASE_LIB_DIR=$APPBASE_DIR/ionic1/base/www/lib/ionic

  ../clone/clone.sh --repository="starters" \
    --depth="1" \
    --directory="$APPBASE_DIR" \
    --branch="master"
}

function run {
  cd ../..

  VERSION=$(readJsonProp "package.json" "version")

  echo "-- Updating files..."

  rm -rf $APPBASE_LIB_DIR
  mkdir -p $APPBASE_LIB_DIR

  node_modules/.bin/gulp build --release --dist=$APPBASE_LIB_DIR
  cp -Rf scss $APPBASE_LIB_DIR

  echo "-- Updating bower dependency..."
  replaceJsonProp "$APPBASE_DIR/bower.json" "ionic" "HeronSantosCom\/ionic-bower#$VERSION"

  cd $APPBASE_DIR

  git config --global user.email "heron@illi.com.br"
  git config --global user.name "Heron Santos"

  git add -A
  git commit -am "release: update ionic to v$VERSION"
  git push -q origin master

  echo "-- committed v$VERSION to starters repo successfully!"
}

source $(dirname $0)/../utils.inc
