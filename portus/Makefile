all: clone clean checkout prepare build

clone:
	git -C Portus rev-parse || git clone https://github.com/SUSE/Portus.git

clean:
	git -C Portus reset --hard

checkout:
	git -C Portus pull

prepare:
	cp Dockerfile Portus/Dockerfile
	cat Gemfile >> Portus/Gemfile
	rm Portus/.ruby-version
	cd Portus && PACKAGING=yes bundle list
	cp entrypoint.sh Portus/

build:
	docker build -t portus Portus
