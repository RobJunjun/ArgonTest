--disable
local remotes = game.ReplicatedStorage.SeatChangerRemotes
local prompts = {}

function createPrompt(seat)
	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "SeatPrompt"
	prompt.HoldDuration = 0.5
	prompt.ActionText = "座る"
	prompt.RequiresLineOfSight = false
	prompt.Parent = seat
	
	prompt.Triggered:Connect(function(player)
		if seat.Occupant ~= nil then return end
		prompt.Enabled = false
		seat:Sit(player.Character.Humanoid)
		remotes.SetSeatPrompts:FireAllClients(prompts)
		local connect
		connect = seat.Changed:Connect(function(str)
			if str == "Occupant" and seat.Occupant == nil then
				connect:Disconnect()
				prompt.Enabled = true
				remotes.SetSeatPrompts:FireAllClients(prompts)
			end
		end)
	end)
	
	return prompt
end

for i, obj in ipairs(game.Workspace:GetDescendants()) do
	if obj:IsA("Seat") then
		obj.Disabled = true 
		table.insert(prompts, createPrompt(obj))
	end
end  