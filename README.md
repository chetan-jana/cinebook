# CineBook – Flutter Movie Ticket Booking App

A beginner-friendly Flutter web project for a lab examination. It demonstrates:
- Flutter widgets: Container, Row, Column, Stack, GridView, ListView, Card, buttons and chips
- Responsive layouts using LayoutBuilder and MediaQuery-friendly constraints
- Navigation using Navigator and MaterialPageRoute
- Animations using AnimatedContainer
- State management using StatefulWidget and Provider
- Reusable custom widgets and a consistent Material theme
- Form validation for name and email

## Requirements
- Flutter SDK installed and added to PATH
- Google Chrome
- VS Code with the Flutter and Dart extensions

## Setup

1. Extract the ZIP file.
2. Open the `cinebook` folder in VS Code.
3. Open the VS Code terminal (Terminal → New Terminal).
4. Run:

```bash
flutter create . --platforms web
flutter pub get
flutter run -d chrome
```

If Flutter asks to overwrite files during `flutter create`, keep the existing `lib/main.dart` and `pubspec.yaml`. The command is mainly needed to generate the web platform folder.

## Build for deployment

```bash
flutter build web --release
```

The production website files will be generated inside `build/web`.

## Deploy to GitHub Pages (simple route)

1. Create a GitHub repository named `cinebook`.
2. In the project terminal, run:

```bash
git init
git add .
git commit -m "Initial CineBook Flutter app"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/cinebook.git
git push -u origin main
```

3. For a repository project page, build with the repository base path:

```bash
flutter build web --release --base-href /cinebook/
```

4. Publish the contents of `build/web` using GitHub Pages. A simple option is to use the `gh-pages` branch with the `gh-pages` npm package, or use a GitHub Actions workflow that uploads `build/web` as the Pages artifact.
5. In GitHub, open Settings → Pages and confirm the deployment URL.

For Vercel, import the GitHub repository and use:
- Framework preset: Other
- Build command: `flutter build web --release`
- Output directory: `build/web`

For Vercel, make sure Flutter is installed in the build environment; the easiest dependable route is to use a Flutter-specific deployment workflow or a Docker/build setup. GitHub Pages via GitHub Actions is a straightforward option for this assignment.

## How to demonstrate in viva

1. Open the home page and resize the browser to show the responsive grid.
2. Open a movie card to demonstrate navigation.
3. Select a date, showtime and multiple seats.
4. Try continuing without selecting a seat (button remains disabled).
5. Enter an invalid email to demonstrate form validation.
6. Complete a booking and open My Bookings.
7. Explain that Provider stores the bookings in memory while the app is running. This demo does not use a backend, real payment gateway or permanent database.

## Important
Bookings are stored in memory and will reset when the page is refreshed. The app is a functional front-end demonstration, not a real ticketing/payment service.

## Automatic GitHub Pages deployment (recommended)

This ZIP includes `.github/workflows/deploy.yml`.

1. Create a GitHub repository named `cinebook` (or use another name; the workflow automatically uses the repository name as the base path).
2. Push the extracted project to the repository's `main` branch.
3. In the repository, open Settings → Pages.
4. Under “Build and deployment”, choose “GitHub Actions” as the source.
5. Open the Actions tab and wait for “Deploy Flutter Web to GitHub Pages” to finish successfully.
6. Your site URL will look like `https://YOUR_USERNAME.github.io/cinebook/`.

Whenever you push a new commit to `main`, GitHub Actions rebuilds and redeploys the site.
