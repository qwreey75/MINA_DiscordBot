--[[

[여러개 감싸기]
여러개가 필요한경우 {} 로 감싸서 , 로 하나하나 분리함
예 : {"안녕","안뇽","ㅎㅇ"}

주석쓰기]
그냥 노트가 필요한경우 -- 를 붇여서 노트를 사용 가능함
예 : -- 노트하기[

 말한사람 언급하기
만약 말한사람 언급이 필요한경우 {%:UserName:%} 을 사용할 수 있음
예 : "안녕하세요 {%:UserName:%} 님!"

[func 를 이용한 세부 반응]
나중에 가면 func 라는걸로 좀더 세세한 기능을 만들 수도 있음
함수 기능이기 때문에 여기에 string 라이브러리를 쓰거나
렌덤 라이브러리를 쓰거나 할 수도 있음
예 :
-- 주사위 굴리기
reply = function(message,args,Content)
    returns ("나온 수는 %d 이에요!"):format(cRandom(1,6));
end;
당연히 여러 반응과 묶을수도 있음
reply = {
    function(message,args,Content)
        returns ("나온 수는 %d 이에요!"):format(cRandom(1,6));
    end,
    "주사위를 찾지 못했어요",
    "어이쿠! 주사위를 떨어트렸어요",
    function(message,args,Content)
        returns ("(대구르르르...) 나온 수는 %d 이에요!"):format(cRandom(1,6));
    end
};

[글자 반복]
금사향! 금사향! 금사향! 처럼 반복되는걸 만들려면
string.rep("반복할 글자",1)
을 쓸 수 있음, 반복할 글자에는 원하는거 집어넣고 숫자부분엔
반복할 수를 추가하면 됨
예 :
reply = {"학교폭력 멈춰!",string.rep("멈춰! ",20)};
단독으로도 사용 가능
reply = string.rep("멈춰! ",20);

!!!sync
]]

