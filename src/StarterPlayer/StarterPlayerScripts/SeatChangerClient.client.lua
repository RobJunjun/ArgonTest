local remotes = game.ReplicatedStorage.SeatChangerRemotes

remotes.SetSeatPrompts.OnClientEvent:Connect(function(list)
	local character = game.Players.LocalPlayer.Character
	local humanoid = character:WaitForChild("Humanoid")
	
	for i, prompt in list do
		if humanoid.Sit then
			prompt.Enabled = false
		else
			if prompt.Parent.Occupant == nil then
				prompt.Enabled = true	
			else
				prompt.Enabled = false
			end
		end
	end
end)