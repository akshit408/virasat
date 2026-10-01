import os
from PIL import Image, ImageFilter, ImageOps
import numpy as np

def extract_and_generate_branding():
    img_path = r'C:/Users/Lenovo/.gemini/antigravity/brain/4c0cfe7b-35ec-4b97-8801-187504270138/.user_uploaded/media_1789495100788.png'
    img = Image.open(img_path).convert('RGBA')

    # Bounding box of cream squircle card: x: 54..253, y: 68..256
    crop_box = (53, 67, 254, 257)
    card = img.crop(crop_box)
    
    w_orig, h_orig = card.size
    print(f"Original cropped card dimensions: {w_orig}x{h_orig}")

    # Cream background color sampled from top-left inside card
    cream_rgb = (253, 244, 228, 255) # #FDF4E4
    
    # 1. Create High-Resolution 1024x1024 Squircle/Full Launcher Icon
    # Upscale cropped card to high-res using LANCZOS
    high_res_card = card.resize((1024, 1024), Image.Resampling.LANCZOS)

    # Clean up outer rounded corners of the card if any dark background remains at extreme corners
    # Mask out corners with rounded rectangle mask
    mask_card = Image.new("L", (1024, 1024), 0)
    from PIL import ImageDraw
    draw_mask = ImageDraw.Draw(mask_card)
    draw_mask.rounded_rectangle([0, 0, 1024, 1024], radius=220, fill=255)
    
    # Place on solid cream background #FDF4E4
    full_icon = Image.new("RGBA", (1024, 1024), cream_rgb)
    full_icon.paste(high_res_card, (0, 0), mask_card)

    os.makedirs("c:/Project/virasat/assets/logos", exist_ok=True)
    full_icon.save("c:/Project/virasat/assets/logos/virasat_v_mark.png", "PNG")
    full_icon.save("c:/Project/virasat/assets/logos/virasat_logo.png", "PNG")
    full_icon.save("c:/Project/virasat/assets/logos/virasat_splash_icon.png", "PNG")

    # 2. Create Adaptive Icon Foreground (virasat_logo_adaptive.png)
    # Extract the exact logo artwork with alpha transparency on cream
    # Logo artwork is inside card with a padding around it
    arr = np.array(card)
    r, g, b, a = arr[:,:,0], arr[:,:,1], arr[:,:,2], arr[:,:,3]

    # Calculate distance from cream_rgb (253, 244, 228)
    dist = np.sqrt((r.astype(float) - 253)**2 + (g.astype(float) - 244)**2 + (b.astype(float) - 228)**2)
    
    # Alpha mask: 0 where color is close to cream, 255 where color is logo
    # Soft alpha transition for clean anti-aliased edges
    alpha = np.clip((dist - 15) * 8, 0, 255).astype(np.uint8)
    
    logo_rgba = np.dstack((r, g, b, alpha))
    logo_img = Image.fromarray(logo_rgba, mode='RGBA')

    # Bounding box of non-transparent logo pixels
    bbox = logo_img.getbbox()
    print("Logo artwork bbox inside card:", bbox)
    if bbox:
        logo_cropped = logo_img.crop(bbox)
        
        # Fit inside 1024x1024 canvas within safe area (~600x600 size in center)
        target_size = 620
        aspect = logo_cropped.width / logo_cropped.height
        if aspect >= 1.0:
            new_w = target_size
            new_h = int(target_size / aspect)
        else:
            new_h = target_size
            new_w = int(target_size * aspect)
            
        logo_scaled = logo_cropped.resize((new_w, new_h), Image.Resampling.LANCZOS)
        
        adaptive_fg = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
        offset_x = (1024 - new_w) // 2
        offset_y = (1024 - new_h) // 2
        adaptive_fg.paste(logo_scaled, (offset_x, offset_y), logo_scaled)
        adaptive_fg.save("c:/Project/virasat/assets/logos/virasat_logo_adaptive.png", "PNG")

    print("Official uploaded logo branding assets extracted & generated successfully!")

if __name__ == "__main__":
    extract_and_generate_branding()
