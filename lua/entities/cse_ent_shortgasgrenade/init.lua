// this was a cse flashbang.

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()

	self.Entity:SetModel("models/weapons/w_eq_smokegrenade.mdl")
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( false )

	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Sleep()
	end
	
	self.timer = CurTime() + 6
	self.solidify = CurTime() + 1
	self.Bastardgas = nil
	self.Spammed = false
end
	local bounces = 0
	function ENT:PhysicsCollide( data, phys )
		bounces = bounces + 1
		if bounces == 1 then
			self.Entity:GetPhysicsObject():Sleep()
		end
	end
	
local function Poison(ent,owner)
	local pd = DamageInfo()
	pd:SetDamage(5)
	pd:SetAttacker(owner)
	pd:SetDamageType(DMG_NERVEGAS)
	if (ent:Health() >= 0) then
		ent:TakeDamageInfo(pd)
	end
	
end

function ENT:Think()
	if (IsValid(self.Owner)==false) then
		self.Entity:Remove()
	end
	if (self.solidify<CurTime()) then
		self.SetOwner(self.Entity)
	end
	if self.timer < CurTime() then
		if !IsValid(self.Bastardgas) && !self.Spammed then
			self.Spammed = true
			self.Bastardgas = ents.Create("env_smoketrail")
			self.Bastardgas:SetOwner(self.Owner)
			self.Bastardgas:SetPos(self.Entity:GetPos())
			self.Bastardgas:SetKeyValue("spawnradius","256")
			self.Bastardgas:SetKeyValue("minspeed","0.5")
			self.Bastardgas:SetKeyValue("maxspeed","2")
			self.Bastardgas:SetKeyValue("startsize","16536")
			self.Bastardgas:SetKeyValue("endsize","256")
			self.Bastardgas:SetKeyValue("endcolor","170 205 70")
			self.Bastardgas:SetKeyValue("startcolor","150 205 70")
			self.Bastardgas:SetKeyValue("opacity","4")
			self.Bastardgas:SetKeyValue("spawnrate","60")
			self.Bastardgas:SetKeyValue("lifetime","10")
			self.Bastardgas:SetParent(self.Entity)
			self.Bastardgas:Spawn()
			self.Bastardgas:Activate()
			self.Bastardgas:Fire("turnon","", 0.1)
			local expl = ents.Create("env_explosion")
			expl:SetPos(self.Entity:GetPos())
			expl:Spawn()
			expl:Fire("explode","",0)
			self.Entity:EmitSound(Sound("BaseSmokeEffect.Sound"))
		end

		local pos = self.Entity:GetPos()
		local maxrange = 256
		local maxstun = 10
		for k,v in pairs(ents.FindInSphere( pos, maxrange) ) do
			if v:GetNWBool( "STALKER_PlyGasMaskOn" ) == true then return end
				if  v:IsPlayer() then
					local stunamount = math.ceil((maxrange/maxstun))
					v:ViewPunch( Angle( stunamount*((math.random()*6)-2), stunamount*((math.random()*6)-2), stunamount*((math.random()*4)-1) ) )
				end
				Poison(v, self.Owner)
		end
		if (self.timer+60<CurTime()) then
			if IsValid(self.Bastardgas) then
				self.Bastardgas:Remove()
			end
		end
		if (self.timer+65<CurTime()) then
			self.Entity:Remove()
		end
		self.Entity:NextThink(CurTime()+0.5)
		return true
	end
end

