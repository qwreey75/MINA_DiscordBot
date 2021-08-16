--[[
	작성 : qwreey
	2021y 04m 06d
	7:07 (PM)

	MINA Discord bot
	https://github.com/qwreey75/MINA_DiscordBot/blob/faf29242b29302341d631513617810d9fe102587/bot.lua

	TODO: DM 에다가 명령어 쓰기 막기
	TODO: 도움말 만들기
	TODO: 사전 Json 인코딩을 없에고 그냥 바로 테이블 넘기기
	TODO: 지우기 명령,강퇴,채널잠금,밴 같은거 만들기
	TODO: 다 못찾으면 !., 같은 기호 지우고 찾기
	TODO: 그리고도 못찾으면 조사 다 지우고 찾기
	TODO: 욕설 멈춰!! 욕 = 떨어짐
]]
--#region : Luvit 모듈 / 주요 모듈 임포트

-- set utf-8 terminal
do
	local chcpStatus do
		local file = io.popen("chcp");
		chcpStatus = file:read("*a");
		file:close();
		chcpStatus = tonumber((chcpStatus or ""):match(": (%d+)")) or 0;
	end
	if not chcpStatus == 65001 then
		os.execute("chcp 65001>NUL");
	end
end

-- set title of terminal
os.execute("title DISCORD BOT");

-- set require path
package.path = require("app.path")(package.path);
_G.require = require;
local exitCodes = require("app.exitCodes"); _G.exitCodes = exitCodes;

-- load modules
local prettyPrint = require "pretty-print"; _G.prettyPrint = prettyPrint;-- 터미널에 여러 자료형 프린팅
local readline = require "readline"; _G.readline = readline;-- 터미널 라인 읽기
local iLogger = require "log"; _G.iLogger = iLogger; -- log 핸들링
local json = require "json"; _G.json = json;-- json 핸들링
local corohttp = require "coro-http"; _G.corohttp = corohttp;-- http 핸들링
local timer = require "timer"; _G.timer = timer;-- 타임아웃 핸들링
local thread = require "thread"; _G.thread = thread-- 스레드 조정
local fs = require "fs"; _G.fs = fs;-- 파일 시스템
local ffi = require "ffi"; _G.ffi = ffi;-- C 동적 상호작용
local utf8 = utf8 or require "utf8"; _G.utf8 = utf; -- 유니코드8 라이브러리 불러오기
local term = require "app.term"; -- terminal settings

-- same with js's timeout function
local function runSchedule(time,func)
	timer.setTimeout(time,coroutine.wrap(func));
end
_G.runSchedule = runSchedule;

iLogger.info("------------------------ [CLEAN  UP] ------------------------");
iLogger.info("luvit loaded");
--#endregion : Luvit 모듈 / 주요 모듈 임포트
--#region : 커맨드 라인 인자 받아오기
local RunOption = {}; -- 인자 옵션 받는곳
iLogger.info("find command line args . . .");
for i,v in pairs(args) do ---@diagnostic disable-line
	if i > 1 then
		iLogger.info((" |- args[%d] : %s"):format(i-1,v));
		RunOption[v] = true;
	end
end
if RunOption["Background"] then
	iLogger.info("Background mode Detected! turn off logging..");
	iLogger.disable = true;
end
--#endregion : 커맨드 라인 인자 받아오기
--#region : 디코 모듈 임포트
iLogger.info("wait for discordia . . .");
local discordia = require "discordia"; _G.discordia = discordia; -- 디스코드 lua 봇 모듈 불러오기
local discordia_class = require "discordia/libs/class"; _G.discordia_class = discordia_class; -- 디스코드 클레스 가져오기
local discordia_Logger = discordia_class.classes.Logger; _G.discordia_Logger = discordia_Logger; -- 로거부분 가져오기 (통합을 위해 수정)
local enums = discordia.enums; _G.enums = enums; -- 디스코드 enums 가져오기
local client = discordia.Client(); _G.client = client; -- 디스코드 클라이언트 만들기
function discordia_Logger:log(level, msg, ...) -- 디스코드 모듈 로거부분 편집
	if self._level < level then return end
	msg = string.format(msg, ...);
	local logFn =
		(level == 3 and iLogger.debug) or
		(level == 2 and iLogger.info) or
		(level == 1 and iLogger.warn) or
		(level == 0 and iLogger.error);
	logFn(msg);
	return msg;
