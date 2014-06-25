--[[Pos que tristanita ap mola
by DaPipex]]

local version = "0.08"

if myHero.charName ~= "Tristana" then return end

--Auto Update - Credits Honda7--

local DaPipexTristUpdate = true
local UPDATE_SCRIPT_NAME = "TristanitaMolaDEV"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/DaPipex/BoL_Scripts/master/TristanitaMolaDEV.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#FF0000\">"..UPDATE_SCRIPT_NAME..":</font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if DaPipexTristUpdate then
    local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH)
    if ServerData then
        local ServerVersion = string.match(ServerData, "local version = \"%d+.%d+\"")
        ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
        if ServerVersion then
            ServerVersion = tonumber(ServerVersion)
            if tonumber(version) < ServerVersion then
                AutoupdaterMsg("New version available"..ServerVersion)
                AutoupdaterMsg("Updating, please don't press F9")
                DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end)  
            else
                AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
            end
        end
    else
        AutoupdaterMsg("Error downloading version info")
    end
end

--End credits - Honda 7--

if VIP_USER then
    VPredActive = true
else
    VPredActive = false
end
require "VPrediction"
require "SOW"


function OnLoad()

    loadDone = false

    Variables()
    Menu()
    DelayAction(CargarPredicciones, 2)
    InterrumpirMenu()
    GapCloserMenu()

end

function Variables()

    rangoW, rangoE, rangoR = 900, 600, 600
    Qlista, Wlista, Elista, Rlista = false, false, false, false
    anchoW, velocidadW, demoraW = 270, 20, .5
    VP = nil
    freePredW = nil
    castigo = nil
    ts = nil
    SOWi = nil
    currentHealth = ((myHero.health * 100) / myHero.maxHealth)
    tablaWenemigos = {"Always Use", "1 or more", "2 or more", "3 or more", "4 or more"}

    EspadaDelChoro, CurvedPenis, GarraIgnea = nil, nil, nil
    BOTRKlisto, BClisto, DFGlisto = nil, nil, nil
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
    TextosMatar = {}
    ListaTextos = { "W+E+R", "E+R", "W+R", "W+E", "R", "E", "W", "Items", "Harass" }
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
        for j, campeon in pairs(InterrumpirCompleto) do
            if enemigo.charName == campeon.nombre then
                table.insert(InterrumpirJuego, campeon.hechizo)
            end
        end
        for h, gapcloserunit in pairs(Acercadores) do
            if enemigo.charName == gapcloserunit.nombre then
                table.insert(AcercadoresJuego, gapcloserunit.hechizo)
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

function CargarPredicciones()

    if VPredActive == true then
        PrintChat("<font color='#FF9A00'>Pos que Tristanita Mola: "..version.." VPrediction version Loaded!</font>")
    else
        freePredW = TargetPrediction(rangoW, velocidadW, demoraW, anchoW)
        PrintChat("<font color='#FF9A00'>Pos que Tristanita Mola: "..version.." Free prediction version Loaded!</font>")
    end

    VP = VPrediction()
    SOWi = SOW(VP)
    SOWi:LoadToMenu(TristyMenu.orbw)

    loadDone = true

end


