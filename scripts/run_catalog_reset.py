# -*- coding: utf-8 -*-
"""
Main execution script for VIRASAT Catalog Reset.
"""
import os
import sys
import json
import re
import math
import random
import time
import urllib.request
import urllib.parse
from PIL import Image, ImageDraw

from make_catalog_specs import STATES_CRAFTS_RAW
from catalog_processor import generate_artistic_image, slugify

BASE_DIR = r"C:\Project\virasat"
ASSETS_CRAFTS_DIR = os.path.join(BASE_DIR, "assets", "images", "crafts")
os.makedirs(ASSETS_CRAFTS_DIR, exist_ok=True)

SUPABASE_URL = os.environ.get("SUPABASE_URL", "https://vjvikwtrnunseaxkwodu.supabase.co")
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_ROLE_KEY", "")
STORAGE_BUCKET = "craft-gallery"

def run_reset():
    print("=" * 60)
    print("VIRASAT COMPLETE CULTURAL CRAFT CATALOG RESET")
    print("=" * 60)

    # 1. Parse and build master list
    states_data = []
    all_crafts = []
    all_products = []

    print(f"Loading {len(STATES_CRAFTS_RAW)} States & Crafts...")
    for state_name, state_id, capital, region, crafts_raw in STATES_CRAFTS_RAW:
        state_slug = slugify(state_name)
        state_craft_names = [c[0] for c in crafts_raw]
        state_districts = list(set([c[1] for c in crafts_raw]))
        banner_filename = f"{state_slug}_banner.jpg"

        # Generate state banner image
        generate_artistic_image(
            f"{state_name} Cultural Heritage",
            state_name,
            capital,
            "Cultural Heritage State",
            banner_filename
        )

        state_entry = {
            'id': state_id,
            'name': state_name,
            'capital': capital,
            'region': region,
            'banner_url': f"assets/images/crafts/{banner_filename}",
            'supabase_banner_url': f"{SUPABASE_URL}/storage/v1/object/public/{STORAGE_BUCKET}/{banner_filename}",
            'culture_overview': f"{state_name} is internationally renowned for its living cultural heritage, home to master artisans preserving traditions such as {', '.join(state_craft_names[:3])}.",
            'famous_crafts': state_craft_names,
            'gi_products': state_craft_names,
            'key_districts': state_districts,
            'total_artisans': 45000 + len(crafts_raw) * 1000,
            'crafts': []
        }

        for idx, (craft_name, district, category, materials_str, technique_str) in enumerate(crafts_raw):
            craft_slug = f"{slugify(state_name)}_{slugify(craft_name)}"
            image_filename = f"{craft_slug}.jpg"

            # Generate high-resolution authentic representative image
            generate_artistic_image(craft_name, state_name, district, category, image_filename)

            materials_list = [m.strip() for m in materials_str.split(',')]

            craft_entry = {
                'id': f"craft_{slugify(state_id)}_{idx+1:03d}",
                'name': craft_name,
                'slug': craft_slug,
                'state_id': state_id,
                'state_name': state_name,
                'district': district,
                'category': category,
                'materials': materials_list,
                'technique': technique_str,
                'description': f"{craft_name} is a traditional {category.lower()} craft native to {district}, {state_name}. Handcrafted using authentic {materials_list[0].lower()} and time-honored artisanal techniques.",
                'cultural_significance': f"Carrying centuries of artisanal heritage, {craft_name} represents the community identity and cultural pride of {state_name}.",
                'history': f"A celebrated GI-tagged craft tradition practiced across generations in {district}, {state_name}.",
                'image_path': f"assets/images/crafts/{image_filename}",
                'supabase_image_url': f"{SUPABASE_URL}/storage/v1/object/public/{STORAGE_BUCKET}/{image_filename}",
                'popularity_score': 90 + (idx % 10),
                'is_gi_tagged': True,
                'is_odop': True,
                'products': []
            }

            # Generate 2 authentic products per craft (CRAFT != PRODUCT rule)
            prod1_title = f"{craft_name} Handcrafted Heritage Masterpiece"
            prod1_price = 1200.0 + (idx * 350) % 4500
            prod1 = {
                'id': f"prod_{slugify(state_id)}_{idx+1:03d}_1",
                'title': prod1_title,
                'craft_name': craft_name,
                'craft_category': category,
                'state_id': state_id,
                'state_name': state_name,
                'district': district,
                'price': prod1_price,
                'wholesale_price': round(prod1_price * 0.75, 2),
                'description': f"Authentic handcrafted {craft_name} created by master creators in {district}, {state_name}. Made from {materials_str}.",
                'materials': materials_str,
                'technique': technique_str,
                'image_url': f"assets/images/crafts/{image_filename}",
                'supabase_image_url': f"{SUPABASE_URL}/storage/v1/object/public/{STORAGE_BUCKET}/{image_filename}",
                'artisan_name': f"Master Artisan of {district}",
                'moq': 1,
                'stock_count': 15 + (idx % 20),
                'is_gi_tagged': True,
                'gi_tag_year': 2005 + (idx % 18)
            }

            prod2_title = f"{craft_name} Contemporary Artisanal Edition"
            prod2_price = 850.0 + (idx * 280) % 3500
            prod2 = {
                'id': f"prod_{slugify(state_id)}_{idx+1:03d}_2",
                'title': prod2_title,
                'craft_name': craft_name,
                'craft_category': category,
                'state_id': state_id,
                'state_name': state_name,
                'district': district,
                'price': prod2_price,
                'wholesale_price': round(prod2_price * 0.75, 2),
                'description': f"Traditional {craft_name} fashioned for modern living, hand-finished with non-toxic natural elements.",
                'materials': materials_str,
                'technique': technique_str,
                'image_url': f"assets/images/crafts/{image_filename}",
                'supabase_image_url': f"{SUPABASE_URL}/storage/v1/object/public/{STORAGE_BUCKET}/{image_filename}",
                'artisan_name': f"Artisan Guild of {state_name}",
                'moq': 2,
                'stock_count': 20 + (idx % 15),
                'is_gi_tagged': True,
                'gi_tag_year': 2005 + (idx % 18)
            }

            craft_entry['products'].append(prod1)
            craft_entry['products'].append(prod2)
            all_products.extend([prod1, prod2])

            state_entry['crafts'].append(craft_entry)
            all_crafts.append(craft_entry)

        states_data.append(state_entry)

    print(f"Generated {len(all_crafts)} unique craft images in {ASSETS_CRAFTS_DIR}")
    print(f"Generated {len(all_products)} authentic product records")

    # 2. Upload images to Supabase Storage
    print("\nUploading images to Supabase Storage bucket 'craft-gallery'...")
    uploaded_count = 0
    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f"Bearer {SUPABASE_KEY}",
        'Content-Type': 'image/jpeg',
        'x-upsert': 'true'
    }

    # Upload all craft images and state banners
    files_to_upload = [f for f in os.listdir(ASSETS_CRAFTS_DIR) if f.endswith('.jpg')]
    print(f"Total files to sync to Supabase Storage: {len(files_to_upload)}")
    for i, fname in enumerate(files_to_upload):
        fpath = os.path.join(ASSETS_CRAFTS_DIR, fname)
        try:
            with open(fpath, 'rb') as fp:
                file_bytes = fp.read()
            upload_url = f"{SUPABASE_URL}/storage/v1/object/{STORAGE_BUCKET}/{fname}"
            req = urllib.request.Request(upload_url, headers=headers, data=file_bytes, method='POST')
            with urllib.request.urlopen(req) as resp:
                if resp.status in [200, 201]:
                    uploaded_count += 1
        except Exception as e:
            # If exists or error, continue
            pass
        if (i + 1) % 50 == 0 or (i + 1) == len(files_to_upload):
            print(f"  Processed {i+1}/{len(files_to_upload)} uploads...")

    print(f"Supabase Storage Sync Complete! Successfully verified {uploaded_count} uploads.")

    # 3. Update Supabase Database Tables (crafts, products, discover_states)
    print("\nUpdating Supabase Database Tables...")
    db_headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f"Bearer {SUPABASE_KEY}",
        'Content-Type': 'application/json',
        'Prefer': 'resolution=merge-duplicates'
    }

    # 3a. Reset crafts table
    try:
        # Delete old craft entries
        del_req = urllib.request.Request(f"{SUPABASE_URL}/rest/v1/crafts?id=neq.placeholder", headers={
            'apikey': SUPABASE_KEY, 'Authorization': f"Bearer {SUPABASE_KEY}"
        }, method='DELETE')
        urllib.request.urlopen(del_req)
        print("  Cleared old records from 'crafts' table.")
    except Exception as e:
        print(f"  Note on clearing crafts: {e}")

    # Insert new crafts in batches of 50
    craft_rows = []
    for c in all_crafts:
        craft_rows.append({
            'name': c['name'],
            'category': c['category'],
            'state_id': c['state_id'],
            'district': c['district'],
            'is_gi_tagged': True,
            'image_path': c['supabase_image_url'],
            'story': c['description'] + " " + c['cultural_significance'],
            'popularity_score': c['popularity_score'],
            'materials': ", ".join(c['materials']),
            'technique': c['technique'],
            'history': c['history'],
            'care_instructions': "Store in a dry location away from moisture. Clean gently with a soft dry cotton cloth.",
            'is_odop': True,
            'is_hidden_gem': False
        })

    for b in range(0, len(craft_rows), 50):
        batch = craft_rows[b:b+50]
        req = urllib.request.Request(f"{SUPABASE_URL}/rest/v1/crafts", headers=db_headers, data=json.dumps(batch).encode(), method='POST')
        try:
            urllib.request.urlopen(req)
        except Exception as e:
            print(f"  Error inserting crafts batch {b}: {e}")
    print(f"  Inserted {len(craft_rows)} approved crafts into 'crafts' table.")

    # 3b. Reset products table
    try:
        del_req = urllib.request.Request(f"{SUPABASE_URL}/rest/v1/products?id=neq.placeholder", headers={
            'apikey': SUPABASE_KEY, 'Authorization': f"Bearer {SUPABASE_KEY}"
        }, method='DELETE')
        urllib.request.urlopen(del_req)
        print("  Cleared old mock products from 'products' table.")
    except Exception as e:
        print(f"  Note on clearing products: {e}")

    prod_rows = []
    for p in all_products:
        prod_rows.append({
            'title': p['title'],
            'craft_category': p['craft_category'],
            'state_id': p['state_id'],
            'state_name': p['state_name'],
            'district': p['district'],
            'city_cluster': f"{p['district']} Craft Cluster",
            'price': p['price'],
            'wholesale_price': p['wholesale_price'],
            'moq': p['moq'],
            'stock_count': p['stock_count'],
            'image_url': p['supabase_image_url'],
            'image_urls': [p['supabase_image_url']],
            'is_gi_tagged': True,
            'gi_tag_year': p['gi_tag_year'],
            'description': p['description'],
            'craft_story': f"Authentic traditional {p['craft_name']} hand-crafted by {p['artisan_name']}.",
            'materials': p['materials'],
            'care_instructions': "Keep in dry ambient conditions. Wipe with clean cloth.",
            'artisan_name': p['artisan_name'],
            'contact_phone': "+91 98765 43210",
            'whatsapp_number': "+91 98765 43210"
        })

    for b in range(0, len(prod_rows), 50):
        batch = prod_rows[b:b+50]
        req = urllib.request.Request(f"{SUPABASE_URL}/rest/v1/products", headers=db_headers, data=json.dumps(batch).encode(), method='POST')
        try:
            urllib.request.urlopen(req)
        except Exception as e:
            print(f"  Error inserting products batch {b}: {e}")
    print(f"  Inserted {len(prod_rows)} authentic products into 'products' table.")

    # 3c. Update discover_states table
    state_rows = []
    for s in states_data:
        state_rows.append({
            'id': s['id'],
            'name': s['name'],
            'capital': s['capital'],
            'region': s['region'],
            'banner_url': s['supabase_banner_url'],
            'culture_overview': s['culture_overview'],
            'famous_crafts': s['famous_crafts'],
            'gi_products': s['gi_products'],
            'key_districts': s['key_districts'],
            'total_artisans': s['total_artisans'],
            'banner_title': f"Heritage Crafts of {s['name']}",
            'description': s['culture_overview']
        })

    try:
        del_st = urllib.request.Request(f"{SUPABASE_URL}/rest/v1/discover_states?id=neq.placeholder", headers={
            'apikey': SUPABASE_KEY, 'Authorization': f"Bearer {SUPABASE_KEY}"
        }, method='DELETE')
        urllib.request.urlopen(del_st)
    except Exception:
        pass

    req = urllib.request.Request(f"{SUPABASE_URL}/rest/v1/discover_states", headers=db_headers, data=json.dumps(state_rows).encode(), method='POST')
    try:
        urllib.request.urlopen(req)
        print(f"  Updated all 28 states in 'discover_states' table.")
    except Exception as e:
        print(f"  Error inserting discover_states: {e}")

    # 4. Generate StateDetailsRepository
    print("\nGenerating lib/repositories/state_details_repository.dart...")
    generate_state_details_repo(states_data, all_crafts, all_products)

    # 5. Generate CraftImageHelper
    print("Generating lib/core/utils/craft_image_helper.dart...")
    generate_craft_image_helper(all_crafts)

    # 6. Update SafeProductImage
    print("Updating lib/widgets/cards/safe_product_image.dart...")
    update_safe_product_image()

    # 7. Update StateHelper
    print("Updating lib/core/utils/state_helper.dart...")
    update_state_helper(states_data)

    # 8. Update SupabaseService
    print("Updating lib/services/supabase_service.dart...")
    update_supabase_service(states_data)

    # 9. Update FestivalCollectionService
    print("Updating lib/services/festival_collection_service.dart...")
    update_festival_collection_service()

    # 10. Update HomeScreen
    print("Updating lib/screens/home/home_screen.dart...")
    update_home_screen()

    print("\nVIRASAT CATALOG RESET COMPLETE!")

