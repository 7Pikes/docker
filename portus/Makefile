all: clone clean pull prepare build

clone:
	git -C Portus rev-parse || git clone https://github.com/SUSE/Portus.git

clean:
	git -C Portus reset --hard

pull:
	git -C Portus pull

prepare:
	cp Dockerfile Portus/Dockerfile
	cat Gemfile >> Portus/Gemfile
	rm Portus/.ruby-version
	cd Portus && PACKAGING=yes bundle list

build:
	docker build -t portus Portus
