import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';

class ContactSupportWidget extends StatefulWidget {
  const ContactSupportWidget({Key? key}) : super(key: key);

  @override
  State<ContactSupportWidget> createState() => _ContactSupportWidgetState();
}

class _ContactSupportWidgetState extends State<ContactSupportWidget> {
  final _messageController = TextEditingController();
  bool _sending = false;
  bool _sent = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final msg = _messageController.text.trim();
    if (msg.isEmpty) return;
    setState(() => _sending = true);
    try {
      await Get.find<LaravelApiClient>().contactSupport(msg);
      setState(() { _sent = true; _sending = false; });
      _messageController.clear();
    } catch (e) {
      setState(() => _sending = false);
      Get.snackbar('Error', 'Could not send message. Please try again.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.08), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Chat with Support', style: Get.textTheme.titleMedium),
          SizedBox(height: 4),
          Text('Send us a message and we\'ll get back to you shortly.',
              style: Get.textTheme.bodySmall),
          SizedBox(height: 16),
          if (_sent)
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(children: [
                Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Your message was sent! We\'ll follow up with you soon.',
                    style: Get.textTheme.bodySmall?.copyWith(color: Colors.green.shade700))),
              ]),
            )
          else ...[
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe your issue or question...',
                hintStyle: Get.textTheme.bodySmall,
                filled: true,
                fillColor: Get.theme.scaffoldBackgroundColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Get.theme.focusColor.withOpacity(0.2))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Get.theme.focusColor.withOpacity(0.2))),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sending ? null : _send,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.secondary,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _sending
                    ? SizedBox(height: 18, width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Get.theme.primaryColor))
                    : Text('Send Message',
                        style: Get.textTheme.titleSmall?.copyWith(color: Get.theme.primaryColor)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
