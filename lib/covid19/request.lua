--[[

작성 : qwreey
2021y 04m 06d
7:07 (PM)

코로나 19 데이터 fetching (http://openapi.data.go.kr)

]]

local module = {};
local corohttp;
local urlCode = require "src/lib/urlCode";
local myXML;

function module:setCoroHttp(NewCorohttp)
	corohttp = NewCorohttp;
	return self;
end
function module:setMyXML(NewMyXML)
	myXML = NewMyXML;
	return self;
end

local dayInSec = 86400;
function module.get(ClientData)
    local time = os.time();
    local today = os.date("*t",time);
    local yesterday = os.date("*t",time - dayInSec);

    local todayStr = tostring(today.year) do;
        local tmp;
        tmp = tostring(today.month);
        if #tmp < 2 then
            tmp = "0" .. tmp
        end
        todayStr = todayStr .. tmp

        tmp = tostring(today.day);
        if #tmp < 2 then
            tmp = "0" .. tmp
        end
        todayStr = todayStr .. tmp
    end

    local yesterdayStr = tostring(yesterday.year) do;
        local tmp;
        tmp = tostring(yesterday.month);
        if #tmp < 2 then
            tmp = "0" .. tmp
        end
        yesterdayStr = yesterdayStr .. tmp

        tmp = tostring(yesterday.day);
        if #tmp < 2 then
            tmp = "0" .. tmp
        end
        yesterdayStr = yesterdayStr .. tmp
    end

    local url = ("http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19InfStateJson?serviceKey=%s&pageNo=1&numOfRows=1&startCreateDt=%s&endCreateDt=%s")
        :format(ClientData.covid19Client,yesterdayStr,todayStr);

	local KeywordUrl = urlCode.urlEncode(Keyword);
	local Header,Body = corohttp.request("GET",url);
	return myXML.xmlToItem(Body);
end

return module;