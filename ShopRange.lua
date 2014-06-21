--[[Simple Shop Range
by
DaPipex]]--

local shopRadius = 1250

function OnLoad()

	RTconfig = scriptConfig("Shop Radius", "dashopradius")
	RTconfig:addParam("drawSradius", "Show your shop range?", SCRIPT_PARAM_ONOFF, true)
	RTconfig:addParam("drawSradiusColor", "Radius Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})

	miTienda = GetShop()

end

function OnDraw()

	if RTconfig.drawSradius then
		DrawCircle(miTienda.x , miTienda.y, miTienda.z, shopRadius, ARGB(RTconfig.drawSradiusColor[1], RTconfig.drawSradiusColor[2], RTconfig.drawSradiusColor[3], RTconfig.drawSradiusColor[4]))
	end
end
