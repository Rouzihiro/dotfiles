#!/usr/bin/env python3
"""
Advanced file search tool with ALWAYS case-insensitive search.
Usage: search_in_file.py <filename> <pattern1> [pattern2] [options]

Options:
  -r, --regex     Patterns are regular expressions
  -c, --count     Show only count of matches
  -n, --line-numbers  Show line numbers (default: on)
  -m, --no-line-numbers  Don't show line numbers
  -v, --invert    Show lines that DO NOT match
  -C, --case-sensitive  Enable case-sensitive search (disabled by default)
"""

import sys
import re
import argparse

def search_file(filename, patterns, use_regex=False, 
                show_count=False, show_line_numbers=True, 
                invert=False, case_sensitive=False):
    """Search for patterns in a file with various options."""
    
    try:
        match_count = 0
        compiled_patterns = []
        
        # Prepare patterns - DEFAULT: case-insensitive unless -C flag is used
        flags = 0 if case_sensitive else re.IGNORECASE
        
        for pattern in patterns:
            if use_regex:
                compiled_patterns.append(re.compile(pattern, flags))
            else:
                # Escape regex special characters for literal search
                escaped_pattern = re.escape(pattern)
                compiled_patterns.append(re.compile(escaped_pattern, flags))
        
        with open(filename, 'r') as f:
            for line_num, line in enumerate(f, 1):
                line = line.rstrip('\n')
                matched = False
                
                for pattern_re in compiled_patterns:
                    if pattern_re.search(line):
                        matched = True
                        break
                
                # Apply inversion if requested
                if invert:
                    matched = not matched
                
                if matched:
                    match_count += 1
                    if not show_count:
                        if show_line_numbers:
                            print(f"Line {line_num}: {line}")
                        else:
                            print(line)
        
        if show_count:
            print(f"Total matches: {match_count}")
            
    except FileNotFoundError:
        print(f"Error: File '{filename}' not found.")
        sys.exit(1)
    except PermissionError:
        print(f"Error: No permission to read '{filename}'.")
        sys.exit(1)
    except re.error as e:
        print(f"Regex error: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(
        description="Search for patterns in files (default: case-insensitive)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s server.log error                # Finds ERROR, Error, error, etc.
  %(prog)s server.log error warning        # Multiple patterns
  %(prog)s logs.txt "404" "500" -c         # Count only
  %(prog)s activity.log "user.*logged" -r  # Regex search
  %(prog)s data.txt "secret" -C            # Case-sensitive search
  %(prog)s output.txt "error" -v           # Show lines WITHOUT "error"
  
Note: By default, ALL searches are case-insensitive.
Use -C for case-sensitive matching.
        """
    )
    
    parser.add_argument("filename", help="File to search")
    parser.add_argument("patterns", nargs="+", help="Pattern(s) to search for")
    
    parser.add_argument("-r", "--regex", action="store_true", 
                       help="Treat patterns as regular expressions")
    
    parser.add_argument("-c", "--count", action="store_true",
                       help="Show only count of matches")
    
    # Line number options - clearer naming
    line_num_group = parser.add_mutually_exclusive_group()
    line_num_group.add_argument("-n", "--line-numbers", action="store_true", 
                               default=True, help="Show line numbers (default)")
    line_num_group.add_argument("-m", "--no-line-numbers", action="store_false", 
                               dest="line_numbers", help="Don't show line numbers")
    
    parser.add_argument("-v", "--invert", action="store_true",
                       help="Show lines that DO NOT match patterns")
    
    parser.add_argument("-C", "--case-sensitive", action="store_true",
                       help="Enable case-sensitive search (default: case-insensitive)")
    
    args = parser.parse_args()
    
    search_file(
        filename=args.filename,
        patterns=args.patterns,
        use_regex=args.regex,
        show_count=args.count,
        show_line_numbers=args.line_numbers,
        invert=args.invert,
        case_sensitive=args.case_sensitive
    )

if __name__ == "__main__":
    main()
