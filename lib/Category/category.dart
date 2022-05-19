
class Category {
  final String name;
  final String icon;

  Category(this.name, this.icon);
}

List<Category> categories =
    categoriesData.map((item) => Category(item['name'], item['icon'])).toList();

List<Map<String, dynamic>> categoriesData = [
  {
    "name": "Food",
    'icon': "assets/icons/food.png",
  },
  {
    "name": "Electronics",
    'icon': "assets/icons/Electronic.png",
  },
  {
    "name": "Health",
    'icon': "assets/icons/health.png",
  },
  {
    "name": "Clothes",
    'icon': "assets/icons/clothes.png", //dry_cleaning
  },
  {
    "name": "Books",
    'icon': "assets/icons/books.png", //chrome_reader_mode_outlined
  },
  {
    "name": "Hobby",
    'icon': "assets/icons/hobby.png",
  },
  {
    "name": "Entertainment",
    'icon': "assets/icons/entertainments.png", //extension festival_outlined
  },
  {
    "name": "Transport",
    'icon': "assets/icons/transport.png",
  },
  {
    "name": "Beauty",
    'icon': "assets/icons/beauty.png", //content cut
  },
  {
    "name": "Utilities",
    'icon':
        "assets/icons/utilities.png", //cottage electrical_services emoji_objects
  },
  {
    "name": "Interior",
    'icon': "assets/icons/interior.png", //deck event_seat
  },
  {
    "name": "Other",
    'icon': "assets/icons/other.png",
  },
];
