#!/usr/bin/env python3
"""
File Search and Replace Tool
Simplified syntax: replace_in_file.py <file> <search> <replace> [options]

Options:
  -f, --first <n>        Replace only first N occurrences (default: all)
  -l, --line <n>         Replace entire line number N
  -p, --preview          Preview changes without saving
  -b, --backup           Create backup before modifying
  -R, --regex            Pattern is a regular expression
  -C, --case-sensitive   Case-sensitive search (default: insensitive)
  -m, --multiple <file>  Load multiple patterns from JSON/YAML file
  
Examples:
  # Basic replacement (most common)
  replace_in_file.py file.txt "old" "new"
  
  # Replace only first occurrence
  replace_in_file.py file.txt "error" "warning" -f 1
  
  # Replace first 3 occurrences
  replace_in_file.py file.txt "foo" "bar" -f 3
  
  # Replace specific line
  replace_in_file.py file.txt -l 42 "new line text"
  
  # Regex replacement
  replace_in_file.py log.txt "User\\s+(\\d+)" "Account \\1" -R
  
  # Preview changes
  replace_in_file.py config.txt "localhost" "server" -p
  
  # Create backup
  replace_in_file.py important.txt "temp" "permanent" -b
  
  # Case-sensitive
  replace_in_file.py code.py "DEBUG" "PRODUCTION" -C
"""

import sys
import re
import os
import shutil
import json
import yaml
import argparse
from datetime import datetime
from typing import List, Tuple, Optional

class FileReplacer:
    def __init__(self, filename: str):
        self.filename = filename
        self.original_content = None
        self.modified_content = None
        
    def read_file(self) -> str:
        """Read the file content."""
        try:
            with open(self.filename, 'r') as f:
                return f.read()
        except FileNotFoundError:
            print(f"Error: File '{self.filename}' not found.")
            sys.exit(1)
        except Exception as e:
            print(f"Error reading file: {e}")
            sys.exit(1)
    
    def write_file(self, content: str):
        """Write content to file."""
        try:
            with open(self.filename, 'w') as f:
                f.write(content)
        except Exception as e:
            print(f"Error writing file: {e}")
            sys.exit(1)
    
    def create_backup(self):
        """Create a backup of the original file."""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_file = f"{self.filename}.backup_{timestamp}"
        try:
            shutil.copy2(self.filename, backup_file)
            print(f"Backup created: {backup_file}")
            return backup_file
        except Exception as e:
            print(f"Warning: Could not create backup: {e}")
            return None
    
    def replace_text(self, pattern: str, replacement: str, 
                    use_regex: bool = False, max_replacements: Optional[int] = None,
                    case_sensitive: bool = False) -> Tuple[int, str]:
        """Replace text in file content."""
        self.original_content = self.read_file()
        modified = self.original_content
        
        flags = 0 if case_sensitive else re.IGNORECASE
        
        if use_regex:
            if max_replacements:
                modified, count = re.sub(pattern, replacement, modified, 
                                        count=max_replacements, flags=flags), max_replacements
            else:
                modified, count = re.subn(pattern, replacement, modified, 
                                         flags=flags)
        else:
            # Simple text replacement
            if not case_sensitive:
                # Case-insensitive string replacement using regex
                pattern_re = re.compile(re.escape(pattern), flags=re.IGNORECASE)
                if max_replacements:
                    modified = pattern_re.sub(replacement, modified, count=max_replacements)
                    count = max_replacements
                else:
                    modified, count = pattern_re.subn(replacement, modified)
            else:
                # Case-sensitive string replacement
                if max_replacements:
                    # We need to implement this manually for case-sensitive
                    count = 0
                    parts = []
                    remaining = modified
                    while remaining and (max_replacements is None or count < max_replacements):
                        idx = remaining.find(pattern)
                        if idx == -1:
                            parts.append(remaining)
                            break
                        parts.append(remaining[:idx])
                        parts.append(replacement)
                        remaining = remaining[idx + len(pattern):]
                        count += 1
                    parts.append(remaining)
                    modified = ''.join(parts)
                else:
                    count = modified.count(pattern)
                    modified = modified.replace(pattern, replacement)
        
        self.modified_content = modified
        return count, modified
    
    def replace_line(self, line_num: int, new_text: str) -> bool:
        """Replace an entire line by line number."""
        self.original_content = self.read_file()
        lines = self.original_content.splitlines(keepends=True)
        
        if line_num < 1 or line_num > len(lines):
            print(f"Error: Line {line_num} is out of range (1-{len(lines)})")
            return False
        
        lines[line_num - 1] = new_text + ('\n' if not new_text.endswith('\n') else '')
        self.modified_content = ''.join(lines)
        return True
    
    def preview_changes(self):
        """Show differences between original and modified content."""
        if not self.original_content or not self.modified_content:
            print("No changes to preview.")
            return
        
        if self.original_content == self.modified_content:
            print("No changes would be made.")
            return
        
        orig_lines = self.original_content.splitlines()
        mod_lines = self.modified_content.splitlines()
        
        print("\n" + "="*60)
        print("PREVIEW OF CHANGES:")
        print("="*60)
        
        for i, (orig, mod) in enumerate(zip(orig_lines, mod_lines), 1):
            if orig != mod:
                print(f"\nLine {i}:")
                # Truncate long lines for display
                orig_display = orig[:100] + ('...' if len(orig) > 100 else '')
                mod_display = mod[:100] + ('...' if len(mod) > 100 else '')
                print(f"  Original: {orig_display}")
                print(f"  Modified: {mod_display}")
        
        # Handle added/removed lines
        if len(orig_lines) != len(mod_lines):
            print(f"\nNote: Number of lines changed from {len(orig_lines)} to {len(mod_lines)}")
        
        print("="*60)
    
    def apply_changes(self, backup: bool = False, preview: bool = False):
        """Apply the changes to the file."""
        if not self.modified_content:
            print("No modifications to apply.")
            return
        
        if self.original_content == self.modified_content:
            print("No changes to apply.")
            return
        
        if preview:
            self.preview_changes()
            print("\nPreview only - file not modified.")
            return
        
        if backup:
            self.create_backup()
        
        self.write_file(self.modified_content)
        print("Changes applied successfully.")

