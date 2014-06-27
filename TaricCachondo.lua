--[[Taric, el caballero cachondo
by
DaPipex]]

local version = "0.02"

if myHero.charName ~= "Taric" then return end

--Auto Update - Credits Honda7--

local DaPipexTaricUpdate = true
local UPDATE_SCRIPT_NAME = "TaricCachondo"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/DaPipex/BoL_Scripts/master/TaricCachondo.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#FF0000\">"..UPDATE_SCRIPT_NAME..":</font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if DaPipexTaricUpdate then
	local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH)
	if ServerData then
		local ServerVersion = string.match(ServerData, "local version = \"%d+.%d+\"")
		ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
		if ServerVersion then
			ServerVersion = tonumber(ServerVersion)
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available "..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)  
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..") Check post for changelog!")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end

--End credits - Honda 7--

require "VPrediction"
require "SOW"

function OnLoad()

	loadDone = false

	Variables()
	TaricMenu()
	InterrumpirMenu()
	DelayAction(Mensajito, 2)

end

function Variables()
	numbersTable = { "1", "2", "3", "4", "5" }
	Qlista, Wlista, Elista, Rlista = false, false, false, false
	rangoQ, rangoW, rangoE, rangoR = 750, 400, 625, 400
	VP = VPrediction()
	SOWi = SOW(VP)
	ts = nil
	castigo = nil
	tieneBuff = false
	tiempoAnimacion = 0
	author = "DaPipex"

	TextosMatar = {}
	ListaTextos = { "W+E+R", "E+R", "W+R", "W+E", "R", "E", "W", "Harass"}
	TextosEsperar = {}

	InterrumpirJuego = {}
	InterrumpirCompleto = {
		{ nombre = "Caitlyn"     , hechizo = "CaitlynAceintheHole"},
		{ nombre = "FiddleSticks", hechizo = "Crowstorm"},
		{ nombre = "FiddleSticks", hechizo = "DrainChannel"},
		{ nombre = "Galio"       , hechizo = "GalioIdolOfDurand"},
		{ nombre = "Karthus"     , hechizo = "FallenOne"},
		{ nombre = "Katarina"    , hechizo = "KatarinaR"},
		{ nombre = "Lucian"      , hechizo = "LucianR"},
		{ nombre = "Malzahar"    , hechizo = "AlZaharNetherGrasp"},
		{ nombre = "MissFortune" , hechizo = "MissFortuneBulletTime"},
		{ nombre = "Nunu"        , hechizo = "AbsoluteZero"},
		{ nombre = "Pantheon"    , hechizo = "Pantheon_GrandSkyfall_Jump"},
		{ nombre = "Shen"        , hechizo = "ShenStandUnited"},
		{ nombre = "Urgot"       , hechizo = "UrgotSwap2"},
		{ nombre = "Varus"       , hechizo = "VarusQ"},
		{ nombre = "Velkoz"      , hechizo = "VelkozR"},
		{ nombre = "Warwick"     , hechizo = "InfiniteDuress"}
	}

	local EquipoEnemigo = GetEnemyHeroes()
	for i, enemigo in pairs(EquipoEnemigo) do
		for j, info in pairs(InterrumpirCompleto) do
			if enemigo.charName == info.nombre then
				table.insert(InterrumpirJuego, info.hechizo)
			end
		end
	end

	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then
		castigo = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then
		castigo = SUMMONER_2
	end

	for k=1, heroManager.iCount do
		TextosEsperar[k] = k * 3
	end 
end

