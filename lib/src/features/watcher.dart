import 'dart:async';
import 'dart:io';
import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as path;

class AssetWatcher {
  final String projectPath;
  final Function(String) onAssetChanged;

  AssetWatcher({required this.projectPath, required this.onAssetChanged});

  StreamSubscription? _subscription;

  void start() {
    final assetsDir = path.join(projectPath, 'assets');
    if (!Directory(assetsDir).existsSync()) {
      print('Assets directory not found at $assetsDir');
      return;
    }

    final watcher = DirectoryWatcher(assetsDir);
    _subscription = watcher.events.listen((event) {
      if (event.type == ChangeType.ADD || event.type == ChangeType.MODIFY) {
        onAssetChanged(event.path);
      }
    });
    
    print('Watching for asset changes in $assetsDir...');
  }

  void stop() {
    _subscription?.cancel();
  }
}
