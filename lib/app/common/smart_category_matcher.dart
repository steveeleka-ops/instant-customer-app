class SmartCategoryMatcher {
  /// Maps category names (as they appear in the API) to keyword lists.
  /// Keywords are all lowercase.
  static const Map<String, List<String>> _categoryKeywords = {
    'Snow removal': [
      'snow', 'plow', 'plowing', 'ice', 'shovel', 'shoveling',
      'driveway', 'winter', 'blizzard', 'sleet', 'frost', 'frozen',
    ],
    'Lawnscape services': [
      'lawn', 'grass', 'mow', 'mowing', 'yard', 'garden', 'gardening',
      'trim', 'trimming', 'hedge', 'bush', 'shrub', 'landscape',
      'landscaping', 'leaf', 'leaves', 'mulch', 'weed',
    ],
    'Heating Repair': [
      'heat', 'heater', 'heating', 'furnace', 'boiler', 'hvac',
      'warm', 'thermostat', 'ac', 'air condition', 'air conditioning',
      'cool', 'cooling', 'duct', 'radiator', 'hot water',
    ],
    'Junk Removal': [
      'junk', 'trash', 'garbage', 'haul', 'hauling', 'debris',
      'clutter', 'remove', 'removal', 'disposal', 'dump', 'waste',
      'old stuff', 'clean out', 'cleanout', 'get rid',
    ],
    'Assembly Furniture': [
      'furniture', 'assemble', 'assembly', 'ikea', 'shelf', 'shelves',
      'desk', 'chair', 'bed', 'table', 'bookcase', 'wardrobe',
      'dresser', 'cabinet', 'put together', 'build',
    ],
    'Plumber': [
      'plumb', 'plumber', 'pipe', 'leak', 'leaking', 'water',
      'drain', 'clog', 'clogged', 'faucet', 'toilet', 'sink',
      'shower', 'flood', 'flooding', 'sewage', 'sewer', 'valve',
    ],
    'Bathroom remodeling': [
      'bathroom', 'bath', 'shower', 'tile', 'tiling',
      'renovation', 'remodel', 'remodeling', 'renovate',
      'vanity', 'bathtub', 'toilet install',
    ],
    'Handyman': [
      'fix', 'repair', 'handyman', 'general', 'odd job',
      'door', 'window', 'paint', 'painting', 'drywall',
      'install', 'installation', 'hang', 'mount', 'patch',
      'caulk', 'grout', 'gutter', 'deck', 'fence',
    ],
    'Tutoring Services': [
      'tutor', 'tutoring', 'teach', 'teacher', 'learn', 'learning',
      'education', 'school', 'homework', 'math', 'reading', 'lesson',
      'study', 'student', 'grade', 'subject', 'writing',
    ],
    'Caregiver': [
      'care', 'caregiver', 'elderly', 'senior', 'babysit', 'babysitter',
      'child', 'nanny', 'assist', 'assistance', 'disabled', 'companion',
      'nurse', 'nursing', 'personal care',
    ],
    'Barber': [
      'haircut', 'hair', 'barber', 'trim', 'shave', 'shaving',
      'beard', 'groom', 'grooming', 'cut', 'style', 'styling',
    ],
    'Glass Replacement': [
      'glass', 'window', 'broken', 'crack', 'cracked', 'replace',
      'shatter', 'shattered', 'mirror', 'windshield', 'pane',
    ],
  };

  /// Returns up to [maxResults] category names that best match [query].
  /// Returns empty list if no meaningful match found.
  static List<String> match(String query, {int maxResults = 3}) {
    if (query.trim().isEmpty) return [];

    final lower = query.toLowerCase();
    final scores = <String, int>{};

    _categoryKeywords.forEach((category, keywords) {
      int score = 0;
      for (final keyword in keywords) {
        if (lower.contains(keyword)) {
          // Longer keyword matches are worth more
          score += keyword.length;
        }
      }
      if (score > 0) scores[category] = score;
    });

    if (scores.isEmpty) return [];

    // Sort by score descending
    final sorted = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(maxResults).map((e) => e.key).toList();
  }
}