end

local function startBot(botToken) -- 봇 시작시키는 함수
	-- 토큰주고 시작
	iLogger.debug("starting bot ...");
	client:run(("Bot %s"):format(botToken));
	client:setGame("'미나야 도움말' 을 이용해 도움말을 얻거나 '미나야 <할말>' 을 이용해 미나와 대화하세요!");
	return;
end
local function reloadBot() -- 봇 종료 함수
	iLogger.info("Try restarting ...");
	client:setGame("재시작중...");
end
local function adminCmd(Text,message) -- 봇 관리 커맨드 실행 함수
	if (Text == "!!!stop" or Text == "!!!kill") then
		message:reply('> 프로그램 죽이는중 . . .');
		os.exit(exitCodes.exit); -- 프로그램 킬
	elseif (Text == "!!!restart" or Text == "!!!reload") then
		iLogger.info("Restarting ...");
		message:reply('> 재시작중 . . . (2초 내로 완료됩니다)');
		reloadBot();
		os.exit(exitCodes.reload); -- 프로그램 다시시작
	elseif (Text == "!!!pull" or Text == "!!!download") then
		iLogger.info("Download codes ...");
		local msg = message:reply('> GITHUB qwreey75/MINA_DiscordBot 로 부터 코드를 받는중 . . .');
		_G.livereloadEnabled = false;
		os.execute("git -C src pull"); -- git 에서 변동사항 가져와 적용하기
		_G.livereloadEnabled = true;
		msg:setContent('> 적용중 . . . (3초 내로 완료됩니다)');
		reloadBot();
		os.exit(exitCodes.reload); -- 다운로드 (리로드)
	elseif (Text == "!!!push" or Text == "!!!upload") then
		iLogger.info("Upload codes ...");
		local msg = message:reply('> GITHUB qwreey75/MINA_DiscordBot 로 코드를 업로드중 . . .');
		_G.livereloadEnabled = false;
		os.execute("git -C src add .&&git -C src commit -m 'MINA : Upload in main code (bot.lua)'&&git -C src push");
		_G.livereloadEnabled = true;
		msg:setContent('> 완료!');
		return; -- 업로드
	elseif (Text == "!!!sync") then
		iLogger.info("Sync codes ...");
		local msg = message:reply('> GITHUB qwreey75/MINA_DiscordBot 로 부터 코드를 동기화중 . . . (8초 내로 완료됩니다)');
		_G.livereloadEnabled = false;
		os.execute('git -C src add .&&git -C src commit -m "MINA : Sync in main code (Bot.lua)"&&git -C src pull&&git -C src push');
		_G.livereloadEnabled = true;
		msg:setContent('> 적용중 . . . (3초 내로 완료됩니다)');
		reloadBot();
		os.exit(exitCodes.reload); -- 동기화 (리로드)
	elseif (Text == "!!!help" or Text == "!!!cmds") then
		message:reply(
			'!!!help 또는 !!!cmds : 이 창을 띄웁니다\n' ..
			'!!!stop 또는 !!!kill : 봇을 멈춥니다\n' ..
			'!!!restart 또는 !!!reload : 봇을 다시로드 시킵니다\n' ..
			'!!!pull 또는 !!!download : 클라우드로부터 코드를 내려받고 다시 시작합니다\n' ..
			'!!!push 또는 !!!upload : 클라우드로 코드를 올립니다\n' ..
			'!!!sync : 클라우드와 코드를 동기화 시킵니다 (차이 비교후 병합)\n'
		);
	end
end
--#endregion : Discord Module
--#region : 부분 모듈 임포팅
iLogger.info("load modules . . .");
local commandHandler = require "commandHandler"; _G.commandHandler = commandHandler; -- 커맨드 구조 처리기
local cRandom = require "cRandom"; _G.cRandom = cRandom; -- LUA 렌덤 핸들러
local strSplit = require "stringSplit"; _G.strSplit = strSplit; -- 글자 분해기
local urlCode = require "urlCode"; _G.urlCode = urlCode; -- 한글 URL 인코더/디코더
local makeId = require "makeId"; _G.makeId = makeId; -- ID 만드는거
local makeSeed = require "makeSeed"; _G.makeSeed = makeSeed;
local myXMl = require "myXML"; _G.myXMl = myXMl;

