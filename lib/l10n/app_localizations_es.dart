// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settings => 'Ajustes';

  @override
  String get close => 'Cerrar';

  @override
  String get query => 'Consulta';

  @override
  String get querySent => 'Consulta enviada al centro';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get search => 'Buscar';

  @override
  String get voucherData => '📄 Datos del Voucher';

  @override
  String get voucherId => 'ID del Voucher';

  @override
  String get pdfSaved => 'PDF guardado en Documentos';

  @override
  String get queryVoucher => 'Consultar Voucher';

  @override
  String get queryError => 'Error al consultar: ';

  @override
  String get idError => 'No existe un voucher con ese ID';

  @override
  String get internetError => 'No hay conexión a Internet. Intenta nuevamente.';

  @override
  String get enterId => 'Debe ingresar un ID';

  @override
  String get voucherSuccess => 'Voucher guardado con éxito';

  @override
  String get saveError => 'Error al guardar: ';

  @override
  String get issueVoucher => 'Emitir Voucher';

  @override
  String get clientName => 'Nombre del Cliente';

  @override
  String get enterName => 'Ingrese el nombre';

  @override
  String get clientPhone => 'Télefono del Cliente';

  @override
  String get enterPhone => 'Ingrese teléfono';

  @override
  String get description => 'Descripción';

  @override
  String get enterDescription => 'Ingresar descripción';

  @override
  String get issuer => 'Emisor (UID o nombre del admin)';

  @override
  String get enterIssuer => 'Ingresar emisor';

  @override
  String get state => 'Estado (Ej: emitido, pendiente...)';

  @override
  String get enterState => 'Ingresar estado';

  @override
  String get date => 'Fecha: ';

  @override
  String get changeDate => 'Cambiar fecha';

  @override
  String get saveVoucher => 'Guardar Voucher';

  @override
  String get mail => 'Correo';

  @override
  String get password => 'Contraseña';

  @override
  String get authentication => 'Autenticación';

  @override
  String get googleSignIn => 'Iniciar sesión con Google';

  @override
  String get googleRegistry => 'Registrar con Google';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta? Registrate';

  @override
  String get haveAccount => '¿Ya tienes cuenta? Inicia Sesión';
}
