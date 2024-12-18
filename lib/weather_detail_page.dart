import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'weather_service.dart';
import 'translation_service.dart';

class WeatherDetailPage extends StatefulWidget {
  final String city;

  const WeatherDetailPage({super.key, required this.city});

  @override
  _WeatherDetailPageState createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  final WeatherService _weatherService = WeatherService();
  final TranslationService _translationService = TranslationService();
  Map<String, dynamic>? _forecastData;

  @override
  void initState() {
    super.initState();
    _fetchForecast();
  }

  Future<void> _fetchForecast() async {
    try {
      final data = await _weatherService.fetchForecast(widget.city);
      for (var day in data['forecast']['forecastday']) {
        final condition = day['day']['condition']['text'];
        final translatedCondition = await _translateCondition(condition);
        day['day']['condition']['text'] = translatedCondition;
      }
      setState(() {
        _forecastData = data;
      });
    } catch (e) {
      print('Ошибка при загрузке прогноза для ${widget.city}: $e');
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

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('d MMMM yyyy', 'ru').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Прогноз для ${widget.city}'),
      ),
      body: _forecastData == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _forecastData!['forecast']['forecastday'].length,
              itemBuilder: (context, index) {
                final day = _forecastData!['forecast']['forecastday'][index];
                final condition = day['day']['condition']['text'];
                final formattedDate = _formatDate(day['date']);
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      'https:${day['day']['condition']['icon']}',
                      width: 50,
                      height: 50,
                    ),
                    title: Text('Дата: $formattedDate'),
                    subtitle: Text(
                      'Макс. температура: ${day['day']['maxtemp_c']}°C\n'
                      'Мин. температура: ${day['day']['mintemp_c']}°C\n'
                      'Состояние: $condition\n'
                      'Ветер: ${day['day']['maxwind_kph']} км/ч',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
