-- 技能工具类
SkillHelper = {}

-- 囚禁actor，用于慑魂枪效果
function SkillHelper:imprisonActor (objid)
  ActorHelper:playBodyEffect(objid, MyConstant.BODY_EFFECT.LIGHT22)
  if (ActorHelper:isPlayer(objid)) then -- 玩家
    local player = PlayerHelper:getPlayer(objid)
    player:setImprisoned(true)
  else
    local actor = ActorHelper:getActor(objid)
    if (actor) then
      actor:setImprisoned(true)
    else
      MonsterHelper:imprisonMonster(objid)
    end
  end
end

-- 取消囚禁actor
function SkillHelper:cancelImprisonActor (objid)
  local canCancel
  if (ActorHelper:isPlayer(objid)) then -- 玩家
    local player = PlayerHelper:getPlayer(objid)
    canCancel = player:setImprisoned(false)
  else
    local actor = ActorHelper:getActor(objid)
    if (actor) then
      canCancel = actor:setImprisoned(false)
    else
      canCancel = MonsterHelper:cancelImprisonMonster(objid)
    end
  end
  if (canCancel) then
    ActorHelper:stopBodyEffectById(objid, MyConstant.BODY_EFFECT.LIGHT22)
  end
end

-- 封魔actor
function SkillHelper:sealActor (objid)
  ActorHelper:playBodyEffect(objid, MyConstant.BODY_EFFECT.LIGHT47)
  if (ActorHelper:isPlayer(objid)) then -- 玩家
    local player = PlayerHelper:getPlayer(objid)
    player:setSeal(true)
  else
    local actor = ActorHelper:getActor(objid)
    if (actor) then
      actor:setSealed(true)
    else
      MonsterHelper:sealMonster(objid)
    end
  end
end

-- 取消封魔actor
function SkillHelper:cancelSealActor (objid)
  local canCancel
  if (ActorHelper:isPlayer(objid)) then -- 玩家
    local player = PlayerHelper:getPlayer(objid)
    canCancel = player:setSeal(false)
  else
    local actor = ActorHelper:getActor(objid)
    if (actor) then
      canCancel = actor:setSealed(false)
    else
      canCancel = MonsterHelper:cancelSealMonster(objid)
    end
  end
  if (canCancel) then
    ActorHelper:stopBodyEffectById(objid, MyConstant.BODY_EFFECT.LIGHT47)
  end
end

-- 万剑诀 起势
function SkillHelper:tenThousandsSwordcraft (objid, size)
  size = size or 3
  local pos = ActorHelper:getDistancePosition(objid, 2)
  pos.y = pos.y + 1
  local dstPos = ActorHelper:getDistancePosition(objid, 6)
  local projectileid = WorldHelper:spawnProjectileByDirPos(objid, 
    MyConstant.WEAPON.TEN_THOUSAND_SWORD_ID, pos, MyVector3:new(0, 1, 0), 0)
  ActorHelper:setFacePitch(projectileid, -135)
  ActorHelper:setFaceYaw(projectileid, ActorHelper:getFaceYaw(objid) + 90)
  -- local projectileid = WorldHelper:spawnProjectileByPos(objid, 
  --   MyConstant.WEAPON.TEN_THOUSAND_SWORD_ID, pos, MyPosition:new(pos.x, pos.y + 1, pos.z), 0)
  local t = 'ten' .. projectileid
  MyTimeHelper:callFnContinueRuns(function ()
    local facePitch = ActorHelper:getFacePitch(projectileid)
    if (not(facePitch)) then
      MyTimeHelper:delFnContinueRuns(t)
    else
      -- LogHelper:debug(ActorHelper:getFacePitch(projectileid))
      if (facePitch >= 270) then
        ActorHelper:appendSpeed(projectileid, 0, 1, 0)
        MyTimeHelper:delFnContinueRuns(t)
        MyTimeHelper:callFnFastRuns(function ()
          WorldHelper:despawnActor(projectileid)
          SkillHelper:tenThousandsSwordcraft2(objid, dstPos, size)
        end, 1)
      else
        ActorHelper:turnFacePitch(projectileid, 45)
      end
      -- local pos = self:getDistancePosition(objid, 2)
      -- pos.y = pos.y + 1
      -- self:setPosition(projectileid, pos)
    end
  end, -1, t)
end

