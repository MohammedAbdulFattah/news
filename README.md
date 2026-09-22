# News App

A Flutter news app built with a clean 3-tier architecture, Riverpod for state management, and NewsAPI.org for data. Users can browse top headlines by category/country and search through all news with date and sort filters.

## Features

- **Auth** — Email login/sign up, continue with Google, logout (Firebase Auth)
- **Top Headlines** — Filter by category and country, with pagination
- **Search** — Full-text search with `from`/`to`/`sortBy` filters
- **Responsive UI** — Adapts between mobile and large screens (floating vs fixed header, bottom sheet vs menu for actions)
- **Loading states done right** — Shimmer loading, empty state, error state, and data state

## Architecture

The app follows a simple 3-tier structure:

```
UI (Notifiers/Providers) → Repository → API (Dio)
```

- **NewsRepository** — talks to NewsAPI's two endpoints (`/v2/top-headlines` and `/v2/everything`), catches whatever goes wrong, and throws a clean `ApiException`
- **ApiException** — maps Dio exceptions (and anything else) into a single exception type with a readable error message
- **Riverpod Notifiers** — handle state on top of the repository

### Notifiers

- **HeadlinesNewsNotifier** — `build()` fetches the first page of headlines and listens to `CategoryFilterNotifier` and `CountryFilterNotifier` for changes. `loadNextPage()` fetches and merges subsequent pages.
- **SearchNewsNotifier** — same idea, but just `build()` for search results.
- A handful of small helper notifiers (like `CategoryFilterNotifier`) hold filter state around these two.

## UI News

**Header**
- Search bar, logout button, and action chips (category/country filters)
- Floating on mobile, fixed on large screens
- Action chips open as a bottom sheet on mobile, a `MenuAnchor` on larger screens

**Body**
- Handles empty, error, loading (shimmer), and data states
- Grid built with `SliverGridDelegateWithMaxCrossAxisExtent` so the column count adjusts automatically to screen size
- Pagination via `CustomScrollView` with a scroll listener — triggers `loadNextPage()` when the user gets within 300px of the bottom

## Folder Structure

```
lib
├── core/
│   ├── constants/
│   ├── enums/
│   ├── exceptions/
│   ├── extensions/
│   ├── helper/
│   └── theme/
├── data/
│   ├── models/
│   └── repositories/
├── notifiers/
├── providers/
└── ui/
    ├── screens/
    └── widgets/
        ├── authentication_widgets/
        ├── home_widgets/
        └── common_widgets.dart
```

## Tech Stack

- **Flutter** — UI toolkit
- **Dio** — networking
- **Firebase Auth** — authentication (email, Google sign-in)
- **Riverpod** — state management
- **NewsAPI.org** — news data source

## API Reference

Uses [NewsAPI.org](https://newsapi.org):

| Endpoint | Purpose | Query params |
|---|---|---|
| `/v2/top-headlines` | Top news | `category`, `country`, `page` |
| `/v2/everything` | Search | `from`, `to`, `sortBy` |

---

Built as a practice project to explore Riverpod, responsive Flutter UI, and clean API/error handling.
