// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get close => 'Close';

  @override
  String get query => 'Query';

  @override
  String get querySent => 'Query sent to the center';

  @override
  String get signIn => 'Sign in';

  @override
  String get register => 'Register';

  @override
  String get search => 'Search';

  @override
  String get voucherData => '📄 Voucher data';

  @override
  String get voucherId => 'Voucher ID';

  @override
  String get pdfSaved => 'PDF saved in Documents';

  @override
  String get queryVoucher => 'Query Voucher';

  @override
  String get queryError => 'Query Error: ';

  @override
  String get idError => 'There is not a Voucher with that ID';

  @override
  String get internetError => 'There is not internet conection. Try again';

  @override
  String get enterId => 'You should enter an ID';

  @override
  String get voucherSuccess => 'Voucher saved successfully';

  @override
  String get saveError => 'Save error: ';

  @override
  String get issueVoucher => 'Issue Voucher';

  @override
  String get clientName => 'Client name';

  @override
  String get enterName => 'Enter name';

  @override
  String get clientPhone => 'Client phone';

  @override
  String get enterPhone => 'Enter phone';

  @override
  String get description => 'Description';

  @override
  String get enterDescription => 'Enter Description';

  @override
  String get issuer => 'Issuer (UID or admin name)';

  @override
  String get enterIssuer => 'Enter issuer';

  @override
  String get state => 'State (Ex: issued, pending...)';

  @override
  String get enterState => 'Enter state';

  @override
  String get date => 'Date: ';

  @override
  String get changeDate => 'Change date';

  @override
  String get saveVoucher => 'Save Voucher';

  @override
  String get mail => 'Mail';

  @override
  String get password => 'Password';

  @override
  String get authentication => 'Authentication';

  @override
  String get googleSignIn => 'Sign In with Google';

  @override
  String get googleRegistry => 'Register with Goolge';

  @override
  String get dontHaveAccount => 'Don\'t you have an account? Register';

  @override
  String get haveAccount => 'Do you already have an account? SignIn';
}
