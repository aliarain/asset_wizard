import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:dart_style/dart_style.dart';

class AssetGenerator {
  Future<void> generate(String projectPath, List<String> assetPaths) async {
    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln('// ignore_for_file: constant_identifier_names');
    buffer.writeln();
    buffer.writeln('class AppAssets {');
    buffer.writeln('  AppAssets._();');
    buffer.writeln();

    for (final assetPath in assetPaths) {
      final relativePath = path.relative(assetPath, from: projectPath);
      final variableName = _generateVariableName(relativePath);
      buffer.writeln("  static const String $variableName = '$relativePath';");
    }

    buffer.writeln('}');

    final formatter = DartFormatter();
    final formattedCode = formatter.format(buffer.toString());

    final outputFile = File(path.join(projectPath, 'lib', 'app_assets.dart'));
    await outputFile.parent.create(recursive: true);
    await outputFile.writeAsString(formattedCode);
  }

  String _generateVariableName(String assetPath) {
    final name = path.basenameWithoutExtension(assetPath);
    // Simple sanitization and camelCase conversion could go here
    // For now, just replacing non-alphanumeric with underscores
    return name.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').toLowerCase();
  }
}