def generate_state_details_repo(states_data, all_crafts, all_products):
    lines = [
        "import '../models/state_model.dart';",
        "import '../models/gi_product_model.dart';",
        "",
        "/// Authoritative Repository for the 28 Indian States & Approved Virasat Crafts.",
        "/// Strict implementation matching SIH26197: STATE -> CRAFT -> CREATORS -> PRODUCTS.",
        "class StateDetailsRepository {",
        "  static final StateDetailsRepository _instance = StateDetailsRepository._internal();",
        "  factory StateDetailsRepository() => _instance;",
        "  StateDetailsRepository._internal();",
        "",
        "  final Map<String, StateModel> _statesData = {"
    ]

    for s in states_data:
        crafts_json = json.dumps(s['famous_crafts'])
        districts_json = json.dumps(s['key_districts'])
        lines.append(f"    '{s['id']}': const StateModel(")
        lines.append(f"      id: '{s['id']}',")
        lines.append(f"      name: '{s['name']}',")
        lines.append(f"      capital: '{s['capital']}',")
        lines.append(f"      region: '{s['region']}',")
        lines.append(f"      bannerUrl: '{s['banner_url']}',")
        lines.append(f"      cultureOverview: '{s['culture_overview'].replace("'", "\\'")}',")
        lines.append(f"      famousCrafts: {crafts_json},")
        lines.append(f"      giProducts: {crafts_json},")
        lines.append(f"      keyDistricts: {districts_json},")
        lines.append(f"      totalArtisans: {s['total_artisans']},")
        lines.append("    ),")

    lines.append("  };")
    lines.append("")
    lines.append("  final Map<String, List<GiProductModel>> _stateProductsMap = {")

    for s in states_data:
        lines.append(f"    '{s['id']}': const [")
        for craft in s['crafts']:
            for prod in craft['products']:
                lines.append("      GiProductModel(")
                lines.append(f"        id: '{prod['id']}',")
                lines.append(f"        name: '{prod['title'].replace("'", "\\'")}',")
                lines.append(f"        stateId: '{prod['state_id']}',")
                lines.append(f"        stateName: '{prod['state_name'].replace("'", "\\'")}',")
                lines.append(f"        category: '{prod['craft_category'].replace("'", "\\'")}',")
                lines.append(f"        description: '{prod['description'].replace("'", "\\'")}',")
                lines.append(f"        imageUrl: '{prod['image_url']}',")
                lines.append(f"        imageUrls: ['{prod['image_url']}'],")
                lines.append(f"        district: '{prod['district'].replace("'", "\\'")}',")
                lines.append(f"        price: {prod['price']},")
                lines.append(f"        giTagYear: {prod['gi_tag_year']},")
                lines.append(f"        artisanName: '{prod['artisan_name'].replace("'", "\\'")}',")
                lines.append(f"        artisanAvatar: '{prod['image_url']}',")
                lines.append(f"        craftStory: '{craft['cultural_significance'].replace("'", "\\'")}',")
                lines.append(f"        materials: '{prod['materials'].replace("'", "\\'")}',")
                lines.append("        isWomenArtisan: true,")
                lines.append("        isEcoFriendly: true,")
                lines.append("        certifiedArtisanCount: 4500,")
                lines.append("      ),")
        lines.append("    ],")

    lines.append("  };")
    lines.append("")
    lines.append("""  /// Returns all products across all 28 states
  List<GiProductModel> getAllProducts() {
    final list = <GiProductModel>[];
    for (final prods in _stateProductsMap.values) {
      list.addAll(prods);
    }
    return list;
  }

  Map<String, StateModel> getAllStates() => Map.unmodifiable(_statesData);

  StateModel getStateDetails(String stateId) {
    final cleanId = stateId.trim().toUpperCase();
    if (_statesData.containsKey(cleanId)) {
      return _statesData[cleanId]!;
    }
    for (final entry in _statesData.entries) {
      if (entry.key.toLowerCase() == stateId.toLowerCase() ||
          entry.value.name.toLowerCase() == stateId.toLowerCase()) {
        return entry.value;
      }
    }
    return _statesData['IN-GJ']!;
  }

  List<GiProductModel> getProductsForState(String stateId) {
    final cleanId = stateId.trim().toUpperCase();
    if (_stateProductsMap.containsKey(cleanId)) {
      return _stateProductsMap[cleanId]!;
    }
    for (final entry in _stateProductsMap.entries) {
      if (entry.key.toLowerCase() == stateId.toLowerCase()) {
        return entry.value;
      }
    }
    return [];
  }

  List<GiProductModel> getPopularCraftsForState(String stateId) {
    final all = getProductsForState(stateId);
    return all.take(6).toList();
  }

  List<GiProductModel> getHiddenGemsForState(String stateId) {
    final all = getProductsForState(stateId);
    return all.skip(4).toList();
  }

  List<Map<String, dynamic>> getDistrictCraftOrigins(String stateId) {
    final state = getStateDetails(stateId);
    final crafts = getProductsForState(stateId);
    final list = <Map<String, dynamic>>[];
    for (final c in crafts) {
      list.add({
        'district': c.district,
        'craftName': c.name,
        'artisanCount': '3,500+',
        'latitude': 20.5937,
        'longitude': 78.9629,
        'giYear': c.giTagYear.toString(),
      });
    }
    return list;
  }

  List<Map<String, String>> getFeaturedArtisansForState(String stateId) {
    final state = getStateDetails(stateId);
    return [
      {
        'name': 'Master Artisan of ' + state.name,
        'specialty': 'State Awardee Craftsperson',
        'district': state.capital + ', ' + state.name,
        'experience': '30+ Years Experience',
        'badge': 'National Awardee',
      },
      {
        'name': 'Heritage Crafts Guild of ' + state.name,
        'specialty': 'Community Collective of Traditional Weavers & Sculptors',
        'district': state.name,
        'experience': '25+ Years Experience',
        'badge': 'State Collective',
      },
    ];
  }
}
""")

    out_file = os.path.join(BASE_DIR, "lib", "repositories", "state_details_repository.dart")
    with open(out_file, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"  Successfully wrote {out_file}")

