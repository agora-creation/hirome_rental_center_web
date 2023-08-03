import 'package:flutter/material.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/providers/auth.dart';
import 'package:hirome_rental_center_web/screens/login.dart';
import 'package:hirome_rental_center_web/widgets/custom_lg_button.dart';
import 'package:hirome_rental_center_web/widgets/link_text.dart';
import 'package:hirome_rental_center_web/widgets/setting_list_tile.dart';
import 'package:hirome_rental_center_web/widgets/volume_slider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          '食器センター : 設定',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: kBlackColor),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingListTile(
              iconData: Icons.volume_up,
              label: '注文通知音量',
              topBorder: true,
              onTap: () => showDialog(
                context: context,
                builder: (context) => const OrderVolumeDialog(),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: LinkText(
                label: 'ログアウト',
                labelColor: kRedColor,
                onTap: () async {
                  await authProvider.signOut();
                  authProvider.clearController();
                  if (!mounted) return;
                  pushReplacementScreen(context, const LoginScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderVolumeDialog extends StatefulWidget {
  const OrderVolumeDialog({super.key});

  @override
  State<OrderVolumeDialog> createState() => _OrderVolumeDialogState();
}

class _OrderVolumeDialogState extends State<OrderVolumeDialog> {
  double orderVolume = 0.5;

  void _init() async {
    double tmpOrderVolume = await getPrefsDouble('orderVolume') ?? 0.5;
    setState(() {
      orderVolume = tmpOrderVolume;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('注文通知音量'),
          const SizedBox(height: 8),
          VolumeSlider(
            value: orderVolume,
            onChanged: (value) {
              setState(() {
                orderVolume = value;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomLgButton(
            label: '変更を保存',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () async {
              await setPrefsDouble('orderVolume', orderVolume);
              if (!mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
