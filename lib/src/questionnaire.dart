import 'dart:io';
import 'package:mason_logger/mason_logger.dart';

/// Interactive questionnaire for gathering optimization preferences.
class InteractiveQuestionnaire {
  final Logger _logger;

  InteractiveQuestionnaire(this._logger);

  /// Asks the user for their optimization preferences.
  Future<Map<String, dynamic>> run() async {
    _logger.info('📋 Let\'s configure your asset optimization!\n');

    final compressionLevel = _askCompressionLevel();
    final deleteUnused = _askYesNo('Do you want to delete unused assets?', defaultValue: false);
    final generateClass = _askYesNo('Generate type-safe asset class (AppAssets)?', defaultValue: true);
    final convertWebP = _askYesNo('Convert images to WebP? (Note: Not yet implemented)', defaultValue: false);
    
    return {
      'compressionLevel': compressionLevel,
      'deleteUnused': deleteUnused,
      'generateClass': generateClass,
      'convertWebP': convertWebP,
    };
  }

  String _askCompressionLevel() {
    _logger.info('🎚️  Select compression level:');
    _logger.info('  1. Low (highest quality, minimal compression)');
    _logger.info('  2. Medium (balanced)');
    _logger.info('  3. High (maximum compression, lower quality)');
    
    while (true) {
      stdout.write('\nYour choice [1-3] (default: 2): ');
      final input = stdin.readLineSync()?.trim() ?? '';
      
      if (input.isEmpty || input == '2') return 'medium';
      if (input == '1') return 'low';
      if (input == '3') return 'high';
      
      _logger.err('Invalid choice. Please enter 1, 2, or 3.');
    }
  }

  bool _askYesNo(String question, {required bool defaultValue}) {
    final defaultText = defaultValue ? 'Y/n' : 'y/N';
    stdout.write('$question [$defaultText]: ');
    
    final input = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    
    if (input.isEmpty) return defaultValue;
    return input == 'y' || input == 'yes';
  }
}
