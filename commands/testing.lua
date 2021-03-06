local discordia_enchant = discordia_enchant;
local compEnums = discordia_enchant.enums;
local components = discordia_enchant.components;
local export = {
	["버튼"] = {
		reply = "디스코드 버튼 컴포넌트 라이브러리 v1 (by Qwreey75)";
		components = {
			components.actionRow.new{
				components.button.new {
					label = "안녕!";
					custom_id = "testingButton";
					style = compEnums.buttonStyle.primary;
				};
			};
		};
	};
};

local replys = {
	"안녕!";
	"반가워!";
	"버튼!";
	"Testing";
	"Is working?";
	"작동함!";
	"버튼을 눌렀어!";
	"Working!";
	"Button!";
};
local replysLen = #replys;

---when button is clicked
---@param id string button id
---@param object interaction button pressed interaction
local function buttonPressed(id,object)
	if id == "testingButton" then
		object.message:setContent(replys[random(1,replysLen)]);
		object:ack();
	end
end
client:onSync("buttonPressed",promise.async(buttonPressed));

return export;
