import 'package:flutter/material.dart';

class DownloadedScreen extends StatefulWidget {
  const DownloadedScreen({super.key});

  @override
  State<DownloadedScreen> createState() => _DownloadedScreenState();
}

class _DownloadedScreenState extends State<DownloadedScreen> {
  @override
  void initState() {
    super.initState();
    /* 
    Lưu ý:
    Khi xoá item trong downloadedFilm
    thì offlineMovies, offlineTvs không bị ảnh hưởng
    */
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
