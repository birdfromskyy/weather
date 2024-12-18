import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'weather_service.dart';
import 'weather_detail_page.dart';
import 'translation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Прогноз погоды',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final WeatherService _weatherService = WeatherService();
  final TranslationService _translationService = TranslationService();
  final List<String> _cities = [
    'Москва',
    'Ханты-Мансийск',
    'Тюмень',
    'Сургут',
    'Нижневартовск',
    'Радужный',
    'Бишкек',
    'Нягань',
    'Урай',
    'Нефтеюганск'
  ];
  Map<String, Map<String, dynamic>> _weatherData = {};
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeatherForAllCities();
  }

  Future<void> _fetchWeatherForAllCities() async {
    for (var city in _cities) {
      await _fetchWeather(city);
    }
  }

  Future<void> _fetchWeather(String city) async {
    try {
      final data = await _weatherService.fetchWeather(city);
      final condition = data['current']['condition']['text'];
      final translatedCondition = await _translateCondition(condition);
      setState(() {
        _weatherData[city] = data;
        _weatherData[city]!['current']['condition']['text'] =
            translatedCondition;
      });
    } catch (e) {
      print('Ошибка при загрузке данных для $city: $e');
    }
  }

  Future<String> _translateCondition(String condition) async {
    try {
      return await _translationService.translate(condition, 'en', 'ru');
    } catch (e) {
      print('Ошибка перевода: $e');
      return condition;
    }
  }

  void _addCity() async {
    final city = _cityController.text.trim();
    if (city.isNotEmpty && !_cities.contains(city)) {
      try {
        final data = await _weatherService.fetchWeather(city);
        final condition = data['current']['condition']['text'];
        final translatedCondition = await _translateCondition(condition);
        setState(() {
          _cities.add(city);
          _weatherData[city] = data;
          _weatherData[city]!['current']['condition']['text'] =
              translatedCondition;
        });
        _cityController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Город "$city" не найден')),
        );
      }
    }
  }

  void _openWeatherDetail(String city) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherDetailPage(city: city),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Прогноз погоды'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Введите название города',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _addCity,
                ),
              ],
            ),
          ),
          Expanded(
            child: _weatherData.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _cities.length,
                    itemBuilder: (context, index) {
                      final city = _cities[index];
                      final data = _weatherData[city];
                      final condition = data != null
                          ? data['current']['condition']['text']
                          : 'Загрузка...';
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: data != null
                              ? Image.network(
                                  'https:${data['current']['condition']['icon']}',
                                  width: 50,
                                  height: 50,
                                )
                              : null,
                          title: Text(city),
                          subtitle: data == null
                              ? const Text('Загрузка...')
                              : Text(
                                  'Температура: ${data['current']['temp_c']}°C\n'
                                  'Состояние: $condition\n'
                                  'Ветер: ${data['current']['wind_kph']} км/ч',
                                ),
                          onTap: () => _openWeatherDetail(city),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
