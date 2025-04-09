import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'model.dart';

class AttachmentHandler {
  final imagePicker = ImagePicker();

  Future<bool> _handlePermissionRequest(
      Permission permission, BuildContext context) async {
    final status = await permission.request();

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        final bool openSettings = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Permission Required'),
                content: const Text(
                    'This feature requires permission. Please enable it in settings.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Open Settings'),
                  ),
                ],
              ),
            ) ??
            false;

        if (openSettings) {
          await openAppSettings();
        }
      }
      return false;
    }
    return status.isGranted;
  }

  // Pick gallery image
  Future<File?> pickGalleryImage(BuildContext context) async {
    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image == null) return null;

      final File file = File(image.path);
      if (!await file.exists()) {
        throw 'Selected image file does not exist';
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image selected successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      return file;
    } catch (e) {
      print('Error picking image: $e');
      if (context.mounted) {
        _showErrorDialog(context, 'Failed to pick image: ${e.toString()}');
      }
      return null;
    }
  }

  // Pick camera image
  Future<File?> pickCameraImage(BuildContext context) async {
    try {
      final hasPermission =
          await _handlePermissionRequest(Permission.camera, context);
      if (!hasPermission) return null;

      final XFile? photo = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (photo == null) return null;

      final File file = File(photo.path);
      if (!await file.exists()) {
        throw 'Captured image file does not exist';
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo captured successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      return file;
    } catch (e) {
      print('Error capturing photo: $e');
      if (context.mounted) {
        _showErrorDialog(context, 'Failed to capture photo: ${e.toString()}');
      }
      return null;
    }
  }

  // Pick document
  Future<File?> pickDocument(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'xls', 'xlsx'],
        allowMultiple: false,
        withData: true,
      );

      if (result == null) return null;

      final file = result.files.first;
      if (file.path == null) {
        throw 'Invalid file path';
      }

      final selectedFile = File(file.path!);
      if (!await selectedFile.exists()) {
        throw 'Selected file does not exist';
      }

      // Validate file size (e.g., 10MB limit)
      if (await selectedFile.length() > 10 * 1024 * 1024) {
        throw 'File size exceeds 10MB limit';
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Document selected: ${file.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }

      return selectedFile;
    } catch (e) {
      print('Error picking document: $e');
      if (context.mounted) {
        _showErrorDialog(context, 'Failed to pick document: ${e.toString()}');
      }
      return null;
    }
  }

  // Pick contact (keep your existing implementation)
  Future<Contact?> pickContact() async {
    try {
      if (!await FlutterContacts.requestPermission()) {
        throw Exception('Contacts permission denied');
      }

      final contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        final fullContact = await FlutterContacts.getContact(contact.id);
        return fullContact;
      }
    } catch (e) {
      debugPrint('Error picking contact: $e');
    }
    return null;
  }

  // Pick location (keep your existing implementation)
  Future<Map<String, dynamic>?> pickLocation(BuildContext context) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks[0];
        final address =
            '${placemark.street}, ${placemark.locality}, ${placemark.country}'
                .replaceAll('null,', '')
                .replaceAll(', ,', ',')
                .trim();
        print(address);
        return {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'address': address,
        };
      }
    } catch (e) {
      debugPrint('Error picking location: $e');
      if (context.mounted) {
        _showErrorDialog(context, 'Failed to get location');
      }
    }
    return null;
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class AttachmentOptions extends StatelessWidget {
  final AttachmentHandler attachmentHandler;
  final Function(ChatMessage) onMessageCreated;
  final String currentUserId;
  final String receiverId;

  const AttachmentOptions({
    Key? key,
    required this.attachmentHandler,
    required this.onMessageCreated,
    required this.currentUserId,
    required this.receiverId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOption(
                context: context,
                icon: Icons.image,
                label: 'Gallery',
                color: Colors.purple,
                onTap: () => _handleGalleryPick(context),
              ),
              _buildOption(
                context: context,
                icon: Icons.camera_alt,
                label: 'Camera',
                color: Colors.red,
                onTap: () => _handleCameraPick(context),
              ),
              _buildOption(
                context: context,
                icon: Icons.insert_drive_file,
                label: 'Document',
                color: Colors.blue,
                onTap: () => _handleDocumentPick(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOption(
                context: context,
                icon: Icons.location_on,
                label: 'Location',
                color: Colors.green,
                onTap: () => _handleLocationPick(context),
              ),
              _buildOption(
                context: context,
                icon: Icons.person,
                label: 'Contact',
                color: Colors.orange,
                onTap: () => _handleContactPick(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 25),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  // Updated handler methods
  Future<void> _handleGalleryPick(BuildContext context) async {
    try {
      Navigator.pop(context);
      final file = await attachmentHandler.pickGalleryImage(context);
      if (file != null) {
        _createMediaMessage(file.path, MessageType.image, 'Image');
      }
    } catch (e) {
      debugPrint('Error picking from gallery: $e');
    }
  }

  Future<void> _handleCameraPick(BuildContext context) async {
    try {
      Navigator.pop(context);
      final file = await attachmentHandler.pickCameraImage(context);
      if (file != null) {
        _createMediaMessage(file.path, MessageType.image, 'Photo');
      }
    } catch (e) {
      debugPrint('Error picking from camera: $e');
    }
  }

  Future<void> _handleDocumentPick(BuildContext context) async {
    try {
      Navigator.pop(context);
      final file = await attachmentHandler.pickDocument(context);
      if (file != null) {
        _createMediaMessage(file.path, MessageType.file, 'Document');
      }
    } catch (e) {
      debugPrint('Error picking document: $e');
    }
  }

  Future<void> _handleLocationPick(BuildContext context) async {
    try {
      Navigator.pop(context);
      final locationData = await attachmentHandler.pickLocation(context);
      if (locationData != null) {
        final message = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: currentUserId,
          receiverId: receiverId,
          message: 'Location: ${locationData['address']}',
          timestamp: DateTime.now(),
          type: MessageType.location,
          metadata: locationData,
        );
        onMessageCreated(message);
      }
    } catch (e) {
      debugPrint('Error picking location: $e');
    }
  }

  Future<void> _handleContactPick(BuildContext context) async {
    try {
      Navigator.pop(context);
      final contact = await attachmentHandler.pickContact();
      if (contact != null) {
        final message = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: currentUserId,
          receiverId: receiverId,
          message: 'Contact: ${contact.displayName}',
          timestamp: DateTime.now(),
          type: MessageType.contact,
          metadata: {
            'name': contact.displayName,
            'phones': contact.phones.map((p) => p.number).toList(),
          },
        );
        onMessageCreated(message);
      }
    } catch (e) {
      debugPrint('Error picking contact: $e');
    }
  }

  void _createMediaMessage(String path, MessageType type, String messageText) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUserId,
      receiverId: receiverId,
      message: messageText,
      timestamp: DateTime.now(),
      type: type,
      mediaUrl: path,
    );
    onMessageCreated(message);
  }
}
