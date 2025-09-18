# Changelog

## [1.0.0] - 2025-09-01 - YY:MM:DD
### Added
- Initial commit to the `development` branch.
- Set up the project structure for the cafe app.
- Added basic assets and configuration files.

## [1.1.0] - 2025-09-02
### Added
- Using our api endpoint(/api/menu) for getting our menu

## [1.2.0] - 2025-09-03
### Added
- API reservation for waiter's

### Fixed
- Changed the architecture to MVVM
- Splitted the code up more for better structure and overall readability

## [1.2.1] - 2025-09-04

### Fixed
- Fixed button sizing

## [1.3.0] - 2025-09-04

### Added
- Create reservation in App using api endpoint

## [1.3.1] - 2025-09-05

### Fixed
- Made some small changes like making an .env file for storing api base url. Removed main function on chefpage and waiterspage. Now its instantiated through navigation from the main app.

## [1.3.2] - 2025-09-10

### Fixed
- Changed the time format from am/pm to 24 hour.
- Changed the model for the time picker to include 24 hour time.

## [1.3.3] - 2025-09-15

### Added
- Added unit test to the app + github workflow.

### Fixed
- Made small changes to api_service.dart

## [1.3.4] - 2025-09-16

### Added
- Tab bar in the waiter view to switch between today's reservations and future reservations.

### Fixed
- .env file is included in the assets folder now.

## [1.4.0] - 2025-09-18

### Changed
- Refactored waiter view to follow MVVM.
- Splitted the code into smaller widgets reservations and order tabs.
- Added unit-test for creating order.