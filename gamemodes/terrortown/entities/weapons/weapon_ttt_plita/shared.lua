if SERVER then
	AddCSLuaFile()
else
	LANG.AddToLanguage("english", "plita_name", "Armor Plate")
	LANG.AddToLanguage("english", "plita_desc", "Ballistic plate capable of stopping bullets.")

	SWEP.PrintName = "plita_name"
	SWEP.Slot = 6
	SWEP.Icon = "vgui/ttt/icon_armor"

	-- client side model settings
	SWEP.UseHands = true -- should the hands be displayed
	SWEP.ViewModelFlip = false -- should the weapon be hold with the left or the right hand
	SWEP.ViewModelFOV = 60

	SWEP.DrawCrosshair = false

	-- equipment menu information is only needed on the client
	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "plita_desc"
	}
end

-- always derive from weapon_tttbase
SWEP.Base = "weapon_tttbase"

--[[Default GMod values]]--

SWEP.Weight = 5
SWEP.AutoSwitchFrom = true
SWEP.NoSights = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1.0
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

--[[Model settings]]--
SWEP.HoldType = "slam"
SWEP.ViewModel = Model( "models/weapons/c_hands_plita.mdl" )
SWEP.WorldModel = Model("models/weapons/plita.mdl")

SWEP.Kind = WEAPON_EQUIP1

SWEP.AutoSpawnable = false

SWEP.CanBuy = { ROLE_TRAITOR }

SWEP.LimitedStock = false

SWEP.AllowDrop = true

SWEP.IsSilent = false

function SWEP:PrimaryAttack()
	
	
	local vm = self.Owner:GetViewModel()
    local anim = "ARM_addarmor"
	if IsValid(self.Owner) then
	
	    vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
		
	    self:EmitSound( "items/battery_pickup.wav" )
		self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() + 99 )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

	    if SERVER then 
			self.AllowDrop = false
			self.Owner:GiveArmor(GetConVar("ttt_item_armor_value"):GetInt())
			local holdup = self.Owner:GetViewModel():SequenceDuration()
			timer.Simple(holdup + .1,
			function()
				self:Remove()
			end)
		end
	end
end

if CLIENT then
	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			local offsetVec = Vector(5, -2.7, -3.4)
			local offsetAng = Angle(180, 90, 0)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand")
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			self:SetPos(newPos)
			self:SetAngles(newAng)

            self:SetupBones()
		end

		self:DrawModel()
	end
end

---
-- @ignore
function SWEP:OnRemove()
	local owner = self:GetOwner()

	if CLIENT and IsValid(owner) and owner == LocalPlayer() and owner:Alive() then
		RunConsoleCommand("use", "weapon_ttt_unarmed")
	end
end