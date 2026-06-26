import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shopowner_mobile_app/core/app_assets.dart';
import 'package:shopowner_mobile_app/core/app_const.dart';
import 'package:shopowner_mobile_app/core/extensions/context_extension.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/utils/app_funcs.dart';
import 'package:shopowner_mobile_app/core/utils/font_family.dart';
import 'package:shopowner_mobile_app/core/widgets/app_text.dart';
import 'package:shopowner_mobile_app/core/widgets/custom_image_view.dart';
import 'package:shopowner_mobile_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:shopowner_mobile_app/presentation/auth/state/auth_state.dart';
import 'package:shopowner_mobile_app/presentation/dashboard/cubit/dashboard_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authS) {
        final auth = authS.authModel;
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.ASSETS_IMAGES_APP_BG_JPG),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildProfileHeader(auth),
                const Gap(24),
                _buildShopInfoCard(context),
                const Gap(20),
                _buildSectionTitle('Account Settings'),
                const Gap(10),
                _buildMenuTile(
                  icon: Icons.person_outline,
                  label: 'Edit Profile',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.storefront_outlined,
                  label: 'Shop Details',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.photo_library_outlined,
                  label: 'Shop Images',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.location_on_outlined,
                  label: 'Shop Location',
                  onTap: () {},
                ),
                const Gap(20),
                _buildSectionTitle('Preferences'),
                const Gap(10),
                _buildMenuTile(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.lock_outline,
                  label: 'Change Password',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.language_outlined,
                  label: 'Language',
                  trailing: const AppText(
                    text: 'English',
                    fontSize: 12,
                    fontClr: AppColors.grey700,
                  ),
                  onTap: () {},
                ),
                const Gap(20),
                _buildSectionTitle('Support'),
                const Gap(10),
                _buildMenuTile(
                  icon: Icons.help_outline,
                  label: 'Help & FAQ',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.chat_bubble_outline,
                  label: 'Contact Support',
                  onTap: () {},
                ),
                _buildMenuTile(
                  icon: Icons.info_outline,
                  label: 'About $appName',
                  onTap: () {},
                ),
                const Gap(20),
                _buildLogoutButton(context),
                const Gap(40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(dynamic auth) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Material(
              elevation: 12,
              shadowColor: AppColors.primaryClr,
              borderRadius: BorderRadius.circular(60),
              child: CustomImageView(
                imagePath: auth?.shopLogo ?? AppAssets.ASSETS_IMAGES_APP_LOGO_PNG,
                height: 90,
                width: 90,
                radius: BorderRadius.circular(60),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.primaryClr,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: AppColors.secClr,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
        const Gap(12),
        AppText(
          text: auth?.shopName ?? appName,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          fontClr: AppColors.primaryClr,
        ),
        const Gap(4),
        AppText(
          text: auth?.email ?? 'shopowner@example.com',
          fontSize: 13,
          fontClr: AppColors.grey700,
          fontFamily: FontFamily.philosopher,
        ),
        if (auth?.market != null) ...[
          const Gap(4),
          AppText(
            text: '${auth.market} • ${auth.subMarket ?? ''}',
            fontSize: 12,
            fontClr: AppColors.primaryClr,
            fontStyle: FontStyle.italic,
            fontFamily: FontFamily.philosopher,
          ),
        ],
      ],
    );
  }

  Widget _buildShopInfoCard(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final data = state.data;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryClr,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildShopStat(
                  '${data?.products ?? 0}',
                  'Products',
                  Icons.inventory_2_outlined,
                ),
              ),
              Container(
                  width: 1, height: 50, color: AppColors.secClr.withOpacity(.3)),
              Expanded(
                child: _buildShopStat(
                  '${data?.orders ?? 0}',
                  'Orders',
                  Icons.shopping_bag_outlined,
                ),
              ),
              Container(
                  width: 1, height: 50, color: AppColors.secClr.withOpacity(.3)),
              Expanded(
                child: _buildShopStat(
                  '${data?.customers ?? 0}',
                  'Customers',
                  Icons.people_outline,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShopStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secClr, size: 20),
        const Gap(4),
        AppText(
          text: value,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          fontClr: Colors.white,
        ),
        AppText(
          text: label,
          fontSize: 11,
          fontClr: AppColors.secClr,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return AppText(
      text: title,
      fontSize: 14,
      fontWeight: FontWeight.w800,
      fontClr: AppColors.primaryClr.withOpacity(.6),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.85),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryClr, size: 22),
            const Gap(14),
            Expanded(
              child: AppText(
                text: label,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontClr: AppColors.primaryClr,
              ),
            ),
            trailing ??
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.primaryClr,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showAlertDialog(
          context,
          title: 'Log out?',
          content: 'Are you sure you want to log out of your shop?',
          confirmText: 'Log Out',
          changeR: true,
          onConfirm: () => context.read<AuthCubit>().logout(context),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.red.withOpacity(.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.red.withOpacity(.3)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: AppColors.red, size: 20),
            Gap(10),
            AppText(
              text: 'Log Out',
              fontSize: 15,
              fontWeight: FontWeight.w900,
              fontClr: AppColors.red,
            ),
          ],
        ),
      ),
    );
  }
}
