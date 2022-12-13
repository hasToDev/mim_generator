import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/core.dart';
import 'widget/share_to_button.dart';

class ShareToPage extends StatefulWidget {
  static const String id = 'shareToPage';

  const ShareToPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ShareToPage> createState() => _ShareToPageState();
}

class _ShareToPageState extends State<ShareToPage> {
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
          ShareToButton(
            text: 'Share to FB',
            onPressed: () async {
              await context.read<ApiDataProvider>().shareTo(
                    filePath: tempFile!.path,
                    message: 'Share to FB',
                  );
            },
          ),
          ShareToButton(
            text: 'Share to Twitter',
            onPressed: () async {
              await context.read<ApiDataProvider>().shareTo(
                    filePath: tempFile!.path,
                    message: 'Share to Twitter',
                  );
            },
          ),
          const SizedBox(height: 10.0),
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
}
