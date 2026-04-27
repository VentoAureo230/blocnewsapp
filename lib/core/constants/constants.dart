import 'package:flutter_dotenv/flutter_dotenv.dart';

const String countryQuery = "us";
const String categoryQuery = "general";

final String weatherApiKey = dotenv.env['WEATHER_API_KEY']!;

final String apiUrlAndroid = dotenv.env['API_URL_ANDROID']!;
final String apiUrlIos = dotenv.env['API_URL_IOS']!;
