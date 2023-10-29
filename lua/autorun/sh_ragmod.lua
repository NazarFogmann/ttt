include("ragmod/ragmod_utils.lua")
include("ragmod/ragmod_options.lua")
include("ragmod/ragmod.lua")

AddCSLuaFile("ragmod/ragmod_input.lua")
include("ragmod/ragmod_input.lua")

if SERVER then
	include("ragmod/sv_ragmod.lua")
	AddCSLuaFile("ragmod/cl_ragmod.lua")
else
	include("ragmod/cl_ragmod.lua")
end