class 'Neon'

function Neon:__init()
	Events:Subscribe( "ModuleLoad", self, self.ModuleLoad)
	Events:Subscribe( "LocalPlayerEnterVehicle", self, self.OnEnterVehicle )
	Events:Subscribe( "LocalPlayerExitVehicle", self, self.OnExitVehicle)
	Events:Subscribe( "PreTick", self, self.PreTick)
end

function Neon:ModuleLoad()
	self.neon = nil
	if self.neon ~= nil then self.neon:Remove() end
end

function Neon:OnEnterVehicle( args )
	v = LocalPlayer:GetVehicle()
	self.neon = ClientLight.Create{
	position = v:GetPosition() + Vector3(0, 0.5, 0),
	color = LocalPlayer:GetColor(),
	constant_attenuation = 10,
	linear_attenuation = 1,
	quadratic_attenuation = 0.1,
	multiplier = 10.0,
	radius = 3.5 }
	self.neon:SetEnabled(true)
end

function Neon:OnExitVehicle( args )
	if self.neon ~= nil then
		self.neon:Remove()
		self.neon = nil
	end
end

function Neon:PreTick()
	v = LocalPlayer:GetVehicle()
	if self.neon ~= nil then 
		if IsValid(v) then
			self.neon:SetPosition(v:GetPosition() + Vector3(0, 0.5, 0)) 
		else
			self.neon:Remove()
			self.neon = nil
		end
	end
end

neon = Neon()