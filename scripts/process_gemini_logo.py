import os
from PIL import Image
import numpy as np

def process_gemini_generated_logo():
    gemini_img_path = r'C:/Users/Lenovo/.gemini/antigravity/brain/4c0cfe7b-35ec-4b97-8801-187504270138/virasat_official_gemini_logo_1789497087152.jpg'
    
    img = Image.open(gemini_img_path).convert('RGBA')
    print(f"Loaded Gemini generated image size: {img.size}")

    # Resize master image to 1024x1024
    master_1024 = img.resize((1024, 1024), Image.Resampling.LANCZOS)
    
    os.makedirs("c:/Project/virasat/assets/logos", exist_ok=True)
    master_1024.save("c:/Project/virasat/assets/logos/virasat_v_mark.png", "PNG")
    master_1024.save("c:/Project/virasat/assets/logos/virasat_logo.png", "PNG")

    # Native splash icon 512x512
    splash_512 = img.resize((512, 512), Image.Resampling.LANCZOS)
    splash_512.save("c:/Project/virasat/assets/logos/virasat_splash_icon.png", "PNG")

    # Extract logo artwork with alpha transparency (remove cream background)
    arr = np.array(master_1024)
    r, g, b, a = arr[:,:,0], arr[:,:,1], arr[:,:,2], arr[:,:,3]

    # Cream background is near RGB (250, 246, 237)
    cream_r, cream_g, cream_b = 250, 246, 237
    dist = np.sqrt((r.astype(float) - cream_r)**2 + (g.astype(float) - cream_g)**2 + (b.astype(float) - cream_b)**2)

    # Soft alpha mask: 0 where cream, 255 where logo artwork
    alpha = np.clip((dist - 15) * (255.0 / 25.0), 0, 255).astype(np.uint8)
    
    logo_rgba = np.dstack((r, g, b, alpha))
    logo_transparent = Image.fromarray(logo_rgba, mode='RGBA')
    
    # Save adaptive foreground
    logo_transparent.save("c:/Project/virasat/assets/logos/virasat_logo_adaptive.png", "PNG")

    # Tight crop for Flutter animated splash screen
    bbox = logo_transparent.getbbox()
    if bbox:
        tight_logo = logo_transparent.crop(bbox)
        tight_logo.save("c:/Project/virasat/assets/logos/virasat_v_mark_tight.png", "PNG")
        print(f"Tight crop saved size: {tight_logo.size}")

    print("Gemini-generated official VIRASAT logo assets processed successfully!")

if __name__ == "__main__":
    process_gemini_generated_logo()
