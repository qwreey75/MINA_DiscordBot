local discordia_enchant = _G.discordia_enchant;
local components = discordia_enchant.components;
local permission = discordia.enums.permission; ---@diagnostic disable-line
local adminPermission = permission.administrator;
local key = "emojiMagnify";

---@type table<string, Command>
local export = {
    ["이모지확대"] = {
        notPermitted = {
            content = zwsp;
            embed = {
                title = ":x: 권한이 없습니다!";
                description = "관리 권한이 있는 사람만 이 명령을 사용할 수 있습니다";
            };
        };
        on = {
            embed = {
                title = ":white_check_mark: 이모지 확대를 켰습니다!";
                description = "이제 사용하는 단일 이모지가 확대됩니다";
            };
            content = zwsp;
        };
        off = {
            embed = {
                title = ":white_check_mark: 이모지 확대를 껐습니다!";
                description = "이제 사용하는 단일 이모지를 확대하지 않습니다";
            };
            content = zwsp;
        };
		disableDm = true;
		command = {"이모지확대"};
        ---@param Content commandContent
		reply = function(message,args,Content,self)
            if not Content.member:hasPermission(adminPermission) then ---@diagnostic disable-line we can do dis without adding channel but diagnostic will catch this method must be called with three arguments
                return message:reply(self.notPermitted);
            end

            local serverData = Content.loadServerData() or {};

			local rawArgs = Content.rawArgs;
			local setTo = not serverData[key];
			if onKeywords[rawArgs] then
				setTo = true;
			elseif onKeywords[rawArgs] then
				setTo = false;
			end
            serverData[key] = setTo;

			Content.saveServerData(serverData);
            return message:reply(setTo and self.on or self.off);
		end;
		onSlash = commonSlashCommand {
			description = "이모지 확대 기능을 켜거나 끕니다, 관리자만 이 기능을 사용할 수 있습니다!";
			name = "이모지확대";
			optionDescription = "이모지 확대를 켤지 끌지 결정해주세요! (아무것도 입력하지 않으면 토글합니다)";
			optionRequired = false;
			optionChoices = {
				{
					name = "이모지 확대 기능을 켭니다!";
					value = "켜기";
				};
				{
					name = "이모지 확대 기능을 끕니다!";
					value = "끄기";
				};
			};
		};
	};
};

local match = string.match;
local this = hook.new{ -- 후크로 구현
    type = hook.types.before;
    destroy = function (self) -- this function never be called, should never happen
        self:detach();
        logger.info("[emojiMagnifying] Module unloaded!");
    end;
    ---@param contents hookContent
    func = function (self,contents)
        if contents.isDm then return; end
        local text = contents.text;
        local emojiId = match(text,"^ *<:[%w_]+:(%d+)> *$");
        if emojiId then
            local message = contents.message;
            local member = message.member;
            local guild = message.guild;
            if (not guild) or (not member) then return; end
            local guildId = guild.id;
            local serverData = serverData.loadData(guildId);
            if (not serverData) or (not serverData[key]) then
                return true;
            end

            message:reply{
                content = zwsp;
                embed = {
                    footer = {
                        text = ("%s 님이 사용한 이모지"):format(member.nickname or member.name);
                    };
                    image = {
                        url = ("https://cdn.discordapp.com/emojis/%s"):format(emojiId);
                    };
                };
                components = {
                    components.actionRow.new {
                        buttons.action_remove_owneronly(member.id); ---@diagnostic disable-line
                    };
                };
                reference = {message = message, mention = false};
            };
            return true;
        end
    end;
};
this:attach();

return export;
