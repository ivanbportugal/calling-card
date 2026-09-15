import 'package:flutter/material.dart';

import '../auth/user.dart';
import 'app_theme.dart';

extension StatusColorPresentation on StatusColor {
  Color resolve(ColorScheme colorScheme) {
    switch (this) {
      case StatusColor.GREEN:
        return colorScheme.statusOpen;
      case StatusColor.YELLOW:
        return colorScheme.statusLimited;
      case StatusColor.RED:
        return colorScheme.statusClosed;
    }
  }

  String get shortLabel {
    switch (this) {
      case StatusColor.GREEN:
        return 'Friends can come';
      case StatusColor.YELLOW:
        return 'Only one can come';
      case StatusColor.RED:
        return 'No one can come';
    }
  }
}
