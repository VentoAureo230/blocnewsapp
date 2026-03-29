import 'package:blocnewsapp/features/daily_news/domain/entities/article.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleEntity? article;
  const ArticleWidget({super.key, this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(
        start: 14,
        end: 14,
        top: 10,
        bottom: 10,
      ),
      height: MediaQuery.of(context).size.width / 2.2,
      child: Row(children: [_buildImage(context), _buildTitleAndDescription()]),
    );
  }

  Widget _buildImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: article!.urlToImage ?? '',
      imageBuilder: (context, imageProvider) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.08),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: double.maxFinite,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.08)),
            child: const CupertinoActivityIndicator(),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: double.maxFinite,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.08)),
            child: const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndDescription() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              article!.title ??  '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                fontFamily: 'Butler',
                color: Colors.black,
              ),
            ),
            // Description
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(article!.description ?? '', maxLines: 2),
              ),
            ),

            // Datetime
            Row(
              children: [
                const Icon(Icons.timeline_outlined, size: 16),
                const SizedBox(width: 5),
                Text(article!.publishedAt ?? '', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
