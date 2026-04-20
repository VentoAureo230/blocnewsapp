import 'package:blocnewsapp/features/daily_news/presentation/pages/home/news_feed.dart';
import 'package:blocnewsapp/features/weather/presentation/widget/weather_banner.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              WeatherBanner(),
              SizedBox(height: 12),
              Expanded(child: NewsFeed()),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Home', style: TextStyle(color: Colors.black)),
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/SearchArticles'),
          icon: const Icon(Icons.search, color: Colors.black),
        ),
        IconButton(
          icon: const Icon(Icons.bookmark, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, '/SavedArticles'),
        ),
      ],
    );
  }
}
