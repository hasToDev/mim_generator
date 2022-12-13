import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui.dart';
import '../../core/core.dart';
export 'widget/widget.dart';

class EditPage extends StatefulWidget {
  static const String id = 'editPage';

  const EditPage({
    Key? key,
  }) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey _loadingKey = GlobalKey();
  final GlobalKey _frameKey = GlobalKey();
  late Map arguments;
  bool waitForCache = false;

  MemePicture? meme;
  File? logoFile;
  Widget? textWidget;

  @override
  void didChangeDependencies() {
    arguments = ModalRoute.of(context)!.settings.arguments as Map;
    meme = arguments['data'];
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
              child: meme == null ? buildLoading() : buildImageStack(),
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
                EditButton(
                  title: 'Add Logo',
                  icon: Icons.image_outlined,
                  onPressed: () async {
                    logoFile = await context.read<ApiDataProvider>().getGalleryImage();
                    setState(() {});
                  },
                ),
                const SizedBox(width: 10.0),
                EditButton(
                  title: 'Add Text',
                  icon: Icons.text_fields,
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        String textEntered = '';
                        return AlertDialog(
                          contentPadding: const EdgeInsets.all(8.0),
                          content: DialogEnterText(
                            onChanged: (value) {
                              textEntered = value;
                            },
                            onCancel: () => Navigator.pop(context),
                            onConfirm: () => Navigator.pop(context, textEntered),
                          ),
                        );
                      },
                    ).then((v) {
                      if (v != null && v != '') {
                        textWidget = Container(
                            padding: const EdgeInsets.all(10.0),
                            color: Colors.transparent,
                            child: Text(v,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )));
                        setState(() {});
                      }
                    });
                  },
                ),
                const Expanded(child: SizedBox()),
                EditButton(
                  title: 'Next',
                  icon: Icons.navigate_next,
                  isLoading: waitForCache,
                  onPressed: () async {
                    waitForCache = true;
                    setState(() {});

                    String filePath =
                        await context.read<ApiDataProvider>().cacheTempFrame(_globalKey);

                    waitForCache = false;
                    setState(() {});

                    if (mounted) {
                      Navigator.pushNamed(
                        context,
                        SaveSharePage.id,
                        arguments: {'data': filePath},
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildImageStack() {
    return RepaintBoundary(
      key: _globalKey,
      child: ClipRRect(
        child: Stack(
          alignment: Alignment.center,
          children: [
            MimCard(
              key: _frameKey,
              data: meme!,
            ),
            if (logoFile != null) LogoOverlay(logoFile: logoFile!),
            if (textWidget != null) TextOverlay(textWidget: textWidget!),
          ],
        ),
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
}
