if SERVER then
AddCSLuaFile( "shared.lua" )
resource.AddFile("materials/vgui/ttt/icon_tripmine.png")
end   
 
SWEP.HoldType = "slam"
     
if CLIENT then
     
SWEP.PrintName    = "Tripwire Mine"
SWEP.Slot         = 6
SWEP.ViewModelFlip = true
SWEP.ViewModelFOV                    = 64 
SWEP.EquipMenuData = {
          type = "item_weapon",
          desc = "Two tripmines to eliminate the inattentive."
       };
     
SWEP.Icon = "materials/vgui/ttt/icon_tripmine.png"
end

SWEP.Base = "weapon_tttbase"
	 
    SWEP.ViewModel                          = "models/weapons/v_slam.mdl" 
    SWEP.WorldModel                         = "models/weapons/w_slam.mdl"   
    SWEP.FiresUnderwater = false
     
    SWEP.Primary.Sound                      = Sound("")             
    SWEP.Primary.Delay                      = .5                    
    SWEP.Primary.ClipSize                   = 2            
    SWEP.Primary.DefaultClip                = 2            
    SWEP.Primary.Automatic                  = false         
    SWEP.Primary.Ammo                       = "slam"
	SWEP.LimitedStock = true
	
	SWEP.NoSights = true
     
    SWEP.AllowDrop = false
    SWEP.Kind = WEAPON_EQUIP
    SWEP.CanBuy = {ROLE_TRAITOR}
	
function SWEP:Deploy()
self:SendWeaponAnim( ACT_SLAM_TRIPMINE_DRAW )
return true
end
     
function SWEP:SecondaryAttack()
return false
end    
     
    function SWEP:OnRemove()
       if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
          RunConsoleCommand("lastinv")
       end
    end
     
function SWEP:PrimaryAttack()
	self:TripMineStick()
	self.Weapon:EmitSound( Sound( "Weapon_SLAM.SatchelThrow" ) )
	self.Weapon:SetNextPrimaryFire(CurTime()+(self.Primary.Delay))
end
     
function SWEP:TripMineStick()
 if SERVER then
      local ply = self.Owner
      if not IsValid(ply) then return end
 
 
      local ignore = {ply, self.Weapon}
      local spos = ply:GetShootPos()
      local epos = spos + ply:GetAimVector() * 80
      local tr = util.TraceLine({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID})
 
      if tr.HitWorld then
         local mine = ents.Create("npc_tripmine")
         if IsValid(mine) then
 
            local tr_ent = util.TraceEntity({start=spos, endpos=epos, filter=ignore, mask=MASK_SOLID}, mine)
 
            if tr_ent.HitWorld then
 
               local ang = tr_ent.HitNormal:Angle()
               ang.p = ang.p + 90
 
               mine:SetPos(tr_ent.HitPos + (tr_ent.HitNormal * 3))
               mine:SetAngles(ang)
               --mine:SetOwner(ply)
               mine:Spawn()
 
                                mine.fingerprints = self.fingerprints
								
                                self:SendWeaponAnim( ACT_SLAM_TRIPMINE_ATTACH )
                               
                                local holdup = self.Owner:GetViewModel():SequenceDuration()
                               
                                timer.Simple(holdup,
                                function()
                                if SERVER then
                                        self:SendWeaponAnim( ACT_SLAM_TRIPMINE_ATTACH2 )
                                end    
                                end)
                                       
                                timer.Simple(holdup + .1,
                                function()
                                        if SERVER then
                                                if self.Owner == nil then return end
                                                if self.Weapon:Clip1() == 0 && self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() ) == 0 then
												self:Remove()
                                                else
                                                self:Deploy()
                                                end
                                        end
                                end)
                                self.Planted = true
								
	self:TakePrimaryAmmo( 1 )
                               
                        end
            end
         end
      end
end

function SWEP:Reload()
   return false
end