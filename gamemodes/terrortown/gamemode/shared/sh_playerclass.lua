DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.WalkSpeed = 180
PLAYER.RunSpeed = 180
PLAYER.JumpPower = 160
PLAYER.CrouchedWalkSpeed = 0.3

function PLAYER:SetupDataTables()
	self.Player:SetupDataTables()
end

player_manager.RegisterClass("player_ttt", PLAYER, "player_default")