#!/bin/bash

# script for generating ABP builds from UI branches
# takes folder name and branch name from ui-script-variables.txt file

source ui-build-script-variables.txt

mkdir $foldername
cd $foldername

git clone git@gitlab.com:eyeo/adblockplus/abpui/adblockpluschrome.git

cd adblockpluschrome
git clone git@gitlab.com:eyeo/adblockplus/buildtools.git
git clone git@gitlab.com:eyeo/adblockplus/abpui/adblockpluscore.git
git clone git@gitlab.com:eyeo/adblockplus/abpui/adblockplusui.git

cd adblockplusui
git checkout $uibranch

npm install
npm run dist
cd ../buildtools
npm install
cd ..

checkout_correct_commit (){
    # If adblockpluschrome has a matching branch use the matching branch instead of master
    IFS=$'\n';
    for HEADS in $(git --git-dir $1 log --pretty=format:%D origin/master..HEAD | sed "/^$/d"); do
      IFS=$', ';
      for HEAD in $HEADS; do
        # Skip special ref HEAD since it will always be present
        if [[ $HEAD == *"HEAD"* ]]; then
          continue;
        fi
        # Strip ref e.g. ref/branch => branch
        export HEAD=$(echo $HEAD | sed "s/[^\/]\+\///g");
        if [ $(git rev-parse --quiet --verify origin/$HEAD) ]; then
          git reset --hard origin/$HEAD;
          break 2;
        fi
      done
    done
    echo $(git status)
    # Include resulting HEAD in debug output
    git log --oneline HEAD^..
}

checkout_correct_commit "./adblockplusui/.git"
cd adblockpluscore
checkout_correct_commit "../adblockplusui/.git"
cd ..

export REPOSITORY_ROOT_URL_ESCAPED=$(echo http://gitlab.com/eyeo/adblockplus/abpui/adblockplusui.git/ | sed -e 's/[\/&]/\\&/g')
cd adblockplusui
export UI_COMMIT=$(git log --pretty=format:'%h' -n 1)
cd ..
cd adblockpluscore
export CORE_COMMIT=$(git log --pretty=format:'%h' -n 1)
cd ..

# Tweak dependencies to automagically use the current UI & core version
sed -i -E "s/(_root = hg:[^ ]+ git:)([^ ]+)/\1$REPOSITORY_ROOT_URL_ESCAPED/g" dependencies
sed -i -E "s/(adblockpluscore = adblockpluscore hg:[[:alnum:]]{12} git:)([[:alnum:]]{7})/\1${CORE_COMMIT:0:8}/g" dependencies
sed -i -E "s/(adblockplusui = adblockplusui hg:[[:alnum:]]{12} git:)([[:alnum:]]{7})/\1${UI_COMMIT:0:8}/g" dependencies

pip install cryptography==2.2.2 Jinja2==2.10 tox==3.0.0 PyYAML==3.12 urllib3==1.22
npm install

# Build ABP
./build.py devenv -t gecko
./build.py devenv -t chrome
./build.py build -t gecko adblockplus-firefox.xpi
./build.py build -t chrome adblockplus-chrome.zip