local cRandom,json,client,discordia,enums,iLogger,makeId,urlCode,strSplit,ACCOUNTData;
return function (o)
    cRandom,json,client,discordia,enums,iLogger,makeId,urlCode,strSplit,ACCOUNTData = 
    o.cRandom,o.json,o.client,o.discordia,o.enums,o.iLogger,o.makeId,o.urlCode,o.strSplit
    ,o.ACCOUNTData;
    -- 여기에는 쓰지 맙쇼
    -- 기능을 임포트 하는 용도로 있는곳

    return {
        ["끝말잇기"] = { -- 나중에 기능 추가하면 이전 예정
            alias = "끝말 잇기";
            reply = "크시랑 하세요";
        };
        ["멈춰"] = {
            alias = {"학교폭력","학교폭력"};
            reply = {"학교폭력멈춰!","멈춰어어!!",string.rep("멈춰! ",20)};
        };
        ["장비를 정지합니다"] = {
            alias = {"장비를정지합니다","정지합니다"};
            reply = "어, 정..정지가 앙 돼. 정지시킬 수가 없어";
        };
        ["울프럼알파"] = {
            alias = "울프럼 알파";
            reply = "우린 답을 찾을것이다, 늘 그랬듯이";
        };
        ["수소"] ={
            alias = "Hydrogen";
            reply = "우주에서 가장 처음으로 만들어진 원소예요";
        };
        ["백만볼트"] ={
            reply = "피카 츄!!?";
        };
        ["헬륨"] ={
            alias = "Helium";
            reply = "세상에서 가장 유명한 비활성 기체예요";
        };
        ["심심해"] = {
            alias = {"심심하다","심심함"};
            reply = "놀아줄까?";
        };
        ["레고"] = {
            reply = "밟았어!";
        };
        ["뭫"] ={
            reply = "묑?"
        };
        ["술"] ={
            alias = {
                "참이슬", 
                "막걸리",
                "포도주",
                "맥주",
                "와인",
                "샴페인",
                "칵테일",
                "청주",
                "크바스",
                "소주",
                "코냑",
                "고량주",
                "위스키",
                "보드카",
                "럼주",
                "발티카"
            };
            reply = "봇은 술을 못 마셔요";
        };
        ["젤다"] = {
            alias = "젤다의 전설","젤다의전설";
            reply = "초록색 옷 입은 애가 젤다죠";
        };
        ["젤다의 전설 브레스 오브 더 와일드"] = {
            alias = {"젤다의전설브레스오브더와일드","젤다의 전설브레스오브와일드","젤다의 전설 브레스오브와일드","젤다의 전설 브레스 오브더와일드","젤다의 전설 브레스 오브 더와일드","젤다의 전설 브레스 오브 더 와일드","젤다의전설브레스오브더 와일드","젤다의전설브레스오브 더 와일드","젤다의전설브레스 오브 더 와일드","젤다의전설 브레스 오브 더 와일드"};
            reply = {"이젠 파란색 옷 입은 애가 젤다죠"};
        };
        ["도박"] = {
            alias = {"돈넣고돈먹기","돈넣고 돈먹기","돈놀이","카지노"};
            reply = {"도박과 가까워지는 순간 인생은 곧 파멸이에요",
                     "도박은 돈을 얻을 확률보다 잃을 확률이 압도적으로 많아요",
                     "이런 단순한 호기심에 도박을 하지요"};
        };
        ["바보"] = {
            reply = {"바보는 크시 선배님이죠^^","미나 바부 아니라구!(울먹)",":broken_heart: - 5"};
        };
        ["왈도체"] = {
            reply = {"안녕하신가! 힘세고 강한 아침, 만일 내게 물어보면 나는 미나.",
                     "번역자가 한 글자 한 글자 정성스럽게 오역하여 만들어진 문체예요"};
        };
        ["팀왈도"] = {
            reply = {"우리는 한다 번역을"};
        };
        ["왜"] = {
            alias = {"왱","왜?","왱?"};
            reply = {"나도 몰라"};
        };
        ["수정"] = {
            alias = {"수정!","!수정","디버그","고치기","고쳐"};
            reply = {"싫어","개발자한테 말해"};
        };
        ["건강"] = {
            reply = {"건강이 최고예요:heartpulse:"};
        };
        ["운동"] = {
            reply = {"지나친 운동은 몸에 해로워요",
                     "시간에 따라 물체의 위치가 변하는 것이에요",
                     "건강하기 위한 필수 조건!",
                     "봇도 운동을 해야 할까요?",
                     "적절한 운동이 가장 좋아요"};
        };
        ["자살"] = {
            reply = {"힘들면 연락해 기다릴게"};
        };
        ["숙제"] = {
            reply = {"니가 해"};
        };
        ["과제"] = {
            reply = {"과제 갯수 제한 쫌;;"};
        };
        ["롤"] = {
            alias = {"리그오브레전드",
                     "리그 오브 레전드",
                     "리그 오브레전드",
                     "리그오브 레전드",
                     "League of Legends",
                     "League ofLegends",
                     "Leagueof Legends",
                     "LeagueofLegends"};
            reply = {"정웅왈 ㅅㅂ게임",
                     "부모님 안부 묻는 겜",
                     "팀운 ㅈ망겜"};
        };
        ["lol"] = {
            reply = "lol";
        };
        ["없어?"] = {
            alias = {"없냐고"};
            reply = {"없어!?"};
        };
        ["뭐가"] = {
            alias = {"뭐가?"};
            reply = {"뭐?"};
        };
        ["조용해"] = {
            alias = {"조용","조용!","!조용","조용히 해","조용히해"};
            reply = {"조금 시끄럽긴 하죠?","알았어요"};
        };
        ["4rajindo"] = {
            alias = {"4라진도","사라진도"};
            reply = {"사라진다 아니에요?",
                     "저를 주인님과 만들어준 아주 ~~나쁜~~ 착한 분이에요!"};
        };
        ["국립국어원"] = {
            reply = "저도 여기에서 도움을 받아요.";
        };
        ["똑똑하다"] = {
            reply = {"나도 그렇게 생각해"};
        };
        ["성별"] = {
            reply = {"딱 보면 알 수 있잖아요!"};
        };
        ["여자"] = {
            alias = {"남자"};
            reply = {"미나의 성별은 뭘까요~?",
                     "미나의 성별은 무엇일까요? 맞춰 보세요!"};
        };             
        ["여성"] = {
            reply = {"맞아요"};
        };
        ["남성"] = {
            reply = {"내가 남자겠니?"};
        };
        ["힘들어"] = {
           reply = {"언젠가 이 힘든 날조차 잊히는 행복이 **{%:UserName:%}**님께 오리라고 믿어 의심치 않을 게요! 파이팅!",
                     "저는 **{%:UserName:%}**님이 항상 노력하신다는 걸 알고 있어요? ...어떻게 아냐구요? **비밀!**"}
        };
    };
end;