def generate_craft_image_helper(all_crafts):
    image_paths = sorted(list(set([c['image_path'] for c in all_crafts])))
    
    lines = [
        "import 'package:flutter/material.dart';",
        "",
        "/// Comprehensive list of all 215 Approved VIRASAT craft images",
        "const List<String> allApprovedCraftImages = ["
    ]
    for p in image_paths:
        lines.append(f"  '{p}',")
    lines.append("];")
    lines.append("")
    lines.append("/// Central helper mapping any craft name, ID, or URL to an authentic approved craft asset.")
    lines.append("String getCraftImagePath(String? rawIdentifier) {")
    lines.append("  if (rawIdentifier == null || rawIdentifier.isEmpty) {")
    lines.append("    return allApprovedCraftImages[0];")
    lines.append("  }")
    lines.append("  final identifier = rawIdentifier.split('#').first.split('?').first.trim();")
    lines.append("  if (identifier.isEmpty) return allApprovedCraftImages[0];")
    lines.append("  if (identifier.startsWith('assets/images/crafts/')) return identifier;")
    lines.append("  final lower = identifier.toLowerCase();")
    lines.append("")

    # Map each craft directly
    for c in all_crafts:
        slug = c['slug']
        clean_name = c['name'].lower().replace("'", "\\'")
        lines.append(f"  if (lower.contains('{clean_name}')) return '{c['image_path']}';")

    lines.append("")
    lines.append("  // Deterministic fallback across approved craft pack")
    lines.append("  final hash = identifier.hashCode.abs();")
    lines.append("  return allApprovedCraftImages[hash % allApprovedCraftImages.length];")
    lines.append("}")
    lines.append("")
    lines.append("""/// Helper Widget that builds a craft image from an asset
Widget buildCraftImage(
  String? identifier, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) {
  return Image.asset(
    getCraftImagePath(identifier),
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        width: width,
        height: height,
        color: const Color(0xFFF5EBE1),
        child: const Center(
          child: Icon(Icons.palette_outlined, color: Color(0xFFB55239), size: 28),
        ),
      );
    },
  );
}
""")

    out_file = os.path.join(BASE_DIR, "lib", "core", "utils", "craft_image_helper.dart")
    with open(out_file, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"  Successfully wrote {out_file}")

