import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalSaldo = 0;
  List<Map<String, dynamic>> _riwayatPengeluaran = [];

  @override
  void initState() {
    super.initState();
    _muatDataLokal();
  }

  Future<void> _muatDataLokal() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('riwayat') ?? <String>[];
    if (!mounted) return;

    setState(() {
      _totalSaldo = prefs.getInt('total_saldo') ?? 0;
      _riwayatPengeluaran = data
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> _simpanDataLokal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_saldo', _totalSaldo);
    await prefs.setStringList(
      'riwayat',
      _riwayatPengeluaran.map(jsonEncode).toList(),
    );
  }

  bool _tambahPengeluaran(String judul, int nominal) {
    final keterangan = judul.trim();
    if (keterangan.isEmpty || nominal <= 0) return false;
    if (nominal > _totalSaldo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo tidak cukup.')),
      );
      return false;
    }

    setState(() {
      _totalSaldo -= nominal;
      _riwayatPengeluaran.insert(0, {
        'judul': keterangan,
        'nominal': nominal,
        'tanggal': DateTime.now().toString().substring(0, 10),

      });
    });
    _simpanDataLokal();
    return true;
  }

  void _tampilkanModalInput() {
    final judulController = TextEditingController();
    final nominalController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tambah Pengeluaran', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: judulController,
              decoration: const InputDecoration(
                labelText: 'Keterangan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nominalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal (Rp)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final nominal = int.tryParse(nominalController.text) ?? 0;
                  if (_tambahPengeluaran(judulController.text, nominal)) {
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Simpan Pengeluaran'),
              ),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      judulController.dispose();
      nominalController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SakuSiswa Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.teal.shade700,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Sisa Uang Saku Saat Ini',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp $_totalSaldo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() => _totalSaldo += 50000);
                        _simpanDataLokal();
                      },
                      icon: const Icon(Icons.add_card, color: Colors.white),
                      label: const Text(
                        'Isi Uang Saku (+Rp50.000)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Riwayat Pengeluaran',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _riwayatPengeluaran.isEmpty
                  ? const Center(child: Text('Belum ada pengeluaran.'))
                  : ListView.builder(
                      itemCount: _riwayatPengeluaran.length,
                      itemBuilder: (context, index) {
                        final item = _riwayatPengeluaran[index];
                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.shopping_bag_outlined),
                            ),
                            title: Text(item['judul'] as String),
                            subtitle: Text(item['tanggal'] as String),
                            trailing: Text('- Rp ${item['nominal']}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tampilkanModalInput,
        icon: const Icon(Icons.remove_circle_outline),
        label: const Text('Catat Pengeluaran'),
      ),
    );
  }
}