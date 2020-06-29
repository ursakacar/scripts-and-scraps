#!/bin/bash

mkdir abpui-translations
cd abpui-translations
git clone git@gitlab.com:eyeo/adblockplus/abpui/adblockplusui.git
cd adblockplusui
npm install
cd adblockplusui
npm run dist
npm start
