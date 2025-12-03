#!/usr/bin/env python3
"""
File Search, Replace, and View Tool
Combined file viewer, search, and replace tool.

Usage:
  # VIEW entire file:
  r <file>                           # View entire file
  
  # VIEW specific lines:
  r <file> -l <line>                 # View single line
  r <file> -l <start>-<end>          # View line range (e.g., 1-10)
  r <file> -l <line1>,<line2>,...   # View specific lines (e.g., 1,5,10)
  
  # SEARCH mode:
  r <file> <search>                  # Search for text
  
  # REPLACE mode:
  r <file> <search> <replace>        # Replace text
  
  # LINE REPLACE mode:
  r <file> -lr <line> <text>         # Replace line (use -lr instead of -l)

Options:
  -R, --regex            Pattern is a regular expression
  -C, --case-sensitive   Case-sensitive search (default: insensitive)
  -p, --preview          Preview changes
  -c, --count            Show only count of matches (search mode)
  -f N, --first N        Replace only first N occurrences
  -b, --backup           Create backup before modifying
  -d, --dry-run          Preview without asking (same as -p)

Examples:
  # VIEW:
  r file.txt                    # View entire file
  r file.txt -l 5              # View line 5
  r file.txt -l 1-10           # View lines 1-10
  r file.txt -l 1,5,10         # View lines 1, 5, and 10
  
  # SEARCH:
  r log.txt "ERROR"            # Search for ERROR
  
  # REPLACE:
  r config.txt "old" "new"     # Basic replace
  
  # LINE REPLACE:
  r script.py -lr 42 "new code" # Replace line 42 (using -lr flag)
"""

import sys
import re
import os
import shutil
import argparse
from datetime import datetime
from typing import Tuple, Optional, List

