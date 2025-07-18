import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/quote_card.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/ai_quote_service.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MotivationAIApp());
}

class MotivationAIApp extends StatelessWidget {
  const MotivationAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivation AI',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> selectedTopics = [];
  String selectedMood = 'Any';
  String quote = 'Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle.';
  String author = 'Christian D. Larson';
  bool isLoading = false;
  DateTime? lastQuoteDate;
  String? preferredTime; // format: HH:mm

  @override
  void initState() {
    super.initState();
    _loadLastQuote();
  }

  Future<void> _loadLastQuote() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      quote = prefs.getString('last_quote') ?? quote;
      author = prefs.getString('last_author') ?? author;
      lastQuoteDate = prefs.getString('last_quote_date') != null ? DateTime.tryParse(prefs.getString('last_quote_date')!) : null;
      preferredTime = prefs.getString('preferred_time');
      selectedTopics = prefs.getStringList('selected_topics') ?? [];
      selectedMood = prefs.getString('selected_mood') ?? 'Any';
    });
  }

  Future<void> _saveQuote(String newQuote, String newAuthor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_quote', newQuote);
    await prefs.setString('last_author', newAuthor);
    await prefs.setString('last_quote_date', DateTime.now().toIso8601String());
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selected_topics', selectedTopics);
    await prefs.setString('selected_mood', selectedMood);
    if (preferredTime != null) {
      await prefs.setString('preferred_time', preferredTime!);
    }
  }

  bool _canGetQuoteNow() {
    if (preferredTime == null) return false;
    final now = TimeOfDay.now();
    final parts = preferredTime!.split(":");
    if (parts.length != 2) return false;
    final prefHour = int.tryParse(parts[0]);
    final prefMinute = int.tryParse(parts[1]);
    if (prefHour == null || prefMinute == null) return false;
    // Allow quote if current time is after or equal to preferred time
    if (now.hour < prefHour || (now.hour == prefHour && now.minute < prefMinute)) {
      return false;
    }
    // Only allow once per day
    final today = DateTime.now();
    if (lastQuoteDate != null &&
        lastQuoteDate!.year == today.year &&
        lastQuoteDate!.month == today.month &&
        lastQuoteDate!.day == today.day) {
      return false;
    }
    return true;
  }

  Future<void> _getNewQuote() async {
    if (!_canGetQuoteNow()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(preferredTime == null
            ? 'Please set your preferred time in Preferences.'
            : 'You can only get a new quote once per day at your chosen time.')),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final result = await AIQuoteService.fetchQuote(topics: selectedTopics, mood: selectedMood);
      setState(() {
        quote = result['quote'] ?? '';
        author = result['author'] ?? '';
        lastQuoteDate = DateTime.now();
      });
      await _saveQuote(quote, author);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Here is your new quote!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch quote: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _openSettings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
    if (result != null && result is Map) {
      setState(() {
        selectedTopics = List<String>.from(result['topics'] ?? []);
        selectedMood = result['mood'] ?? 'Any';
        preferredTime = result['time'] ?? preferredTime;
      });
      await _savePreferences();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings updated!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motivation AI'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? const CircularProgressIndicator()
                  : QuoteCard(
                      quote: quote,
                      author: author,
                    ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _getNewQuote,
                  style: AppTheme.iosButtonStyle,
                  child: const Text('New Quote'),
                ),
              ),
              const SizedBox(height: 32),
              if (selectedTopics.isNotEmpty || selectedMood != 'Any' || preferredTime != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selectedTopics.isNotEmpty)
                      Text('Topics: ${selectedTopics.join(", ")}', style: Theme.of(context).textTheme.bodySmall),
                    if (selectedMood != 'Any')
                      Text('Mood: $selectedMood', style: Theme.of(context).textTheme.bodySmall),
                    if (preferredTime != null)
                      Text('Preferred Time: $preferredTime', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