-- 데이터
local data = require "data"; _G.data = data;
data:setJson(json);

-- 유저 데이터 핸들링
local userData = require "userData"; _G.userData = userData;
userData:setJson(json):setILogger(iLogger):setMakeId(makeId);

--#endregion : 부분 모듈 임포팅
--#region : 설정파일 불러오기
iLogger.info("load files . . .");
local ACCOUNTData = data.load("data/ACCOUNT.json"); _G.ACCOUNTData = ACCOUNTData;
local loveLeaderstats = data.load("data/loveLeaderstats.json");
local EULA = data.loadRaw("data/EULA.txt"); _G.EULA = EULA;
--#endregion : load settings from data file
--#region : 반응, 프리픽스, 설정, 커맨드 등등
iLogger.info("---------------------- [LOAD SETTINGS] ----------------------");
iLogger.info("load settings ...");
iLogger.info(" |- admins, prefixs, prefix reply, unknown reply, command env");
local disableDm = "이 반응은 DM 에서 사용 할 수 없어요! 서버에서 이용해 주세요";
local eulaComment_love = "\n" .. -- 약관 동의 안할때 호감도 표시
	"\n> 호감도 기능을 사용할 수 없어요!" ..
	"\n> 호감도 기능을 사용하려면 '미나야 약관 동의' 를 입력해주세요!" ..
	"\n> (약관의 세부정보를 보려면 '미나야 약관' 을 입력해주세요)";
