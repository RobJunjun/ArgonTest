local isOn = false
local scframe = script.Parent.ScrollingFrame
local selected = {}

function updateList(data)
	for i, list in ipairs(scframe:GetChildren()) do
		if list:IsA("UIListLayout") then continue end
		if list.Visible then
			list:Destroy()
		end
	end 
	
	scframe.Visible = true
	
	for i, page in ipairs(data) do
		for j, plrData in ipairs(page) do
			local prefab = scframe.ListPrefab:Clone()
			prefab.Parent = scframe
			prefab.Visible = true
			
			if plrData.id > 0 then
				prefab.playername.Text = game.Players:GetNameFromUserIdAsync(plrData.id)
				prefab.thumb.Image = game.Players:GetUserThumbnailAsync(plrData.id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			end
			prefab.laps.Text = plrData.laps / 100
			if selected[plrData.id] then
				prefab.checkBox.Text = "✔"
			else
				prefab.checkBox.Text = " "
			end
			
			prefab.Button.MouseButton1Click:Connect(function()
				if not selected[plrData.id] then
					print("select")
					selected[plrData.id] = true
					prefab.checkBox.Text = "✔"
				else
					print("unselect")
					selected[plrData.id] = nil
					prefab.checkBox.Text = " "
				end
			end)
		end
	end
end

script.Parent.OnOff.MouseButton1Click:Connect(function()
	if isOn then
		isOn = false
		script.Parent.OnOff.Text = "+"
		scframe.Visible = false
	else
		isOn = true
		script.Parent.OnOff.Text = "ー"
		local data = game.ReplicatedStorage.RaceMarionetteRemotes.GetRacerList:InvokeServer()
		updateList(data)
	end
end)

script.Parent.buttonPlay.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.forTest.play:FireServer()
end)

script.Parent.buttonReady.MouseButton1Down:Connect(function()
	game.ReplicatedStorage.forTest.ready:FireServer(selected)
end)