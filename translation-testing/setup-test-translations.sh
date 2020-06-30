#!/bin/bash

read -p 'Enter branch name: ' uibranch

mkdir abpui-translations
cd abpui-translations
git clone git@gitlab.com:eyeo/adblockplus/abpui/adblockplusui.git
cd adblockplusui
git checkout $uibranch
npm install
npm run dist
npm start
