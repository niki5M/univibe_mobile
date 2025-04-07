import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/profile/bloc/profile_state.dart';
// import '../../features/profile/models/profile_model.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';
import '../auth/presentation/login_page.dart';
import '../theme/theme_bloc.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String selectedGroup;
  final ValueChanged<String>? onGroupChanged;

  const CustomAppBar({
    super.key,
    required this.selectedGroup,
    this.onGroupChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildGroupSelection(context),
            _buildUserProfile(context),
          ],
        ),
      ),
      flexibleSpace: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, theme) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroupSelection(BuildContext context) {
    const groups = ['И-1-21(а)', 'И-2-21(б)', 'И-1-22(a)'];

    return GroupSelection(
      selectedGroup: selectedGroup,
      groups: groups,
      onGroupChanged: onGroupChanged,
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return UserProfile(
            profile: state.profile,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class GroupSelection extends StatelessWidget {
  final String selectedGroup;
  final List<String> groups;
  final ValueChanged<String>? onGroupChanged;

  const GroupSelection({
    Key? key,
    required this.selectedGroup,
    required this.groups,
    this.onGroupChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final iconColor = Theme.of(context).iconTheme.color;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.group_rounded, color: iconColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (onGroupChanged != null) {
                  onGroupChanged!(value);
                }
              },
              itemBuilder: (BuildContext context) {
                return groups.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice, style: TextStyle(color: textColor)),
                  );
                }).toList();
              },
              child: Row(
                children: [
                  Text("Ваша группа", style: TextStyle(fontSize: 15, color: textColor)),
                  Icon(Icons.arrow_drop_down, color: iconColor),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(selectedGroup, style: TextStyle(fontSize: 15, color: textColor)),
          ],
        ),
      ],
    );
  }
}

class UserProfile extends StatelessWidget {
  final Profile profile;

  const UserProfile({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final smallTextColor = Theme.of(context).textTheme.bodySmall?.color;
    final iconColor = Theme.of(context).iconTheme.color;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              profile.name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              profile.group,
              style: TextStyle(
                fontSize: 10,
                color: smallTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return ShadProfileSheet(profile: profile);
              },
            );
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: iconColor ?? Colors.grey,
                width: 2,
              ),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/cat.jpeg'),
            ),
          ),
        ),
      ],
    );
  }
}

class ShadProfileSheet extends StatelessWidget {
  final Profile profile;

  const ShadProfileSheet({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final iconColor = Theme.of(context).iconTheme.color;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/cat.jpeg'),
            ),
            const SizedBox(height: 16),
            Text(
              profile.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              profile.email,
              style: TextStyle(
                fontSize: 14,
                color: textColor?.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 20),
            _buildSettingsList(context, textColor, iconColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList(
      BuildContext context,
      Color? textColor,
      Color? iconColor,
      ) {
    return Column(
      children: [
        BlocBuilder<ThemeBloc, ThemeData>(
          builder: (context, themeState) {
            return ListTile(
              leading: Icon(Icons.dark_mode, color: iconColor),
              title: Text("Темная тема", style: TextStyle(color: textColor)),
              trailing: Switch(
                value: themeState.brightness == Brightness.dark,
                onChanged: (value) {
                  BlocProvider.of<ThemeBloc>(context).add(ToggleTheme());
                },
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.notifications, color: iconColor),
          title: Text("Уведомления", style: TextStyle(color: textColor)),
          trailing: const Switch(value: true, onChanged: null),
        ),
        const LogoutButton(),
      ],
    );
  }
}



class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final iconColor = Theme.of(context).iconTheme.color;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
          );
        }
      },
      child: ListTile(
        leading: Icon(Icons.exit_to_app, color: iconColor),
        title: Text("Выход из аккаунта", style: TextStyle(color: textColor)),
        onTap: () {
          context.read<AuthBloc>().add(AuthLogoutRequested());
        },
      ),
    );
  }
}