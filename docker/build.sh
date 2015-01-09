meteor build ../ff --architecture os.linux.x86_64
docker build -t="chees/meteor-testje" .
docker push chees/meteor-testje
