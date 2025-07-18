# Directories
SOURCES_DIR = overrides
DIST_DIR = ./dist

# Python environment setup (for tools)
PYTHON_DIR = venv
PYTHON_EXE = $(PYTHON_DIR)/bin/python3
PIP_EXE = $(PYTHON_DIR)/bin/pip

# Variables
MOD_NAME = $(shell jq ".name" modrinth.index.json)
VERSION = $(shell jq ".versionId" modrinth.index.json)

# Objects
ZIP_FILE = $(MOD_NAME)-$(VERSION).mrpack
INDEX_FILE = index.html
STYLESHEET = stylesheet.css

# Files
MODRINTH_JSON = modrinth.index.json

# Default target
all: clean package $(INDEX_FILE)

# Clean up previous builds
clean:
	@echo "Cleaning up previous builds..."
	@rm -f $(DIST_DIR)/$(ZIP_FILE)
	@rm -f $(DIST_DIR)/images/*
	@rm -f index.md
	@rm -f $(INDEX_FILE)

distclean: clean
	@echo "Cleaning up python virtual environment directory..."
	@rm -rf $(PYTHON_DIR)

# Package the mod into a ZIP file
package: clean
	@echo "Packaging the mod..."
	@zip -x '*/.DS_Store' @ -r $(DIST_DIR)/$(ZIP_FILE) $(SOURCES_DIR) $(MODRINTH_JSON)

# Build github pages
pages: clean $(INDEX_FILE)
	@echo "Building the website..."

# Python dependencies for DRY
$(PYTHON_EXE): scripts/requirements.txt
	@echo "Setting up virtual environment..."
	@python3 -m venv $(PYTHON_DIR)
	@$(PIP_EXE) install -r "$<"

$(DIST_DIR)/index.md: README.md scripts/json_to_md.py $(PYTHON_EXE)
	@echo "Generating index.md from README.md..."
	@$(PYTHON_EXE) scripts/json_to_md.py "$<" | tee "$@"

# Build the site
$(INDEX_FILE): $(DIST_DIR)/index.md $(STYLESHEET)
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
	@cp $< $@


help:
	@echo "Makefile commands:"
	@echo "  make            - Build the mod package"
	@echo "  make clean      - Remove previous build files"
	@echo "  make package    - Create the mod package"
	@echo "  make pages      - Update the github-pages content"
	@echo "  make help       - Show this help message"
	@echo "  make distclean  - Clean and build the package with index file"

.PHONY: all clean package pages help distclean
