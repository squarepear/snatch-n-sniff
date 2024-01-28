all: windows zip

clean:
	rm -rf build

windows:
	mkdir -p build/windows
	godot -v --export "Windows Desktop" ../build/windows/SnatchNSniff.exe project/project.godot

zip: windows
	mkdir -p build/zip
	mkdir -p build/zip/src
	rsync -av --progress project build/zip/src --exclude .godot/
	echo "This project was built using [Godot Engine](https://godotengine.org)." > build/zip/src/README.md
	mkdir -p build/zip/release/windows
	cp -r build/windows/* build/zip/release/windows
	cp LICENSE build/zip
	mkdir -p build/zip/press
	cp press/*png build/zip/press
	cd build/zip;	zip SnatchNSniff.zip -r .