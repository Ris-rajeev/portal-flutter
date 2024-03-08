import 'dart:io';

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:authsec_flutter/utilities/display_error_alert.dart';

class HadWinMarkdownViewer extends StatefulWidget {
  final String screenName;
  final String urlRequested;

  const HadWinMarkdownViewer({
    Key? key,
    required this.screenName,
    required this.urlRequested,
  }) : super(key: key);

  @override
  HadWinMarkdownViewerState createState() => HadWinMarkdownViewerState();
}

class HadWinMarkdownViewerState extends State<HadWinMarkdownViewer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.screenName,
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xff243656),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width - 20,
              padding: EdgeInsets.only(
                left: 16.18,
                right: 16.18,
                bottom: 16.18,
                top: 6.18,
              ),
              child: FutureBuilder<String>(
                future: getTextData(widget.urlRequested),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print('testing');

                    // return MarkdownWidgetBuilder(
                    // markdownData: snapshot.data!,
                    // styleConfig: MarkdownWidgetConfig(
                    //   markdownTheme: MarkdownTheme(
                    //     blockquoteDecoration: BoxDecoration(
                    //       color: Color(0xffcaf0f8),
                    //     ),
                    //     blockquoteTextStyle: TextStyle(
                    //       color: Color(0xff0077b6),
                    //     ),
                    //     tableConfig: TableConfig(
                    //       headerStyle: TextStyle(
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //       bodyTextConfig: TextConfig(
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //     titleConfig: TitleConfig(
                    //       commonStyle: GoogleFonts.ubuntu(),
                    //       showDivider: false,
                    //     ),
                    //     ulConfig: UlConfig(
                    //       textStyle: GoogleFonts.workSans(),
                    //       dotWidget: (deep, index) => Text(
                    //         "${index + 1}.\t",
                    //         style: GoogleFonts.ubuntu(),
                    //       ),
                    //     ),
                    //     olConfig: OlConfig(
                    //       textStyle: GoogleFonts.workSans(),
                    //       indexWidget: (deep, index) => Text(
                    //         "${index + 1}.\t",
                    //         style: GoogleFonts.ubuntu(),
                    //       ),
                    //     ),
                    //     pConfig: PConfig(
                    //       textStyle: GoogleFonts.workSans(),
                    //       onLinkTap: (url) {
                    //         launchExternalURL(url!).then(
                    //           (value) =>
                    //               debugPrint("requested to access $url"),
                    //         );
                    //       },
                    //       emStyle: const TextStyle(
                    //         fontWeight: FontWeight.w600,
                    //         backgroundColor: Color(0xffccff33),
                    //         fontStyle: FontStyle.italic,
                    //       ),
                    //     ),
                    //     codeConfig: CodeConfig(
                    //       codeStyle: GoogleFonts.spaceMono(
                    //         backgroundColor: Color(0xff4a4e69),
                    //         fontWeight: FontWeight.w600,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // builder: (context, content) {
                    //   return content;
                    // },
                    // );
                  }
                  return docsLoading();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getTextData(String url) async {
    var response;
    try {
      response = await http.get(Uri.parse(url));
    } on SocketException {
      showErrorAlert(
        context,
        {'internetConnectionError': 'no internet connection'},
      );
    } catch (e) {
      showErrorAlert(context, {'error': "something went wrong"});
    }
    return response.body;
  }

  Widget docsLoading() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: FadeShimmer(
                height: 27,
                width: 100,
                radius: 7.2,
                highlightColor: Color(0xffced4da),
                baseColor: Color(0xffe9ecef),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1.618),
            ),
            ...List.generate(
              4,
              (i) => Container(
                child: FadeShimmer(
                  height: 21,
                  width: MediaQuery.of(context).size.width - 24,
                  radius: 7.2,
                  highlightColor: Color(0xffced4da),
                  baseColor: Color(0xffe9ecef),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1.618),
              ),
            ).toList(),
          ],
        );
      },
      separatorBuilder: (_, b) => SizedBox(
        height: 10,
      ),
      itemCount: 5,
    );
  }
}
