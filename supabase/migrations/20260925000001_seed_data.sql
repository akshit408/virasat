-- =============================================================================
-- VIRASAT v3.0 — SUPABASE MIGRATION 20260925000001_seed_data.sql
-- TEAM 3AM | SIH 2026
-- =============================================================================

INSERT INTO discover_states (id, name, capital, region, banner_url, culture_overview, famous_crafts, gi_products, key_districts, total_artisans)
VALUES
('IN-GJ', 'Gujarat', 'Gandhinagar', 'West India', 'assets/images/states/gujarat.jpg', 
 'Gujarat is a vibrant cradle of Indian craft heritage, renowned worldwide for intricate tie-dye textiles, double-ikat silk weaves, block printing, Rogan oil art, and copper bell crafts.',
 ARRAY['Patan Patola Double Ikat', 'Jamnagar Bandhani', 'Kutch Ajrakh Block Print', 'Nirona Rogan Painting', 'Tangaliya Handloom Weave', 'Sankheda Lacquered Furniture'],
 ARRAY['Bandhani', 'Patan Patola', 'Ajrakh Print', 'Kutch Embroidery', 'Sankheda Furniture', 'Tangaliya Shawl'],
 ARRAY['Jamnagar', 'Patan', 'Kutch', 'Surendranagar', 'Ahmedabad', 'Chhota Udaipur'], 45000),

('IN-RJ', 'Rajasthan', 'Jaipur', 'North-West India', 'assets/images/states/rajasthan.jpg', 
 'Rajasthan embodies royal Indian art and desert folk craft. Famous for Turko-Persian quartz Blue Pottery, gold Meenakari jewellery, wooden Block Prints, and hand-carved leather Mojaris.',
 ARRAY['Blue Pottery', 'Meenakari Jewelry', 'Bagru Block Print', 'Kota Doria'],
 ARRAY['Jaipur Blue Pottery', 'Sanganeri Hand Block Print', 'Kota Doria', 'Kathputlis of Rajasthan'],
 ARRAY['Jaipur', 'Jodhpur', 'Udaipur', 'Barmer', 'Kota'], 62000),

('IN-UP', 'Uttar Pradesh', 'Lucknow', 'North India', 'assets/images/states/uttar_pradesh.jpg', 
 'Uttar Pradesh leads India in registered GI crafts, featuring delicate Lucknow Chikankari shadow embroidery, opulent Banarasi brocade silk sarees, and brass metalware.',
 ARRAY['Chikankari Embroidery', 'Banarasi Brocade Silk', 'Moradabad Brassware', 'Zardozi Embroidery'],
 ARRAY['Banarasi Brocade', 'Lucknow Chikankari', 'Moradabad Metal Craft', 'Nizamabad Black Pottery'],
 ARRAY['Varanasi', 'Lucknow', 'Moradabad', 'Azamgarh', 'Firozabad'], 88000),

('IN-WB', 'West Bengal', 'Kolkata', 'East India', 'assets/images/states/west_bengal.jpg', 
 'West Bengal is celebrated for artistic soulfulness: legendary Bankura terracotta horses, Kantha running-stitch quilts, Jamdani muslin weaves, and Dokra metal castings.',
 ARRAY['Kantha Embroidery', 'Terracotta Craft', 'Dokra Metal Casting', 'Jamdani Weaves'],
 ARRAY['Santipur Saree', 'Kantha Stitch', 'Bankura Panchmura Terracotta'],
 ARRAY['Bankura', 'Birbhum', 'Burdwan', 'Murshidabad', 'Purulia'], 54000),

('IN-MP', 'Madhya Pradesh', 'Bhopal', 'Central India', 'assets/images/states/madhya_pradesh.jpg', 
 'Heartland India art spans sacred Gond tribal paintings depicting forest spirits, delicate gossamer Chanderi weaves, and Bagh block printing.',
 ARRAY['Gond Tribal Painting', 'Chanderi Silk', 'Maheshwari Sarees', 'Bagh Print'],
 ARRAY['Chanderi Fabric', 'Bagh Prints of Madhya Pradesh', 'Gond Painting'],
 ARRAY['Dindori', 'Ashoknagar', 'Dhar', 'Khargone'], 38000),

('IN-JK', 'Jammu & Kashmir', 'Srinagar', 'North India', 'assets/images/states/jammu_kashmir.jpg', 
 'Kashmir is renowned globally for gossamer Changthangi Pashmina shawls, hand-painted Papier-Mâché decor, Sozni needlework, and Walnut wood carving.',
 ARRAY['Pashmina Weaving', 'Papier-Mâché', 'Walnut Wood Carving', 'Kani Shawl'],
 ARRAY['Kashmir Pashmina', 'Kani Shawl', 'Kashmir Papier Mache'],
 ARRAY['Srinagar', 'Budgam', 'Anantnag', 'Baramulla'], 32000),

