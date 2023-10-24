--- @ignore

CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 100
CLGAMEMODESUBMENU.title = "submenu_administration_experimental_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_experimental_tweaks")

	form:MakeHelp({
		label = "help_unique_playermodels"
	})

	form:MakeCheckBox({
		serverConvar = "ttt_unique_playermodels",
		label = "label_unique_playermodels"
	})
end
