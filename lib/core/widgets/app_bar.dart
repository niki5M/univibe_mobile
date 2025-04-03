import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/profile/bloc/profile_state.dart';
import '../theme/theme_bloc.dart';

class ScheduleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String selectedGroup;
  final ValueChanged<String>? onGroupChanged;

  const ScheduleAppBar({
    super.key,
    required this.selectedGroup,
    this.onGroupChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.group_rounded, color: Color(0xffa68694)),
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
                    child: Text(choice),
                  );
                }).toList();
              },
              child: Row(
                children: const [
                  Text("Ваша группа", style: TextStyle(fontSize: 15)),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(selectedGroup, style: const TextStyle(fontSize: 15)),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              profile.name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(profile.group, style: const TextStyle(fontSize: 10)),
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
                return ProfileSettings(profile: profile);
              },
            );
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Theme.of(context).iconTheme.color ?? Colors.black,
                  width: 2),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/seyd.png'),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileSettings extends StatelessWidget {
  final Profile profile;

  const ProfileSettings({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeData>(
      builder: (context, theme) {
        return SlidingUpPanel(
          minHeight: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.6,
          panelBuilder: (ScrollController scrollController) {
            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage:
                            AssetImage('assets/images/seyd.png'),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            profile.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            profile.email,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSettingsList(context, theme),
                  ],
                ),
              ),
            );
          },
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        );
      },
    );
  }

  Widget _buildSettingsList(BuildContext context, ThemeData theme) {
    return Expanded(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text("Редактировать профиль"),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          BlocBuilder<ThemeBloc, ThemeData>(
            builder: (context, themeState) {
              return ListTile(
                leading: Icon(
                  Icons.dark_mode,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: const Text("Темная тема"),
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
            leading: Icon(
              Icons.notifications,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text("Уведомления"),
            trailing: const Switch(value: true, onChanged: null),
          ),
          ListTile(
            leading: Icon(
              Icons.help,
              color: Theme.of(context).iconTheme.color,
            ),
            title: const Text("Помощь"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}

class ProfileNameInAppBar extends StatelessWidget {
  const ProfileNameInAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Text(state.profile.name);
        }
        return const Text('Загрузка...');
      },
    );
  }
}