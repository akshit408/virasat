import '../models/gi_product_model.dart';
import '../models/state_model.dart';

class CraftService {
  final List<StateModel> _states = [
    const StateModel(
      id: 'st_rj',
      name: 'Rajasthan',
      capital: 'Jaipur',
      bannerUrl: 'assets/images/crafts/blue_pottery_01.jpg',
      cultureOverview: 'Land of Kings known for vibrant textiles, royal blue pottery, block printing, and intricate wooden carvings.',
      famousCrafts: ['Blue Pottery', 'Block Printing', 'Puppet Making', 'Meenakari Jewellery', 'Kota Doria'],
      giProducts: ['Jaipur Blue Pottery', 'Bagru Hand Block Print', 'Sanganeri Print', 'Kota Doria'],
      keyDistricts: ['Jaipur', 'Jodhpur', 'Udaipur', 'Barmer'],
      totalArtisans: 45000,
    ),
    const StateModel(
      id: 'st_jk',
      name: 'Jammu & Kashmir',
      capital: 'Srinagar',
      bannerUrl: 'assets/images/crafts/pashmina_01.jpg',
      cultureOverview: 'Renowned globally for fine hand-knotted silk carpets, pure pashmina weaving, and paper-mache craft.',
      famousCrafts: ['Pashmina Weaving', 'Paper Mache', 'Kani Shawl', 'Walnut Wood Carving'],
      giProducts: ['Kashmir Pashmina', 'Kani Shawl', 'Kashmir Paper Mache', 'Kashmir Walnut Wood Carving'],
      keyDistricts: ['Srinagar', 'Budgam', 'Anantnag', 'Baramulla'],
      totalArtisans: 28000,
    ),
    const StateModel(
      id: 'st_mp',
      name: 'Madhya Pradesh',
      capital: 'Bhopal',
      bannerUrl: 'assets/images/crafts/gond_painting_01.jpg',
      cultureOverview: 'Cradle of ancient Indian folk art including Gond paintings and Chanderi sarees.',
      famousCrafts: ['Gond Painting', 'Chanderi Silk', 'Bagh Print'],
      giProducts: ['Gond Painting', 'Chanderi Saree'],
      keyDistricts: ['Dindori', 'Chanderi', 'Dhar'],
      totalArtisans: 32000,
    ),
    const StateModel(
      id: 'st_tn',
      name: 'Tamil Nadu',
      capital: 'Chennai',
      bannerUrl: 'assets/images/crafts/kanchipuram_silk_01.jpg',
      cultureOverview: 'Home of Dravidian architecture, Kanjeevaram silk weaving, Tanjore gold foil paintings, and bronze icon casting.',
      famousCrafts: ['Kanjeevaram Silk', 'Tanjore Painting', 'Swamimalai Bronze Icons', 'Pattamadai Mats'],
      giProducts: ['Kanchipuram Silk', 'Tanjavur Paintings', 'Swamimalai Bronze Icons'],
      keyDistricts: ['Kanchipuram', 'Thanjavur', 'Madurai', 'Coimbatore'],
      totalArtisans: 50000,
    ),
    const StateModel(
      id: 'st_as',
      name: 'Assam',
      capital: 'Dispur',
      bannerUrl: 'assets/images/crafts/bamboo_basket_01.jpg',
      cultureOverview: 'Land of Muga Golden Silk, intricate bamboo weaving, bell metal craft, and traditional Assamese ornaments.',
      famousCrafts: ['Muga Silk Weaving', 'Bamboo & Cane Craft', 'Bell Metal Craft', 'Traditional Terracotta'],
      giProducts: ['Muga Silk of Assam', 'Assam Karbi Wooden Craft'],
      keyDistricts: ['Sualkuchi', 'Kamrup', 'Barpeta', 'Dhubri'],
      totalArtisans: 22000,
    ),
  ];

  final List<GiProductModel> _crafts = [
    const GiProductModel(
      id: 'cr_bp',
      name: 'Jaipur Blue Pottery',
      stateId: 'IN-RJ',
      stateName: 'Rajasthan',
      district: 'Jaipur',
      category: 'Pottery & Ceramics',
      description: 'Unique glaze pottery without clay, made from quartz stone powder.',
      imageUrl: 'assets/images/crafts/blue_pottery_01.jpg',
      imageUrls: ['assets/images/crafts/blue_pottery_01.jpg'],
      giTagYear: 2008,
      certifiedArtisanCount: 3500,
      price: 2500,
    ),
    const GiProductModel(
      id: 'cr_mb',
      name: 'Gond Folk Painting',
      stateId: 'IN-MP',
      stateName: 'Madhya Pradesh',
      district: 'Dindori',
      category: 'Paintings',
      description: 'Ancient wall and canvas art drawn using twigs, dots, and natural dyes.',
      imageUrl: 'assets/images/crafts/gond_painting_01.jpg',
      imageUrls: ['assets/images/crafts/gond_painting_01.jpg'],
      giTagYear: 2012,
      certifiedArtisanCount: 8200,
      price: 1800,
    ),
  ];

  Future<List<StateModel>> getAllStates() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _states;
  }

  Future<StateModel> getStateById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _states.firstWhere((s) => s.id == id, orElse: () => _states.first);
  }

  Future<List<GiProductModel>> getAllCrafts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _crafts;
  }

  Future<GiProductModel> getCraftById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _crafts.firstWhere((c) => c.id == id, orElse: () => _crafts.first);
  }
}
