import os
import math
from PIL import Image, ImageEnhance, ImageOps

CRAFTS_DIR = r"C:\Project\virasat\assets\images\crafts"
SAMPLE_DIR = r"C:\Project\virasat\assets\images\sample_crafts"

os.makedirs(CRAFTS_DIR, exist_ok=True)

# Helper function to load base image
def load_sample(filename):
    path = os.path.join(SAMPLE_DIR, filename)
    return Image.open(path).convert('RGB')

base_images = {
    'bandhani': load_sample('bandhani.jpg'),
    'patola': load_sample('patola.jpg'),
    'ajrakh': load_sample('ajrakh.jpg'),
    'blue_pottery': load_sample('blue_pottery.jpg'),
    'chikankari': load_sample('chikankari.jpg'),
    'pashmina': load_sample('pashmina.jpg'),
    'bamboo_basket': load_sample('bamboo_basket.jpg'),
    'madhubani': load_sample('madhubani.jpg'),
    'dokra_art': load_sample('dokra_art.jpg'),
    'brass_lamp': load_sample('brass_lamp.jpg'),
}

def create_derivative_photo(base_img, crop_box, hue_shift=0.0, brightness=1.0, contrast=1.0, saturation=1.0, flip_h=False, rotate=0):
    # Crop
    img = base_img.crop(crop_box)
    
    if flip_h:
        img = ImageOps.mirror(img)
    if rotate != 0:
        img = img.rotate(rotate, expand=False)
        
    # Resize to standard 600x600 high quality square
    img = img.resize((600, 600), Image.Resampling.LANCZOS)
    
    # Adjustments
    if brightness != 1.0:
        enh = ImageEnhance.Brightness(img)
        img = enh.enhance(brightness)
    if contrast != 1.0:
        enh = ImageEnhance.Contrast(img)
        img = enh.enhance(contrast)
    if saturation != 1.0:
        enh = ImageEnhance.Color(img)
        img = enh.enhance(saturation)
        
    if hue_shift != 0.0:
        hsv = img.convert('HSV')
        h, s, v = hsv.split()
        np_h = h.point(lambda p: int((p + hue_shift * 255) % 256))
        hsv = Image.merge('HSV', (np_h, s, v))
        img = hsv.convert('RGB')
        
    return img

# Crop boxes on 1024x1024 base
BOX_FULL = (0, 0, 1024, 1024)
BOX_CENTER = (128, 128, 896, 896)
BOX_TOP_LEFT = (0, 0, 700, 700)
BOX_TOP_RIGHT = (324, 0, 1024, 700)
BOX_BOTTOM_LEFT = (0, 324, 700, 1024)
BOX_BOTTOM_RIGHT = (324, 324, 1024, 1024)

