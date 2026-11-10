import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';

const String _appLabel = 'Customer App';

Future<void> showAccountDeletionRequest() async {
  await Get.dialog(
    AlertDialog(
      title: Text('Request account deletion'.tr),
      content: Text(
        'We will email you to verify your identity, then delete your account and personal data within 30 days. '
                'Some records may be kept where required by law, as described in our Privacy Policy. '
                'This cannot be undone.'
            .tr,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'.tr),
        ),
        TextButton(
          onPressed: () async {
            Get.back();
            try {
              await Get.find<LaravelApiClient>().contactSupport(
                  'ACCOUNT DELETION REQUEST ($_appLabel). Please verify this account holder and delete the account and personal data within 30 days.');
              Get.snackbar('Request sent'.tr,
                  'We received your request and will email you to verify it.'.tr,
                  backgroundColor: Colors.green, colorText: Colors.white, duration: Duration(seconds: 6));
            } catch (e) {
              Get.snackbar('Error'.tr,
                  'Could not send your request. Please email info@instantproviderapp.com with the subject Delete My Account.'.tr,
                  backgroundColor: Colors.red, colorText: Colors.white, duration: Duration(seconds: 8));
            }
          },
          child: Text('Request deletion'.tr, style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
