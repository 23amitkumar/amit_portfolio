import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';


import '../../../core/constants/app_constants.dart';
import '../../../core/utils/clipboard_helper.dart';

/// Contact form view model controller.
class ContactController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  final isSending = false.obs;
  final isSent = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(value.trim())) return 'Enter a valid email';
    return null;
  }

  String? validateSubject(String? value) {
    if (value == null || value.trim().isEmpty) return 'Subject is required';
    return null;
  }

  String? validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) return 'Message is required';
    if (value.trim().length < 10) return 'Message must be at least 10 characters';
    return null;
  }

  Future<void> sendMessage() async {
    if (!formKey.currentState!.validate()) return;

    isSending.value = true;
    
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://formspree.io/f/mrpzglob',
        data: {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'subject': subjectController.text.trim(),
          'message': messageController.text.trim(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isSent.value = true;
        Get.snackbar(
          'Message Sent!',
          'Thank you for reaching out. I will get back to you within 24 hours.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          backgroundColor: const Color(0xFF22C55E),
          colorText: Colors.white,
        );

        nameController.clear();
        emailController.clear();
        subjectController.clear();
        messageController.clear();
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not send message. Please try again later or email me directly.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isSending.value = false;
    }
  }

  Future<void> openWhatsApp() async {
    final url = Uri.parse('https://wa.me/${AppConstants.whatsapp}');
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> openLinkedIn() async {
    final url = Uri.parse(AppConstants.linkedIn);
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> openGitHub() async {
    final url = Uri.parse(AppConstants.github);
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> openEmail() async {
    final url = Uri.parse('mailto:${AppConstants.email}');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  void copyEmail() => ClipboardHelper.copy(AppConstants.email, message: 'Email copied!');
  void copyPhone() => ClipboardHelper.copy(AppConstants.phone, message: 'Phone copied!');
  void copyLocation() => ClipboardHelper.copy(AppConstants.developerLocation, message: 'Location copied!');
}
