import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'types.dart';

/// Validates and analyzes assets in a Flutter project.
class AssetValidator {
  /// Creates a new [AssetValidator].
  const AssetValidator();

  /// Analyzes assets in the given Flutter project.
  ///
  /// Parameters:
  /// - [projectPath]: Path to the Flutter project root directory
  ///
  /// Returns an [AssetAnalysis] containing information about all assets.
  Future<AssetAnalysis> analyzeAssets(String projectPath) async {
    final pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
    if (!pubspecFile.existsSync()) {
      throw FileSystemException('pubspec.yaml not found in $projectPath');
    }

    final pubspecContent = await pubspecFile.readAsString();
    final pubspec = loadYaml(pubspecContent);
    if (pubspec is! YamlMap) {
       throw FileSystemException('Invalid pubspec.yaml format');
    }

    final assets = <String, AssetMetadata>{};
    final unusedAssets = <String>[];

    // Extract assets from pubspec.yaml
    if (pubspec.containsKey('flutter')) {
      final flutter = pubspec['flutter'];
      if (flutter is YamlMap && flutter.containsKey('assets')) {
        final assetList = flutter['assets'];
        if (assetList is YamlList) {
          for (final asset in assetList) {
            final assetPath = asset.toString();
            final file = File(path.join(projectPath, assetPath));

            if (file.existsSync()) {
              final size = await file.length();
              assets[assetPath] = AssetMetadata(
                path: assetPath,
                size: size,
                type: _getAssetType(assetPath),
              );
            }
          }
        }
      }
    }

    // Find unused assets
    await _findUnusedAssets(projectPath, assets, unusedAssets);

    return AssetAnalysis(assets: assets, unusedAssets: unusedAssets);
  }

  /// Determines the type of an asset based on its extension.
  String _getAssetType(String assetPath) {
    final extension = path.extension(assetPath).toLowerCase();
    switch (extension) {
      case '.png':
      case '.jpg':
      case '.jpeg':
        return 'image';
      case '.ttf':
      case '.otf':
        return 'font';
      default:
        return 'other';
    }
  }

  /// Finds unused assets by scanning Dart files for references.
  Future<void> _findUnusedAssets(
    String projectPath,
    Map<String, AssetMetadata> assets,
    List<String> unusedAssets,
  ) async {
    final libDir = Directory(path.join(projectPath, 'lib'));
    if (!libDir.existsSync()) {
      return;
    }

    final dartFiles = await _findDartFiles(libDir);
    final referencedAssets = <String>{};

    for (final file in dartFiles) {
      final content = await file.readAsString();
      for (final asset in assets.keys) {
        if (content.contains(asset)) {
          referencedAssets.add(asset);
        }
      }
    }

    unusedAssets.addAll(
      assets.keys.where((asset) => !referencedAssets.contains(asset)),
    );
  }

  /// Recursively finds all Dart files in a directory.
  Future<List<File>> _findDartFiles(Directory dir) async {
    final files = <File>[];
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        files.add(entity);
      }
    }
    return files;
  }

  /// Formats file size in human-readable format.
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Estimates potential savings for each asset based on compression level.
  Map<String, Map<String, dynamic>> estimateSavings(
    Map<String, Map<String, dynamic>> assets,
    String compressionLevel,
  ) {
    final savings = <String, Map<String, dynamic>>{};

    for (final entry in assets.entries) {
      final asset = entry.value;
      final type = asset['type'] as String;
      final size = asset['size'] as int;

      if (type == '.png' || type == '.jpg' || type == '.jpeg') {
        double reduction;
        switch (compressionLevel) {
          case 'low':
            reduction = 0.1; // 10% reduction
            break;
          case 'medium':
            reduction = 0.3; // 30% reduction
            break;
          case 'high':
            reduction = 0.5; // 50% reduction
            break;
          default:
            reduction = 0.3;
        }

        final estimatedSize = size * (1 - reduction);
        savings[entry.key] = {
          'currentSize': asset['sizeFormatted'],
          'estimatedSize': _formatFileSize(estimatedSize.toInt()),
          'savings': _formatFileSize((size * reduction).toInt()),
          'reduction': '${(reduction * 100).toStringAsFixed(1)}%',
        };
      } else {
        savings[entry.key] = {
          'currentSize': asset['sizeFormatted'],
          'estimatedSize': asset['sizeFormatted'],
          'savings': '0 B',
          'reduction': '0%',
          'note': 'Not compressible',
        };
      }
    }

    return savings;
  }
}
