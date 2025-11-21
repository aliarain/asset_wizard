import 'package:assetkamkaro/src/cli.dart';
import 'dart:io';

/// Entry point for the AssetKamKaro CLI tool.
///
/// This tool helps optimize and manage assets in Flutter projects by:
/// - Compressing images while maintaining quality
/// - Detecting and removing unused assets
/// - Providing detailed optimization reports
///
/// Usage:
/// ```bash
/// dart run assetkamkaro:optimize [options]
/// ```
///
/// Options:
/// - --compression: Set compression level (low, medium, high)
/// - --dry-run: Show what would be done without making changes
/// - --backup: Create backup before making changes
/// - --exclude: Comma-separated list of files/directories to exclude
/// - --delete: Delete unused assets
/// - --config: Path to custom configuration file
void main(List<String> arguments) async {
  try {
    final cli = AssetKamKaroCli();
    await cli.run(arguments);
  } catch (e) {
    stderr.writeln('Error: $e');
    exitCode = 1;
  }
}
