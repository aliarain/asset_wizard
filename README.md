# AssetWizard ✨🧙

[![pub package](https://img.shields.io/pub/v/asset_wizard.svg?style=for-the-badge&logo=flutter&color=02569B)](https://pub.dev/packages/asset_wizard)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**A magical Flutter CLI tool that compresses images, removes unused assets, generates type-safe classes, creates ZIP backups and shrinks your app size in seconds.**

> ### 🔄 Migrating from AssetKamKaro?
> Just change the dependency name to `asset_wizard: ^0.2.0` and run `dart pub get`.  
> Old command is gone – use the new short one: `dart run ak`

---

## ✨ Features

- **🎨 Smart Image Compression** - Reduce file sizes while maintaining quality
- **🗑️ Unused Asset Detection** - Find assets that aren't referenced in code
- **📦 ZIP Backup System** - Never lose your original assets
- **🎤 Interactive Questionnaire** - Guided setup for beginners
- **🎭 Beautiful CLI** - Cute mode with emojis and colors
- **⚡ Short Command** - Just `ak` instead of long commands
- **👀 Watch Mode** - Auto-optimize when assets change
- **🏗️ Type-Safe Assets** - Generate Dart classes for asset paths
- **🛡️ Safe Operations** - Dry-run mode and automatic backups

---

## 🚀 Quick Start

### Installation

```bash
# Add to your pubspec.yaml
dependencies:
  asset_wizard: ^0.2.0

# Or install globally for CLI use
dart pub global activate asset_wizard
```

### Basic Usage

```bash
# Interactive mode (recommended for first-time users)
dart run ak -i

# Or use with options
dart run ak --compression high --generate-class

# See all options
dart run ak --help
```

---

## 📖 Usage

### Command Line Interface

```bash
# Initialize configuration
dart run ak init

# Basic optimization
dart run ak

# With specific compression level
dart run ak --compression high

# Dry run to analyze without making changes
dart run ak --dry-run

# Delete unused assets
dart run ak --delete-unused

# Generate type-safe asset class
dart run ak --generate-class

# Watch mode for automatic optimization
dart run ak --watch

# Clean up backup files
dart run ak clean

# Check version
dart run ak version
```

### Interactive Mode 🎤

The easiest way to use AssetWizard:

```bash
dart run ak -i
```

This will guide you through:
- Compression level selection
- Unused asset deletion
- Asset class generation
- WebP conversion (coming soon)

### Programmatic Usage

```dart
import 'package:asset_wizard/asset_wizard.dart';

void main() async {
  final wizard = AssetWizard();
  
  final result = await wizard.optimize(
    projectPath: 'path/to/your/flutter/project',
    compressionLevel: CompressionLevel.medium,
    generateClass: true,
  );
  
  print('Total size reduction: ${result.totalSizeReduction} bytes');
  print('Assets processed: ${result.totalAssetsProcessed}');
  print('Unused assets found: ${result.unusedAssets.length}');
}
```

---

## 🎯 Configuration

Create a `config.yaml` file in your project root:

```yaml
compression:
  level: medium
  jpeg:
    quality: 80
    subsampling: yuv420
  png:
    level: 9
    filter: 0

exclude:
  - assets/icons
  - assets/backgrounds

backup: true
delete_unused: false
```

Or generate it automatically:

```bash
dart run ak init
```

---

## 🎨 Features in Detail

### Smart Compression
- **Low**: Minimal compression, highest quality (10% reduction)
- **Medium**: Balanced compression and quality (30% reduction)
- **High**: Maximum compression, lower quality (50% reduction)

### ZIP Backups 📦
- Automatic timestamped backups before optimization
- Stored in `.asset_wizard_backup/` directory
- Restore anytime if something goes wrong
- Skip with `--no-backup` flag

### Asset Class Generator 🏗️
Generates `lib/app_assets.dart` with type-safe constants:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND
class AppAssets {
  AppAssets._();

  static const String logo_png = 'assets/images/logo.png';
  static const String icon_home = 'assets/icons/home.svg';
}

// Use in your code
Image.asset(AppAssets.logo_png)
```

### Watch Mode 👀
Monitor your assets directory and automatically optimize when files change:

```bash
dart run ak --watch
```

Perfect for development workflow!

### Cute Mode 🎨
Enabled by default! Enjoy:
- Beautiful ASCII art logo
- Emoji-enhanced messages
- Colorful progress bars
- Animated spinners

Disable for CI/CD:
```bash
dart run ak --no-cute
```

---

## 📊 CLI Options

| Option | Short | Description | Default |
|--------|-------|-------------|---------|
| `--compression` | `-c` | Compression level (low/medium/high) | medium |
| `--dry-run` | `-d` | Analyze without making changes | false |
| `--backup` | `-b` | Create ZIP backup before optimization | true |
| `--exclude` | `-e` | Directories to exclude | [] |
| `--delete-unused` | `-D` | Delete unused assets | false |
| `--generate-class` | | Generate AppAssets class | false |
| `--watch` | `-w` | Watch for changes | false |
| `--interactive` | `-i` | Use interactive questionnaire | false |
| `--cute` | | Enable cute mode with emojis | true |
| `--help` | `-h` | Show help information | - |

---

## 🎯 Use Cases

- 📱 **Before App Store submission** - Reduce bundle size to meet requirements
- 🔄 **During development** - Keep assets optimized with watch mode
- 🧹 **Spring cleaning** - Remove unused assets and clean up
- 🚀 **CI/CD Integration** - Automate asset optimization in build pipelines
- 📊 **Asset auditing** - Understand what's taking up space

---

## 🤝 Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) before submitting pull requests.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- [image](https://pub.dev/packages/image) package for image processing
- [path](https://pub.dev/packages/path) package for path handling
- [yaml](https://pub.dev/packages/yaml) package for configuration
- [args](https://pub.dev/packages/args) package for CLI support
- [mason_logger](https://pub.dev/packages/mason_logger) for beautiful CLI output
- [archive](https://pub.dev/packages/archive) for ZIP compression

---

## 📞 Support

If you find a bug or have a feature request, please [open an issue](https://github.com/aliarain/asset_wizard/issues).

---

**Made with ✨ and 🧙 by the Flutter community**

**Happy Optimizing! ✨**
