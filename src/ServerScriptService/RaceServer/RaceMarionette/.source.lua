local TweenService			= game:GetService("TweenService")
local HttpService 			= game:GetService("HttpService")
local RunService 			= game:GetService("RunService")
local DataStoreService		= game:GetService("DataStoreService")
local DisableCollisions 	= require(script.DisableCollisions)
local LogDataStore 		= DataStoreService:GetDataStore(script.Conf.DbName.Value)
local LapTimeDataStore 	= DataStoreService:GetOrderedDataStore("lapTime"..script.Conf.DbName.Value)

local Remotes = game.ReplicatedStorage.RaceMarionetteRemotes
local Records = {}
local LapTimes = {}
local CloneCharacters = {}
local LoadedAnims = {}
local RecordPlayingList = {}
local CharacterFolder = Instance.new("Folder")
CharacterFolder.Parent = game.Workspace
CharacterFolder.Name = "CharacterFolder"

local debugmode = false

local module = {}

function createDebugParts(rec)
	for j, data in rec.record do
		local part = Instance.new("Part")
		part.Anchored = true
		part.Size = Vector3.new(1,1,1)
		part.CFrame = data.CFrame
		part.Parent = game.Workspace
	end
end

function createPlayerCopy(userid, name, startCf)
	CloneCharacters[userid] = false
	LoadedAnims[userid] = false
	local charid = 3407099658
	if tonumber(userid) > 0 then
		charid = tonumber(userid) 
	end
	local chara = game.Players:CreateHumanoidModelFromUserId(charid)
	chara.Name = name
	CloneCharacters[userid] = chara
	LoadedAnims[userid] = {}
	chara:PivotTo(startCf)
	DisableCollisions:SetCollision(chara)
	chara.Parent = CharacterFolder
end

function getAnim(userid, state)
	if LoadedAnims[userid][state] then
		return LoadedAnims[userid][state]
	else
		local humanoid = CloneCharacters[userid]:FindFirstChild("Humanoid")
		if humanoid then
			local asset
			if state == Enum.HumanoidStateType.Running.Value then
				asset = script.Run
			elseif state == Enum.HumanoidStateType.Jumping.Value then
				asset = script.Jump
			elseif state == Enum.HumanoidStateType.Freefall.Value then
				asset = script.Fall
			end
			if asset then
				LoadedAnims[userid][state] = humanoid:LoadAnimation(asset)
			end
		end
		return LoadedAnims[userid][state]
	end
end

function setCharaAnimation(userid, state)
	if not CloneCharacters[userid] then
		warn("not ready player character ", userid)
		return
	end
	local humanoid = CloneCharacters[userid]:FindFirstChild("Humanoid")
	local animator = humanoid and humanoid:FindFirstChild("Animator")
	if animator then
		local anim = getAnim(userid, state)
		if anim and not anim.IsPlaying then
			local animTracks = animator:GetPlayingAnimationTracks()
			for i,track in ipairs(animTracks) do
				track:Stop(0)
				track:Destroy()
			end
			anim:Play()
		end
	end
end

function playRecordTweens(userid, rec)
	if not CloneCharacters[userid] then
		warn("not ready player character ", userid)
		return
	end
	local tweens = {}
	for i, data in rec.record do
		if CloneCharacters[userid] then
			table.insert(tweens, TweenService:Create(CloneCharacters[userid].PrimaryPart, TweenInfo.new(data.fps, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), { CFrame = data.CFrame }))
		end
	end

	if #tweens > 1 then
		for i, tw in tweens do
			if i < #tweens then
				tweens[i].Completed:Connect(function()
					tweens[i+1]:Play()
					if rec.record[i+1] then
						setCharaAnimation(userid, rec.record[i+1].state)
					else
						warn("record not found in tweens ", rec)
					end
				end)
			elseif i >= #tweens then
				tweens[i].Completed:Connect(function()
					task.wait(2)
					table.remove(RecordPlayingList, table.find(RecordPlayingList, userid))
					module:RemovePlayerCharacter(userid)
				end)
			end
		end	
	end
	
	tweens[1]:Play()
	setCharaAnimation(userid, rec.record[1].state)
	table.insert(RecordPlayingList, userid)
