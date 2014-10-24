--[[
Twitch, el niño rata
by
DaPipex
--]]

local version = "1.3"

if myHero.charName ~= "Twitch" then return end

-- These variables need to be near the top of your script so you can call them in your callbacks.
HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
-- DO NOT CHANGE. This is set to your proper ID.
id = 291

-- CHANGE ME. Make this the exact same name as the script you added into the site!
ScriptName = "TwitchNinoRata"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()


local DaPipexTwitchUpdate = true
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

if DaPipexTwitchUpdate then
	SourceUpdater("TwitchNinoRata", version, "raw.github.com", "/DaPipex/BoL_Scripts/master/TwitchNinoRata.lua", SCRIPT_PATH..GetCurrentEnv().FILE_NAME):CheckUpdate()
end

local RequireSL = Require("Twitchy Libs")
RequireSL:Add("VPrediction", "https://raw.githubusercontent.com/Hellsing/BoL/master/common/VPrediction.lua")
RequireSL:Add("SOW", "https://raw.githubusercontent.com/Hellsing/BoL/master/common/SOW.lua")
--RequireSL:Add("SxOrbWalk", "https://raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua")

RequireSL:Check()

if RequireSL.downloadNeeded == true then return end

function OnLoad()

	loadDone = false

	TwitchVars()
	TwitchMenu()

	PrintChat("<font color='#246205'>Twitch niño rata: Loaded!</font>")

	UpdateWeb(true, ScriptName, id, HWID)

end

function OnUnload()

	UpdateWeb(false, ScriptName, id, HWID)

end

function OnBugsplat()

	UpdateWeb(false, ScriptName, id, HWID)

end


function TwitchVars()
	
	HechizoQ = { rango = 1000, ancho = nil, velocidad = nil, demora = nil}
	HechizoW = { rango = 950, ancho = 275, velocidad = 1750, demora = .25}
	HechizoE = { rango = 1200, ancho = nil, velocidad = nil, demora = nil}
	HechizoR = { rango = 850, ancho = nil, velocidad = nil, demora = nil}

	Qlista, Wlista, Elista, Rlista, Ilista = nil, nil, nil, nil, nil

	EspadaDelChoro, CurvedPenis, RapiditoAtaco = nil, nil, nil

	VenenoCount = {}

	InvisiDuration = nil

	castigo = nil

	VP, SOWi, STStw, SxOrb = nil, nil, nil

	VP = VPrediction()
	SOWi = SOW(VP)
	STStw = SimpleTS(STS_PRIORITY_LESS_CAST_PHYSICAL)

	local enemigos = GetEnemyHeroes()
	for i, enemy in pairs(enemigos) do
		VenenoCount[enemy.charName] = 0
	end

	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
		castigo = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
		castigo = SUMMONER_2
	end

end

