local typingGame = require "class.typingGame";
local korquoteRequest = require "commands.korquote.request";
local korquoteEmbed = require "commands.korquote.embed";
korquoteRequest:setrandom(random):setJson(json);
korquoteEmbed:setUrlCode(urlCode);

---@type table<string, Command>
local export = {
	["한글명언"] = {
		alias = {"명언 한국어","명언 한글","한글명언","한국어명언","한글 명언","한국어 명언","명언","korean quote","kor quote","koreanquote","korquote"};
		reply = "잠시만 기달려주세요 . . .";
		func = function(replyMsg,message,args,Content)
			replyMsg:update {
				embed = korquoteEmbed:embed(korquoteRequest.fetch());
				content = "한글 명언을 가져왔습니다";
			};
		end;
		onSlash = commonSlashCommand {
			noOption = true;
			description = "한글 명언을 보여줍니다!";
		};
	};
	["타자연습 한글"] = {
		alias = {
			"한글 타자연습","한글타자연습","한글타자","한글 타자",
			"한국어 타자","한국어타자","한국어 타자연습",
			"한국어타자연습","타자연습 한국어","타자연습한글",
			"타자한글","타자 한글","타자 한국어","타자연습한글"
		};
		reply = "잠시만 기달려주세요 . . .";
		embed = {description = "뒤에 보이는 문구를 재빠르게 입력하세요!"};
		func = function(replyMsg,message,args,Content)
			local this = korquoteRequest.fetch();
			typingGame.new(replyMsg,message,Content,this.message,this.author);
		end;
	};
};
return export;
