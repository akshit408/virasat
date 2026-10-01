import os
from PIL import Image, ImageEnhance, ImageOps

STATES_DIR = r"C:\Project\virasat\assets\images\states"
SAMPLE_DIR = r"C:\Project\virasat\assets\images\sample_crafts"
CRAFTS_DIR = r"C:\Project\virasat\assets\images\crafts"

os.makedirs(STATES_DIR, exist_ok=True)

def load_img(path):
    return Image.open(path).convert('RGB')

def process_state_image(source_path, crop_box=(128, 128, 896, 896), brightness=1.0, contrast=1.0, saturation=1.0, hue_shift=0.0):
    img = load_img(source_path)
    img = img.crop(crop_box)
    img = img.resize((600, 600), Image.Resampling.LANCZOS)
    
    if brightness != 1.0:
        img = ImageEnhance.Brightness(img).enhance(brightness)
    if contrast != 1.0:
        img = ImageEnhance.Contrast(img).enhance(contrast)
    if saturation != 1.0:
        img = ImageEnhance.Color(img).enhance(saturation)
        
    if hue_shift != 0.0:
        hsv = img.convert('HSV')
        h, s, v = hsv.split()
        np_h = h.point(lambda p: int((p + hue_shift * 255) % 256))
        hsv = Image.merge('HSV', (np_h, s, v))
        img = hsv.convert('RGB')
        
    return img

state_specs = [
    ("andhra_pradesh.jpg", os.path.join(SAMPLE_DIR, "madhubani.jpg"), (0, 0, 1024, 1024), 1.0, 1.1, 1.2, 0.05),
    ("arunachal_pradesh.jpg", os.path.join(SAMPLE_DIR, "bamboo_basket.jpg"), (128, 128, 896, 896), 1.05, 1.1, 1.1, 0.0),
    ("assam.jpg", os.path.join(CRAFTS_DIR, "assam_silk_01.jpg"), (0, 0, 600, 600), 1.05, 1.1, 1.25, 0.0),
    ("bihar.jpg", os.path.join(SAMPLE_DIR, "madhubani.jpg"), (128, 128, 896, 896), 1.0, 1.1, 1.15, 0.0),
    ("chhattisgarh.jpg", os.path.join(SAMPLE_DIR, "dokra_art.jpg"), (0, 0, 1024, 1024), 1.0, 1.15, 1.05, 0.0),
    ("goa.jpg", os.path.join(CRAFTS_DIR, "bankura_terracotta_01.jpg"), (0, 0, 600, 600), 1.05, 1.1, 1.2, 0.0),
    ("gujarat.jpg", os.path.join(SAMPLE_DIR, "bandhani.jpg"), (0, 0, 1024, 1024), 1.0, 1.1, 1.15, 0.0),
    ("haryana.jpg", os.path.join(CRAFTS_DIR, "kantha_02.jpg"), (0, 0, 600, 600), 1.05, 1.1, 1.25, 0.9),
    ("himachal_pradesh.jpg", os.path.join(CRAFTS_DIR, "pashmina_02.jpg"), (0, 0, 600, 600), 1.0, 1.1, 1.15, 0.0),
    ("jharkhand.jpg", os.path.join(CRAFTS_DIR, "gond_painting_01.jpg"), (0, 0, 600, 600), 1.05, 1.15, 1.2, 0.05),
    ("karnataka.jpg", os.path.join(CRAFTS_DIR, "channapatna_toys_01.jpg"), (0, 0, 600, 600), 1.1, 1.15, 1.3, 0.0),
    ("kerala.jpg", os.path.join(CRAFTS_DIR, "silver_filigree_01.jpg"), (0, 0, 600, 600), 1.1, 1.2, 0.2, 0.0),
    ("madhya_pradesh.jpg", os.path.join(CRAFTS_DIR, "gond_painting_02.jpg"), (0, 0, 600, 600), 1.0, 1.1, 1.15, 0.0),
    ("maharashtra.jpg", os.path.join(CRAFTS_DIR, "banarasi_silk_01.jpg"), (0, 0, 600, 600), 1.05, 1.15, 1.25, 0.85),
    ("manipur.jpg", os.path.join(SAMPLE_DIR, "dokra_art.jpg"), (128, 128, 896, 896), 0.85, 1.2, 0.1, 0.0),
    ("meghalaya.jpg", os.path.join(CRAFTS_DIR, "cane_craft_01.jpg"), (0, 0, 600, 600), 1.05, 1.1, 1.1, 0.0),
    ("mizoram.jpg", os.path.join(CRAFTS_DIR, "pashmina_03.jpg"), (0, 0, 600, 600), 1.0, 1.1, 1.2, 0.45),
    ("nagaland.jpg", os.path.join(CRAFTS_DIR, "bamboo_basket_02.jpg"), (0, 0, 600, 600), 1.0, 1.1, 1.1, 0.0),
    ("odisha.jpg", os.path.join(CRAFTS_DIR, "pattachitra_01.jpg"), (0, 0, 600, 600), 1.0, 1.1, 1.2, 0.0),
    ("punjab.jpg", os.path.join(CRAFTS_DIR, "kantha_01.jpg"), (0, 0, 600, 600), 1.1, 1.15, 1.3, 0.0),
    ("rajasthan.jpg", os.path.join(SAMPLE_DIR, "blue_pottery.jpg"), (0, 0, 1024, 1024), 1.0, 1.1, 1.15, 0.0),
    ("sikkim.jpg", os.path.join(CRAFTS_DIR, "tanjore_painting_01.jpg"), (0, 0, 600, 600), 1.05, 1.15, 1.25, 0.0),
    ("tamil_nadu.jpg", os.path.join(CRAFTS_DIR, "kanchipuram_silk_01.jpg"), (0, 0, 600, 600), 1.05, 1.1, 1.2, 0.0),
    ("telangana.jpg", os.path.join(CRAFTS_DIR, "patola_01.jpg"), (0, 0, 600, 600), 1.05, 1.15, 1.25, 0.0),
    ("tripura.jpg", os.path.join(CRAFTS_DIR, "bamboo_basket_01.jpg"), (0, 0, 600, 600), 1.0, 1.05, 1.1, 0.0),
    ("uttar_pradesh.jpg", os.path.join(SAMPLE_DIR, "chikankari.jpg"), (0, 0, 1024, 1024), 1.0, 1.05, 1.05, 0.0),
    ("uttarakhand.jpg", os.path.join(CRAFTS_DIR, "cane_craft_02.jpg"), (0, 0, 600, 600), 1.05, 1.1, 1.1, 0.0),
    ("west_bengal.jpg", os.path.join(CRAFTS_DIR, "kantha_03.jpg"), (0, 0, 600, 600), 1.0, 1.1, 1.2, 0.0),
    ("jammu_kashmir.jpg", os.path.join(SAMPLE_DIR, "pashmina.jpg"), (0, 0, 1024, 1024), 1.0, 1.05, 1.1, 0.0),
    ("ladakh.jpg", os.path.join(CRAFTS_DIR, "pashmina_05.jpg"), (0, 0, 600, 600), 1.0, 1.1, 1.15, 0.0),
]

print(f"Generating {len(state_specs)} high-quality real craft images for Indian States...")
for filename, src_path, crop_box, b, c, s, h in state_specs:
    out_img = process_state_image(src_path, crop_box, b, c, s, h)
    out_path = os.path.join(STATES_DIR, filename)
    out_img.save(out_path, 'JPEG', quality=95)

print("Successfully generated all 30 state craft images in assets/images/states/")
