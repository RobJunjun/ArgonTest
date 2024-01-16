local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")

local playerCollisionGroupName = "Players"
PhysicsService:RegisterCollisionGroup("Players")
PhysicsService:CollisionGroupSetCollidable(playerCollisionGroupName,playerCollisionGroupName,false)

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
		object.CollisionGroup = playerCollisionGroupName
		if object.Name == "HumanoidRootPart" then
			object.Anchored = true
		else
			object.Anchored = false
		end
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

local module = {}

function module:SetCollision(character)
	onCharacterAdded(character)
end

return module
