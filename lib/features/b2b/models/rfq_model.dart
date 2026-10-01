class B2bRFQ {
  final String id;
  final String buyerName;
  final String buyerType;
  final String title;
  final String craftType;
  final int units;
  final double budget;
  final String deadline;
  final String status; // 'Open', 'Under Review', 'Awarded'
  final String location;
  final String notes;
  final bool isVerified;
  final String image;

  const B2bRFQ({
    required this.id,
    required this.buyerName,
    required this.buyerType,
    required this.title,
    required this.craftType,
    required this.units,
    required this.budget,
    required this.deadline,
    required this.status,
    required this.location,
    required this.notes,
    this.isVerified = true,
    this.image = 'assets/images/crafts/blue_pottery_01.jpg',
  });
}

const List<B2bRFQ> seededRFQs = [
  B2bRFQ(
    id: 'rfq-taj-01',
    buyerName: 'Taj Hotels & Resorts',
    buyerType: 'Hotels & Resorts',
    title: '500 Blue Pottery Dinner Sets for Udaipur Luxury Property',
    craftType: 'Blue Pottery',
    units: 500,
    budget: 1850000,
    deadline: '15 Apr 2026',
    status: 'Open',
    location: 'Udaipur, Rajasthan',
    notes: 'Food-safe lead-free glaze required. Custom cobalt floral rim matching Taj heritage palette.',
    image: 'assets/images/crafts/blue_pottery_01.jpg',
  ),
  B2bRFQ(
    id: 'rfq-fab-02',
    buyerName: 'FabIndia Overseas Pvt Ltd',
    buyerType: 'Retail Stores',
    title: '1,200 Handwoven Chanderi Silk Dupattas',
    craftType: 'Chanderi Weaving',
    units: 1200,
    budget: 1440000,
    deadline: '22 Apr 2026',
    status: 'Under Review',
    location: 'New Delhi HQ',
    notes: 'GI Pehchan registered looms mandatory. Zari border with azo-free dyes.',
    image: 'assets/images/crafts/pashmina_01.jpg',
  ),
  B2bRFQ(
    id: 'rfq-raj-03',
    buyerName: 'Rajasthan Tourism Dept',
    buyerType: 'Government Buyers',
    title: '2,000 Miniature Painting Souvenirs with Silk Pouches',
    craftType: 'Miniature Painting',
    units: 2000,
    budget: 900000,
    deadline: '02 Apr 2026',
    status: 'Awarded',
    location: 'Jaipur, Rajasthan',
    notes: 'Official souvenir for Pushkar Camel Fair & Heritage Conclave.',
    image: 'assets/images/crafts/madhubani_01.jpg',
  ),
  B2bRFQ(
    id: 'rfq-amz-04',
    buyerName: 'Amazon Karigar India',
    buyerType: 'Corporate Gift Buyers',
    title: '800 Terracotta Home Decor Planters & Diyas',
    craftType: 'Terracotta Craft',
    units: 800,
    budget: 560000,
    deadline: '30 Apr 2026',
    status: 'Open',
    location: 'Bengaluru, Karnataka',
    notes: 'Export-grade drop-tested packaging required. Drop-ship eligible.',
    image: 'assets/images/crafts/bamboo_basket_01.jpg',
  ),
  B2bRFQ(
    id: 'rfq-min-05',
    buyerName: 'Ministry of Culture, Govt of India',
    buyerType: 'Government Buyers',
    title: '350 Dokra Brass Figurines for Bharat Pavilion',
    craftType: 'Dokra Bell Metal',
    units: 350,
    budget: 1225000,
    deadline: '10 May 2026',
    status: 'Open',
    location: 'New Delhi',
    notes: 'Certified lost-wax casting technique with Ministry provenance certificate.',
    image: 'assets/images/crafts/bandhani_01.jpg',
  ),
  B2bRFQ(
    id: 'rfq-int-06',
    buyerName: 'Studio Lotus Architecture',
    buyerType: 'Interior Designers',
    title: '150 Warli & Gond Handpainted Acoustic Wall Panels',
    craftType: 'Warli Art',
    units: 150,
    budget: 750000,
    deadline: '18 May 2026',
    status: 'Open',
    location: 'Mumbai, Maharashtra',
    notes: 'Architectural grade timber framing with eco-varnish finish.',
    image: 'assets/images/crafts/ajrakh_01.jpg',
  ),
];
