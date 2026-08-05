import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../shell/controllers/shell_controller.dart';
import '../controllers/contact_controller.dart';

/// Contact screen with form and social links.
class ContactView extends GetView<ContactController> {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    final shellController = Get.find<ShellController>();
    final isMobile = Responsive.isMobile(context);

    return PageScaffold(
      onScroll: shellController.updateScrollProgress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Get In Touch',
            subtitle: 'Have a project in mind? Let\'s discuss how I can help.',
          ),
          isMobile
              ? Column(
                  children: [
                    _ContactForm(),
                    32.verticalSpace,
                    _ContactInfo(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _ContactForm()),
                    32.horizontalSpace,
                    Expanded(child: _ContactInfo()),
                  ],
                ),
        ],
      ),
    );
  }
}

class _ContactForm extends GetView<ContactController> {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Send a Message', style: context.textTheme.headlineSmall),
            24.verticalSpace,
            TextFormField(
              controller: controller.nameController,
              validator: controller.validateName,
              decoration: _inputDecoration(context, 'Your Name', Icons.person_outline_rounded),
            ),
            16.verticalSpace,
            TextFormField(
              controller: controller.emailController,
              validator: controller.validateEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration(context, 'Your Email', Icons.email_outlined),
            ),
            16.verticalSpace,
            TextFormField(
              controller: controller.subjectController,
              validator: controller.validateSubject,
              decoration: _inputDecoration(context, 'Subject', Icons.subject_rounded),
            ),
            16.verticalSpace,
            TextFormField(
              controller: controller.messageController,
              validator: controller.validateMessage,
              maxLines: 5,
              decoration: _inputDecoration(context, 'Your Message', Icons.message_outlined),
            ),
            32.verticalSpace,
            Obx(
              () => GradientButton(
                label: AppStrings.sendMessage,
                icon: Icons.send_rounded,
                isLoading: controller.isSending.value,
                onPressed: controller.sendMessage,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: context.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: context.isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: context.isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}

class _ContactInfo extends GetView<ContactController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact Information', style: context.textTheme.headlineSmall),
              24.verticalSpace,
              _InfoTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: AppConstants.email,
                onTap: controller.openEmail,
                onCopy: controller.copyEmail,
              ),
              _InfoTile(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: AppConstants.phone,
                onCopy: controller.copyPhone,
              ),
              _InfoTile(
                icon: Icons.location_on_outlined,
                label: 'Location',
                value: AppConstants.developerLocation,
                onCopy: controller.copyLocation,
              ),
            ],
          ),
        ),
        24.verticalSpace,
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Connect With Me', style: context.textTheme.headlineSmall),
              24.verticalSpace,
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SocialButton(
                    icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 22, color: Color(0xFF25D366)),
                    label: 'WhatsApp',
                    color: const Color(0xFF25D366),
                    onTap: controller.openWhatsApp,
                  ),
                  SocialButton(
                    icon: const FaIcon(FontAwesomeIcons.linkedinIn, size: 22, color: Color(0xFF0A66C2)),
                    label: 'LinkedIn',
                    color: const Color(0xFF0A66C2),
                    onTap: controller.openLinkedIn,
                  ),
                  SocialButton(
                    icon: FaIcon(FontAwesomeIcons.github, size: 22, color: context.isDarkMode ? Colors.white : const Color(0xFF24292F)),
                    label: 'GitHub',
                    color: context.isDarkMode ? Colors.white : const Color(0xFF24292F),
                    onTap: controller.openGitHub,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.onCopy,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.textTheme.labelMedium),
                Text(value, style: context.textTheme.bodyMedium),
              ],
            ),
          ),
          if (onCopy != null)
            IconButton(
              onPressed: onCopy,
              icon: const Icon(Icons.copy_rounded, size: 18),
              tooltip: 'Copy',
            ),
        ],
      ),
    );
  }
}
