--disable
local TextChatService 	= game:GetService("TextChatService")
local ChatService		= game:GetService("Chat")
local player			= game.Players.LocalPlayer
local gui = script.Parent


gui.DisableTextsButton.MouseButton1Click:Connect(function()
	--[[
	if TextChatService.BubbleChatConfiguration.Enabled  then
		TextChatService.BubbleChatConfiguration.Enabled = false
		for i, plr in ipairs(game.Players:GetPlayers()) do
			local humanoid = plr.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			end
		end
		local folder = game.Workspace:FindFirstChild("CharacterFolder")
		for i, chara in ipairs(folder:GetChildren()) do
			local humanoid = chara:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			end
		end
		gui.DisableTextsButton.BackgroundColor3 = Color3.fromRGB(100,100,100)
	else
		TextChatService.BubbleChatConfiguration.Enabled = true
		for i, plr in ipairs(game.Players:GetPlayers()) do
			local humanoid = plr.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
			end
		end
		local folder = game.Workspace:FindFirstChild("CharacterFolder")
		for i, chara in ipairs(folder:GetChildren()) do
			local humanoid = chara:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
			end
		end
		gui.DisableTextsButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
	end 
	]]
	if ChatService.BubbleChatEnabled  then
		ChatService.BubbleChatEnabled = false
		for i, plr in ipairs(game.Players:GetPlayers()) do
			local humanoid = plr.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			end
		end
		local folder = game.Workspace:FindFirstChild("CharacterFolder")
		if folder then
			for i, chara in ipairs(folder:GetChildren()) do
				local humanoid = chara:FindFirstChild("Humanoid")
				if humanoid then
					humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
				end
			end
		end
		gui.DisableTextsButton.BackgroundColor3 = Color3.fromRGB(100,100,100)
	else
		ChatService.BubbleChatEnabled = true
		for i, plr in ipairs(game.Players:GetPlayers()) do
			local humanoid = plr.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
			end
		end
		local folder = game.Workspace:FindFirstChild("CharacterFolder")
		if folder then
			for i, chara in ipairs(folder:GetChildren()) do
				local humanoid = chara:FindFirstChild("Humanoid")
				if humanoid then
					humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
				end
			end
		end
		gui.DisableTextsButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
	end 
end)

player.PlayerGui:WaitForChild("BubbleChat").ChildAdded:Connect(function(chat)
	print(chat)
	chat:WaitForChild("BillboardFrame").Visible = false
end)