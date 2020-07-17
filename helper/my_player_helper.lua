-- 我的玩家工具类
MyPlayerHelper = {}

function MyPlayerHelper:initPlayer (objid)
  PlayerHelper:setPlayerEnableBeKilled(objid, false)
  local player = PlayerHelper:addPlayer(objid)
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

-- 玩家攻击命中
function MyPlayerHelper:playerAttackHit (objid, toobjid)
  local itemid = PlayerHelper:getCurToolID(objid)
  local item = MyItemHelper:getItem(itemid)
  if (item) then
    item:attackHit(objid, toobjid)
    PlayerHelper:showActorHp(objid, toobjid)
  end
end

-- 玩家造成伤害
function MyPlayerHelper:playerDamageActor (objid, toobjid)
  local key = PlayerHelper:generateDamageKey(objid, toobjid)
  MyTimeHelper:setFrameInfo(key, true)
  PlayerHelper:showActorHp(objid, toobjid)
end

-- 玩家击败生物
function MyPlayerHelper:playerDefeatActor (playerid, objid)
  if (PlayerHelper:getDefeatActor(objid)) then -- 该生物已死亡
    return
  else
    PlayerHelper:recordDefeatActor(objid)
  end
  local exp = MonsterHelper:getExp(playerid, objid)
  local player = PlayerHelper:getPlayer(playerid)
  player:gainExp(exp)
end

-- 玩家移动一格
function MyPlayerHelper:playerMoveOneBlockSize (objid)
  MyActorHelper:resumeClickActor(objid)
  if (MyActorHelper:isApproachBlock(objid)) then
    local player = PlayerHelper:getPlayer(objid)
    player:stopFly(true)
  end
end

-- 玩家受到伤害
function MyPlayerHelper:playerBeHurt (objid, toobjid)
  local player = PlayerHelper:getPlayer(objid)
  if (player:isFlying()) then
    player:stopFly()
  end
end

-- 骑乘
function MyPlayerHelper:playerMountActor (objid, toobjid)
  LogHelper:debug('骑乘')
end

-- 取消骑乘
function MyPlayerHelper:playerDismountActor (objid, toobjid)
  LogHelper:debug('取消骑乘')
end