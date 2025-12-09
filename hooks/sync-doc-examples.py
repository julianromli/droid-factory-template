#!/usr/bin/env python3
"""
Sync code examples in markdown docs with actual source code.
"""
import json
import sys
import re
import os

def extract_code_snippets(doc_file):
    """Extract code snippets from markdown file."""
    with open(doc_file, 'r') as f:
        content = f.read()

    # Find code blocks with source file annotations
    # Format: ```typescript
    # // From: src/components/Button.tsx
    pattern = r'```(\w+)\n// From: (.*?)\n(.*?)\n```'
    snippets = re.findall(pattern, content, re.DOTALL)

    return snippets

def verify_snippet_matches_source(language, source_file, snippet):
    """Check if snippet exists in source file."""
    if not os.path.exists(source_file):
        return False, f"Source file not found: {source_file}"

    with open(source_file, 'r') as f:
        source_content = f.read()

    # Normalize whitespace for comparison
    normalized_snippet = ' '.join(snippet.split())
    normalized_source = ' '.join(source_content.split())

    if normalized_snippet in normalized_source:
        return True, "Snippet matches source"
    else:
        return False, "Snippet does not match source code"

def main():
    input_data = json.load(sys.stdin)
    file_path = input_data.get('tool_input', {}).get('file_path', '')

    # Check both code files and doc files
    if file_path.endswith(('.md', '.mdx')):
        # Doc file changed - verify all examples
        print(f"📖 Verifying code examples in {file_path}...")

        snippets = extract_code_snippets(file_path)
        issues = []

        for lang, source, snippet in snippets:
            matches, message = verify_snippet_matches_source(lang, source, snippet)
            if not matches:
                issues.append(f"{source}: {message}")

        if issues:
            print("⚠️ Some code examples may be outdated:", file=sys.stderr)
            for issue in issues:
                print(f"  - {issue}", file=sys.stderr)
            print("\nConsider updating the examples in the documentation.", file=sys.stderr)
        else:
            print("✓ All code examples are in sync")

    elif file_path.endswith(('.ts', '.tsx', '.js', '.jsx', '.py')):
        # Code file changed - check if it's referenced in docs
        print(f"Checking if {file_path} is referenced in documentation...")

        # Find docs that reference this file
        doc_files = []
        for root, dirs, files in os.walk('docs'):
            for file in files:
                if file.endswith(('.md', '.mdx')):
                    doc_path = os.path.join(root, file)
                    with open(doc_path, 'r') as f:
                        if file_path in f.read():
                            doc_files.append(doc_path)

        if doc_files:
            print(f"ℹ️ File is referenced in {len(doc_files)} documentation file(s):")
            for doc in doc_files:
                print(f"  - {doc}")
            print("\nConsider updating these docs if the API changed.")

    sys.exit(0)

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(0)
