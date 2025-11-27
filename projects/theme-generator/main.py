#!/usr/bin/env python3
"""
Modular Theme Generator
Run this in your theme folder with kitty.conf
"""

import os
import sys
import importlib
import inspect
from pathlib import Path

# Add the parsers and generators to path
sys.path.append(str(Path(__file__).parent / 'parsers'))
sys.path.append(str(Path(__file__).parent / 'generators'))

from parsers.kitty_parser import KittyParser
from generators import BaseGenerator

class ThemeGenerator:
    def __init__(self):
        self.parser = KittyParser()
        self.generators = self._discover_generators()
    
    def _discover_generators(self):
        """Automatically discover all generator classes in the generators directory"""
        generators = {}
        generators_dir = Path(__file__).parent / 'generators'
        
        # Import all Python files in the generators directory
        for py_file in generators_dir.glob('*.py'):
            if py_file.name.startswith('_') or py_file.name == 'base.py':
                continue
                
            module_name = py_file.stem
            try:
                # Import the module
                module = importlib.import_module(f'generators.{module_name}')
                
                # Find all classes that inherit from BaseGenerator
                for name, obj in inspect.getmembers(module, inspect.isclass):
                    if (issubclass(obj, BaseGenerator) and 
                        obj != BaseGenerator and 
                        obj.__module__ == module.__name__):
                        
                        # Use the class name without 'Generator' as the key
                        key = name.replace('Generator', '').lower()
                        generators[key] = obj
                        print(f"🔍 Discovered generator: {key} -> {name}")
                        
            except ImportError as e:
                print(f"⚠️  Could not import {module_name}: {e}")
            except Exception as e:
                print(f"⚠️  Error processing {module_name}: {e}")
        
        return generators
    
    def get_available_generators(self):
        """Return list of available generators"""
        return list(self.generators.keys())
    
    def generate_all(self):
        """Generate all config files"""
        print("🚀 Modular Theme Generator")
        print("==========================")
        print(f"📁 Found {len(self.generators)} generators")
        
        try:
            # Parse colors from kitty.conf
            colors = self.parser.parse()
            print("")
            print("🎯 Generating theme files...")
            print("")
            
            generated_files = []
            
            # Generate all configs
            for name, generator_class in self.generators.items():
                try:
                    generator = generator_class(colors)
                    output_file = generator.generate()
                    generated_files.append(output_file)
                    print(f"✅ Generated: {output_file}")
                except Exception as e:
                    print(f"❌ Failed to generate {name}: {e}")
            
            print("")
            print("🎉 All done! Generated files:")
            for file in generated_files:
                print(f"   - {file}")
            print("")
            print("📝 Existing files were backed up with .backup.<timestamp>")
            
        except FileNotFoundError as e:
            print(f"❌ Error: {e}")
            print("💡 Make sure you're in your theme folder with kitty.conf")
        except Exception as e:
            print(f"❌ Unexpected error: {e}")
    
    def generate_specific(self, app_name):
        """Generate config for specific app"""
        if app_name not in self.generators:
            print(f"❌ No generator found for: {app_name}")
            print(f"💡 Available generators: {', '.join(sorted(self.get_available_generators()))}")
            return
        
        try:
            colors = self.parser.parse()
            generator_class = self.generators[app_name]
            generator = generator_class(colors)
            output_file = generator.generate()
            print(f"✅ Generated: {output_file}")
        except Exception as e:
            print(f"❌ Failed to generate {app_name}: {e}")
    
    def list_generators(self):
        """List all available generators"""
        print("📋 Available generators:")
        for name in sorted(self.get_available_generators()):
            generator_class = self.generators[name]
            print(f"   - {name}: {generator_class.__name__} -> {generator_class.default_filename}")

def main():
    """Main function"""
    generator = ThemeGenerator()
    
    if len(sys.argv) > 1:
        command = sys.argv[1]
        if command in ['-l', '--list', 'list']:
            generator.list_generators()
        elif command in ['-h', '--help', 'help']:
            print_help(generator)
        else:
            # Generate specific app
            generator.generate_specific(command)
    else:
        # Generate all
        generator.generate_all()

def print_help(generator):
    """Print help information"""
    print("🎨 Theme Generator - Generate config files from kitty.conf")
    print("")
    print("Usage:")
    print("  python main.py                    # Generate all configs")
    print("  python main.py <app_name>         # Generate specific app config")
    print("  python main.py --list             # List all available generators")
    print("  python main.py --help             # Show this help")
    print("")
    print("Available generators:")
    for name in sorted(generator.get_available_generators()):
        print(f"  - {name}")

if __name__ == "__main__":
    main()
