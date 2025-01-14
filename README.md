# Flutter To-Do List App
 - A simple and intuitive to-do list application built with Flutter that allows users to add, edit, delete, and manage tasks efficiently. The app stores tasks in a local SQLite database, ensuring data persistence.

# Features
- Task Management: Add, edit, and delete tasks.
 - Date Picker: Easily select task dates with a calendar view.
 - Local Storage: Persist data using SQLite.
 - Responsive UI: Adapts to different screen sizes.
 - Customizable Colors: Each task displays with alternating background colors.

# How to Run the Project
1) Clone the repository:
 - git clone https://github.com/yourusername/flutter-todo-app.git
2) Navigate to the project directory:
 - cd flutter-todo-app
3) Install dependencies:
 - flutter pub get
4) Run the app:
 - flutter run

# Project Structure

lib/
├── main.dart            # Entry point of the application
├── models/
│   └── todo_model.dart  # ToDo model class
└── widgets/
|    └── todo_list.dart   # Main screen to manage tasks
├── screenshots/
│   ├── home_screen.png
│   ├── add_task.png
│   └── edit_task.png
    
# Dependencies
This app uses the following packages:
- flutter/material.dart - For UI design
- google_fonts - For custom fonts
- intl - For date formatting
- sqflite - For SQLite database integration
- path - For database file path management

:- To add these dependencies, they are listed in pubspec.yaml:

dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^5.0.0
  intl: ^0.18.0
  sqflite: ^2.0.0+4
  path: ^1.8.0

# How It Works
1) Task Management:
 - Add Task: Tap the "+" button to add a new task. Fill in the title, description, and date, then press "Submit."
 - Edit Task: Tap the pencil icon next to a task to edit it.
 - Delete Task: Tap the trash icon to remove a task.
2) Database:
 - Data is stored in an SQLite database (todo.db) using the sqflite package.
 - The table AddTodoTask is created to store task information (id, title, description, and date).
3) Custom Styling:
 - Custom colors and fonts are applied using the google_fonts package for better visuals.

# Screenshots
1) Home Screen:- A list of all tasks with options to edit or delete.
   - screenshots\Add Task Modal.jpg
2) Add/Edit Task Modal:- A form to input or edit task details.
   - screenshots\Edit Task Modal.jpg
   - screenshots\Home Screen.jpg

# Future Enhancements
-Search Functionality: Add a search bar to filter tasks.
-Notifications: Implement reminders for tasks.
-Dark Mode: Add support for dark theme.
-Cloud Sync: Sync tasks to the cloud for cross-device access.

