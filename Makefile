# Makefile for packaging KubeJS mod

# Variables
MOD_NAME = $(shell jq ".name" modrinth.index.json)
VERSION = $(shell jq ".versionId" modrinth.index.json)
ZIP_FILE = $(MOD_NAME)-$(VERSION).mrpack

# Directories
SOURCES_DIR = overrides

# Files
MODRINTH_JSON = modrinth.index.json

# Default target
all: clean package

# Clean up previous builds
clean:
	@echo "Cleaning up previous builds..."
	@rm -f $(ZIP_FILE)

# Package the mod into a ZIP file
package: clean
	@echo "Packaging the mod..."
	@zip -x '*/.DS_Store' @ -r dist/$(ZIP_FILE) $(SOURCES_DIR) $(MODRINTH_JSON)

# Help command
help:
	@echo "Makefile commands:"
	@echo "  make            - Build the mod package"
	@echo "  make clean      - Remove previous build files"
	@echo "  make package    - Create the mod package"
	@echo "  make help       - Show this help message"

.PHONY: all clean package help
