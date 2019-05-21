install:
	ln -sfr sc /usr/local/bin/sc
	bzip2 -k doc/sc.1
	mv doc/sc.1.bz2 /usr/local/share/man/man1/sc.1.bz2
	mandb
