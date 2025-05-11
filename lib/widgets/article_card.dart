import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../providers/article_provider.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArticleProvider>(context);
    final isFav = provider.isFavorite(article.id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 3,
      child: ListTile(
        title: Text(article.title),
        subtitle: Text(article.body.length > 100
            ? "${article.body.substring(0, 100)}..."
            : article.body),
        trailing: IconButton(
          icon: Icon(isFav ? Icons.star : Icons.star_border,
              color: isFav ? Colors.amber : null),
          onPressed: () => provider.toggleFavorite(article.id),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/detail', arguments: article);
        },
      ),
    );
  }
}
