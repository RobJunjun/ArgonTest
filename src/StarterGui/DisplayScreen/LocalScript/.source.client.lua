--disable
--[[
	If you don't understand how to use this, see:
	https://devforum.roblox.com/t/live-camera-feed-script-using-viewportframe-handler/1237932
	
	I did not make ViewportHandler, I did make this module to use it though.
	
	-- Steven4547466
]]

game.Workspace.camera1:WaitForChild("eye")

local Enabled = true

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ViewportHandler = require(script:WaitForChild("ViewportHandler"))
local Config = require(script:WaitForChild("Config"))

local Frame = script.Parent:WaitForChild("ViewportFrame")
local VF_Handler = ViewportHandler.new(Frame)
local cam = Instance.new("Camera")
cam.FieldOfView = Config.FOV

RunService:BindToRenderStep("UpdateCameraEye", Enum.RenderPriority.Camera.Value - 1, function()
	cam.CFrame = Config.CameraEye.CFrame
end)

if Config.AdornOnEnable then
	local tool = Config.Adornee:FindFirstAncestorWhichIsA("Tool")
	if tool then
		Enabled = false
		tool.Equipped:Connect(function()
			Enabled = true
			script.Parent.Adornee = Config.Adornee
			script.Parent.Face = Config.AttachToFace
		end)

		tool.Unequipped:Connect(function()
			Enabled = false
			script.Parent.Adornee = nil
		end)
	else
		script.Parent.Adornee = Config.Adornee
		script.Parent.Face = Config.AttachToFace
	end
end

Frame.CurrentCamera = cam

local renderedObjects = {}

function getTopLevelModel(part)
	local model = part:FindFirstAncestorWhichIsA("Model")
	while model.Parent ~= workspace do
		local temp = model
		model = model:FindFirstAncestorWhichIsA("Model")
		if model == workspace or model == nil then model = temp end
	end
	return model
end

local cameraModel = getTopLevelModel(Config.CameraEye)

function getPartHandler(part)
	for p, h in pairs(renderedObjects) do
		if p == part then return h end
	end
	return nil
end

function partInFieldOfVision(part)
	if part:IsA("Model") then part = part.Head end
	for i = 0, part.Size.X, 5 do
		for j = 0, part.Size.Y, 2 do
			for k = 0, part.Size.Z, 5 do
				local point = part.CFrame * CFrame.new((-part.Size.X/2)+i, (-part.Size.Y/2)+j, (-part.Size.Z/2)+k)
				local vector = (point.Position - cam.CFrame.Position)
				local magnitude = vector.Magnitude
				if magnitude > Config.CameraRange then continue end
				local dir = vector.unit
				local angle = math.deg(math.acos(cam.CFrame.LookVector:Dot(dir)))	
				if angle < cam.FieldOfView then
					return true
				end
			end
		end
	end
	return false
end


local _isScreenGui = script.Parent:IsA("ScreenGui")
function playerInRangeOfScreen()
	if _isScreenGui then return true end
	if not script.Parent.Adornee then return false end
	local camera = workspace.CurrentCamera
	return (script.Parent.Adornee.CFrame.Position - camera.CFrame.Position).Magnitude <= Config.PlayerVisionRange
end

function recurse(model) 
	for _,d in ipairs(model:GetDescendants()) do
		task.wait()
		if d:IsA("BasePart") and d.Name ~= "Terrain" then
			local handler = getPartHandler(d)
			if not partInFieldOfVision(d) then 
				if handler then
					handler:Destroy()
					renderedObjects[d] = nil
				end
				continue
			end
			if handler then continue end
			if d:GetAttribute("CameraNoUpdate") then
				renderedObjects[d] = VF_Handler:RenderObject(d, 0) 
			else
				renderedObjects[d] = VF_Handler:RenderObject(d, Config.FPS) 				
			end
		elseif d:IsA("Model") and d ~= cameraModel then
			if d:FindFirstChildWhichIsA("Humanoid") ~= nil then
				local handler = getPartHandler(d)
				if not partInFieldOfVision(d) then 
					if handler then
						handler:Destroy()
						renderedObjects[d] = nil
					end
					continue
				end
				if handler then continue end
				if d:GetAttribute("CameraNoUpdate") then
					renderedObjects[d] = VF_Handler:RenderHumanoid(d, 0)
				else
					renderedObjects[d] = VF_Handler:RenderHumanoid(d, Config.FPS)			
				end
			end	
		end
	end
end

while true do
	if not Enabled or not playerInRangeOfScreen() then
		if VF_Handler then VF_Handler:Destroy() end
		VF_Handler = nil
		renderedObjects = {}
		task.wait(1/Config.UpdateFrequency)
		continue
	end
	if not VF_Handler then 
		VF_Handler = ViewportHandler.new(Frame) 
	end
	for _,d in ipairs(workspace:GetChildren()) do
		task.wait()
		if not d:IsA("Model") then 
			recurse(d)
		end
		if d:IsA("BasePart") and d.Name ~= "Terrain" then
			local handler = getPartHandler(d)
			if not partInFieldOfVision(d) then 
				if handler then
					handler:Destroy()
					renderedObjects[d] = nil
				end
				continue
			end
			if handler then continue end
			if d:GetAttribute("CameraNoUpdate") then
				renderedObjects[d] = VF_Handler:RenderObject(d, 0) 
			else
				renderedObjects[d] = VF_Handler:RenderObject(d, Config.FPS) 				
			end
		end
		if d:IsA("Model") and d ~= cameraModel then
			if d:FindFirstChildWhichIsA("Humanoid") ~= nil then
				local handler = getPartHandler(d)
				if not partInFieldOfVision(d) then 
					if handler then
						handler:Destroy()
						renderedObjects[d] = nil
					end
					continue
				end
				if handler then continue end
				if d:GetAttribute("CameraNoUpdate") then
					renderedObjects[d] = VF_Handler:RenderHumanoid(d, 0)
				else
					renderedObjects[d] = VF_Handler:RenderHumanoid(d, Config.FPS)			
				end
			else
				recurse(d)
			end	
		end
	end
	task.wait(1/Config.UpdateFrequency)
end
