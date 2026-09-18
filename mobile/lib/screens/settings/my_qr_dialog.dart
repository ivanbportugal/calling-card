import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../friends/qr_email_codec.dart';

Future<void> showMyQrDialog(BuildContext context, String email) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('My QR code'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(data: encodeEmailQr(email), size: 220),
          const SizedBox(height: 16),
          Text(email, textAlign: TextAlign.center),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done'),
        ),
      ],
    ),
  );
}
