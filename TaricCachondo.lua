--[[
Taric, el caballero cachondo
by
DaPipex
--]]

local version = "1.0"

if myHero.charName ~= "Taric" then return end

-- These variables need to be near the top of your script so you can call them in your callbacks.
HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
-- DO NOT CHANGE. This is set to your proper ID.
id = 291

-- CHANGE ME. Make this the exact same name as the script you added into the site!
ScriptName = "TaricCachondo"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()


local DaPipexTaricUpdate = true
local SourceLibURL = "https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua"
local SourceLibPath = LIB_PATH.."SourceLib.lua"
local DownloadingSourceLib = false

if FileExist(SourceLibPath) then
	require "SourceLib"
	DownloadingSourceLib = false
else
	DownloadingSourceLib = true
	DownloadFile(SourceLibURL, SourceLibPath, function() PrintChat("SourceLib downloaded, please reload (Double F9)") end)
end

if DownloadingSourceLib == true then
	PrintChat("SourceLib is being downloaded, please wait.")
	return
end

if DaPipexTaricUpdate then
	SourceUpdater("TaricCachondo", version, "raw.github.com", "/DaPipex/BoL_Scripts/master/TaricCachondo.lua", SCRIPT_PATH..GetCurrentEnv().FILE_NAME):CheckUpdate()
end

local RequireSL = Require("Taric Libs")
RequireSL:Add("VPrediction", "https://raw.githubusercontent.com/Hellsing/BoL/master/common/VPrediction.lua")
RequireSL:Add("SOW", "https://raw.githubusercontent.com/Hellsing/BoL/master/common/SOW.lua")

RequireSL:Check()

if RequireSL.downloadNeeded == true then return end



function OnLoad()

	loadDone = false

	TaricVars()
	TaricMenu()
	ExtrasMenu()

	PrintChat("<font color='#19DEDB'>Taric, el caballero cachondo Loaded!</font>")

end

function TaricVars()

	HechizoQ = { rango = 750 }
	HechizoW = { rango = 400, demora = 0.25 }
	HechizoE = { rangoMax = 625, rangoMin = 1 }
	HechizoR = { rango = 400 }

	VP, SOWi, STSta = nil, nil, nil

	Qlista, Wlista, Elista, Rlista, Ilista = false, false, false, false, false

	castigo = nil

	tiempoAnimacion = 0

	VP = VPrediction()
	SOWi = SOW(VP)
	STSta = SimpleTS(STS_PRIORITY_LESS_CAST_MAGIC)


	TextosMatar = {}
	ListaTextos = { "W+E+R", "E+R", "W+R", "W+E", "R", "E", "W", "Harass" }
	TextosEsperar = {}

	for k=1, heroManager.iCount do
		TextosEsperar[k] = k * 3
	end


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
		for j, campeon in pairs(InterrumpirCompleto) do
			if enemigo.charName == campeon.nombre then
				table.insert(InterrumpirJuego, campeon.hechizo)
			end
		end
	end

	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
		castigo = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
		castigo = SUMMONER_2
	end

end

