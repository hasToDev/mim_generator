import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../ui.dart';

class SaveSharePage extends StatefulWidget {
  static const String id = 'saveSharePage';

  const SaveSharePage({
    Key? key,
  }) : super(key: key);

  @override
  State<SaveSharePage> createState() => _SaveSharePageState();
}

class _SaveSharePageState extends State<SaveSharePage> {
  final GlobalKey _loadingKey = GlobalKey();
  late Map arguments;
  File? tempFile;

  @override
  void didChangeDependencies() {
    arguments = ModalRoute.of(context)!.settings.arguments as Map;
    tempFile = File(arguments['data']);
    setState(() {});

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 56.0,
        leading: IconButton(
          splashColor: Colors.white12,
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () async {
            await Future.delayed(const Duration(milliseconds: 125));
            if (mounted) Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          'Mim Generator',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: Column(
        key: _loadingKey,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(6.0),
              child: tempFile == null
                  ? buildLoading()
                  : Image.file(
                      tempFile!,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                    ),
            ),
          ),
          Container(
            height: 64.0,
            padding: const EdgeInsets.all(6.0),
            margin: const EdgeInsets.only(
              bottom: 6.0,
              left: 6.0,
              right: 6.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text(
                      'Simpan',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    onPressed: () async {
                      await GallerySaver.saveImage(tempFile!.path).then((value) async {
                        callSnackBar(text: 'File sukses di simpan!', color: Colors.green);
                      }).catchError((e, stacktrace) async {
                        callSnackBar(text: 'File gagal tersimpan!', color: Colors.red);
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text(
                      'Share',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        ShareToPage.id,
                        arguments: {'data': tempFile!.path},
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildLoading() {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        RenderBox? renderBox = _loadingKey.currentContext!.findRenderObject() as RenderBox;
        return LimitedBox(
          maxHeight: renderBox.constraints.maxHeight,
          maxWidth: double.infinity,
          child: const Center(
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: CircularProgressIndicator(strokeWidth: 3.0),
            ),
          ),
        );
      },
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> callSnackBar({
    required String text,
    required Color color,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      duration: const Duration(milliseconds: 1500),
      content: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
      ),
    ));
  }
}
