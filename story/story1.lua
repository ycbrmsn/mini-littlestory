-- 剧情一
Story1 = MyStory:new()

function Story1:new ()
  local data = {
    title = '序章',
    name = '学院招生通知',
    desc = '文羽前来通知我说风颖城的武术学院开始招生了',
    tips = {
      '今天又是晴朗的一天。这么好的天气，出门去逛逛吧。',
      '好像听到文羽在叫我。我得去问问他到底发生了什么。',
      '文羽告诉我风颖城的武术学院又要开始招生了，让我去问问村长。记得村长家在村中央，门对面就是喷泉。',
      '村长说学院的先生在客栈，不知道我能不能入先生的法眼呢。客栈我知道，就在喷泉旁边，有竹栅栏围着的。',
      '我得到了先生的认可。明日巳时，我就要跟着先生向着学院出发了。今天我还可以四处逛逛，或者回家睡一觉。',
      '今日巳时，就要出发了。想想还真有点迫不及待。'
    },
    posBeg = { x = 31, y = 8, z = 1 },
    posEnd = { x = 31, y = 9, z = 1 },
    createPos = { x = 28, y = 7, z = -28 },
    movePos = { x = 31, y = 8, z = 1 }
  }
  self:checkData(data)

  setmetatable(data, self)
  self.__index = self
  return data
end

function Story1:playerBadHurt (objid)
  local player = PlayerHelper:getPlayer(objid)
  local pos
  for i, v in ipairs(miaolan.firstFloorBedPositions) do
    pos = v
    if (MyAreaHelper:isAirArea(v)) then
      break
    end
  end
  player:setPosition(pos)
  PlayerHelper:rotateCamera(objid, ActorHelper.FACE_YAW.SOUTH, 0)
  player.action:playDown(1)
  PlayerHelper:changeVMode(objid)
  player:thinkTo(objid, 0, '没想到我又受重伤了。')
end

function Story1:recover (player)
  local mainProgress = MyStoryHelper:getMainStoryProgress()
  if (mainProgress >= 5) then
    player:enableMove(true)
  end
end