function TaricMenu()

	Machote = scriptConfig("Taric Cachondo Remade", "GemasCachondas")

	Machote:addSubMenu("Orbwalking", "orbw")
	SOWi:LoadToMenu(Machote.orbw, STSta)

	Machote:addSubMenu("Keys", "keys")
	Machote.keys:addParam("combo", "All-In Combo (Space)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	Machote.keys:addParam("SWcombo", "Spell-Weaving Combo", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	Machote.keys:addParam("harass", "Harass with E", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))

	Machote:addSubMenu("SBTW", "sbtw")

	Machote.sbtw:addSubMenu("Q Settings", "qInfo")
	Machote.sbtw.qInfo:addParam("useQ", "Use Q", SCRIPT_PARAM_LIST, 3, {"Don't use", "Only on me", "Only on low ally"})
	Machote.sbtw.qInfo:addParam("useQslider", "Min HP% to heal", SCRIPT_PARAM_SLICE, 75, 1, 100, 0)

	Machote.sbtw:addSubMenu("W Settings", "wInfo")
	Machote.sbtw.wInfo:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
	Machote.sbtw.wInfo:addParam("useWenemies", "Enemies to use W", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)

	Machote.sbtw:addSubMenu("E Settings", "eInfo")
	Machote.sbtw.eInfo:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
	Machote.sbtw.eInfo:addParam("useEslider", "Range to E", SCRIPT_PARAM_SLICE, HechizoE.rangoMax, HechizoE.rangoMin, HechizoE.rangoMax, 0)

	Machote.sbtw:addSubMenu("R Settings", "rInfo")
	Machote.sbtw.rInfo:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
	Machote.sbtw.rInfo:addParam("useRenemies", "Enemies to use R", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)

	Machote:addSubMenu("Healing", "heal")
	Machote.heal:addParam("autoHealMe", "Auto Heal me", SCRIPT_PARAM_ONOFF, false)
	Machote.heal:addParam("AHMslide", "^ if under %HP", SCRIPT_PARAM_SLICE, 75, 1, 100, 0)
	Machote.heal:addParam("autoHealOthers", "Auto Heal Others", SCRIPT_PARAM_ONOFF, false)
	Machote.heal:addParam("AHOslide", "^ if under %HP", SCRIPT_PARAM_SLICE, 75, 1, 100, 0)

	Machote:addSubMenu("Interrupt", "inter")

	Machote:addSubMenu("Killsteal", "ks")
	Machote.ks:addParam("ksW", "KS with W", SCRIPT_PARAM_ONOFF, true)
	Machote.ks:addParam("ksE", "KS with E", SCRIPT_PARAM_ONOFF, false)
	Machote.ks:addParam("ksR", "KS with R", SCRIPT_PARAM_ONOFF, true)
	Machote.ks:addParam("ksIgnite", "KS with Ignite", SCRIPT_PARAM_ONOFF, true)

	Machote:addSubMenu("Drawing", "draw")
	Machote.draw:addParam("drawAA", "Draw AA range", SCRIPT_PARAM_ONOFF, false)
	Machote.draw:addParam("drawQ", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
	Machote.draw:addParam("drawWR", "Draw W/R range", SCRIPT_PARAM_ONOFF, true)
	Machote.draw:addParam("drawE", "Draw user-set E range", SCRIPT_PARAM_ONOFF, true)
	Machote.draw:addParam("drawKill", "Draw Killable", SCRIPT_PARAM_ONOFF, true)

	Machote.draw:addSubMenu("Colors", "colors")
	Machote.draw.colors:addParam("aaColor", "AA Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
	Machote.draw.colors:addParam("qColor", "Q Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
	Machote.draw.colors:addParam("wrColor", "W/R Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
	Machote.draw.colors:addParam("eColor", "E Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})

	Machote:addSubMenu("Extras", "extras")
	Machote.extras:addParam("useSkin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
	Machote.extras:addParam("chooseSkin", "Choose skin:", SCRIPT_PARAM_SLICE, 0, 0, 3, 0)

	Machote:addSubMenu("Script Info", "scriptInfo")
	Machote.scriptInfo:addParam("infoAuth", "Author", SCRIPT_PARAM_INFO, "DaPipex")
	Machote.scriptInfo:addParam("infoVers", "Version", SCRIPT_PARAM_INFO, version)

	loadDone = true

end

function OnTick()

	if loadDone then

		Chequeos()
		KillSteal()
		CalculoDeDano()

		if Machote.extras.useSkin then
			if CambioSkin() then
				GenModelPacket("Taric", Machote.extras.chooseSkin)
				lastSkin = Machote.extras.chooseSkin
			end
		end

		if Machote.keys.combo then
			NormalCombo()
		end

		--[[
		if Machote.keys.SWcombo then
			SWCombo()
		end
		--]]

		if Machote.keys.harass then
			Harass()
		end

		if Machote.heal.autoHealMe or Machote.heal.autoHealOthers then
			AmbulanciaCachonda()
		end

	end

end

function Chequeos()

	Qlista = (myHero:CanUseSpell(_Q) == READY)
	Wlista = (myHero:CanUseSpell(_W) == READY)
	Elista = (myHero:CanUseSpell(_E) == READY)
	Rlista = (myHero:CanUseSpell(_R) == READY)
	Ilista = (castigo ~= nil and myHero:CanUseSpell(castigo) == READY)

	Target = STSta:GetTarget(HechizoE.rangoMax)

end

function NormalCombo()

	if Qlista then
		if Machote.sbtw.qInfo.useQ == 2 then
			if myHero.health < ((Machote.sbtw.qInfo.useQslider / 100) * myHero.maxHealth) then
				CastSpell(_Q, myHero)
			end
		elseif Machote.sbtw.qInfo.useQ == 3 then
			local aliados = GetAllyHeroes()
			for i, ally in pairs(aliados) do
				if not ally.dead then
					if GetDistance(ally) < HechizoQ.rango then
						if ally.health < ((Machote.sbtw.qInfo.useQslider / 100) * ally.maxHealth) then
							CastSpell(_Q, ally)
						end
					end
				end
			end
		end
	end

	if Wlista then
		if Machote.sbtw.wInfo.useW then
			if CountEnemyHeroInRange(HechizoW.rango) >= Machote.sbtw.wInfo.useWenemies then
				CastSpell(_W)
			end
		end
	end

	if Elista and Target ~= nil then
		if Machote.sbtw.eInfo.useE then
			if ValidTarget(Target, Machote.sbtw.eInfo.useEslider) then
				CastSpell(_E, Target)
			end
		end
	end

	if Rlista then
		if Machote.sbtw.rInfo.useR then
			if CountEnemyHeroInRange(HechizoR.rango) >= Machote.sbtw.rInfo.useRenemies then
				CastSpell(_R)
			end
		end
	end
end

function Harass()

	if Elista and Target ~= nil and ValidTarget(Target, HechizoE.rangoMax) then
		CastSpell(_E, Target)
	end
end

function AmbulanciaCachonda()

	if Machote.heal.autoHealMe then
		if Qlista then
			if myHero.health < ((Machote.heal.AHMslide / 100) * myHero.maxHealth) then
				CastSpell(_Q, myHero)
			end
		end
	end

	if Machote.heal.autoHealOthers then
		if Qlista then
			local aliados = GetAllyHeroes()
			for i, ally in pairs(aliados) do
				if not ally.dead then
					if GetDistance(ally) < HechizoQ.rango then
						if ally.health > ((Machote.heal.AHOslide / 100) * ally.maxHealth) then
							CastSpell(_Q, ally)
						end
					end
				end
			end
		end
	end
end

function KillSteal()

	local perrosCuliaos = GetEnemyHeroes()

	for i, enemy in pairs(perrosCuliaos) do

		if Machote.ks.ksW and Wlista then
			if GetDistance(enemy) < HechizoW.rango and ValidTarget(enemy) then
				if getDmg("W", enemy, myHero) > enemy.health then
					CastSpell(_W)
				end
			end
		end

		if Machote.ks.ksE and Elista then
			if GetDistance(enemy) < HechizoE.rangoMax and ValidTarget(enemy) then
				if getDmg("E", enemy, myHero) > enemy.health then
					CastSpell(_E, enemy)
				end
			end
		end

		if Machote.ks.ksR and Rlista then
			if GetDistance(enemy) < HechizoR.rango and ValidTarget(enemy) then
				if getDmg("R", enemy, myHero) > enemy.health then
					CastSpell(_R)
				end
			end
		end

		if Machote.ks.ksIgnite and Ilista then
			if GetDistance(enemy) < 600 and ValidTarget(enemy) then
				if getDmg("IGNITE", enemy, myHero) > enemy.health then
					CastSpell(castigo, enemy)
				end
			end
		end
	end
end

function ExtrasMenu()

	if #InterrumpirJuego > 0 then
		for i, hechizoInter in pairs(InterrumpirJuego) do
			Machote.inter:addParam(hechizoInter, hechizoInter, SCRIPT_PARAM_ONOFF, true)
		end
	else
		Machote.inter:addParam("info1", "No supported spells found", SCRIPT_PARAM_INFO, "")
	end
end

function OnProcessSpell(unit, spell)

	if unit == myHero then
		if spell.name:lower():find("attack") then
			tiempoAnimacion = spell.windUpTime
		end
	end

	if #InterrumpirJuego > 0 and Elista then
		for i, hechizoInter in pairs(InterrumpirJuego) do
			if spell.name == hechizoInter and (unit.team ~= myHero.team) and Machote.inter[hechizoInter] then
				if ValidTarget(unit, HechizoE.rangoMax) then
					CastSpell(_E, unit)
				end
			end
		end
	end
end

function OnAnimation(unit, animation)

	if unit.isMe and animation:lower():find("attack") and Target ~= nil then
		if Machote.keys.SWcombo then
			if Elista and ValidTarget(Target, HechizoE.rangoMax) then
				DelayAction(function() CastSpell(_E, Target) end, tiempoAnimacion + 0.01)
			elseif Rlista and not Elista and ValidTarget(Target, HechizoR.rango) then
				DelayAction(function() CastSpell(_R) end, tiempoAnimacion + 0.01)
			elseif Wlista and not Rlista and not Elista and ValidTarget(Target, HechizoW.rango) then
				DelayAction(function() CastSpell(_W) end, tiempoAnimacion + 0.01)
			elseif Qlista and not Wlista and not Rlista and not Elista and ValidTarget(Target, 400) then
				DelayAction(function() CastSpell(_Q, myHero) end, tiempoAnimacion + 0.01)
			end
		end
	end
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

function TRGB(colorTable)
	return RGB(colorTable[2], colorTable[3], colorTable[4])
end

function OnDraw()

	if loadDone and not myHero.dead then

		if Machote.draw.drawAA then
			DrawCircle(myHero.x, myHero.y, myHero.z, SOWi:MyRange(), TRGB(Machote.draw.colors.aaColor))
		end

		if Machote.draw.drawQ then
			DrawCircle(myHero.x, myHero.y, myHero.z, HechizoQ.rango, TRGB(Machote.draw.colors.qColor))
		end

		if Machote.draw.drawWR then
			DrawCircle(myHero.x, myHero.y, myHero.z, HechizoW.rango, TRGB(Machote.draw.colors.wrColor))
		end

		if Machote.draw.drawE then
			DrawCircle(myHero.x, myHero.y, myHero.z, Machote.sbtw.eInfo.useEslider, TRGB(Machote.draw.colors.eColor))
		end

		if Machote.draw.drawKill then
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
