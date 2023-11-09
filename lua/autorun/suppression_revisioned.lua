--[[
Original code and idea by - SweptThr.one (https://steamcommunity.com/id/SweptThrone)
I chagned the effect and the way it works with the addition of the sound from ins2 also with the settings and all
okay bye now 
-kait
]]
local suppression_enabled = CreateConVar("ttt_suppression", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

local suppression_viewpunch = true
local suppression_viewpunch_intensity = 3
local suppression_buildupspeed = 1
local suppression_sharpen = true
local suppression_sharpen_intensity = 1.9
local suppression_bloom = true
local suppression_blur = true
local supression_blur_style = 1
local supression_blur_intensity = 2.8
local suppression_bloom_intensity = 1.3
local suppression_gasp_enabled = true
local suppression_enable_vehicle = true

function ApplySuppressionEffect(at, hit, start)
	bruh = start or at:EyePos()
	bruhh = hit
	for _,v in pairs(player.GetAll()) do
		local distance, sup_point = util.DistanceToLine( bruh, bruhh, v:GetPos() )
		if v:IsPlayer() and v:Alive() and (suppression_enabled:GetBool()) and distance < 100 and !(v == at) then
			if (v:InVehicle() and !suppression_enable_vehicle) then return end
			v:SetNWInt("EffectAMT", math.Clamp(v:GetNWInt("EffectAMT"), 0, 1) + 0.05 * (suppression_buildupspeed))
			sound.Play("bul_snap/supersonic_snap_" .. math.random(1,18) .. ".wav", sup_point, 75, 100, 1)
			sound.Play("bul_flyby/subsonic_" .. math.random(1,27) .. ".wav", sup_point, 75, 100, 1)
			if (suppression_viewpunch) then
			v:ViewPunch( Angle( math.Rand(-1, 1) * (v:GetNWInt("EffectAMT")) * (suppression_viewpunch_intensity), math.Rand(-1, 1) * (v:GetNWInt("EffectAMT")) * (suppression_viewpunch_intensity), math.Rand(-1, 1) * (v:GetNWInt("EffectAMT")) * (suppression_viewpunch_intensity) ) ) 
			end
			timer.Remove(v:Name() .. "blurreset")
			timer.Create(v:Name() .. "blurreset", 4, 1, function()
				for i=1,(v:GetNWInt("EffectAMT") / 0.05) + 1 do
					timer.Simple(0.1 * i, function()
						v:SetNWInt("EffectAMT", math.Clamp(v:GetNWInt("EffectAMT") - 0.1, 0, 100000))
					end)
				end 
				if v:Alive() and suppression_gasp_enabled then
					v:EmitSound("gasp/focus_gasp_0".. math.random(1,6) ..".wav", 75, math.random(90,110) )
				end
			end) --end timer function
		end --end alive test
	end --end for
end -- end function
hook.Add("EntityFireBullets", "SupperssionFunc", function(at, bul)
	local oldcb = bul.Callback
	bul.Callback = function( at, tr, dm)
		if oldcb then 
			oldcb( at, tr, dm ) 
		end
		if SERVER then 
			ApplySuppressionEffect(at, tr.HitPos, tr.StartPos)
		end
	end
	return true
end)
local sharpen_lerp = 0
local bloom_lerp = 0
local effect_lerp = 0
hook.Add("RenderScreenspaceEffects", "ApplySuppression", function()
	if (suppression_sharpen) then
	sharpen_lerp = Lerp(6 * FrameTime(), sharpen_lerp, LocalPlayer():GetNWInt("EffectAMT") * (suppression_sharpen_intensity))
	DrawSharpen( sharpen_lerp , 0.4 )
	end
	if (suppression_bloom) then
	bloom_lerp = Lerp(6 * FrameTime(), bloom_lerp, LocalPlayer():GetNWInt("EffectAMT") * 0.5 * (suppression_bloom_intensity))
	DrawBloom( 0.30, bloom_lerp , 0.33, 4.5, 1, 0, 1, 1, 1 )
	end
	if (suppression_blur) then
	effect_lerp = Lerp(6 * FrameTime(), effect_lerp, LocalPlayer():GetNWInt("EffectAMT") )
		if (supression_blur_style) == 0 then
			DrawBokehDOF( effect_lerp * supression_blur_intensity, 0, 0 )
		else
			DrawBokehDOF( effect_lerp * supression_blur_intensity, 0.05, 0.25 )
		end
	end
end)
hook.Add("PlayerInitialSpawn", "Initialize", function(ply)
	ply:SetNWInt("EffectAMT", 0)

end)

hook.Add("PlayerDeath", "ClearDeath", function(ply, i, a)
	ply:SetNWInt("EffectAMT", 0)

end)