local Admins = { -- 관리 명령어 권한
	["367946917197381644"] = "쿼리";
	["647101613047152640"] = "눈송이";
	["415804982764371969"] = "상어";
	["754620012450414682"] = "팥죽";
	["756035861250048031"] = "내부계";
};
local prefixs = { -- 명령어 맨앞 글자 (접두사)
	[1] = "미나야";
	[2] = "미나";
	[3] = "미나야.";
	[4] = "미나!";
	[5] = "미나야!";
	[6] = "미나야...";
	[7] = "미나야..",
	[8] = "미나...";
	[9] = "미나는";
	[10] = "미나의";
	[11] = "mina";
	[12] = "hey mina";
};
local prefixReply = { -- 그냥 미나야 하면 답
	"미나는 여기 있어요!","부르셨나요?","넹?",
	"왜요 왜요 왜요?","심심해요?","네넹","미나에요",
	"~~어쩌라고~~","Zzz... 아! 안졸았어요",
	"Zzz... 아! 안졸았어요 ~~아 나도 좀 잠좀 자자 인간아~~","네!"
};
local unknownReply = { -- 반응 없을때 띄움
	"(갸우뚱?)","무슨 말이에요?","네?","으에?"--,"먕?",":thinking: 먀?"
};
iLogger.info(" |- load commands from ./commands");
local otherCommands = {} -- commands 폴더에서 커맨드 불러오기
for dir in fs.scandirSync("commands") do
	dir = string.gsub(dir,"%.lua$","");
	iLogger.info(" |  |- load command dict from : commands/" .. dir .. ".lua");
	otherCommands[#otherCommands+1] = require("commands." .. dir);
end
iLogger.info("settings loaded!");
-- 커맨드 색인파일 만들기
iLogger.info("encoding commands...");
local commands,commandsLen;
commands,commandsLen = commandHandler.encodeCommands({
	-- 특수기능
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
	["호감도"] = {
		reply = function (message,args,c)
			if message.author.id == "480318544693821450" then
				return "미나는 **{#:UserName:#}** 님을 **10/25** 만금 좋아해요!";
			elseif message.author.id == "647101613047152640" then
				return "니 약관동의 안할 거잔아";
			end
			if c.rawArgs == "" then -- 내 호감도 불러오기
				local muserData = c.getUserData();
				if muserData == nil then -- 약관 동의하지 않았으면 리턴
					return eulaComment_love;
				end
				local numLove = tonumber(muserData.love);
				if numLove == nil then
					return "미나는 **{#:UserName:#}** 님을 **NULL (nil)** 만큼 좋아해요!\n\n오류가 발생하였습니다...\n```json : Userdata / love ? NULL```";	
				elseif numLove > 0 then
					return ("미나는 **{#:UserName:#}** 님을 **%d** 만큼 좋아해요!"):format(numLove);
				elseif numLove < 0 then
					return ("미나는 **{#:UserName:#}** 님을 **%d** 만큼 싫어해요;"):format(math.abs(numLove));
				elseif numLove == 0 then
					return "미나는 아직 **{#:UserName:#}** 님을 몰라요!";
				end
			end
		end
	};
	["약관동의"] = {
		alias = {"EULA동의","약관 동의","사용계약 동의"};
		reply = function (message,args,c)
			local muserData = c.getUserData(); -- 내 호감도 불러오기
			if muserData then -- 약관 동의하지 않았으면 리턴
				return "**{#:UserName:#}** 님은 이미 약관을 동의하셨어요!";
			end
			local userId = tostring(message.author.id);
			local file = io.open(("data/userData/%s.json"):format(userId),"w");
			file:write(
				("{" ..
					('"latestName":"%s",'):format(message.author.name) ..
					'"love":0,' ..
					('"lastName":["%s"],'):format(message.author.name) ..
					'"lastCommand":{}' ..
				"}")
			);
			file:close();
			--"안녕하세요 {#:UserName:#} 님!\n사용 약관에 동의해주셔서 감사합니다!\n사용 약관을 동의하였기 때문에 다음 기능을 사용 할 수 있게 되었습니다!\n\n> 미나야 배워 (미출시 기능)\n"
		end;
	};
	["지워"] = {
		disableDm = true;
		alias = {"지우개","지워봐","지워라","지우기","삭제해","청소","삭제","청소해","clear"};
		func = function(replyMsg,message,args,Content)
			local RemoveNum = Content.rawArgs == "" and 5 or tonumber(Content.rawArgs);
			if (not RemoveNum) or type(RemoveNum) ~= "number" then -- 숫자가 아닌 다른걸 입력함
				message:reply("잘못된 명령어 사용법이에요!\n\n**올바른 사용 방법**\n> 미나야 지워 <지울 수>\n지울수 : 2 에서 100 까지의 숫자 (정수)");
				return;
			elseif (RemoveNum % 1) ~= 0 then -- 소숫점을 입력함
				local Remsg = message:reply("~~메시지를 반으로 쪼개서 지우라는거야? ㅋㅋㅋ~~");
				runSchedule(800,function()
					Remsg:setContent("<지울 수> 는 정수만 사용 가능해요!");
				end);
				return;
			elseif RemoveNum < 0 then -- 마이너스를 입력함
				local Remsg = message:reply("~~메시지를 더 늘려달라는거야? ㅋㅋㅋ~~");
				runSchedule(800,function()
					Remsg:setContent("적어도 2개 이상부터 지울 수 있어요!");
				end);
				return;
			elseif RemoveNum > 100 then -- 너무 많음
				local Remsg = message:reply("~~미쳤나봐... 작작 일 시켜~~");
				runSchedule(800,function()
					Remsg:setContent("100 개 이상의 메시지는 지울 수 없어요!");
				end);
				return;
			elseif RemoveNum < 2 then -- 범위를 넘어감
				local Remsg = message:reply("~~그정도는 니 손으로 좀 지워라~~");
				runSchedule(800,function()
					Remsg:setContent("너무 적어요! 2개 이상부터 지울 수 있어요!");
				end);
				return;
			elseif not message.member:hasPermission(message.channel,enums.permission.manageMessages) then
				message:reply("권한이 부족해요! 메시지 관리 권한이 있는 유저만 이 명령어를 사용 할 수 있어요");
				return;
			end

			message.channel:bulkDelete(message.channel:getMessagesBefore(message.id,RemoveNum));
			local infoMsg = message:reply(("최근 메시지 %s개를 지웠어요!"):format(RemoveNum));
			message:delete();

			runSchedule(1200,function ()
				infoMsg:delete();
			end);
			return;
		end;
	};
	["미나"] = {
		alias = {"미나야","미나!","미나...","미나야...","미나..","미나야..","미나.","미나야.","미나야!"};
		reply = prefixReply;
	};
	["반응"] = {
		alias = {"반응수","반응 수","반응 갯수"};
		reply = "새어보고 있어요...";
		func = function (replyMsg,message,args,Content)
			replyMsg:setContent(("미나가 아는 반응은 %d개 이에요!"):format(commandsLen));
		end;
	};
	["배워"] = {
		alias = {"배워봐","배워라","배우세요"};
		func = function (replyMsg,message,args,Content)
			
		end;
	};
	-- ["잊어"] = {
	-- 	alias = {"지워","까먹어"};
	-- 	func = function (replyMsg,message,args,Content)
	-- 		Content.rawArgs
			
	-- 		return replyMsg:setContent()
	-- 	end;
	-- };
},unpack(otherCommands));
iLogger.info("command encode end!");
--#endregion : 반응, 프리픽스, 설정
--#region : 메인 파트
iLogger.info("----------------------- [SET UP BOT ] -----------------------");
client:on('messageCreate', function(message) -- 메시지 생성됨
	local User = message.author;
	local Text = message.content;
	local Channel = message.channel;
	local IsDm = Channel.type == enums.channelType.private;

	-- 유저가 봇인경우
	if User.bot then
		return;
	end
	-- 하드코딩된 관리 명령어)
	if Admins[User.id] then
		adminCmd(Text,message);
	end

	-- 명령어
	-- prefix : 접두사
	-- rawCommandText : 접두사 뺀 커맨드 전채
	-- splitCommandText : rawCommandText 를 \32 로 분해한 array
	-- rawCommandText : 커맨드 이름 (앞부분 다 자르고)
	-- CommandName : 커맨드 이름
	-- | 찾은 후 (for 루프 뒤)
	-- Command : 커맨드 개체 (찾은경우)

	Text = string.lower(Text);

	-- 접두사 구문 분석하기
	local prefix;
	for _,nprefix in pairs(prefixs) do
		-- 만약 접두사와 글자가 일치하는경우 반응 달기
		if nprefix == Text then
			message:reply {
				content = prefixReply[cRandom(1,#prefixReply)];
				reference = {message = message, mention = false};
			};
			return;
		end
		local nprefix = nprefix .. "\32"; -- 맨 앞 실행 접두사
		if string.sub(Text,1,#nprefix) == nprefix then -- 만약에 접두가사 일치하면
			prefix = nprefix;
			break;
		end
	end
	if not prefix then
		return;
	end

	-- 알고리즘 작성
	-- 커맨드 찾기
	-- 단어 분해 후 COMMAND DICT 에 색인시도
	-- 못찾으면 다시 넘겨서 뒷단어로 넘김
	-- 찾으면 넘겨서 COMMAND RUN 에 TRY 던짐
	local rawCommandText = string.sub(Text,#prefix+1,-1); -- 접두사 뺀 글자
	local splitCommandText = strSplit(rawCommandText,"\32");
	local CommandName,Command,rawCommandName;

	-- (커맨드 색인 1 차시도) 띄어쓰기를 포함한 명령어를 검사할 수 있도록 for 루프 실행
	-- 찾기 찾기 찾기
	-- 찾기 찾기
	-- 찾기
	-- 이런식으로 계단식 찾기를 수행
	for len = #splitCommandText,1,-1 do
		local spText,text = "",""; -- 띄어쓰기가 포함되도록 검색 / 띄어쓰기 없이 검색
		for index = 1,len do
			local thisText = splitCommandText[index];
			spText = spText .. (index ~= 1 and " " or "") .. thisText;
			text = text .. thisText;
		end
		local spTempCommand = commandHandler.findCommandFrom(commands,spText);
		if spTempCommand then
			CommandName = spText;
			rawCommandName = spText;
			Command = spTempCommand;
			break;
		end
		local tempCommand = commandHandler.findCommandFrom(commands,spText);
		if tempCommand then
			CommandName = text;
			rawCommandName = text;
			Command = tempCommand;
			break;
		end
	end

	-- (커맨드 색인 2 차시도) 커맨드 못찾으면 단어별로 나눠서 찾기 시도
	-- 찾기 찾기 찾기
	-- 부분부분 다 나눠서 찾기
	if not Command then
		for FindPos,Text in pairs(splitCommandText) do
			Command = commandHandler.findCommandFrom(commands,Text);
			if Command then
				CommandName = "";
				rawCommandName = Text;
				for Index = 1,FindPos do
					CommandName = CommandName .. splitCommandText[Index];
				end
				break;
			end
		end
	end

	-- 커맨드 찾지 못함
	if not Command then
		message:reply(unknownReply[cRandom(1,#unknownReply)]);
		-- 반응 없는거 기록하기
		fs.appendFile("log/unknownTexts/raw.txt","\n" .. Text);
		return;
	elseif IsDm and Command.disableDm then
		message:reply(disableDm);
		return;
	end

	-- 커맨드 찾음 (실행)
	local love = Command.love; -- 호감도
	love = tonumber((type(love) == "function") and love() or love);
	local loveText = (love ~= 0 and love) and ( -- love 가 0 이 아님을 확인
		(love > 0 and ("\n` ❤ + %d `"):format(love)) or -- 만약 love 가 + 면
		(love < 0 and ("\n` 💔 - %d `"):format(math.abs(love))) -- 만약 love 가 - 면
	) or "";

	local func = Command.func; -- 커맨드 함수 가져오기
	local replyText = Command.reply; -- 커맨드 리플(답변) 가져오기
	local rawArgs,args; -- 인수 (str,띄어쓰기 단위로 나눔 array)
	replyText = (
		(type(replyText) == "table") -- 커맨드 답변이 여러개면 하나 뽑기
		and (replyText[cRandom(1,#replyText)])
		or replyText
	);
	-- 만약 호감도가 있으면 올려주기
	if love then
		local thisUserDat = userData:loadData(User.id);
		if thisUserDat then
			thisUserDat.love = thisUserDat.love + love;
			userData:saveData(User.id);
		else
			loveText = eulaComment_love;
		end
	end
	-- 만약 답변글이 함수면 (지금은 %s 시에요 처럼 쓸 수 있도록) 실행후 결과 가져오기
	if type(replyText) == "function" then
		rawArgs = string.sub(rawCommandText,#CommandName+2,-1);
		args = strSplit(rawArgs,"\32");
		replyText = replyText(
			message,args,{
				rawCommandText = rawCommandText; -- 접두사를 지운 커맨드 스트링
				prefix = prefix; -- 접두사(확인된)
				rawArgs = rawArgs; -- args 를 str 로 받기 (직접 분석용)
				rawCommandName = rawCommandName;
				self = Command;
				commandName = CommandName;
				saveUserData = function ()
					return userData:saveData(User.id);
				end;
				getUserData = function ()
					return userData:loadData(User.id);
				end;
			}
		);
	end
	--replyText = (
	--	type(replyText) == "function" and
	--	replyText(message,args,{
	--	}) or replyText
	--);
	local replyMsg; -- 답변 오브잭트를 담을 변수
	if replyText then -- 만약 답변글이 있으면
		-- 답변 주기
		local replyTextType = type(replyText);
		if replyTextType == "string" then
			replyText = replyText .. loveText;
		elseif replyTextType == "table" and replyText.content then
			replyText.content = replyText.content .. loveText;
		end
		replyMsg = message:reply{
			content = commandHandler.formatReply(replyText,{
				Msg = message;
				User = User;
				Channel = Channel;
			});
			reference = {message = message, mention = false};
		};
	end
	-- func (replyMsg,message,args,EXTENDTable);
	if func then -- 만약 커맨드 함수가 있으면
		-- 커맨드 함수 실행
		rawArgs = rawArgs or string.sub(rawCommandText,#CommandName+2,-1);
		args = strSplit(rawArgs,"\32");
		func(replyMsg,message,args,{
			rawCommandText = rawCommandText; -- 접두사를 지운 커맨드 스트링
			prefix = prefix; -- 접두사(확인된)
			rawArgs = rawArgs; -- args 를 str 로 받기 (직접 분석용)
			rawCommandName = rawCommandName;
			self = Command;
			loveText = loveText;
		});
	end
end);
startBot(ACCOUNTData.botToken); -- 봇 켜기
if not RunOption.Background then -- 백그라운드 서비스가 아니면
	term(); -- 커맨드 창 인풋 읽기
end
_G.livereloadEnabled = true;
require("app.livereload");
--#endregion : 메인 파트