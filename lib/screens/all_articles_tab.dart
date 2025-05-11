import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../widgets/article_card.dart';
import 'detail_screen.dart';

class AllArticlesTab extends StatefulWidget {
  const AllArticlesTab({super.key});

  @override
  State<AllArticlesTab> createState() => _AllArticlesTabState();
}

class _AllArticlesTabState extends State<AllArticlesTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ArticleProvider>(context, listen: false).fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArticleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Articles"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              onChanged: provider.searchArticles,
              decoration: const InputDecoration(
                hintText: "Search by title or body",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.error.isNotEmpty
                ? Center(child: Text(provider.error))
                : RefreshIndicator(
              onRefresh: provider.fetchArticles,
              child: ListView.builder(
                itemCount: provider.articles.length,
                itemBuilder: (context, index) {
                  final article = provider.articles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetailScreen(article: article),
                        ),
                      );
                    },
                    child: ArticleCard(article: article),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
