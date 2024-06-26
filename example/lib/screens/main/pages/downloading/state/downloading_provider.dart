import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

import '../../../../../shared/misc/circular_buffer.dart';

class DownloadingProvider extends ChangeNotifier {
  Stream<DownloadProgress>? _downloadProgress;
  Stream<DownloadProgress>? get downloadProgress => _downloadProgress;
  void setDownloadProgress(
    Stream<DownloadProgress>? newStream, {
    bool notify = true,
  }) {
    _downloadProgress = newStream;
    if (notify) notifyListeners();
  }

  int _parallelThreads = 5;
  int get parallelThreads => _parallelThreads;
  set parallelThreads(int newNum) {
    _parallelThreads = newNum;
    notifyListeners();
  }

  int _bufferingAmount = 100;
  int get bufferingAmount => _bufferingAmount;
  set bufferingAmount(int newNum) {
    _bufferingAmount = newNum;
    notifyListeners();
  }

  bool _skipExistingTiles = true;
  bool get skipExistingTiles => _skipExistingTiles;
  set skipExistingTiles(bool newBool) {
    _skipExistingTiles = newBool;
    notifyListeners();
  }

  bool _skipSeaTiles = true;
  bool get skipSeaTiles => _skipSeaTiles;
  set skipSeaTiles(bool newBool) {
    _skipSeaTiles = newBool;
    notifyListeners();
  }

  int? _rateLimit = 200;
  int? get rateLimit => _rateLimit;
  set rateLimit(int? newNum) {
    _rateLimit = newNum;
    notifyListeners();
  }

  bool _disableRecovery = false;
  bool get disableRecovery => _disableRecovery;
  set disableRecovery(bool newBool) {
    _disableRecovery = newBool;
    notifyListeners();
  }

  bool _showQuitTilesPreviewIndicator = false;
  bool get showQuitTilesPreviewIndicator => _showQuitTilesPreviewIndicator;
  set showQuitTilesPreviewIndicator(bool newBool) {
    _showQuitTilesPreviewIndicator = newBool;
    notifyListeners();
  }

  StreamSubscription<DownloadProgress>? _tilesPreviewStreamSub;
  StreamSubscription<DownloadProgress>? get tilesPreviewStreamSub =>
      _tilesPreviewStreamSub;
  set tilesPreviewStreamSub(
    StreamSubscription<DownloadProgress>? newStreamSub,
  ) {
    _tilesPreviewStreamSub = newStreamSub;
    notifyListeners();
  }

  final _tilesPreview = <TileCoordinates, Uint8List?>{};
  Map<TileCoordinates, Uint8List?> get tilesPreview => _tilesPreview;
  void addTilePreview(TileCoordinates coords, Uint8List? image) {
    _tilesPreview[coords] = image;
    notifyListeners();
  }

  void clearTilesPreview() {
    _tilesPreview.clear();
    notifyListeners();
  }

  final List<TileEvent> _failedTiles = [];
  List<TileEvent> get failedTiles => _failedTiles;
  void addFailedTile(TileEvent e) => _failedTiles.add(e);

  final CircularBuffer<TileEvent> _skippedTiles = CircularBuffer(50);
  CircularBuffer<TileEvent> get skippedTiles => _skippedTiles;
  void addSkippedTile(TileEvent e) => _skippedTiles.add(e);
}
