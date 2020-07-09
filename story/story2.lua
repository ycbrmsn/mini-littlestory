-- 剧情二
Story2 = MyStory:new()

function Story2:new ()
  local data = Story2Helper:getData()
  self:checkData(data)

  -- if (MyStoryHelper:getMainStoryIndex() <= 2) then -- 剧情2
  --   local areaid = AreaHelper:getAreaByPos(data.eventPositions[1])
  --   data.areaid = areaid
  -- end
  setmetatable(data, self)
  self.__index = self
  return data
end

function Story2:recover (player)
  Story2Helper:recover(player)
end

-- 剧情二工具类
Story2Helper = {}

function Story2Helper:getData ()
  return {
    title = '启程',
    name = '前往学院',
    desc = '先生带着我向学院出发了',
    tips = {
      '终于到了出发的时间了。我好激动。',
      '先生带着我向学院出发了。只是，没想到是要用跑的。',
      '这群可恶的强盗，居然要抢我的通行令。没办法了，先消灭他们再说。',
      '可恶的强盗终于被我消灭了。看来我还是很厉害的嘛。',
      '我……我竟然被一伙强盗打败了。还好先生及时赶到。',
      '#G目前剧情到此。'
      -- '先生先离开了。风颖城，我来了。'
    },
    yexiaolongInitPosition = {
      { x = 0, y = 7, z = 23 },
      { x = 0, y = 7, z = 20 }
    },
    playerInitPosition = { x = 0, y = 7, z = 16 },
    movePositions1 = {
      { x = 0, y = 7, z = 70 },
      { x = 0, y = 7, z = 130 },
      { x = 0, y = 7, z = 190 },
      { x = 0, y = 7, z = 250 },
      { x = 0, y = 7, z = 280 }
    },
    movePositions2 = {
      { x = 0, y = 7, z = 65 },
      { x = 0, y = 7, z = 125 },
      { x = 0, y = 7, z = 185 },
      { x = 0, y = 7, z = 245 },
      { x = 0, y = 7, z = 275 }
    },
    leaveForAWhilePositions = {
      { x = 10, y = 7, z = 280 },
      { x = 24, y = 7, z = 230 }
    },
    eventPositions = {
      { x = 0, y = 7, z = 320 }
    },
    xiaotoumuPositions = {
      { x = 0, y = 7, z = 330 }
    },
    louluoPositions = {
      { x = -2, y = 7, z = 330 },
      { x = 2, y = 7, z = 330 },
      { x = 4, y = 7, z = 330 },
      { x = -4, y = 7, z = 330 },
      { x = 6, y = 7, z = 328 },
      { x = -6, y = 7, z = 328 },
      { x = 8, y = 7, z = 326 },
      { x = -8, y = 7, z = 326 },
      { x = 10, y = 7, z = 324 },
      { x = -10, y = 7, z = 324 }
    },
    xiaotoumus = {},
    xiaolouluos = {},
    killXiaotoumuNum = 0,
    killLouluoNum = 0,
    toCollegePositions = {
      { x = 0, y = 7, z = 359 },
      { x = 0, y = 7, z = 420 },
      { x = -36, y = 7, z = 458 },
      { x = -36, y = 7, z = 500 },
      { x = -6, y = 7, z = 525 },
      { x = -6, y = 7, z = 580 },
      { x = -16, y = 7, z = 600 }
    },
    standard = 1
  }
end

function Story2Helper:recover (player)
  local mainProgress = MyStoryHelper:getMainStoryProgress()
  local hostPlayer = MyPlayerHelper:getHostPlayer()
  if (mainProgress == 1) then -- 村口集合
    if (player == hostPlayer) then
      story2:goToCollege()
    else
      player:setMyPosition(hostPlayer:getMyPosition())
    end
  elseif (mainProgress == 2) then -- 开始奔跑
    PlayerHelper:rotateCamera(player.objid, ActorHelper.FACE_YAW.NORTH, 0)
    player:setMyPosition(story2.eventPositions[1])
    if (player == hostPlayer) then
      story2:meetBandits(hostPlayer)
    end
  elseif (mainProgress == 3) then -- 路遇强盗
    if (not(AreaHelper:objInArea(story2.areaid, player.objid))) then -- 不在区域内则移动到区域内
      player:setMyPosition(story2.eventPositions[1])
    end
  elseif (mainProgress == 4) then -- 消灭了强盗
    if (not(AreaHelper:objInArea(story2.areaid, player.objid))) then -- 不在区域内则移动到区域内
      player:setMyPosition(story2.eventPositions[1])
    end
    if (player == hostPlayer) then
      story2:wipeOutQiangdao()
    end
  elseif (mainProgress == 5) then -- 被强盗打败
    if (player == hostPlayer) then
      story2:playerBadHurt(player.objid)
    end
  elseif (mainProgress == 6) then -- 先生离开
    -- 剧情二结束
  end
end