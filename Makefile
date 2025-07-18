# Directories
SOURCES_DIR = overrides
DIST_DIR = ./docs

# Python environment setup (for tools)
PYTHON_DIR = venv
PYTHON_EXE = $(PYTHON_DIR)/bin/python3
PIP_EXE = $(PYTHON_DIR)/bin/pip

# Variables
MOD_NAME = $(shell jq ".name" modrinth.index.json)
VERSION = $(shell jq ".versionId" modrinth.index.json)

# Objects
ZIP_FILE = $(DIST_DIR)/$(MOD_NAME)-$(VERSION).mrpack
ZIP_IGNORE = "*/.DS_Store"
INDEX_FILE = $(DIST_DIR)/index.html
INDEX_MD = $(DIST_DIR)/index.md
STYLESHEET = stylesheet.css
STYLESHEET_OBJ = $(DIST_DIR)/$(STYLESHEET)
IMAGES = $(wildcard images/*.png)
IMAGE_OBJS = $(subst images/,docs/images/,$(IMAGES))

# Files
MODRINTH_JSON = modrinth.index.json

# Default target
all: clean package $(INDEX_FILE)

# Clean up previous builds
clean:
	@echo "Cleaning up previous builds..."
	@rm -f $(ZIP_FILE)
	@rm -f $(DIST_DIR)/images/*
	@rm -f $(INDEX_MD)
	@rm -f $(INDEX_FILE)

$(DIST_DIR):
	@mkdir -p $@

distclean: clean
	@echo "Cleaning up build environment..."
	@rm -rf $(PYTHON_DIR)
	@rm -rf $(DIST_DIR)

# Package the mod into a ZIP file
package: clean $(DIST_DIR)
	@echo "Packaging the mod..."
	@zip -x $(ZIP_IGNORE) @ -r $(ZIP_FILE) $(SOURCES_DIR) $(MODRINTH_JSON)

# Build github pages
pages: clean $(INDEX_FILE)
	@echo "Building the website..."

# Python dependencies for DRY
$(PYTHON_EXE): scripts/requirements.txt
	@echo "Setting up build environment..."
	@python3 -m venv $(PYTHON_DIR)
	@$(PIP_EXE) install -r "$<"

$(INDEX_MD): README.md scripts/json_to_md.py $(PYTHON_EXE)
	@echo "Generating index.md from README.md..."
	@$(PYTHON_EXE) scripts/json_to_md.py "$<" > "$@"

# Build the site
$(INDEX_FILE): $(INDEX_MD) $(STYLESHEET_OBJ) $(IMAGE_OBJS)
	pandoc \
		"$<" \
		--metadata title=$(MOD_NAME) \
		--metadata version=$(VERSION) \
		--css=$(STYLESHEET) \
		--link-images=true \
		--standalone \
		--output "$@"

$(DIST_DIR)/images/%.png: images/%.png
	@mkdir -p $(DIST_DIR)/images
	@cp -v $< $@

help:
	@echo "Makefile commands:"
	@echo "  make            - Build the mod package"
	@echo "  make clean      - Remove previous build files"
	@echo "  make package    - Create the mod package"
	@echo "  make pages      - Update the github-pages content"
	@echo "  make help       - Show this help message"
	@echo "  make distclean  - Clean and build the package with index file"

.PHONY: all clean package pages help distclean
