///Package imports
library;

import 'package:flutter/widgets.dart';

///[HMSDeviceUtils] holds helpers for responsive / device form-factor
///decisions used across the room kit.
class HMSDeviceUtils {
  HMSDeviceUtils._();

  ///Returns true when the current device is a tablet (iPad or a large
  ///Android tablet).
  ///
  ///We use the shortest-side >= 600dp heuristic — the same breakpoint the
  ///Material guidelines use to separate tablets from phones. [shortestSide]
  ///is orientation invariant, so this value is stable across rotation.
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }
}
