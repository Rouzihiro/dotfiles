# generators/base_generator.py
import os
import shutil
from datetime import datetime
from abc import ABC, abstractmethod

class BaseGenerator(ABC):
    def __init__(self, colors):
        self.colors = colors
    
    def backup_file(self, filepath):
        """Backup file if it exists"""
        if os.path.exists(filepath):
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            backup_path = f"{filepath}.backup.{timestamp}"
            shutil.copy2(filepath, backup_path)
            print(f"📦 Backed up: {filepath} -> {backup_path}")
    
    @abstractmethod
    def generate(self, output_file=None):
        """Generate the config file"""
        pass
    
    @property
    @abstractmethod
    def default_filename(self):
        """Return default output filename"""
        pass
