class Student {
  int? id;
  String? nama;
  String? nim;
  String? mataKuliah;
  double? nilaiUas;
  double? nilaiUts;
  double? nilaiTugas;

  Student({
    this.id,
    this.nama,
    this.nim,
    this.mataKuliah,
    this.nilaiUas,
    this.nilaiUts,
    this.nilaiTugas,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nim': nim,
      'mata_kuliah': mataKuliah,
      'nilai_uas': nilaiUas,
      'nilai_uts': nilaiUts,
      'nilai_tugas': nilaiTugas,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      nama: map['nama'],
      nim: map['nim'],
      mataKuliah: map['mata_kuliah'],
      nilaiUas: map['nilai_uas'],
      nilaiUts: map['nilai_uts'],
      nilaiTugas: map['nilai_tugas'],
    );
  }
}
