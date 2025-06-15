import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void initIndonesianLocale() {
  initializeDateFormatting('id_ID', null);
}

class IndonesianDateFormat {
  static final idLocale = Intl.withLocale(
    'id_ID',
    () => DateFormat('EEEE, d MMMM y'),
  );

  static String formatDayName(DateTime date) {
    return DateFormat.EEEE('id_ID').format(date);
  }
}
