GIMP_VERSION=2.8
GIMP_SCRIPT_DIR=$(HOME)/.gimp-$(GIMP_VERSION)/scripts

.PHONY: install

install: $(GIMP_SCRIPT_DIR)
	cp *.scm $(GIMP_SCRIPT_DIR)

$(GIMP_SCRIPT_DIR):
	mkdir -p $(GIMP_SCRIPT_DIR)

