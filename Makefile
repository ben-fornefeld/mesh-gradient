.PHONY: help release test analyze format clean setup

help: ## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## install dependencies and tools
	@echo "Installing dependencies..."
	@flutter pub get
	@echo "Activating Melos..."
	@dart pub global activate melos
	@echo "Activating Pana..."
	@dart pub global activate pana
	@echo "✓ Setup complete"

test: ## run tests
	@flutter test

analyze: ## run static analysis
	@flutter analyze

format: ## format code
	@dart format .

format-check: ## check code formatting
	@dart format --set-exit-if-changed .

clean: ## clean build artifacts
	@flutter clean
	@rm -rf .dart_tool/
	@rm -rf build/

release: ## start release process (interactive)
	@bash release.sh

release-patch: ## quick patch release
	@echo "Quick patch release..."
	@melos version patch --yes --no-git-tag-version
	@bash -c 'NEW_VERSION=$$(grep "^version:" pubspec.yaml | sed "s/version: //"); echo "Version bumped to $$NEW_VERSION"'

release-minor: ## quick minor release
	@echo "Quick minor release..."
	@melos version minor --yes --no-git-tag-version
	@bash -c 'NEW_VERSION=$$(grep "^version:" pubspec.yaml | sed "s/version: //"); echo "Version bumped to $$NEW_VERSION"'

release-major: ## quick major release
	@echo "Quick major release..."
	@melos version major --yes --no-git-tag-version
	@bash -c 'NEW_VERSION=$$(grep "^version:" pubspec.yaml | sed "s/version: //"); echo "Version bumped to $$NEW_VERSION"'

publish-dry: ## dry-run publish to pub.dev
	@flutter pub publish --dry-run

pana: ## run pub.dev scoring analysis
	@echo "Running pana (pub.dev scoring)..."
	@dart pub global run pana --no-warning --exit-code-threshold 0

pana-json: ## run pana with JSON output
	@dart pub global run pana --json --no-warning

ci: format-check analyze test pana ## run all CI checks locally

watch: ## run tests in watch mode (requires entr)
	@find lib test -name '*.dart' | entr -c flutter test

