library;

///Dart imports
import 'dart:async';
import 'dart:developer';

///Package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///[WhiteboardWebView] is a widget that renders the whiteboard webview
class WhiteboardWebView extends StatefulWidget {
  ///When true we periodically zoom-to-fit the board so a viewer always sees all
  ///the content (including whatever the presenter writes at the bottom). This
  ///is kept off for the whiteboard owner so they retain control of the camera.
  final bool autoFit;
  const WhiteboardWebView({Key? key, this.autoFit = false}) : super(key: key);

  @override
  State<WhiteboardWebView> createState() => WhiteboardWebViewState();
}

class WhiteboardWebViewState extends State<WhiteboardWebView> {
  late WebViewController _controller;
  Timer? _autoFitTimer;

  ///Best-effort "zoom to fit" for the tldraw-based board: use the editor API if
  ///the board exposes it, otherwise fall back to the board's zoom-to-fit
  ///keyboard shortcut (Shift + 1).
  static const String _fitJs = '''
(function(){
  try {
    if (window.editor && typeof window.editor.zoomToFit === 'function') {
      window.editor.zoomToFit({ animation: { duration: 200 } });
      return;
    }
  } catch(e){}
  try {
    var mk = function(t){
      return new KeyboardEvent(t, {key:'1', code:'Digit1', keyCode:49, which:49, shiftKey:true, bubbles:true, cancelable:true});
    };
    document.dispatchEvent(mk('keydown'));
    document.dispatchEvent(mk('keyup'));
  } catch(e){}
})();
''';

  ///Fits the board camera to all content so nothing gets cropped.
  void fitToContent() {
    _controller.runJavaScript(_fitJs);
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (_) {
            return NavigationDecision.navigate;
          },
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            ///Fit once the board has loaded, then keep viewers following the
            ///content as the presenter keeps writing.
            if (widget.autoFit) {
              fitToContent();
              _startAutoFit();
            }
          },
          onWebResourceError: (WebResourceError error) {
            log("Error occured in whiteboard tile: ${error.description}");
          },
        ),
      );
  }

  void _startAutoFit() {
    _autoFitTimer?.cancel();
    _autoFitTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => fitToContent(),
    );
  }

  @override
  void dispose() {
    _autoFitTimer?.cancel();
    _controller.loadHtmlString("https://www.100ms.live/");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, String?>(
      selector: (_, meetingStore) => meetingStore.whiteboardModel?.url,
      builder: (_, url, __) {
        ///If the url is not null we render the webview
        return url != null
            ? WebViewWidget(
                controller: _controller..loadRequest(Uri.parse(url)),
              )
            : const SizedBox();
      },
    );
  }
}
