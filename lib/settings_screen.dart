import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variabel untuk logika
  bool _isDarkMode = false;
  bool _isNotifikasi = true;
  bool _isAutoSave = false;
  int _volume = 50;
  String _selectedLanguage = 'Indonesia';

  final List<String> _languages = ['Indonesia', 'English', '中文'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Card Pengaturan Utama
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚙️ Pengaturan Aplikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    
                    // Switch Dark Mode
                    SwitchListTile(
                      title: const Text('Mode Gelap'),
                      subtitle: const Text('Aktifkan tema gelap'),
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value;
                          _tampilkanSnackbar('Mode Gelap: ${value ? "ON" : "OFF"}');
                        });
                      },
                      secondary: const Icon(Icons.dark_mode, color: Colors.blue),
                    ),
                    
                    // Switch Notifikasi
                    SwitchListTile(
                      title: const Text('Notifikasi'),
                      subtitle: const Text('Terima notifikasi aplikasi'),
                      value: _isNotifikasi,
                      onChanged: (value) {
                        setState(() {
                          _isNotifikasi = value;
                          _tampilkanSnackbar('Notifikasi: ${value ? "ON" : "OFF"}');
                        });
                      },
                      secondary: const Icon(Icons.notifications, color: Colors.orange),
                    ),
                    
                    // Switch Auto Save
                    SwitchListTile(
                      title: const Text('Auto Save'),
                      subtitle: const Text('Simpan data secara otomatis'),
                      value: _isAutoSave,
                      onChanged: (value) {
                        setState(() {
                          _isAutoSave = value;
                          _tampilkanSnackbar('Auto Save: ${value ? "ON" : "OFF"}');
                        });
                      },
                      secondary: const Icon(Icons.save, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Card Pengaturan Lanjutan
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔧 Pengaturan Lanjutan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    
                    // Slider Volume
                    Row(
                      children: [
                        const Icon(Icons.volume_up, color: Colors.purple),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Volume: $_volume%'),
                              Slider(
                                value: _volume.toDouble(),
                                min: 0,
                                max: 100,
                                divisions: 10,
                                label: '$_volume%',
                                onChanged: (value) {
                                  setState(() {
                                    _volume = value.round();
                                    _tampilkanSnackbar('Volume: $_volume%');
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const Divider(),
                    
                    // Dropdown Bahasa
                    Row(
                      children: [
                        const Icon(Icons.language, color: Colors.teal),
                        const SizedBox(width: 10),
                        const Text('Bahasa: '),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedLanguage,
                            isExpanded: true,
                            onChanged: (value) {
                              setState(() {
                                _selectedLanguage = value!;
                                _tampilkanSnackbar('Bahasa: $_selectedLanguage');
                              });
                            },
                            items: _languages.map((lang) {
                              return DropdownMenuItem(
                                value: lang,
                                child: Text(lang),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Card Status
            Card(
              elevation: 2,
              color: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '✅ Branch: feature/settings-logic | Siap di-Pull Request',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi logika untuk menampilkan snackbar
  void _tampilkanSnackbar(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.blue,
      ),
    );
  }
}