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
