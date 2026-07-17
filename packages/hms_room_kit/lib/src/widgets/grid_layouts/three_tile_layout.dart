///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

///This widget renders three tiles on a page
///The three tiles are rendered in a 3x1 grid
///The tiles look like this
/// ┌─────┐
/// │  0  │
/// ├─────┤
/// │  1  │
/// ├─────┤
/// │  2  │
/// └─────┘
class ThreeTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;
  const ThreeTileLayout({
    super.key,
    required this.peerTracks,
    required this.startIndex,
  });

  @override
  Widget build(BuildContext context) {
    ///In portrait the three tiles are stacked vertically (3x1).
    ///In landscape they sit side by side (1x3) to use the wide frame.
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
      const SizedBox(width: 2, height: 2),
      Expanded(
        child: ListenablePeerWidget(
          index: startIndex + 2,
          peerTracks: peerTracks,
        ),
      ),
    ];

    return isLandscape
        ? Row(children: children)
        : Column(children: children);
  }
}