end

game.Players.PlayerAdded:Connect(function(player)
	--対象の記録を読み込むなければ０
	LapTimes[player.UserId] = LapTimeDataStore:GetAsync(player.UserId)
	if not LapTimes[player.UserId] then
		LapTimes[player.UserId] = 0
	else
		LapTimes[player.UserId] = LapTimes[player.UserId] / 100
	end
end)

function module:RemovePlayerRecord()
	table.clear(Records)
end

--プレイヤー動き記録開始
function module:StartRecord(player)
	Remotes.SetRecord:InvokeClient(player, true)
end

--プレイヤー動き記録終了
--保存するか判断するBoolを返す
function module:EndRecord(player, lapTime)
	print("GOAL!! lapTime :: ",tonumber(lapTime / 100), tonumber(LapTimes[player.UserId]))

	--新記録のみ保存
	if debugmode or tonumber(lapTime / 100) < tonumber(LapTimes[player.UserId]) then
		--記録は小数点２げたまで獲得
		local rec = Remotes.SetRecord:InvokeClient(player, false)
		LapTimeDataStore:SetAsync(player.UserId, lapTime)
		if rec then
			Records[player.UserId] = {Name = player.Name, record = rec}
		else
			warn("recording invoke failure ", rec)
		end
		return true
	end
	return false
end

--プレイヤーごとに移動ログを保存
function module:SaveRecord(userid)
	if Records[userid] then
		local encoded = HttpService:JSONEncode(Records[userid])
		--print("encoding data", encoded)
		print("encoding Length", encoded:len())
		LogDataStore:SetAsync("log/"..userid, encoded)
	else
		warn("record not found")
	end
end

--プレイヤーの移動ログを獲得
function module:LoadRecord(userid)
	local loadRecord = LogDataStore:GetAsync("log/"..userid)
	if loadRecord then
		local decoded = HttpService:JSONDecode(loadRecord)
		for i, dat in decoded.record do
			dat.CFrame = CFrame.new(table.unpack(dat.CFrame))
		end
		
		print("loadRecord ::", decoded)
		Records[userid] = decoded
	else
		warn("load record failure ", userid)
	end
end

function module:PlayRecords()
	if #RecordPlayingList > 0 then
		warn("aleary record playing")
		return
	end
	for userid, data in pairs(Records) do
		--createDebugParts(data)
		playRecordTweens(userid, data)
	end
end

function module:RemovePlayerCharacter(userid)
	if CloneCharacters[userid] then
		CloneCharacters[userid]:Destroy()
		CloneCharacters[userid] = nil
	end
end

function module:RemoveAllCharacters()
	for userid, chara in pairs(CloneCharacters) do
		chara:Destroy()
	end
	table.clear(CloneCharacters)
	table.clear(RecordPlayingList)
end

--記録が存在するプレイヤーのキャラを作成、待機
function module:ReadyPlayerCharacters()
	module:RemoveAllCharacters()
	for userid, data in pairs(Records) do
		createPlayerCopy(userid, data.Name, data.record[1].CFrame)
	end
end

--記録が保存するプレイヤーデータリストを取得
function module:GetRacerDataList(size)
	local pages = LapTimeDataStore:GetSortedAsync(false, size)
	local curPage = pages:GetCurrentPage()
	--[[
	key : userId
	value = lapTime
	]]
	local pageIndex = 1
	local result = {}
	while true do
		result[pageIndex] = {}
		for i, dat in ipairs(curPage) do
			table.insert(result[pageIndex], { id = tonumber(dat.key), laps = tonumber(dat.value)})
		end
		if pages.IsFinished then
			break
		end
		pageIndex += 1
		pages:AdvanceToNextPageAsync()
	end
	return result
end

--記録が保存するプレイヤーデータを取得
function module:GetRacerData(userid)
	local data = LapTimeDataStore:GetAsync(userid)
	if data then
		return { id = tonumber(data.key), laps = tonumber(data.value) }
	end
end

function module:ResetRecords()
	
end

return module
