Smart Task Manager (Flutter)

A Smart Task Manager built with Flutter, following Clean Architecture, Bloc state management, and offline-first design.
The app supports task creation, update, deletion, search, pagination, and background sync when connectivity is restored.

 Features
_____________
* Add, edit, delete tasks

* Search tasks with debounce

* Pagination (infinite scrolling)

* Pull-to-refresh

* Offline-first support (Hive + background sync)

* Automatic sync when internet reconnects

* Clean Architecture (Data / Domain / Presentation)

* Bloc state management

* Dependency Injection using GetIt

* Cupertino-style dialogs (iOS feel)

* Responsive UI (phone & tablet ready)

* Unsynced task indicator

* Unit-test ready architecture
************************************
🏗 Architecture Overview

This project follows Clean Architecture to keep the codebase scalable, maintainable, and testable.
*************************
Layer Responsibilities
_______________________
* Presentation
UI + Bloc (state & events only)

* Domain
Business logic (Entities + UseCases)

* Data
Data sources, models, repository implementations

lib/
│
├── core/
│   ├── network/
│   │   ├── connectivity_service.dart
│   │   ├── network_info.dart
│   ├── error/
│   ├── constants/
│
├── feature/
│   └── tasks/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── task_local_data_source.dart
│       │   │   ├── task_remote_data_source.dart
│       │   ├── models/
│       │   │   └── task_model.dart
│       │   └── repositories/
│       │       └── task_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── task.dart
│       │   ├── repositories/
│       │   │   └── task_repository.dart
│       │   └── usecases/
│       │       ├── get_tasks.dart
│       │       ├── create_task.dart
│       │       ├── update_task.dart
│       │       ├── delete_task.dart
│       │       ├── sync_tasks.dart
│       │       └── task_usecases.dart
│       │
│       └── presentation/
│           ├── bloc/
│           │   ├── task_bloc.dart
│           │   ├── task_event.dart
│           │   └── task_state.dart
│           ├── pages/
│           │   └── task_page.dart
│           └── widgets/
│               └── app_custom_textfield.dart
│
├── di/
│   └── injection_container.dart
│
└── main.dart
*********************************

 Offline-First & Sync Strategy
 __________________________________

Tasks are always saved locally (Hive) first

* If internet is available:
_______________________
Data is synced to remote API (via Dio)

Task is marked as isSynced = true

* If offline:
______________
Task remains locally stored

Marked as isSynced = false

When connectivity is restored:

connectivity_plus triggers background sync

Unsynced tasks are pushed to server automatically

***********************************
State Management (Bloc)
__________________________
The Bloc layer handles all business logic.

* Events
___________

LoadTasks

AddTask

UpdateTaskEvent

DeleteTaskEvent

SearchTasks

LoadMoreTasks

RefreshTasks

ConnectivityChanged

* States
___________
TaskInitial

TaskLoading

TaskLoaded

TaskError
*********************
Tech Stack
_____________

Flutter

Bloc (flutter_bloc)

Hive (local persistence)

Dio (network requests)

connectivity_plus (network monitoring)

GetIt (dependency injection)

UUID (unique IDs)