-- 万剑诀 落势
function SkillHelper:tenThousandsSwordcraft2 (objid, dstPos, size)
  local y = dstPos.y + 20
  local arr, projectiles = {}, {}
  for i = dstPos.x - size, dstPos.x + size do
    for ii = dstPos.z - size, dstPos.z + size do
      table.insert(arr, MyPosition:new(i, y, ii))
    end
  end
  SkillHelper:tenThousandsSwordcraft3(objid, arr, projectiles)
  local dim = MyPosition:new(5, 10, 5)
  MyTimeHelper:callFnContinueRuns(function ()
    for i, v in ipairs(projectiles) do
      if (v[1]) then
        local pos = ActorHelper:getMyPosition(v[2])
        if (pos) then
          -- local objids = ActorHelper:getAllCreaturesArroundPos(pos, dim)
          local objids = ActorHelper:getAllCreaturesArroundPos(pos, dim, objid)
          if (not(objids) or #objids == 0) then
            objids = ActorHelper:getAllPlayersArroundPos(pos, dim, objid)
          end
          if (objids and #objids > 0) then
            ActorHelper:appendSpeed(v[2], -v[3].x, -v[3].y, -v[3].z)
            local speedVector3 = ActorHelper:appendFixedSpeed(v[2], 1, pos, ActorHelper:getMyPosition(objids[1]))
            v[3] = speedVector3
            ItemHelper:recordMissileSpeed(v[2], speedVector3)
          end
        else
          v[1] = false
        end
      end
    end
  end, 5)
end

function SkillHelper:tenThousandsSwordcraft3 (objid, arr, projectiles)
  if (#arr > 0) then
    local index = math.random(1, #arr)
    local speedVector3 = MyVector3:new(0, -0.8, 0)
    local projectileid = WorldHelper:spawnProjectileByDirPos(objid, 
      MyConstant.WEAPON.TEN_THOUSAND_SWORD_ID, arr[index], speedVector3, 0)
    ActorHelper:appendSpeed(projectileid, speedVector3.x, speedVector3.y, speedVector3.z)
    table.insert(projectiles, { true, projectileid, speedVector3 })
    table.remove(arr, index)
    ItemHelper:recordProjectile(projectileid, objid, 
      ItemHelper:getItem(MyWeaponAttr.tenThousandsSword.levelIds[1]), {})
    ItemHelper:recordMissileSpeed(projectileid, speedVector3)
    MyTimeHelper:callFnFastRuns(function ()
      SkillHelper:tenThousandsSwordcraft3(objid, arr, projectiles)
    end, 0.1)
  end
end

-- 气甲术
function SkillHelper:airArmour (objid, size)
  size = size or 3
  local dim = { x = size + 1, y = size + 1, z = size + 1 }
  local teamid = ActorHelper:getTeam(objid)
  local bodyEffect = MyConstant.BODY_EFFECT.LIGHT64
  ActorHelper:playBodyEffect(objid, bodyEffect)
  -- local t = objid .. 'airArmour'
  MyTimeHelper:callFnContinueRuns(function ()
    local pos = ActorHelper:getMyPosition(objid)
    pos.y = pos.y + 1
    local missiles
    if (teamid == 0) then
      missiles = ActorHelper:getAllMissilesArroundPos(pos, dim)
    else
      missiles = ActorHelper:getAllMissilesArroundPos(pos, dim, objid, false)
    end
    if (missiles and #missiles > 0) then
      for i, v in ipairs(missiles) do
        local distance = MathHelper:getDistance(pos, v)
        if (distance < size) then
          local speedVector3 = ItemHelper:getMissileSpeed(v)
          if (speedVector3 and not(speedVector3:isZero())) then
            ActorHelper:appendSpeed(v, -speedVector3.x, -speedVector3.y, -speedVector3.z)
            ItemHelper:recordMissileSpeed(v, MyVector3:new(0, 0, 0))
          end
        end
      end
    end
  end, 10)
  MyTimeHelper:callFnFastRuns(function ()
    ActorHelper:stopBodyEffectById(objid, bodyEffect)
  end, 10)

  -- pos.x = pos.x + 2
  -- local projectileid = WorldHelper:spawnProjectileByDirPos(objid, 
  --     MyConstant.WEAPON.TEN_THOUSAND_SWORD_ID, pos, MyVector3:new(0, 1, 0), 0)
  -- local speedVector3 = MyVector3:new(-1, 0, 0)
  -- ActorHelper:appendSpeed(projectileid, speedVector3.x, speedVector3.y, speedVector3.z)
  -- ItemHelper:recordMissileSpeed(projectileid, speedVector3)
  -- MyTimeHelper:callFnFastRuns(function ()
  --   local sv3 = ItemHelper:getMissileSpeed(projectileid)
  --   ActorHelper:appendSpeed(projectileid, -sv3.x, -sv3.y, -sv3.z)
  -- end, 0.1)
end