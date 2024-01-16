local InsertService = game:GetService("InsertService")
local emotesFolder = Instance.new("Folder")
emotesFolder.Name = "EmoteAssets"
emotesFolder.Parent = game.ReplicatedStorage

local module = {}
function module:LoadEmotes(emotedict)
	for i, data in ipairs(emotedict) do
		local loadedEmote = InsertService:LoadAsset(data.emote)
		loadedEmote.Name = data.name
		loadedEmote.Parent = emotesFolder
	end
end
return module
