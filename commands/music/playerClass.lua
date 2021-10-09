local this = {};
this.__index = this;

local ytDown = require("commands.music.youtubeDownload");
local remove = table.remove;
local insert = table.insert;

local function formatTime(time)
	local sec = time % 60;
	local min = math.floor(time / 60);
	return ("%d:%d"):format(min,sec);
end

-- 이 코드는 신과 나만 읽을 수 있게 만들었습니다
-- 만약 편집을 기꺼히 원한다면... 그렇게 하도록 하세요
-- 다만 여기의 이 규칙을 따라주세요
-- theHourOfAllOfSpentForEditingThis = 6; -- TYPE: number;hour
-- 이 코드를 편집하기 위해 사용한 시간만큼 여기의
-- 변수에 값을 추가해주세요.

--[[
voiceChannelID : 그냥 식별용으로 쓰기 위해 만든 별거 없는 아이디스페이스
nowPlaying : 지금 플레이중인 곡
new.playIndex
]]
function this.new(props)
	local new = {};
	setmetatable(new,this);
	new:__init(props);
	return new;
end

function this:__init(props)
	self.voiceChannelID = props.voiceChannelID;
	self.nowPlaying = nil;
	self.handler = props.handler;
	self.isPaused = false;
	self.isLooping = false;
end

--#region : Stream handling methods

function this:__play(thing) -- PRIVATE
	if not thing then -- if thing is none - song
		return;
	end
	if self.nowPlaying then
		self:__stop();
	end
	self.nowPlaying = thing;
	self.isPaused = false;
	coroutine.wrap(function()
		self.handler:playFFmpeg(thing.audio);
		-- timer.sleep(20);
		if self.isLooping and self.nowPlaying then
			insert(self,thing);
		end
		if self[1] == thing then
			self:remove(1);
		end
		self.nowPlaying = nil; -- remove song
	end)();
end
function this:__stop() -- PRIVATE
	if not self.nowPlaying then
		return;
	end
	self.nowPlaying = nil;
	self.isPaused = false;
	self.handler:stopStream();
end

--#endregion : Stream handling methods

function this:apply()
	if self.nowPlaying == self[1] then
		return;
	end
	self:__play(self[1]);
end

--- insert new song
function this:add(thing,onIndex)
	local audio,info,url,vid = ytDown.download(thing.url);
	if not audio then
		return nil;
	end
	thing.url = url or thing.url;
	thing.audio = audio;
	thing.info = info;
	thing.vid = vid;
	if onIndex then
		insert(self,onIndex,thing);
	else
		insert(self,thing);
	end
	if onIndex == 1 then
		this:__stop();
	end
	self:apply();
	return audio;
end

-- remove song and checkout
function this:remove(start,counts)
	counts = counts or 1;
	if not start then -- get last index
		start = #self;
		counts = 1; -- THIS IS MUST BE 1, other value will make errors
	end
	local popedLast,indexLast;
	for index = start,start+counts-1 do
		popedLast = remove(self,start);
		indexLast = index;
	end
	self:apply();
	return popedLast,indexLast;
end

-- kill bot
function this:kill()
	local handler = self.handler;
	if handler then
		handler:close();
	end
end

-- set resume, pause
function this:setPaused(paused)
	if paused then
		self.isPaused = true;
		self.handler:pauseStream();
	else
		self.isPaused = false;
		self.handler:resumeStream();
	end
end

-- set looping
function this:setLooping(looping)
	self.isLooping = looping;
end

function this:getStatusText()
	local len = 0;
	for _,song in ipairs(self) do
		len = len + song.info.duration;
	end
	return {
		text = ("총 곡 수 : %d | 총 길이 : %s"):format(#self,formatTime(len))
		 .. (self.isLooping and "\n플레이리스트 루프중" or "")
		 .. (self.isPaused and "\n재생 멈춤" or "");
	};
end

local itemPerPage = 10;
-- display list of songs
function this:embedfiyList(page)
	page = tonumber(page) or 1;
	local atStart,atEnd = itemPerPage * (page-1) + 1,page * itemPerPage
	local fields = {};
	for index = atStart,atEnd do
		local song = self[index];
		if song then
			insert(fields,{
				name = (index == 1) and "현재 재생중" or (("%d 번째 곡"):format(index));
				value = ("[%s](%s)"):format(song.info.title:gsub("\"","\\\""),song.url);
			});
		end
	end

	if #fields == 0 then
		if page == 1 then
			return {
				footer = self:getStatusText();
				fields = fields;
				title = "1 페이지";
				description = "재생 목록이 비어있습니다";
				color = 16040191;
			};
		end
		return {
			footer = self:getStatusText();
			fields = fields;
			title = ("%d 페이지"):format(page);
			description = "페이지가 비어있습니다";
			color = 16040191;
		};
	end

	if #self > atEnd then
		insert(fields,{
			name = "더 많은 곡이 있습니다!";
			value = ("다음 페이지를 보려면\n> 미나 곡리스트 %d\n를 입력해주세요"):format(page + 1);
		});
	end

	return {
		fields = fields;
		footer = self:getStatusText();
		title = ("%d 번째 페이지"):format(page);
		color = 16040191;
	}
end

-- display now playing
function this:embedfiyNowplaying(index)
	index = tonumber(index) or 1;
	local song = self[1];

	if not song then
		return {
			title = "재생 목록이 비어있습니다";
			color = 16040191;
		};
	end

	local info = song.info;
	if not info then
		return {
			title = "알 수 없는 곡";
			color = 16040191;
		};
	end
	local thumbnails = info.thumbnails;
	local handler = self.handler;
	local getElapsed = handler.getElapsed;
	local elapsed = getElapsed();
	logger.info(elapsed);
	return {
		footer = self:getStatusText();
		title = info.title;
		description = ("%s\n곡 길이 : %s | 조회수 : %d | 좋아요 : %d\n업로더 : %s\n[영상으로 이동](%s) | [채널로 이동](%s)"):format(
			getElapsed and ("재생중 : " .. formatTime(getElapsed()) .. "\n") or "",
			formatTime(info.duration),
			info.view_count,
			info.like_count,
			info.uploader,
			song.url or info.webpage_url,
			info.uploader_url or info.channel_url
		);
		thumbnail = thumbnails and {
			url = thumbnails[#thumbnails].url;
		} or nil;
		color = 16040191;
	};
end

---@deprecated
-- function this:embedfiy()
-- 	local fields = {};
-- 	for i,song in ipairs(self) do
-- 		insert(fields,{
-- 			name = (i == 1) and "현재 재생중" or (("%d 번째 곡"):format(i));
-- 			value = ("[%s](%s)"):format(song.info.title:gsub("\"","\\\""),song.url);
-- 		});
-- 	end

-- 	return {
-- 		fields = fields;
-- 		footer = self:getStatusText();
-- 		title = "재생 목록에 있는 곡들은 다음과 같습니다";
-- 		color = 16040191;
-- 	};
-- end

return this;
