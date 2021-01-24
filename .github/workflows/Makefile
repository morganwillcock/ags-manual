.POSIX:
.SUFFIXES:

all: test.yml

.SUFFIXES: .m4 .yml
.m4.yml:
	m4 $< > $@

clean:
	rm -f *.yml
