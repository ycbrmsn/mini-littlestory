-- 剑

-- 御剑
ControlSword = MyWeapon:new(MyWeaponAttr.controlSword)

function ControlSword:useItem1 (objid)
  local player = PlayerHelper:getPlayer(objid)
  local state = player:getState()
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
  local player = PlayerHelper:getPlayer(objid)
  player:stopFly(true)
end

-- 万剑
TenThousandsSword = MyWeapon:new(MyWeaponAttr.tenThousandsSword)

function TenThousandsSword:useItem1 (objid)
  SkillHelper:tenThousandsSwordcraft(objid)
  ItemHelper:recordUseSkill(objid, self.id, self.cd)
end

-- 投掷物命中
function TenThousandsSword:projectileHit (projectileInfo, toobjid, blockid, pos)
  local objid = projectileInfo.objid
  local player = PlayerHelper:getPlayer(objid)
  if (toobjid > 0) then -- 命中生物（似乎命中同队生物不会进入这里）
    -- 判断是否是敌对生物
    if (not(ActorHelper:isTheSameTeamActor(objid, toobjid))) then -- 敌对生物，则造成伤害
      local key = PlayerHelper:generateDamageKey(objid, toobjid)
      local isHurt = MyTimeHelper:getFrameInfo(key)
      if (not(isHurt)) then -- 造成伤害事件没有发生
        player:damageActor(toobjid, self.hurt)
      end
    end
  end
end