-- 我的区域工具类
MyAreaHelper = {
  playerInHomePos = { x = 31, y = 9, z = 3 },
  wolfAreas = {},
  maxRandomTimes = 10,
  showToastAreas = {} -- { areaid1 = { areaid2, name }, ... }
}

function MyAreaHelper:removeToArea (myActor)
  if (myActor and myActor.wants) then
    local want = myActor.wants[1]
    if (want.toAreaId) then
      AreaHelper:destroyArea(want.toAreaId)
      want.toAreaId = nil
    end
  end
end

function MyAreaHelper:isAirArea (pos)
  return BlockHelper:isAirBlock(pos.x, pos.y, pos.z) and BlockHelper:isAirBlock(pos.x, pos.y + 1, pos.z)
end

function MyAreaHelper:getRandomAirPositionInArea (areaid)
  local pos = AreaHelper:getRandomPos(areaid)
  local times = 1
  while (not(self:isAirArea(pos)) and times < self.maxRandomTimes) do
    pos = AreaHelper:getRandomPos(areaid)
    times = times + 1
  end
  return pos
end

function MyAreaHelper:initAreas ()
  self.playerInHomeAreaId = AreaHelper:getAreaByPos(self.playerInHomePos)
  self:initShowToastAreas()
end

function MyAreaHelper:initShowToastAreas ()
  local arr = { wolf, qiangdaoLouluo, ox }
  for i, v in ipairs(arr) do
    if (v.generate) then -- 如果需要生成怪物
      self.showToastAreas[v.areaids[2]] = { v.areaids[1], v.areaName, v.generate }
    else
      self.showToastAreas[v.areaids[2]] = { v.areaids[1], v.areaName }
    end
  end
  for i, v in ipairs(guard.initAreas) do
    if (i >= 5) then
      break
    end
    self.showToastAreas[guard.initAreas2[i]] = { v.areaid, '风颖城' }
  end
end

function MyAreaHelper:showToastArea (objid, areaid)
  local player = MyPlayerHelper:getPlayer(objid)
  for k, v in pairs(self.showToastAreas) do
    if (k == areaid) then
      if (v[1] == -1 or (player.prevAreaId and player.prevAreaId == v[1])) then
        MyPlayerHelper:showToast(objid, v[2])
        if (#v == 3) then -- 生成怪物
          v[3]()
        end
      end
      player.prevAreaId = areaid
      return true
    elseif (v[1] == areaid) then
      player.prevAreaId = areaid
      return true
    end
  end
  return false
end

function MyAreaHelper:playerEnterArea (objid, areaid)
  MyStoryHelper:playerEnterArea(objid, areaid)
  local myPlayer = MyPlayerHelper:getPlayer(objid)
  if (areaid == myPlayer.toAreaId) then -- 玩家自动前往地点
    AreaHelper:destroyArea(areaid)
    -- myPlayer.action:runAction()
    myPlayer.action:doNext()
  elseif (self:showToastArea(objid, areaid)) then -- 显示提示区域检测
  elseif (guard and guard:checkTokenArea(objid, areaid)) then -- 检查通行令牌
  end
end

function MyAreaHelper:playerLeaveArea (objid, areaid)
  MyStoryHelper:playerLeaveArea(objid, areaid)
end

function MyAreaHelper:creatureEnterArea (objid)
  
end

-- 位置附近的所有玩家
function MyAreaHelper:getAllPlayersArroundPos (pos, dim, objid, isTheSame)
  local posBeg, posEnd = MathHelper:getRectRange(pos, dim)
  local objids = AreaHelper:getAllPlayersInAreaRange(posBeg, posEnd)
  return self:getTeamObjs(objids, objid, isTheSame, true)
end

-- 位置附近的所有生物
function MyAreaHelper:getAllCreaturesArroundPos (pos, dim, objid, isTheSame)
  local posBeg, posEnd = MathHelper:getRectRange(pos, dim)
  local objids = AreaHelper:getAllCreaturesInAreaRange(posBeg, posEnd)
  return self:getTeamObjs(objids, objid, isTheSame, false)
end

function MyAreaHelper:getTeamObjs (objids, objid, isTheSame, isPlayer)
  if (objids and objid) then
    local arr, tid = {}
    local teamid
    if (ActorHelper:isPlayer(objid)) then
      teamid = PlayerHelper:getTeam(objid)
    else
      teamid = CreatureHelper:getTeam(objid)
    end
    for i, v in ipairs(objids) do
      if (isPlayer) then
        tid = PlayerHelper:getTeam(v)
      else
        tid = CreatureHelper:getTeam(v)
      end
      if ((isTheSame and teamid == tid) or -- 同队
        (not(isTheSame) and teamid ~= tid)) then -- 不同队
        table.insert(arr, v)
      end
    end
    return arr
  else
    return objids
  end
end