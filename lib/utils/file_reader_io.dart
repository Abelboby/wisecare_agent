// ignore_for_file: undefined_function
import 'dart:io';

/// Reads file at [path] into bytes. Used when file_picker returns path but not bytes (e.g. Android).
/// This file is a conditional import target — never imported directly.
Future<List<int>?> readFileBytes(String path) async {
  try {
    final file = File(path);
    if (await file.exists()) {
      return await file.readAsBytes();
    }
  } catch (_) {}
  return null;
}
