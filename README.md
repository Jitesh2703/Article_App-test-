# Flutter Article App

A Flutter app that fetches and displays a list of articles from a public API.

## Features
- List of articles fetched from a public API.
- Search functionality to filter articles by title or body.
- Detailed view of each article.
- Responsive UI that adapts to different screen sizes.

## Setup Instructions
1. Clone the repo:  
   `git clone https://github.com/Jitesh2703/Article_App-test-.git`  
   `cd flutter_article_app`

2. Install dependencies:  
   `flutter pub get`

3. Run the app:  
   `flutter run`

## Tech Stack
- Flutter SDK: 3.x.x (or the version you're using)
- State Management: Provider
- HTTP Client: http
- Persistence: shared_preferences

## State Management Explanation
In this app, we are using **Provider** for state management. The `ArticleProvider` class manages the articles and handles operations like fetching data, searching articles, and managing favorites. The app uses `ChangeNotifier` to notify listeners when data changes.

## Known Issues / Limitations
- Favorites are only stored temporarily in memory, and are not persisted after restarting the app. This will be handled with **shared_preferences** in a future update.
- There are no advanced error handling or retry mechanisms implemented for the API requests.
