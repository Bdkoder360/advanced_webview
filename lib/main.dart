import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool Connection = false;
  bool getconnect = false;

  @override
  void initState() {
    super.initState();
    checkconnecttivity();
  }

  checkconnecttivity() async {
    bool result = await InternetConnectionChecker().hasConnection;
    setState(() {
      Connection = result;
      print(Connection);
      getconnect = true;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  late WebViewController controller;
  bool isLoading = true;

  // final StreamSubscription<InternetConnectionStatus> listener =
  //     InternetConnectionChecker().onStatusChange.listen(
  //   (InternetConnectionStatus status) {
  //     switch (status) {
  //       case InternetConnectionStatus.connected:
  //         // ignore: avoid_print

  //         print('Data connection is available.');
  //         break;
  //       case InternetConnectionStatus.disconnected:
  //         // ignore: avoid_print
  //         print('You are disconnected from the internet.');
  //         break;
  //     }
  //   },
  // );

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      // appBar: AppBar(
      //   title: Image.network('https://cdn-ehfci.nitrocdn.com/ebgOdRuKhSDnqvVaxEzZngCPMhIFpwmv/assets/static/optimized/rev-36a57a3/tamampk.com/wp-content/uploads/2021/12/98c10b45d74089c3761249c1d66f805f.imageedit_6_5430072013.png',height: 30,),
      //   leading: const Icon(Icons.menu),
      //   actions: [const Icon(Icons.shopping_cart_outlined)],
      // ),
      body: WillPopScope(
        onWillPop: () async {
          print(await controller.canGoBack() ? true : false);

          if (await controller.canGoBack()) {
            checkconnecttivity();
            controller.goBack();

            return Future.value(false);
          } else {
            return (await showDialog(
                  context: context,
                  builder: (context) => new AlertDialog(
                    title: new Text('Are you sure?'),
                    content: new Text('Do you want to exit an App'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: new Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: new Text('Yes'),
                      ),
                    ],
                  ),
                )) ??
                false;
          }
        },
        child: SafeArea(
          child: Connection
              ? Stack(
                  children: [
                    WebView(
                        javascriptMode: JavascriptMode.unrestricted,
                        initialUrl: Connection
                            ? 'https://niloyitinstitute.com/student/login'
                            : "https://niloyitinstitute.com/student/login",
                        onWebViewCreated:
                            (WebViewController webViewController) async {
                          this.controller = webViewController;

                          //   if (getconnect) {
                          //     if (Connection == false) {
                          //       Future<void> loadHtmlFromAssets(
                          //           String filename, controller) async {
                          //         String fileText =
                          //             await rootBundle.loadString(filename);
                          //         controller.loadUrl(Uri.dataFromString(fileText,
                          //                 mimeType: 'text/html',
                          //                 encoding: Encoding.getByName('utf-8'))
                          //             .toString());
                          //       }

                          //       await loadHtmlFromAssets(
                          //           'assets/data.html', controller);
                          //     } else {
                          //       controller.loadUrl('https://niloyitinstitute.com/student/login');
                          //     }
                          //   }
                        },
                        // onPageStarted: (url) {
                        //   Future.delayed(Duration(milliseconds: 700), () {
                        //     controller.runJavascript(
                        //         "document.getElementsByClassName('whb-main-header')[0].style.display='none'");
                        //   });
                        //   Future.delayed(Duration(milliseconds: 1000), () {
                        //     //  controller.runJavascript("document.getElementsByClassName('whb-main-header')[0].style.display='none'");
                        //     controller.runJavascript(
                        //         "document.getElementsByClassName('footer-sidebar')[0].style.display='none'");
                        //     controller.runJavascript(
                        //         "document.getElementsByTagName('container.main-footer')[0].style.display='none'");
                        //     // controller.runJavascript("document.body.scroll = 'no'");
                        //   });
                        // },
                        onPageStarted: (_url) {
                          if (_url.contains('zoom')) {
                            void _launchURL() async {
                              if (!await launch(_url))
                                print('Could not launch $_url');
                              controller.goBack();
                            }

                            _launchURL();
                          }
                        },
                        onProgress: (int) {
                          print('prgress$int');
                          var prgress = (int == 100) ? false : true;
                          if (prgress) {
                            setState(() {
                              isLoading = true;
                            });
                          }
                        },
                        onPageFinished: (finish) {
                          setState(() {
                            isLoading = false;
                          });
                        }),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.redAccent,
                            ),
                          )
                        : Stack(),
                  ],
                )
              : Center(
                  child: Image.asset('assets/no-internet-icon-6.jpg'),
                ),
        ),
      ),
    );
  }
}
