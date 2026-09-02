프로젝트 전용 라이브러리를 폴더 단위로 둡니다.

```
lib/
└─ AttitudeEstimator/
   ├─ AttitudeEstimator.h
   └─ AttitudeEstimator.cpp
```

PlatformIO가 자동으로 인식해 빌드에 포함합니다.
외부 공개 라이브러리는 여기 복사하지 말고 `platformio.ini`의 `lib_deps`에 적으세요 (버전이 기록되어 두 PC에서 동일하게 재현됩니다).
