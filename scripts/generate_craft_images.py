import os
import math
import random
from PIL import Image, ImageDraw, ImageFont, ImageFilter

OUTPUT_DIR = r"C:\Project\virasat\assets\images\crafts"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# 110 Craft Specs: (filename, craft_display_name, category_type, state_name, base_color_hue)
CRAFT_SPECS = [
    # Gujarat (15)
    ("bandhani_01.jpg", "Bandhani Saree", "tie_dye", "Gujarat", 0),      # Crimson Red
    ("bandhani_02.jpg", "Bandhani Dupatta", "tie_dye", "Gujarat", 45),   # Marigold Gold
    ("bandhani_03.jpg", "Bandhani Kurti", "tie_dye", "Gujarat", 140),   # Emerald Green
    ("bandhani_04.jpg", "Bandhani Lehenga", "tie_dye", "Gujarat", 280),  # Royal Purple
    ("bandhani_05.jpg", "Bandhani Stole", "tie_dye", "Gujarat", 15),     # Rust Orange

    ("patola_01.jpg", "Rajkot Patola Silk", "double_ikat", "Gujarat", 350),  # Deep Ruby
    ("patola_02.jpg", "Patan Double Ikat", "double_ikat", "Gujarat", 40),   # Ocher Gold
    ("patola_03.jpg", "Patola Weaver Shawl", "double_ikat", "Gujarat", 200),# Teal Blue
    ("patola_04.jpg", "Heritage Patola Saree", "double_ikat", "Gujarat", 320),# Magenta

    ("ajrakh_01.jpg", "Ajrakh Block Stole", "block_print", "Gujarat", 220), # Indigo Navy
    ("ajrakh_02.jpg", "Ajrakh Cotton Dupatta", "block_print", "Gujarat", 10),# Madder Red
    ("ajrakh_03.jpg", "Ajrakh Modal Silk", "block_print", "Gujarat", 130), # Forest Green

    ("rogan_art_01.jpg", "Tree of Life Rogan", "paint_art", "Gujarat", 30),  # Terracotta
    ("rogan_art_02.jpg", "Rogan Wall Art", "paint_art", "Gujarat", 190),     # Peacock Teal
    ("rogan_art_03.jpg", "Rogan Yellow Panel", "paint_art", "Gujarat", 50),  # Warm Amber

    # Rajasthan (15)
    ("blue_pottery_01.jpg", "Blue Pottery Vase", "pottery", "Rajasthan", 210), # Cobalt Blue
    ("blue_pottery_02.jpg", "Blue Pottery Plate", "pottery", "Rajasthan", 195),# Turquoise
    ("blue_pottery_03.jpg", "Blue Pottery Planter", "pottery", "Rajasthan", 225),# Ultramarine
    ("blue_pottery_04.jpg", "Blue Pottery Coasters", "pottery", "Rajasthan", 180),# Cyan
    ("blue_pottery_05.jpg", "Blue Pottery Jar", "pottery", "Rajasthan", 205),   # Royal Blue

    ("meenakari_01.jpg", "Meenakari Peacock Jhumka", "jewelry", "Rajasthan", 340),# Crimson Enamel
    ("meenakari_02.jpg", "Meenakari Bangle Set", "jewelry", "Rajasthan", 150),    # Emerald Enamel
    ("meenakari_03.jpg", "Meenakari Pendant", "jewelry", "Rajasthan", 45),       # Gold Enamel

    ("bagru_print_01.jpg", "Bagru Dabu Bedspread", "block_print", "Rajasthan", 25), # Mud Brown
    ("bagru_print_02.jpg", "Bagru Natural Indigo", "block_print", "Rajasthan", 215),# Deep Indigo
    ("bagru_print_03.jpg", "Bagru Harda Yellow", "block_print", "Rajasthan", 55),   # Harda Gold

    ("sanganeri_print_01.jpg", "Sanganeri Floral Cotton", "block_print", "Rajasthan", 355),# Rose Pink
    ("sanganeri_print_02.jpg", "Sanganeri Chintz Dress", "block_print", "Rajasthan", 170), # Mint Green
    ("sanganeri_print_03.jpg", "Sanganeri Table Runner", "block_print", "Rajasthan", 35), # Saffron
    ("sanganeri_print_04.jpg", "Sanganeri Kurti Fabric", "block_print", "Rajasthan", 270),# Lilac

    # Madhya Pradesh (10)
    ("chanderi_01.jpg", "Chanderi Tissue Saree", "sheer_weave", "Madhya Pradesh", 45), # Gold Tissue
    ("chanderi_02.jpg", "Chanderi Zari Cotton", "sheer_weave", "Madhya Pradesh", 340),# Fuchsia Zari
    ("chanderi_03.jpg", "Chanderi Pastel Dupatta", "sheer_weave", "Madhya Pradesh", 160),# Mint Pastel
    ("chanderi_04.jpg", "Chanderi Katan Silk", "sheer_weave", "Madhya Pradesh", 210),# Royal Blue
    ("chanderi_05.jpg", "Chanderi Motifs Saree", "sheer_weave", "Madhya Pradesh", 15),# Coral

    ("gond_painting_01.jpg", "Gond Wildlife Canvas", "folk_art", "Madhya Pradesh", 30), # Warm Ochre
    ("gond_painting_02.jpg", "Gond Tree of Life", "folk_art", "Madhya Pradesh", 130), # Forest Moss
    ("gond_painting_03.jpg", "Gond Deer Motif", "folk_art", "Madhya Pradesh", 200),  # Peacock Blue
    ("gond_painting_04.jpg", "Gond Tribal Sun", "folk_art", "Madhya Pradesh", 15),    # Clay Red
    ("gond_painting_05.jpg", "Gond Bird Symphony", "folk_art", "Madhya Pradesh", 280),# Violet

    # Uttar Pradesh (10)
    ("chikankari_01.jpg", "Chikankari White Kurti", "embroidery", "Uttar Pradesh", 200),# Pure Ivory
    ("chikankari_02.jpg", "Chikankari Georgette", "embroidery", "Uttar Pradesh", 330), # Soft Blush
    ("chikankari_03.jpg", "Chikankari Anarkali", "embroidery", "Uttar Pradesh", 175),  # Seafoam
    ("chikankari_04.jpg", "Chikankari Palazzo", "embroidery", "Uttar Pradesh", 240),   # Powder Lavender
    ("chikankari_05.jpg", "Chikankari Dupatta", "embroidery", "Uttar Pradesh", 50),    # Champagne Gold

    ("banarasi_silk_01.jpg", "Banarasi Katan Saree", "brocade", "Uttar Pradesh", 0),   # Vermilion Red
    ("banarasi_silk_02.jpg", "Banarasi Jangla Brocade", "brocade", "Uttar Pradesh", 45),# Antique Gold
    ("banarasi_silk_03.jpg", "Banarasi Tanchoi Silk", "brocade", "Uttar Pradesh", 280),# Deep Purple
    ("banarasi_silk_04.jpg", "Banarasi Organza Zari", "brocade", "Uttar Pradesh", 140),# Emerald Zari
    ("banarasi_silk_05.jpg", "Banarasi Royal Blue", "brocade", "Uttar Pradesh", 220), # Sapphire Blue

    # West Bengal (10)
    ("kantha_01.jpg", "Kantha Stitch Saree", "stitching", "West Bengal", 15),       # Terracotta Brick
    ("kantha_02.jpg", "Kantha Embroidered Stole", "stitching", "West Bengal", 45),  # Honey Amber
    ("kantha_03.jpg", "Kantha Tussar Silk", "stitching", "West Bengal", 130),       # Olive Silk
    ("kantha_04.jpg", "Kantha Bed Cover", "stitching", "West Bengal", 210),         # Indigo Kantha
    ("kantha_05.jpg", "Kantha Wall Hanging", "stitching", "West Bengal", 330),      # Berry Magenta

    ("bankura_terracotta_01.jpg", "Bankura Horse Pair", "terracotta", "West Bengal", 18),# Terracotta Red
    ("bankura_terracotta_02.jpg", "Bankura Elephant Figure", "terracotta", "West Bengal", 28),# Burnt Clay
    ("bankura_terracotta_03.jpg", "Bankura Wall Tile", "terracotta", "West Bengal", 38),# Earthen Brown
    ("bankura_terracotta_04.jpg", "Bankura Bell Artifact", "terracotta", "West Bengal", 12),# Dark Terracotta
    ("bankura_terracotta_05.jpg", "Bankura Temple Plaque", "terracotta", "West Bengal", 24),# Warm Ochre Clay

    # Kashmir (10)
    ("pashmina_01.jpg", "Kashmiri Pashmina Shawl", "wool_weave", "Kashmir", 350),  # Deep Rose
    ("pashmina_02.jpg", "Kani Pashmina Weave", "wool_weave", "Kashmir", 40),      # Saffron Gold
    ("pashmina_03.jpg", "Sozni Embroidered Shawl", "wool_weave", "Kashmir", 195),  # Kashmiri Teal
    ("pashmina_04.jpg", "Pure Cashmere Stole", "wool_weave", "Kashmir", 280),     # Plum Violet
    ("pashmina_05.jpg", "Jama Pashmina Classic", "wool_weave", "Kashmir", 130),   # Sage Olive

    ("papier_mache_01.jpg", "Papier-Mâché Trinket Box", "paper_craft", "Kashmir", 210),# Royal Kashmiri Blue
    ("papier_mache_02.jpg", "Papier-Mâché Vase", "paper_craft", "Kashmir", 45),     # Chinar Gold
    ("papier_mache_03.jpg", "Papier-Mâché Samovar", "paper_craft", "Kashmir", 0),   # Chinar Crimson
    ("papier_mache_04.jpg", "Papier-Mâché Plate", "paper_craft", "Kashmir", 140),   # Emerald Leaf
    ("papier_mache_05.jpg", "Papier-Mâché Coasters", "paper_craft", "Kashmir", 290),# Imperial Purple

    # Odisha (10)
    ("pattachitra_01.jpg", "Pattachitra Jagannath Art", "palm_art", "Odisha", 30), # Vermilion Ochre
    ("pattachitra_02.jpg", "Pattachitra Krishna Leela", "palm_art", "Odisha", 200),# Indigo Cobalt
    ("pattachitra_03.jpg", "Pattachitra Palm Leaf Etching", "palm_art", "Odisha", 40),# Natural Palm Gold
    ("pattachitra_04.jpg", "Pattachitra Tree Canvas", "palm_art", "Odisha", 120),  # Herbal Green
    ("pattachitra_05.jpg", "Pattachitra Painted Box", "palm_art", "Odisha", 340),  # Deep Crimson

    ("silver_filigree_01.jpg", "Tarakasi Silver Brooch", "metal_wire", "Odisha", 210),# Sterling Silver Blue
    ("silver_filigree_02.jpg", "Tarakasi Filigree Earrings", "metal_wire", "Odisha", 0),# Sterling Silver Rose
    ("silver_filigree_03.jpg", "Tarakasi Silver Taj Model", "metal_wire", "Odisha", 270),# Sterling Silver Lilac
    ("silver_filigree_04.jpg", "Tarakasi Filigree Box", "metal_wire", "Odisha", 45), # Sterling Silver Gold Accent
    ("silver_filigree_05.jpg", "Tarakasi Silver Pendant", "metal_wire", "Odisha", 170),# Sterling Silver Mint

    # Karnataka (10)
    ("channapatna_toys_01.jpg", "Channapatna Wooden Stacker", "lacquer_wood", "Karnataka", 50),# Lacquer Yellow
    ("channapatna_toys_02.jpg", "Channapatna Rocking Horse", "lacquer_wood", "Karnataka", 15),# Lacquer Orange
    ("channapatna_toys_03.jpg", "Channapatna Animal Figures", "lacquer_wood", "Karnataka", 130),# Lacquer Green
    ("channapatna_toys_04.jpg", "Channapatna Spinning Top", "lacquer_wood", "Karnataka", 340),# Lacquer Red
    ("channapatna_toys_05.jpg", "Channapatna Decorative Pegs", "lacquer_wood", "Karnataka", 200),# Lacquer Blue

    ("mysore_silk_01.jpg", "Mysore Silk Gold Zari Saree", "silk_weave", "Karnataka", 345),# Royal Magenta
    ("mysore_silk_02.jpg", "Mysore Crepe Silk", "silk_weave", "Karnataka", 215),        # Peacock Royal Blue
    ("mysore_silk_03.jpg", "Mysore Silk Brocade", "silk_weave", "Karnataka", 45),        # Pure Gold Silk
    ("mysore_silk_04.jpg", "Mysore Silk Zari Border", "silk_weave", "Karnataka", 140),   # Deep Emerald Silk
    ("mysore_silk_05.jpg", "Mysore Printed Silk", "silk_weave", "Karnataka", 15),        # Deep Ochre Silk

    # Tamil Nadu (10)
    ("kanchipuram_silk_01.jpg", "Kanchipuram Temple Saree", "heavy_silk", "Tamil Nadu", 355),# Crimson Temple Gold
    ("kanchipuram_silk_02.jpg", "Kanchipuram Bridal Silk", "heavy_silk", "Tamil Nadu", 40),  # Mustard Yellow Zari
    ("kanchipuram_silk_03.jpg", "Kanchipuram Korvai Silk", "heavy_silk", "Tamil Nadu", 280),# Violet Magenta
    ("kanchipuram_silk_04.jpg", "Kanchipuram Pure Mulberry", "heavy_silk", "Tamil Nadu", 145),# Forest Emerald
    ("kanchipuram_silk_05.jpg", "Kanchipuram Dual Tone Silk", "heavy_silk", "Tamil Nadu", 205),# Peacock Cyan Blue

    ("tanjore_painting_01.jpg", "Tanjore Gold Foil Ganesha", "gold_art", "Tamil Nadu", 45), # Gold Leaf Red
    ("tanjore_painting_02.jpg", "Tanjore Goddess Lakshmi", "gold_art", "Tamil Nadu", 40),  # Antique Gold Leaf
    ("tanjore_painting_03.jpg", "Tanjore Krishna Frame", "gold_art", "Tamil Nadu", 210),  # Sapphire Gold Leaf
    ("tanjore_painting_04.jpg", "Tanjore Saraswati Art", "gold_art", "Tamil Nadu", 130),  # Emerald Gold Leaf
    ("tanjore_painting_05.jpg", "Tanjore Peacock Panel", "gold_art", "Tamil Nadu", 330),  # Magenta Gold Leaf

    # North-East (10)
    ("bamboo_basket_01.jpg", "Assam Woven Bamboo Basket", "bamboo", "Assam", 35),       # Natural Cane Gold
    ("bamboo_basket_02.jpg", "Tripura Fine Mesh Basket", "bamboo", "Tripura", 45),     # Honey Bamboo
    ("bamboo_basket_03.jpg", "Nagaland Storage Basket", "bamboo", "Nagaland", 25),     # Smoked Dark Bamboo
    ("bamboo_basket_04.jpg", "Manipur Fruit Basket", "bamboo", "Manipur", 60),          # Golden Bamboo

    ("cane_craft_01.jpg", "Assam Cane Planter Box", "bamboo", "Assam", 38),             # Woven Cane Sand
    ("cane_craft_02.jpg", "Meghalaya Cane Tray", "bamboo", "Meghalaya", 42),            # Light Natural Cane
    ("cane_craft_03.jpg", "Mizoram Cane Lamp Shade", "bamboo", "Mizoram", 28),          # Amber Warm Cane

    ("assam_silk_01.jpg", "Muga Silk Golden Saree", "wild_silk", "Assam", 48),          # Natural Muga Gold
    ("assam_silk_02.jpg", "Eri Silk Soft Shawl", "wild_silk", "Assam", 35),             # Soft Ivory Eri
    ("assam_silk_03.jpg", "Paat Silk Mekhela Chador", "wild_silk", "Assam", 200),       # Royal Indigo Assam Silk
]

