local APIurl = "http://hangang.dkserver.wo.tc";

---@type table<string, Command>
local export = {
	["한강기온"] = {
		alias = {
			"한강 온도","한강 수온","한강온도",
			"한강 기온","한강수온","한강",
			"한강물온도","한강 물 온도","한강 물온도",
			"한강 각","한강각"
		};
		reply = function (message)
			local header,response = corohttp.request("GET",APIurl);
			local decoded = json.decode(response); ---@type table
			if decoded then
				return message:reply{
					content = zwsp;
					embed = {
						title = ("한강 물 온도는 %s 도 입니다!"):format(tostring(decoded.temp));
						description = ("%s 기준의 자료입니다"):format(tostring(decoded.time));
					};
				};
			else
				return message:reply{
					content = zwsp;
					embed = {
						title = ":x: 오류!";
						description = "한강 물 온도를 불러오지 못했습니다";
					};
				};
			end
		end;
		onSlash = commonSlashCommand {
			noOption = true;
			description = "한강 물온도를 보여줍니다!";
		};
	};
};
return export;
