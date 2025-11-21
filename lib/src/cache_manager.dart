import 'dart:io';
import 'package:path/path.dart' as path;

/// Manages caching of processed assets to avoid reprocessing.
///
/// The CacheManager maintains a cache of file hashes to determine if an asset
/// has been modified since the last optimization. This helps avoid unnecessary
/// reprocessing of unchanged assets, improving performance.
///
/// The cache is stored in a JSON file within the specified cache directory.
/// By default, the cache directory is '.asset_wizard_cache' in the project root.
class CacheManager {
  /// The directory where cache files are stored.
  final String _cacheDir;

  /// In-memory cache of file hashes.
  final Map<String, String> _cache = {};

  /// Creates a new CacheManager instance.
  ///
  /// [cacheDir] specifies the directory where cache files will be stored.
  /// If not provided, defaults to '.asset_wizard_cache'.
  CacheManager({String? cacheDir})
      : _cacheDir = cacheDir ?? '.asset_wizard_cache';

  /// Gets the cached hash for a file if it exists.
  ///
  /// Returns the cached hash for [filePath] if it exists in the cache,
  /// otherwise returns null.
  String? getCachedHash(String filePath) {
    return _cache[filePath];
  }

  /// Caches the hash for a file.
  ///
  /// Stores the [hash] for [filePath] in the cache.
  /// The hash is used to determine if the file has been modified.
  void cacheHash(String filePath, String hash) {
    _cache[filePath] = hash;
  }

  /// Saves the cache to disk.
  ///
  /// Writes the current cache state to a JSON file in the cache directory.
  /// Creates the cache directory if it doesn't exist.
  Future<void> saveCache() async {
    final cacheFile = File(path.join(_cacheDir, 'cache.json'));
    await cacheFile.create(recursive: true);
    await cacheFile.writeAsString(_cache.toString());
  }

  /// Loads the cache from disk.
  ///
  /// Reads the cache state from the JSON file in the cache directory.
  /// If the cache file doesn't exist, no action is taken.
  Future<void> loadCache() async {
    final cacheFile = File(path.join(_cacheDir, 'cache.json'));
    if (await cacheFile.exists()) {
      final content = await cacheFile.readAsString();
      // TODO: Implement cache parsing logic
      print('Cache loaded: $content');
    }
  }

  /// Clears the cache.
  ///
  /// Removes all entries from the in-memory cache and deletes the cache directory
  /// from disk if it exists.
  Future<void> clearCache() async {
    _cache.clear();
    final cacheDir = Directory(_cacheDir);
    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
    }
  }
}
