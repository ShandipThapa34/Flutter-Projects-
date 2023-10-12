import 'dart:math';

class Category {
  List<Map<String, String>> wordsAndCategories = [
    //fruits
    {"word": "apple", "category": "fruits"},
    {"word": "banana", "category": "fruits"},
    {"word": "orange", "category": "fruits"},
    {"word": "grape", "category": "fruits"},
    {"word": "kiwi", "category": "fruits"},
    {"word": "mango", "category": "fruits"},
    {"word": "pineapple", "category": "fruits"},
    {"word": "strawberry", "category": "fruits"},
    {"word": "watermelon", "category": "fruits"},
    {"word": "cherry", "category": "fruits"},
    //animals
    {"word": "lion", "category": "animals"},
    {"word": "elephant", "category": "animals"},
    {"word": "tiger", "category": "animals"},
    {"word": "giraffe", "category": "animals"},
    {"word": "zebra", "category": "animals"},
    {"word": "monkey", "category": "animals"},
    {"word": "kangaroo", "category": "animals"},
    {"word": "penguin", "category": "animals"},
    {"word": "dolphin", "category": "animals"},
    {"word": "panda", "category": "animals"},
    //musical instrument
    {"word": "piano", "category": "musical instruments"},
    {"word": "guitar", "category": "musical instruments"},
    {"word": "violin", "category": "musical instruments"},
    {"word": "trumpet", "category": "musical instruments"},
    {"word": "flute", "category": "musical instruments"},
    {"word": "drums", "category": "musical instruments"},
    {"word": "saxophone", "category": "musical instruments"},
    {"word": "harmonica", "category": "musical instruments"},
    {"word": "harp", "category": "musical instruments"},
    //geography
    {"word": "mountain", "category": "geography"},
    {"word": "river", "category": "geography"},
    {"word": "desert", "category": "geography"},
    {"word": "island", "category": "geography"},
    {"word": "canyon", "category": "geography"},
    {"word": "plateau", "category": "geography"},
    {"word": "volcano", "category": "geography"},
    {"word": "glacier", "category": "geography"},
    {"word": "valley", "category": "geography"},
    //professions
    {"word": "doctor", "category": "professions"},
    {"word": "engineer", "category": "professions"},
    {"word": "teacher", "category": "professions"},
    {"word": "lawyer", "category": "professions"},
    {"word": "nurse", "category": "professions"},
    {"word": "plumber", "category": "professions"},
    {"word": "scientist", "category": "professions"},
    {"word": "artist", "category": "professions"},
    {"word": "chef", "category": "professions"},
    {"word": "pilot", "category": "professions"},
    //weather
    {"word": "rain", "category": "weather"},
    {"word": "sun", "category": "weather"},
    {"word": "snow", "category": "weather"},
    {"word": "wind", "category": "weather"},
    {"word": "storm", "category": "weather"},
    //colors
    {"word": "black", "category": "colors"},
    {"word": "white", "category": "colors"},
    {"word": "brown", "category": "colors"},
    {"word": "purple", "category": "colors"},
    {"word": "Yellow", "category": "colors"},
    {"word": "magenta", "category": "colors"},
    {"word": "crimson", "category": "colors"},
    {"word": "Indigo", "category": "colors"},
    {"word": "beige", "category": "colors"},
    {"word": "charcoal", "category": "colors"},
  ];

  Map<String, String> getRandomWordAndCategory() {
    Random random = Random();
    int randomIndex = random.nextInt(wordsAndCategories.length);
    return wordsAndCategories[randomIndex];
  }
}
