class 'Neon'

function Neon:__init()
	
	Events:Subscribe( "LocalPlayerEnterVehicle", self, self.OnEnterVehicle )
	Events:Subscribe( "LocalPlayerExitVehicle", self, self.OnExitVehicle)
	Events:Subscribe( "EntitySpawn", self, self.EntitySpawn )
	Events:Subscribe( "EntityDespawn", self, self.EntityDespawn )
	Events:Subscribe("PlayerNetworkValueChange", self, self.PlayerValueChangeNeon)
	Events:Subscribe("ModuleLoad", self, self.ModuleLoad )
	Events:Subscribe( "Render", self, self.Render )

	player_neon = {}	
	
	self.neon = nil
end

function Neon:ModuleLoad()
	for p in Client:GetStreamedPlayers() do
		self:CreateNeon(p)
	end
	self:CreateNeon(LocalPlayer)
end

function Neon:EntitySpawn(args)
	if args.entity.__type == "Player" then
		self:CreateNeon(args.entity)
	end
end

-- Event to detect when a player is despawned to remove the existing hat (from the perspective of the LocalPlayer)
function Neon:EntityDespawn(args)
	if args.entity.__type == "Player" then
		self:DestroyNeon(args.entity)
	end
end

function Neon:CreateNeon(player)
	self:RemoveNeon(player)	
	if player:GetValue("Neon") == 1 then
		player_neon[player:GetId()] = ClientLight.Create{
			position = LocalPlayer:GetPosition() + Vector3(0, 1, 0),
			color = LocalPlayer:GetColor(),
			constant_attenuation = 10,
			linear_attenuation = 1,
			quadratic_attenuation = 0.1,
			multiplier = 10.0,
			radius = 3.5 
		}
	else
		if player_neon[player:GetId()] ~= nil then
			if IsValid( player_neon[player:GetId()] ) then
				player_neon[player:GetId()]:Remove()
			end
			player_neon[player:GetId()] = nil
		end
	end
end

function Neon:PlayerValueChangeNeon(args)
	if args.key == "Neon" then
		self:CreateNeon(args.player)
	end
end
	
function Neon:RemoveNeon(player)
	if player_neon[player:GetId()] ~= nil then
		if IsValid( player_neon[player:GetId()] ) then
			player_neon[player:GetId()]:Remove()
		end
		player_neon[player:GetId()] = nil
	end
end	

function Neon:MoveNeon(player)
	if IsValid(player) then
		local neon = player_neon[player:GetId()]
		if neon ~= nil and IsValid(neon) then
			neon:SetPosition( player:GetPosition() + Vector3(0, 1, 0)) 
		end
	end
end

function Neon:OnEnterVehicle( args )
	Network:Send( "PlayerFired", 1 )
end

function Neon:OnExitVehicle( args )
	Network:Send( "PlayerFired", 0 )
end

function Neon:Render()
	for p in Client:GetStreamedPlayers() do
		self:MoveNeon(p)
	end
	self:MoveNeon(LocalPlayer)
end

neon = Neon()