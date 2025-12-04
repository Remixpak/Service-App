import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @query.
  ///
  /// In es, this message translates to:
  /// **'Consulta'**
  String get query;

  /// No description provided for @querySent.
  ///
  /// In es, this message translates to:
  /// **'Consulta enviada al centro'**
  String get querySent;

  /// No description provided for @signIn.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get signIn;

  /// No description provided for @register.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get register;

  /// No description provided for @search.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get search;

  /// No description provided for @voucherData.
  ///
  /// In es, this message translates to:
  /// **'📄 Datos del Voucher'**
  String get voucherData;

  /// No description provided for @voucherId.
  ///
  /// In es, this message translates to:
  /// **'ID del Voucher'**
  String get voucherId;

  /// No description provided for @pdfSaved.
  ///
  /// In es, this message translates to:
  /// **'PDF guardado en Documentos'**
  String get pdfSaved;

  /// No description provided for @queryVoucher.
  ///
  /// In es, this message translates to:
  /// **'Consultar Voucher'**
  String get queryVoucher;

  /// No description provided for @queryError.
  ///
  /// In es, this message translates to:
  /// **'Error al consultar: '**
  String get queryError;

  /// No description provided for @idError.
  ///
  /// In es, this message translates to:
  /// **'No existe un voucher con ese ID'**
  String get idError;

  /// No description provided for @internetError.
  ///
  /// In es, this message translates to:
  /// **'No hay conexión a Internet. Intenta nuevamente.'**
  String get internetError;

  /// No description provided for @enterId.
  ///
  /// In es, this message translates to:
  /// **'Debe ingresar un ID'**
  String get enterId;

  /// No description provided for @voucherSuccess.
  ///
  /// In es, this message translates to:
  /// **'Voucher guardado con éxito'**
  String get voucherSuccess;

  /// No description provided for @saveError.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar: '**
  String get saveError;

  /// No description provided for @issueVoucher.
  ///
  /// In es, this message translates to:
  /// **'Emitir Voucher'**
  String get issueVoucher;

  /// No description provided for @clientName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del Cliente'**
  String get clientName;

  /// No description provided for @enterName.
  ///
  /// In es, this message translates to:
  /// **'Ingrese el nombre'**
  String get enterName;

  /// No description provided for @clientPhone.
  ///
  /// In es, this message translates to:
  /// **'Télefono del Cliente'**
  String get clientPhone;

  /// No description provided for @enterPhone.
  ///
  /// In es, this message translates to:
  /// **'Ingrese teléfono'**
  String get enterPhone;

  /// No description provided for @description.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get description;

  /// No description provided for @enterDescription.
  ///
  /// In es, this message translates to:
  /// **'Ingresar descripción'**
  String get enterDescription;

  /// No description provided for @issuer.
  ///
  /// In es, this message translates to:
  /// **'Emisor (UID o nombre del admin)'**
  String get issuer;

  /// No description provided for @enterIssuer.
  ///
  /// In es, this message translates to:
  /// **'Ingresar emisor'**
  String get enterIssuer;

  /// No description provided for @state.
  ///
  /// In es, this message translates to:
  /// **'Estado (Ej: emitido, pendiente...)'**
  String get state;

  /// No description provided for @enterState.
  ///
  /// In es, this message translates to:
  /// **'Ingresar estado'**
  String get enterState;

  /// No description provided for @date.
  ///
  /// In es, this message translates to:
  /// **'Fecha: '**
  String get date;

  /// No description provided for @changeDate.
  ///
  /// In es, this message translates to:
  /// **'Cambiar fecha'**
  String get changeDate;

  /// No description provided for @saveVoucher.
  ///
  /// In es, this message translates to:
  /// **'Guardar Voucher'**
  String get saveVoucher;

  /// No description provided for @mail.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get mail;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @authentication.
  ///
  /// In es, this message translates to:
  /// **'Autenticación'**
  String get authentication;

  /// No description provided for @googleSignIn.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión con Google'**
  String get googleSignIn;

  /// No description provided for @googleRegistry.
  ///
  /// In es, this message translates to:
  /// **'Registrar con Google'**
  String get googleRegistry;

  /// No description provided for @dontHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes una cuenta? Registrate'**
  String get dontHaveAccount;

  /// No description provided for @haveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? Inicia Sesión'**
  String get haveAccount;

  /// No description provided for @voucherManagement.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Voucher'**
  String get voucherManagement;

  /// No description provided for @editingVoucher.
  ///
  /// In es, this message translates to:
  /// **'Editar Voucher'**
  String get editingVoucher;

  /// No description provided for @deleteVoucher.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Voucher'**
  String get deleteVoucher;

  /// No description provided for @order.
  ///
  /// In es, this message translates to:
  /// **'Orden: '**
  String get order;

  /// No description provided for @client.
  ///
  /// In es, this message translates to:
  /// **'Cliente: '**
  String get client;

  /// No description provided for @model.
  ///
  /// In es, this message translates to:
  /// **'Modelo: '**
  String get model;

  /// No description provided for @service.
  ///
  /// In es, this message translates to:
  /// **'Servicio: '**
  String get service;

  /// No description provided for @searchError.
  ///
  /// In es, this message translates to:
  /// **'Error al buscar: '**
  String get searchError;

  /// No description provided for @orderNumber.
  ///
  /// In es, this message translates to:
  /// **'Número de orden'**
  String get orderNumber;

  /// No description provided for @noVouchersRegistered.
  ///
  /// In es, this message translates to:
  /// **'No hay vouchers registrados'**
  String get noVouchersRegistered;

  /// No description provided for @enterOrderNumber.
  ///
  /// In es, this message translates to:
  /// **'Ingrese el número de orden'**
  String get enterOrderNumber;

  /// No description provided for @orderError.
  ///
  /// In es, this message translates to:
  /// **'No existe un voucher con ese número de orden'**
  String get orderError;

  /// No description provided for @whatsappError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir WhatsApp'**
  String get whatsappError;

  /// No description provided for @issueDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de emisión: '**
  String get issueDate;

  /// No description provided for @deliveryDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de entrega: '**
  String get deliveryDate;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get saveChanges;

  /// No description provided for @editData.
  ///
  /// In es, this message translates to:
  /// **'Editar datos'**
  String get editData;

  /// No description provided for @editSucces.
  ///
  /// In es, this message translates to:
  /// **'Voucher actualizado correctamente'**
  String get editSucces;

  /// No description provided for @pdfError.
  ///
  /// In es, this message translates to:
  /// **'Error al generar o enviar PDF: '**
  String get pdfError;

  /// No description provided for @notDefined.
  ///
  /// In es, this message translates to:
  /// **'no definida'**
  String get notDefined;

  /// No description provided for @justNumbers.
  ///
  /// In es, this message translates to:
  /// **'Ingrese solo números'**
  String get justNumbers;

  /// No description provided for @fourDigits.
  ///
  /// In es, this message translates to:
  /// **'El número debe tener solo 4 dígitos'**
  String get fourDigits;

  /// No description provided for @enterTotal.
  ///
  /// In es, this message translates to:
  /// **'Ingrese el total'**
  String get enterTotal;

  /// No description provided for @totalError.
  ///
  /// In es, this message translates to:
  /// **'El total debe ser positivo'**
  String get totalError;

  /// No description provided for @validTotal.
  ///
  /// In es, this message translates to:
  /// **'Ingrese un número válido'**
  String get validTotal;

  /// No description provided for @selectDelivery.
  ///
  /// In es, this message translates to:
  /// **'Select delivery'**
  String get selectDelivery;

  /// No description provided for @clean.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get clean;

  /// No description provided for @send.
  ///
  /// In es, this message translates to:
  /// **'Enviar al cliente'**
  String get send;

  /// No description provided for @changeIssueDate.
  ///
  /// In es, this message translates to:
  /// **'Cambiar fecha de emisión'**
  String get changeIssueDate;

  /// No description provided for @validPhone.
  ///
  /// In es, this message translates to:
  /// **'Ingrese un número de télefono válido'**
  String get validPhone;

  /// No description provided for @voucherExist.
  ///
  /// In es, this message translates to:
  /// **'Ya existe un voucher con este número de orden'**
  String get voucherExist;

  /// No description provided for @noUsers.
  ///
  /// In es, this message translates to:
  /// **'No hay usuario autenticado'**
  String get noUsers;

  /// No description provided for @noValidTotal.
  ///
  /// In es, this message translates to:
  /// **'El total debe ser un número válido'**
  String get noValidTotal;

  /// No description provided for @repairMessage.
  ///
  /// In es, this message translates to:
  /// **'Mensaje de Reparación'**
  String get repairMessage;

  /// No description provided for @deliveryRepairMessage.
  ///
  /// In es, this message translates to:
  /// **'Mensaje enviado al entregar una reparación'**
  String get deliveryRepairMessage;

  /// No description provided for @reserveMessage.
  ///
  /// In es, this message translates to:
  /// **'Mensaje de Reserva'**
  String get reserveMessage;

  /// No description provided for @confirmReserve.
  ///
  /// In es, this message translates to:
  /// **'Mensaje enviado al confirmar una reserva'**
  String get confirmReserve;

  /// No description provided for @currentUser.
  ///
  /// In es, this message translates to:
  /// **'Usuario actual: '**
  String get currentUser;

  /// No description provided for @closedAccount.
  ///
  /// In es, this message translates to:
  /// **'Sesión cerrada correctamente'**
  String get closedAccount;

  /// No description provided for @closeSession.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get closeSession;

  /// No description provided for @hi.
  ///
  /// In es, this message translates to:
  /// **'Hola'**
  String get hi;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
