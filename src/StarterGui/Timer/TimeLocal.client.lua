function printTime(d)

	return d.Year.." / "..d.Month.." / "..d.Day.." : "..d.Hour.." / "..d.Minute.." / "..d.Second

end

game.ReplicatedStorage:WaitForChild("TimerRemote").OnClientEvent:Connect(function(timestamp)
	print(printTime(timestamp:ToLocalTime()))
	print(printTime(timestamp:ToUniversalTime()))
	
	local now = DateTime.now()
	print(printTime(now:ToLocalTime()))
	print(printTime(now:ToUniversalTime()))
end)