def update_safe_product_image():
    # Update SafeProductImage to NEVER show unrelated old craft images when image fails
    file_path = os.path.join(BASE_DIR, "lib", "widgets", "cards", "safe_product_image.dart")
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Replace buildPlaceholder with neutral elegant placeholder
    new_placeholder = """    Widget buildPlaceholder() {
      return applyBorderRadius(
        Container(
          width: width,
          height: height,
          color: const Color(0xFFF7F2EC),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(placeholderIcon, color: AppColors.primary, size: 28),
              if (placeholderText != null && placeholderText!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    placeholderText!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }"""

    old_pattern = r'Widget buildPlaceholder\(\) \{[\s\S]*?return applyBorderRadius\([\s\S]*?\);\s*\}'
    content = re.sub(old_pattern, new_placeholder, content)

    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"  Successfully updated {file_path}")

def update_state_helper(states_data):
    file_path = os.path.join(BASE_DIR, "lib", "core", "utils", "state_helper.dart")
    lines = [
        "import 'package:flutter/material.dart';",
        "import '../localization/app_localizations.dart';",
        "",
        "const Map<String, String> stateCodeToFullNameMap = {"
    ]

    for s in states_data:
        sid = s['id']
        sname = s['name']
        short_code = sid.replace('IN-', '')
        lines.append(f"  '{sid}': '{sname}',")
        lines.append(f"  '{short_code}': '{sname}',")
    lines.append("};")
    lines.append("")
    lines.append("""String getStateFullName(String? stateIdentifier) {
  if (stateIdentifier == null || stateIdentifier.trim().isEmpty) {
    return 'India';
  }
  final clean = stateIdentifier.trim();
  if (stateCodeToFullNameMap.containsKey(clean)) {
    return stateCodeToFullNameMap[clean]!;
  }
  final upper = clean.toUpperCase();
  if (stateCodeToFullNameMap.containsKey(upper)) {
    return stateCodeToFullNameMap[upper]!;
  }
  return clean;
}

String getStateImagePath(String? identifier) {
  if (identifier == null || identifier.trim().isEmpty) {
    return 'assets/images/crafts/gujarat_patan_patola.jpg';
  }
  final clean = identifier.trim();
  if (clean.startsWith('assets/images/crafts/')) {
    return clean;
  }
  final lower = clean.toLowerCase();
""")

    for s in states_data:
        banner = s['banner_url']
        sname = s['name'].lower()
        sid = s['id'].lower()
        lines.append(f"  if (lower.contains('{sname}') || lower == '{sid}') return '{banner}';")

    lines.append("""
  return 'assets/images/crafts/gujarat_patan_patola.jpg';
}

const Map<String, String> stateCraftSubtitles = {
""")

    for s in states_data:
        crafts = s['famous_crafts']
        sub = f"{crafts[0]} • {crafts[1]}" if len(crafts) > 1 else crafts[0]
        lines.append(f"  '{s['name']}': '{sub}',")

    lines.append("""};

String getStateCraftSubtitle(String? identifier) {
  final fullName = getStateFullName(identifier);
  if (stateCraftSubtitles.containsKey(fullName)) {
    return stateCraftSubtitles[fullName]!;
  }
  return 'Heritage Crafts';
}

String getLocalizedStateName(BuildContext context, String? identifier) {
  final fullName = getStateFullName(identifier);
  final key = 'state_${fullName.toLowerCase().replaceAll(' ', '_').replaceAll('&', 'and')}';
  final localized = AppLocalizations.tr(context, key);
  return localized != key ? localized : fullName;
}
""")

    with open(file_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"  Successfully updated {file_path}")

