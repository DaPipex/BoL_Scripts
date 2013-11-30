----------------- Champion Script: Soraka -----------------
----------------- Script Author  : DaPipex ---------------
----------------- 25-11-2013 19:53:26 ---------------------

if myHero.charName ~= "Soraka" then return end

local QRange = 675
local ERange = 725
local QUsable
local EUsable
local ts

function OnLoad()
SorakaLul = scriptConfig("Soraka KS Tools", "SorakaKSTools")
SorakaLul:addParam("Toplel", "Note: E has priority over Q", SCRIPT_PARAM_INFO)
SorakaLul:addParam("Eks", "Killsteal - E", SCRIPT_PARAM_ONOFF, false)
SorakaLul:addParam("Qks", "Killsteal - Q", SCRIPT_PARAM_ONOFF, false)
SorakaLul:addParam("DrawE", "Draw E Range", SCRIPT_PARAM_ONOFF, false)
SorakaLul:addParam("DrawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, false)
SorakaLul:permaShow("Eks")
SorakaLul:permaShow("Qks")

ts = TargetSelector(TARGET_LESS_CAST, ERange, DAMAGE_MAGIC)
ts.name = "Soraka"
SorakaLul:addTS(ts)

PrintChat(" >>Soraka the KS'er Loaded! ")



end

function OnDraw()
if SorakaLul.DrawE then
        DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0xFF0000)
   end

if SorakaLul.DrawQ then
        DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0x0000FF)
   end
end

function OnTick()
ts:update()
Target = ts.target

if SorakaLul.Eks then
     CastDatE()
end

if SorakaLul.Qks then
     CastDatQ()
end

end

function CastDatE()

if Target ~= nil then
     if myHero:CanUseSpell(_E) == READY and getDmg("E",Target,myHero) > Target.health then
          CastSpell(_E,Target)
     end
end
end

function CastDatQ()

if Target ~= nil then
     if myHero:CanUseSpell(_Q) == READY and not myHero:CanUseSpell(_E) == READY and getDmg("Q",Target,myHero) > Target.health then
          CastSpell(_Q,Target)
     end
end
end
