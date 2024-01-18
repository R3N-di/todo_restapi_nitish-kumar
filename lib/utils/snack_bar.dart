import 'package:flutter/material.dart';
import '../components/colors.dart';

void showErrorMessage(
  BuildContext context, {
  required String messages,
}) {
  final snackBar = SnackBar(
    content: Text(
      messages,
      style: TextStyle(color: appText),
    ),
    backgroundColor: appPrimary,
  );
}

// TAMPILKAN PESAN BERHASIL ATAU GAGAL KE USER BERDASARKAN DARI STATUS
void showSuccessMessage(
  BuildContext context, {
  required String messages,
}) {
  final snackBar = SnackBar(content: Text(messages));

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
