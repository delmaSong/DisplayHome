# READ ME
- minimum target: iOS 14.0
- RxSwift / ReactorKit

## 기능
API가 제공하는 데이터를 타입에 따라 표시하는 UI 구현

### 네트워크
- `APIRouter`: 네트워크 요청 정보 담은 객체
- `NetworkDispatcher`: URLSession을 이용해 서버로 요청을 보내고 응답 받는 객체

### 디자인 시스템
- [Resource](https://github.com/delmaSong/MusinsaResources)라는 재사용 가능한 외부 모듈로 분리
- `Resource.Color`, `Resource.Font` 정의

### UI구현
- `HomeViewController` 내에 `UICollectionView` 존재
- Compositional Layout을 이용해 각 `DisplaySection`에 따라 `UICollectionView` 내의 `section`이 생성되도록 함
- `DisplaySection`내에 `header`, `footer`가 존재하는지 여부를 파악해 각각의 `section`에 `supplementaryView`가 추가되도록 함