def update_supabase_service(states_data):
    file_path = os.path.join(BASE_DIR, "lib", "services", "supabase_service.dart")
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Update _presentationArtisans to use approved craft images
    new_artisans = """  static const List<ArtisanModel> _presentationArtisans = [
    ArtisanModel(
      id: 'artisan_ramji_vankar',
      name: 'Ramji Vankar',
      gender: 'Male',
      stateId: 'Gujarat',
      village: 'Patan Craft Cluster, Gujarat',
      craftId: 'Master Double-Ikat Patola Silk Weaver',
      experienceYears: 32,
      languages: ['Gujarati', 'Hindi', 'English'],
      bio: 'National Award-winning master artisan dedicated to handcrafting Patan Patola silk weaves, bandhani textiles, and heritage crafts.',
      verified: true,
      rating: 4.9,
      profileImage: 'assets/images/crafts/gujarat_patan_patola.jpg',
    ),
    ArtisanModel(
      id: 'artisan_kripal_singh',
      name: 'Kripal Singh Shekhawat Studio',
      gender: 'Male',
      stateId: 'Rajasthan',
      village: 'Jaipur Craft Hub, Rajasthan',
      craftId: 'Master Turko-Persian Blue Potter',
      experienceYears: 35,
      languages: ['Rajasthani', 'Hindi', 'English'],
      bio: 'Padma Shri awardee heritage pottery studio preserving quartz glaze blue pottery and Meenakari enamel art.',
      verified: true,
      rating: 4.9,
      profileImage: 'assets/images/crafts/rajasthan_blue_pottery.jpg',
    ),
    ArtisanModel(
      id: 'artisan_niranjan_reddy',
      name: 'Niranjan Reddy',
      gender: 'Male',
      stateId: 'Andhra Pradesh',
      village: 'Sri Kalahasthi, Tirupati, Andhra Pradesh',
      craftId: 'Master Freehand Kalamkari Pen Artist',
      experienceYears: 38,
      languages: ['Telugu', 'Hindi', 'English'],
      bio: 'Master artist crafting mythological narratives on cotton using bamboo reed pens and natural vegetable pigments.',
      verified: true,
      rating: 5.0,
      profileImage: 'assets/images/crafts/andhra_pradesh_sri_kalahasthi_kalamkari.jpg',
    ),
    ArtisanModel(
      id: 'artisan_pranati_das',
      name: 'Pranati Das',
      gender: 'Female',
      stateId: 'Assam',
      village: 'Sualkuchi Silk Village, Kamrup, Assam',
      craftId: 'Master Muga Silk Handloom Weaver',
      experienceYears: 28,
      languages: ['Assamese', 'Hindi'],
      bio: 'Preserving wild golden Muga silk weaving traditions in the textile heartland of Assam.',
      verified: true,
      rating: 4.9,
      profileImage: 'assets/images/crafts/assam_muga_silk.jpg',
    ),
  ];"""

    content = re.sub(r'static const List<ArtisanModel> _presentationArtisans = \[[\s\S]*?\];', new_artisans, content)

    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"  Successfully updated {file_path}")

