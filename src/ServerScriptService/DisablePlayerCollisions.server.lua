local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")

local playerCollisionGroupName = "Players"
PhysicsService:RegisterCollisionGroup("Players")
PhysicsService:CollisionGroupSetCollidable(playerCollisionGroupName,playerCollisionGroupName,false)

--gachahall
PhysicsService:RegisterCollisionGroup("GachaStageCoins")
PhysicsService:RegisterCollisionGroup("GachaStageFloor")
PhysicsService:RegisterCollisionGroup("GachaStageWall")
PhysicsService:RegisterCollisionGroup("SubRobo")
PhysicsService:RegisterCollisionGroup("Doll")

PhysicsService:CollisionGroupSetCollidable("GachaStageCoins", "GachaStageCoins", false)
PhysicsService:CollisionGroupSetCollidable("GachaStageCoins", "GachaStageWall", false)
PhysicsService:CollisionGroupSetCollidable("GachaStageCoins", "SubRobo", false)
PhysicsService:CollisionGroupSetCollidable("GachaStageCoins", "Players", false)
PhysicsService:CollisionGroupSetCollidable("GachaStageWall", "SubRobo", false)
PhysicsService:CollisionGroupSetCollidable("SubRobo", "SubRobo", false)
PhysicsService:CollisionGroupSetCollidable("SubRobo", "Players", false)

PhysicsService:CollisionGroupSetCollidable("Doll", "Default", false)
PhysicsService:CollisionGroupSetCollidable("Doll", "Players", false)
PhysicsService:CollisionGroupSetCollidable("Doll", "SubRobo", false)
PhysicsService:CollisionGroupSetCollidable("Doll", "GachaStageWall", false)
PhysicsService:CollisionGroupSetCollidable("Doll", "GachaStageCoins", false)


local previousCollisionGroups = {}

local function setCollisionGroup(object, character)
	local tool = nil 
	local isDoll = false
	if character then
		tool = character:FindFirstChildOfClass("Tool")
		if tool then
			isDoll = object:IsDescendantOf(tool)	
		end
	end
	
	if object:IsA("BasePart") then
		previousCollisionGroups[object] = object.CollisionGroup
		object.CollisionGroup = isDoll and "Doll" or playerCollisionGroupName
	end
end

local function setCollisionGroupRecursive(object)
	setCollisionGroup(object)
	for _, child in ipairs(object:GetChildren()) do
		setCollisionGroupRecursive(child)
	end	
end

local function resetCollisionGroup(object)
	local previousCollisionGroup = previousCollisionGroups[object]
	if not previousCollisionGroup then return end
	
	object.CollisionGroup = previousCollisionGroup
	previousCollisionGroups[object] = nil
end

local function onCharacterAdded(character)
	setCollisionGroupRecursive(character)
	
	character.DescendantAdded:Connect(function(object)
		setCollisionGroup(object, character)
	end)
	character.DescendantRemoving:Connect(resetCollisionGroup)
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(onCharacterAdded)
end

Players.PlayerAdded:Connect(onPlayerAdded)