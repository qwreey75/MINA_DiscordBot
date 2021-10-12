local root = "data/userLearn/%s";
local indexedFile = "data/userLearn/index";
local indexedCache = json.decode(
	("{%s}"):format(fs.readFileSync(indexedFile))
);
local module = {};

local errorType = {
	unknown = 0;
	tooLongValue = 1;
	tooLongName = 2;
	notEnoughLove = 3;
	nullValue = 4;
	nullName = 5;
	devDefined = 6;
	linkDetected = 7;
	mentionDetected = 8;
	channelDetected = 9;
	alreadlyLearnByYou = 10;
};
module.errorType = errorType;

--- get react
function module.get(name)
	local hash = sha1(name);
	local id = indexedCache[hash];
	if not id then
		return;
	end

	local path = root:format(id);
	local maxIndex = tonumber((fs.readFileSync(path .. "/index") or ""):match("%d+"));

	if not maxIndex then
		return;
	end

	local index = cRandom(1,maxIndex);
	local this = json.decode(fs.readFileSync(("%s/%d"):format(path,index)));

	return this;
end

local maxValueLength = 200;
local maxNameLength = 100;
local costLove = 20;
local utf8Len = utf8.len;
local insert = table.insert;
--- Add new react
function module.put(name,value,author,when,userData)
	if commandHandler.findCommandFrom(reacts,name) then
		return errorType.devDefined; -- if developers defined that
	elseif value:match("@everyone") or -- when user used mention
	value:match("@here") or
	value:match("<@!?[^ \\]+>") then
		return errorType.mentionDetected; -- user mention detected
	elseif value:match("<#[^ ]+>") then
		return errorType.channelDetected; -- channel mention detected
	end
	local love = userData.love; -- get user love from userData
    if (not name) or name == "" or name == " " or name == "\n" then
        return errorType.nullName; -- invalid name
    elseif (not value) or value == "" or value == " " or value == "\n" then
        return errorType.nullValue; -- invalid value
    elseif love < costLove then
		return errorType.notEnoughLove; -- if user's love didn't enough
	elseif utf8Len(value) > maxValueLength then
		return errorType.tooLongValue; -- if value is loner then max length
	elseif utf8Len(name) > maxNameLength then
		return errorType.tooLongName; -- if name is longer than max length
	end
	name = name:lower(); -- make name into lower cased
	userData.love = love - costLove; -- using love
	if value:find("https://",1,true) or -- when link detected
	value:find("http://","1",true) or
	value:match(".-%.org") or
	value:match(".-%.com") or
	value:match(".-%.net") then
		return errorType.linkDetected;
	end

	-- setup database
	local hash = sha1(name);
	local id = indexedCache[hash];
	local path;
	local index;
	if not id then -- write new
		id = makeId(); -- make new identifier
		indexedCache[hash] = id;
		fs.appendFileSync(indexedFile,('"%s":"%s",\n'):format(hash,id));
		path = root:format(id);
		fs.mkdirSync(path);
		fs.writeFile(path .. "/name",name);
		fs.writeFile(path .. "/index","1");
		index = 1;
	else
		-- check is exist already (learn by that user)
		local already;
		for _,this in pairs(userData.learned) do -- 최적화 필요
			if this:sub(1,18) == id then
				local file = fs.readFileSync(root:format(this));
				if file then
					file = json.decode(file);
					if file and file.content == value then
						already = true;
						break;
					end
				end
			end
		end
		if already then
			return errorType.alreadlyLearnByYou;
		end

		path = root:format(id);
		index = tonumber(fs.readFileSync(path .. "/index"):match("%d+"));
		index = index + 1;
		fs.writeFileSync(path .. "/index",tostring(index));
	end

	-- save to file
	fs.writeFileSync(("%s/%d"):format(path,index),json.encode({
		author = tostring(author);
		when = tonumber(when);
		content = value;
	}));

	-- save into user data
	local learned = userData.learned;
	if not learned then
		learned = {};
		userData.learned = learned;
		userData.lenLearned = 0;
	end
	insert(learned,("%s/%d"):format(id,index));
	userData.lenLearned = userData.lenLearned + 1;
end

return module;