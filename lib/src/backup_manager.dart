import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;

/// Manages backup operations using ZIP compression.
class BackupManager {
  /// Creates a ZIP backup of the assets directory.
  /// 
  /// Returns the path to the created backup file.
  Future<String?> createZipBackup(String projectPath) async {
    final assetsDir = Directory(path.join(projectPath, 'assets'));
    
    if (!await assetsDir.exists()) {
      print('No assets directory found to backup.');
      return null;
    }

    final timestamp = DateTime.now().toIso8601String().replaceAll(RegExp(r'[:\-\.]'), '_');
    final backupFileName = 'assets_backup_$timestamp.zip';
    final backupPath = path.join(projectPath, '.assetkamkaro_backup', backupFileName);
    
    // Create backup directory if it doesn't exist
    final backupDir = Directory(path.dirname(backupPath));
    await backupDir.create(recursive: true);

    // Create ZIP archive
    final encoder = ZipFileEncoder();
    encoder.create(backupPath);
    
    // Add entire assets directory to the ZIP
    await encoder.addDirectory(assetsDir);
    encoder.close();

    return backupPath;
  }

  /// Restores assets from a ZIP backup.
  Future<void> restoreFromZip(String zipPath, String projectPath) async {
    final zipFile = File(zipPath);
    if (!await zipFile.exists()) {
      throw FileSystemException('Backup file not found: $zipPath');
    }

    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract to project directory
    for (final file in archive) {
      final filename = path.join(projectPath, file.name);
      if (file.isFile) {
        final outFile = File(filename);
        await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content as List<int>);
      } else {
        await Directory(filename).create(recursive: true);
      }
    }
  }

  /// Lists all available backups in the backup directory.
  Future<List<String>> listBackups(String projectPath) async {
    final backupDir = Directory(path.join(projectPath, '.assetkamkaro_backup'));
    
    if (!await backupDir.exists()) {
      return [];
    }

    final backups = <String>[];
    await for (final entity in backupDir.list()) {
      if (entity is File && entity.path.endsWith('.zip')) {
        backups.add(entity.path);
      }
    }

    return backups..sort((a, b) => b.compareTo(a)); // Most recent first
  }
}
