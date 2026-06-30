# TrueFit Project Details

## Overview
**TrueFit** is an iOS application built using **SwiftUI**. The project follows **Clean Architecture** principles and is modularized using local Swift packages/folders to separate concerns.

## Tech Stack & Core Technologies
- **UI Framework**: SwiftUI
- **Architecture**: Clean Architecture (Domain, Data, Core, Features)
- **Dependency Injection**: Manual DI via `DIContainer`
- **State Management & Routing**: `ObservableObject` / `@StateObject` alongside Router objects (`AppRouter`, `AuthRouter`) injected via `@EnvironmentObject`.
- **Local Storage**: CoreData (for persistence) and UserDefaults (for preferences tracking).

## Project Structure
The source code is primarily split into the `App` lifecycle folder and the `Packages` folder which simulates modularity.

### 1. App (`TrueFit/App/`)
Contains the application's entry point, root state management, and high-level routing.
- **`TrueFitApp.swift`**: Main entry point. Initializes the `DIContainer` and injects routers and CoreData contexts into the environment.
- **`RootView.swift` & `RootViewModel.swift`**: Manages the top-level application state (`splash`, `onboarding`, `unauthenticated`, `guest`, `authenticated`). Routes users based on their authentication and onboarding status.
- **`AppRouter.swift` & `AuthRouter.swift`**: Manage navigation stacks and routing logic for the main app and authentication flows, respectively.

### 2. Packages (`TrueFit/Packages/`)
Structured following Clean Architecture principles:

- **Core (`Packages/Core/`)**:
  - **DesignSystem**: Contains foundations for Typography, Motion, Spacing, Shadow, Radius, Colors, and extensions for AppImages.
  - **DI (`DIContainer.swift`)**: Centralizes the instantiation of dependencies like `AuthManager`, `PreferencesManager`, `PersistenceController`, and Routers.
  - **Networking**: For API communication.
  - **Utilities & Helpers**: Contains `AuthManager` (handles guest mode, keychain token storage) and `PreferencesManager` (tracks if onboarding has been seen).
  
- **Data (`Packages/Data/`)**:
  - **DataSources**: Remote and Local data sources.
  - **Repositories**: Implementations of Domain repository interfaces.
  - **DTOs**: Data Transfer Objects for mapping API responses to local models.
  - **Mappers**: For mapping between DTOs, Local models, and Domain Entities.

- **Domain (`Packages/Domain/`)**:
  - **Entities**: Pure business logic models.
  - **UseCases**: Business logic rules and operations.
  - **RepositoryInterfaces**: Protocols defining data operations to be implemented by the Data layer.

- **Features (`Packages/Features/`)**:
  - Contains modular UI features.
  - **AuthFeature**: Implements SignIn (`LoginView`, `ForgotPasswordView`, `NewPasswordView`) and SignUp (`SignUpView`, `SuccessView`). Uses components like `AuthTextField`, `SocialLoginButton`, and `PrimaryButton`. Managed by `AuthViewModel`.

## Key Flows & Mechanics
- **Onboarding & Guest Mode**: `RootViewModel` evaluates `PreferencesManager.hasSeenOnboarding` and `AuthManager` state to route the user. Users can skip auth by selecting "Continue as Guest".
- **Authentication**: `AuthManager` handles tokens securely (prepared for Keychain). Successful login updates the `RootViewModel` state to `.authenticated`.

## Persistence
- **CoreData**: Initialized via `PersistenceController` and injected into the SwiftUI environment. (`TrueFit.xcdatamodeld`).
- **UserDefaults**: Used for lightweight flags like `hasSeenOnboarding`.
