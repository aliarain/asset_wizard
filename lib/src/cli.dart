import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:mason_logger/mason_logger.dart';
import '../asset_wizard.dart';
import 'features/watcher.dart';
import 'questionnaire.dart';
import 'backup_manager.dart';

/// Command-line interface for AssetWizard.
class AssetWizardCli {
  final ArgParser _parser;
  late final Logger _logger;

  AssetWizardCli() : _parser = ArgParser() {
    _parser
      ..addOption(
        'compression',
        abbr: 'c',
        help: 'Compression level (low, medium, high)',
        defaultsTo: 'medium',
      )
      ..addFlag(
        'dry-run',
        abbr: 'd',
        help: 'Analyze without making changes',
        defaultsTo: false,
      )
      ..addFlag(
        'backup',
        abbr: 'b',
        help: 'Create ZIP backup before optimization',
        defaultsTo: true,
      )
      ..addMultiOption(
        'exclude',
        abbr: 'e',
        help: 'Directories to exclude from optimization',
        defaultsTo: const [],
      )
      ..addFlag(
        'delete-unused',
        abbr: 'D',
        help: 'Delete unused assets',
        defaultsTo: false,
      )
      ..addOption(
        'config',
        help: 'Path to configuration file',
        defaultsTo: 'config.yaml',
      )
      ..addFlag(
        'webp',
        help: 'Convert images to WebP',
        defaultsTo: false,
      )
      ..addFlag(
        'generate-class',
        help: 'Generate AppAssets class',
        defaultsTo: false,
      )
      ..addFlag(
        'watch',
        abbr: 'w',
        help: 'Watch for changes',
        defaultsTo: false,
      )
      ..addFlag(
        'interactive',
        abbr: 'i',
        help: 'Use interactive questionnaire mode',
        defaultsTo: false,
      )
      ..addFlag(
        'cute',
        help: 'Enable cute mode with emojis',
        defaultsTo: true,
      )
      ..addFlag(
        'help',
        abbr: 'h',
        help: 'Show help information',
        defaultsTo: false,
        negatable: false,
      );
  }

  Future<void> run(List<String> arguments) async {
    try {
      final results = _parser.parse(arguments);
      
      _logger = Logger(
        level: Level.info,
        theme: results['cute'] as bool ? LogTheme() : LogTheme(), // Custom theme could be added here
      );

      if (results['help'] as bool) {
        _printUsage();
        return;
      }

      // Check for positional arguments for commands
      if (results.rest.isNotEmpty) {
        final command = results.rest.first;
        
        if (command == 'init') {
          await _initProject();
          return;
        }

        if (command == 'clean') {
          await _cleanProject();
          return;
        }

        if (command == 'version') {
          _printVersion();
          return;
        }
      }

      _printLogo(results['cute'] as bool);

      // Handle interactive mode
      String compressionLevel = results['compression'] as String;
      bool deleteUnused = results['delete-unused'] as bool;
      bool generateClass = results['generate-class'] as bool;
      bool convertWebP = results['webp'] as bool;

      if (results['interactive'] as bool) {
        final questionnaire = InteractiveQuestionnaire(_logger);
        final preferences = await questionnaire.run();
        
        compressionLevel = preferences['compressionLevel'] as String;
        deleteUnused = preferences['deleteUnused'] as bool;
        generateClass = preferences['generateClass'] as bool;
        convertWebP = preferences['convertWebP'] as bool;
      }

      final progress = _logger.progress('Analyzing project...');
      
      final optimizer = AssetWizard();

      // Create ZIP backup if enabled
      if (results['backup'] as bool && !(results['dry-run'] as bool)) {
        progress.update('Creating ZIP backup...');
        final backupManager = BackupManager();
        final backupPath = await backupManager.createZipBackup(Directory.current.path);
        if (backupPath != null) {
          _logger.info('📦 Backup created: $backupPath');
        }
      }

      if (results['watch'] as bool) {
        _logger.info('Starting watch mode... 👀');
        final watcher = AssetWatcher(
          projectPath: Directory.current.path,
          onAssetChanged: (path) async {
            _logger.info('Asset changed: $path');
            // Re-run optimization or specific task
            // For simplicity, we re-run the whole optimization for now, 
            // but ideally we should only process the changed file.
             final result = await optimizer.optimize(
              projectPath: Directory.current.path,
              compressionLevel: _parseCompressionLevel(compressionLevel),
              dryRun: results['dry-run'] as bool,
              createBackup: false, // Don't backup repeatedly in watch mode
              excludePatterns: results['exclude'] as List<String>,
              deleteUnused: deleteUnused,
              convertWebP: convertWebP,
              generateClass: generateClass,
            );
            _printResult(result, results['cute'] as bool);
          },
        );
        watcher.start();
        
        // Keep alive
        await Completer<void>().future;
        return;
      }

      final result = await optimizer.optimize(
        projectPath: Directory.current.path,
        compressionLevel: _parseCompressionLevel(compressionLevel),
        dryRun: results['dry-run'] as bool,
        createBackup: results['backup'] as bool,
        excludePatterns: results['exclude'] as List<String>,
        deleteUnused: deleteUnused,
        convertWebP: convertWebP,
        generateClass: generateClass,
      );

      progress.complete('Optimization complete!');
      _printResult(result, results['cute'] as bool);

    } catch (e) {
      _logger.err('Error: $e');
      _printUsage();
      exit(1);
    }
  }