class FileTool:
    def __init__(self, filename: str):
        self.filename = filename
        self.original_content = None
        self.modified_content = None
        
    def view_lines(self, line_spec: Optional[str] = None):
        """View specific lines or entire file."""
        try:
            if not os.path.exists(self.filename):
                print(f"Error: File '{self.filename}' not found.")
                sys.exit(1)
            
            if not os.access(self.filename, os.R_OK):
                print(f"Error: Cannot read file '{self.filename}'.")
                sys.exit(1)
            
            # Read all lines
            with open(self.filename, 'r') as f:
                lines = f.readlines()
            
            # If no line spec, show all lines
            if line_spec is None:
                for i, line in enumerate(lines, 1):
                    print(f"{i:6}: {line.rstrip()}")
                return
            
            # Parse line specification
            line_nums = self.parse_line_spec(line_spec, len(lines))
            if not line_nums:
                print(f"Error: Invalid line specification: {line_spec}")
                return
            
            # Show requested lines
            for i in line_nums:
                if 1 <= i <= len(lines):
                    print(f"{i:6}: {lines[i-1].rstrip()}")
                else:
                    print(f"Warning: Line {i} is out of range (1-{len(lines)})")
                    
        except Exception as e:
            print(f"Error viewing file: {e}")
            sys.exit(1)
    
    def parse_line_spec(self, spec: str, max_lines: int) -> List[int]:
        """Parse line specification like '5', '1-10', or '1,5,10'."""
        try:
            result = []
            
            # Handle comma-separated list
            if ',' in spec:
                parts = spec.split(',')
                for part in parts:
                    part = part.strip()
                    if '-' in part:
                        # Range like 1-10
                        start_str, end_str = part.split('-', 1)
                        start = int(start_str.strip())
                        end = int(end_str.strip())
                        result.extend(range(start, end + 1))
                    else:
                        # Single number
                        result.append(int(part))
            
            # Handle range like 1-10
            elif '-' in spec:
                start_str, end_str = spec.split('-', 1)
                start = int(start_str.strip())
                end = int(end_str.strip())
                result = list(range(start, end + 1))
            
            # Handle single number
            else:
                result.append(int(spec))
            
            # Filter out invalid line numbers
            result = [i for i in result if 1 <= i <= max_lines]
            
            # Remove duplicates and sort
            result = sorted(set(result))
            
            return result
            
        except ValueError:
            return []
    
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
    
    def search_text(self, pattern: str, use_regex: bool = False, 
                   case_sensitive: bool = False, count_only: bool = False) -> int:
        """Search for text in file."""
        content = self.read_file()
        lines = content.splitlines()
        matches = 0
        
        flags = 0 if case_sensitive else re.IGNORECASE
        
        if use_regex:
            try:
                pattern_re = re.compile(pattern, flags)
            except re.error as e:
                print(f"Regex error: {e}")
                return 0
        else:
            pattern_re = re.compile(re.escape(pattern), flags)
        
        if not count_only:
            print(f"\nSearching '{self.filename}' for: {pattern}")
            print("=" * 60)
        
        for i, line in enumerate(lines, 1):
            if pattern_re.search(line):
                matches += 1
                if not count_only:
                    try:
                        highlighted = pattern_re.sub(f"\033[91m\\g<0>\033[0m", line)
                    except:
                        highlighted = line
                    print(f"Line {i}: {highlighted[:120]}{'...' if len(line) > 120 else ''}")
        
        if not count_only:
            if matches == 0:
                print("No matches found.")
            else:
                print("=" * 60)
                print(f"Found {matches} match{'es' if matches != 1 else ''}")
        elif count_only:
            print(f"Matches found: {matches}")
        
        return matches
    
    def replace_text(self, pattern: str, replacement: str, 
                    use_regex: bool = False, max_replacements: Optional[int] = None,
                    case_sensitive: bool = False) -> Tuple[int, str]:
        """Replace text in file content."""
        self.original_content = self.read_file()
        modified = self.original_content
        
        flags = 0 if case_sensitive else re.IGNORECASE
        
        if use_regex:
            try:
                if max_replacements:
                    modified = re.sub(pattern, replacement, modified, 
                                     count=max_replacements, flags=flags)
                    count = max_replacements
                else:
                    modified, count = re.subn(pattern, replacement, modified, 
                                             flags=flags)
            except re.error as e:
                print(f"Regex error: {e}")
                return 0, modified
        else:
            if not case_sensitive:
                pattern_re = re.compile(re.escape(pattern), flags=re.IGNORECASE)
                if max_replacements:
                    modified = pattern_re.sub(replacement, modified, count=max_replacements)
                    count = max_replacements
                else:
                    modified, count = pattern_re.subn(replacement, modified)
            else:
                if max_replacements:
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
        
        changed_lines = 0
        for i, (orig, mod) in enumerate(zip(orig_lines, mod_lines), 1):
            if orig != mod:
                changed_lines += 1
                print(f"\nLine {i}:")
                print(f"  Original: {orig[:100]}{'...' if len(orig) > 100 else ''}")
                print(f"  Modified: {mod[:100]}{'...' if len(mod) > 100 else ''}")
        
        if changed_lines == 0:
            print("No changes detected.")
        
        if len(orig_lines) != len(mod_lines):
            print(f"\nNote: Line count changed from {len(orig_lines)} to {len(mod_lines)}")
        
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
        print("✓ Changes applied successfully.")

