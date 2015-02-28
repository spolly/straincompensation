PACKAGE = STRAINCOMP
VERSION = 1.0.5
RELEASE_DIR = ../bin
SOURCE_DIR = .
MAIN_FILE = $(SOURCE_DIR)/main.m

FILES = `./octdep.pl main.m`

all:

install:
	for i in $(FILES) ; do \
           install -m 0444 --preserve-timestamps $$i $(RELEASE_DIR) ; \
        done

clean:

distclean: clean
	for i in $(FILES) ; do \
           rm -f $(RELEASE_DIR)/`basename $$i`; \
        done