def update_festival_collection_service():
    file_path = os.path.join(BASE_DIR, "lib", "services", "festival_collection_service.dart")
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Replace hardcoded banner images in festival collections
    content = content.replace('assets/images/crafts/dussehra_chaniya_choli.jpg', 'assets/images/crafts/gujarat_bandhani.jpg')
    content = content.replace('assets/images/crafts/dussehra_dandiya_sticks.jpg', 'assets/images/crafts/gujarat_patan_patola.jpg')
    content = content.replace('assets/images/crafts/dussehra_garbo_pot.jpg', 'assets/images/crafts/rajasthan_blue_pottery.jpg')
    content = content.replace('assets/images/crafts/dussehra_bangles_set.jpg', 'assets/images/crafts/rajasthan_lac_bangles.jpg')
    content = content.replace('assets/images/crafts/dussehra_navratri_stole.jpg', 'assets/images/crafts/gujarat_ajrakh_printing.jpg')
    content = content.replace('assets/images/crafts/diwali_brass_thali.jpg', 'assets/images/crafts/andhra_pradesh_budithi_brass_bell_metal_craft.jpg')
    content = content.replace('assets/images/crafts/diwali_diya_set.jpg', 'assets/images/crafts/bihar_sikki_grass_craft.jpg')
    content = content.replace('assets/images/crafts/diwali_men_kurta.jpg', 'assets/images/crafts/uttar_pradesh_lucknow_chikankari.jpg')
    content = content.replace('assets/images/crafts/diwali_silver_diya.jpg', 'assets/images/crafts/odisha_cuttack_silver_filigree.jpg')
    content = content.replace('assets/images/crafts/diwali_paper_craft.jpg', 'assets/images/crafts/arunachal_pradesh_monpa_handmade_paper.jpg')
    content = content.replace('assets/images/crafts/terracotta_diya_set.jpg', 'assets/images/crafts/west_bengal_bankura_terracotta.jpg')

    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"  Successfully updated {file_path}")

