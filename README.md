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