  Future<void> _initProject() async {
    final configFile = File('config.yaml');
    if (await configFile.exists()) {
      _logger.warn('config.yaml already exists!');
      return;
    }

    await configFile.writeAsString('''
compression:
  level: medium
  jpeg:
    quality: 80
  png:
    level: 9

exclude:
  - assets/icons
  - assets/backgrounds

backup: true
delete_unused: false
''');
    _logger.success('Created config.yaml ✨');
  }

  Future<void> _cleanProject() async {
    final backupDir = Directory('.asset_wizard_backup');
    if (await backupDir.exists()) {
      await backupDir.delete(recursive: true);
      _logger.success('Cleaned up backup files 🧹');
    } else {
      _logger.info('No backup files found to clean.');
    }
  }

  void _printVersion() {
    _logger.info('AssetWizard v0.2.0 ✨🧙');
  }

  void _printUsage() {
    _logger.info('Usage: dart run ak [options]');
    _logger.info(_parser.usage);
  }

  void _printLogo(bool cute) {
    if (cute) {
      _logger.info('''
    _                _  __        ___                  _ 
   / \\   ___ ___  ___| |_/ \\      / (_)______ _ _ __ __| |
  / _ \\ / __/ __|/ _ \\ __\\ \\ /\\ / /| |_  / _` | '__/ _` |
 / ___ \\\\__ \\__ \\  __/ |_ \\ V  V / | |/ / (_| | | | (_| |
/_/   \\_\\___/___/\\___|\\__| \\_/\\_/  |_/___\\__,_|_|  \\__,_|
                                                          
      ''');
      _logger.info('✨🧙 Making your assets magical and tiny! ✨🧙\n');
    }
  }

  void _printResult(OptimizationResult result, bool cute) {
    if (cute) {
      _logger.info('🎉 Total size reduction: ${result.totalSizeReduction} bytes');
      _logger.info('📦 Assets processed: ${result.totalAssetsProcessed}');
      if (result.unusedAssets.isNotEmpty) {
        _logger.warn('🗑️  Unused assets found: ${result.unusedAssets.length}');
      }
    } else {
      print(result);
    }
  }

  CompressionLevel _parseCompressionLevel(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return CompressionLevel.low;
      case 'high':
        return CompressionLevel.high;
      case 'medium':
      default:
        return CompressionLevel.medium;
    }
  }
}
