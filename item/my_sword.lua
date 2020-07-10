-- 剑

-- 御剑
ControlSword = MyWeapon:new(MyWeaponAttr.controlSword)

function ControlSword:useItem (objid)
  local player = MyPlayerHelper:getPlayer(objid)
  local state = player:getState()
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    ChatHelper:sendSystemMsg('御剑失控，短时间内无法再次御剑', objid)
    return
  end
  if (state == 0) then -- 可御剑，则御剑
    player:flyStatic()
  elseif (state == 1) then -- 御剑静止，则前行
    player:flyAdvance()
  elseif (state == 2) then -- 御剑前行，则静止
    player:flyStatic()
  end
end

-- 潜行
function ControlSword:useItem2 (objid)
  local player = MyPlayerHelper:getPlayer(objid)
  player:stopFly(true)
end