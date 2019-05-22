.PHONY: all
all:
	zsh util/compile.zsh
.PHONY: install
install:
	ln -sfr sc /usr/local/bin/sc
	bzip2 -k doc/sc.1
	mv doc/sc.1.bz2 /usr/local/share/man/man1/sc.1.bz2
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
	zsh test/_suite.zsh
