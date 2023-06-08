all: clean build-linux

build-linux:
	mkdir build
	dart compile exe --target-os=linux -o build/keno main.dart
clean:
	rm -rf build