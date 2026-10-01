/**
 * AI Product Scanner - Image Analyzer Placeholder Service
 * Returns mock visual detection results compatible with Flutter.
 */
const analyzeProductImage = async (imagePath) => {
  return {
    success: true,
    craftName: 'Handloom Bandhani Silk Saree',
    craftType: 'Bandhani Textiles',
    state: 'Gujarat',
    district: 'Kutch',
    giTag: true,
    authenticityScore: 98,
    aiConfidence: 0.96,
    detectedMaterials: ['Pure Silk', 'Natural Indigo Dye', 'Cotton Threads'],
    detectedColors: ['Deep Crimson Red', 'Royal Blue', 'Golden Zari'],
    dimensions: '5.5 meters x 1.2 meters',
    weavingDensity: 'High Count Double Tie-Dye',
    recommendedPrice: 4850,
  };
};

module.exports = { analyzeProductImage };
