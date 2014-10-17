--[[mORGANa
the organ donor by DaPipex
DaPipex]]

local version = "0.3"

if myHero.charName ~= "Morgana" then return end

-- These variables need to be near the top of your script so you can call them in your callbacks.
HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
-- DO NOT CHANGE. This is set to your proper ID.
id = 291

-- CHANGE ME. Make this the exact same name as the script you added into the site!
ScriptName = "MorganaOrganDonor"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()

local DaPipexMorgUpdate = true
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

if DaPipexMorgUpdate then
	SourceUpdater("MorganaOrganDonor", version, "raw.github.com", "/DaPipex/BoL_Scripts/master/MorganaOrganDonor.lua", SCRIPT_PATH..GetCurrentEnv().FILE_NAME):CheckUpdate()
end

local RequireSL = Require("mORGANa Libs")
RequireSL:Add("VPrediction", "https://raw.githubusercontent.com/Hellsing/BoL/master/common/VPrediction.lua")
RequireSL:Add("SOW", "https://raw.githubusercontent.com/Hellsing/BoL/master/common/SOW.lua")
RequireSL:Add("Prodiction", "https://bitbucket.org/Klokje/public-klokjes-bol-scripts/raw/ec830facccefb3b52212dba5696c08697c3c2854/Test/Prodiction/Prodiction.lua")

RequireSL:Check()

if RequireSL.downloadNeeded == true then return end



function OnLoad()

	loadDone = false

	MorgVars()
	MorgMenu()
	--GapCloserMenu()

	PrintChat("<font color='#9201C7'>mORGANa the Organ Donor: Loaded!</font>")
	UpdateWeb(true, ScriptName, id, HWID)

end

function OnUnload()

	UpdateWeb(false, ScriptName, id, HWID)

end

function OnBugsplat()

	UpdateWeb(false, ScriptName, id, HWID)

end

function MorgVars()

	VP = nil
	SOWi = nil
	STSm = nil
	ProdQ = nil
	freePredQ = nil

	colorRangos = RGB(146, 29, 92)

	TextosMatar = {}
	TextosEsperar = {}
	ListaTextos = { "Q+W+R", "Q+R", "W+R", "Q+W", "R", "Q", "W", "Harass" }

	for k=1, heroManager.iCount do
		TextosEsperar[k] = k * 3
	end

	HechizoQ = {rango = 1300, velocidad = 1200, ancho = 70, demora = 0.5}
	HechizoW = {rango = 900}
	HechizoE = {rango = 750}
	HechizoR = {rango = 625}

	VP = VPrediction()
	STSm = SimpleTS(STS_PRIORITY_LESS_CAST_MAGIC)
	SOWi = SOW(VP)
	ProdQ = Prodiction
	freePredQ = TargetPrediction(HechizoQ.rango, HechizoQ.velocidad, HechizoQ.demora, HechizoQ.ancho)

	WuseTable = {"Never", "ASAP", "On CC'd"}

--[[
	AcercadoresJuego = {}
	Acercadores = {
		{ nombre = "Akali"     , hechizo = "AkaliShadowDance"    },
		{ nombre = "Alistar"   , hechizo = "Headbutt"            },
		{ nombre = "Diana"     , hechizo = "DianaTeleport"       },
		{ nombre = "Irelia"    , hechizo = "IreliaGatotsu"       },
		{ nombre = "Jax"       , hechizo = "JaxLeapStrike"       },
		{ nombre = "Jayce"     , hechizo = "JayceToTheSkies"     },
		{ nombre = "Maokai"    , hechizo = "MaokaiUnstableGrowth"},
		{ nombre = "MonkeyKing", hechizo = "MonkeyKingNimbus"    },
		{ nombre = "Pantheon"  , hechizo = "Pantheon_LeapBash"   },
		{ nombre = "Poppy"     , hechizo = "PoppyHeroicCharge"   },
		{ nombre = "Quinn"     , hechizo = "QuinnE"              },
		{ nombre = "XinZhao"   , hechizo = "XenZhaoSweep"        },
		{ nombre = "LeeSin"    , hechizo = "blindmonkqtwo"       },
        --Non Targeted--
        { nombre = "Aatrox"    , hechizo = "AatroxQ"             },
        { nombre = "Gragas"    , hechizo = "GragasE"             },
        { nombre = "Graves"    , hechizo = "GravesMove"          },
        { nombre = "Hecarim"   , hechizo = "HecarimUlt"          },
        { nombre = "JarvanIV"  , hechizo = "JarvanIVDragonStrike"},
        { nombre = "JarvanIV"  , hechizo = "JarvanIVCataclysm"   },  
        { nombre = "Khazix"    , hechizo = "KhazixE"             },
        { nombre = "Khazix"    , hechizo = "khazixelong"         },  
        { nombre = "Leblanc"   , hechizo = "LeblancSlide"        },
        { nombre = "Leblanc"   , hechizo = "LeblancSlideM"       },
        { nombre = "Leona"     , hechizo = "LeonaZenithBlade"    },
        { nombre = "Malphite"  , hechizo = "UFSlash"             },
        { nombre = "Renekton"  , hechizo = "RenektonSliceAndDice"},
        { nombre = "Sejuani"   , hechizo = "SejuaniArcticAssault"}, 
        { nombre = "Shen"      , hechizo = "ShenShadowDash"      },
        { nombre = "Tristana"  , hechizo = "RocketJump"          },
        { nombre = "Tryndamere", hechizo = "slashCast"           }
    }

    local EquipoEnemigo = GetEnemyHeroes()
    for i, enemigo in pairs(EquipoEnemigo) do
    	for j, campeon in pairs(Acercadores) do
    		if enemigo.charName == campeon.nombre then
    			table.insert(AcercadoresJuego, campeon.hechizo)
    		end
    	end
    end
    --]]

    if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
    	castigo = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
    	castigo = SUMMONER_2
    end

