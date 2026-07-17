///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

///This widget renders six tiles on a page
///The six tiles are rendered in a 3x2 grid
///The tiles look like this
// ╔═══════╦═══════╗
// ║   0   ║   1   ║
// ╠═══════╬═══════╣
// ║   2   ║   3   ║
// ╠═══════╬═══════╣
// ║   4   ║   5   ║
// ╚═══════╩═══════╝
class SixTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;
  const SixTileLayout({
    super.key,
    required this.peerTracks,
    required this.startIndex,
  });

  ///Builds a single tile wrapped in an [Expanded].
  Widget _tile(int index) => Expanded(
        child: ListenablePeerWidget(
          index: index,
          peerTracks: peerTracks,
        ),
      );

  ///Builds a row of tiles from the given [indexes].
  Widget _row(List<int> indexes) => Expanded(
        child: Row(
          children: [
            for (int i = 0; i < indexes.length; i++) ...[
              if (i != 0) const SizedBox(width: 2),
              _tile(indexes[i]),
            ],
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    ///In landscape we render two rows of three (3x2). In portrait we keep the
    ///original three rows of two (2x3).
    return Column(
      children: isLandscape
          ? [
              _row([startIndex, startIndex + 1, startIndex + 2]),
              const SizedBox(height: 2),
              _row([startIndex + 3, startIndex + 4, startIndex + 5]),
            ]
          : [
              _row([startIndex, startIndex + 1]),
              const SizedBox(height: 2),
              _row([startIndex + 2, startIndex + 3]),
              const SizedBox(height: 2),
              _row([startIndex + 4, startIndex + 5]),
            ],
    );
  }
}