def hsl_to_rgb(h, s, l):
    """Simple HSL (h 0..360, s 0..100, l 0..100) to RGB tuple."""
    c = (1 - abs(2 * (l/100) - 1)) * (s/100)
    x = c * (1 - abs((h / 60) % 2 - 1))
    m = (l/100) - c/2
    if 0 <= h < 60:
        r, g, b = c, x, 0
    elif 60 <= h < 120:
        r, g, b = x, c, 0
    elif 120 <= h < 180:
        r, g, b = 0, c, x
    elif 180 <= h < 240:
        r, g, b = 0, x, c
    elif 240 <= h < 300:
        r, g, b = x, 0, c
    else:
        r, g, b = c, 0, x
    return (int((r + m) * 255), int((g + m) * 255), int((b + m) * 255))

def generate_image(filename, craft_title, category, state, base_hue):
    width, height = 600, 600
    img = Image.new("RGB", (width, height), hsl_to_rgb(base_hue, 70, 15))
    draw = ImageDraw.Draw(img)

    # 1. Base Gradient / Texture Background
    for y in range(height):
        ratio = y / height
        hue = (base_hue + ratio * 15) % 360
        lightness = 18 + ratio * 20
        color = hsl_to_rgb(hue, 65, lightness)
        draw.line([(0, y), (width, y)], fill=color)

    # 2. Craft-Specific Procedural Artwork / Motifs
    random.seed(hash(filename))

    if category == "tie_dye": # Bandhani tie dye dots
        for _ in range(350):
            cx = random.randint(30, width - 30)
            cy = random.randint(30, height - 30)
            r = random.randint(4, 12)
            draw.ellipse([cx-r, cy-r, cx+r, cy+r], fill=(255, 255, 255), outline=hsl_to_rgb(base_hue, 90, 45))
            draw.ellipse([cx-r//2, cy-r//2, cx+r//2, cy+r//2], fill=hsl_to_rgb((base_hue+60)%360, 90, 60))

    elif category == "double_ikat": # Patola diamond lattice
        grid_size = 50
        for x in range(0, width, grid_size):
            for y in range(0, height, grid_size):
                pts = [(x + grid_size//2, y), (x + grid_size, y + grid_size//2),
                       (x + grid_size//2, y + grid_size), (x, y + grid_size//2)]
                draw.polygon(pts, outline=hsl_to_rgb(45, 90, 70), fill=hsl_to_rgb(base_hue, 50, 30))
                draw.polygon([(p[0]*0.8+x*0.2, p[1]*0.8+y*0.2) for p in pts], fill=hsl_to_rgb((base_hue+120)%360, 80, 50))

    elif category == "block_print": # Ajrakh / Bagru geometric blocks
        for x in range(20, width - 20, 70):
            for y in range(20, height - 20, 70):
                draw.rectangle([x, y, x+60, y+60], outline=hsl_to_rgb(45, 80, 75), width=2)
                draw.ellipse([x+10, y+10, x+50, y+50], outline=hsl_to_rgb(base_hue, 90, 80), width=2)
                draw.line([(x+30, y+10), (x+30, y+50)], fill=hsl_to_rgb(45, 90, 80), width=2)
                draw.line([(x+10, y+30), (x+50, y+30)], fill=hsl_to_rgb(45, 90, 80), width=2)

    elif category == "pottery": # Blue Pottery floral circles
        center_x, center_y = width // 2, height // 2
        for radius in range(240, 40, -40):
            draw.ellipse([center_x-radius, center_y-radius, center_x+radius, center_y+radius],
                         outline=hsl_to_rgb(210, 90, 85), width=4, fill=hsl_to_rgb(205, 80, (radius//3)+20))
        for angle in range(0, 360, 30):
            rad = math.radians(angle)
            px = center_x + int(140 * math.cos(rad))
            py = center_y + int(140 * math.sin(rad))
            draw.ellipse([px-15, py-15, px+15, py+15], fill=(255, 255, 255), outline=hsl_to_rgb(220, 90, 40))

    elif category == "jewelry": # Meenakari gold enamel
        cx, cy = width // 2, height // 2
        for r in [220, 170, 120, 70]:
            draw.ellipse([cx-r, cy-r, cx+r, cy+r], outline=(255, 215, 0), width=6)
        for i in range(12):
            angle = i * (360 / 12)
            rad = math.radians(angle)
            x = cx + int(140 * math.cos(rad))
            y = cy + int(140 * math.sin(rad))
            draw.polygon([(x, y-15), (x+15, y+15), (x-15, y+15)], fill=hsl_to_rgb((base_hue+i*20)%360, 90, 50), outline=(255, 215, 0))

    elif category == "folk_art": # Gond painting intricate dots & lines
        for _ in range(60):
            x1, y1 = random.randint(20, width-20), random.randint(20, height-20)
            x2, y2 = x1 + random.randint(-150, 150), y1 + random.randint(-150, 150)
            draw.line([(x1, y1), (x2, y2)], fill=hsl_to_rgb(random.randint(0, 360), 85, 65), width=5)
            draw.ellipse([x1-8, y1-8, x1+8, y1+8], fill=(255, 255, 255))

    elif category == "embroidery": # Chikankari delicate white shadow work
        for x in range(30, width, 60):
            for y in range(30, height, 60):
                draw.arc([x-25, y-25, x+25, y+25], 0, 360, fill=(255, 255, 255), width=2)
                draw.line([(x-15, y), (x+15, y)], fill=(245, 245, 250), width=3)
                draw.line([(x, y-15), (x, y+15)], fill=(245, 245, 250), width=3)

    elif category in ["brocade", "heavy_silk", "silk_weave", "wild_silk", "sheer_weave"]: # Zari gold weaves
        for i in range(0, width, 25):
            draw.line([(i, 0), (i+150, height)], fill=(212, 175, 55, 128), width=2)
            draw.line([(width-i, 0), (width-i-150, height)], fill=(255, 223, 0, 128), width=2)
        # Gold Border
        draw.rectangle([15, 15, width-15, height-15], outline=(255, 215, 0), width=8)

    elif category == "terracotta": # Bankura terracotta clay relief
        cx, cy = width // 2, height // 2
        draw.rectangle([30, 30, width-30, height-30], outline=(160, 82, 45), width=10)
        draw.ellipse([cx-120, cy-120, cx+120, cy+120], outline=(210, 105, 30), width=8)
        draw.polygon([(cx, cy-80), (cx+70, cy+60), (cx-70, cy+60)], fill=(139, 69, 19), outline=(255, 140, 0))

    elif category == "gold_art": # Tanjore gold leaf framing
        draw.rectangle([20, 20, width-20, height-20], outline=(255, 215, 0), width=14)
        draw.rectangle([35, 35, width-35, height-35], outline=(184, 134, 11), width=4)
        cx, cy = width // 2, height // 2
        draw.ellipse([cx-110, cy-110, cx+110, cy+110], fill=(139, 0, 0), outline=(255, 215, 0), width=6)
        draw.polygon([(cx, cy-60), (cx+50, cy+40), (cx-50, cy+40)], fill=(255, 215, 0))

    elif category in ["bamboo", "lacquer_wood", "paper_craft", "metal_wire", "stitching", "palm_art", "wool_weave"]:
        # Fine lattice / weave texture
        step = 20
        for i in range(-height, width + height, step):
            draw.line([(i, 0), (i + height, height)], fill=hsl_to_rgb((base_hue+20)%360, 40, 40), width=2)
            draw.line([(i, height), (i + height, 0)], fill=hsl_to_rgb(base_hue, 50, 60), width=2)

    # 3. Outer Decorative Frame
    draw.rectangle([10, 10, width-10, height-10], outline=(255, 255, 255), width=3)

    # 4. Premium Craft Badge & Typography Banner (Bottom)
    banner_height = 110
    banner_y = height - banner_height - 20
    draw.rectangle([20, banner_y, width-20, height-20], fill=(0, 0, 0, 200))
    draw.rectangle([20, banner_y, width-20, height-20], outline=hsl_to_rgb(base_hue, 80, 65), width=2)

    # State Tag
    draw.rectangle([35, banner_y + 12, 170, banner_y + 32], fill=hsl_to_rgb(base_hue, 90, 45))
    
    # Save image with high quality
    filepath = os.path.join(OUTPUT_DIR, filename)
    img.save(filepath, "JPEG", quality=92)

print(f"Generating {len(CRAFT_SPECS)} craft images in {OUTPUT_DIR}...")
for filename, title, category, state, hue in CRAFT_SPECS:
    generate_image(filename, title, category, state, hue)

print(f"SUCCESS: Generated {len(CRAFT_SPECS)} unique craft images in assets/images/crafts/")
