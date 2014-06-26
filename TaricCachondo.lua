--[[Taric, el caballero cachondo
by
DaPipex]]--

local version = 0.01

if myHero.charName ~= "Taric" then return end

--Auto Update - Credits Honda7--

local DaPipexTaricUpdate = false
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
	DelayAction(EndStuff, 2)

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

	TextosMatar = {}
	ListaTextos = {}
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
	MachoteConfig.keys:addParam("comboWeavingKey", "Spell Weaving Combo", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
	MachoteConfig.keys:addParam("harassKey", "Harass with stun", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))

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
	MachoteConfig.draw:addParam("drawQrange", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
	MachoteConfig.draw:addParam("drawWrange", "Draw W range", SCRIPT_PARAM_ONOFF, true)
	--MachoteConfig.draw:addParam("drawMaxErange", "Draw max E range", SCRIPT_PARAM_ONOFF, true)
	MachoteConfig.draw:addParam("drawErange", "Draw user-set E range", SCRIPT_PARAM_ONOFF, true)
	MachoteConfig.draw:addParam("drawRrange", "Draw R range", SCRIPT_PARAM_ONOFF, true)
	MachoteConfig.draw:addParam("drawKill", "Draw Killable", SCRIPT_PARAM_ONOFF, true)

	MachoteConfig:addSubMenu("Debug", "debug")
	MachoteConfig.debug:addParam("debug", "Debugging", SCRIPT_PARAM_ONOFF, false)

	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, rangoE)
	ts.name = "Machote"
	MachoteConfig:addTS(ts)

end

function EndStuff()
	PrintChat("<font color='#C1F220'>Loaded Taric, el caballero cachondo. Version: "..version.." Have fun!</font>")

	loadDone = true
end

function OnTick()

	if loadDone then

		Chequeos()
		Killsteal()
		CalculoDeDano()
		SOWi:ForceTarget(Target)

		--Keys and their functions--
		if MachoteConfig.keys.comboKey then
			Combo()
		end

		--[[if MachoteConfig.keys.comboWeavingKey then
			WeavingCombo(Aweonao)
		end]]--

		if MachoteConfig.keys.harassKey then
			Harass()
		end
		--Keys and functions--
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

	if Qlista then
		if MachoteConfig.combo.Qinfo.useQ == 2 and (myHero.health <= ((MachoteConfig.combo.Qinfo.minHPtoHealSelf / 100) * myHero.maxHealth)) then
			if MachoteConfig.debug.debug then
				PrintChat("Called Q Self")
			end
			CastSpell(_Q, myHero)
		elseif MachoteConfig.combo.Qinfo.useQ == 3 then
			local wachoPeor = LowestAllyInMyRange(rangoQ + 25)
			if wachoPeor.health <= ((MachoteConfig.combo.Qinfo.minHPtoHealAlly / 100) * wachoPeor.maxHealth) then
				if MachoteConfig.debug.debug then
					PrintChat("Called Q Lowest Ally")
				end
				CastSpell(_Q, wachoPeor)
			end
		end
	end

	if Wlista then
		if MachoteConfig.combo.Winfo.useW and ((MachoteConfig.combo.Winfo.minWenemies > CountEnemyHeroInRange(rangoW)) or CountEnemyHeroInRange(rangoW) == 1) then
			if MachoteConfig.debug.debug then
				PrintChat("Called W")
			end
			CastSpell(_W)
		end
	end

	if Elista then
		if MachoteConfig.combo.Einfo.useE then
			if MachoteConfig.combo.Einfo.rangeToE <= GetDistance(Target) then
				if MachoteConfig.debug.debug then
					PrintChat("Called E on "..Target.charName)
				end
				CastSpell(_E, Target)
			end
		end
	end

	if Rlista then
		if MachoteConfig.combo.Rinfo.useR and ((MachoteConfig.combo.Rinfo.minRenemies > CountEnemyHeroInRange(rangoR)) or CountEnemyHeroInRange(rangoW) == 1) then
			if MachoteConfig.debug.debug then
				PrintChat("Called R")
			end
			CastSpell(_R)
		end
	end
end

function Harass()

	if Elista then
		if MachoteConfig.combo.Einfo.rangeToE <= GetDistance(Target) then
			if MachoteConfig.debug.debug then
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
			if ValidTarget(enemigo, rangoW) and Wlista and not Elista and not Rlista then
				if enemigo.health <= getDmg("W", enemigo, myHero) then
					if MachoteConfig.debug.debug then
						PrintChat("Tried to KS with W: "..enemigo.charName)
					end
					CastSpell(_W)
				end
			end
		end

		if MachoteConfig.killsteal.ksE then
			if ValidTarget(enemigo, rangoE) and Elista and not Rlista then
				if enemigo.health <= getDmg("E", enemigo, myHero) then
					if MachoteConfig.debug.debug then
						PrintChat("Tried to KS with E "..enemigo.charName)
					end
					CastSpell(_E, enemigo)
				end
			end
		end

		if MachoteConfig.killsteal.ksR then
			if ValidTarget(enemigo, rangoR) and Rlista then
				if enemigo.health <= getDmg("R", enemigo, myHero) then
					if MachoteConfig.debug.debug then
						PrintChat("Tried to KS with R: "..enemigo.charName)
					end
					CastSpell(_R)
				end
			end
		end

		if MachoteConfig.killsteal.ksI then
			if ValidTarget(enemigo, 600) and Ilista then
				if enemigo.health <= getDmg("IGNITE", enemigo, myHero) then
					if MachoteConfig.debug.debug then
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
		local wachitoPrueba = heroManager:getHero(i)
		if wachitoPrueba.team == myHero.team then
			if not wachitoPrueba.dead and GetDistance(wachitoPrueba) < range then
				pobrecito = wachitoPrueba
			elseif (pobrecito.health / pobrecito.maxHealth) > (wachitoPrueba.health / wachitoPrueba.maxHealth) and not pobrecito.dead then
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
		end
	end
end
