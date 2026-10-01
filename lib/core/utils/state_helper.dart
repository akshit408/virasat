import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

const Map<String, String> stateCodeToFullNameMap = {
  'IN-AP': 'Andhra Pradesh',
  'IN-AR': 'Arunachal Pradesh',
  'IN-AS': 'Assam',
  'IN-BR': 'Bihar',
  'IN-CT': 'Chhattisgarh',
  'IN-GA': 'Goa',
  'IN-GJ': 'Gujarat',
  'IN-HR': 'Haryana',
  'IN-HP': 'Himachal Pradesh',
  'IN-JH': 'Jharkhand',
  'IN-KA': 'Karnataka',
  'IN-KL': 'Kerala',
  'IN-MP': 'Madhya Pradesh',
  'IN-MH': 'Maharashtra',
  'IN-MN': 'Manipur',
  'IN-ML': 'Meghalaya',
  'IN-MZ': 'Mizoram',
  'IN-NL': 'Nagaland',
  'IN-OR': 'Odisha',
  'IN-PB': 'Punjab',
  'IN-RJ': 'Rajasthan',
  'IN-SK': 'Sikkim',
  'IN-TN': 'Tamil Nadu',
  'IN-TG': 'Telangana',
  'IN-TR': 'Tripura',
  'IN-UP': 'Uttar Pradesh',
  'IN-UT': 'Uttarakhand',
  'IN-WB': 'West Bengal',
  'IN-JK': 'Jammu & Kashmir',
  'IN-LD': 'Ladakh',
  'AP': 'Andhra Pradesh',
  'AR': 'Arunachal Pradesh',
  'AS': 'Assam',
  'BR': 'Bihar',
  'CT': 'Chhattisgarh',
  'GA': 'Goa',
  'GJ': 'Gujarat',
  'HR': 'Haryana',
  'HP': 'Himachal Pradesh',
  'JH': 'Jharkhand',
  'KA': 'Karnataka',
  'KL': 'Kerala',
  'MP': 'Madhya Pradesh',
  'MH': 'Maharashtra',
  'MN': 'Manipur',
  'ML': 'Meghalaya',
  'MZ': 'Mizoram',
  'NL': 'Nagaland',
  'OR': 'Odisha',
  'PB': 'Punjab',
  'RJ': 'Rajasthan',
  'SK': 'Sikkim',
  'TN': 'Tamil Nadu',
  'TG': 'Telangana',
  'TR': 'Tripura',
  'UP': 'Uttar Pradesh',
  'UT': 'Uttarakhand',
  'WB': 'West Bengal',
  'JK': 'Jammu & Kashmir',
  'LD': 'Ladakh',
  'st_rj': 'Rajasthan',
  'st_jk': 'Jammu & Kashmir',
  'st_mp': 'Madhya Pradesh',
  'st_tn': 'Tamil Nadu',
  'st_as': 'Assam',
};

