if SERVER then
	AddCSLuaFile()
end

SWEP.HoldType = "grenade"

if CLIENT then
	SWEP.PrintName = "grenade_fire"
	SWEP.Slot = 3

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.Icon = "vgui/ttt/icon_nades"
	SWEP.IconLetter = "P"
end

SWEP.Base = "weapon_tttbasegrenade"

SWEP.Kind = WEAPON_NADE
SWEP.WeaponID = AMMO_MOLOTOV
SWEP.spawnType = WEAPON_TYPE_NADE

SWEP.UseHands = true
SWEP.ViewModel 				= "models/weapons/anya/c_molly.mdl"
SWEP.WorldModel 			= "models/weapons/anya/w_molly.mdl"

SWEP.Weight = 5
SWEP.AutoSpawnable = true
SWEP.Spawnable = true

function SWEP:PullPin()
	if self:GetPin() then return end

	local ply = self:GetOwner()
	if not IsValid(ply) then return end

	self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)

	if self.SetHoldType then
		self:SetHoldType(self.HoldReady)
	end

	self:SetPin(true)

	self:SetDetTime(CurTime() + self.detonate_timer)
end

---
-- really the only difference between grenade weapons: the model and the thrown ent.
-- @ignore
function SWEP:GetGrenadeName()
	return "ifs_molotov_proj"
end
