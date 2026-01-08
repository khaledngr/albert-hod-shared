#!/usr/bin/env python3
"""
Quick test script to verify the Docker environment is set up correctly.
Run this inside the Docker container or after installing dependencies locally.
"""

import sys

def test_imports():
    """Test that all required packages can be imported."""
    print("Testing Python version...")
    print(f"Python version: {sys.version}")
    
    print("\nTesting core packages...")
    try:
        import pandas as pd
        print("✓ pandas")
    except ImportError as e:
        print(f"✗ pandas: {e}")
        return False
    
    try:
        import numpy as np
        print("✓ numpy")
    except ImportError as e:
        print(f"✗ numpy: {e}")
        return False
    
    print("\nTesting web scraping packages...")
    try:
        from bs4 import BeautifulSoup
        print("✓ beautifulsoup4")
    except ImportError as e:
        print(f"✗ beautifulsoup4: {e}")
        return False
    
    try:
        import selenium
        print("✓ selenium")
    except ImportError as e:
        print(f"✗ selenium: {e}")
        return False
    
    print("\nTesting Jupyter...")
    try:
        import jupyter
        print("✓ jupyter")
    except ImportError as e:
        print(f"✗ jupyter: {e}")
        return False
    
    print("\nTesting data science packages...")
    try:
        import seaborn as sns
        print("✓ seaborn")
    except ImportError as e:
        print(f"✗ seaborn: {e}")
        return False
    
    try:
        import plotly
        print("✓ plotly")
    except ImportError as e:
        print(f"✗ plotly: {e}")
        return False
    
    try:
        import nltk
        print("✓ nltk")
    except ImportError as e:
        print(f"✗ nltk: {e}")
        return False
    
    try:
        import sklearn
        print("✓ scikit-learn")
    except ImportError as e:
        print(f"✗ scikit-learn: {e}")
        return False
    
    print("\n✓ All packages imported successfully!")
    return True

if __name__ == "__main__":
    success = test_imports()
    sys.exit(0 if success else 1)

