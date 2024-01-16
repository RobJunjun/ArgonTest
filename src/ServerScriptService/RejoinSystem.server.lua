--disable
local TeleportService = game:GetService("TeleportService")
local remotes = game.ReplicatedStorage.RejoinSystemRemotes
local rejoinTime = 60

game.Players.PlayerAdded:Connect(function(player)
	remotes.init:FireClient()
end)

remotes.init.OnServerEvent:Connect(function(player)
	local intValue = Instance.new("IntValue")
	intValue.Value = 0
	intValue.Name = "Timer"
	intValue.Parent = player
end)

game:GetService("RunService").Heartbeat:Connect(function(delta)
	for i, player in ipairs(game.Players:GetPlayers()) do
		if player:FindFirstChild("Timer") then
			player.Timer.Value += delta
			if player.Timer.Value >= rejoinTime then
				TeleportService:TeleportAsync()
			end
		end
	end
end)