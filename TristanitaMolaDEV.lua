--[[Pos que tristanita ap mola
by DaPipex]]

local version = 0.02

if myHero.charName ~= "Tristana" then return end
if VIP_USER then
    VPredActive = true
else
    VPredActive = false
end
require "VPrediction"
require "SOW"


function OnLoad()

    Variables()
    Menu()
    DelayAction(CargarPredicciones, 3)

end

function Variables()

    rangoW, rangoE, rangoR = 900, 650, 700
    Qlista, Wlista, Elista, Rlista = false, false, false, false
    anchoW, velocidadW, demoraW = 270, 20, .5
    VP = nil
    freePredW = nil
    castigo = nil
    ts = nil
    SOWi = nil

    if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then
        castigo = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then
        castigo = SUMMONER_2
    end

end

function CargarPredicciones()

    if VPredActive == true then
        VP = VPrediction()
        PrintChat("Pos que Tristanita Mola: "..version.." VPrediction version Loaded!")
    else
        freePredW = TargetPrediction(rangoW, velocidadW, demoraW, anchoW)
        PrintChat("Pos que Tristanita Mola: "..version.." Free prediction version Loaded!")
    end

    SOWi = SOW(VP)
    SOWi:LoadToMenu(TristyMenu.orbw)

end


function Menu()

    TristyMenu = scriptConfig("Tristanita Mola by DaPipex", "tristymola")

    TristyMenu:addSubMenu("Orbwalking", "orbw")

    TristyMenu:addSubMenu("SBTW", "combo")
    TristyMenu.combo:addParam("useQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.combo:addParam("rangeToQ", "Range to use Q", SCRIPT_PARAM_SLICE, 350, 350, 700, 0)
    TristyMenu.combo:addParam("useW", "Use W in combo", SCRIPT_PARAM_ONOFF, false)
    TristyMenu.combo:addParam("useE", "Use E...", SCRIPT_PARAM_LIST, 2, { "Never", "ASAP" })
    TristyMenu.combo:addParam("useR", "Use R in combo", SCRIPT_PARAM_ONOFF, false)

    TristyMenu:addSubMenu("Items", "items")
    TristyMenu.items:addParam("itemsG", "Want to use items in combo?", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.items:addParam("useBOTRK", "Use Ruined king", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.items:addParam("useBC", "Use Bilgewater Cutlass", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.items:addParam("useDFG", "Use DeathFire Grasp", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.items:addParam("rangeToDFG", "Range to use DFG", SCRIPT_PARAM_SLICE, 500, 100, 750, 0)

    TristyMenu:addSubMenu("KS", "killsteal")
    TristyMenu.killsteal:addParam("ksW", "Killsteal with W", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.killsteal:addParam("ksR", "Killsteal with R", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.killsteal:addParam("ksIgnite", "Killsteal with Ignite", SCRIPT_PARAM_ONOFF, true)

    TristyMenu:addSubMenu("Keys", "keys")
    TristyMenu.keys:addParam("ComboKey", "SBTW Key (Space)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    TristyMenu.keys:addParam("info1", "Request more keys!", SCRIPT_PARAM_INFO, "")

    TristyMenu:addSubMenu("Drawing", "draw")
    TristyMenu.draw:addParam("drawQrange", "Draw Range to use Q", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.draw:addParam("drawWrange", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.draw:addParam("drawErange", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.draw:addParam("drawRrange", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.draw:addParam("drawAArange", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.draw:addParam("drawDFGrange", "Draw DFG Range", SCRIPT_PARAM_ONOFF, false)

    ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, rangoW)
    ts.name = "Tristanita"
    TristyMenu:addTS(ts)

end


function OnTick()

    Chequeos()
    ActualizarRangos()
    Killsteal()
    if TristyMenu.keys.ComboKey then
        Combo()
        UsarObjetos()
    end

end

function OnDraw()

    if myHero.dead then return end

    if TristyMenu.draw.drawAArange then
        SOWi:DrawAARange()
    end

    if TristyMenu.draw.drawQrange then
        DrawCircle(myHero.x, myHero.y, myHero.z, TristyMenu.combo.rangeToQ, ARGB(255, 255, 0, 0))
    end

    if TristyMenu.draw.drawWrange then
        DrawCircle(myHero.x, myHero.y, myHero.z, rangoW, ARGB(255, 0, 255, 0))
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
end

function Chequeos()

    Qlista = (myHero:CanUseSpell(_Q) == READY)
    Wlista = (myHero:CanUseSpell(_W) == READY)
    Elista = (myHero:CanUseSpell(_E) == READY)
    Rlista = (myHero:CanUseSpell(_R) == READY)
    Ilista = (castigo ~= nil and myHero:CanUseSpell(castigo) == READY)

    EspadaDelChoro = GetInventorySlotItem(3153)
    BOTRKlisto = (EspadaDelChoro ~= nil and myHero:CanUseSpell(EspadaDelChoro) == READY)

    CurvedPenis = GetInventorySlotItem(3144)
    BClisto = (CurvedPenis ~= nil and myHero:CanUseSpell(CurvedPenis) == READY)

    GarraIgnea = GetInventorySlotItem(3128)
    DFGlisto = (CurvedPenis ~= nil and myHero:CanUseSpell(GarraIgnea) == READY)

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

function ActualizarRangos()

    rangoE = 650 + 9 * (myHero.level - 1)

end

function CastSpecialW()

    if VPredActive then
        local CastPosition, HitChance, Position = VP:GetCircularCastPosition(Target, demoraW, anchoW, rangoW, velocidadW, myHero, false)
        if HitChance >= 1 and (GetDistance(CastPosition) < rangoW) then
            CastSpell(_W, CastPosition.x, CastPosition.z)
        end
    else
        local Position = freePredW:GetPrediction(Target)
        if GetDistance(Position) < rangoW then
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
            CastItem(3153, Target)
        end
    end

    if TristyMenu.items.useBC and (GetDistance(Target) < 450) then
        if BClisto then
            CastItem(3144, Target)
        end
    end

    if TristyMenu.items.useDFG and (GetDistance(Target) < TristyMenu.items.rangeToDFG) then
        if DFGlisto then
            CastItem(3128, Target)
        end
    end
end
