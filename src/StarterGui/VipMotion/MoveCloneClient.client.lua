local Players 			= game:GetService("Players")
local RunService 		= game:GetService("RunService")
local TextChatService	= game:GetService("TextChatService")
local ChatService		= game:GetService("Chat")
local UserInputService  = game:GetService("UserInputService")
local remotes = game.ReplicatedStorage.MoveCloneRemotes
local curTime = 0
local Enabled = false
local HoldingControl = false
local KeyMapping = {
	[Enum.KeyCode.One] 	 = 1,
	[Enum.KeyCode.Two] 	 = 2,
	[Enum.KeyCode.Three] = 3,
	[Enum.KeyCode.Four]  = 4,
	[Enum.KeyCode.Five]  = 5,
	[Enum.KeyCode.Six] 	 = 6,
	[Enum.KeyCode.Seven] = 7,
	[Enum.KeyCode.Eight] = 8,
	[Enum.KeyCode.Nine]  = 9,
	[Enum.KeyCode.Zero]  = 10,
}

local gui = script.Parent
local AnimList = require(remotes.VipMotionReplicated.AnimList)

local CloneBubbleDegign = {
	CornerRadius = UDim.new(1, 0),
	MaxWidth = 380,
	TailVisible = true,
	Transparency = 0.06,
	TextSize = 18,
	TextColor3 = Color3.fromRGB(232, 232, 232),
	Font = Enum.Font.Cartoon,
	Padding = 10,
	BackgroundGradient = {
		Enabled = true,
		Rotation = 90,
		Color = ColorSequence.new(Color3.fromRGB(0, 208, 255), Color3.fromRGB(43, 141, 247)),
	},
	MaxDistance = math.huge,
	MinimizeDistance = math.huge,
}

local bubbleChatSettings = {
	UserSpecificSettings = {}
}

local curPage = 1
local viewEmotePerPage = 4
local maxPage = math.round(#AnimList / viewEmotePerPage) 
local buttonConnects = {}
local animStoppedConnect = nil
local moveCopyTime = 20

function stopAllAnim()
	local chara = Players.LocalPlayer.Character
	local tracks = chara.Humanoid.Animator:GetPlayingAnimationTracks();
	for i, track in pairs(tracks) do
		if track.Priority == Enum.AnimationPriority.Action4 then
			track:Stop();
		end
	end	
end

function setPage(page)
	if page > maxPage then
		curPage = 1
	elseif page <= 0 then
		curPage = maxPage
	else
		curPage = page
	end
	
	for i, con in ipairs(buttonConnects) do
		if con ~= nil then
			con:Disconnect()
		end
	end
	table.clear(buttonConnects)
	local idx = 1
	if curPage > 1 then
		idx = ((curPage-1) * viewEmotePerPage) + 1
	end
	
	for i, emoteButton in ipairs(gui.Frame.MotionListFrame:GetChildren()) do
		if emoteButton:IsA("ImageButton") then
			local animData = AnimList[idx]
			idx += 1
			if animData then
				emoteButton.Visible = true
				emoteButton.Image = animData.image
				table.insert(buttonConnects, emoteButton.MouseButton1Click:Connect(function()
					local asset = game.ReplicatedStorage.EmoteAssets:FindFirstChild(animData.name)
					if asset then
						stopAllAnim()
						local animation = asset:GetChildren()[1]
						local chara = Players.LocalPlayer.Character
						local track = chara.Humanoid.Animator:LoadAnimation(animation)
						track.Priority = Enum.AnimationPriority.Action4
						track:Play()
						remotes.EmoteClone:FireServer(animData.name)
						
						if animStoppedConnect ~= nil then
							animStoppedConnect:Disconnect()
						end
						animStoppedConnect = chara.Humanoid.Running:Connect(function(speed)
							if speed > 0 then
								if animStoppedConnect ~= nil then animStoppedConnect:Disconnect() end	
								track:Stop()
							end
						end)
					end
				end)) 
			else
				emoteButton.Visible = false
			end
		end
	end
end

function guiInit()
	curPage = 1
	setPage(curPage)
	
	gui.Frame.NextButton.MouseButton1Click:Connect(function()
		setPage(curPage+1)
	end)
	
	gui.Frame.PrevButton.MouseButton1Click:Connect(function()
		setPage(curPage-1)
	end)
end

remotes.SetEnabled.OnClientEvent:Connect(function(bool)
	--20230913 GUI非表示
	--gui.Enabled = bool
	--gui.VipMotionButton.Visible = bool
	gui.Enabled = false
	gui.VipMotionButton.Visible = false
	gui.Frame.Visible = false
	if bool and not Enabled then
		Enabled = bool
		RunService.RenderStepped:Connect(function(delta)
			if curTime >= moveCopyTime then
				curTime = 0
				remotes.MoveClone:FireServer()	
			end
			curTime += delta
		end)
		
		gui.VipMotionButton.MouseButton1Click:Connect(function()
			gui.Frame.Visible = not gui.Frame.Visible
		end)
		guiInit()
	end
end)

remotes.Chat.OnClientEvent:Connect(function(part, message, log)
	if bubbleChatSettings.UserSpecificSettings[part:GetFullName()] == nil then
		bubbleChatSettings.UserSpecificSettings[part:GetFullName()] = CloneBubbleDegign
		ChatService:SetBubbleChatSettings(bubbleChatSettings)
	end
	
	ChatService:Chat(part, message)
	game.StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = log,
	})
	
	--TextChatService:DisplayBubble(part, message)
	--Channel:DisplaySystemMessage(log)
end)

function playMotion(keycode)
	if not Enabled  then return end
	local animData = AnimList[KeyMapping[keycode]]
	if animData then
		local asset = game.ReplicatedStorage.EmoteAssets:FindFirstChild(animData.name)
		if asset then
			stopAllAnim()
			local animation = asset:GetChildren()[1]
			local chara = Players.LocalPlayer.Character
			local track = chara.Humanoid.Animator:LoadAnimation(animation)
			track.Priority = Enum.AnimationPriority.Action4
			track:Play()
			remotes.EmoteClone:FireServer(animData.name)

			if animStoppedConnect ~= nil then
				animStoppedConnect:Disconnect()
			end
			animStoppedConnect = chara.Humanoid.Running:Connect(function(speed)
				if speed > 0 then
					if animStoppedConnect ~= nil then animStoppedConnect:Disconnect() end	
					track:Stop()
				end
			end)
		end
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not Enabled then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftControl then
			HoldingControl = true
		elseif KeyMapping[input.KeyCode] and HoldingControl then
			playMotion(input.KeyCode)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if not Enabled then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.LeftControl then
			HoldingControl = false
		end
	end
end)
