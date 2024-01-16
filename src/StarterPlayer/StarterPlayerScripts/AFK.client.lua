--disable
local TeleportService = game:GetService("TeleportService")
local rejoinTime = 30
local player = game.Players.LocalPlayer
local isTeleported = false
local tpData = TeleportService:GetLocalPlayerTeleportData()
print("tpData ", tpData)

local afkTime = 0 
local totalTime = tpData and tpData.timeValue or 0

local gui = script.RejoinScreen
gui.Parent = player.PlayerGui
game:GetService("RunService").RenderStepped:Connect(function(delta)
	if afkTime >= rejoinTime and not isTeleported then
		isTeleported = true
		TeleportService:Teleport(game.PlaceId, player, { timeValue = totalTime })
	end
	afkTime += delta
	totalTime += delta
	gui.Frame.TextLabel.Text = "AFK.."..math.floor(totalTime)
end)