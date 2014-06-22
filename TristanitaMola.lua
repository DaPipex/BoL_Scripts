--[[Pos que tristanita ap mola
by DaPipex]]

local version = 0.04

if myHero.charName ~= "Tristana" then return end
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
    EspadaDelChoro, CurvedPenis, GarraIgnea = nil, nil, nil
    BOTRKlisto, BClisto, DFGlisto = nil, nil, nil
    TextosMatar = {}
    ListaTextos = { "Harass", "W", "E", "R", "W+E", "W+R", "E+R", "Ignite", "On cooldown" }
    InterrumpirJuego = {}
    InterrumpirCompleto = {
        { nombre = "Caitlyn", hechizo = "CaitlynAceintheHole"},
        { nombre = "FiddleSticks", hechizo = "Crowstorm"},
        { nombre = "FiddleSticks", hechizo = "DrainChannel"},
        { nombre = "Galio", hechizo = "GalioIdolOfDurand"},
        { nombre = "Karthus", hechizo = "FallenOne"},
        { nombre = "Katarina", hechizo = "KatarinaR"},
        { nombre = "Lucian", hechizo = "LucianR"},
        { nombre = "Malzahar", hechizo = "AlZaharNetherGrasp"},
        { nombre = "MissFortune", hechizo = "MissFortuneBulletTime"},
        { nombre = "Nunu", hechizo = "AbsoluteZero"},
        { nombre = "Pantheon", hechizo = "Pantheon_GrandSkyfall_Jump"},
        { nombre = "Shen", hechizo = "ShenStandUnited"},
        { nombre = "Urgot", hechizo = "UrgotSwap2"},
        { nombre = "Varus", hechizo = "VarusQ"},
        { nombre = "Velkoz", hechizo = "VelkozR"},
        { nombre = "Warwick", hechizo = "InfiniteDuress"}
    }

    local EquipoEnemigo = GetEnemyHeroes()
    for i, enemigo in pairs(EquipoEnemigo) do
        for j, campeon in pairs(InterrumpirCompleto) do
            if enemigo.charName == campeon.nombre then
                table.insert(InterrumpirJuego, campeon.hechizo)
            end
        end
    end


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

    loadDone = true

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

    TristyMenu:addSubMenu("Interrupt", "inter")
    TristyMenu.inter:addParam("interG", "Interrupt?", SCRIPT_PARAM_ONOFF, true)

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
    TristyMenu.keys:addParam("HarassKey", "Harass with E (C)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
    TristyMenu.keys:addParam("info1", "Request more keys!", SCRIPT_PARAM_INFO, "")

    TristyMenu:addSubMenu("Drawing", "draw")
    TristyMenu.draw:addParam("drawQrange", "Draw Range to use Q", SCRIPT_PARAM_ONOFF, true)
    TristyMenu.draw:addParam("drawWrange", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
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
    end
end

function OnDraw()

    if loadDone then
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

        if TristyMenu.draw.drawKtext then
            for i=1, heroManager.iCount do
                local objetivo = heroManager:GetHero(i)
                if ValidTarget(objetivo, 900) and objetivo ~= nil then
                    PrintFloatText(objetivo, 0, ListaTextos[TextosMatar[i]])
                end
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

    EspadaDelChoro = GetInventorySlotItem(3153)
    CurvedPenis = GetInventorySlotItem(3144)
    GarraIgnea = GetInventorySlotItem(3128)

    BOTRKlisto = (EspadaDelChoro ~= nil and myHero:CanUseSpell(EspadaDelChoro) == READY)
    BClisto = (CurvedPenis ~= nil and myHero:CanUseSpell(CurvedPenis) == READY)
    DFGlisto = (GarraIgnea ~= nil and myHero:CanUseSpell(GarraIgnea) == READY)

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
end

function CalculoDeDano()

    for i=1, heroManager.iCount do
        local objetivo = heroManager:GetHero(i)
        if ValidTarget(objetivo, 900) and objetivo ~= nil then
            dfgDMG, bcDMG, botrkDMG = 0, 0, 0
            wDMG = ((Wlista and getDmg("W", objetivo, myHero)) or 0)
            eDMG = ((Elista and getDmg("E", objetivo, myHero, 3)) or 0)
            rDMG = ((Rlista and getDmg("R", objetivo, myHero)) or 0)
            dfgDMG = ((DFGlisto and getDmg("DFG", objetivo, myHero)) or 0)
            bcDMG = ((BClisto and getDmg("BWC", objetivo, myHero)) or 0)
            botrkDMG = ((BOTRKlisto and getDmg("RUINEDKING", objetivo, myHero)) or 0)
            iDMG = ((Ilista and getDmg("IGNITE", objetivo, myHero)) or 0)
            itemsDMG = dfgDMG + bcDMG + botrkDMG

            if objetivo.health > (wDMG + eDMG + rDMG + itemsDMG) and itemsDMG ~= 0 then
                TextosMatar[i] = 1
            elseif objetivo.health < wDMG then
                if Wlista then
                    TextosMatar[i] = 2
                else
                    TextosMatar[i] = 9
                end
            elseif objetivo.health < (wDMG + eDMG) then
                if (Wlista and Elista) then
                    TextosMatar[i] = 5
                else
                    TextosMatar[i] = 9
                end
            elseif objetivo.health < (wDMG + rDMG) then
                if (Wlista and Rlista) then
                    TextosMatar[i] = 6
                else
                    TextosMatar[i] = 9
                end
            elseif objetivo.health < eDMG then
                if Elista then
                    TextosMatar[i] = 3
                else
                    TextosMatar[i] = 9
                end
            elseif objetivo.health < rDMG then
                if Rlista then
                    TextosMatar[i] = 4
                else
                    TextosMatar[i] = 9
                end
            elseif objetivo.health < (eDMG + rDMG) then
                if (Elista and Rlista) then
                    TextosMatar[i] = 7
                else
                    TextosMatar[i] = 9
                end
            elseif objetivo.health < iDMG then
                if Ilista then
                    TextosMatar[i] = 8
                else
                    TextosMatar[i] = 9
                end
            end
        end
    end
end
