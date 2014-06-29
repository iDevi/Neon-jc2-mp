class 'Neon'

function Neon:__init()
    Network:Subscribe( "PlayerFired", self, self.ExecuteNeon )    
end

function Neon:ExecuteNeon( value, player )
	player:SetNetworkValue( "Neon", value) -- Store the Appeance Item as a player value
end

neon = Neon()