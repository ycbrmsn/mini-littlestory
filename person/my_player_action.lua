-- 我的玩家行为类
MyPlayerAction = MyActorAction:new()

function MyPlayerAction:new (player)
  local o = {
    myActor = player
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function MyPlayerAction:playAct (act, afterSeconds)
  if (afterSeconds) then
    MyTimeHelper:callFnAfterSecond (function (p)
      PlayerHelper:playAct(self.myActor.objid, act)
    end, afterSeconds)
  else
    PlayerHelper:playAct(self.myActor.objid, act)
  end
end

function MyPlayerAction:runTo (positions, callback)
  if (positions and #positions > 0) then
    if (self.myActor.toPos) then -- 之前的行动没有结束又来一个行动
      AreaHelper:destroyArea(self.myActor.toAreaId)
    end
    self.myActor.wants = { positions, callback }
    self:doNext()
  end
end

function MyPlayerAction:doNext ()
  if (not(self.myActor.wants)) then
    return
  end
  if (#self.myActor.wants[1] > 0) then -- 有下一段路程，则继续
    local pos = self.myActor.wants[1][1]
    self.myActor.toPos = pos
    self.myActor.toAreaId = AreaHelper:createMovePosArea(pos)
    table.remove(self.myActor.wants[1], 1)
  else -- 没有则检测回调
    self.myActor.toPos = nil
    if (#self.myActor.wants > 1) then -- 有回调则执行
      self.myActor.wants[2]()
    end
  end
end

function MyPlayerAction:execute ()
  local pos = self.myActor.toPos
  if (pos) then
    ActorHelper:tryNavigationToPos(self.myActor.objid, pos.x, pos.y, pos.z, false)
  end
end

function MyPlayerAction:flyStatic ()
  local pos = self.myActor:getMyPosition()
  if (not(ActorHelper:isInAir(self.myActor.objid))) then -- 不在空中
    pos.y = pos.y + 2
    self.myActor:setMyPosition(pos)
  end
  ActorHelper:setFaceYaw(self.myActor.objid, ActorHelper:getFaceYaw(self.myActor.objid))
  if (not(self.myActor.flySwordId)) then
    self.myActor.flySwordId = WorldHelper:spawnCreature(pos.x, pos.y, pos.z, MyConstant.FLY_SWORD_ID, 1)[1]
    CreatureHelper:closeAI(self.myActor.flySwordId)
    ActorHelper:setEnableBeAttackedState(self.myActor.flySwordId, false) -- 不可被攻击
  end
  local isFlying, flyType = self.myActor:isFlying()
  local isFlyingAdvance, flyAdvanceType = self.myActor:isFlyingAdvance()
  if (not(isFlying)) then -- 如果没有飞，则飞起来
    MyTimeHelper:callFnContinueRuns(function ()
      ActorHelper:appendSpeed(self.myActor.objid, 0, MyConstant.FLY_SPEED, 0)
      local p = self.myActor:getMyPosition()
      ActorHelper:setMyPosition(self.myActor.flySwordId, p.x, p.y - 0.1, p.z)
      ActorHelper:setFaceYaw(self.myActor.flySwordId, ActorHelper:getFaceYaw(self.myActor.objid))
    end, -1, flyType)
  end
  if (isFlyingAdvance) then -- 如果在向前飞，则停止
    MyTimeHelper:delFnContinueRuns(flyAdvanceType)
  end
  self.myActor:setState(1)
end

function MyPlayerAction:flyAdvance ()
  local isFlying, flyType = self.myActor:isFlying()
  local isFlyingAdvance, flyAdvanceType = self.myActor:isFlyingAdvance()
  if (not(isFlying)) then -- 如果没有飞，则飞起来
    MyTimeHelper:callFnContinueRuns(function ()
      ActorHelper:appendSpeed(self.myActor.objid, 0, MyConstant.FLY_SPEED, 0)
    end, -1, flyType)
  end
  if (not(isFlyingAdvance)) then -- 如果没有向前飞，则向前飞
    MyTimeHelper:callFnContinueRuns(function ()
      ActorHelper:appendFixedSpeed(self.myActor.objid, MyConstant.FLY_ADVANCE_SPEED, 
        self.myActor:getMyPosition(), self.myActor:getAimPos())
    end, -1, flyAdvanceType)
  end
  self.myActor:setState(2)
end

function MyPlayerAction:stopFly (isRegular)
  local state = self.myActor:getState()
  if (state == 0) then -- 未飞行
    return
  end
  if (not(isRegular)) then -- 失控
    ItemHelper:recordUseSkill(self.myActor.objid, MyWeaponAttr.controlSword.levelIds[1], 
      MyWeaponAttr.controlSword.cd)
  end
  if (state == 1) then -- 静止
    MyTimeHelper:delFnContinueRuns(self.myActor.objid .. 'fly')
  elseif (state == 2) then -- 前行
    MyTimeHelper:delFnContinueRuns(self.myActor.objid .. 'fly')
    MyTimeHelper:delFnContinueRuns(self.myActor.objid .. 'flyAdvance')
  end
  self.myActor:setState(0)
  ActorHelper:killSelf(self.myActor.flySwordId)
  self.myActor.flySwordId = nil
  -- ActorHelper:setImmuneFall(self.myActor.objid, true) -- 免疫跌落
  -- MyTimeHelper:callFnFastRuns(function ()
  --   ActorHelper:setImmuneFall(self.myActor.objid, false) -- 取消免疫跌落
  -- end, 1)
end