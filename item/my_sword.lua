-- 剑

-- 御剑
ControlSword = MyWeapon:new(MyWeaponAttr.controlSword)

function ControlSword:useItem (objid)
  local player = MyPlayerHelper:getPlayer(objid)
  if (not(player:ableUseSkill('闪袭'))) then
    return false
  end
  local ableUseSkill = MyItemHelper:ableUseSkill(objid, self.id, self.cd)
  if (not(ableUseSkill)) then
    MyPlayerHelper:showToast(objid, '闪袭技能冷却中')
    return
  end
  local playerPos = player:getMyPosition()
  -- 循环以距离玩家正面1米递增的间隔点开始，作为中心点，扩大1格，查找生物
  local distanceTimes = self.distance + self.level * self.addDistancePerLevel
  local targetObjid
  for i = 1, distanceTimes do
    local pos = MathHelper:getDistancePosition(player:getMyPosition(), player:getFaceYaw(), i)
    local areaid = AreaHelper:createNineCubicArea(pos)
    local objids = MyActorHelper:getAllOtherTeamActorsInAreaId(objid, areaid)
    AreaHelper:destroyArea(areaid)
    if (#objids > 0) then
      MyItemHelper:recordUseSkill(objid, self.id, self.cd)
      local tempDistance
      for ii, vv in ipairs(objids) do
        local distance = MathHelper:getDistance(playerPos, MyActorHelper:getMyPosition(vv))
        if (not(tempDistance) or distance < tempDistance) then
          tempDistance = distance
          targetObjid = vv
        end
      end
      if (targetObjid) then -- 发现目标
        local itemid = MyConstant.WEAPON.COMMON_PROJECTILE_ID -- 通用投掷物id
        local targetPos = MyActorHelper:getMyPosition(targetObjid)
        local initPos = MyPosition:new(targetPos.x, targetPos.y + 0.2, targetPos.z)
        local dirVector3 = MyVector3:new(0, -1, 0)
        local projectileid = WorldHelper:spawnProjectileByDirPos(objid, itemid, initPos, dirVector3) -- 创建投掷物
        MyItemHelper:recordProjectile(projectileid, objid, self, { hurt = self.attack * (self.multiple + self.level * self.addMultiplePerLevel) - MyConstant.PROJECTILE_HURT, pos = playerPos }) -- 记录伤害
        break
      end
    end
  end
  if (not(targetObjid)) then
    ChatHelper:sendSystemMsg('闪袭技能有效范围内未发现目标', objid)
  end
end

-- 投掷物命中
function ControlSword:projectileHit (projectileInfo, toobjid, blockid, pos)
  local objid = projectileInfo.objid
  local item = projectileInfo.item
  local player = MyPlayerHelper:getPlayer(objid)
  local playerPos = projectileInfo.pos
  WorldHelper:playAndStopBodyEffectById(playerPos, MyConstant.BODY_EFFECT.SMOG1)
  if (toobjid > 0) then -- 命中生物（似乎命中同队生物不会进入这里）
    player:setDistancePosition(toobjid, -1)
    player:lookAt(toobjid)
    -- 击退效果
    MyActorHelper:appendSpeed(toobjid, 2, player:getMyPosition())
    -- 判断是否是敌对生物
    if (not(MyActorHelper:isTheSameTeamActor(objid, toobjid))) then -- 敌对生物，则造成伤害
      local hurt = projectileInfo.hurt
      -- 伤害
      player:damageActor(toobjid, hurt)
    end
  elseif (blockid > 0) then -- 命中方块
    player:setMyPosition(pos)
    ChatHelper:sendSystemMsg('闪袭技能放偏了', objid)
  end
end