String getStateFullName(String? stateIdentifier) {
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
    return 'assets/images/crafts/patola_01.jpg';
  }
  final clean = identifier.trim();
  if ((clean.startsWith('assets/images/crafts/') || clean.startsWith('assets/images/states/')) &&
      !clean.endsWith('_banner.jpg')) {
    return clean;
  }
  final lower = clean.toLowerCase().replaceAll('_', ' ');

  if (lower.contains('andhra pradesh') || lower == 'in-ap' || lower == 'ap') return 'assets/images/crafts/ap_kondapalli_bommalu.jpg';
  if (lower.contains('arunachal pradesh') || lower == 'in-ar' || lower == 'ar') return 'assets/images/crafts/arunachal_monpa_paper.jpg';
  if (lower.contains('assam') || lower == 'in-as' || lower == 'as') return 'assets/images/crafts/assam_muga_silk.jpg';
  if (lower.contains('bihar') || lower == 'in-br' || lower == 'br') return 'assets/images/crafts/bihar_madhubani.jpg';
  if (lower.contains('chhattisgarh') || lower == 'in-ct' || lower == 'ct') return 'assets/images/crafts/chhattisgarh_bastar_dhokra.jpg';
  if (lower.contains('goa') || lower == 'in-ga' || lower == 'ga') return 'assets/images/crafts/goa_kunbi_weaving.jpg';
  if (lower.contains('gujarat') || lower == 'in-gj' || lower == 'gj') return 'assets/images/crafts/gujarat_patan_patola.jpg';
  if (lower.contains('haryana') || lower == 'in-hr' || lower == 'hr') return 'assets/images/crafts/haryana_phulkari.jpg';
  if (lower.contains('himachal pradesh') || lower == 'in-hp' || lower == 'hp') return 'assets/images/crafts/hp_kullu_shawl.jpg';
  if (lower.contains('jharkhand') || lower == 'in-jh' || lower == 'jh') return 'assets/images/crafts/jharkhand_sohrai.jpg';
  if (lower.contains('karnataka') || lower == 'in-ka' || lower == 'ka') return 'assets/images/crafts/karnataka_channapatna.jpg';
  if (lower.contains('kerala') || lower == 'in-kl' || lower == 'kl') return 'assets/images/crafts/kerala_aranmula_kannadi.jpg';
  if (lower.contains('madhya pradesh') || lower == 'in-mp' || lower == 'mp') return 'assets/images/crafts/mp_gond_painting.jpg';
  if (lower.contains('maharashtra') || lower == 'in-mh' || lower == 'mh') return 'assets/images/crafts/banarasi_silk_02.jpg';
  if (lower.contains('manipur') || lower == 'in-mn' || lower == 'mn') return 'assets/images/crafts/dussehra_garbo_pot.jpg';
  if (lower.contains('meghalaya') || lower == 'in-ml' || lower == 'ml') return 'assets/images/crafts/assam_silk_03.jpg';
  if (lower.contains('mizoram') || lower == 'in-mz' || lower == 'mz') return 'assets/images/crafts/bandhani_02.jpg';
  if (lower.contains('nagaland') || lower == 'in-nl' || lower == 'nl') return 'assets/images/crafts/pashmina_04.jpg';
  if (lower.contains('odisha') || lower == 'in-or' || lower == 'or') return 'assets/images/crafts/pattachitra_01.jpg';
  if (lower.contains('punjab') || lower == 'in-pb' || lower == 'pb') return 'assets/images/crafts/bagru_print_02.jpg';
  if (lower.contains('rajasthan') || lower == 'in-rj' || lower == 'rj') return 'assets/images/crafts/blue_pottery_01.jpg';
  if (lower.contains('sikkim') || lower == 'in-sk' || lower == 'sk') return 'assets/images/crafts/tanjore_painting_02.jpg';
  if (lower.contains('tamil nadu') || lower == 'in-tn' || lower == 'tn') return 'assets/images/crafts/kanchipuram_silk_01.jpg';
  if (lower.contains('telangana') || lower == 'in-tg' || lower == 'tg') return 'assets/images/crafts/patola_03.jpg';
  if (lower.contains('tripura') || lower == 'in-tr' || lower == 'tr') return 'assets/images/crafts/bamboo_basket_03.jpg';
  if (lower.contains('uttar pradesh') || lower == 'in-up' || lower == 'up') return 'assets/images/crafts/banarasi_silk_01.jpg';
  if (lower.contains('uttarakhand') || lower == 'in-ut' || lower == 'ut') return 'assets/images/crafts/gond_painting_05.jpg';
  if (lower.contains('west bengal') || lower == 'in-wb' || lower == 'wb') return 'assets/images/crafts/bankura_terracotta_01.jpg';
  if (lower.contains('jammu') || lower == 'in-jk' || lower == 'jk') return 'assets/images/crafts/pashmina_01.jpg';
  if (lower.contains('ladakh') || lower == 'in-ld' || lower == 'ld') return 'assets/images/crafts/pashmina_05.jpg';

  return 'assets/images/crafts/patola_01.jpg';
}

const Map<String, String> stateCraftSubtitles = {
  'Andhra Pradesh': 'Kondapalli Bommalu • Etikoppaka Toys',
  'Arunachal Pradesh': 'Monpa Handmade Paper • Thangka Painting',
  'Assam': 'Muga Silk • Eri Silk',
  'Bihar': 'Madhubani Painting • Sikki Grass Craft',
  'Chhattisgarh': 'Bastar Dhokra • Bastar Iron Craft',
  'Goa': 'Kunbi Weaving • Coconut Shell Craft',
  'Gujarat': 'Patan Patola • Rogan Art',
  'Haryana': 'Phulkari • Chopad/Chaupar Craft',
  'Himachal Pradesh': 'Kullu Shawls • Chamba Rumal',
  'Jharkhand': 'Sohrai Painting • Khovar Painting',
  'Karnataka': 'Mysore Painting • Channapatna Toys',
  'Kerala': 'Aranmula Kannadi • Kerala Mural Painting',
  'Madhya Pradesh': 'Gond Painting • Bagh Print',
  'Maharashtra': 'Warli Painting • Paithani',
  'Manipur': 'Shaphee Lanphee • Wangkhei Phee',
  'Meghalaya': 'Cane & Bamboo Craft • Ryndia/Eri Silk Weaving',
  'Mizoram': 'Puan Weaving • Pawndum',
  'Nagaland': 'Naga Shawls • Chakhesang Shawls',
  'Odisha': 'Pattachitra • Raghurajpur Pattachitra',
  'Punjab': 'Phulkari • Punjabi Jutti',
  'Rajasthan': 'Blue Pottery • Kota Doria',
  'Sikkim': 'Thangka Painting • Carpet Weaving',
  'Tamil Nadu': 'Tanjore Painting • Kanchipuram Silk',
  'Telangana': 'Pochampally Ikat • Adilabad Dokra',
  'Tripura': 'Bamboo Craft • Cane Craft',
  'Uttar Pradesh': 'Banarasi Silk • Lucknow Chikankari',
  'Uttarakhand': 'Aipan Art • Ringaal Bamboo Craft',
  'West Bengal': 'Kantha Embroidery • Bengal Pattachitra',
  'Jammu & Kashmir': 'Pashmina • Papier-Mâché',
  'Ladakh': 'Changthangi Pashmina • Choktse Carving',
};

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
