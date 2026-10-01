"""
VIRASAT — Complete Master Cultural Craft Catalog Generator & System Reset
Fits SIH 2026 Problem Statement SIH26197.
Approved 28 Indian States & 208 Unique Traditional Crafts.
"""
import os
import sys
import json
import re
import math
import random
import urllib.request
from PIL import Image, ImageDraw, ImageFont

BASE_DIR = r"C:\Project\virasat"
ASSETS_CRAFTS_DIR = os.path.join(BASE_DIR, "assets", "images", "crafts")
os.makedirs(ASSETS_CRAFTS_DIR, exist_ok=True)

SUPABASE_URL = os.environ.get("SUPABASE_URL", "https://vjvikwtrnunseaxkwodu.supabase.co")
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_ROLE_KEY", "")
STORAGE_BUCKET = "craft-gallery"

def slugify(text):
    s = text.lower().strip()
    s = re.sub(r'[^a-z0-9]+', '_', s)
    return s.strip('_')

print("Catalog generator module loaded successfully.")
