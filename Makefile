PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
FISH_COMPLETIONS ?= $(HOME)/.config/fish/completions
DATADIR ?= $(HOME)/Library/Application Support

OPENAPI_URL = https://raw.githubusercontent.com/APIs-guru/openapi-directory/f7207cf0a5c56081d275ebae4cf615249323385d/APIs/googleapis.com/drive/v3/openapi.yaml
SPEC_FILE = openapi.yaml

BUILD_DIR = .build

.PHONY: install uninstall check-deps clean

$(BUILD_DIR)/$(SPEC_FILE):
	@mkdir -p "$(BUILD_DIR)"
	@echo "Downloading OpenAPI spec..."
	@curl -sSL -o "$(BUILD_DIR)/$(SPEC_FILE)" "$(OPENAPI_URL)"
	@echo "Post-processing spec..."
	@sed -i '' 's/operationId: drive\./operationId: /g' "$(BUILD_DIR)/$(SPEC_FILE)"

install: check-deps $(BUILD_DIR)/$(SPEC_FILE)
	@mkdir -p "$(BINDIR)"
	@install -m 755 gdrive "$(BINDIR)/gdrive"
	@install -m 755 auth-google "$(BINDIR)/auth-google"
	@mkdir -p "$(FISH_COMPLETIONS)"
	@install -m 644 gdrive.fish "$(FISH_COMPLETIONS)/gdrive.fish"
	@mkdir -p "$(DATADIR)/gdrive-cli"
	@install -m 644 "$(BUILD_DIR)/$(SPEC_FILE)" "$(DATADIR)/gdrive-cli/$(SPEC_FILE)"
	@echo "Installed gdrive to $(BINDIR)"
	@echo "Installed fish completions to $(FISH_COMPLETIONS)"
	@echo "Installed API spec to $(DATADIR)/gdrive-cli"

uninstall:
	@rm -f "$(BINDIR)/gdrive" "$(BINDIR)/auth-google"
	@rm -f "$(FISH_COMPLETIONS)/gdrive.fish"
	@rm -rf "$(DATADIR)/gdrive-cli"
	@echo "Uninstalled gdrive"

clean:
	@rm -rf "$(BUILD_DIR)"
	@echo "Cleaned up build directory"

check-deps:
	@command -v oauth2c >/dev/null || (echo "Missing: oauth2c (brew install cloudentity/tap/oauth2c)" && exit 1)
	@command -v restish >/dev/null || (echo "Missing: restish (brew install restish)" && exit 1)
	@command -v jq >/dev/null || (echo "Missing: jq (brew install jq)" && exit 1)
