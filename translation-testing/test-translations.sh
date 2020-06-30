#!/bin/bash

# will ask which pages you want opened and then open a tab per for each locale in FF and chrome

cd abpui-translations/adblockplusui

coreLocales=(ar de el en es fr hu it ja ko nl pl pt-BR ru tr zh-CN)
browsers=(google-chrome firefox)
pages=(composer.html day1.html desktop-options.html devtools-panel.html first-run.html issue-reporter.html mobile-options.html popup-dummy.html popup.html problem.html updates.html)

for page in ${pages[@]}; do
	read -p "Open translated pages for ${page}? (y/n)   " CONT
	if [ "$CONT" = "y" ]; then
		for browser in ${browsers[@]}; do
			if [ $browser == "firefox" ]; then
				# ugly workaround, firefox needs to be opened before te for loop below is run, in order to open all tabs at the same time
				firefox &
				# yeah, I don't want to talk about it
				sleep 3
			fi
			for coreLocale in ${coreLocales[@]}; do
				# warning: this will open 16 new tabs per page (1 per locale)
				$browser http://127.0.0.1:8080/$page?locale=$coreLocale
			done
		done
	fi
done