# Quizz App

A simple true/false quiz app built with Flutter.  
Users can pick a category, answer a series of questions, see immediate feedback, and view their final score.

## Features

- 5 quiz categories (History, Geography, Math, Science, Culture)
- At least 10 true/false questions per category
- Categories grid view with images and names
- Detailed quiz view with category image, question text, and True/False buttons
- Instant feedback after each answer (color change and correct-answer highlight)
- Final score screen showing correct and incorrect answers and percentage
- Button on score screen to return to the categories page

## Requirements Mapping

- **Models**: `Question` and `Category` in `lib/models`
- **Categories page**: `CategoriesPage` in `lib/screens/categories_page.dart`
- **Detailed view (quiz)**: `QuizPage` in `lib/screens/quiz_page.dart`
- **Score view**: `ScorePage` in `lib/screens/score_page.dart`
- **Entry point**: `main.dart` in `lib/main.dart`

## Project Structure

- `lib/main.dart` – App entry point, sets `CategoriesPage` as home
- `lib/models/question.dart` – `Question` model
- `lib/models/category.dart` – `Category` model
- `lib/data/categories_data.dart` – Hard-coded categories and questions
- `lib/screens/categories_page.dart` – Grid of quiz categories
- `lib/screens/quiz_page.dart` – Quiz flow and state management
- `lib/screens/score_page.dart` – Final score summary view

## How to Run

From the project root:

```bash
cd quizz-app
flutter pub get
flutter run
```

Make sure you have Flutter installed and an emulator or physical device connected.


