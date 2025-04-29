import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/profile/bloc/profile_state.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../theme/theme_bloc.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final popoverController = ShadPopoverController();

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildUserProfile(context),
            _buildActionIcons(context, popoverController),
          ],
        ),
      ),
    );
  }



  Widget _buildUserProfile(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Row(
            children: [
              _buildProfileAvatar(context, state.profile),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.profile.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  // Text(
                  //   state.profile.id,
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w500,
                  //     color: Theme.of(context).textTheme.bodyLarge?.color,
                  //   ),
                  // ),
                  Text(
                    state.profile.group,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProfileAvatar(BuildContext context, Profile profile) {
    return GestureDetector(
      onTap: () => _showProfileSheet(context, profile),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).iconTheme.color ?? Colors.grey,
            width: 1.5,
          ),
        ),
        child: const CircleAvatar(
          backgroundImage: AssetImage('assets/images/cat.jpeg'),
        ),
      ),
    );
  }

  Widget _buildActionIcons(BuildContext context, ShadPopoverController controller) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Row(
            children: [
              ShadPopover.new(
                controller: controller,
                popover: (context) => _buildNotificationPopover(context),
                child: ShadButton.ghost(
                  padding: const EdgeInsets.all(6),
                  onPressed: () {
                    controller.toggle(); // Открывает/закрывает popover
                  },
                  child: const Icon(LucideIcons.bellRing, size: 24),
                ),
              ),
              ShadButton.ghost(
                padding: const EdgeInsets.all(6),
                child: const Icon(LucideIcons.component, size: 24),
                onPressed: () {
                  _showProfileSheet(context, state.profile);
                },
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showProfileSheet(BuildContext context, Profile profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShadProfileSheet(profile: profile),
    );
  }
}

Widget _buildNotificationPopover(BuildContext context) {
  final theme = ShadTheme.of(context);
  return Container(
    width: 250,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: theme.colorScheme.popover,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Уведомления",
          style: theme.textTheme.muted.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(3, (i) => _buildNotificationItem(theme, i + 1)),
      ],
    ),
  );
}

Widget _buildNotificationItem(ShadThemeData theme, int number) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(LucideIcons.mail, size: 20, color: theme.colorScheme.foreground),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Новое уведомление #$number',
            style: TextStyle(fontSize: 13, color: theme.colorScheme.foreground),
          ),
        ),
      ],
    ),
  );
}

class ShadProfileSheet extends StatelessWidget {
  final Profile profile;

  const ShadProfileSheet({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final roles = {
      'student': 'Студент',
      'teacher': 'Преподаватель',
      'admin': 'Администратор',
      'moderator': 'Модератор',
    };

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/cat.jpeg'),
          ),
          const SizedBox(height: 12),
          Text(
            profile.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.foreground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.email,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ShadSelect<String>(
              placeholder: const Text('Выберите роль'),
              options: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 6, 6, 6),
                  child: Text(
                    'Роли',
                    style: theme.textTheme.muted.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.popoverForeground,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                ...roles.entries.map(
                      (e) => ShadOption(
                    value: e.key,
                    child: Text(e.value),
                  ),
                ),
              ],
              selectedOptionBuilder: (context, value) =>
                  Text(roles[value] ?? 'Не выбрано'),
              onChanged: (value) {
                print('Выбрана роль: $value');
                // Здесь можно вызвать Bloc-событие или сохранить роль
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsList(context),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildListTile(
            context,
            icon: LucideIcons.moon,
            title: "Темная тема",
            trailing: Switch(
              value: theme.brightness == Brightness.dark,
              onChanged: (value) {
                context.read<ThemeBloc>().add(ToggleTheme());
              },
            ),
          ),
          _buildListTile(
            context,
            icon: LucideIcons.bell,
            title: "Уведомления",
            trailing: const Switch(value: true, onChanged: null),
          ),
          const Divider(height: 1),
          _buildListTile(
            context,
            icon: LucideIcons.logOut,
            title: "Выход из аккаунта",
            onTap: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        Widget? trailing,
        VoidCallback? onTap,
      }) {
    final theme = ShadTheme.of(context);

    return ListTile(
      leading: Icon(icon, size: 28, color: theme.colorScheme.foreground),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: theme.colorScheme.foreground,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      minLeadingWidth: 35,
    );
  }
}