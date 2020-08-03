-- 我的游戏工具类
MyGameHelper = {}

function initMyActors ()
  PersonHelper:init()
  MyBlockHelper:init()
end

function initDoorAreas ()
  local doors = PositionHelper:getDoorPositions()
  for i, v in ipairs(doors) do
    local areaid = AreaHelper:getAreaByPos(v)
    -- LogHelper:debug('初始化门区域：', areaid)
    table.insert(AreaHelper.allDoorAreas, areaid, v)
  end
end

-- 事件

-- 开始游戏
function MyGameHelper:startGame ()
  GameHelper:startGame()
  MyBlockHelper:initBlocks()
end

-- 游戏运行时
function MyGameHelper:runGame ()
  GameHelper:runGame()
end

-- 结束游戏
function MyGameHelper:endGame ()
  GameHelper:endGame()
end

-- 世界时间到[n]点
function MyGameHelper:atHour (hour)
  GameHelper:atHour(hour)
end

-- 世界时间到[n]秒
function MyGameHelper:atSecond (second)
  GameHelper:atSecond(second)
  -- if (second == 1) then
  --   initMyActors()
  --   MonsterHelper:init()
  --   MyAreaHelper:initAreas()
  -- end

  -- if (second == 3) then
  --   MyStoryHelper.mainIndex = 2
  --   MyStoryHelper.mainProgress = 1
  --   story2:goToCollege()
  -- end
end