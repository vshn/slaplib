.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help
	@grep -E -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: release
release: ## Update version in stdlib.yaml, tag and push. Usage: make release VERSION=1.2.3
	@if [ -z "$(VERSION)" ]; then echo "VERSION required: make release VERSION=1.2.3"; exit 1; fi
	@echo "$(VERSION)" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$$' || { echo "VERSION must be semver (e.g. 1.2.3)"; exit 1; }
	@if [ -n "$$(git status --porcelain)" ]; then echo "working tree dirty, commit or stash first"; exit 1; fi
	@branch=$$(git rev-parse --abbrev-ref HEAD); \
	if [ "$$branch" != "master" ]; then echo "must release from master (on $$branch)"; exit 1; fi
	git pull --ff-only origin master
	yq -i '.metadata.version = "$(VERSION)"' stdlib.yaml
	git add stdlib.yaml
	git commit -m "chore: release v$(VERSION)"
	git tag -a "v$(VERSION)" -m "Release v$(VERSION)"
	git push origin master
	git push origin "v$(VERSION)"
