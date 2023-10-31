if SERVER then
	AddCSLuaFile()
end

SWEP.HoldType = "grenade"

if CLIENT then
	SWEP.PrintName = "grenade_fire"
	SWEP.Slot = 3

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.Icon = "vgui/ttt/icon_nades"
	SWEP.IconLetter = "P"
end

SWEP.Base = "weapon_tttbasegrenade"

SWEP.Kind = WEAPON_NADE
SWEP.WeaponID = AMMO_MOLOTOV
SWEP.spawnType = WEAPON_TYPE_NADE

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/arccw_go/v_eq_molotov.mdl"
SWEP.WorldModel = "models/weapons/arccw_go/w_eq_molotov_thrown.mdl"

SWEP.Weight = 5
SWEP.AutoSpawnable = true
SWEP.Spawnable = true

---
-- really the only difference between grenade weapons: the model and the thrown ent.
-- @ignore
function SWEP:GetGrenadeName()
	return "ifs_molotov_proj"
end
