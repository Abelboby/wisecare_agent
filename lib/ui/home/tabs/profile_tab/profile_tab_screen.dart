import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:wisecare_agent/models/profile/profile_model.dart';
import 'package:wisecare_agent/provider/home_provider.dart';
import 'package:wisecare_agent/provider/profile_provider.dart';
import 'package:wisecare_agent/ui/home/tabs/profile_tab/edit_profile/edit_profile_screen.dart';
import 'package:wisecare_agent/utils/theme/colors/app_color.dart';
import 'package:wisecare_agent/utils/theme/theme_manager.dart';

part 'profile_tab_functions.dart';
part 'widgets/profile_header_section.dart';
part 'widgets/profile_stats_section.dart';
part 'widgets/profile_details_card.dart';
part 'widgets/profile_quick_actions.dart';

/// Profile tab: Agent Profile header, stats, professional details, quick actions.
class ProfileTabScreen extends StatefulWidget {
  const ProfileTabScreen({super.key});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Skin.color(Co.warmBackground),
      body: Consumer2<ProfileProvider, HomeProvider>(
        builder: (context, profileProvider, homeProvider, _) {
          final profile = profileProvider.profile;
          final isLoading = profileProvider.isProfileLoading;
          final errorMessage = profileProvider.errorMessage;

          if (isLoading && profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Skin.color(Co.primary)),
                  const SizedBox(height: 16),
                  Text(
                    'Loading profile...',
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: Skin.color(Co.loginLabel),
                    ),
                  ),
                ],
              ),
            );
          }

          if (errorMessage != null && errorMessage.isNotEmpty && profile == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexend(
                        fontSize: 14,
                        color: Skin.color(Co.error),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        profileProvider.loadProfile();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Skin.color(Co.primary),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => profileProvider.loadProfile(forceRefresh: true),
            color: Skin.color(Co.primary),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _ProfileHeaderWithStats(
                    tasksCount: homeProvider.activeTasks.length,
                    onEditProfile: () => _openEditProfile(context), // from profile_tab_functions.dart
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _ProfileDetailsCard(profile: profile),
                      const SizedBox(height: 16),
                      _ProfileQuickActionsCard(
                        isOnline: homeProvider.isOnline,
                        onToggleOnline: () {
                          if (homeProvider.isOnline) {
                            homeProvider.setOffline();
                          } else {
                            homeProvider.setOnline();
                          }
                        },
                        onViewCertification: () {},
                        onLogout: () => profileProvider.signOut(),
                        isLoggingOut: profileProvider.isLoading,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
