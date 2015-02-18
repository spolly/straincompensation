PACKAGE = STRAINCOMP
VERSION = 1.0.4
RELEASE_DIR = ../bin
SOURCE_DIR = .
MAIN_FILE = $(SOURCE_DIR)/main.m

FILES = $(SOURCE_DIR)/main.m \
	$(SOURCE_DIR)/calcMaterial.m \
	$(SOURCE_DIR)/edzerostress.m \
	$(SOURCE_DIR)/getMaterial.m \
	$(SOURCE_DIR)/matthewsblakeslee.m \
	$(SOURCE_DIR)/parseSelection.m

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
