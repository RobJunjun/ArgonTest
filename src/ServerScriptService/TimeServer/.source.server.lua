local LocalizationService = game:GetService("LocalizationService") 
local region = require(script.region)
local remote = Instance.new("RemoteEvent")
remote.Name = "TimerRemote"
remote.Parent = game.ReplicatedStorage

function printTime(d)
	
	return d.Year.." / "..d.Month.." / "..d.Day.." : "..d.Hour.." / "..d.Minute.." / "..d.Second
	
end

game.Players.PlayerAdded:Connect(function(player)
	local now = DateTime.now()
	print(printTime(now:ToLocalTime()))
	print(printTime(now:ToUniversalTime()))
	
	local utc = now:ToUniversalTime()
	local result, code = pcall(LocalizationService.GetCountryRegionForPlayerAsync, LocalizationService, player)
	
	local adjustTime = DateTime.fromUniversalTime(utc.Year,utc.Month,utc.Day,utc.Hour + 9,utc.Minute,utc.Second)
	print(printTime(adjustTime:ToUniversalTime()))
	
end)