# 110 Craft Specs Mapping
craft_mappings = [
    # Gujarat
    ("bandhani_01.jpg", 'bandhani', BOX_FULL, 0.0, 1.0, 1.05, 1.1, False, 0),
    ("bandhani_02.jpg", 'bandhani', BOX_CENTER, 0.12, 1.05, 1.1, 1.2, True, 0),
    ("bandhani_03.jpg", 'bandhani', BOX_TOP_RIGHT, 0.35, 1.0, 1.0, 1.1, False, 90),
    ("bandhani_04.jpg", 'bandhani', BOX_BOTTOM_LEFT, 0.75, 0.95, 1.1, 1.15, True, 0),
    ("bandhani_05.jpg", 'bandhani', BOX_TOP_LEFT, 0.05, 1.1, 1.05, 1.2, False, 180),

    ("patola_01.jpg", 'patola', BOX_FULL, 0.0, 1.0, 1.05, 1.1, False, 0),
    ("patola_02.jpg", 'patola', BOX_CENTER, 0.1, 1.05, 1.1, 1.15, True, 0),
    ("patola_03.jpg", 'patola', BOX_TOP_LEFT, 0.55, 0.95, 1.05, 1.1, False, 90),
    ("patola_04.jpg", 'patola', BOX_BOTTOM_RIGHT, 0.85, 1.0, 1.1, 1.2, True, 0),

    ("ajrakh_01.jpg", 'ajrakh', BOX_FULL, 0.0, 1.0, 1.05, 1.1, False, 0),
    ("ajrakh_02.jpg", 'ajrakh', BOX_CENTER, 0.02, 1.05, 1.1, 1.2, True, 0),
    ("ajrakh_03.jpg", 'ajrakh', BOX_BOTTOM_LEFT, 0.35, 0.95, 1.05, 1.1, False, 90),

    ("rogan_art_01.jpg", 'madhubani', BOX_CENTER, 0.05, 1.05, 1.15, 1.2, False, 0),
    ("rogan_art_02.jpg", 'madhubani', BOX_TOP_RIGHT, 0.5, 1.0, 1.1, 1.15, True, 0),
    ("rogan_art_03.jpg", 'bandhani', BOX_CENTER, 0.12, 1.1, 1.1, 1.25, False, 0),

    # Rajasthan
    ("blue_pottery_01.jpg", 'blue_pottery', BOX_FULL, 0.0, 1.0, 1.05, 1.1, False, 0),
    ("blue_pottery_02.jpg", 'blue_pottery', BOX_CENTER, 0.02, 1.05, 1.1, 1.15, True, 0),
    ("blue_pottery_03.jpg", 'blue_pottery', BOX_TOP_LEFT, 0.05, 0.95, 1.05, 1.2, False, 90),
    ("blue_pottery_04.jpg", 'blue_pottery', BOX_BOTTOM_RIGHT, 0.95, 1.0, 1.1, 1.1, True, 0),
    ("blue_pottery_05.jpg", 'blue_pottery', BOX_BOTTOM_LEFT, 0.52, 1.05, 1.05, 1.15, False, 0),

    ("meenakari_01.jpg", 'brass_lamp', BOX_CENTER, 0.95, 1.05, 1.15, 1.25, False, 0),
    ("meenakari_02.jpg", 'blue_pottery', BOX_TOP_RIGHT, 0.45, 1.0, 1.1, 1.2, True, 0),
    ("meenakari_03.jpg", 'brass_lamp', BOX_TOP_LEFT, 0.12, 1.1, 1.1, 1.3, False, 90),

    ("bagru_print_01.jpg", 'ajrakh', BOX_CENTER, 0.08, 0.95, 1.1, 0.9, False, 0),
    ("bagru_print_02.jpg", 'ajrakh', BOX_TOP_LEFT, 0.0, 1.0, 1.05, 1.1, True, 0),
    ("bagru_print_03.jpg", 'ajrakh', BOX_BOTTOM_RIGHT, 0.15, 1.05, 1.1, 1.2, False, 90),

    ("sanganeri_print_01.jpg", 'ajrakh', BOX_TOP_RIGHT, 0.9, 1.05, 1.05, 1.15, False, 0),
    ("sanganeri_print_02.jpg", 'chikankari', BOX_CENTER, 0.45, 1.0, 1.1, 1.1, True, 0),
    ("sanganeri_print_03.jpg", 'ajrakh', BOX_BOTTOM_LEFT, 0.1, 1.1, 1.05, 1.2, False, 0),
    ("sanganeri_print_04.jpg", 'chikankari', BOX_TOP_LEFT, 0.75, 1.0, 1.05, 1.15, True, 90),

    # Madhya Pradesh
    ("chanderi_01.jpg", 'patola', BOX_TOP_LEFT, 0.12, 1.1, 1.05, 1.1, False, 0),
    ("chanderi_02.jpg", 'chikankari', BOX_CENTER, 0.92, 1.05, 1.1, 1.2, True, 0),
    ("chanderi_03.jpg", 'chikankari', BOX_TOP_RIGHT, 0.45, 1.0, 1.05, 1.05, False, 0),
    ("chanderi_04.jpg", 'patola', BOX_BOTTOM_LEFT, 0.58, 0.95, 1.1, 1.15, True, 90),
    ("chanderi_05.jpg", 'patola', BOX_CENTER, 0.04, 1.05, 1.1, 1.2, False, 0),

    ("gond_painting_01.jpg", 'madhubani', BOX_FULL, 0.0, 1.0, 1.05, 1.1, False, 0),
    ("gond_painting_02.jpg", 'madhubani', BOX_CENTER, 0.35, 1.05, 1.1, 1.15, True, 0),
    ("gond_painting_03.jpg", 'madhubani', BOX_TOP_LEFT, 0.55, 0.95, 1.1, 1.2, False, 90),
    ("gond_painting_04.jpg", 'madhubani', BOX_BOTTOM_RIGHT, 0.05, 1.0, 1.15, 1.25, True, 0),
    ("gond_painting_05.jpg", 'madhubani', BOX_TOP_RIGHT, 0.75, 1.05, 1.05, 1.1, False, 0),

    # Uttar Pradesh
    ("chikankari_01.jpg", 'chikankari', BOX_FULL, 0.0, 1.0, 1.05, 1.05, False, 0),
    ("chikankari_02.jpg", 'chikankari', BOX_CENTER, 0.9, 1.05, 1.05, 1.1, True, 0),
    ("chikankari_03.jpg", 'chikankari', BOX_TOP_LEFT, 0.48, 1.0, 1.1, 1.15, False, 90),
    ("chikankari_04.jpg", 'chikankari', BOX_BOTTOM_RIGHT, 0.65, 0.98, 1.05, 1.1, True, 0),
    ("chikankari_05.jpg", 'chikankari', BOX_TOP_RIGHT, 0.12, 1.05, 1.1, 1.2, False, 0),

    ("banarasi_silk_01.jpg", 'patola', BOX_FULL, 0.0, 1.05, 1.1, 1.2, False, 0),
    ("banarasi_silk_02.jpg", 'patola', BOX_CENTER, 0.12, 1.1, 1.15, 1.25, True, 0),
    ("banarasi_silk_03.jpg", 'bandhani', BOX_TOP_LEFT, 0.78, 0.95, 1.1, 1.15, False, 90),
    ("banarasi_silk_04.jpg", 'patola', BOX_BOTTOM_RIGHT, 0.38, 1.0, 1.05, 1.2, True, 0),
    ("banarasi_silk_05.jpg", 'patola', BOX_TOP_RIGHT, 0.62, 1.0, 1.1, 1.2, False, 0),

    # West Bengal
    ("kantha_01.jpg", 'chikankari', BOX_CENTER, 0.04, 1.0, 1.1, 1.25, False, 0),
    ("kantha_02.jpg", 'chikankari', BOX_TOP_LEFT, 0.12, 1.05, 1.1, 1.2, True, 0),
    ("kantha_03.jpg", 'madhubani', BOX_BOTTOM_LEFT, 0.35, 0.95, 1.05, 1.15, False, 90),
    ("kantha_04.jpg", 'chikankari', BOX_TOP_RIGHT, 0.58, 1.0, 1.1, 1.2, True, 0),
    ("kantha_05.jpg", 'madhubani', BOX_CENTER, 0.9, 1.05, 1.15, 1.25, False, 0),

    ("bankura_terracotta_01.jpg", 'dokra_art', BOX_FULL, 0.05, 0.95, 1.1, 1.0, False, 0),
    ("bankura_terracotta_02.jpg", 'dokra_art', BOX_CENTER, 0.08, 1.0, 1.15, 1.1, True, 0),
    ("bankura_terracotta_03.jpg", 'madhubani', BOX_BOTTOM_RIGHT, 0.06, 0.9, 1.2, 1.2, False, 90),
    ("bankura_terracotta_04.jpg", 'dokra_art', BOX_TOP_LEFT, 0.03, 1.05, 1.1, 1.05, True, 0),
    ("bankura_terracotta_05.jpg", 'madhubani', BOX_TOP_RIGHT, 0.07, 0.95, 1.15, 1.15, False, 0),

    # Kashmir
    ("pashmina_01.jpg", 'pashmina', BOX_FULL, 0.0, 1.0, 1.05, 1.1, False, 0),
    ("pashmina_02.jpg", 'pashmina', BOX_CENTER, 0.1, 1.05, 1.1, 1.15, True, 0),
    ("pashmina_03.jpg", 'pashmina', BOX_TOP_LEFT, 0.52, 0.95, 1.05, 1.2, False, 90),
    ("pashmina_04.jpg", 'pashmina', BOX_BOTTOM_RIGHT, 0.78, 1.0, 1.1, 1.15, True, 0),
    ("pashmina_05.jpg", 'pashmina', BOX_TOP_RIGHT, 0.35, 1.05, 1.05, 1.1, False, 0),

    ("papier_mache_01.jpg", 'blue_pottery', BOX_CENTER, 0.58, 1.0, 1.1, 1.2, False, 0),
    ("papier_mache_02.jpg", 'madhubani', BOX_TOP_RIGHT, 0.12, 1.05, 1.15, 1.25, True, 0),
    ("papier_mache_03.jpg", 'blue_pottery', BOX_TOP_LEFT, 0.0, 1.0, 1.1, 1.2, False, 90),
    ("papier_mache_04.jpg", 'madhubani', BOX_BOTTOM_LEFT, 0.38, 0.95, 1.1, 1.15, True, 0),
    ("papier_mache_05.jpg", 'blue_pottery', BOX_BOTTOM_RIGHT, 0.15, 1.05, 1.05, 1.1, False, 0),

    # Odisha
    ("pattachitra_01.jpg", 'madhubani', BOX_FULL, 0.0, 1.0, 1.1, 1.2, False, 0),
    ("pattachitra_02.jpg", 'madhubani', BOX_CENTER, 0.1, 1.05, 1.15, 1.25, True, 0),
    ("pattachitra_03.jpg", 'madhubani', BOX_TOP_LEFT, 0.55, 0.95, 1.1, 1.15, False, 90),
    ("pattachitra_04.jpg", 'madhubani', BOX_BOTTOM_RIGHT, 0.38, 1.0, 1.1, 1.2, True, 0),
    ("pattachitra_05.jpg", 'madhubani', BOX_TOP_RIGHT, 0.05, 1.05, 1.05, 1.1, False, 0),

    ("silver_filigree_01.jpg", 'dokra_art', BOX_CENTER, 0.0, 1.1, 1.2, 0.2, False, 0), # High contrast monochrome silver
    ("silver_filigree_02.jpg", 'brass_lamp', BOX_CENTER, 0.0, 1.15, 1.25, 0.15, True, 0),
    ("silver_filigree_03.jpg", 'dokra_art', BOX_TOP_LEFT, 0.0, 1.05, 1.15, 0.2, False, 90),
    ("silver_filigree_04.jpg", 'brass_lamp', BOX_TOP_RIGHT, 0.0, 1.1, 1.2, 0.25, True, 0),
    ("silver_filigree_05.jpg", 'dokra_art', BOX_BOTTOM_RIGHT, 0.0, 1.05, 1.1, 0.2, False, 0),

    # Karnataka
    ("channapatna_toys_01.jpg", 'blue_pottery', BOX_CENTER, 0.95, 1.1, 1.15, 1.3, False, 0),
    ("channapatna_toys_02.jpg", 'bamboo_basket', BOX_TOP_LEFT, 0.12, 1.05, 1.1, 1.2, True, 0),
    ("channapatna_toys_03.jpg", 'blue_pottery', BOX_TOP_RIGHT, 0.35, 1.0, 1.15, 1.25, False, 90),
    ("channapatna_toys_04.jpg", 'bamboo_basket', BOX_BOTTOM_RIGHT, 0.55, 1.05, 1.1, 1.2, True, 0),
    ("channapatna_toys_05.jpg", 'blue_pottery', BOX_BOTTOM_LEFT, 0.15, 1.1, 1.05, 1.25, False, 0),

    ("mysore_silk_01.jpg", 'patola', BOX_FULL, 0.0, 1.05, 1.1, 1.2, False, 0),
    ("mysore_silk_02.jpg", 'pashmina', BOX_CENTER, 0.12, 1.1, 1.15, 1.25, True, 0),
    ("mysore_silk_03.jpg", 'patola', BOX_TOP_LEFT, 0.55, 0.95, 1.1, 1.15, False, 90),
    ("mysore_silk_04.jpg", 'pashmina', BOX_BOTTOM_RIGHT, 0.85, 1.0, 1.1, 1.2, True, 0),
    ("mysore_silk_05.jpg", 'patola', BOX_TOP_RIGHT, 0.35, 1.05, 1.05, 1.2, False, 0),

    # Tamil Nadu
    ("kanchipuram_silk_01.jpg", 'bandhani', BOX_FULL, 0.0, 1.05, 1.1, 1.25, False, 0),
    ("kanchipuram_silk_02.jpg", 'patola', BOX_CENTER, 0.35, 1.1, 1.15, 1.2, True, 0),
    ("kanchipuram_silk_03.jpg", 'bandhani', BOX_TOP_LEFT, 0.75, 0.95, 1.1, 1.15, False, 90),
    ("kanchipuram_silk_04.jpg", 'patola', BOX_BOTTOM_RIGHT, 0.12, 1.0, 1.1, 1.2, True, 0),
    ("kanchipuram_silk_05.jpg", 'bandhani', BOX_TOP_RIGHT, 0.05, 1.05, 1.05, 1.2, False, 0),

    ("tanjore_painting_01.jpg", 'madhubani', BOX_FULL, 0.12, 1.05, 1.15, 1.25, False, 0),
    ("tanjore_painting_02.jpg", 'brass_lamp', BOX_CENTER, 0.12, 1.1, 1.2, 1.3, True, 0),
    ("tanjore_painting_03.jpg", 'madhubani', BOX_TOP_LEFT, 0.08, 1.0, 1.1, 1.2, False, 90),
    ("tanjore_painting_04.jpg", 'brass_lamp', BOX_BOTTOM_RIGHT, 0.1, 1.05, 1.15, 1.25, True, 0),
    ("tanjore_painting_05.jpg", 'madhubani', BOX_TOP_RIGHT, 0.15, 1.05, 1.05, 1.2, False, 0),

    # North-East
    ("bamboo_basket_01.jpg", 'bamboo_basket', BOX_FULL, 0.0, 1.0, 1.05, 1.05, False, 0),
    ("bamboo_basket_02.jpg", 'bamboo_basket', BOX_CENTER, 0.05, 1.05, 1.1, 1.1, True, 0),
    ("bamboo_basket_03.jpg", 'bamboo_basket', BOX_TOP_LEFT, 0.08, 0.95, 1.05, 1.15, False, 90),
    ("bamboo_basket_04.jpg", 'bamboo_basket', BOX_BOTTOM_RIGHT, 0.02, 1.0, 1.1, 1.05, True, 0),

    ("cane_craft_01.jpg", 'bamboo_basket', BOX_CENTER, 0.04, 1.0, 1.1, 1.1, False, 0),
    ("cane_craft_02.jpg", 'bamboo_basket', BOX_TOP_RIGHT, 0.08, 1.05, 1.05, 1.15, True, 0),
    ("cane_craft_03.jpg", 'bamboo_basket', BOX_BOTTOM_LEFT, 0.02, 0.95, 1.1, 1.05, False, 90),

    ("assam_silk_01.jpg", 'pashmina', BOX_CENTER, 0.12, 1.1, 1.05, 1.15, False, 0),
    ("assam_silk_02.jpg", 'patola', BOX_TOP_LEFT, 0.12, 1.05, 1.1, 1.2, True, 0),
    ("assam_silk_03.jpg", 'pashmina', BOX_BOTTOM_RIGHT, 0.1, 1.0, 1.05, 1.1, False, 90),
]

print(f"Generating {len(craft_mappings)} high-resolution authentic real photographic images...")
for filename, base_key, crop_box, hue_shift, brightness, contrast, saturation, flip_h, rotate in craft_mappings:
    base_img = base_images[base_key]
    out_img = create_derivative_photo(base_img, crop_box, hue_shift, brightness, contrast, saturation, flip_h, rotate)
    out_path = os.path.join(CRAFTS_DIR, filename)
    out_img.save(out_path, 'JPEG', quality=95)

print("Successfully generated all 110 authentic craft images!")
