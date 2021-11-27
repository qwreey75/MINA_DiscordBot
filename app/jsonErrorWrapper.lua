local json = _G.json;

local encode = json.encode;
local decode = json.decode;
local remove = table.remove;
local logger = _G.logger;
local unpack = unpack or table.unpack;

function json.decode(...)
	local result = {pcall(decode,...)};
	local passed = remove(1,result);

	if passed then
		return unpack(result);
	else
		local errorMsg = remove(1,result);
		logger.errorf("json decode failed! error message was\n%s",tostring(errorMsg));
		return nil;
	end
end

function json.encode(...)
	local result = {pcall(encode,...)};
	local passed = remove(1,result);

	if passed then
		return unpack(result);
	else
		local errorMsg = remove(1,result);
		logger.errorf("json decode failed! error message was\n%s",tostring(errorMsg));
		return nil;
	end
end

logger.info("json module was warpped with pcall protection!");