def load_multiple_patterns(pattern_file: str) -> List[dict]:
    """Load multiple patterns from JSON or YAML file."""
    if not os.path.exists(pattern_file):
        print(f"Error: Pattern file '{pattern_file}' not found.")
        sys.exit(1)
    
    try:
        with open(pattern_file, 'r') as f:
            if pattern_file.endswith('.json'):
                patterns = json.load(f)
            elif pattern_file.endswith(('.yaml', '.yml')):
                patterns = yaml.safe_load(f)
            else:
                print(f"Error: Unsupported file format. Use .json or .yaml")
                sys.exit(1)
        
        # Validate pattern structure
        if isinstance(patterns, list):
            for i, pattern in enumerate(patterns):
                if not all(k in pattern for k in ['search', 'replace']):
                    print(f"Error: Pattern {i} missing 'search' or 'replace' key")
                    sys.exit(1)
            return patterns
        else:
            print("Error: Pattern file should contain a list of patterns")
            sys.exit(1)
            
    except Exception as e:
        print(f"Error loading pattern file: {e}")
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(
        description="File search and replace tool with simplified syntax",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )
    
    # Positional arguments for common use case
    parser.add_argument("filename", help="File to modify")
    parser.add_argument("search", nargs="?", help="Text to search for", default=None)
    parser.add_argument("replace", nargs="?", help="Replacement text", default=None)
    
    # Options
    parser.add_argument("-f", "--first", type=int, 
                       help="Replace only first N occurrences (default: all)")
    
    parser.add_argument("-l", "--line", type=int, 
                       help="Replace entire line number N")
    
    parser.add_argument("-p", "--preview", action="store_true",
                       help="Preview changes without saving")
    
    parser.add_argument("-b", "--backup", action="store_true",
                       help="Create backup before modifying")
    
    parser.add_argument("-R", "--regex", action="store_true",
                       help="Pattern is a regular expression")
    
    parser.add_argument("-C", "--case-sensitive", action="store_true",
                       help="Case-sensitive search (default: insensitive)")
    
    parser.add_argument("-m", "--multiple", 
                       help="Load multiple patterns from JSON/YAML file")
    
    args = parser.parse_args()
    
    # Validation
    if args.multiple and (args.search or args.replace):
        print("Error: Cannot use --multiple with search/replace arguments")
        sys.exit(1)
    
    if args.line and args.search:
        print("Error: Cannot use both --line and search/replace arguments")
        sys.exit(1)
    
    if args.line and not args.replace:
        print("Error: When using --line, provide replacement text as third argument")
        sys.exit(1)
    
    if not args.multiple and not args.line and (not args.search or not args.replace):
        print("Error: Need both search and replace arguments for text replacement")
        print("Usage: replace_in_file.py <file> <search> <replace> [options]")
        print("       replace_in_file.py <file> -l <line> <text> [options]")
        print("       replace_in_file.py <file> -m <pattern_file> [options]")
        sys.exit(1)
    
    # Initialize replacer
    replacer = FileReplacer(args.filename)
    
    # Handle multiple patterns from file
    if args.multiple:
        patterns = load_multiple_patterns(args.multiple)
        total_changes = 0
        
        for pattern_data in patterns:
            print(f"\nProcessing pattern: {pattern_data['search'][:50]}...")
            count, _ = replacer.replace_text(
                pattern=pattern_data['search'],
                replacement=pattern_data['replace'],
                use_regex=pattern_data.get('regex', False),
                max_replacements=pattern_data.get('first', None),
                case_sensitive=pattern_data.get('case_sensitive', False)
            )
            total_changes += count
            print(f"  Matches found: {count}")
        
        print(f"\nTotal changes across all patterns: {total_changes}")
    
    # Handle line replacement
    elif args.line:
        if not args.replace:
            print("Error: Need replacement text for line replacement")
            sys.exit(1)
            
        success = replacer.replace_line(args.line, args.replace)
        if not success:
            sys.exit(1)
        print(f"Line {args.line} replaced")
    
    # Handle text replacement (most common case)
    else:
        count, _ = replacer.replace_text(
            pattern=args.search,
            replacement=args.replace,
            use_regex=args.regex,
            max_replacements=args.first,
            case_sensitive=args.case_sensitive
        )
        print(f"Matches found: {count}")
    
    # Apply changes
    replacer.apply_changes(backup=args.backup, preview=args.preview)

if __name__ == "__main__":
    main()
