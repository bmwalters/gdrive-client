PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
FISH_COMPLETIONS ?= $(HOME)/.config/fish/completions

.PHONY: install uninstall check-deps

install: check-deps
	@mkdir -p $(BINDIR)
	@install -m 755 gdrive $(BINDIR)/gdrive
	@install -m 755 auth-google $(BINDIR)/auth-google
	@mkdir -p $(FISH_COMPLETIONS)
	@install -m 644 gdrive.fish $(FISH_COMPLETIONS)/gdrive.fish
	@echo "Installed gdrive to $(BINDIR)"
	@echo "Installed fish completions to $(FISH_COMPLETIONS)"

uninstall:
	@rm -f $(BINDIR)/gdrive $(BINDIR)/auth-google
	@rm -f $(FISH_COMPLETIONS)/gdrive.fish
	@echo "Uninstalled gdrive"

check-deps:
	@command -v oauth2c >/dev/null || (echo "Missing: oauth2c (brew install cloudentity/tap/oauth2c)" && exit 1)
	@command -v restish >/dev/null || (echo "Missing: restish (brew install restish)" && exit 1)
	@command -v jq >/dev/null || (echo "Missing: jq (brew install jq)" && exit 1)
