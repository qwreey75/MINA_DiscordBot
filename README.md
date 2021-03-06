
**주의 : 이 저장소는 운영중인 미나 봇에 대한 기여만을 상정합니다, 이 저장소를 통해 미나의 사설서버를 운영하는것은 허용하지 않습니다**  
따라서 라이선스가 존재하지 않으며, 이를 부정 사용시에는 법적인 처벌을 받을 수 있습니다  

# MINA_DiscordBot

실험 / 재미 / 교육 (공부) 목적으로 만들어진 프로젝트 미나 디스코드 봇 ([초대링크](https://discord.com/oauth2/authorize?client_id=828894481289969665&permissions=412429446208&scope=bot%20applications.commands))  

지원  
- 상아리 : 프로필 제작, 아이디어 제공  
- 눈송이 : 작명, 아이디어 제공, 협업 개발  
- 팥죽 : 아이디어 제공  
그외 등등...  

:: 미나 추가하려 했던것 (하고있는것) 
플리 저장하는거 (ear 에서 영감)
음악 현재재생 같은거 띄우는 방 따로 만들기
금지어 기능 (있으면 알아서 지우는거)

# 설정
아래의 커맨드를 입력합니다 (리눅스 전용)  
```sh
mkdir data;mkdir data/interactionData;mkdir data/serverData;mkdir data/userData;mkdir data/userLearn;mkdir data/youtubeCache;mkdir data/youtubeFiles;touch data/userLearn/index;touch data/ACCOUNT_test.json;touch data/ACCOUNT.json;printf "[]" > data/lastMusicStatus.json;printf "[]" > data/loveLeaderstatus.json
```
그런 다음 ACCOUNT.json 을 편집합니다, 형식은 다음과 같습니다  
```jsonc
{
    "ReportWebhooks": [
        // 문의 기능을 위한 디스코드 웹훅 목록입니다, 문자열로 모두 입력합니다
    ],
    "botToken": "", // 봇이 돌아갈 토큰입니다, BOT 프리픽스는 필요 없습니다
    "naverClientId": "", // 네이버 API 클라이언트 아이디입니다
    "naverClientSecret": "", // 네이버 API 클라이언트 시크릿입니다 , 사전 기능에서 사용됩니다
    "InvLink": "https://discord.com/oauth2/authorize?client_id=828894481289969665&permissions=412429446208&scope=bot%20applications.commands", // 초대 링크입니다, 직접 바꾸시면 됩니다
    "BirthdayDay": 1617793730, // 이 봇이 탄생한 날자를 유닉스 시간대로 기록한것입니다, GMT+9 를 따릅니다
    "GoogleAPIKey": "", // 유튜브 API 를 사용할 수 있는 구글 API 키입니다
    "covid19Client": "", // 공공데이터포탈에서 발급받은 코로나 19 상황 API 의 키입니다
    "ApexLegendsApiKey": "" // 에이펙스 공식 API 에서 발급받은 API 키입니다
}
```
ACCOUNT_test.json 의 경우 테스트모드 (luvit app test) 로 실행했을 때 ACCOUNT.json 의 값을 덮어쓰는데 사용됩니다. 즉 테스트 모드에서 다른 토큰으로 로그인하도록 설정할 수 있습니다.  

이제 [luvit](https://github.com/truemedian/luvit-bin) 을 받고 `/user/bin` 이나 `C:\Windows` 처럼 Path 로 인식할 수 있는 곳에 luvit 바이너리 파일을 넣고.  mina 폴더 안에서 `luvit app` 을 쳐주시면 돌아갑니다  

Debug 모드를 켜려면 `luvit app test` 쓰면 됩니다 이러면 ACCOUNT_test.json 의 값을 ACCOUNT.json 의 값보다 우선순위를 둔채로 실행합니다  

# 종속성/사용 라이브러리
[Actknowledge](./docs/Actknowledge.md) 를 확인하세요  

# 기여 도움말
[Contributor](./docs/Contributor.md) 를 확인하세요  

# 실행 인자
[RunArgs](./docs/RunArgs.md) 를 확인하세요  
