import 'dart:io';

/// Abstract contract for storage services.
abstract class StorageContract {
  /// Upload a file and return the download URL.
  Future<String> uploadFile(String path, File file);
  
  /// Delete a file by URL or path.
  Future<void> deleteFile(String fileUrl);
  
  /// Get download URL for a file path.
  Future<String> getDownloadUrl(String path);
}
