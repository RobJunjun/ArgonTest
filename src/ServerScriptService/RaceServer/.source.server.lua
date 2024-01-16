--disable
local MessagingService = game:GetService("MessagingService")
local HttpService = game:GetService("HttpService")
local Zone = require(game.ReplicatedStorage.Zone)
local RaceMarionette = require(script.RaceMarionette)
local Role = require(game.ServerStorage.Role)
local start = Zone.new(game.Workspace.Race.Start)
local goal  =  Zone.new(game.Workspace.Race.Goal)
local lapTimes = {}

game.Players.PlayerAdded:Connect(function(player)
	lapTimes[player.UserId] = {isRecording = false, lapTime = 0}
end)

start.playerExited:Connect(function(player)
	print(("player '%s' start Recording!"):format(player.Name))
	lapTimes[player.UserId].isRecording = true
	lapTimes[player.UserId].lapTime = 0

	RaceMarionette:StartRecord(player)
end)

goal.playerEntered:Connect(function(player)
	print(("player '%s' end Recording!"):format(player.Name))
	if lapTimes[player.UserId] and lapTimes[player.UserId].isRecording then
		lapTimes[player.UserId].isRecording = false
		local isNew = RaceMarionette:EndRecord(player, math.floor(lapTimes[player.UserId].lapTime * 100))
		if isNew then
			RaceMarionette:SaveRecord(player.UserId)
		end
	end
	player.Character:PivotTo(game.Workspace.SpawnLocation.CFrame + Vector3.new(0, 2, 0))
end)

game:GetService("RunService").Heartbeat:Connect(function(delta)
	for userid, dat in pairs(lapTimes) do
		if dat.isRecording then
			dat.lapTime += delta
		end
	end
end)
local READY = "MARIONETTE_RACE_READY"
local PLAY = "MARIONETTE_RACE_PLAY"
--ログ再生準備
--仮：選択したプレイヤーリストのログデータを取得、キャラ生成
MessagingService:SubscribeAsync(READY, function(response)
	local decoded = HttpService:JSONDecode(response.Data)
	local userid = tonumber(decoded.userid)
	if Role:CheckPermission(userid, Role.Type.RaceMarinette) then
		RaceMarionette:RemovePlayerRecord()
		
		for id, val in pairs(decoded.selectedList) do
			RaceMarionette:LoadRecord(id)
		end 
		
		RaceMarionette:ReadyPlayerCharacters()		
	end
end)

MessagingService:SubscribeAsync(PLAY, function(response)
	local userid = response.Data
	if Role:CheckPermission(userid, Role.Type.RaceMarinette) then
		RaceMarionette:PlayRecords()	
	end
end)

game.ReplicatedStorage.forTest.ready.OnServerEvent:Connect(function(player, selectedList)
	local data = {}
	data.userid = player.UserId
	data.selectedList = selectedList
	local encoded = HttpService:JSONEncode(data)
	MessagingService:PublishAsync(READY, encoded)
end)

game.ReplicatedStorage.forTest.play.OnServerEvent:Connect(function(player)
	MessagingService:PublishAsync(PLAY, player.UserId)
end)

game.ReplicatedStorage.RaceMarionetteRemotes.GetRacerList.OnServerInvoke = function()
	return RaceMarionette:GetRacerDataList(10)
end