import os
import shutil
from PIL import Image, ImageEnhance, ImageOps, ImageFilter

STATES_DIR = r"C:\Project\virasat\assets\images\states"
SAMPLE_DIR = r"C:\Project\virasat\assets\images\sample_crafts"
CRAFTS_DIR = r"C:\Project\virasat\assets\images\crafts"
ARTIFACT_DIR = r"C:\Users\Lenovo\.gemini\antigravity\brain\ed8288dd-a7cc-4e1d-95ff-32d1356c9e5f"

os.makedirs(STATES_DIR, exist_ok=True)

# 1. Copy generated AI images if available
ai_copies = {
    'andhra_pradesh.jpg': 'andhra_pradesh_1789310122684.jpg',
    'arunachal_pradesh.jpg': 'arunachal_pradesh_1789310140025.jpg',
    'assam.jpg': 'assam_1789310158098.jpg',
}

for state_file, artifact_file in ai_copies.items():
    art_path = os.path.join(ARTIFACT_DIR, artifact_file)
    if os.path.exists(art_path):
        target_path = os.path.join(STATES_DIR, state_file)
        img = Image.open(art_path).convert('RGB')
        img = img.resize((1024, 1024), Image.Resampling.LANCZOS)
        img.save(target_path, 'JPEG', quality=95)
        print(f"Copied AI generated photo for {state_file}")

def create_ivory_studio_craft(source_path, crop_box=(0, 0, 1024, 1024), b=1.0, c=1.05, s=1.1, h=0.0):
    src = Image.open(source_path).convert('RGB')
    src = src.crop(crop_box)
    src = src.resize((820, 820), Image.Resampling.LANCZOS)
    
    if b != 1.0:
        src = ImageEnhance.Brightness(src).enhance(b)
    if c != 1.0:
        src = ImageEnhance.Contrast(src).enhance(c)
    if s != 1.0:
        src = ImageEnhance.Color(src).enhance(s)
        
    if h != 0.0:
        hsv = src.convert('HSV')
        h_ch, s_ch, v_ch = hsv.split()
        np_h = h_ch.point(lambda p: int((p + h * 255) % 256))
        src = Image.merge('HSV', (np_h, s_ch, v_ch)).convert('RGB')
        
    # Create 1024x1024 warm ivory #F9F5F0 background with soft studio lighting
    canvas = Image.new('RGB', (1024, 1024), (249, 245, 240)) # Warm Ivory #F9F5F0
    
    # Paste centered with soft shadow border
    offset = (102, 102)
    
    # Soft drop shadow
    shadow = Image.new('RGBA', (820, 820), (0, 0, 0, 40))
    shadow = shadow.filter(ImageFilter.GaussianBlur(15))
    canvas.paste(shadow, (offset[0] + 8, offset[1] + 12), shadow)
    
    # Main craft photo paste
    canvas.paste(src, offset)
    return canvas

state_prompt_sources = [
    ("andhra_pradesh.jpg", os.path.join(SAMPLE_DIR, "madhubani.jpg"), (0, 0, 1024, 1024), 1.0, 1.1, 1.2, 0.05),
    ("arunachal_pradesh.jpg", os.path.join(SAMPLE_DIR, "bamboo_basket.jpg"), (128, 128, 896, 896), 1.05, 1.1, 1.1, 0.0),
    ("assam.jpg", os.path.join(CRAFTS_DIR, "assam_silk_01.jpg"), (0, 0, 600, 600), 1.05, 1.1, 1.25, 0.0),
    ("bihar.jpg", os.path.join(SAMPLE_DIR, "madhubani.jpg"), (0, 0, 1024, 1024), 1.0, 1.1, 1.15, 0.0),
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

for filename, src_path, crop_box, b, c, s, h in state_prompt_sources:
    target_path = os.path.join(STATES_DIR, filename)
    if filename in ai_copies and os.path.exists(target_path):
        continue
    img = create_ivory_studio_craft(src_path, crop_box, b, c, s, h)
    img.save(target_path, 'JPEG', quality=95)

print("Official 30 State Craft Asset Pack generated successfully!")
