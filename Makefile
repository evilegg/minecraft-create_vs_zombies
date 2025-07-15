# Directories
SOURCES_DIR = overrides
DIST_DIR = ./dist

# Variables
MOD_NAME = $(shell jq ".name" modrinth.index.json)
VERSION = $(shell jq ".versionId" modrinth.index.json)

# Objects
ZIP_FILE = $(MOD_NAME)-$(VERSION).mrpack
INDEX_FILE = $(DIST_DIR)/index.html

# Files
MODRINTH_JSON = modrinth.index.json

# Default target
all: clean package $(INDEX_FILE)

# Clean up previous builds
clean:
	@echo "Cleaning up previous builds..."
	@rm -f $(ZIP_FILE)
	@rm -f $(INDEX_FILE)

# Package the mod into a ZIP file
package: clean
	@echo "Packaging the mod..."
	@zip -x '*/.DS_Store' @ -r $(DIST_DIR)/$(ZIP_FILE) $(SOURCES_DIR) $(MODRINTH_JSON)

# Build the site
$(INDEX_FILE): README.md
	@pandoc \
		--embed \
		"$<" \
		-o "$@"

# Help command
help:
	@echo "Makefile commands:"
	@echo "  make            - Build the mod package"
	@echo "  make clean      - Remove previous build files"
	@echo "  make package    - Create the mod package"
	@echo "  make help       - Show this help message"

.PHONY: all clean package help
