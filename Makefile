TESTDIR = /tmp/sub
PG_CONFIG ?= pg_config

CFLAGS  = -std=c99 -D_GNU_SOURCE -O0 -g
CFLAGS += -I $(shell $(PG_CONFIG) --includedir)
CFLAGS += $(shell $(PG_CONFIG) --cflags)

all: foo ;

foo: $(wildcard *.h) foo.c
	gcc $(CFLAGS) pqexpbuffer.c foo.c -o $@

clean:
	rm -f foo

tree: foo
	./foo path mkdirs $(TESTDIR)/dir/test
	touch $(TESTDIR)/{a,b,c.h}
	touch $(TESTDIR)/dir/{toto,titi,tata}
	./foo path mkdirs $(TESTDIR)/sub
	touch $(TESTDIR)/sub/{foo,bar,baz}
	touch $(TESTDIR)/dir/test/coucou.txt
	tree $(TESTDIR)

test: test-commandline test-filepaths test-runprogram ;

test-commandline: foo
	./foo --help
	./foo env get --help
	./foo env get PATH
	./foo ls --help

test-filepaths: foo tree
	./foo path -h
	./foo path ls foo.c
	./foo path ls /tmp/citus-ha-keeper-tests/node_b.backup/
	./foo path abs /tmp/citus-ha-keeper-tests/monitor
	./foo path abs ./monitor
	./foo path ext foo.c .py
	./foo path ext foo.c py
	./foo path join ../subcommands.c foo.c
	./foo path joindir /tmp/citus-ha-demo/primary/data/ .backup
	./foo path merge bar.baz ./
	./foo path rel ./foo.c ../../..
	./foo path rmdir $(TESTDIR)
	tree $(TESTDIR)
	./foo path ls $(TESTDIR)
	./foo path find pg_ctl

test-runprogram: foo
	./foo which cat
	./foo echo 1
	./foo echo 2
	./foo echo 12
	./foo echo 15

.PHONY: all clean tree test test-commandline test-filepaths test-runprogram
