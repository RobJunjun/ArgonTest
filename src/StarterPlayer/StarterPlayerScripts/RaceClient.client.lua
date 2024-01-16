local Remotes = game.ReplicatedStorage.RaceMarionetteRemotes
local player = game.Players.LocalPlayer
local localRecord = {}
local recordEnabled = false

local minRecordLength = 2
local prevPos = nil
local prevfps = 0
function ClientRecord(bool)
	if bool then
		recordEnabled = true
		return false
	else
		local result = table.clone(localRecord)
		if #result == 0 then
			result = false
		end
		recordEnabled = false
		table.clear(localRecord)
		prevPos = nil
		prevfps = 0
		return result
	end
end

Remotes.SetRecord.OnClientInvoke = ClientRecord
game:GetService("RunService").RenderStepped:Connect(function(delta)
	if recordEnabled then
		local character = player.Character
		if character and character.PrimaryPart then
			local pivot = character:GetPivot()
			if prevPos and (pivot.Position - prevPos).Magnitude > minRecordLength then
				--print("Recording...")
				local data = {
					--jump = {isJump = character.Humanoid.Jump, assetId = ""},
					--move = {isMove = character.Humanoid.MoveDirection.Magnitude > 0, assetId = ""},
					state = character.Humanoid:GetState().Value, 
					CFrame = {pivot:GetComponents()},
					fps	   = prevfps 
				}
				table.insert(localRecord, data)
				prevPos = pivot.Position
				prevfps = 0
			elseif prevPos == nil then
				prevPos = pivot.Position
				prevfps = 0
			else
				--warn("Not Recording")
				prevfps += delta
			end 
		end
	end
end)