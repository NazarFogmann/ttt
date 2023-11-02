if SERVER then
	AddCSLuaFile()
end

SWEP.HoldType = "grenade"

if CLIENT then
	SWEP.PrintName = "grenade_smoke"
	SWEP.Slot = 3

	SWEP.ViewModelFlip = true
	SWEP.ViewModelFOV = 54

	SWEP.Icon = "vgui/ttt/icon_nades"
	SWEP.IconLetter = "Q"
end

SWEP.Base = "weapon_tttbasegrenade"

SWEP.WeaponID = AMMO_SMOKE
SWEP.Kind = WEAPON_NADE
SWEP.spawnType = WEAPON_TYPE_NADE

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/v_eq_smokegrenade.mdl"
SWEP.WorldModel = "models/weapons/w_eq_smokegrenade_thrown.mdl"

SWEP.Weight = 5
SWEP.AutoSpawnable = true
SWEP.Spawnable = true

---
-- really the only difference between grenade weapons: the model and the thrown ent.
-- @ignore
function SWEP:GetGrenadeName()
	return "ifs_smoke_proj"
end
