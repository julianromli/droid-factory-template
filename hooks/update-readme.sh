#!/bin/bash
set -e

input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')

# Only update on package.json or structure changes
if ! echo "$file_path" | grep -qE '(package\.json|README\.md)$'; then
  exit 0
fi

cwd=$(echo "$input" | jq -r '.cwd')
cd "$cwd"

# Don't run if README is the file being edited
if [ "$file_path" = "README.md" ]; then
  exit 0
fi

echo "📝 Checking README..."

# Update package info in README
if [ -f "package.json" ] && [ -f "README.md" ]; then
  name=$(jq -r '.name' package.json)
  version=$(jq -r '.version' package.json)
  description=$(jq -r '.description' package.json)

  # Check if version in README matches package.json
  if ! grep -q "Version: $version" README.md; then
    echo "⚠️ README version out of sync with package.json"
    echo "Package version: $version"
    echo "Consider updating README.md or ask me to do it"
  fi
fi

# Check for missing documentation sections
required_sections=("Installation" "Usage" "API" "Contributing")
missing_sections=()

for section in "${required_sections[@]}"; do
  if ! grep -qi "## $section" README.md; then
    missing_sections+=("$section")
  fi
done

if [ ${#missing_sections[@]} -gt 0 ]; then
  echo "⚠️ README missing sections:"
  printf '  - %s\n' "${missing_sections[@]}"
fi

exit 0
