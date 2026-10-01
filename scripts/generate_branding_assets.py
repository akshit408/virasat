import os
import math
from PIL import Image, ImageDraw, ImageFilter

def create_virasat_v_mark(size=1024, padding_ratio=0.18, bg_color=None):
    # High resolution surface for anti-aliasing (supersampled 2x)
    render_size = size * 2
    pad = int(render_size * padding_ratio)
    
    img = Image.new("RGBA", (render_size, render_size), bg_color if bg_color else (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    def transform_coords(pts):
        res = []
        usable_w = render_size - 2 * pad
        usable_h = render_size - 2 * pad
        for x, y in pts:
            nx = pad + (x / 1000.0) * usable_w
            ny = pad + (y / 1000.0) * usable_h
            res.append((nx, ny))
        return res

    # Palette
    forest_green = (31, 94, 69, 255)      # #1F5E45
    saffron_gold = (229, 163, 75, 255)    # #E5A34B
    terracotta   = (166, 62, 36, 255)     # #A63E24
    dark_brown   = (59, 35, 20, 255)      # #3B2314

    # 1. Sun behind the monument (top center: 500, 310, r=105)
    sun_pts = []
    cx, cy, radius = 500, 310, 105
    for angle in range(0, 360, 5):
        rad = math.radians(angle)
        sun_pts.append((cx + radius * math.cos(rad), cy + radius * math.sin(rad)))
    draw.polygon(transform_coords(sun_pts), fill=saffron_gold)

    # Sun rays accent
    for r_offset in [120, 135]:
        ray_pts = []
        for angle in range(0, 360, 10):
            rad = math.radians(angle)
            ray_pts.append((cx + r_offset * math.cos(rad), cy + r_offset * math.sin(rad)))
        draw.polygon(transform_coords(ray_pts), fill=(229, 163, 75, 60))

    # 2. Monument Silhouette in top center (Arch & Dome structure)
    monument_poly = [
        (460, 410), (460, 340), (475, 340), (475, 310),
        (490, 310), (500, 275), (510, 310), (525, 310),
        (525, 340), (540, 340), (540, 410),
        # Arch cutout curve inside
        (525, 410), (525, 375), (515, 360), (500, 355), (485, 360), (475, 375), (475, 410)
    ]
    draw.polygon(transform_coords(monument_poly), fill=dark_brown)

    # 3. Left Wing - Forest Green Organic Leaf Half of the 'V'
    leaf_pts = [
        (500, 860),
        (440, 780),
        (350, 650),
        (260, 500),
        (180, 340),
        (150, 220), # Tip of leaf
        (210, 240),
        (290, 310),
        (370, 420),
        (430, 540),
        (475, 680),
        (500, 770),
    ]
    draw.polygon(transform_coords(leaf_pts), fill=forest_green)
    
    # Leaf inner veining highlight
    leaf_vein = [
        (220, 290), (320, 420), (400, 560), (460, 720)
    ]
    t_vein = transform_coords(leaf_vein)
    draw.line(t_vein, fill=(255, 255, 255, 80), width=int(12 * (render_size / 1000.0)))

    # 4. Right Wing - Saffron Artisan Hand/Flames Curve Half of the 'V'
    artisan_pts = [
        (500, 860),
        (560, 780),
        (650, 650),
        (740, 500),
        (820, 340),
        (850, 220), # Tip
        (790, 240),
        (710, 310),
        (630, 420),
        (570, 540),
        (525, 680),
        (500, 770),
    ]
    draw.polygon(transform_coords(artisan_pts), fill=saffron_gold)
    
    # Artisan inner accent line
    artisan_vein = [
        (780, 290), (680, 420), (600, 560), (540, 720)
    ]
    t_artisan_vein = transform_coords(artisan_vein)
    draw.line(t_artisan_vein, fill=(255, 255, 255, 90), width=int(12 * (render_size / 1000.0)))

    # 5. Center Bottom Convergence Jewel / Terracotta Accent
    jewel_pts = [
        (500, 880), (475, 820), (500, 770), (525, 820)
    ]
    draw.polygon(transform_coords(jewel_pts), fill=terracotta)

    # Downsample using LANCZOS for crisp anti-aliasing
    img_final = img.resize((size, size), Image.Resampling.LANCZOS)
    return img_final

def generate_all_branding_assets():
    os.makedirs("c:/Project/virasat/assets/logos", exist_ok=True)
    
    # 1. Standalone V Mark (1024x1024)
    v_mark = create_virasat_v_mark(size=1024, padding_ratio=0.15)
    v_mark.save("c:/Project/virasat/assets/logos/virasat_v_mark.png", "PNG")
    v_mark.save("c:/Project/virasat/assets/logos/virasat_logo.png", "PNG")

    # 2. Adaptive Icon Foreground (1024x1024, ~0.28 padding for safe zone)
    v_adaptive_fg = create_virasat_v_mark(size=1024, padding_ratio=0.28)
    v_adaptive_fg.save("c:/Project/virasat/assets/logos/virasat_logo_adaptive.png", "PNG")

    # 3. Native Splash Icon (512x512)
    v_splash = create_virasat_v_mark(size=512, padding_ratio=0.18)
    v_splash.save("c:/Project/virasat/assets/logos/virasat_splash_icon.png", "PNG")
    
    print("Branding assets generated successfully in assets/logos/")

if __name__ == "__main__":
    generate_all_branding_assets()
