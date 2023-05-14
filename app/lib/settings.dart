import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  SettingsThemeData settingsTheme() {
    return const SettingsThemeData(
      settingsListBackground: Color.fromRGBO(31, 31, 31, 1),
      titleTextColor: Colors.white,
      dividerColor: Colors.white,
      inactiveSubtitleColor: Colors.white,
      leadingIconsColor: Colors.white,
      tileHighlightColor: Colors.white,
      inactiveTitleColor: Colors.white,
      settingsTileTextColor: Colors.white,
      tileDescriptionTextColor: Colors.white
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SettingsList(
        lightTheme: settingsTheme(),
        darkTheme: settingsTheme(),
        sections: [
          SettingsSection(
            title: const Text('Settings'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                value: const Text('English'),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.people_alt),
                title: const Text('About'),
                value: const Text('About app'),
                onPressed: (context){
                  showAboutDialog(
                    context: context,
                    applicationIcon: const Icon(Icons.abc),
                    applicationName: 'About',
                    applicationLegalese: 'This app is licensed updated MIT License'
                  );
                },
              )

            ],
          ),
        ],
      ),
    );
  }
}
