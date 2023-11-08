if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/icon_parachute.vmt")
	resource.AddFile("materials/vgui/ttt/perks/hud_parachute.png")
end

ITEM.hud = Material("vgui/ttt/perks/hud_parachute.png")
ITEM.EquipMenuData = {
	type = "item_passive",
	name = "Glider",
	desc = "You can glide!"
}
ITEM.material = "vgui/ttt/icon_parachute"
ITEM.CanBuy = {ROLE_TRAITOR, ROLE_DETECTIVE}

if SERVER then
	util.AddNetworkString("GliderNet")

	local function UnparachutePlayer(ply)
		ply.IsGliding = false

		net.Start("GliderNet")
		net.WriteBool(ply.IsGliding)
		net.WriteEntity(ply)
		net.Broadcast()
	end

	function GliderThink()
		for _, ply in ipairs(player.GetAll()) do
			if ply:Alive() and ply:HasEquipmentItem("item_ttt_glider") and not (
				ply:GetMoveType() == MOVETYPE_NOCLIP
				or ply:InVehicle()
				or ply:OnGround()
				or ply.IsGliding
				or ply:GetVelocity().z > -450
			) then
				ply.IsGliding = true

				net.Start("GliderNet")
				net.WriteBool(ply.IsGliding)
				net.WriteEntity(ply)
				net.Broadcast()

				ply.GliderDrop = 1
			end

			if ply.IsGliding then
				if ply:KeyDown(IN_USE) and ply.GliderDrop > 0.4 then
					ply.GliderDrop = ply.GliderDrop - 0.005
				elseif not ply:KeyDown(IN_USE) and ply.GliderDrop < 1 then
					ply.GliderDrop = ply.GliderDrop + 0.005
				end

				if ply:KeyDown(IN_DUCK) and ply:KeyDown(IN_WALK) and ply.IsGliding
				or ply:OnGround() and ply.IsGliding
				or ply:WaterLevel() > 0
				or not ply:Alive() and ply:OnGround()
				or ply.GliderDrop < 0.4
				then
					UnparachutePlayer(ply)

					ply.GliderDrop = 1
				else -- gliding behaviors
					if ply:KeyDown(IN_FORWARD) then
						local aim = ply:GetAimVector()
						aim:Normalize()
						aim.z = math.min(aim.z, 0)

						ply:SetLocalVelocity(ply:GetForward() * 200 * ply.GliderDrop * 1.1 - ply:GetUp() * 320 * ply.GliderDrop * 0.25 + aim * 200)
					elseif ply:KeyDown(IN_BACK) then
						ply:SetLocalVelocity(ply:GetForward() * 100 * ply.GliderDrop * 1.1 - ply:GetUp() * 260 * ply.GliderDrop * 0.25)
					else
						ply:SetLocalVelocity(ply:GetForward() * 125 * ply.GliderDrop * 1.1 - ply:GetUp() * 300 * ply.GliderDrop * 0.25)
					end
				end
			end
		end
	end
	hook.Add("Think", "GliderThink", GliderThink)
else
	function ShakeGlider(ucmd)
		if LocalPlayer().IsGliding then
			ucmd:SetViewAngles(ucmd:GetViewAngles() + Angle(math.sin(RealTime() * 35) * 0.005, math.sin(RealTime() * 35) * 0.005, 0))
		end
	end
	hook.Add("CreateMove", "ShakeGlider", ShakeGlider)

	local function GliderNet()
		local bool = net.ReadBool()
		local ply = net.ReadEntity()

		if IsValid(ply) then
			ply.IsGliding = bool
		end
	end
	net.Receive("GliderNet", GliderNet)
end

hook.Add("CalcMainActivity", "GliderAnimations", function(ply)
	if ply.IsGliding then
		return ACT_MP_SWIM, -1
	end
end)

hook.Add("UpdateAnimation", "wingsFallSpeed", function(ply)
	if ply.IsGliding then
		ply:SetPlaybackRate(3.0)

		return true
	end
end)
