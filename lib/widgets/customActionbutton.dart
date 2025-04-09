import 'package:flutter/material.dart';

enum CustomButtonType { cancel, save, edit }

class CustomActionButton extends StatelessWidget {
  final CustomButtonType type;
  final VoidCallback onPressed;
  final String label;
  final bool isDisabled;
  final IconData? customIcon;

  const CustomActionButton({
    super.key,
    required this.type,
    required this.onPressed,
    required this.label,
    this.isDisabled = false,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonProperties = _getButtonProperties(context);
    final borderRadius = BorderRadius.circular(12);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 120,
        maxWidth: 200,
        minHeight: 48,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonProperties.backgroundColor,
          foregroundColor: buttonProperties.foregroundColor,
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onPressed: isDisabled ? null : onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              customIcon ?? buttonProperties.icon,
              size: 20,
              color:
                  isDisabled ? Colors.grey : buttonProperties.foregroundColor,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:
                    isDisabled ? Colors.grey : buttonProperties.foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _ButtonProperties _getButtonProperties(BuildContext context) {
    switch (type) {
      case CustomButtonType.cancel:
        return _ButtonProperties(
          backgroundColor: Colors.red.shade100,
          foregroundColor: Colors.red.shade800,
          icon: Icons.close_rounded,
        );
      case CustomButtonType.save:
        return _ButtonProperties(
          backgroundColor: Colors.blue.shade100,
          foregroundColor: Colors.blue.shade800,
          icon: Icons.check_rounded,
        );
      case CustomButtonType.edit:
        return _ButtonProperties(
          backgroundColor: Colors.orange.shade100,
          foregroundColor: Colors.orange.shade800,
          icon: Icons.edit_rounded,
        );
    }
  }
}

class _ButtonProperties {
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;

  _ButtonProperties({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });
}

// Usage Example:
class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Buttons Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomActionButton(
              type: CustomButtonType.cancel,
              label: 'Cancel',
              onPressed: () => print('Cancel pressed'),
            ),
            const SizedBox(height: 20),
            CustomActionButton(
              type: CustomButtonType.save,
              label: 'Save Changes',
              onPressed: () => print('Save pressed'),
            ),
            const SizedBox(height: 20),
            CustomActionButton(
              type: CustomButtonType.edit,
              label: 'Edit Profile',
              onPressed: () => print('Edit pressed'),
            ),
            const SizedBox(height: 20),
            CustomActionButton(
              type: CustomButtonType.save,
              label: 'Disabled Button',
              onPressed: () {},
              isDisabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
