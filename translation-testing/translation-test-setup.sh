#!/bin/bash

mkdir test-translations
cd test-translations
git clone git@gitlab.com:eyeo/adblockplus/abpui/adblockplusui.git
cd adblockplusui
npm install
cd adblockplusui
npm run dist
echo test
