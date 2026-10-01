# Approved VIRASAT Cultural Craft Catalog Dataset (28 States, 208 Crafts)
# Structure: STATE -> CRAFT -> CREATORS -> PRODUCTS

APPROVED_CATALOG = {
    'IN-AP': {
        'state_name': 'Andhra Pradesh',
        'capital': 'Amaravati',
        'region': 'South India',
        'culture_overview': 'Andhra Pradesh boasts a rich heritage of traditional crafts spanning centuries, renowned for its vegetable-dyed Kalamkari textiles, softwood Kondapalli toys, and bell metal casting.',
        'crafts': [
            {
                'name': 'Kondapalli Bommalu',
                'district': 'Krishna',
                'category': 'Woodcraft & Toys',
                'description': 'Traditional lightweight softwood toys hand-carved from Tella Poniki wood and painted with natural vegetable extracts, depicting rural village themes and mythological figures.',
                'cultural_significance': 'Centerpiece of South Indian Bommala Koluvu festive displays during Sankranti and Navratri, celebrating rural agrarian life and Vedic lore.',
                'history': 'Originated in the 14th century during the Reddy dynasty; master craftspeople migrated from Rajasthan and settled in Kondapalli village.',
                'materials': ['Tella Poniki Softwood', 'Natural Tamarind Seed Paste', 'Enamel & Vegetable Pigments', 'Lime Mortar'],
                'technique': 'Slow carving of seasoned softwood followed by assembly with natural paste, coated with lime primer, and hand-painted using fine squirrel-hair brushes.',
                'creators': [
                    {'name': 'Chalamacharla Subba Rao', 'title': 'Master Kondapalli Sculptor', 'district': 'Krishna, Andhra Pradesh', 'experience': '36 Years', 'rating': 4.9}
                ],
                'products': [
                    {'title': 'Kondapalli Dancing Doll (Aata Bomma)', 'price': 1250.0, 'desc': 'Oscillating traditional dancing doll weighted at base, hand-carved from Tella Poniki softwood.'},
                    {'title': 'Kondapalli Village Life Miniature Ensemble', 'price': 2400.0, 'desc': 'Handcrafted diorama set depicting traditional potters, farmers, and weaver figurines.'}
                ]
            },
            {
                'name': 'Etikoppaka Toys',
                'district': 'Visakhapatnam',
                'category': 'Woodcraft & Lacquer',
                'description': 'Lacquered wooden toys and decorative boxes made from Ankudi wood, turned on lathes and finished with non-toxic organic vegetable lacquer resins.',
                'cultural_significance': 'Renowned worldwide as completely non-toxic, safe children toys infused with seeds, bark, and roots dyes.',
                'history': 'A 400-year-old tradition practiced along the banks of the Varaha River, revived through GI tag recognition for organic lacquering.',
                'materials': ['Ankudi Wood (Wrightia tinctoria)', 'Natural Lac Resin', 'Indigo & Turmeric Dyes', 'Mogali Leaves for Polishing'],
                'technique': 'Lathe-turning of soft Ankudi wood followed by friction-applied colored lac sticks and high-gloss buffing using dry Mogali palm leaves.',
                'creators': [
                    {'name': 'C. V. Raju', 'title': 'National Awardee Etikoppaka Master', 'district': 'Visakhapatnam, Andhra Pradesh', 'experience': '32 Years', 'rating': 5.0}
                ],
                'products': [
                    {'title': 'Etikoppaka Natural Lacquer Stacking Toy', 'price': 850.0, 'desc': 'Eco-friendly smooth wooden stacking rings finished with natural turmeric and indigo lac.'},
                    {'title': 'Etikoppaka Lacquered Vermilion Box (Kumkum Bharani)', 'price': 550.0, 'desc': 'Graceful hand-turned wooden sacred box featuring traditional floral motifs.'}
                ]
            },
            {
                'name': 'Machilipatnam Kalamkari',
                'district': 'Krishna',
                'category': 'Textiles & Handlooms',
                'description': 'Intricate block-printed cotton fabric created using carved wooden stamps, natural vegetable dyes, and running river water bleaching.',
                'cultural_significance': 'A signature maritime trade craft exported globally since the Golconda Sultanate, epitomizing Persian-Indian aesthetic syncretism.',
                'history': 'Flourished under the patronage of Golconda rulers and European traders in the Coromandel coast from the 16th century onwards.',
                'materials': ['Pure Cotton Fabric', 'Myrobalan (Karakkai) Solution', 'Madder Root Red Dye', 'Fermented Iron Indigo Solution'],
                'technique': 'Fabric treated with buffalo milk and myrobalan, printed with hand-carved teakwood blocks, and washed in flowing water to fix colors.',
                'creators': [
                    {'name': 'Pitchuka Srinivas', 'title': 'Master Kalamkari Block Printer', 'district': 'Krishna, Andhra Pradesh', 'experience': '28 Years', 'rating': 4.9}
                ],
                'products': [
                    {'title': 'Machilipatnam Tree of Life Kalamkari Dupatta', 'price': 1850.0, 'desc': 'Pure cotton hand-block printed dupatta featuring natural madder red and indigo floral creeper motifs.'},
                    {'title': 'Machilipatnam Block-Printed Table Runner', 'price': 1100.0, 'desc': 'Traditional geometric and peacock medallion border table linen in organic earth dyes.'}
                ]
            },
            {
                'name': 'Sri Kalahasthi Kalamkari',
                'district': 'Tirupati',
                'category': 'Textiles & Handlooms',
                'description': 'Freehand pen-drawn sacred religious murals and narratives executed with bamboo reed pens (kalam) on cow milk-treated cotton.',
                'cultural_significance': 'Sacred temple cloth tradition depicting scenes from the Ramayana, Mahabharata, and Shiva Puranas used as temple hangings.',
                'history': 'Patronized by Vijayanagara emperors in the sacred temple town of Sri Kalahasthi to adorn temple chariots and sanctums.',
                'materials': ['Bamboo Reed (Kalam)', 'Raw Handspun Cotton', 'Cow Milk', 'Natural Mineral & Vegetable Colors'],
                'technique': 'Bamboo stylus wrapped with wool releases natural ink slowly as the artisan outlines mythological figures without stencils.',
                'creators': [
                    {'name': 'Niranjan Reddy', 'title': 'Padma Shri Nominee Kalamkari Artist', 'district': 'Tirupati, Andhra Pradesh', 'experience': '40 Years', 'rating': 5.0}
                ],
                'products': [
                    {'title': 'Sri Kalahasthi Sacred Tree Freehand Wall Hanging', 'price': 3800.0, 'desc': 'Intricately pen-drawn cotton tapestry illustrating the Tree of Life with bird and deer motifs.'},
                    {'title': 'Sri Kalahasthi Hand-Painted Temple Saree', 'price': 6500.0, 'desc': 'Exclusive pure handloom saree with pen-crafted mythological narrative pallu.'}
                ]
            },
            {
                'name': 'Bobbili Veena',
                'district': 'Vizianagaram',
                'category': 'Musical Instruments',
                'description': 'Exquisite classical acoustic string instrument carved from a single log of seasoned jackwood, acclaimed for its resonant tonal clarity.',
                'cultural_significance': 'The royal instrument of Carnatic music maestros, representing the zenith of South Indian acoustic craft.',
                'history': 'Practiced for over three centuries under the patronage of the Rajas of Bobbili who established dedicated luthier workshops.',
                'materials': ['Seasoned Jackwood (Panasa)', 'Brass Frets', 'Inlaid Deer Horn & Celluloid Trim', 'Steel Strings'],
                'technique': 'Monoxyl (Ekanda) carving where resonator, neck, and head are sculpted from a single solid block of jackwood for purest sound transmission.',
                'creators': [
                    {'name': 'Sarvasiddhi Achyuta Rao', 'title': 'Master Bobbili Luthier', 'district': 'Vizianagaram, Andhra Pradesh', 'experience': '34 Years', 'rating': 5.0}
                ],
                'products': [
                    {'title': 'Bobbili Concert Saraswati Veena', 'price': 28500.0, 'desc': 'Full-size concert acoustic Saraswati Veena with hand-carved lion head and fine brass frets.'},
                    {'title': 'Bobbili Decorative Miniature Veena', 'price': 2200.0, 'desc': 'Authentic scaled miniature jackwood Veena crafted by traditional Bobbili guild artisans.'}
                ]
            },
            {
                'name': 'Durgi Stone Carving',
                'district': 'Guntur',
                'category': 'Stone Carving',
                'description': 'Intricate temple sculptures and deity icons chiseled from soft white limestone found along the Palnadu region.',
                'cultural_significance': 'Carrying forward the sculptural legacy of Nagarjunakonda and the ancient Amaravati Buddhist stupas.',
                'history': 'Traceable to the Ikshvaku and Satavahana dynasties (2nd century BCE) who immortalized Buddhist and Shaivite iconography in soft limestone.',
                'materials': ['Palnadu Soft Limestone', 'Forged Steel Chisels', 'Fine Sand Polishing Paste'],
                'technique': 'Hand chiseling according to canonical Shilpa Shastras measurements, followed by fine water-sanding to achieve a matte silky sheen.',
                'creators': [
                    {'name': 'G. Somasekhar', 'title': 'Master Shilpi Sculptor', 'district': 'Guntur, Andhra Pradesh', 'experience': '29 Years', 'rating': 4.8}
                ],
                'products': [
                    {'title': 'Durgi Limestone Ganesha Relief Plaque', 'price': 3400.0, 'desc': 'Hand-chiseled Palnadu soft limestone relief sculpture following classical iconography.'},
                    {'title': 'Durgi Carved Traditional Floral Diya Lamp', 'price': 1450.0, 'desc': 'Aesthetic single-stone limestone table oil lamp with carved petal contours.'}
                ]
            },
            {
                'name': 'Budithi Brass & Bell Metal Craft',
                'district': 'Srikakulam',
                'category': 'Metalwork & Utensils',
                'description': 'Handcrafted alloy cooking vessels, ornamental pots, and temple bells featuring contemporary sleek geometries and dark antique patinas.',
                'cultural_significance': 'Utilitarian and ritual brassware known for its distinctive two-tone polish and metallurgical durability.',
                'history': 'Developed by hereditary metal smiths (Kamsalis) in Budithi village, evolving from royal kitchen vessels to acclaimed art decor.',
                'materials': ['Brass (Peethal)', 'Bell Metal Alloy (Kansa)', 'Natural Polishing Black Powder', 'Charcoal'],
                'technique': 'Sheet metal hammering and joint braising, spun on wooden lathes and friction-polished with special local herbal pastes to produce dark rings.',
                'creators': [
                    {'name': 'K. Satyanarayana', 'title': 'Master Metal Smith', 'district': 'Srikakulam, Andhra Pradesh', 'experience': '31 Years', 'rating': 4.9}
                ],
                'products': [
                    {'title': 'Budithi Two-Tone Brass Urli Vessel', 'price': 2600.0, 'desc': 'Hand-hammered brass decorative shallow vessel with signature contrasting dark burnished rims.'},
                    {'title': 'Budithi Traditional Brass Water Goblet Set', 'price': 1750.0, 'desc': 'Pure brass ayurvedic health drinking glasses hand-turned on traditional lath.'}
                ]
            }
        ]
    }
}
