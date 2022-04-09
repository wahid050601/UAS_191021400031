import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //_get berfungsi untuk menampung data dari internet nanti
  List _get = [];

  //paste apikey yang didapatkan dari newsapi.org
  var apikey = '93873f36c0b84eb3812157c39a968eb1';

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _getData();
  }

  //method untuk merequest/mengambil data dari internet
  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          "https://newsapi.org/v2/top-headlines?country=id&category=business&apiKey=${apikey}"));

      // cek apakah respon berhasil
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          //memasukan data yang di dapat dari internet ke variabel _get
          _get = data['articles'];
        });
      }
    } catch (e) {
      //tampilkan error di terminal
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //menghilangkan debug label
      debugShowCheckedModeBanner: false,
      home: Scaffold(

          //membuat appbar dengan background putih dan membuat tulisan di tengah
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                "UJIAN AKHIR SEMESTER",
                style: TextStyle(color: Colors.black38),
              ),
            ),
          ),
          body: ListView.builder(
            // itemcount adalah total panjang data yang ingin ditampilkan
            // _get.length adalah total panjang data dari data berita yang diambil
            itemCount: _get.length,

            // itembuilder adalah bentuk widget yang akan ditampilkan, wajib menggunakan 2 parameter.
            itemBuilder: (context, index) {
              //padding digunakan untuk memberikan jarak bagian atas listtile agar tidak terlalu mepet
              //menggunakan edgeInsets.only untuk membuat jarak hanya pada bagian atas saja
              return Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),

                //listtile adalah widget yang disediakan flutter berisi 3 properti yang kita pakai
                //properti: leading, title, dan subtitle. di dalam setiap properti kalian bebas melakukan customisasi
                child: ListTile(
                  leading: Image.network(
                    //menampilkan data gamabr
                    _get[index]['urlToImage'] ??
                        "https://cdn.pixabay.com/photo/2018/03/17/20/51/white-buildings-3235135__340.jpg",
                    fit: BoxFit.cover,
                    width: 100,
                  ),
                  title: Text(
                    //menampilkan data judul
                    _get[index]['title'] ?? "No Title",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    //menampilkan deskripsi berita
                    _get[index]['description'] ?? "No Description",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          )),
    );
  }
}
