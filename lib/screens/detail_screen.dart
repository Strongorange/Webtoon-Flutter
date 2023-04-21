import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoon/models/webtoon_detail.dart';
import 'package:webtoon/models/webtoon_episode_model.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen(
      {super.key, required this.title, required this.thumb, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  /// Constructor에서는 id에 접근할 수 없어 late를 사용해 선언만 해둔다.
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  /// SharedPrefrences를 사용해 사용자가 좋아요를 눌렀는지 확인한다.
  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      /// likedToons 저장소가 있는 상황, likedToons에 id가 있는지 확인
      if (likedToons.contains(widget.id)) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      /// 유저가 처음 앱을 여는 상황, likedToons 저장소가 없어 새로 생성
      await prefs.setStringList('likedToons', []);
    }
  }

  /// 사용자가 좋아요를 눌렀을 때 호출되는 함수
  void onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        /// 좋아요를 누른 상태에서 누르면 좋아요를 취소한다.
        likedToons.remove(widget.id);
      } else {
        /// 좋아요를 누르지 않은 상태에서 누르면 좋아요를 추가한다.
        likedToons.add(widget.id);
      }

      /// likedToons 저장소 상태를 변경한다.
      await prefs.setStringList('likedToons', likedToons);

      /// isLiked 상태를 변경하고 렌더링한다.
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  void initState() {
    /// late로 선언해둔 변수에 값을 할당한다.
    super.initState();

    /// widget.xxx 을 사용해서 DetailScreen Class의 변수에 접근할 수 있다.
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);

    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon:
                Icon(isLiked ? Icons.favorite_rounded : Icons.favorite_outline),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            offset: const Offset(2, 3),
                            color: Colors.black.withOpacity(0.4),
                          )
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      width: 180,
                      child: Image.network(widget.thumb),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: webtoon,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "${snapshot.data!.genre} / ${snapshot.data!.age}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  } else {
                    const Text('...');
                  }
                  return const Text('...');
                }),
              ),
              const SizedBox(height: 30),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(episode: episode, webtoonId: widget.id)
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
