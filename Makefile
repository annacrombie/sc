.PHONY: all
all:
	zsh util/compile.zsh
.PHONY: install
install:
	ln -sfr mu /usr/local/bin/mu
	bzip2 -k doc/mu.1
	mv doc/mu.1.bz2 /usr/local/share/man/man1/mu.1.bz2
	mandb
.PHONY: update
update:
	git pull
	git submodule update
.PHONY: clean
clean:
	find src -name "*.zwc" -type f -exec rm -f {} +
.PHONY: test
test:
	zsh util/test.zsh
