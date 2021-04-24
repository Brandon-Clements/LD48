all: web

love:
	cd src; zip -9 -r ../build/game.love .

web: love
	echo "game" | npx love.js build/game.love build/game

web-run: web
	cd build/game;python3 -m http.server

web-pub: web
	cp -r build/game/* ../LD48-pub