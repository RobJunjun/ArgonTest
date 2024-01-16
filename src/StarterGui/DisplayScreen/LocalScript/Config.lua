local Players = game:GetService("Players")
local Player = Players.LocalPlayer
-- The above is for example for tools, it is not required, in this config it isn't even used.

local config = {
	CameraEye = workspace.camera1.eye, -- The part the camera looks through, looks in the front face of the part
	FOV = 70, -- How wide the field of vision should be
	CameraRange = 400, -- The max distance to render parts
	FPS = 60, -- How many updates objects being rendered should undergo per second
	UpdateFrequency = 20, -- How many times to update rendered objects per second (removing/adding objects to the ViewportFrame)
	RenderCameraModel = false, -- Whether or not the model containing CameraEye should be rendered
	PlayerVisionRange = 100, -- How far away the player can see the screen (outside of this range, everything unrenders)

	AdornOnEnable=false, -- Whether or not to adorn the surfacegui on enable (useful for tools)
	Adornee=nil, -- The adornee if AdornOnEnable is true
	AttachToFace=Enum.NormalId.Front -- Which face to attach to
}

return config
