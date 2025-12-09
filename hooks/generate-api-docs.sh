#!/bin/bash
set -e

input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name')
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')

# Only process code files
if ! echo "$file_path" | grep -qE '\.(ts|tsx|js|jsx|py|go)$'; then
  exit 0
fi

# Skip test files
if echo "$file_path" | grep -qE '\.(test|spec)\.(ts|tsx|js|jsx)$'; then
  exit 0
fi

cwd=$(echo "$input" | jq -r '.cwd')
cd "$cwd"

echo "📚 Updating API documentation..."

case "$file_path" in
  *.ts|*.tsx)
    # TypeScript - use typedoc
    if command -v typedoc &> /dev/null && [ -f "typedoc.json" ]; then
      echo "Generating TypeScript docs..."
      typedoc --out docs/api src/ 2>&1 || {
        echo "⚠️ Failed to generate docs" >&2
      }
      echo "✓ API docs updated at docs/api"
    fi
    ;;

  *.py)
    # Python - use pdoc
    if command -v pdoc &> /dev/null; then
      module_name=$(echo "$file_path" | sed 's|^src/||; s|/|.|g; s|\.py$||')
      echo "Generating Python docs for $module_name..."

      pdoc --html --output-dir docs/api "$module_name" --force 2>&1 || {
        echo "⚠️ Failed to generate docs" >&2
      }
      echo "✓ API docs updated"
    fi
    ;;

  *.go)
    # Go - use godoc
    if command -v godoc &> /dev/null; then
      echo "Generating Go docs..."
      # Go docs are typically served, not generated
      # But we can create markdown from godoc
      echo "✓ Go docs available via 'godoc -http=:6060'"
    fi
    ;;
esac

exit 0
