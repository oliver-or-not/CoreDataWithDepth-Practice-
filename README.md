# CoreDataWithDepth-Practice-
깊이가 있는 데이터 모델을 코어 데이터로 다루고 뷰에 실시간으로 표시합니다.</br></br>
CoreDataPractice231005App.swift 파일에서 두 가지 MainView 중 하나를 선택하고 실행할 수 있습니다.</br></br>
MainView_FetchFunction 및 이것에서 이어지는 뷰들은 화면을 업데이트해야 할 때마다 fetch 함수를 실행하는 방식입니다.</br>
이 프로젝트에서는 뷰모델을 만들지 않았지만, 이러한 방식은 MVVM 구조에서 사용할 수 있다는 장점이 있습니다.</br>
* CoreData를 MVVM에서 사용할 때 참고할 만한 영상: https://www.youtube.com/watch?v=BPQkpxtgalY</br></br>


MainView_FetchedResults 및 이것에서 이어지는 뷰들은 @FetchRequest() 프로퍼티 래퍼를 사용합니다.</br>
데이터 모델에 변화가 있으면 화면이 자동으로 업데이트된다는 장점이 있습니다.</br>
