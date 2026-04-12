import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// App localization helper
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// Format date based on locale
  String formatDate(DateTime date) {
    if (locale.languageCode == 'ru') {
      return DateFormat('dd MMMM yyyy', 'ru').format(date);
    }
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  /// Format currency based on locale
  String formatCurrency(double amount, String currency) {
    if (locale.languageCode == 'ru') {
      return NumberFormat.currency(
        locale: 'ru_RU',
        symbol: currency == 'RUB' ? '₽' : '\$',
        decimalDigits: 2,
      ).format(amount);
    }
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: currency == 'USD' ? '\$' : '₽',
      decimalDigits: 2,
    ).format(amount);
  }

  /// Format number
  String formatNumber(num number) {
    return NumberFormat.decimalPattern(locale.toString()).format(number);
  }

  /// Get localized strings
  String get appTitle => locale.languageCode == 'ru'
      ? 'Популярные пакеты'
      : 'Popular Packages';

  String get products => locale.languageCode == 'ru'
      ? 'Товары'
      : 'Products';

  String get settings => locale.languageCode == 'ru'
      ? 'Настройки'
      : 'Settings';

  String get language => locale.languageCode == 'ru'
      ? 'Язык'
      : 'Language';

  String get security => locale.languageCode == 'ru'
      ? 'Безопасность'
      : 'Security';

  String get authToken => locale.languageCode == 'ru'
      ? 'Токен авторизации'
      : 'Auth Token';

  String get save => locale.languageCode == 'ru'
      ? 'Сохранить'
      : 'Save';

  String get logout => locale.languageCode == 'ru'
      ? 'Выйти'
      : 'Logout';

  String get price => locale.languageCode == 'ru'
      ? 'Цена'
      : 'Price';

  String get created => locale.languageCode == 'ru'
      ? 'Создано'
      : 'Created';
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