('IN-OR', 'Odisha', 'Bhubaneswar', 'East India', 'assets/images/states/odisha.jpg', 
 'Odisha is home to Raghurajpur heritage crafts village, sacred Jagannath Pattachitra scroll paintings, and delicate Tarakasi silver filigree from Cuttack.',
 ARRAY['Pattachitra Painting', 'Silver Filigree (Tarakasi)', 'Sambalpuri Ikat'],
 ARRAY['Orissa Pattachitra', 'Cuttack Silver Filigree', 'Sambalpuri Bandha Saree'],
 ARRAY['Puri', 'Cuttack', 'Sambalpur', 'Ganjam'], 41000),

('IN-KA', 'Karnataka', 'Bengaluru', 'South India', 'assets/images/states/karnataka.jpg', 
 'Karnataka features non-toxic lacquerware Channapatna wooden toys, Mysore mulberry silk weaves, and Bidriware silver inlay artifacts.',
 ARRAY['Channapatna Wooden Toys', 'Mysore Silk', 'Bidriware Silver Inlay'],
 ARRAY['Channapatna Toys & Dolls', 'Mysore Silk', 'Bidriware'],
 ARRAY['Ramanagara', 'Mysore', 'Bidar', 'Koppal'], 49000),

('IN-TN', 'Tamil Nadu', 'Chennai', 'South India', 'assets/images/states/tamil_nadu.jpg', 
 'Tamil Nadu boasts gold zari Kanchipuram silk sarees, gold-foil Tanjore sacred paintings, and Swamimalai bronze icon casting.',
 ARRAY['Kanchipuram Silk', 'Tanjore Gold Painting', 'Swamimalai Bronze Icons'],
 ARRAY['Kanchipuram Silk', 'Thanjavur Paintings', 'Swamimalai Bronze Icons'],
 ARRAY['Kanchipuram', 'Thanjavur', 'Madurai', 'Coimbatore'], 58000),

('IN-AS', 'Assam', 'Dispur', 'North-East India', 'assets/images/states/assam.jpg', 
 'Assam craft heritage centers on golden Muga silk found nowhere else on Earth, fine cane & bamboo basketry, and Majuli wooden masks.',
 ARRAY['Muga Silk Weaving', 'Cane & Bamboo Craft', 'Majuli Wooden Mask'],
 ARRAY['Muga Silk of Assam', 'Assam Karbi Wooden Craft'],
 ARRAY['Kamrup', 'Sualkuchi', 'Majuli', 'Nalbari'], 34000)

ON CONFLICT (id) DO UPDATE SET
name = EXCLUDED.name,
culture_overview = EXCLUDED.culture_overview,
famous_crafts = EXCLUDED.famous_crafts,
gi_products = EXCLUDED.gi_products;

-- SEED GOVERNMENT SCHEMES
INSERT INTO government_schemes (scheme_name, ministry, description, eligibility, portal_url, category)
VALUES
('PM VIKAS (Pradhan Mantri Vishwakarma Kaushal Samman)', 'Ministry of Micro, Small and Medium Enterprises', 'Comprehensive financial support, skill training, toolkit incentives, and marketing assistance for traditional artisans and craftspeople across India.', 'Traditional artisans and craftspeople practicing 18 identified family crafts.', 'https://pmvishwakarma.gov.in', 'Skill Development & Credit Support'),
('AHVY (Ambedkar Hastshilp Vikas Yojana)', 'Ministry of Textiles', 'Cluster-based holistic development program for handicrafts artisans providing design assistance, toolkits, and infrastructure.', 'Artisan Self-Help Groups (SHGs) and registered handicraft cooperatives.', 'https://handicrafts.nic.in', 'Cluster Development'),
('ODOP (One District One Product)', 'Ministry of Commerce & Industry', 'State initiative to select, brand, and promote one specific craft/product from each district to transform it into an export hub.', 'Artisans, weavers, and small-scale manufacturers producing identified district crafts.', 'https://odop.india.gov.in', 'Export & Market Promotion'),
('GI Tagging Assistance Scheme', 'Department for Promotion of Industry and Internal Trade (DPIIT)', 'Financial grant and legal registration support for artisan guilds to register Geographical Indications for regional craft protection.', 'Artisan associations and registered craft producer companies.', 'https://ipindia.gov.in', 'Intellectual Property Protection')
ON CONFLICT DO NOTHING;
