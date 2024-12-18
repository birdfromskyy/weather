Map<String, String> weatherConditionTranslations = {
  'Sunny': 'Солнечно',
  'Cloudy': 'Облачно',
  'Overcast': 'Пасмурно',
  'Mist': 'Туман',
  'Overcast ': 'Пасмурная погода',
  'Partly cloudy': 'Переменная облачность',
  'Patchy rain possible': 'Возможен дождь',
  'Patchy rain nearby': 'Мелкий дождь неподалеку',
  'Thundery outbreaks possible': 'Возможны грозы',
  'Blowing snow': 'Метель',
  'Blizzard': 'Буран',
  'Fog': 'Туман',
  'Freezing fog': 'Морозный туман',
  'Patchy light drizzle': 'Местами легкая морось',
  'Light drizzle': 'Легкая морось',
  'Freezing drizzle': 'Морозная морось',
  'Heavy freezing drizzle': 'Сильная морозная морось',
  'Patchy light rain': 'Местами легкий дождь',
  'Light rain': 'Легкий дождь',
  'Moderate rain at times': 'Умеренный дождь временами',
  'Moderate rain': 'Умеренный дождь',
  'Heavy rain at times': 'Сильный дождь временами',
  'Heavy rain': 'Сильный дождь',
  'Light freezing rain': 'Легкий морозный дождь',
  'Moderate or heavy freezing rain': 'Умеренный или сильный морозный дождь',
  'Light sleet': 'Легкий дождь со снегом',
  'Moderate or heavy sleet': 'Умеренный или сильный дождь со снегом',
  'Patchy light snow': 'Местами легкий снег',
  'Light snow': 'Легкий снег',
  'Patchy moderate snow': 'Местами умеренный снег',
  'Moderate snow': 'Умеренный снег',
  'Patchy heavy snow': 'Местами сильный снег',
  'Heavy snow': 'Сильный снег',
  'Ice pellets': 'Ледяные гранулы',
  'Light rain shower': 'Легкий дождь',
  'Moderate or heavy rain shower': 'Умеренный или сильный дождь',
  'Torrential rain shower': 'Ливень',
  'Light sleet showers': 'Легкий дождь со снегом',
  'Moderate or heavy sleet showers': 'Умеренный или сильный дождь со снегом',
  'Light snow showers': 'Легкий снег',
  'Moderate or heavy snow showers': 'Умеренный или сильный снег',
  'Light showers of ice pellets': 'Легкий дождь из ледяных гранул',
  'Moderate or heavy showers of ice pellets':
      'Умеренный или сильный дождь из ледяных гранул',
  'Patchy light rain with thunder': 'Местами легкий дождь с грозой',
  'Moderate or heavy rain with thunder': 'Умеренный или сильный дождь с грозой',
  'Patchy light snow with thunder': 'Местами легкий снег с грозой',
  'Moderate or heavy snow with thunder': 'Умеренный или сильный снег с грозой',
};

class TranslationService {
  Future<String> translate(
      String condition, String fromLang, String toLang) async {
    if (fromLang == 'en' && toLang == 'ru') {
      return weatherConditionTranslations[condition] ?? condition;
    }
    return condition;
  }
}
