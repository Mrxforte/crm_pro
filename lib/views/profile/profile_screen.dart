import 'package:crm_pro/common/app_colors.dart';
import 'package:crm_pro/common/app_constants.dart';
import 'package:crm_pro/viewmodels/auth_viewmodel.dart';
import 'package:crm_pro/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Profile'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
              SizedBox(height: AppDimensions.paddingLarge),

              // User Info Section
              _buildInfoSection(),
              SizedBox(height: AppDimensions.paddingLarge),

              // Profile Menu Items
              _buildMenuSection(),
              SizedBox(height: AppDimensions.paddingLarge),

              // Logout Button
              PrimaryButton(
                label: 'Logout',
                onPressed: () {
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'User Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppDimensions.paddingMedium),
            _buildInfoRow('Email', 'user@example.com'),
            SizedBox(height: AppDimensions.paddingSmall),
            _buildInfoRow('Phone', '+1 (555) 000-0000'),
            SizedBox(height: AppDimensions.paddingSmall),
            _buildInfoRow('Member Since', 'March 5, 2026'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuTile('Edit Profile', Icons.edit, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit profile feature coming soon')),
          );
        }),
        _buildMenuTile('Settings', Icons.settings, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings feature coming soon')),
          );
        }),
        _buildMenuTile('Help & Support', Icons.help, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Help feature coming soon')),
          );
        }),
        _buildMenuTile('Privacy Policy', Icons.privacy_tip, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Privacy policy feature coming soon')),
          );
        }),
      ],
    );
  }

  Widget _buildMenuTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final authViewModel = context.read<AuthViewModel>();
                await authViewModel.logout();
                if (context.mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