function TwitchMenu()

	Twitchy = scriptConfig("Twitch - Nino Rata", "twitchdapipex")

	Twitchy:addSubMenu("Orbwalking - SOW", "orbwSOW")
	SOWi:LoadToMenu(Twitchy.orbwSOW, STStw)

	Twitchy:addSubMenu("Simple Target Selector", "sts")
	STStw:AddToMenu(Twitchy.sts)

	Twitchy:addSubMenu("Keys", "keys")
	Twitchy.keys:addParam("combokey", "Combo Key (SPACE)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	Twitchy.keys:addParam("harassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	Twitchy.keys:addParam("harassKeyToggle", "Harass Key Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("H"))

	Twitchy:addSubMenu("Combo", "combo")

	Twitchy.combo:addSubMenu("Q Settings", "qInfo")
	Twitchy.combo.qInfo:addParam("useQ1", "Use Q ...", SCRIPT_PARAM_ONOFF, false)
	Twitchy.combo.qInfo:addParam("useQenemies", "^ if # enemies in range", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
	Twitchy.combo.qInfo:addParam("useQ2", "Use Q ...", SCRIPT_PARAM_ONOFF, false)
	Twitchy.combo.qInfo:addParam("useQhealth", "^ if my HP% is under", SCRIPT_PARAM_SLICE, 40, 1, 100, 0)

	Twitchy.combo:addSubMenu("W Settings", "wInfo")
	Twitchy.combo.wInfo:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
	Twitchy.combo.wInfo:addParam("useWenemies", "^ if will hit # enemies", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
	Twitchy.combo.wInfo:addParam("useWpred", "Use with Prediction", SCRIPT_PARAM_ONOFF, true)

	Twitchy.combo:addSubMenu("E Settings", "eInfo")
	Twitchy.combo.eInfo:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
	Twitchy.combo.eInfo:addParam("useEminStacks", "Min Poison Stacks", SCRIPT_PARAM_SLICE, 6, 1, 6, 0)

	Twitchy.combo:addSubMenu("R Settings", "rInfo")
	Twitchy.combo.rInfo:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, true)
	Twitchy.combo.rInfo:addParam("useRenemies", "if # enemies in range", SCRIPT_PARAM_SLICE, 2, 1, 6, 0)

	Twitchy:addSubMenu("Harass", "harass")
	Twitchy.harass:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
	Twitchy.harass:addParam("useWmana", "W Mana Manager", SCRIPT_PARAM_SLICE, 30, 1, 100, 0)
	Twitchy.harass:addParam("useWpred", "Use with Prediction", SCRIPT_PARAM_ONOFF, true)
	Twitchy.harass:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, false)
	Twitchy.harass:addParam("useEminStacks", "Min Poison Stacks", SCRIPT_PARAM_SLICE, 3, 1, 6, 0)

	Twitchy:addSubMenu("Items", "items")
	Twitchy.items:addParam("useBOTRK", "Use Ruined King", SCRIPT_PARAM_ONOFF, true)
	Twitchy.items:addParam("useBC", "Use Bilgewater Cutlass", SCRIPT_PARAM_ONOFF, true)
	Twitchy.items:addParam("useYMG", "Use Youmuu's Ghostblade", SCRIPT_PARAM_ONOFF, true)

	Twitchy:addSubMenu("Killsteal", "ks")
	Twitchy.ks:addParam("ksE", "KS with E", SCRIPT_PARAM_ONOFF, true)
	Twitchy.ks:addParam("ksIgnite", "KS with Ignite", SCRIPT_PARAM_ONOFF, true)

	Twitchy:addSubMenu("Drawing", "draw")
	Twitchy.draw:addParam("qRange", "Range to use Q", SCRIPT_PARAM_ONOFF, true)
	Twitchy.draw:addParam("wRange", "Range to use W", SCRIPT_PARAM_ONOFF, true)
	Twitchy.draw:addParam("wSplash", "W AOE Range", SCRIPT_PARAM_ONOFF, false)
	Twitchy.draw:addParam("eRange", "Range to use E", SCRIPT_PARAM_ONOFF, true)
	Twitchy.draw:addParam("aaRange", "AA Range normal", SCRIPT_PARAM_ONOFF, false)
	Twitchy.draw:addParam("rRange", "AA Range if R on", SCRIPT_PARAM_ONOFF, true)
	Twitchy.draw:addParam("invDuration", "Invisibility Duration", SCRIPT_PARAM_ONOFF, true)
	Twitchy.draw:addParam("stackCount", "Enemy Stack Count", SCRIPT_PARAM_ONOFF, true)

	Twitchy.draw:addSubMenu("Colors", "colors")
	Twitchy.draw.colors:addParam("qColor", "Q Range Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
	Twitchy.draw.colors:addParam("wColor", "W Range Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
	Twitchy.draw.colors:addParam("wAOEColor", "W AOE Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
	Twitchy.draw.colors:addParam("eColor", "E Range Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
	Twitchy.draw.colors:addParam("rColor", "R Range Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
	Twitchy.draw.colors:addParam("aaColor", "AA Range Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})

	Twitchy:addSubMenu("Prediction", "pred")
	Twitchy.pred:addParam("mode", "Choose Prediction:", SCRIPT_PARAM_LIST, 1, {"VPrediction"})
	Twitchy.pred:addParam("info1", "Prodiction to be added:", SCRIPT_PARAM_INFO, "Soon")

	Twitchy:addSubMenu("Extras", "extras")
	Twitchy.extras:addParam("useSkin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
	Twitchy.extras:addParam("chooseSkin", "Choose skin:", SCRIPT_PARAM_SLICE, 0, 0, 5, 0)

	Twitchy:addSubMenu("Script Info", "scriptInfo")
	Twitchy.scriptInfo:addParam("infoAuth", "Author", SCRIPT_PARAM_INFO, "DaPipex")
	Twitchy.scriptInfo:addParam("infoVers", "Version", SCRIPT_PARAM_INFO, version)

	loadDone = true

end

function OnTick()

	if loadDone then

		Chequeos()
		KillSteal()
		--CalculoDeDano()

		if Twitchy.extras.useSkin then
			if CambioSkin() then
				GenModelPacket("Twitch", Twitchy.extras.chooseSkin)
				lastSkin = Twitchy.extras.chooseSkin
			end
		end

		if Twitchy.keys.combokey then
			Combo()
			UsarObjetos()
		end

		if Twitchy.keys.harassKey or Twitchy.keys.harassKeyToggle then
			Harass()
		end

		if GetGame().isOver then
			UpdateWeb(false, ScriptName, id, HWID)
			loadDone = false
		end

	end
end

function Chequeos()

	Qlista = (myHero:CanUseSpell(_Q) == READY)
	Wlista = (myHero:CanUseSpell(_W) == READY)
	Elista = (myHero:CanUseSpell(_E) == READY)
	Rlista = (myHero:CanUseSpell(_R) == READY)
	Ilista = (castigo ~= nil and myHero:CanUseSpell(castigo) == READY)

	EspadaDelChoro = GetInventorySlotItem(3153)
	CurvedPenis = GetInventorySlotItem(3144)
	RapiditoAtaco = GetInventorySlotItem(3142)

	BOTRKlisto = (EspadaDelChoro ~= nil and myHero:CanUseSpell(EspadaDelChoro) == READY)
	BClisto = (CurvedPenis ~= nil and myHero:CanUseSpell(CurvedPenis) == READY)
	YMGlisto = (RapiditoAtaco ~= nil and myHero:CanUseSpell(RapiditoAtaco) == READY)

	Target = STStw:GetTarget(HechizoW.rango)

end

function Combo()

	if Qlista then
		if Twitchy.combo.qInfo.useQ1 then
			if CountEnemyHeroInRange(HechizoQ.rango) >= Twitchy.combo.qInfo.useQenemies then
				CastSpell(_Q)
			end
		end

		if Twitchy.combo.qInfo.useQ2 then
			if myHero.health < ((Twitchy.combo.qInfo.useQhealth / 100) * myHero.maxHealth) then
				CastSpell(_Q)
			end
		end
	end

	if Wlista then
		if Twitchy.combo.wInfo.useW and Target ~= nil and Twitchy.combo.wInfo.useWpred then
			CastW(Target, false, true)
		else
			CastW(Target, false, false)
		end
	end

	if Rlista then
		if Twitchy.combo.rInfo.useR then
			if CountEnemyHeroInRange(HechizoR.rango) >= Twitchy.combo.rInfo.useRenemies then
				CastSpell(_R)
			end
		end
	end

	if Elista then
		local enemigos = GetEnemyHeroes()
		for i, enemy in pairs(enemigos) do
			if ValidTarget(enemy, HechizoE.rango) then
				if VenenoCount[enemy.charName] >= Twitchy.combo.eInfo.useEminStacks then
					CastSpell(_E)
				end
			end
		end
	end
end

function Harass()

	if Wlista then
		if Target ~= nil then
			if myHero.mana > ((Twitchy.harass.useWmana / 100) * myHero.maxMana) then
				if Twitchy.harass.useW and Twitchy.harass.useWpred then
					CastW(Target, true, true)
				else
					CastW(Target, true, false)
				end
			end
		end
	end

	if Elista then
		if Twitchy.harass.useE then
			local enemigos = GetEnemyHeroes()
			for i, enemy in pairs(enemigos) do
				if ValidTarget(enemy, HechizoE.rango) then
					if VenenoCount[enemy.charName] >= Twitchy.harass.useEminStacks then
						CastSpell(_E)
					end
				end
			end
		end
	end

end

function OnGainBuff(unit, buff)

	if unit.type == myHero.type and unit.team ~= myHero.team then
		if buff.name == "twitchdeadlyvenom" then
			VenenoCount[unit.charName] = buff.stack
		end
	end

	if unit.isMe and buff.name == "TwitchHideInShadows" then
		InvisiTick = GetTickCount()
		InvisiDuration = buff.duration
	end
end

function OnLoseBuff(unit, buff)

	if unit.type == myHero.type and unit.team ~= myHero.team then
		if buff.name == "twitchdeadlyvenom" then
			VenenoCount[unit.charName] = 0
		end
	end

	if unit.isMe and buff.name == "TwitchHideInShadows" then
		InvisiTick = nil
		InvisiDuration = nil
	end
end

function OnUpdateBuff(unit, buff)

	if unit.type == myHero.type and unit.team ~= myHero.team then
		if buff.name == "twitchdeadlyvenom" then
			VenenoCount[unit.charName] = buff.stack
		end
	end
end

function CastW(Weon, HarassMode, UsePred)

	if not UsePred and not HarassMode then
		local enemiesRangeTarget = 0
		if ValidTarget(Target, HechizoW.rango) then
			enemiesRangeTarget = CountEnemyHeroInRange(HechizoW.ancho, Target)
			if enemiesRangeTarget >= Twitchy.combo.wInfo.useWenemies then
				CastSpell(_W, Target)
			end
		end
	elseif not UsePred and HarassMode then
		if ValidTarget(Target, HechizoW.rango) then
			CastSpell(_W, Target)
		end
	else
		if not HarassMode then
			local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(Weon, HechizoW.demora, HechizoW.ancho, HechizoW.rango, HechizoW.velocidad, myHero)
			if AOECastPosition and nTargets >= Twitchy.combo.wInfo.useWenemies then
				CastSpell(_W, AOECastPosition.x, AOECastPosition.z)
			end
		else
			local CastPosition, HitChance, Position = VP:GetCircularCastPosition(Weon, HechizoW.demora, HechizoW.ancho, HechizoW.rango, HechizoW.velocidad, myHero, false)
			if CastPosition and HitChance >= 1 then
				CastSpell(_W, CastPosition.x, CastPosition.z)
			end
		end
	end
end

function UsarObjetos()

	if Target ~= nil then
		if Twitchy.items.useBOTRK and (GetDistance(Target) < 450) then
			if BOTRKlisto then
				CastSpell(EspadaDelChoro, Target)
			end
		end

		if Twitchy.items.useBC and (GetDistance(Target) < 450) then
			if BClisto then
				CastSpell(CurvedPenis, Target)
			end
		end

		if Twitchy.items.useYMG and ((GetDistance(Target) < (SOWi:MyRange() - 100))) then
			if YMGlisto then
				CastSpell(RapiditoAtaco, Target)
			end
		end
	end
end

function KillSteal()

	local enemigos = GetEnemyHeroes()
	for i, enemy in pairs(enemigos) do

		if Twitchy.ks.ksE then
			if ValidTarget(enemy, HechizoE.rango) then
				local PoisonStacks = VenenoCount[enemy.charName]
				local eDMG = (5*myHero:GetSpellData(_E).level+10+.2*myHero.ap+.25*myHero.addDamage)*PoisonStacks
				if myHero:CalcDamage(enemy, eDMG) > enemy.health then
					CastSpell(_E)
				end
			end
		end

		if Twitchy.ks.ksIgnite and Ilista then
			if GetDistance(enemy) < 600 and ValidTarget(enemy) then
				if getDmg("IGNITE", enemy, myHero) > enemy.health then
					CastSpell(castigo, enemy)
				end
			end
		end
	end
end

function OnDraw()

	if loadDone and not myHero.dead then

		if Twitchy.draw.qRange then
			DrawCircle(myHero.x, myHero.y, myHero.z, HechizoQ.rango, TRGB(Twitchy.draw.colors.qColor))
		end

		if Twitchy.draw.wRange then
			DrawCircle(myHero.x, myHero.y, myHero.z, HechizoW.rango, TRGB(Twitchy.draw.colors.wColor))
		end

		if Twitchy.draw.wSplash then
			DrawCircle(mousePos.x, mousePos.y, mousePos.z, HechizoW.ancho, TRGB(Twitchy.draw.colors.wAOEColor))
		end

		if Twitchy.draw.eRange then
			DrawCircle(myHero.x, myHero.y, myHero.z, HechizoE.rango, TRGB(Twitchy.draw.colors.eColor))
		end

		if Twitchy.draw.rRange then
			DrawCircle(myHero.x, myHero.y, myHero.z, HechizoR.rango, TRGB(Twitchy.draw.colors.rColor))
		end

		if Twitchy.draw.aaRange then
			DrawCircle(myHero.x, myHero.y, myHero.z, SOWi:MyRange(), TRGB(Twitchy.draw.colors.aaColor))
		end

		if Twitchy.draw.stackCount then
			for i, enemy in pairs(GetEnemyHeroes()) do
				if enemy.visible then
					local EnemyToScreen = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
					DrawText(tostring(VenenoCount[enemy.charName]), 25, EnemyToScreen.x, EnemyToScreen.y, RGB(255, 255, 0))
				end
			end
		end

		if Twitchy.draw.invDuration then
			local HeroToScreen = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
			local TickAhora = GetTickCount()
			if InvisiDuration then
				local Remnant = ((TickAhora - InvisiTick) / 1000)
				local RealRemnant = (InvisiDuration - Remnant)
				if RealRemnant < 0 then
					InvisiDuration = nil
				end
				DrawText(tostring(Dienoround(RealRemnant, 1)), 25, HeroToScreen.x, HeroToScreen.y, RGB(0, 255, 0))
			else
				DrawText("Visible", 25, HeroToScreen.x, HeroToScreen.y, RGB(255, 0, 0))
			end
		end
	end
end


function TRGB(colorTable)
	return RGB(colorTable[2], colorTable[3], colorTable[4])
end

function GenModelPacket(champ, skinId)
	p = CLoLPacket(0x97)
	p:EncodeF(myHero.networkID)
	p.pos = 1
	t1 = p:Decode1()
	t2 = p:Decode1()
	t3 = p:Decode1()
	t4 = p:Decode1()
	p:Encode1(t1)
	p:Encode1(t2)
	p:Encode1(t3)
	p:Encode1(bit32.band(t4,0xB))
    p:Encode1(1)--hardcode 1 bitfield
    p:Encode4(skinId)
    for i = 1, #champ do
    	p:Encode1(string.byte(champ:sub(i,i)))
    end
    for i = #champ + 1, 64 do
    	p:Encode1(0)
    end
    p:Hide()
    RecvPacket(p)
end

function CambioSkin()
	return Twitchy.extras.chooseSkin ~= lastSkin
end

--Credits Dienofail from his Jayce Script--
function Dienoround(num, idp)
	return string.format("%." .. (idp or 0) .. "f", num)
end
--Credits Dienofail from his Jayce Script--
