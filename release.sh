#!/bin/bash

# mesh_gradient release script
# automates version bumping, changelog generation, and publishing

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # no color

echo -e "${GREEN}mesh_gradient Release Script${NC}"
echo ""

# check if melos is installed
if ! command -v melos &> /dev/null; then
    echo -e "${YELLOW}Melos not found. Installing...${NC}"
    dart pub global activate melos
fi

# check for uncommitted changes
if [[ -n $(git status -s) ]]; then
    echo -e "${RED}Error: You have uncommitted changes. Please commit or stash them first.${NC}"
    exit 1
fi

# check if on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" != "main" ]]; then
    echo -e "${YELLOW}Warning: You're on branch '$CURRENT_BRANCH', not 'main'. Continue? (y/n)${NC}"
    read -r response
    if [[ "$response" != "y" ]]; then
        exit 1
    fi
fi

# get current version
CURRENT_VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //')
echo -e "Current version: ${GREEN}$CURRENT_VERSION${NC}"
echo ""

# prompt for version bump type
echo "Select version bump type:"
echo "  1) patch (e.g., 1.3.8 → 1.3.9)"
echo "  2) minor (e.g., 1.3.8 → 1.4.0)"
echo "  3) major (e.g., 1.3.8 → 2.0.0)"
echo "  4) custom"
echo ""
read -p "Choice [1-4]: " choice

case $choice in
    1) VERSION_TYPE="patch" ;;
    2) VERSION_TYPE="minor" ;;
    3) VERSION_TYPE="major" ;;
    4)
        read -p "Enter custom version (e.g., 1.3.9): " CUSTOM_VERSION
        VERSION_TYPE="$CUSTOM_VERSION"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

# prompt for changelog entry
echo ""
echo -e "${YELLOW}Enter changelog description (what's new in this release?):${NC}"
read -r CHANGELOG_DESC

if [[ -z "$CHANGELOG_DESC" ]]; then
    echo -e "${RED}Error: Changelog description is required${NC}"
    exit 1
fi

# bump version using melos
echo ""
echo -e "${GREEN}Bumping version...${NC}"

if [[ "$VERSION_TYPE" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    # custom version
    NEW_VERSION="$VERSION_TYPE"
    sed -i "s/^version:.*/version: $NEW_VERSION/" pubspec.yaml
else
    # use melos for semantic versioning
    melos version --no-git-tag-version --yes "$VERSION_TYPE"
    NEW_VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //')
fi

# update changelog
echo -e "${GREEN}Updating changelog...${NC}"
TODAY=$(date +%Y-%m-%d)

# create new changelog entry
NEW_ENTRY="## $NEW_VERSION ($TODAY)\n\n$CHANGELOG_DESC\n"

# prepend to changelog (after the header if it exists)
if grep -q "^#" CHANGELOG.md; then
    # has header, insert after it
    sed -i "/^#/a\\\\n$NEW_ENTRY" CHANGELOG.md
else
    # no header, prepend to file
    echo -e "$NEW_ENTRY\n$(cat CHANGELOG.md)" > CHANGELOG.md
fi

# show changes
echo ""
echo -e "${GREEN}Changes to be released:${NC}"
echo -e "  Version: ${GREEN}$CURRENT_VERSION → $NEW_VERSION${NC}"
echo -e "  Changelog: ${YELLOW}$CHANGELOG_DESC${NC}"
echo ""

# confirm
read -p "Proceed with release? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo -e "${YELLOW}Release cancelled. Rolling back changes...${NC}"
    git checkout pubspec.yaml CHANGELOG.md
    exit 1
fi

# commit and tag
echo ""
echo -e "${GREEN}Committing changes...${NC}"
git add pubspec.yaml CHANGELOG.md
git commit -m "chore(release): $NEW_VERSION"

echo -e "${GREEN}Creating tag v$NEW_VERSION...${NC}"
git tag "v$NEW_VERSION"

echo ""
echo -e "${GREEN}✓ Release prepared!${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the changes: git show"
echo "  2. Push to GitHub: git push && git push --tags"
echo "  3. GitHub Actions will automatically publish to pub.dev"
echo ""
echo "To rollback: git reset --hard HEAD~1 && git tag -d v$NEW_VERSION"

