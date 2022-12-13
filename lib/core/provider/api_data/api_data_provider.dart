import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core.dart';

class ApiDataProvider extends ChangeNotifier {
  final ImagePicker picker;
  final FetchMemeData fetchMemeData;

  ApiDataProvider({
    required this.picker,
    required this.fetchMemeData,
  }) : super();

  List<MemePicture> memeList = [];

  // Fetch Server Data
  Future<void> fetchServerData() async {
    final failureOrData = await fetchMemeData(NoParams());

    await failureOrData.fold(
      (failure) {
        if (kDebugMode) print(failure.message);
      },
      (data) async {
        memeList = data;
      },
    );
  }

  // Get Local Data
  Future<List<MemePicture>> memeData(bool initApp) async {
    if (initApp) await fetchServerData();
    return memeList;
  }

  // Get Gallery Image
  Future<File?> getGalleryImage() async {
    File? results;
    XFile? rawImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (rawImage != null) {
      final File tempFile = File(rawImage.path);
      results = tempFile;
    }

    return results;
  }

  // Caching Temporary Frame
  Future<String> cacheTempFrame(GlobalKey globalKey) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    DateTime now = DateTime.now();
    String uniqueId = now.toIso8601String();
    uniqueId = uniqueId.replaceAll(RegExp(r'[-:.]'), '');

    final directory = await getTemporaryDirectory();
    File tempFile = File('${directory.path}/temp-$uniqueId.png')
      ..createSync(recursive: true)
      ..writeAsBytesSync(pngBytes);

    return tempFile.path;
  }

  // Share Files To
  Future<void> shareTo({required String filePath, required String message}) async {
    String fileName = filePath.split('/').last;
    if (fileName.contains('temp-')) fileName = fileName.replaceFirst('temp-', '');

    await Share.shareXFiles([XFile(filePath)], subject: fileName, text: message)
        .catchError((e) async {
      if (kDebugMode) print(e);
    });
  }
}
