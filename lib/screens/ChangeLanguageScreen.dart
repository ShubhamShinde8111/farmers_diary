import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../lan/locale_provider.dart';
import '../generated/l10n.dart'; // For using translated strings

class ChangeLanguageScreen extends StatelessWidget {
  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'हिन्दी (Hindi)', 'code': 'hi'},
    {'name': 'বাংলা (Bengali)', 'code': 'bn'},
    {'name': 'తెలుగు (Telugu)', 'code': 'te'},
    {'name': 'मराठी (Marathi)', 'code': 'mr'},
    {'name': 'தமிழ் (Tamil)', 'code': 'ta'},
    {'name': 'ગુજરાતી (Gujarati)', 'code': 'gu'},
    {'name': 'اردو (Urdu)', 'code': 'ur'},
    {'name': 'ಕನ್ನಡ (Kannada)', 'code': 'kn'},
    {'name': 'ଓଡ଼ିଆ (Odia)', 'code': 'or'},
    {'name': 'മലയാളം (Malayalam)', 'code': 'ml'},
    {'name': 'ਪੰਜਾਬੀ (Punjabi)', 'code': 'pa'},
    {'name': 'অসমীয়া (Assamese)', 'code': 'as'},
  ];

  void _selectLanguage(BuildContext context, String name, String code) async {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    await localeProvider.setLocale(Locale(code));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Language changed to $name')),
    );

    // Optional: pop back to previous screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocaleCode = Provider.of<LocaleProvider>(context).locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)!.selectLanguage), // From localization
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          final isSelected = language['code'] == currentLocaleCode;

          return ListTile(
            leading: const Icon(Icons.language),
            title: Text(language['name']!),
            trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.arrow_forward_ios),
            onTap: () => _selectLanguage(context, language['name']!, language['code']!),
          );
        },
      ),
    );
  }
}
