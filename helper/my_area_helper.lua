-- 我的区域工具类
MyAreaHelper = {
  playerInHomePos = { x = 31, y = 9, z = 3 },
  wolfAreas = {},
  maxRandomTimes = 10,
  showToastAreas = {} -- { areaid1 = { areaid2, name }, ... }
}

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

function MyAreaHelper:playerEnterArea (objid, areaid)
  MyStoryHelper:playerEnterArea(objid, areaid)
  local myPlayer = PlayerHelper:getPlayer(objid)
  if (areaid == myPlayer.toAreaId) then -- 玩家自动前往地点
    AreaHelper:destroyArea(areaid)
    -- myPlayer.action:runAction()
    myPlayer.action:doNext()
  elseif (self:showToastArea(objid, areaid)) then -- 显示提示区域检测
  elseif (guard and guard:checkTokenArea(objid, areaid)) then -- 检查通行令牌
  end
end