function Menu()

    TristyMenu = scriptConfig("Tristanita Mola by DaPipex", "tristymola")

    TristyMenu:addSubMenu("Orbwalking", "orbw")

    TristyMenu:addSubMenu("SBTW", "combo")
    TristyMenu.combo:addParam("useQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.combo:addParam("rangeToQ", "Range to use Q", SCRIPT_PARAM_SLICE, 350, 350, 700, 0)
    TristyMenu.combo:addParam("useW", "Use W in combo", SCRIPT_PARAM_ONOFF, false)
    
    TristyMenu.combo:addSubMenu("W Options", "wSettings")
    TristyMenu.combo.wSettings:addParam("maxWenemies", "Don't use W if # enemies around", SCRIPT_PARAM_LIST, 1, tablaWenemigos)
    TristyMenu.combo.wSettings:addParam("sliderWrange", "Range to check around Target", SCRIPT_PARAM_SLICE, 800, 300, 1000, 0)
    TristyMenu.combo.wSettings:addParam("drawWrangeTarget", "Draw this range?", SCRIPT_PARAM_ONOFF, false)

    TristyMenu.combo:addParam("useE", "Use E...", SCRIPT_PARAM_LIST, 2, { "Never", "ASAP" })
    TristyMenu.combo:addParam("useR", "Use R in combo", SCRIPT_PARAM_ONOFF, false)

    TristyMenu:addSubMenu("Interrupt", "inter")
    TristyMenu.inter:addParam("interG", "Interrupt?", SCRIPT_PARAM_ONOFF, true)

    TristyMenu:addSubMenu("Anti Gap Closer", "agc")
    TristyMenu.agc:addParam("minHPagc", "Min HP % to push enemies away", SCRIPT_PARAM_SLICE, 40, 1, 100, 0)
    TristyMenu.agc:addParam("info4", "Current % health", SCRIPT_PARAM_INFO, "%")

    TristyMenu:addSubMenu("Items", "items")
    TristyMenu.items:addParam("itemsG", "Want to use items in combo?", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.items:addParam("useBOTRK", "Use Ruined king", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.items:addParam("useBC", "Use Bilgewater Cutlass", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.items:addParam("useDFG", "Use DeathFire Grasp", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.items:addParam("useBFT", "Use Black Fire Torch", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.items:addParam("rangeToDFG", "Range to use DFG or BFT", SCRIPT_PARAM_SLICE, 500, 100, 750, 0)

    TristyMenu:addSubMenu("KS", "killsteal")
    TristyMenu.killsteal:addParam("ksW", "Killsteal with W", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.killsteal:addParam("ksR", "Killsteal with R", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.killsteal:addParam("ksIgnite", "Killsteal with Ignite", SCRIPT_PARAM_ONOFF, true)

    TristyMenu:addSubMenu("Keys", "keys")
    TristyMenu.keys:addParam("ComboKey", "SBTW Key (Space)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    TristyMenu.keys:addParam("HarassKey", "Harass with E (C)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
    TristyMenu.keys:addParam("info1", "Request more keys!", SCRIPT_PARAM_INFO, "")

    TristyMenu:addSubMenu("Drawing", "draw")
    TristyMenu.draw:addParam("drawQrange", "Draw Range to use Q", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.draw:addParam("drawWrange", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.draw:addParam("drawWslowRange", "Draw W slow range", SCRIPT_PARAM_ONOFF, false)
    TristyMenu.draw:addParam("drawErange", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.draw:addParam("drawRrange", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.draw:addParam("drawAArange", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.draw:addParam("drawDFGrange", "Draw DFG Range", SCRIPT_PARAM_ONOFF, false)
    TristyMenu.draw:addParam("drawKtext", "Draw Kill text", SCRIPT_PARAM_ONOFF, true)

    ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, rangoW)
    ts.name = "Tristanita"
    TristyMenu:addTS(ts)

end


function OnTick()

    if loadDone then
        Chequeos()
        ActualizarRangos()
        Killsteal()
        CalculoDeDano()
        if TristyMenu.keys.ComboKey then
            Combo()
            UsarObjetos()
        end
        if TristyMenu.keys.HarassKey then
            Harass()
        end
        SOWi:ForceTarget(Target)
    end
end

function OnDraw()

    if loadDone then
        if myHero.dead then return end

        if TristyMenu.draw.drawAArange then
            DrawCircle(myHero.x, myHero.y, myHero.z, SOWi:MyRange(), ARGB(255, 124, 255, 203))
        end

        if TristyMenu.draw.drawQrange then
            DrawCircle(myHero.x, myHero.y, myHero.z, TristyMenu.combo.rangeToQ, ARGB(255, 255, 0, 0))
        end

        if TristyMenu.draw.drawWrange then
            DrawCircle(myHero.x, myHero.y, myHero.z, rangoW, ARGB(255, 0, 255, 0))
        end

        if TristyMenu.combo.wSettings.drawWrangeTarget and Target ~= nil then
            local barPos = WorldToScreen(D3DXVECTOR3(Target.x, Target.y, Target.z)) --(Credit to Zikkah)
            local PosX = barPos.x - 35
            local PosY = barPos.y - 10
            DrawCircle(Target.x, Target.y, Target.z, TristyMenu.combo.wSettings.sliderWrange, ARGB(255, 255, 0, 255))
            DrawText(CountEnemyHeroInRangeOfHero(TristyMenu.combo.wSettings.sliderWrange, Target), 16, PosX, PosY, ARGB(255, 255, 204, 0)
        end

        if TristyMenu.draw.drawWslowRange and Wlista then
            local TristVector = Vector(myHero.x, myHero.z)
            local RatonVector = Vector(mousePos.x, mousePos.z)
            local wDrawOffset = 50
            if GetDistance(TristVector, RatonVector) < rangoW - wDrawOffset then
                DrawCircle(mousePos.x, mousePos.y, mousePos.z, anchoW, RGB(190, 155, 151))
            else
                local BordeDraw = TristVector+(RatonVector-TristVector):normalized() * (rangoW - wDrawOffset)
                DrawCircle(BordeDraw.x, myHero.y, BordeDraw.y, anchoW, RGB(190, 155, 151))
            end
        end


        if TristyMenu.draw.drawErange then
            DrawCircle(myHero.x, myHero.y, myHero.z, rangoE, ARGB(255, 0, 0, 255))
        end

        if TristyMenu.draw.drawRrange then
            DrawCircle(myHero.x, myHero.y, myHero.z, rangoR, ARGB(255, 255, 255, 255))
        end

        if TristyMenu.draw.drawDFGrange then
            DrawCircle(myHero.x, myHero.y, myHero.z, TristyMenu.items.rangeToDFG, ARGB(255, 255, 255, 0))
        end

        if TristyMenu.draw.drawKtext then
            for i=1, heroManager.iCount do
                local objetivo = heroManager:GetHero(i)
                if ValidTarget(objetivo, 3500) and objetivo ~= nil and TextosEsperar[i] == 1 then
                    PrintFloatText(objetivo, 0, ListaTextos[TextosMatar[i]])
                end
                if ValidTarget(objetivo, 2000) then
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

function Chequeos()

    TristyMenu.agc.info4 = (math.floor((myHero.health * 100) / myHero.maxHealth).."%")

    Qlista = (myHero:CanUseSpell(_Q) == READY)
    Wlista = (myHero:CanUseSpell(_W) == READY)
    Elista = (myHero:CanUseSpell(_E) == READY)
    Rlista = (myHero:CanUseSpell(_R) == READY)
    Ilista = (castigo ~= nil and myHero:CanUseSpell(castigo) == READY)

    EspadaDelChoro = GetInventorySlotItem(3153)
    CurvedPenis = GetInventorySlotItem(3144)
    GarraIgnea = GetInventorySlotItem(3128)
    AntorchaNegra = GetInventorySlotItem(3188)

    BOTRKlisto = (EspadaDelChoro ~= nil and myHero:CanUseSpell(EspadaDelChoro) == READY)
    BClisto = (CurvedPenis ~= nil and myHero:CanUseSpell(CurvedPenis) == READY)
    DFGlisto = (GarraIgnea ~= nil and myHero:CanUseSpell(GarraIgnea) == READY)
    BFTlisto = (AntorchaNegra ~= nil and myHero:CanUseSpell(AntorchaNegra) == READY)

    ts:update()
    Target = ts.target

end

function Combo()

    if Target == nil then return end

    if TristyMenu.combo.useQ then
        if Qlista and (GetDistance(Target) < TristyMenu.combo.rangeToQ) then
            CastSpell(_Q)
        end
    end

    if TristyMenu.combo.useW then
        if Wlista and (GetDistance(Target) < rangoW) then
            CastSpecialW()
        end
    end

    if TristyMenu.combo.useE == 2 then
        if Elista and (GetDistance(Target) < rangoE) then
            CastSpell(_E, Target)
        end
    end

    if TristyMenu.combo.useR then
        if Rlista and (GetDistance(Target) < rangoR) then
            CastSpell(_R, Target)
        end
    end
end

function Harass()

    if Target ~= nil then
        if (GetDistance(Target) < rangoE) then
            CastSpell(_E, Target)
        end
    end
end

function ActualizarRangos()

    rangoE = 600 + 9 * (myHero.level - 1)
    rangoR = 600 + 9 * (myHero.level - 1)

end

function CastSpecialW()

    local wachosAlrededor = CountEnemyHeroInRangeOfHero(TristyMenu.combo.wSettings.sliderWrange, Target)

    if VPredActive then
        local CastPosition, HitChance, Position = VP:GetCircularCastPosition(Target, demoraW, anchoW, rangoW, velocidadW, myHero, false)
        if HitChance >= 1 and (GetDistance(CastPosition) < rangoW) and (wachosAlrededor < (TristyMenu.combo.wSettings.maxWenemies - 1)) then
            CastSpell(_W, CastPosition.x, CastPosition.z)
        end
    else
        local Position = freePredW:GetPrediction(Target)
        if GetDistance(Position) < rangoW and (wachosAlrededor < (TristyMenu.combo.wSettings.maxWenemies - 1)) then
            CastSpell(_W, Position.x, Position.z)
        end
    end
end

function Killsteal()

    local wachos = GetEnemyHeroes()
    for i, enemy in pairs(wachos) do
        if TristyMenu.killsteal.ksW then
            if ValidTarget(enemy, rangoW) then
                if Wlista and not Rlista then
                    if getDmg("W", enemy, myHero) > enemy.health then
                        CastKSw(enemy)
                    end
                end
            end
        end
        if TristyMenu.killsteal.ksR then
            if ValidTarget(enemy, rangoR) then
                if Rlista then
                    if getDmg("R", enemy, myHero) > enemy.health then
                        CastSpell(_R, enemy)
                    end
                end
            end
        end
        if TristyMenu.killsteal.ksIgnite then
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

function CastKSw(target)

    if target ~= nil then
        if VPredActive then
            local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, demoraW, anchoW, rangoW, velocidadW, myHero, false)
            if HitChance >= 1 and (GetDistance(CastPosition) < rangoW) then
                CastSpell(_W, CastPosition.x, CastPosition.z)
            end
        else
            local Position = freePredW:GetPrediction(target)
            if GetDistance(Position) < rangoW then
                CastSpell(_W, Position.x, Position.z)
            end
        end
    end
end

function UsarObjetos()

    if (TristyMenu.items.itemsG == false) or (Target == nil) then return end

    if TristyMenu.items.useBOTRK and (GetDistance(Target) < 450) then
        if BOTRKlisto then
            CastSpell(EspadaDelChoro, Target)
        end
    end

    if TristyMenu.items.useBC and (GetDistance(Target) < 450) then
        if BClisto then
            CastSpell(CurvedPenis, Target)
        end
    end

    if TristyMenu.items.useDFG and (GetDistance(Target) < TristyMenu.items.rangeToDFG) then
        if DFGlisto then
            CastSpell(GarraIgnea, Target)
        end
    end

    if TristyMenu.items.useBFT and (GetDistance(Target) < TristyMenu.items.rangeToDFG) then
        if BFTlisto then
            CastSpell(AntorchaNegra, Target)
        end
    end
end

function InterrumpirMenu()
    if #InterrumpirJuego > 0 then
        for i, hechizoInter in pairs(InterrumpirJuego) do
            TristyMenu.inter:addParam(hechizoInter, hechizoInter, SCRIPT_PARAM_ONOFF, true)
        end
    else
        TristyMenu.inter:addParam("info2", "No supported spells found", SCRIPT_PARAM_INFO, "")
    end
end

function OnProcessSpell(unit, spell)

    if #InterrumpirJuego > 0 and TristyMenu.inter.interG and Rlista then
        for i, habilidad in pairs(InterrumpirJuego) do
            if spell.name == habilidad and (unit.team ~= myHero.team) and TristyMenu.inter[habilidad] then
                if GetDistance(unit) < rangoR then
                    CastSpell(_R, unit)
                end
            end
        end
    end

    if #AcercadoresJuego > 0 and Rlista then
        for i, habilidadGC in pairs(AcercadoresJuego) do
            if spell.name == habilidadGC and (unit.team ~= myHero.team) and TristyMenu.agc[habilidadGC] then
                if GetDistance(spell.endPos) <= 275 and (myHero.health <= ((TristyMenu.agc.minHPagc / 100) * myHero.maxHealth)) then
                CastSpell(_R, unit)
            end 
        end
    end
end
end

function CalculoDeDano()

    for i=1, heroManager.iCount do
        local objetivo = heroManager:GetHero(i)
        if ValidTarget(objetivo, 3500) and objetivo ~= nil then
            dfgDMG, bcDMG, botrkDMG = 0, 0, 0
            wDMG = ((Wlista and getDmg("W", objetivo, myHero)) or 0)
            eDMG = ((Elista and getDmg("E", objetivo, myHero, 3)) or 0)
            rDMG = ((Rlista and getDmg("R", objetivo, myHero)) or 0)
            dfgDMG = ((DFGlisto and getDmg("DFG", objetivo, myHero)) or 0)
            bcDMG = ((BClisto and getDmg("BWC", objetivo, myHero)) or 0)
            botrkDMG = ((BOTRKlisto and getDmg("RUINEDKING", objetivo, myHero)) or 0)
            bftDMG = ((BFTlisto and getDmg("BLACKFIRE", objetivo, myHero)) or 0)
            iDMG = ((Ilista and getDmg("IGNITE", objetivo, myHero)) or 0)
            itemsDMG = dfgDMG + bcDMG + botrkDMG + bftDMG

            if (wDMG + eDMG + rDMG < objetivo.health) then
                TextosMatar[i] = 9
            elseif itemsDMG >= objetivo.health then
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

function GapCloserMenu()

    if #AcercadoresJuego > 0 then
        for i, hechizoGC in pairs(AcercadoresJuego) do
            TristyMenu.agc:addParam(hechizoGC, hechizoGC, SCRIPT_PARAM_ONOFF, false)
        end
    else
        TristyMenu.agc:addParam("info3", "No supported spells found", SCRIPT_PARAM_INFO, "")
    end
end

function CountEnemyHeroInRangeOfHero(range, hero)
    range = range and range*range
    local WachosInRange = 0
    for i = 1, heroManager.iCount do
        local wachoCount = heroManager:getHero(i)
        if ValidTarget(hero) and GetDistanceSqr(hero, wachoCount) <= range then
            WachosInRange = WachosInRange + 1
            if wachoCount.networkID == hero.networkID then
                WachosInRange = WachosInRange - 1
            end
        end
    end
    return WachosInRange
end
