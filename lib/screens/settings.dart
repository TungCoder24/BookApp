import 'package:bai_test_intern/constant.dart';
import 'package:bai_test_intern/provider/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool valueMood = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ThemeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final toggleProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: value.isDarkMode ? colorWhite : colorBlack,
                )),
            title: Text(
              "Setting",
              style: TextStyle(
                color: value.isDarkMode ? colorWhite : colorBlack,
              ),
            ),
          ),
          body: Container(
            child: ListTile(
              leading: const Icon(Icons.sunny),
              title: Text(
                "Chế độ tối",
                style: TextStyle(
                    color: value.isDarkMode ? colorWhite : colorBlack,
                    fontSize: 16),
              ),
              trailing: Switch(
                  activeColor: Colors.green,
                  value: value.isDarkMode,
                  onChanged: (bool value) {
                    toggleProvider.toggle(value);
                  }),
            ),
          ),
        );
      },
    );
  }
}