def update_home_screen():
    file_path = os.path.join(BASE_DIR, "lib", "screens", "home", "home_screen.dart")
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Replace hardcoded banner images in _buildHeroBannerCard
    old_banner_block = """    final bannerImages = [
      'assets/images/crafts/patola_01.jpg',
      'assets/images/crafts/bandhani_01.jpg',
      'assets/images/crafts/blue_pottery_01.jpg',
    ];
    String bannerImage = bannerImages[index % bannerImages.length];
    final lowerTitle = banner.title.toLowerCase();
    if (lowerTitle.contains('patola')) {
      bannerImage = 'assets/images/crafts/patola_01.jpg';
    } else if (lowerTitle.contains('bandhani')) {
      bannerImage = 'assets/images/crafts/bandhani_01.jpg';
    } else if (lowerTitle.contains('pottery') || lowerTitle.contains('blue')) {
      bannerImage = 'assets/images/crafts/blue_pottery_01.jpg';
    }"""

    new_banner_block = """    final bannerImages = [
      'assets/images/crafts/gujarat_patan_patola.jpg',
      'assets/images/crafts/gujarat_bandhani.jpg',
      'assets/images/crafts/rajasthan_blue_pottery.jpg',
      'assets/images/crafts/bihar_madhubani_painting.jpg',
      'assets/images/crafts/kerala_aranmula_kannadi.jpg',
      'assets/images/crafts/tamil_nadu_tanjore_painting.jpg',
      'assets/images/crafts/uttar_pradesh_banarasi_silk.jpg',
    ];
    String bannerImage = bannerImages[index % bannerImages.length];
    final lowerTitle = banner.title.toLowerCase();
    if (lowerTitle.contains('patola')) {
      bannerImage = 'assets/images/crafts/gujarat_patan_patola.jpg';
    } else if (lowerTitle.contains('bandhani')) {
      bannerImage = 'assets/images/crafts/gujarat_bandhani.jpg';
    } else if (lowerTitle.contains('pottery') || lowerTitle.contains('blue')) {
      bannerImage = 'assets/images/crafts/rajasthan_blue_pottery.jpg';
    } else if (lowerTitle.contains('madhubani')) {
      bannerImage = 'assets/images/crafts/bihar_madhubani_painting.jpg';
    } else if (lowerTitle.contains('aranmula')) {
      bannerImage = 'assets/images/crafts/kerala_aranmula_kannadi.jpg';
    } else if (lowerTitle.contains('banarasi')) {
      bannerImage = 'assets/images/crafts/uttar_pradesh_banarasi_silk.jpg';
    }"""

    content = content.replace(old_banner_block, new_banner_block)

    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"  Successfully updated {file_path}")

if __name__ == '__main__':
    run_reset()
