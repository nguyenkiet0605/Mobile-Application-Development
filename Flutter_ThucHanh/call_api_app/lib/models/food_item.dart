class FoodItem {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String imageUrl;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.imageUrl,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? 'Unknown',
      area: json['strArea'] ?? 'Unknown',
      instructions: json['strInstructions'] ?? 'Recipe details not available',
      imageUrl: json['strMealThumb'] ?? '',
    );
  }
}
