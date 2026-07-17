///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

///This widget renders two tiles on a page
///The two tiles are rendered in a 2x1 grid
///The tiles look like this
/// ┌─────┐
/// │  0  │
/// ├─────┤
/// │  1  │
/// └─────┘
class TwoTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;

  const TwoTileLayout({
    super.key,
    required this.peerTracks,
    required this.startIndex,
  });

  @override
  Widget build(BuildContext context) {
    ///In portrait the two tiles are stacked vertically (2x1).
    ///In landscape they sit side by side (1x2) which uses the wide frame
    ///far better than a vertical stack.
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final children = <Widget>[
      Expanded(
        child: ListenablePeerWidget(
          index: startIndex,
          peerTracks: peerTracks,
        ),
      ),
      const SizedBox(width: 2, height: 2),
      Expanded(
        child: ListenablePeerWidget(
          index: startIndex + 1,
          peerTracks: peerTracks,
        ),
      ),
    ];

    return isLandscape
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children,
          );
  }
}
