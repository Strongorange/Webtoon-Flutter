# webtoon

A new Flutter project.

## pub.dev

npm 같은 존재

## Future

당장 완료될 수 있는 작업이 아닌 것.  
JS같이 async, await로 처리

## Uri.parse

왜 사용할까? 굳이?

## jsonDecode

Json으로 변환시켜주는 메소드

## named constructor

클래스 생성자를 직접 정의해서 사용할 수 있음
`webtoon_model.dart`

```dart
class WebtoonModel {
  final String title, thumb, id;

  /// named constructor
  WebtoonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
}
```

`일반 생성자를 사용할 경우`

```dart
class WebtoonModel {
  /// late키워드 추가
  late final String title, thumb, id;

  /// normal constructor
  WebtoonModel(Map<String, dynamic> json){
    title = json['title'],
    thumb = json['thumb'],
    id = json['id'];
  }
}
```

## Future Builder

### stateless widget에서 데이터 처리

Data처리를 위해서 stateful widget을 사용해야할 필요가 없다.  
Future Builder를 사용하면 setState, isLoading, async await 등을 사용하지 않고 stateless widget에서도 데이터를 처리할 수 있다.

`statelessWidget에서 Future Builder 사용`

```dart
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Future<List<WebtoonModel>> webtoons = ApiService().getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 2,
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Text('data');
          } else {
            return const Text('Loading');
          }
        },
      ),
    );
  }
}
```

body의 `FutureBuilder`는 `future`와 `builder`를 필수로 가진다.  
`future`는 `Future`를 반환하는 함수를 넣어주고, `builder`는 `context`와 `snapshot`을 받는 함수를 넣어준다.  
`snapshot`은 `future`의 결과를 담고있고 `context`는 `builder`의 context이다.

### stateful widget에서 데이터 처리

`stateful widget`에서도 당연히 사용 가능하다.
하지만 `stateful widget`에서는 State를 담당하는 클래스와 클래스의 변수들을 가진 클래스가 분리되어있기 때문에 `stateful widget`에서는 `state`를 통해 `Future`를 처리해야한다.

```dart

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

  @override
  void initState() {
    /// late로 선언해둔 변수에 값을 할당한다.
    super.initState();

    /// widget.xxx 을 사용해서 DetailScreen Class의 변수에 접근할 수 있다.
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
  }
```

`DetailScreen` 클래스에서 `title, thumb, id`값을 받아오고 `_DetailScreenState` 클래스에서 `late` 키워드를 사용하여 `webtoon`과 `episodes`를 선언한다.  
`late` 키워드를 사용하는 이유는 생성자 부분에서 `id`에 접근할 수 없기 때문이다. `DetailScreen` 클래스의 값에 접근하기 위해서 `widget.xxx`을 사용한다.

`initState`에서 `webtoon`과 `episodes`에 값을 할당하고 이를 아래의 build 메소드 안의 `Future Builder`에서 사용한다.

```dart
FutureBuilder(
            future: webtoon,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
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
                  ),
                );
              } else {
                const Text('...');
              }
              return const Text('...');
            }),
          ),
```

## ListView && ListView.builder && ListView.separated

`ListView`는 `ListView.builder`의 부모이다.  
`ListView.builder`는 `ListView`의 `children`을 `builder`로 대체한 것이다.
`ListView.separated`는 `ListView.builder`의 `separatorBuilder`를 추가한 것이다. 이를 통해 아이템 사이에 Separator를 추가할 수 있다.

## Navigator.push

화면 이동을 `Navigator`를 통해 이동할 수 있다. push는 `(context, route)`를 받는다.  
route는 `MaterialPageRoute`를 통해 생성할 수 있다. `MaterialPageRoute`는 `builder`를 통해 `Widget`을 반환한다.

```dart
Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailScreen(title: title, thumb: thumb, id: id)),
        );

```

`MaterialPageRoute`는 `builder`를 통해 `Widget`을 반환해 위젯을 새로운 화면으로 이동시킬 수 있다.

## Hero

`Hero`는 `tag`와 `child`를 필수로 가진다. `tag`는 `Hero`를 구분하기 위한 값이다.  
이렇게 같은 `tag`를 가진 `Hero` 위젯 안의 요소들은 화면이 전환될때 새로 생성되는 것이 아니라 그 자리에서 새로운 위치로 움직이는 것처럼 보이게 된다.

## url_launcher

`url_launcher`는 `url`을 통해 브라우저 앱을 실행시킬 수 있다.
