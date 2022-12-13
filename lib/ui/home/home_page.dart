import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/core.dart';
import '../ui.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homePage';

  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool initApp = true;
  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Mim Generator',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await context.read<ApiDataProvider>().fetchServerData();
          setState(() {});
        },
        child: FutureBuilder(
          key: _globalKey,
          future: context.read<ApiDataProvider>().memeData(initApp),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return buildLoading();

            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                initApp = false;
                return buildData(snapshot);
              } else {
                return buildNoAvailableData();
              }
            }

            return buildLoading();
          },
        ),
      ),
    );
  }

  Widget buildData(AsyncSnapshot<List<MemePicture>> snapshot) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.all(4.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              EditPage.id,
              arguments: {'data': snapshot.data![index]},
            );
          },
          child: MimCard(data: snapshot.data![index]),
        );
      },
    );
  }

  Widget buildLoading() {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        RenderBox? renderBox = _globalKey.currentContext!.findRenderObject() as RenderBox;
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

  Widget buildNoAvailableData({String? text}) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        RenderBox? renderBox = _globalKey.currentContext!.findRenderObject() as RenderBox;
        return LimitedBox(
          maxHeight: renderBox.constraints.maxHeight,
          maxWidth: double.infinity,
          child: Center(
            child: Text(
              text ?? 'No Data',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
          ),
        );
      },
    );
  }
}

class MimCard extends StatelessWidget {
  const MimCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  final MemePicture data;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: data.url,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
      placeholder: (context, url) {
        return SizedBox(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[50]!,
            period: const Duration(milliseconds: 1200),
            child: Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: const BorderSide(
                  color: Colors.transparent,
                  width: 0.0,
                ),
              ),
              child: const SizedBox(),
            ),
          ),
        );
      },
    );
  }
}
