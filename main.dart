import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _mataKuliahController = TextEditingController();
  final TextEditingController _nilaiUasController = TextEditingController();
  final TextEditingController _nilaiUtsController = TextEditingController();
  final TextEditingController _nilaiTugasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UAS Kamaliah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambah Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama')),
            TextField(
                controller: _nimController,
                decoration: InputDecoration(labelText: 'NIM')),
            TextField(
                controller: _mataKuliahController,
                decoration: InputDecoration(labelText: 'Mata Kuliah')),
            TextField(
                controller: _nilaiUasController,
                decoration: InputDecoration(labelText: 'Nilai UAS')),
            TextField(
                controller: _nilaiUtsController,
                decoration: InputDecoration(labelText: 'Nilai UTS')),
            TextField(
                controller: _nilaiTugasController,
                decoration: InputDecoration(labelText: 'Nilai Tugas')),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _databaseHelper.insertStudent({
                      'nama': _namaController.text,
                      'nim': _nimController.text,
                      'mata_kuliah': _mataKuliahController.text,
                      'nilai_uas': double.parse(_nilaiUasController.text),
                      'nilai_uts': double.parse(_nilaiUtsController.text),
                      'nilai_tugas': double.parse(_nilaiTugasController.text),
                    });
                    setState(() {
                      _namaController.clear();
                      _nimController.clear();
                      _mataKuliahController.clear();
                      _nilaiUasController.clear();
                      _nilaiUtsController.clear();
                      _nilaiTugasController.clear();
                    });
                  },
                  child: Text('Tambah'),
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
              'Data Mahasiswa',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _databaseHelper.getStudents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var student = snapshot.data![index];
                        double nilaiKeseluruhan = (student['nilai_uas'] +
                                student['nilai_uts'] +
                                student['nilai_tugas']) /
                            3;
                        return ListTile(
                          title: Text(student['nama']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('NIM: ${student['nim']}'),
                              Text('Mata Kuliah: ${student['mata_kuliah']}'),
                              Text('Nilai UAS: ${student['nilai_uas']}'),
                              Text('Nilai UTS: ${student['nilai_uts']}'),
                              Text('Nilai Tugas: ${student['nilai_tugas']}'),
                              Text(
                                  'Nilai Keseluruhan: ${nilaiKeseluruhan.toStringAsFixed(2)}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Mengisi nilai teks dari TextEditingController dengan data mahasiswa yang dipilih
                                  _namaController.text = student['nama'];
                                  _nimController.text = student['nim'];
                                  _mataKuliahController.text =
                                      student['mata_kuliah'];
                                  _nilaiUasController.text =
                                      student['nilai_uas'].toString();
                                  _nilaiUtsController.text =
                                      student['nilai_uts'].toString();
                                  _nilaiTugasController.text =
                                      student['nilai_tugas'].toString();

                                  // Menampilkan dialog edit
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Edit Mahasiswa'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller: _namaController,
                                                decoration: InputDecoration(
                                                    labelText: 'Nama'),
                                              ),
                                              TextField(
                                                controller: _nimController,
                                                decoration: InputDecoration(
                                                    labelText: 'NIM'),
                                              ),
                                              TextField(
                                                controller:
                                                    _mataKuliahController,
                                                decoration: InputDecoration(
                                                    labelText: 'Mata Kuliah'),
                                              ),
                                              TextField(
                                                controller: _nilaiUasController,
                                                decoration: InputDecoration(
                                                    labelText: 'Nilai UAS'),
                                              ),
                                              TextField(
                                                controller: _nilaiUtsController,
                                                decoration: InputDecoration(
                                                    labelText: 'Nilai UTS'),
                                              ),
                                              TextField(
                                                controller:
                                                    _nilaiTugasController,
                                                decoration: InputDecoration(
                                                    labelText: 'Nilai Tugas'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              // Menyimpan perubahan ke database
                                              await _databaseHelper
                                                  .updateStudent(
                                                      student['id'], {
                                                'nama': _namaController.text,
                                                'nim': _nimController.text,
                                                'mata_kuliah':
                                                    _mataKuliahController.text,
                                                'nilai_uas': double.parse(
                                                    _nilaiUasController.text),
                                                'nilai_uts': double.parse(
                                                    _nilaiUtsController.text),
                                                'nilai_tugas': double.parse(
                                                    _nilaiTugasController.text),
                                              });
                                              Navigator.of(context).pop();
                                              setState(() {});
                                            },
                                            child: Text('Simpan'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Batal'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await _databaseHelper
                                      .deleteStudent(student['id']);
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
