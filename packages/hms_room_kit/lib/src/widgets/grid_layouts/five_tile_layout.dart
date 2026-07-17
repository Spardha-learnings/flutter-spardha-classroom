///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/grid_layouts/listenable_peer_widget.dart';

///This widget renders five tiles on a page
///The five tiles are rendered in a 2x2 grid with fifth tile at the bottom center
///The tiles look like this
/// ╔═══════╦═══════╗
/// ║   0   ║   1   ║
/// ╠═══════╬═══════╣
/// ║   2   ║   3   ║
/// ╠═══════╬═══════╣
///     ║   4   ║
///     ╚═══════╝
class FiveTileLayout extends StatelessWidget {
  final int startIndex;
  final List<PeerTrackNode> peerTracks;
  const FiveTileLayout({
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

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    ///In landscape we lay the five tiles out as a row of three over a row of
    ///two, which fills the wide frame far better than the portrait
    ///2 + 2 + 1 vertical arrangement.
    if (isLandscape) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                _tile(startIndex),
                const SizedBox(width: 2),
                _tile(startIndex + 1),
                const SizedBox(width: 2),
                _tile(startIndex + 2),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 6),
              child: Row(
                children: [
                  _tile(startIndex + 3),
                  const SizedBox(width: 2),
                  _tile(startIndex + 4),
                ],
              ),
            ),
          ),
        ],
      );
    }

    ///Here we render two rows with two tiles in each row and last a center tile
    ///The first row contains the tiles with index [startIndex] and [startIndex+1]
    ///The second row contains the tiles with index [startIndex+2] and [startIndex+3]
    ///The third row contains the center tile with index [startIndex+4]
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              _tile(startIndex),
              const SizedBox(width: 2),
              _tile(startIndex + 1),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Expanded(
          child: Row(
            children: [
              _tile(startIndex + 2),
              const SizedBox(width: 2),
              _tile(startIndex + 3),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 4,
            ),
            child: ListenablePeerWidget(
              index: startIndex + 4,
              peerTracks: peerTracks,
            ),
          ),
        ),
      ],
    );
  }
}
