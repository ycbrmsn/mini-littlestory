-- 我的玩家工具类
MyPlayerHelper = {}

-- 玩家进入游戏
function MyPlayerHelper:playerEnterGame (objid)
  PlayerHelper:playerEnterGame(objid)
  PlayerHelper:setPlayerEnableBeKilled(objid, false)
  local player = PlayerHelper:getPlayer(objid)
  local hostPlayer = PlayerHelper:getHostPlayer()
  if (player == hostPlayer) then
    -- logPaper = LogPaper:new()
    if (not(GameDataHelper:updateStoryData())) then -- 刚开始游戏
      MyTimeHelper:setHour(MyConstant.INIT_HOUR)
      player:setPosition(-24, 34.5, 6)
      PlayerHelper:rotateCamera(objid, ActorHelper.FACE_YAW.EAST, 0)
      BackpackHelper:addItem(objid, MyWeaponAttr.controlSword.levelIds[1], 1)
    end
  else
    player:setPosition(hostPlayer:getPosition())
  end
  GameDataHelper:updatePlayerData(player)
  MyStoryHelper:recover(player) -- 恢复剧情
end

-- 玩家离开游戏
function MyPlayerHelper:playerLeaveGame (objid)
  PlayerHelper:playerLeaveGame(objid)
end

-- 玩家进入区域
function MyPlayerHelper:playerEnterArea (objid, areaid)
  PlayerHelper:playerEnterArea(objid, areaid)
  MyAreaHelper:playerEnterArea(objid, areaid)
end

-- 玩家离开区域
function MyPlayerHelper:playerLeaveArea (objid, areaid)
  PlayerHelper:playerLeaveArea(objid, areaid)
  MyStoryHelper:playerLeaveArea(objid, areaid)
end

-- 玩家点击方块
function MyPlayerHelper:playerClickBlock (objid, blockid, x, y, z)
  PlayerHelper:playerClickBlock(objid, blockid, x, y, z)
end

-- 玩家使用道具
function MyPlayerHelper:playerUseItem (objid, itemid)
  PlayerHelper:playerUseItem(objid, itemid)
end

-- 玩家点击生物
function MyPlayerHelper:playerClickActor (objid, toobjid)
  PlayerHelper:playerClickActor(objid, toobjid)
end

-- 玩家获得道具
function MyPlayerHelper:playerAddItem (objid, itemid, itemnum)
  PlayerHelper:playerAddItem(objid, itemid, itemnum)
  MyStoryHelper:playerAddItem(objid, itemid, itemnum)
end

-- 玩家攻击命中
function MyPlayerHelper:playerAttackHit (objid, toobjid)
  PlayerHelper:playerAttackHit(objid, toobjid)
end

-- 玩家造成伤害
function MyPlayerHelper:playerDamageActor (objid, toobjid)
  PlayerHelper:playerDamageActor(objid, toobjid)
end

-- 玩家击败生物
function MyPlayerHelper:playerDefeatActor (playerid, objid)
  PlayerHelper:playerDefeatActor(playerid, objid)
end

-- 玩家受到伤害
function MyPlayerHelper:playerBeHurt (objid, toobjid)
  PlayerHelper:playerBeHurt(objid, toobjid)
end

-- 玩家选择快捷栏
function MyPlayerHelper:playerSelectShortcut (objid)
  PlayerHelper:playerSelectShortcut(objid)
end

-- 玩家快捷栏变化
function MyPlayerHelper:playerShortcutChange (objid)
  PlayerHelper:playerShortcutChange(objid)
end

-- 玩家运动状态改变
function MyPlayerHelper:playerMotionStateChange (objid, playermotion)
  PlayerHelper:playerMotionStateChange(objid, playermotion)
end

-- 玩家移动一格
function MyPlayerHelper:playerMoveOneBlockSize (objid)
  ActorHelper:resumeClickActor(objid)
  PlayerHelper:playerMoveOneBlockSize(objid)
end

-- 骑乘
function MyPlayerHelper:playerMountActor (objid, toobjid)
  LogHelper:debug('骑乘')
end

-- 取消骑乘
function MyPlayerHelper:playerDismountActor (objid, toobjid)
  LogHelper:debug('取消骑乘')
end