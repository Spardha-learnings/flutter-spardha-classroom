library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/whiteboard_screenshare/whiteboard_screenshare_store.dart';
import 'package:hms_room_kit/src/widgets/whiteboard_screenshare/whiteboard_webview.dart';

///[WhiteboardTile] is a widget that renders the whiteboard tile
class WhiteboardTile extends StatefulWidget {
  const WhiteboardTile({Key? key}) : super(key: key);
  @override
  State<WhiteboardTile> createState() => _WhiteboardTileState();
}

class _WhiteboardTileState extends State<WhiteboardTile> {
  bool isFullScreen = false;

  ///Lets us call the webview's fit-to-content from the Fit button.
  final GlobalKey<WhiteboardWebViewState> _webViewKey =
      GlobalKey<WhiteboardWebViewState>();

  @override
  Widget build(BuildContext context) {
    ///The owner drives the board, so only non-owners (viewers) auto-follow the
    ///content; the owner keeps manual control of the camera.
    final bool isOwner =
        context.read<MeetingStore>().whiteboardModel?.isOwner ?? false;

    return Stack(
      children: [
        WhiteboardWebView(key: _webViewKey, autoFit: !isOwner),
        Positioned(
          top: 5,
          right: 5,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///Fit-to-content button: snaps the camera so the whole board
              ///(including the bottom) is visible.
              GestureDetector(
                onTap: () => _webViewKey.currentState?.fitToContent(),
                child: PointerInterceptor(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: HMSThemeColors.backgroundDim.withAlpha(64),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/fit_screen.svg",
                        height: 16,
                        width: 16,
                        semanticsLabel: "fit_whiteboard_label",
                        colorFilter: ColorFilter.mode(
                          HMSThemeColors.onSurfaceHighEmphasis,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              ///Maximize/minimize button: toggles the whiteboard full screen.
              GestureDetector(
                onTap: () {
                  context.read<WhiteboardScreenshareStore>().toggleFullScreen();
                },
                child: PointerInterceptor(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: HMSThemeColors.backgroundDim.withAlpha(64),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Selector<WhiteboardScreenshareStore, bool>(
                        selector: (_, whiteboardScreenshareStore) =>
                            whiteboardScreenshareStore.isFullScreen,
                        builder: (_, isFullScreen, __) {
                          return SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/${isFullScreen ? "minimize" : "maximize"}.svg",
                            height: 16,
                            width: 16,
                            semanticsLabel: "maximize_label",
                            colorFilter: ColorFilter.mode(
                              HMSThemeColors.onSurfaceHighEmphasis,
                              BlendMode.srcIn,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
