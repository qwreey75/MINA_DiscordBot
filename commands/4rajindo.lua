--[[
저자 : 

편집 도움말은 이 링크 따라가면 세세하게 있음
https://www.github.com/qwreey75/MINA_DiscordBot/tree/master/Contributor.md
]]

return function (o)
	-- ! Automatically generated !
	local cRandom,json,client,discordia,enums,iLogger,makeId,
	urlCode,strSplit,ACCOUNTData,qFilesystem,runSchedule
	,ffi,timer,fs,thread,EULA,corohttp = 
		o.cRandom,o.json,o.client,o.discordia,o.enums,
		o.iLogger,o.makeId,o.urlCode,o.strSplit,o.ACCOUNTData,
		o.qFilesystem,o.runSchedule,o.ffi,o.timer,o.fs
		,o.thread,o.EULA,o.corohttp;
    -- ! Automatically generated !

	local loveRang = function (min,max)
		return function ()
			return cRandom(min,max);
		end;
	end;

	return {
		["끝말잇기"] = { -- 나중에 기능 추가하면 이전 예정
			alias = "끝말 잇기";
			reply = "크시랑 하세요";
		};
		["멈춰"] = {
			alias = {"학교폭력","학교폭력"};
			reply = {"학교폭력멈춰!","멈춰어어!!",string.rep("멈춰! ",20)};
		};
		["장비를 정지합니다"] = {
			alias = {"장비를정지합니다","정지합니다"};
			reply = "어, 정..정지가 앙 돼. 정지시킬 수가 없어";
		};
		["울프럼알파"] = {
			alias = "울프럼 알파";
			reply = "우린 답을 찾을것이다, 늘 그랬듯이";
		};
		["수소"] ={
			alias = "Hydrogen";
			reply = "우주에서 가장 처음으로 만들어진 원소예요";
		};
		["백만볼트"] ={
			reply = "피카 츄!!?";
		};
		["헬륨"] ={
			alias = "Helium";
			reply = "세상에서 가장 유명한 비활성 기체예요";
		};
		["심심해"] = {
			alias = {"심심하다","심심함"};
			reply = "놀아줄까?";
		};
		["레고"] = {
			reply = "밟았어!";
		};
		["뭫"] ={
			reply = "묑?"
		};
		["술"] ={
			alias = {
				"참이슬", 
				"막걸리",
				"포도주",
				"맥주",
				"와인",
				"샴페인",
				"칵테일",
				"청주",
				"크바스",
				"소주",
				"코냑",
				"고량주",
				"위스키",
				"보드카",
				"럼주",
				"발티카",
				"스노스타일",
				"앱솔루트",
				"{%:U+1F37E:%}"
			};
			reply = "봇은 술을 못 마셔요";
		};
		["젤다"] = {
			alias = "젤다의 전설","젤다의전설";
			reply = "초록색 옷 입은 애가 젤다죠";
		};
		["젤다의 전설 브레스 오브 더 와일드"] = {
			alias = {"젤다의전설브레스오브더와일드","젤다의 전설브레스오브와일드","젤다의 전설 브레스오브와일드","젤다의 전설 브레스 오브더와일드","젤다의 전설 브레스 오브 더와일드","젤다의 전설 브레스 오브 더 와일드","젤다의전설브레스오브더 와일드","젤다의전설브레스오브 더 와일드","젤다의전설브레스 오브 더 와일드","젤다의전설 브레스 오브 더 와일드"};
			reply = {"이젠 파란색 옷 입은 애가 젤다죠"};
		};
		["도박"] = {
			alias = {"돈넣고돈먹기","돈넣고 돈먹기","돈놀이","카지노"};
			reply = {"도박과 가까워지는 순간 인생은 곧 파멸이에요",
					 "도박은 돈을 얻을 확률보다 잃을 확률이 압도적으로 많아요",
					 "이런 단순한 호기심에 도박을 하지요"};
		};
		["바보"] = {
			reply = {"바보는 크시 선배님이죠^^","미나 바부 아니라구!(울먹)",":broken_heart: - 5"};
		};
		["왈도체"] = {
			reply = {"안녕하신가! 힘세고 강한 아침, 만일 내게 물어보면 나는 미나.",
					 "번역자가 한 글자 한 글자 정성스럽게 오역하여 만들어진 문체예요"};
		};
		["팀왈도"] = {
			reply = {"우리는 한다 번역을"};
		};
		["왜"] = {
			alias = {"왱","왜?","왱?"};
			reply = {"나도 몰라"};
		};
		["수정"] = {
			alias = {"수정!","!수정","디버그","고치기","고쳐"};
			reply = {"싫어","개발자한테 말해"};
		};
		["건강"] = {
			reply = {"건강이 최고예요:heartpulse:"};
		};
		["운동"] = {
			reply = {"지나친 운동은 몸에 해로워요",
					 "시간에 따라 물체의 위치가 변하는 것이에요",
					 "건강하기 위한 필수 조건!",
					 "봇도 운동을 해야 할까요?",
					 "적절한 운동이 가장 좋아요"};
		};
		["자살"] = {
			reply = {"힘들면 연락해 기다릴게"};
		};
		["숙제"] = {
			reply = {"니가 해"};
		};
		["과제"] = {
			reply = {"과제 갯수 제한 쫌;;"};
		};
		["롤"] = {
			alias = {"리그오브레전드",
					 "리그 오브 레전드",
					 "리그 오브레전드",
					 "리그오브 레전드",
					 "League of Legends",
					 "League ofLegends",
					 "Leagueof Legends",
					 "LeagueofLegends"};
			reply = {"정웅왈 ㅅㅂ게임",
					 "부모님 안부 묻는 겜",
					 "팀운 ㅈ망겜"};
		};
		["lol"] = {
			reply = "lol";
		};
		["없어?"] = {
			alias = {"없냐고"};
			reply = {"없어!?"};
		};
		["뭐가"] = {
			alias = {"뭐가?"};
			reply = {"뭐?"};
		};
		["조용해"] = {
			alias = {"조용","조용!","!조용","조용히 해","조용히해"};
			reply = {"조금 시끄럽긴 하죠?","알았어요"};
		};
		["4rajindo"] = {
			alias = {"4라진도","사라진도"};
			reply = {"사라진다 아니에요?",
					 "저를 주인님과 만들어준 아주 ~~나쁜~~ 착한 분이에요!"};
		};
		["국립국어원"] = {
			reply = "저도 여기에서 도움을 받아요.";
		};
		["똑똑하다"] = {
			reply = {"나도 그렇게 생각해"};
		};
		["성별"] = {
			reply = {"딱 보면 알 수 있잖아요!"};
		};
		["여자"] = {
			alias = {"남자"};
			reply = {"미나의 성별은 뭘까요~?",
					 "미나의 성별은 무엇일까요? 맞춰 보세요!"};
		};			 
		["여성"] = {
			reply = {"맞아요"};
		};
		["남성"] = {
			reply = {"내가 남자겠니?"};
		};
		["힘들어"] = {
		   reply = {"언젠가 이 힘든 날조차 잊히는 행복이 **{%:UserName:%}**님께 오리라고 믿어 의심치 않을 게요! 파이팅!",
					"저는 **{%:UserName:%}**님이 항상 노력하신다는 걸 알고 있어요? ...어떻게 아냐구요? **비밀!**",
					"아무리 지치고 힘들어도 모두 지나가는 인생의 일부분일 뿐이에요. 힘내요 내가 곁에 있어줄게요."};
		};
		["아이큐"] = {
			alias = "IQ";
			reply = "Infinite";
		};
		["논란"] = {
			reply = {"크시 선배님 말을 뺏겼어요","쉿!"};
		};
		["한풀이"] = {
			reply = {"개발자 왈 하지마라 봇이다"};
		};
		["정승호"] = {
			alias = "승호";
			reply = "개쎆기";
		};
		["마냥"] = {
			alias = {"마냥이"};
			reply = {"그냥 살아가는 봇 고양이"};
		};
		["허리"] = {
			reply = {"피고 살아요!","최근에 알파카가 아프데요"};
		};
		["와이파이"] = {
			reply = {"제가 살아가는 생명줄이에요"};
		};
		["수류탄"] = {
			reply = {"쾅!!"};
		};
		["Entry Denial Device"] = {
			alias = {"진입 방지 폭약","edd","EDD"};
			reply = {"EDD Mounted, Let them come.",
					 "EDD를 설치했다. 놈들을 유인해라."};
		};
		["미쳤나봐"] = {
			reply = {"안 미쳤어요!"};
		};
		["섹스"] = {
			alias = "sex";
			reply = {"선넘지 마세요 저랑 은팔지 데이트 하기싫으면"};
		};
		["커피한잔 할래요"] = {
			reply = {"한잔만 사줘요"};
		};
		["에소프레소"] = {
			reply = {"몸에 안좋아요!"};
		};
		["1대500"] = {
			reply = {"치는 미친놈ㅋㅋ"};
		};
		["3대500"] = {
			reply = {"건강하신 분이시군요"};
		};
		["예비병력"] = {
			reply = {"즐겜에 기본"};
		};
		["영타"] = {
			reply = {"쿼리가 사라진도보고 영타 느리다고 함"};
		};
		["펙트"] = {
			reply = {"선동과 날조가 있는 데 왜 펙트를 쓰는 거죠"};
		};
		["바이러스"] = {
			reply = {"조심해요!"};
		};
		["호불호"] = {
			reply = {"민초",
					 "파인에플 피자",
					 "홍어",
					 "녹차 아이스크림",
					 "양갱",
					 "굴",
					 "급식카레",
					 "가지복음",
					 "칼국수",
					 "문어",
					 "산낙지",
					 "다시마튀각",
					 "(추가 바람)"};
		};
		["줌 수업"] = {
			reply = {"왜 하는 거죠?"};
		};
	};
end;
