import os
from PIL import Image, ImageDraw, ImageFilter
import numpy as np

def extract_logo_artwork():
    img_path = r'C:/Users/Lenovo/.gemini/antigravity/brain/4c0cfe7b-35ec-4b97-8801-187504270138/.user_uploaded/media_1789495784988.png'
    img = Image.open(img_path).convert('RGBA')

    # Bounding box containing the logo mark inside top-left squircle card:
    # X: 55..185, Y: 35..135
    logo_crop = img.crop((55, 34, 185, 136))
    
    arr = np.array(logo_crop)
    r, g, b, a = arr[:,:,0], arr[:,:,1], arr[:,:,2], arr[:,:,3]

    # Sample cream background from the corners of this crop box (e.g. at 2, 2)
    cream_r, cream_g, cream_b = arr[2, 2, 0], arr[2, 2, 1], arr[2, 2, 2]
    print(f"Sampled cream background RGB: ({cream_r}, {cream_g}, {cream_b})")

    # Compute Euclidean color distance from cream background for each pixel
    dist = np.sqrt((r.astype(float) - cream_r)**2 + (g.astype(float) - cream_g)**2 + (b.astype(float) - cream_b)**2)
    
    # Smooth alpha mask: 0 for cream background, 255 for logo artwork
    # Thresholding with soft transition curve (dist between 12 and 35)
    alpha = np.clip((dist - 12) * (255.0 / 23.0), 0, 255).astype(np.uint8)
    
    # Reassemble RGBA logo artwork
    logo_rgba = np.dstack((r, g, b, alpha))
    logo_artwork = Image.fromarray(logo_rgba, mode='RGBA')

    # Trim any extra fully transparent border
    bbox = logo_artwork.getbbox()
    if bbox:
        logo_artwork = logo_artwork.crop(bbox)
        print("Trimmed logo artwork size:", logo_artwork.size)

    # Palette cream background color #FFF8F1 (255, 248, 241, 255)
    cream_bg_color = (255, 248, 241, 255) # #FFF8F1

    # Desired Master Size: 1024x1024
    master_size = 1024
    # Desired Padding: ~18-20% padding -> Artwork size ~640px inside 1024px canvas
    artwork_target_size = 640

    w, h = logo_artwork.size
    aspect = w / h
    if aspect >= 1.0:
        new_w = artwork_target_size
        new_h = int(artwork_target_size / aspect)
    else:
        new_h = artwork_target_size
        new_w = int(artwork_target_size * aspect)

    logo_scaled = logo_artwork.resize((new_w, new_h), Image.Resampling.LANCZOS)

    # 1. Generate Master 1024x1024 PNG on #FFF8F1 Cream Background
    master_png = Image.new("RGBA", (master_size, master_size), cream_bg_color)
    offset_x = (master_size - new_w) // 2
    offset_y = (master_size - new_h) // 2
    master_png.paste(logo_scaled, (offset_x, offset_y), logo_scaled)

    os.makedirs("c:/Project/virasat/assets/logos", exist_ok=True)
    master_png.save("c:/Project/virasat/assets/logos/virasat_v_mark.png", "PNG")
    master_png.save("c:/Project/virasat/assets/logos/virasat_logo.png", "PNG")

    # 2. Generate 512x512 Native Splash Icon
    splash_png = master_png.resize((512, 512), Image.Resampling.LANCZOS)
    splash_png.save("c:/Project/virasat/assets/logos/virasat_splash_icon.png", "PNG")

    # 3. Generate 1024x1024 Android Adaptive Foreground PNG (Transparent Background)
    adaptive_fg = Image.new("RGBA", (master_size, master_size), (0, 0, 0, 0))
    adaptive_fg.paste(logo_scaled, (offset_x, offset_y), logo_scaled)
    adaptive_fg.save("c:/Project/virasat/assets/logos/virasat_logo_adaptive.png", "PNG")

    print("Master 1024x1024 PNG, Adaptive Foreground, and Splash icons generated successfully!")

if __name__ == "__main__":
    extract_logo_artwork()
