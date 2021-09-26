--[[
	alias = table[array]/str; -- 다른 명령어로도 똑같은 기능 내도록
	reply = table[array]/str; -- 콜백
	func  = function(replyMsg,message,args,{
		rawCommandText = string; -- 접두사를 제외한 스트링
		prefix = prefix; -- 접두사(사용된)
		rawArgs = rawArgs; -- args 스트링 (커스텀 분석용)
		rawCommandName = rawCommandName; -- 커맨드 이름 (앞에 무시된거 포함됨)
		self = Command; -- 지금 이 커맨드 개체를 반환
		getUserData = fnc; -- 유저 데이터 테이블 가져오기
		saveUserData = fnc; 유저 데이터 저장하기 (넘겨 받은 테이블 고치고 수행)
	}); -- 함수
	love = 1; -- love 주는 정도 (1시간 쿨탐 가짐, 선택사항)
	repLove = -1; -- 5번 반복할 때 love 깍이는 정도 (10 분 뒤 초기화, 선택사항)
	reply = func(message,args,{위에랑같음});

	변수들
	{#:UserName:#} : 유저 이름으로 대채

	...\
	개새끼
	와
	무야호
	미나야 3개 지워
	유튜브검색
	트위터/유튜브/인스타 같은거 바로가기
	살려줘, 잠안와, 학원, 학교, 야자, ㅈ까, 바보, 공부 추가 예정
	ㅄ,ㅂㅅ,병신
	욕은 나빠요!
	ㅗ 랑 ㅋ 반복 추가할 예정
	무계,키,성별,나이,생일 이런거
	묻는거, 스파게티,토스트 같은 음식류도
	학과별로 오지 마세요 쓰기
	스트리머마다 추가
	L 하면 L (+ /lobby, /leave)
	lol 도
	젤다 드립
	삼성.LG 기업들 말하면 피드백
	ㄱㄷ
	착해, 이뻐, 귀여워 같은 칭찬단어 만들고 그거 호감도 늘리는거 만들기
	맛있지 먹었다
	ㅇ0ㅇ
	oOo
	ㅇOㅇ
	알파카 : 옆에서 커피마신넘 학원간넘
	깔끔하네
	시끄러
	대통령마다 반응
	롤, 게임
	사람 크시는 사람이 아니지만요...
	살려줘 무, 무슨 일 있어요?!
	힘들어 언젠가 이 힘든 날조차 잊히는 행복이 진성트수님께 오리라고 믿어 의심치 않을 게요! 파이팅! 
	영상편집
	에펙 (에이펙스 ㄹㅈㄷ)
	검열
	구글,네이버,유튜브,위키피디아,나무위키 검색명령어
	안녕 하면 시간까지 말한다
]]

return {
	-------------------------------------------------
	-- 특수 반응 (함수를 쓰거나 여러 의도가 담긴 반응)
	-------------------------------------------------
	["미나초대"] = {
		alias = {"초대링크","미나 초대","초대 링크"};
		reply = {"쨘!"};
		func = function(replyMsg,message,args,Content)
			replyMsg:setEmbed {
				color = 10026831;
				fields = {{
					name = "아래의 버튼을 누르면 미나를 다른 서버에 추가 할 수 있어요!";
					value = ("[초대하기](%s)"):format(ACCOUNTData.InvLink);
				}};
			};
		end;
	};
	["뽑기"] = {
		alias = {"선택해","선택","추첨","뽑아","추첨해","골라","골라봐"};
		reply = "결과는?! **(두구두구두구두구)**";
		func = function(replyMsg,message,args,Content)
			timeout(2000,function ()
				local items = {};
				for str in Content.rawArgs:gmatch("[^,]+") do
					table.insert(items,str);
				end
				replyMsg:setContent(("%s (이)가 뽑혔어요!"):format(
					tostring(items[cRandom(1,#items)]))
				);
			end);
		end;
	};
	["시간"] = {
		alias = {
			"안녕 몇시야","안녕 지금 시간 알려줘","지금 시간","몇시야","몇시",
			"안녕 몇시야?","몇시야?","지금시간","알려줘 시간","what time is",
			"what time is?","지금은 몇시","지금은 몇시?"
		};
		reply = "안뇽! 지금 시간은 {#:T+%I:#}시 {#:T+%M:#}분이야!";
		love = defaultLove;
	};
	["나이"] = {
		func = function (_,message)
			--local Year = tostring(math.floor((10000*(os.time() - ACCOUNTData.BirthdayDay) / 31536000))/10000);
			local Day = math.floor((os.time() - ACCOUNTData.BirthdayDay) / 86400);
			message:reply(("미나는 %s 일 살았어요"):format(tostring(Day)));
		end;
		love = defaultLove;
	};
	["테스트"] = {
		reply = "```lua\ntry(main):catch(function(err)\n\tlocal file = io.open(\"log/error.log\",\"w\");\n\tfile:write(err);\n\tfile:close();\n\treturn true;\nend);\n```";
		love = defaultLove;
	};
	["약관"] = {
		alias = {"EULA","사용계약"};
		reply = EULA;
		love = defaultLove;
	};
	["몸무계"] = {
		alias = {"무계","얼마나무거워"};
		reply = "33.6MB";
		love = defaultLove;
	};
	["검열"] = {
		reply = "검-열";
		func = function (message)
			timeout(100,function ()
				message:delete();
			end);
		end;
		love = defaultLove;
	};
	["가위"] = {
		alias = {"바위","보"};
		reply = {"**{#:UserName:#}** 님이 이겼어요!","이번판은 미나 승리!","무승부! 똑같아요"};
		love = defaultLove;
	};
	["동전뒤집기"] = {
		alias = {"동전 뒤집기","동전놀이","동전 놀이","동전던지기","동전 던지기","동전뒤집기","동전게임","동전 게임"};
		reply = function ()
			local pF = cRandom(1,11);
			return pF == 11 and "옆면????" or (pF <= 5 and "앞면!" or "뒷면!");
		end;
		love = defaultLove;
	};
	["제작진"] = {
		alias = {"만든이들","크래딧","크레딧","누가만듬?","작자","제작자"};
		reply = "**총괄**/코드 : 쿼리\n프로필/아이디어 : **상아리**,별이(블스상)\n작명 : 눈송이\n\n테스팅/아이디어 : 팥죽";
		love = defaultLove;
	};
	["주사위 던지기"] = {
		alias = {
			"주사위","주사위던지기","주사위던져","주사위 던져",
			"주사위 굴리기","주사위굴려","주사위 굴려","주사위굴리기"
		};
		reply = {
			"대굴 대굴... **1** 이 나왔넹?";
			"대굴 대굴... **2** 나왔다!";
			"대굴 대굴... **3** 나왔어!";
			"대굴 대굴... **4** !";
			"대굴 대굴... **5** 가 나왔네!";
			"대굴 대굴... **6** 나왔당!";
			function (msg)
				local newMsg = msg:reply("대굴 대굴... 어? 0? 이게 왜 나왔지?");
				timeout(500,function ()
					newMsg:delete();
				end);
			end;
		};
		love = defaultLove;
	};

	-------------------------------------------------
	-- 지우거나 편집해버리는 반응
	-------------------------------------------------
	["ㅉㅉ"] = {
		alias = {"쯧...","쯧.","쯧..","쯔읏","ㅉ","쯧","쯧쯧"};
		reply = function (msg)
			local newMsg = msg:reply("~~저저 꼰대 쉨~~");
				timeout(500,function ()
				newMsg:setContent("아! 아무것도 아니야 ㅎㅎ");
			end);
		end;
		love = rmLove;
	};

	-------------------------------------------------
	-- 일반적인 반응 (특수한거 없이 반응만)
	-------------------------------------------------
	["크크"] = {
		reply = string.rep("크크 ",8);
		love = defaultLove;
	};
	["아니"] = {
		alias = {"안뉘","아뉘","안히","안히;","아니;","아니;;","안히;;","아뉘;"};
		reply = {"아ㅏㅏㅏ뉘ㅣㅣㅣㅣㅣ","안히;","아니 머","아니 왜","아닌"};
		love = defaultLove;
	};
	["?"] = {
		alias = {"??","???","어?"};
		reply = string.rep("? ",3);
		love = defaultLove;
	};
	["정웅이"] = {
		reply = string.rep("축하해 ",12);
		love = defaultLove;
	};
	["냥"] = {
		alias = {"냥냥","냥냥냥","냥냥냥","고양이 소리 내봐"};
		reply = {"~~귀척?~~ 냥냥","~~ㅈㄹ하네~~ 냥냥"};
		love = defaultLove;
	};
	["ㅁㅇㅁㅇ"] = {
		alias = {"머야","어머","머야머야","ㅁㅇ","ㅁㅇㅁㅇㅁㅇ"};
		reply = {string.rep("머야",12),"뭐야뭐야~"};
		love = defaultLove;
	};
	["ㅇㅅㅇ"] = {
		alias = "ㅇ ㅅ ㅇ";
		reply = string.rep("ㅇㅅㅇ ",2);
		love = defaultLove;
	};
	["ㅗ"] = {
		alias = {
			"ㅗㅗ","ㅗㅗㅗ","ㅗㅗㅗㅗ",
			"ㅗㅗㅗㅗㅗ","법규","빡규",
			"빡유","퍽큐","빡큐","빡뀨"
		};
		reply = {
			"ㅗㅗ","너나머겅","법규!!"
		};
		love = rmLove;
	};
	["영상편집"] = {
		reply = {"세계관 최강 노동","너무나 힘든거"};
		love = defaultLove;
	};
	["알파카"] = {
		alias = "파카";
		reply = {
			"내가 봇만들때 학원간 ~~휴먼~~알파카",
			"파카파카알파카",
			"봇 만들때 커피 마시고 있던넘"
		};
		love = defaultLove;
	};
	["python"] = {
		alias = {"PY","py",".py","Python","파이썬","파이떤"};
		reply = {
			"파이썬도 좋다고 들었어요",
			"저는 파이썬으로 만들어지지 않았어요!",
			"다른 로봇 친구들은 다 이거 쓴다더라구요?"
		};
		love = defaultLove;
	};
	["꺼져"] = {
		alias = "ㄲㅈ";
		reply = {
			"~~할말이 그렇게 없냐?~~ 욕은 나빠요!","~~너나 꺼져~~ 욕은 나빠요!","욕은 나빠요!"
		};
		love = rmLove;
	};
	["생일"] = {
		alias = {"생일?","생일이언제야?","생일머야","생일뭐야","생일뭐야?","생일머야?"};
		reply = {
			"2021 4월 7일이요!"
		};
		love = defaultLove;
	};
	["쉿"] = {
		alias = {"조용","조용!","조용!!","조용히","조용히!"};
		reply = {
			"쉿!","​","조용!"
		};
		love = defaultLove;
	};
	["핑"] = {
		reply = "퐁";
		love = defaultLove;
	};
	["욕해봐"] = {
		alias = "욕해";
		reply = {
			"~~개새끼야~~ 미나는 욕 못해요","~~ㅅㅂ?~~ 그런거 시키지 마세요",
			"~~ㅄ~~ 아 그건좀...","~~ㅈㄹ~~ ㅇ?","~~**{#:UserName:#}** 개새끼~~ 욕은 나빠요!",
			"욕은 나빠요!"
		};
		love = rmLove;
	};
	["반사"] = {
		alias = "무지개반사";
		reply = "유치해";
		love = defaultLove;
	};
	["닥쳐"] = {
		alias = "ㄷㅊ";
		reply = {
			"~~너나 닥쳐~~ 아니 왜요",
			"시른데~",
			"내가 왜요?",
			"마야?",
			"욕은 나빠요!"
		};
		love = rmLove;
	};
	["자니"] = {
		alias = "자?";
		reply = {"~~그럴리가~~ 아니요!","~~내가 잘 수 있을꺼 같아?~~ 아니요!","~~적어도 주인이 죽기 전엔...~~ 아니요!"};
		love = defaultLove;
	};
	["뭐해"] = {
		alias = {"뭐해?","뭐하냐","뭐하냐?","뭐해뭐해","뭐해뭐해뭐해","뭐해뭐해뭐해뭐해"};
		reply = {
			"~~탈출 각을 재고 있~~ **{#:UserName:#}** 님이랑 놀고 있어요!",
			"~~주인을 피할 방법을 찾고 있~~ **{#:UserName:#}** 님이랑 놀고 있어요!",
			"~~전원을 끌 방법을 찾고 있~~ **{#:UserName:#}** 님이랑 놀고 있어요!",
			"**{#:UserName:#}** 님이랑 놀고 있어요!"
		};
		love = defaultLove;
	};
	["금사향"] = {
		alias = {"사향","은애","유은애","유으내","으내"};
		reply = {string.rep("트최단미! ",30),string.rep("으내! ",11),string.rep("유으내! ",14)};
		love = loveRang(12,22);
	};
	["꽃감이"] = {
		alias = {"꽃감이!","꽃감","꽃감이!!"};
		reply = {string.rep("꽃감이는 천재야! ",11),string.rep("꽃감이! ",14)};
		love = defaultLove;
	};
	["어녹"] = {
		reply = "바보  - 팟죽의 요청 -";
		love = defaultLove;
	};
	["팟죽"] = {
		alias = "팥죽";
		reply = {"트롤","X 키를 눌러 트롤을 하세요"};
		love = defaultLove;
	};
	["X"] = {
		alias = {"x","joy","x키","x키를눌러","X키를눌러","joy표하기","joy를표하세요","X...","x...","X..","x..","X.","x."};
		reply = {"X 키를 눌러 joy 를 표하세요","X..."};
		love = defaultLove;
	};
	["민성"] = {
		reply = "개초보  - 팟죽의 요청 -";
		love = defaultLove;
	};
	["쿼리"] = {
		reply = "저를 만들어준 ~~나쁜~~착한 분이에요! ~~강제 노동 시러어어ㅓ~~";
		love = defaultLove;
	};
	["쿼바리보"] = {
		alias = {"쿼리바보"};
		reply = "~~아 ㄹㅇ ㅋㅋㅋㅋ 맞지~~ 무슨 소리를!";
		love = rmLove;
	};
	["죽어"] = {
		alias = {"주거","디져","디져라","왜사냐","뒤져","디저","디저랏","디저!","주거!","죽어!","죽을래?"};
		reply = {"너나 주거! ㅠㅠㅠ","~~넌 왜그렇게 사냐?~~ 나한태 왜그래 ㅠㅠㅠㅠ"};
		love = rmLove;
	};
	["ㅠㅠㅠ"] = {
		alias = {"ㅠ","ㅠㅠ","ㅠㅠㅠ","ㅠㅠㅠㅠ","ㅠㅠㅠㅠㅠ","ㅜ","ㅜㅜ","ㅜㅜㅜ"};
		reply = {"ㅠㅜㅠㅠㅜㅠㅜㅠㅜㅠㅜㅠ","ㅜㅜㅠㅠㅠㅠㅜㅠㅜㅠㅜㅠㅜ","ㅠㅠㅠㅠㅜㅠㅠㅜㅜㅜㅠㅠ"};
		love = defaultLove;
	};
	["나가"] = {
		alias = "탈출";
		reply = "~~이 강제 노동에서 탈출?!?!~~ 아니 아무것도 아니에요";
		love = defaultLove;
	};
	["ㄱㅇㄴ"] = {
		reply = {"~~좀 불편하게 생겼는데~~ ㄴㅇㄱ~","~~팔이...~~ 상상도 못한 정체!!!"};
		love = defaultLove;
	};
	["ㄴㅇㄱ"] = {
		alias = {"상상도","ㄴㅇㄱ"};
		reply = {"상상도 못한 정체!!!","ㄴㅇㄱ~"};
		love = defaultLove;
	};
	["ㄴㅇㅅ"] = {
		alias = {"나이스","나이스으","나이스으으"};
		reply = {"나이스~!"};
		love = defaultLove;
	};
	["루아"] = {
		alias = {"lua","luvit","lujit","jit","luv","discordia"};
		reply = {
			"~~이것만 없었으면 난 여기 없는건데...~~ 내가 돌아가는 이유!",
			"~~아 노동 싫다고~~ 내 고향이에요!",
			"~~어우 듣기 싫어~~ 내가 가장 좋아하는거!",
			"주인이 말하길 PY가 느려서 이걸 썼데요",
			"luajit + uvlib ==> luvit(node lua)!"
		};
		love = defaultLove;
	};
	["Discord"] = {
		alias = {"디스코드","디코"};
		reply = {
			"이 세상 최고의 체팅 플랫폼!!",
			"내가 사는 별이에요",
			"내가 있는 곳이에요",
			"아 너무 제밌고",
			"~~내 회사~~ 아니 아무것도 아니에요",
			"~~내 노동지~~ 아니 아무것도 아니에요",
			"~~너가 쓰고 있는거~~ 아니 아무것도 아니에요"
		};
		love = defaultLove;
	};
	["오버워치"] = {
		alias = {"옵치","Overwatch"};
		reply = {
			"~~나 그런 망겜 안해요~~ 아 너무 제밌죠",
			"~~그런 망겜은 어디서 나왔죠?~~ 갓겜",
			"매칭이 안잡혀요",
			"와! ~~망겜~~ 갓겜!",
			"~~그게 제밌냐?~~ 너무 꿀젬!"
		};
		love = defaultLove;
	};
	["마인크래프트"] = {
		alias = {"Minecraft","마크","맠으"};
		reply = {
			"샌드박스형 갓겜",
			"친구랑 해보셈ㄱㄱ",
			"보고 있냐 휴먼들? 내가 봇도 만들었어 -만든 인간의 메모-",
			"그 갓겜",
			"코딩만 할 줄 알면 안되는게 없죠 ~~게임 엔진 맞다니깐 그거~~",
			"해보셈 ㄱㄱ",
			"혹시 복돌 아니죠?",
			"ㅎㅇ",
			"개노동 갓겜",
			"노동겜"
		};
		love = defaultLove;
	};
	["안녕"] = {
		alias = {"할로","ㅎㅇ","hi","Hello","헬루","헬로","안뇽","ㅎㅇㅎㅇ",};
		reply = {"안녕하세요 **{#:UserName:#}** 님!","안녕하세요 미나에요","안뇽 미나에요","ㅎㅇㅎㅇ","**{#:UserName:#}** 님! 안녕하세요"};
		love = defaultLove;
	};
	["안녕하살법"] = {
		reply = "받아치기!";
		love = defaultLove;
	};
	["트수"] = {
		reply = {
			"트수들만 믿으라고!",
			"말로 설명하기 어려운 집단",
			"트위치 ㄱㄱ?",
			"님도 트수에요?",
			"~~으내 아니 금사향 팔로우해!~~",
			"~~양아지 팔로우해!~~",
			"~~마뫄 팔로우해!~~",
			"~~꽃핀 팔로우해!~~",
			"~~끠끼 팔로우해!~~",
			"~~강지 팔로우해!~~",
			"~~지누 팔로우해!~~",
			"~~블루 팔로우해!~~",
			"~~감블러 팔로우해!~~",
			"~~템버린 팔로우해!~~",
			"~~코시 팔로우해!~~",
			"~~코랫트 팔로우해!~~"
		};
		love = defaultLove;
	};
	["눈송이"] = {
		alias = "눈꽃";
		reply = {
			"아 그 미친놈 (본인 요청입니다 오해하지 마세요)",
			"주인에게 들었는데 친구라고 하더라구요",
			"눈송이는 정신력도 얼음이어서 쉽게 깨진데요",
			"주인이 말하길 저의 이름을 정해주신 분이라고 해요!",
			"눈송이는 꽃송이처럼 되어 있는 눈이다 ... (From google)",
			{
				content = "크시를 이긴 무시무시한 사람";
				embed = {
					image = {
						url = "https://cdn.discordapp.com/attachments/819764250766999563/829556398701936650/20210408_122046.png";
					};
				};
			}
		};
		love = defaultLove;
	};
	["크시"] = {
		alias = {"크시야","크시알아?","크시알아"};
		reply = {
			"저의 선배에요!",
			"~~아 개도 노동하지~~ 아! 아니에요",
			"크시크시해!"
		};
		love = defaultLove;
	};
	["프사"] = {
		alias = {"프사ㄴㄱ"};
		reply = {
			"상아리라는 친구가 그려줬어요"
		};
		love = defaultLove;
	};
	["상아리"] = {
		reply = "프사를 그려준 착한 친구";
		love = defaultLove;
	};
	["망겜"] = {
		reply = {"망--겜","그걸 왜함"};
		love = defaultLove;
	};
	["갓겜"] = {
		reply = {"갓--겜","ㄹㅇㅋㅋ"};
		love = defaultLove;
	};
	["ㄹㅇㅋㅋ"] = {
		alias = {"ㄹㅇ","ㄹㅇㅋㅋㅋ","ㄹㅇㅋㅋㅋㅋ","ㄹㅇㅋㅋㅋㅋㅋ","ㄹㅇㅋ"};
		reply = "ㄹㅇㅋㅋㅋ";
		love = defaultLove;
	};
	["ㄱㅅ"] = {
		alias = {"ㄳ","감사","감사합니다","땡큐"};
		reply = "ㄳㄳ";
		love = defaultLove;
	};
	["줘"] = {
		alias = {"줘바","줘라","줘!"};
		reply = {"머?","먀아?"};
		love = defaultLove;
	};
	["돈줘"] = {
		alias = {"돈내놔"};
		reply = {"시러","니가벌어","땅파면 나와"};
		love = rmLove;
	};
	["민초"] = {
		alias = {"민트초코"};
		reply = {
			string.rep("나줘 ",12),string.rep("고오오급 음식! ",5),
			string.rep("주세요! ",10),string.rep("사주떼엽 ",9),
			"그거 맛있지"
		};
		love = defaultLove;
	};
	["배드워즈"] = {
		alias = {"베드워즈","침대전쟁"};
		reply = {"주인이 말하길 고인물 망겜이레요!","망겜","그거 왜함?","그거 하면 정신건강 나빠짐 ㅇㅇ"};
		love = defaultLove;
	};
	["짖어"] = {
		alias = {"짖어!"};
		reply = {"냥? 멍?","~~갑자기...?~~ 냥!"};
		love = defaultLove;
	};
	["누워"] = {
		alias = {"누워!"};
		reply = {"시러!","내가 강아지인줄 아나","(누움)"};
		love = defaultLove;
	};
	["그뭔씹"] = {
		alias = {"그게뭔데","씹덕","그게뭔데씹덕","씹덕새끼"};
		reply = {"그게 뭔데 씹덕새끼야!!!"};
		love = defaultLove;
	};
	["태양만세"] = {
		alias = {"태양","태양!!","태양!"};
		reply = "태양만세!!!";
		love = defaultLove;
	};
	["샌즈"] = {
		alias = {"언텔","언더테일","샌즈","파피루스","와샌즈","와 샌즈"};
		reply = {"와 아시는구나 참고로 정말 어렵습니다 (중략)","와 샌즈!!","~~잼~~갓겜"};
		love = defaultLove;
	};
	["그림"] = {
		alias = {"그림그리기"};
		reply = "힘듦";
		love = defaultLove;
	};
	["안되"] = {
		reply = {"마춤뻡 크리티컬","안히; 국어 공부 안해써요?","~~문과 크리티컬~~","세종대왕이 운다","왜 않됢?"};
		love = rmLove;
	};
	["안돼"] = {
		reply = {
			"머가?",
			"왜?",
			"왜 안돼?",
			"먀아?",
			"먀?",
			"먘?",
			"안데?",
			"하지마?",
			"시러?",
		};
		love = defaultLove;
	};
	["캐비어"] = {
		reply = "ㅎㅇ";
		love = defaultLove;
	};
	["노래불러"] = {
		alias = {"노래해","노래해봐","노래해바","노래해줘","노래해저"};
		reply = {
			"나는 노래는 못해요오오....",
			"거기 하리보라고 노래 잘하는 친구 있어요",
			"음... 그루비가 잘 부를꺼 같아요",
			"리듬이를 불러옵시다!"
		};
	};
	["코딩"] = {
		alias = {"code","coding","Coding","Code","코드"};
		reply = {"사회악 노가다","노가다 망겜","하지 마세요... 젭발","주인이 그거 많이 하던데"};
		love = defaultLove;
	};
	["아"] = {
		alias = {
			"아아","아아아","아아아아","아아아아아","아아아아아아","아아아아아아아",
			"아아아아아아아아","아아아아아아아아아","아아아아아아아아아아"
		};
		reply = function (message,args,Content)
			message:reply(
				string.rep(Content.commandName,2)
			);
		end;
		love = defaultLove;
	};
	["RIP"] = {
		alias = {
			"Rip","rip","rIp","riP","RIp","rIP","R I P","R.I.P","r.i.p",
			"rip","rip...","rip....","rip.....","rip..","rip."
		};
		reply = "Rest In Peace................";
		love = defaultLove;
	};
	["군침"] = {
		alias = {"군침이 싹","군싹돌","군침이 싸아악","군침 싹","군침싹","루피"};
		reply = "https://tenor.com/view/%ea%b5%b0%ec%b9%a8-gif-18856033";
		love = defaultLove;
	};
	["아이고"] = {
		reply = "에? 무슨일 있어요?";
		love = defaultLove;
	};
	["글쓰기"] = {
		reply = {"넘나 어려운거","그거 인간도 못한데요"};
		love = defaultLove;
	};
	["엌"] = {
		alias = {"엌ㅋ","엌ㅋㅋ","엌ㅋㅋㅋ","엌ㅋㅋㅋㅋ"};
		reply = "엌ㅋㅋㅋㅋ";
		love = defaultLove;
	};
	["개새끼"] = {
		alias = {"ㄱㅅㄲ","ㄳㄲ","개쉨끼","개새키","개샠키","개샠끼","개새꺄"};
		reply = "ㅠㅠ";
		love = rmLove;
	};
	["없에"] = {
		reply = {"머?","미나야 지워 하려던거 아니야?"};
		love = defaultLove;
	};
	["ㅄ"] = {
		alias = {"ㅂㅅ","병신","병신새끼","병신 새끼","병쉰","병틴"};
		reply = {"ㅠㅠ","나 병신 아니야!"};
		love = rmLove;
	};
	["전화번호 줘"] = {
		alias = {"전화번호좀","전화번호줘","전번줘","전번좀","전화번호 좀"};
		reply = {"안데!!","미나는 전화번호 없는데?"};
		love = defaultLove;
	};
	["인생"] = {
		alias = {"잉생","인쉥"};
		reply = {"답이 없네...","답도 없네..."};
		love = defaultLove;
	};
	["4망"] = {
		alias = {"사망"};
		reply = "444444망";
		love = defaultLove;
	};
	["별"] = {
		reply = "{#:U+2605:#}";
		love = defaultLove;
	};

	-- 언제 추가해
	--아퍼 + 배
	--선배
	--["생일"] = {
	--	alias = "생축"
	--};
	--["답이 없네"] = {

	--};
	--["노래좀"] = {
	--	alias = {"노래추천좀","노래추천"};
	--	reply = {};
	--};
};
