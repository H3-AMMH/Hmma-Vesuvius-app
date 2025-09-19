## Copilot Contribution Instructions

- **Architecture:**  
  Follow the MVVM (Model-View-ViewModel) pattern.  
  - Place business logic in `viewmodels/`.
  - UI code belongs in `views/` and `widgets/`.
  - Data models go in `models/`.
  - API and data access in `services/`.

- **Flutter Standards:**  
  - Use idiomatic Flutter and Dart code.
  - Prefer stateless widgets where possible.
  - Use `const` constructors and widgets when possible.
  - Use theming and avoid hardcoded colors/styles in widgets.

- **Code Quality:**  
  - Avoid duplicated code; extract reusable logic into methods, widgets, or helpers.
  - Use descriptive variable and method names.
  - Keep files and classes focused and concise.

- **Testing:**  
  - Write unit tests for important features, especially for business logic in `viewmodels/` and `services/`.
  - Place tests in the `test/` directory.
  - Ensure all tests pass before submitting changes.

- **Other Guidelines:**  
  - Use environment variables for configuration (see `.env`).
  - Document public classes and methods where appropriate.
  - Run `flutter analyze` and address warnings.
