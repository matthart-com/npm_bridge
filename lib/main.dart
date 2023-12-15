import 'dart:async';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Proskomma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Hello Proskomma'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _textEditingController;
  String _response = "";
  HeadlessInAppWebView? headlessWebView;
  String url = "";
  String results = "";
  String query = """{
  id
  processor
  documents {
    id
    book: header(id: "bookCode")
    title: header(id: "toc")
    mainBlocksText
  }
}""";
  String data = """
\id PSA unfoldingWord® Simplified Text (truncated by Mark)
\ide UTF-8
\toc1 The Book of Psalms
\mt1 Psalms
\c 150
\q1
\v 1 Praise Yahweh!
\q1 Praise God in his temple!
\q2 Praise him who is in his fortress in heaven!
\q1
\v 2 Praise him for the mighty deeds that he has performed;
\q2 praise him because he is very great!
\q1
\v 3 Praise him by blowing trumpets loudly;
\q2 praise him by playing harps and small stringed instruments!
\q1
\v 4 Praise him by beating drums and by dancing.
\q2 Praise him by playing stringed instruments and by playing flutes!
\q1
\v 5 Praise him by clashing cymbals;
\q2 praise him by clashing very loud cymbals!
\q1
\v 6 I want all living creatures to praise Yahweh!
\q1 Praise Yahweh!
""";

  @override
  void initState() {
    _textEditingController = new TextEditingController(text: data);
    super.initState();

    headlessWebView = HeadlessInAppWebView(
      initialFile: "bridge/dist/index.html",
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
        allowUniversalAccessFromFileURLs: true,
        javaScriptCanOpenWindowsAutomatically: true,
        javaScriptEnabled: true,
        transparentBackground: true,
        horizontalScrollBarEnabled: false,
        verticalScrollBarEnabled: false,
      )),
      onWebViewCreated: (controller) {
        print("onWebViewCreated");
      },
      onConsoleMessage: (controller, consoleMessage) {
        print(consoleMessage.message);
      },
      onLoadStart: (controller, url) async {
        print("onLoadStart");
        setState(() {
          this.url = url?.toString() ?? '';
        });
      },
      onLoadStop: (controller, url) async {
        print("onLoadStop");
        setState(() {
          this.url = url?.toString() ?? '';
        });
      },
    );
    headlessWebView?.run();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: 15,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                style: TextStyle(
                  fontSize: 12.0,
                ),
              )
              //Text("URL: ${url}"),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    print("usfm onPressed");
                    var result = await headlessWebView?.webViewController
                        .callAsyncJavaScript(
                            functionBody: "return window.test(query, data);",
                            arguments: {'query': query, 'data': _textEditingController.text});
                    print(result?.value.runtimeType); // int
                    print(result?.error.runtimeType); // Null
                    print(result);
                    setState(() {
                      results = result?.value;
                    });
                  },
                  child: const Text("USFM")),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      results = "";
                    });
                  },
                  child: const Text("Clear")),
            ),
            new SingleChildScrollView(
              child: new Text(
                results,
                style: new TextStyle(
                  fontSize: 10.0,
                  color: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '$_response',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
