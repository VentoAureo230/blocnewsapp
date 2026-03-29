import 'package:flutter_dotenv/flutter_dotenv.dart';

final String newsBaseApiUrl = dotenv.env['NEWS_BASE_URL']!; // Doesn't work, the RestApi decorator need a constant : "Arguments of a constant creation must be constant expressions."
final String newsApiKey = dotenv.env['NEWS_API_KEY']!;
const String countryQuery = "us";
const String categoryQuery = "general";