--[[
■各権限説明
　None = 何も権限がない

　--役割
　Administrator 	= 管理者（全ての機能が使える）
　Modelator 		= モデレーター（役割表示用でここだけに与えられた権限はない）
　SpecialJudge 	= 特別審査員（特別審査員、投票時大量の点数が入る）

　--機能の権限
　AllowStage 	= この権限を持っている人は舞台に登れる
　CoinCreator 	= この権限を持っている人はコインクリエータが
          　　　　  インベントリーに入り、コイン設置ができる
 
 --投票用
　BackgroundVote	= この権限を持っている人は投票可能になる
 
 --ベイブレードパーク用
　ChangeBeyBo 	= この権限を持っている人はベイボーくんになる
]]
local Role = {
	None = 0,
	--表示する役割
	Administrator = 1,
	Modelator = 2,
	SpecialJudge = 3,
	AllowStage = 4,
	Helper = 5,
	RaceMarinette = 6,
	Marionette = 7,
	
	BackgroundVote = 101,
}
--[[
プレイヤーの役割はRoleの配列
複数登録可能、表示時は１番目のものを表示する
★モデレーターの場合は特に権限とかはなく、役割表示用
]]
local playerRoleList = {
	--ロブラボカンパニー
	[3407099658] = {Name = "Mela", 			Role = {Role.Marionette, Role.RaceMarinette, }},
	[3430010218] = {Name = "nagi_tchi", 	Role = {Role.Marionette, Role.RaceMarinette, }},
	[3381900837] = {Name = "Yakumi", 		Role = {Role.Marionette, Role.RaceMarinette, }},
	[3428655565] = {Name = "ouji", 			Role = {Role.Marionette, Role.RaceMarinette, }},
	[3303260775] = {Name = "puyyotto", 		Role = {Role.Marionette, Role.RaceMarinette, }},
	[5138611155] = {Name = "marco", 		Role = {Role.Marionette, Role.RaceMarinette, }},
	[5138591192] = {Name = "KenmanDayo", 	Role = {Role.Marionette, Role.RaceMarinette, }},
	[3278770848] = {Name = "junjun", 		Role = {Role.Marionette, Role.RaceMarinette, }},
	[-1] 		 = {Name = "test1", 		Role = {Role.Marionette, Role.RaceMarinette, }},
	[-2] 		 = {Name = "test2", 		Role = {Role.Marionette, Role.RaceMarinette, }},
	--モデレーター
	--[[
	[491519466]  = {Name = "Amayuuuma23JP", Role = {Role.Modelator, Role.Administrator, Role.AllowStage}},
	[2751684686] = {Name = "Chuc_ky29matt", Role = {Role.Modelator, Role.Administrator, Role.AllowStage}},
	[2610331629] = {Name = "Marco", 		Role = {Role.Modelator, Role.Administrator, Role.AllowStage, }},
	--[2598768629] = {Name = "NETAKE", 		Role = {Role.Modelator, Role.Administrator, Role.AllowStage}},
	[3047413032] = {Name = "AOchan", 		Role = {Role.Modelator, Role.Administrator, Role.AllowStage}},
	--[1990370372] = {Name = "KenmanYT", 		Role = {Role.Modelator, Role.Administrator, Role.AllowStage}},
	[2575481625] = {Name = "Lynne", 		Role = {Role.Modelator, Role.Administrator, Role.AllowStage, }},
	[2619873331] = {Name = "dondondon_64", 	Role = {Role.Modelator, Role.Administrator, Role.AllowStage}},
	--[2818381716] = {Name = "blackcat_0106", Role = {Role.Modelator, Role.Administrator, Role.AllowStage}},
	[1065426168] = {Name = "coco", 			Role = {Role.Modelator, Role.Administrator, Role.AllowStage}},
	[2649726092] = {Name = "ruri_tchi", 	Role = {Role.Modelator, Role.BackgroundVote, Role.Administrator, Role.AllowStage}},
	[3336310575] = {Name = "kamasetarou", 	Role = {Role.Modelator, Role.Administrator, Role.AllowStage}},
	--特別審査員
	[2962088434] = {Name = "orechan", 		Role = {Role.SpecialJudge, Role.Administrator, Role.AllowStage, }},
	[1810808268] = {Name = "duck", 			Role = {Role.SpecialJudge, Role.Administrator, Role.AllowStage, }},
	[2342279767] = {Name = "Ririchiyo145",	Role = {Role.SpecialJudge, Role.Administrator, Role.AllowStage, }},
	[1672829490] = {Name = "Marchy", 		Role = {Role.SpecialJudge, Role.Administrator, Role.AllowStage, }},
	[4294359212] = {Name = "kanipan", 		Role = {Role.SpecialJudge, Role.Administrator, Role.AllowStage, }},
	[4737598489] = {Name = "tettsun", 		Role = {Role.SpecialJudge, Role.Administrator, Role.AllowStage, }},
	[2208793240] = {Name = "tekito", 		Role = {Role.SpecialJudge, Role.Administrator, Role.AllowStage, }},
	[2341726414] = {Name = "yuzanu", 		Role = {Role.SpecialJudge, Role.Administrator, Role.AllowStage, }},
	--[3568746938] = {Name = "bigfacellc", 	Role = {Role.SpecialJudge, Role.Administrator, Role.AllowStage}},
	
	--おてつだいさん（コラボレーター）
	[3406168569] = {Name = "nyan2_Roblox", 	Role = {Role.Helper}},
	[2871338962] = {Name = "gmdfrtg", 		Role = {Role.Helper}},
	[3166066912] = {Name = "kousandao", 	Role = {Role.Helper}},
	[3975133727] = {Name = "lime_Poyo", 	Role = {Role.Helper}},
	[1669351002] = {Name = "ir30161", 		Role = {Role.Helper}},
	[3370018866] = {Name = "NEONg7mo", 		Role = {Role.Helper}},
	[4702023835] = {Name = "CHEEBANA",		Role = {Role.Helper}},
	[2211305238] = {Name = "Gatoo", 		Role = {Role.Helper}},
	[1489303812] = {Name = "dragon_4528", 	Role = {Role.Helper}},
	[3123375612] = {Name = "nyanko_soba", 	Role = {Role.Helper}},
	[715111243] = {Name = "Rafuriruu", 		Role = {Role.Helper}},
	[2621684227] = {Name = "uparupahamapi",	Role = {Role.Helper}},
	[1143147656] = {Name = "Truekyarasuku",	Role = {Role.Helper}},
	[1648366531] = {Name = "uuh8uuu", 		Role = {Role.Helper}},
	]]

}
--チャットアイコン、タグ設定
local roleIcons ={
	--[[
	[Role.Administrator] 	= "rbxassetid://14771643102",
	[Role.Modelator] 		= "rbxassetid://14771643190",
	[Role.SpecialJudge] 	= "rbxassetid://14771643253",
	]]
}
local roleTags = {
	[Role.Administrator] 	= {Tag = "⚜️", Color = Color3.fromRGB(255,255,255)},
	[Role.Modelator] 		= {Tag = "⚖️", Color = Color3.fromRGB(255,255,255)},
	[Role.SpecialJudge] 	= {Tag = "✨", Color = Color3.fromRGB(255,255,255)},
	[Role.Helper] 			= {Tag = "🔔", Color = Color3.fromRGB(255,255,255)},
}

local module = {}
module.Type = Role

function module:GetPlayerRole(userid)
	local id = tonumber(userid) 
	if playerRoleList[id] and #playerRoleList[id].Role > 0 then
		return playerRoleList[id].Role[1]
	else
		return Role.None
	end
end

function module:GetRoleImage(role)
	return roleIcons[role]
end

function module:GetRoleTag(role)
	return roleTags[role]
end


function module:GetPlayerRoleList()
	return playerRoleList
end

function module:CheckPermission(userid, role)
	local id = tonumber(userid) 
	if playerRoleList[id] and table.find(playerRoleList[id].Role, role) then
		return role
	else
		return false
	end
end

return module