function TaricMenu()

	MachoteConfig = scriptConfig("Taric Cachondo", "hermosotaric")

	MachoteConfig:addSubMenu("Orbwalking", "orbw")
	SOWi:LoadToMenu(MachoteConfig.orbw)

	MachoteConfig:addSubMenu("Combo", "combo")
	MachoteConfig.combo:addSubMenu("Q Settings", "Qinfo")
	MachoteConfig.combo.Qinfo:addParam("useQ", "Use Q on..", SCRIPT_PARAM_LIST, 3, { "Don't use", "Self", "Lowest ally" })
	MachoteConfig.combo.Qinfo:addParam("minHPtoHealSelf", "Min % Health to heal self", SCRIPT_PARAM_SLICE, 90, 1, 100, 0)
	MachoteConfig.combo.Qinfo:addParam("minHPtoHealAlly", "Min % Health to heal ally", SCRIPT_PARAM_SLICE, 90, 1, 100, 0)
	MachoteConfig.combo.Qinfo:addParam("autoHealAlly", "Auto Heal Ally", SCRIPT_PARAM_ONOFF, false)
	MachoteConfig.combo.Qinfo:addParam("AHAmin", "Auto Heal Ally min health", SCRIPT_PARAM_SLICE, 90, 1, 100, 0)

	MachoteConfig.combo:addSubMenu("W Settings", "Winfo")
	MachoteConfig.combo.Winfo:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
	MachoteConfig.combo.Winfo:addParam("minWenemies", "Min Enemies to use W", SCRIPT_PARAM_LIST, 1, numbersTable)

	MachoteConfig.combo:addSubMenu("E Settings", "Einfo")
	MachoteConfig.combo.Einfo:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
	MachoteConfig.combo.Einfo:addParam("rangeToE", "Range to use E", SCRIPT_PARAM_SLICE, rangoE, 1, rangoE, 0)

	MachoteConfig.combo:addSubMenu("R Settings", "Rinfo")
	MachoteConfig.combo.Rinfo:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)
	MachoteConfig.combo.Rinfo:addParam("minRenemies", "Min Enemies to use R", SCRIPT_PARAM_LIST, 1, numbersTable)

	MachoteConfig:addSubMenu("Keys", "keys")
	MachoteConfig.keys:addParam("comboKey", "Normal Combo [all in] (Space)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	MachoteConfig.keys:addParam("comboWeavingKey", "Spell Weaving Combo", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	MachoteConfig.keys:addParam("harassKey", "Harass with stun", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))

	MachoteConfig:addSubMenu("Interrupt", "inter")
	MachoteConfig.inter:addParam("info1", "Interrupt with stun:", SCRIPT_PARAM_INFO, "")

	MachoteConfig:addSubMenu("Items", "items")
	MachoteConfig.items:addParam("itemsG", "Use items in combo?", SCRIPT_PARAM_ONOFF, false)

	MachoteConfig:addSubMenu("KS", "killsteal")
	MachoteConfig.killsteal:addParam("ksW", "KS with W", SCRIPT_PARAM_ONOFF, true)
	MachoteConfig.killsteal:addParam("ksE", "KS with E", SCRIPT_PARAM_ONOFF, true)
	MachoteConfig.killsteal:addParam("ksR", "KS with R", SCRIPT_PARAM_ONOFF, true)
	MachoteConfig.killsteal:addParam("ksI", "KS with Ignite", SCRIPT_PARAM_ONOFF, true)

	MachoteConfig:addSubMenu("Drawing", "draw")
	MachoteConfig.draw:addParam("drawAArange", "Draw AA range", SCRIPT_PARAM_ONOFF, true)
	MachoteConfig.draw:addParam("drawQrange", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
	MachoteConfig.draw:addParam("drawWrange", "Draw W range", SCRIPT_PARAM_ONOFF, true)
	--MachoteConfig.draw:addParam("drawMaxErange", "Draw max E range", SCRIPT_PARAM_ONOFF, true)
	MachoteConfig.draw:addParam("drawErange", "Draw user-set E range", SCRIPT_PARAM_ONOFF, true)
	MachoteConfig.draw:addParam("drawRrange", "Draw R range", SCRIPT_PARAM_ONOFF, true)
	MachoteConfig.draw:addParam("drawKill", "Draw Killable", SCRIPT_PARAM_ONOFF, true)
	MachoteConfig.draw:addParam("drawTarget", "Draw Target", SCRIPT_PARAM_ONOFF, true)

	MachoteConfig:addSubMenu("Debug", "Debug")
	MachoteConfig.Debug:addParam("Debug", "Debugging", SCRIPT_PARAM_ONOFF, false)

	MachoteConfig:addParam("info3", "Script Author:", SCRIPT_PARAM_INFO, author)
	MachoteConfig:addParam("info4", "Script Version:", SCRIPT_PARAM_INFO, version)

	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, rangoE)
	ts.name = "Machote"
	MachoteConfig:addTS(ts)

end

function Mensajito()
	PrintChat("<font color='#19DEDB'>Loaded Taric, el caballero cachondo. Version: "..version.." Have fun!</font>")

	loadDone = true
end

function OnTick()

	if loadDone then

		Chequeos()
		Killsteal()
		CalculoDeDano()

		if MachoteConfig.combo.Qinfo.autoHealAlly then
			AutoHealAlly()
		end

		if MachoteConfig.keys.comboKey then
			Combo()
		end

		if MachoteConfig.keys.harassKey then
			Harass()
		end
	end
end

function Chequeos()

	Qlista = (myHero:CanUseSpell(_Q) == READY)
	Wlista = (myHero:CanUseSpell(_W) == READY)
	Elista = (myHero:CanUseSpell(_E) == READY)
	Rlista = (myHero:CanUseSpell(_R) == READY)
	Ilista = (castigo ~= nil and myHero:CanUseSpell(castigo) == READY)

	ts:update()
	Target = ts.target

end

function Combo()

	if Qlista and Target ~= nil then
		if MachoteConfig.combo.Qinfo.useQ == 2 and (myHero.health <= ((MachoteConfig.combo.Qinfo.minHPtoHealSelf / 100) * myHero.maxHealth)) then
			if MachoteConfig.Debug.Debug then
				PrintChat("Called Q Self")
			end
			CastSpell(_Q, myHero)
		elseif MachoteConfig.combo.Qinfo.useQ == 3 then
			local wachoPeor = LowestAllyInMyRange(rangoQ)
			if wachoPeor.health <= ((MachoteConfig.combo.Qinfo.minHPtoHealAlly / 100) * wachoPeor.maxHealth) then
				if MachoteConfig.Debug.Debug then
					PrintChat("Called Q Lowest Ally")
				end
				CastSpell(_Q, wachoPeor)
			end
		end
	end

	if Wlista then
		if MachoteConfig.combo.Winfo.useW and ((MachoteConfig.combo.Winfo.minWenemies < CountEnemyHeroInRange(rangoW - 10)) or CountEnemyHeroInRange(rangoW) == 1) then
			if MachoteConfig.Debug.Debug then
				PrintChat("Called W")
			end
			CastSpell(_W)
		end
	end

	if Elista and Target ~= nil then
		if MachoteConfig.combo.Einfo.useE then
			if MachoteConfig.combo.Einfo.rangeToE >= GetDistance(Target) then
				if MachoteConfig.Debug.Debug then
					PrintChat("Called E on "..Target.charName)
				end
				CastSpell(_E, Target)
			end
		end
	end

	if Rlista then
		if MachoteConfig.combo.Rinfo.useR and ((MachoteConfig.combo.Rinfo.minRenemies < CountEnemyHeroInRange(rangoR - 10)) or CountEnemyHeroInRange(rangoW) == 1) then
			if MachoteConfig.Debug.Debug then
				PrintChat("Called R")
			end
			CastSpell(_R)
		end
	end
end

function Harass()

	if Elista and Target ~= nil then
		if MachoteConfig.combo.Einfo.rangeToE >= GetDistance(Target) then
			if MachoteConfig.Debug.Debug then
				PrintChat("Called Harass E on "..Target.charName)
			end
			CastSpell(_E, Target)
		end
	end
end

function Killsteal()

	local wachos = GetEnemyHeroes()
	for i, enemigo in pairs(wachos) do

		if MachoteConfig.killsteal.ksW then
			if ValidTarget(enemigo, rangoW - 10) and Wlista and not Elista and not Rlista then
				if enemigo.health <= getDmg("W", enemigo, myHero) then
					if MachoteConfig.Debug.Debug then
						PrintChat("Tried to KS with W: "..enemigo.charName)
					end
					CastSpell(_W)
				end
			end
		end

		if MachoteConfig.killsteal.ksE then
			if ValidTarget(enemigo, rangoE) and Elista and not Rlista then
				if enemigo.health <= getDmg("E", enemigo, myHero) then
					if MachoteConfig.Debug.Debug then
						PrintChat("Tried to KS with E "..enemigo.charName)
					end
					CastSpell(_E, enemigo)
				end
			end
		end

		if MachoteConfig.killsteal.ksR then
			if ValidTarget(enemigo, rangoR - 10) and Rlista then
				if enemigo.health <= getDmg("R", enemigo, myHero) then
					if MachoteConfig.Debug.Debug then
						PrintChat("Tried to KS with R: "..enemigo.charName)
					end
					CastSpell(_R)
				end
			end
		end

		if MachoteConfig.killsteal.ksI then
			if ValidTarget(enemigo, 600) and Ilista then
				if enemigo.health <= getDmg("IGNITE", enemigo, myHero) then
					if MachoteConfig.Debug.Debug then
						PrintChat("Tried to KS with Ignite: "..enemigo.charName)
					end
					CastSpell(castigo, enemigo)
				end
			end
		end
	end
end

function LowestAllyInMyRange(range)
	local pobrecito = nil
	for i=1, heroManager.iCount do
		local wachitoPrueba = heroManager:GetHero(i)
		if wachitoPrueba.team == myHero.team then
			if not wachitoPrueba.dead and GetDistance(wachitoPrueba) < range then
				pobrecito = wachitoPrueba
			elseif (pobrecito.health / pobrecito.maxHealth) > (wachitoPrueba.health / wachitoPrueba.maxHealth) and not pobrecito.dead and GetDistance(wachitoPrueba) < range then
				pobrecito = wachitoPrueba
			end
		end
	end
	return pobrecito
end

function CalculoDeDano()

	for i=1, heroManager.iCount do
		local objetivo = heroManager:GetHero(i)
		if ValidTarget(objetivo, 3500) and objetivo ~= nil then
			wDMG = ((Wlista and getDmg("W", objetivo, myHero)) or 0)
			eDMG = ((Elista and getDmg("E", objetivo, myHero)) or 0)
			rDMG = ((Rlista and getDmg("R", objetivo, myHero)) or 0)
			iDMG = ((Ilista and getDmg("IGNITE", objetivo, myHero)) or 0)

			if (wDMG + eDMG + rDMG < objetivo.health) then
				TextosMatar[i] = 8
			elseif Wlista and (wDMG >= objetivo.health) then
				TextosMatar[i] = 7
			elseif Elista and (eDMG >= objetivo.health) then
				TextosMatar[i] = 6
			elseif Rlista and (rDMG >= objetivo.health) then
				TextosMatar[i] = 5
			elseif Wlista and Elista and (wDMG + eDMG >= objetivo.health) then
				TextosMatar[i] = 4
			elseif Wlista and Rlista and (wDMG + rDMG >= objetivo.health) then
				TextosMatar[i] = 3
			elseif Elista and Rlista and (eDMG + rDMG >= objetivo.health) then
				TextosMatar[i] = 2
			elseif Wlista and Elista and Rlista and (wDMG and eDMG and rDMG >= objetivo.health) then
				TextosMatar[i] = 1
			end
		end
	end
end

function OnDraw()
	if loadDone then

		if MachoteConfig.draw.drawQrange then
			DrawCircle(myHero.x, myHero.y, myHero.z, rangoQ, RGB(255, 255, 255))
		end

		if MachoteConfig.draw.drawWrange then
			DrawCircle(myHero.x, myHero.y, myHero.z, rangoW, RGB(255, 255, 255))
		end

		if MachoteConfig.draw.drawErange then
			DrawCircle(myHero.x, myHero.y, myHero.z, MachoteConfig.combo.Einfo.rangeToE, RGB(255, 255, 255))
		end

		if MachoteConfig.draw.drawRrange then
			DrawCircle(myHero.x, myHero.y, myHero.z, rangoR, RGB(255, 255, 255))
		end

		if MachoteConfig.draw.drawAArange then
			DrawCircle(myHero.x, myHero.y, myHero.z, SOWi:MyRange() + 25, RGB(0, 255, 0))
		end

		if MachoteConfig.draw.drawTarget and Target ~= nil then
			DrawCircle(Target.x, Target.y, Target.z, 500, RGB(255, 0, 255))
		end

		if MachoteConfig.draw.drawKill then
			for i=1, heroManager.iCount do
				local objetivo = heroManager:GetHero(i)
				if ValidTarget(objetivo, 3500) and objetivo ~= nil and TextosEsperar[i] == 1 then
					PrintFloatText(objetivo, 0, ListaTextos[TextosMatar[i]])
				end
				if ValidTarget(objetivo, 3500) then
					if TextosEsperar[i] == 1 then
						TextosEsperar[i] = 30
					else
						TextosEsperar[i] = TextosEsperar[i] - 1
					end
				end
			end
		end
	end
end

function OnAnimation(unit, animation)

	if unit.isMe and animation:lower():find("attack") and Target ~= nil then
		if MachoteConfig.Debug.Debug then
			PrintChat(animation)
		end

		if MachoteConfig.keys.comboWeavingKey and MachoteConfig.combo.Einfo.useE and Elista and (GetDistance(Target) < ((SOWi:MyRange() + 25) + VP:GetHitBox(Target))) then
			DelayAction(function() CastSpell(_E, Target) end, tiempoAnimacion + 0.01)
			if MachoteConfig.Debug.Debug then
				PrintChat("E en cadena")
			end

		elseif MachoteConfig.keys.comboWeavingKey and MachoteConfig.combo.Rinfo.useR and Rlista and not Elista and (GetDistance(Target) < ((SOWi:MyRange() + 25) + VP:GetHitBox(Target))) then
			DelayAction(function() CastSpell(_R) end, tiempoAnimacion + 0.01)
			if MachoteConfig.Debug.Debug then
				PrintChat("R en cadena")
			end

		elseif MachoteConfig.keys.comboWeavingKey and MachoteConfig.combo.Winfo.useW and Wlista and not Elista and not Rlista and (GetDistance(Target) < ((SOWi:MyRange() + 25) + VP:GetHitBox(Target))) then
			DelayAction(function() CastSpell(_W) end, tiempoAnimacion + 0.01)
			if MachoteConfig.Debug.Debug then
				PrintChat("W en cadena")
			end

		elseif MachoteConfig.keys.comboWeavingKey and not (MachoteConfig.combo.Qinfo.useQ == 1) and Qlista and not Wlista and not Elista and not Rlista and (GetDistance(Target) < (SOWi:MyRange() + 25)) then
			DelayAction(function() CastSpell(_Q, myHero) end, tiempoAnimacion + 0.01)
			if MachoteConfig.Debug.Debug then
				PrintChat("Q en cadena")
			end
		end
	end
end

function OnProcessSpell(unit, spell)

	if unit == myHero then
		if spell.name:lower():find("attack") then
			tiempoAnimacion = spell.windUpTime
		end
	end

	if #InterrumpirJuego > 0 and Elista then
		for i, habilidad in pairs(InterrumpirJuego) do
			if spell.name == habilidad and (unit.team ~= myHero.team) and MachoteConfig.inter[habilidad] then
				if GetDistance(unit) < rangoE then
					CastSpell(_E, unit)
				end
			end
		end
	end
end

function AutoHealAlly()

	local ally = GetAllyHeroes()
	for i, aliadoAcurar in pairs(ally) do
		if aliadoAcurar.health < ((MachoteConfig.combo.Qinfo.AHAmin / 100) * aliadoAcurar.maxHealth) then
			if GetDistance(aliadoAcurar) < rangoQ then
				CastSpell(_Q, aliadoAcurar)
			end
		end
	end
end

function InterrumpirMenu()

	if #InterrumpirJuego > 0 then
		for i, hechizoInter in pairs(InterrumpirJuego) do
			MachoteConfig.inter:addParam(hechizoInter, hechizoInter, SCRIPT_PARAM_ONOFF, true)
		end
	else
		MachoteConfig.inter:addParam("info2", "No supported spells found", SCRIPT_PARAM_INFO, "")
	end
end
