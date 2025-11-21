# Changelog

## [0.2.0] - 2025-11-21 – The Rebirth Update ✨🧙

### 🎉 Major Changes
- **BREAKING:** Renamed package from `assetkamkaro` to `asset_wizard`
- **BREAKING:** Renamed main class from `AssetKamKaro` to `AssetWizard`
- **BREAKING:** Renamed CLI class from `AssetKamKaroCli` to `AssetWizardCli`
- Updated package description to emphasize magical, fast asset optimization
- Bumped version to 0.2.0 to reflect breaking changes

### ✨ New Features
- Interactive questionnaire mode (`--interactive` or `-i` flag)
- ZIP backup system with timestamped backups
- Shortened command: `dart run ak` (was `dart run assetkamkaro:optimize`)
- New commands: `init`, `clean`, `version`
- "Cute mode" with ASCII art logo and emojis (enabled by default)
- Asset class generator for type-safe asset references
- Watch mode for automatic optimization on file changes
- WebP converter (placeholder for future implementation)

### 🐛 Bug Fixes
- Fixed unsafe type casting for `YamlMap` and `YamlList` in validator
- Fixed code style issues (curly braces in flow control)
- Removed unused imports throughout codebase
- Fixed CLI command parsing to use positional arguments

### 📦 Dependencies
- Added `mason_logger: ^0.2.10` for beautiful CLI output
- Added `watcher: ^1.1.0` for file system watching
- Added `dart_style: ^2.3.4` for code formatting
- Added `archive: ^3.4.10` for ZIP compression

### 🔄 Migration Guide
If you were using `assetkamkaro`:

1. Update your `pubspec.yaml`:
   ```yaml
   dependencies:
     asset_wizard: ^0.2.0  # was: assetkamkaro: ^0.1.1
   ```

2. Update imports:
   ```dart
   // Old:
   import 'package:assetkamkaro/assetkamkaro.dart';
   
   // New:
   import 'package:asset_wizard/asset_wizard.dart';
   ```

3. Update class names:
   ```dart
   // Old:
   final optimizer = AssetKamKaro();
   
   // New:
   final optimizer = AssetWizard();
   ```

4. Update CLI commands:
   ```bash
   # Old:
   dart run assetkamkaro:optimize --help
   
   # New:
   dart run ak --help
   ```

### 📝 Internal Changes
- Renamed backup directory from `.assetkamkaro_backup` to `.asset_wizard_backup`
- Renamed cache directory from `.assetkamkaro_cache` to `.asset_wizard_cache`
- Updated ASCII logo to "AssetWizard" with magical theme
- Updated all documentation and comments

---

## [0.1.1] - 2024-03-21

### Fixed
- Fixed example code to match actual API
- Removed duplicate CompressionResult class definition
- Corrected parameter names in optimize method
- Updated result properties to match OptimizationResult class

### Changed
- Improved error handling in compression process
- Enhanced documentation for public APIs
- Updated example to use proper CompressionLevel enum
- Standardized parameter naming across the package

## [0.1.0] - 2024-03-21

### Added
- Initial release of AssetKamKaro
- Asset optimization functionality
- Command-line interface
- Configuration support
- Progress reporting
- Asset analysis
- Unused asset detection
- Cache management
- Worker pool for parallel processing

### Changed
- Improved compression algorithms
- Enhanced error handling
- Better type safety
- Updated documentation
- Optimized performance

### Fixed
- Fixed linter warnings
- Removed unused imports
- Corrected import paths
- Fixed type issues
- Added missing dependencies

### Security
- Improved error handling
- Enhanced file operations safety
- Better cache management

## [1.0.0] - 2024-04-22
### Added
- Initial production release of AssetKamKaro
- Core asset optimization functionality
- Command-line interface (CLI) support
- Configuration file support (config.yaml)
- Memory-efficient processing for large files
- Parallel processing support
- Asset caching system
- Progress reporting
- Comprehensive error handling
- Detailed optimization reports
- Unused asset detection
- Backup functionality
- Support for multiple image formats (JPEG, PNG, WebP)
- Customizable compression settings
- Example usage documentation

### Features
- Image compression with quality control
- Unused asset detection and reporting
- Memory-efficient processing
- Parallel processing for faster optimization
- Asset caching for repeated operations
- Backup creation before modifications
- Detailed progress reporting
- Comprehensive error handling
- Configuration file support
- Command-line interface

### Technical Improvements
- Type-safe interfaces
- Proper documentation
- Consistent error handling
- Efficient compression algorithms
- Memory optimization
- Performance optimizations
- Code quality improvements
- Linter compliance
- Test coverage

### Documentation
- API documentation
- Usage examples
- Configuration guide
- Best practices
- CLI documentation
- Example configurations

### Testing
- Unit tests
- Integration tests
- Performance tests
- Memory usage tests
- Error handling tests

### Dependencies
- image: ^4.0.0
- path: ^1.8.0
- yaml: ^3.1.0
- args: ^2.4.0
