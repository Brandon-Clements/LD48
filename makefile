all: web

love:
	mkdir -p build
	cd src; zip -9 -r ../build/game.love .

love-run: love
	love build/game.love --console

web: love
	echo "New Babel" | npx love.js build/game.love build/game
	cp web-theme/bg.png build/game/theme/bg.png
	cp web-theme/love.css build/game/theme/love.css

web-run: web
	cd build/game;python3 -m http.server

web-pub: web
	cp -r build/game/* ../LD48-pub