def parse_arguments():
    """Parse command line arguments with custom handling."""
    args = sys.argv[1:]
    
    if not args:
        return {'mode': 'help'}
    
    if args[0] in ['-h', '--help']:
        return {'mode': 'help'}
    
    result = {
        'filename': None,
        'search': None,
        'replace': None,
        'line_spec': None,  # For viewing lines: -l 3 or -l 1-5
        'line_num': None,   # For replacing a line: -lr 3 "text"
        'regex': False,
        'case_sensitive': False,
        'preview': False,
        'count': False,
        'first': None,
        'backup': False,
        'dry_run': False,
    }
    
    i = 0
    while i < len(args):
        arg = args[i]
        
        if arg == '-R' or arg == '--regex':
            result['regex'] = True
            i += 1
        elif arg == '-C' or arg == '--case-sensitive':
            result['case_sensitive'] = True
            i += 1
        elif arg == '-p' or arg == '--preview':
            result['preview'] = True
            i += 1
        elif arg == '-c' or arg == '--count':
            result['count'] = True
            i += 1
        elif arg == '-b' or arg == '--backup':
            result['backup'] = True
            i += 1
        elif arg == '-d' or arg == '--dry-run':
            result['preview'] = True
            i += 1
        elif arg == '-f' or arg == '--first':
            if i + 1 >= len(args):
                print("Error: -f requires a number")
                sys.exit(1)
            try:
                result['first'] = int(args[i + 1])
            except ValueError:
                print(f"Error: -f requires a number, got '{args[i + 1]}'")
                sys.exit(1)
            i += 2
        elif arg == '-l' or arg == '--line':
            # VIEW mode: -l <line-spec>
            if i + 1 >= len(args):
                print("Error: -l requires a line specification")
                print("Examples: -l 5, -l 1-10, -l 1,5,10")
                sys.exit(1)
            result['line_spec'] = args[i + 1]
            i += 2
        elif arg == '-lr' or arg == '--line-replace':
            # LINE REPLACE mode: -lr <line> <text>
            if i + 2 >= len(args):
                print("Error: -lr requires line number and replacement text")
                print("Usage: r <file> -lr <line> <text>")
                sys.exit(1)
            try:
                result['line_num'] = int(args[i + 1])
            except ValueError:
                print(f"Error: -lr requires a line number, got '{args[i + 1]}'")
                sys.exit(1)
            result['replace'] = args[i + 2]
            i += 3
        elif arg.startswith('-'):
            print(f"Error: Unknown option: {arg}")
            sys.exit(1)
        else:
            # Positional argument
            if result['filename'] is None:
                result['filename'] = arg
            elif result['search'] is None:
                result['search'] = arg
            elif result['replace'] is None:
                result['replace'] = arg
            else:
                print(f"Warning: Ignoring extra argument: {arg}")
            i += 1
    
    # Determine mode
    if result['filename'] is None:
        result['mode'] = 'error'
    elif result['line_num'] is not None:
        result['mode'] = 'line_replace'
    elif result['line_spec'] is not None:
        result['mode'] = 'view_lines'
    elif result['search'] is None:
        result['mode'] = 'view_all'
    elif result['replace'] is None:
        result['mode'] = 'search'
    else:
        result['mode'] = 'replace'
    
    return result

def main():
    args = parse_arguments()
    
    if args['mode'] == 'help':
        print(__doc__)
        sys.exit(0)
    elif args['mode'] == 'error':
        print("Error: No filename provided")
        print("\nQuick usage:")
        print("  r file.txt                    # View file")
        print("  r file.txt -l 5              # View line 5")
        print("  r file.txt 'search'          # Search")
        print("  r file.txt 'old' 'new'       # Replace")
        print("  r file.txt -lr 42 'text'     # Replace line 42")
        sys.exit(1)
    
    tool = FileTool(args['filename'])
    
    if args['dry_run']:
        args['preview'] = True
    
    if args['mode'] == 'view_all':
        tool.view_lines()
    
    elif args['mode'] == 'view_lines':
        tool.view_lines(args['line_spec'])
    
    elif args['mode'] == 'search':
        matches = tool.search_text(
            pattern=args['search'],
            use_regex=args['regex'],
            case_sensitive=args['case_sensitive'],
            count_only=args['count']
        )
        if args['count'] and matches == 0:
            print("No matches found.")
    
    elif args['mode'] == 'replace':
        count, _ = tool.replace_text(
            pattern=args['search'],
            replacement=args['replace'],
            use_regex=args['regex'],
            max_replacements=args['first'],
            case_sensitive=args['case_sensitive']
        )
        
        if count == 0:
            print("No matches found.")
            print("No changes to apply.")
        else:
            print(f"Found {count} match{'es' if count != 1 else ''}")
            tool.apply_changes(backup=args['backup'], preview=args['preview'])
    
    elif args['mode'] == 'line_replace':
        success = tool.replace_line(args['line_num'], args['replace'])
        if not success:
            sys.exit(1)
        tool.apply_changes(backup=args['backup'], preview=args['preview'])

if __name__ == "__main__":
    main()