end

function MorgMenu()

	morganMenu = scriptConfig("Morgana - Organ Donor", "morgDaPipex")

	morganMenu:addSubMenu("Orbwalking", "orbw")
	SOWi:LoadToMenu(morganMenu.orbw, STSm)

	morganMenu:addSubMenu("Simple Target Selector", "sts")
	STSm:AddToMenu(morganMenu.sts)

	morganMenu:addSubMenu("Keys", "keys")
	morganMenu.keys:addParam("combo", "SBTW", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	morganMenu.keys:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))

	morganMenu:addSubMenu("SBTW", "combo")
	morganMenu.combo:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	morganMenu.combo:addParam("useWsnared", "Use W on Q'd enemies", SCRIPT_PARAM_ONOFF, true)
	morganMenu.combo:addParam("useWgroup", "Use W on group (MEC)", SCRIPT_PARAM_ONOFF, true)
	morganMenu.combo:addParam("useWgroupMin", "Min enemies to use W MEC", SCRIPT_PARAM_SLICE, 2, 2, 5, 0)
	morganMenu.combo:addParam("useR", "Use R in combo", SCRIPT_PARAM_ONOFF, false)
	morganMenu.combo:addParam("useRmin", "Min enemies to use R", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)

	morganMenu:addSubMenu("Harass", "harass")
	morganMenu.harass:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	morganMenu.harass:addParam("useW", "Use W...", SCRIPT_PARAM_LIST, 1, WuseTable)


	morganMenu:addSubMenu("Anti gap closer", "agc")
	morganMenu.agc:addParam("useAGC", "Enable", SCRIPT_PARAM_ONOFF, true)


	morganMenu:addSubMenu("Killsteal", "ks")
	morganMenu.ks:addParam("useQ", "Use Q to ks", SCRIPT_PARAM_ONOFF, true)
	morganMenu.ks:addParam("useW", "Use W to ks", SCRIPT_PARAM_ONOFF, true)
	morganMenu.ks:addParam("useR", "Use R to ks", SCRIPT_PARAM_ONOFF, true)
	morganMenu.ks:addParam("useIgnite", "Use Ignite to ks", SCRIPT_PARAM_ONOFF, true)

	morganMenu:addSubMenu("Drawing", "draw")
	morganMenu.draw:addParam("drawQ", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
	morganMenu.draw:addParam("drawW", "Draw W range", SCRIPT_PARAM_ONOFF, true)
	morganMenu.draw:addParam("drawE", "Draw E range", SCRIPT_PARAM_ONOFF, false)
	morganMenu.draw:addParam("drawR", "Draw R range", SCRIPT_PARAM_ONOFF, true)
	morganMenu.draw:addParam("drawRcount", "Draw # of enemies in R range", SCRIPT_PARAM_ONOFF, true)
	morganMenu.draw:addParam("drawAA", "Draw AA range", SCRIPT_PARAM_ONOFF, false)
	morganMenu.draw:addParam("drawKtext", "Draw Killable text", SCRIPT_PARAM_ONOFF, true)

	morganMenu:addSubMenu("Prediction", "pred")
	if VIP_USER then
		morganMenu.pred:addParam("selectPred", "Select Prediction", SCRIPT_PARAM_LIST, 1, {"Prodiction", "VPrediction"})
	else
		morganMenu.pred:addParam("info1", "Using free prediction", SCRIPT_PARAM_INFO, "")
	end

	morganMenu:addSubMenu("Extras", "extras")
	morganMenu.extras:addParam("useSkin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
	morganMenu.extras:addParam("chooseSkin", "Choose skin:", SCRIPT_PARAM_SLICE, 0, 0, 5, 0)

	morganMenu:addSubMenu("Script Info", "scriptInfo")
	morganMenu.scriptInfo:addParam("info3", "Author", SCRIPT_PARAM_INFO, "DaPipex")
	morganMenu.scriptInfo:addParam("info4", "Version", SCRIPT_PARAM_INFO, version)

	loadDone = true

end

function OnTick()

	if loadDone then
		Chequeos()
		KillSteal()
		CalculoDeDano()

		if GetGame().isOver then
			UpdateWeb(false, ScriptName, id, HWID)
			loadDone = false
		end


		if morganMenu.keys.combo then
			Combo()
		end
		if morganMenu.keys.harass then
			Harass()
		end
		if morganMenu.extras.useSkin then
			if CambioSkin() then
				GenModelPacket("Morgana", morganMenu.extras.chooseSkin)
				lastSkin = morganMenu.extras.chooseSkin
			end
		end
	end
end

function Chequeos()

	Qlista = (myHero:CanUseSpell(_Q) == READY)
	Wlista = (myHero:CanUseSpell(_W) == READY)
	Elista = (myHero:CanUseSpell(_E) == READY)
	Rlista = (myHero:CanUseSpell(_R) == READY)
	Ilista = (castigo ~= nil and myHero:CanUseSpell(castigo) == READY)

	Target = STSm:GetTarget(HechizoQ.rango)

end

function Combo()

	if Target == nil then return end

	if Qlista then
		if morganMenu.combo.useQ then
			CastQ(Target)
		end
	end

	if Wlista then
		if morganMenu.combo.useWsnared then
			if not Target.canMove and GetDistance(Target) <= HechizoW.rango then
				CastSpell(_W, Target)
			end
		end

		if morganMenu.combo.useWgroup then
			local AOEpos, MThitChance, nEnemies = VP:GetCircularAOECastPosition(Target, 0.5, 280, HechizoW.rango, math.huge, myHero)
			if MThitChance >= 1 and nEnemies >= morganMenu.combo.useWgroupMin then
				CastSpell(_W, AOEpos.x, AOEpos.y)
			end
		end
	end

	if Rlista then
		if morganMenu.combo.useR then
			if CountEnemyHeroInRange(HechizoR.rango) >= morganMenu.combo.useRmin then
				CastSpell(_R)
			end
		end
	end
end

function CastQ(Weon)

	if VIP_USER then
		if morganMenu.pred.selectPred == 1 then
			local prodPos, prodInfo = ProdQ.GetPrediction(Weon, HechizoQ.rango, HechizoQ.velocidad, HechizoQ.demora, HechizoQ.ancho, myHero)
			if prodPos and not prodInfo.collision() then
				CastSpell(_Q, prodPos.x, prodPos.z)
			end
		elseif morganMenu.pred.selectPred == 2 then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(Weon, HechizoQ.demora, HechizoQ.ancho, HechizoQ.rango, HechizoQ.velocidad, myHero, true)
			if CastPosition and HitChance >= 1 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	else
		local nextPosition, minionCollision, nextHealth = freePredQ:GetPrediction(Weon)
		if nextPosition and not minionCollision then
			CastSpell(_Q, nextPosition.x, nextPosition.z)
		end
	end
end

function Harass()

	if Target == nil then return end

	if Qlista then
		if morganMenu.harass.useQ then
			CastQ(Target)
		end
	end

	if Wlista then
		if morganMenu.harass.useW == 2 then
			if GetDistance(Target) <= HechizoW.rango then
				CastSpell(_W, Target)
			end
		elseif morganMenu.harass.useW == 3 then
			if (GetDistance(Target) <= HechizoW.rango) and not Target.canMove then
				CastSpell(_W, Target)
			end
		end
	end
end

function KillSteal()

	local wachos = GetEnemyHeroes()
	for i, enemy in pairs(wachos) do
		if morganMenu.ks.useQ then
			if ValidTarget(enemy, HechizoQ.rango) then
				if Qlista and not Wlista then
					if getDmg("Q", enemy, myHero) > enemy.health then
						CastQ(enemy)
					end
				end
			end
		end

		if morganMenu.ks.useW then
			if ValidTarget(enemy, HechizoW.rango) then
				if Wlista and not Qlista then
					if getDmg("W", enemy, myHero) > enemy.health then
						CastSpell(_W, enemy)
					end
				end
			end
		end

		if morganMenu.ks.useR then
			if ValidTarget(enemy, HechizoR.rango) then
				if Rlista and not Qlista then
					if getDmg("R", enemy, myHero) > enemy.health then
						CastSpell(_R, enemy)
					end
				end
			end
		end

		if morganMenu.ks.useIgnite then
			if ValidTarget(enemy, 600) then
				if Ilista then
					if getDmg("IGNITE", enemy, myHero) > enemy.health then
						CastSpell(castigo, enemy)
					end
				end
			end
		end
	end
end

--[[
function GapCloserMenu()

	if #AcercadoresJuego > 0 then
		for i, hechizoGC in pairs(AcercadoresJuego) do
			morganMenu.agc:addParam(hechizoGC, hechizoGC, SCRIPT_PARAM_ONOFF, false)
		end
	else
		morganMenu.agc:addParam("info2", "No supported spells found", SCRIPT_PARAM_INFO, "")
	end
end
--]]

function OnProcessSpell(unit, spell)

	if morganMenu.agc.useAGC then
		TargetDashing, CanHit, Position = VP:IsDashing(unit, HechizoQ.demora, HechizoQ.rango, HechizoQ.velocidad, myHero)
		if TargetDashing and CanHit then
			CastSpell(_Q, Position.x, Position.z)
		end
	end
end

function CalculoDeDano()

	for i=1, heroManager.iCount do
		local objetivo = heroManager:GetHero(i)
		if ValidTarget(objetivo, 3500) and objetivo ~= nil then
			qDMG = ((Wlista and getDmg("Q", objetivo, myHero)) or 0)
			wDMG = ((Elista and getDmg("W", objetivo, myHero)) or 0)
			rDMG = ((Rlista and getDmg("R", objetivo, myHero)) or 0)

			if (qDMG + wDMG + rDMG < objetivo.health) then
				TextosMatar[i] = 8
			elseif Wlista and (wDMG >= objetivo.health) then
				TextosMatar[i] = 7
			elseif Qlista and (qDMG >= objetivo.health) then
				TextosMatar[i] = 6
			elseif Rlista and (rDMG >= objetivo.health) then
				TextosMatar[i] = 5
			elseif Qlista and Wlista and (qDMG + wDMG >= objetivo.health) then
				TextosMatar[i] = 4
			elseif Wlista and Rlista and (wDMG + rDMG >= objetivo.health) then
				TextosMatar[i] = 3
			elseif Qlista and Rlista and (qDMG + rDMG >= objetivo.health) then
				TextosMatar[i] = 2
			elseif Qlista and Wlista and Rlista and (qDMG and wDMG and rDMG >= objetivo.health) then
				TextosMatar[i] = 1
			end
		end
	end
end

function OnDraw()

	if loadDone then
		if myHero.dead then return end

		if morganMenu.draw.drawQ then
			DrawCircle(myHero.x, myHero.y, myHero.z, HechizoQ.rango, colorRangos)
		end

		if morganMenu.draw.drawW then
			DrawCircle(myHero.x, myHero.y, myHero.z, HechizoW.rango, colorRangos)
		end

		if morganMenu.draw.drawE then
			DrawCircle(myHero.x, myHero.y, myHero.z, HechizoE.rango, colorRangos)
		end

		if morganMenu.draw.drawR then
			DrawCircle(myHero.x, myHero.y, myHero.z, HechizoR.rango, colorRangos)
		end

		if morganMenu.draw.drawRcount then
			local morgPos = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
			local PosX = morgPos.x
			local PosY = morgPos.y - 10
			DrawText(tostring(CountEnemyHeroInRange(HechizoR.rango)), 30, PosX, PosY, RGB(115, 225, 225))
		end

		if morganMenu.draw.drawAA then
			DrawCircle(myHero.x, myHero.y, myHero.z, SOWi:MyRange(), RGB(33, 147, 29))
		end

		if morganMenu.draw.drawKtext then
			for i=1, heroManager.iCount do
				local objetivo = heroManager:GetHero(i)
				if ValidTarget(objetivo, 3500) and objetivo ~= nil and TextosEsperar[i] == 1 then
					PrintFloatText(objetivo, 0, ListaTextos[TextosMatar[i]])
				end
				if ValidTarget(objetivo, 3500) then
					if TextosEsperar[i] == 1 then
						TextosEsperar[i] = 20
					else
						TextosEsperar[i] = TextosEsperar[i] - 1
					end
				end
			end
		end
	end
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
	return morganMenu.extras.chooseSkin ~= lastSkin
end
