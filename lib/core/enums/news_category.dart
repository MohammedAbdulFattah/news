enum NewsCategory {
  all,
  business,
  entertainment,
  general,
  health,
  science,
  sports,
  technology;

  static String format(NewsCategory category) {
    return category.name[0].toUpperCase() + category.name.substring(1);
  }
}
