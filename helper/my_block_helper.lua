-- 我的方块工具类
MyBlockHelper = {
  cityGateBlockIds = { 414, 122, 415 }, -- 竖纹、雪堆、电石块
  cityGates = { -- 开关、左电石、右电石、右区域
    { MyPosition:new(-41.5, 8.5, 484.5), MyPosition:new(-39.5, 5.5, 480.5), MyPosition:new(-32.5, 5.5, 480.5), MyPosition:new(-35.5, 12.5, 480.5) }, -- 南
    { MyPosition:new(-30.5, 8.5, 619.5), MyPosition:new(-32.5, 5.5, 623.5), MyPosition:new(-39.5, 5.5, 623.5), MyPosition:new(-36.5, 12.5, 623.5) }, -- 北
    { MyPosition:new(31.5, 8.5, 546.5), MyPosition:new(35.5, 5.5, 548.5), MyPosition:new(35.5, 5.5, 555.5), MyPosition:new(35.5, 12.5, 552.5) }, -- 东
    { MyPosition:new(-103.5, 8.5, 557.5), MyPosition:new(-107.5, 5.5, 555.5), MyPosition:new(-107.5, 5.5, 548.5), MyPosition:new(-107.5, 12.5, 551.5) } -- 西
  }
}

function MyBlockHelper:init ()
  for i, v in ipairs(self.cityGates) do
    table.insert(v, AreaHelper:getAreaByPos(v[4]))
  end
end

function MyBlockHelper:check (pos, objid)
  local blockid = BlockHelper:getBlockID(pos.x, pos.y, pos.z)
  if (BlockHelper:checkCandle(objid, blockid, pos)) then
  elseif (MyBed:isBed(blockid)) then
    -- 处理床
    PlayerHelper:showToast(objid, '你无法在别人的床上睡觉')
  end
end

-- 检查是否是控制城门的开关，如果是则打开城门或关闭城门
function MyBlockHelper:checkCityGates (objid, blockid, pos)
  if (blockid == 724) then -- 开关
    for i, v in ipairs(self.cityGates) do
      if (v[1]:equals(pos)) then -- 找到开关
        if (BlockHelper:getBlockSwitchStatus(v[1])) then -- 打开
          if (BlockHelper:getBlockID(v[4].x, v[4].y, v[4].z) == self.cityGateBlockIds[1]) then
            AreaHelper:replaceAreaBlock(v[5], self.cityGateBlockIds[1], self.cityGateBlockIds[2], 5)
            BlockHelper:replaceBlock(self.cityGateBlockIds[3], v[2].x, v[2].y, v[2].z)
            MyTimeHelper:callFnFastRuns(function ()
              AreaHelper:replaceAreaBlock(v[5], self.cityGateBlockIds[2], self.cityGateBlockIds[1], 5)
              BlockHelper:replaceBlock(self.cityGateBlockIds[3], v[3].x, v[3].y, v[3].z)
            end, 0.005)
          end
        else
          BlockHelper:replaceBlock(self.cityGateBlockIds[2], v[2].x, v[2].y, v[2].z)
          BlockHelper:replaceBlock(self.cityGateBlockIds[2], v[3].x, v[3].y, v[3].z)
        end
        break
      end
    end
  end
end

function MyBlockHelper:initBlocks ()
  BlockHelper:setBlockSettingAttState(BlockHelper.bedid, BLOCKATTR.ENABLE_BEOPERATED, false) -- 舒适的床不可操作
  BlockHelper:setBlockSettingAttState(BlockHelper.switchid, BLOCKATTR.ENABLE_DESTROYED, false) -- 开关不可被破坏
  BlockHelper:setBlockSettingAttState(BlockHelper.doorid, BLOCKATTR.ENABLE_DESTROYED, false) -- 门不可被破坏
end

-- 事件

-- 完成方块挖掘
function MyBlockHelper:blockDigEnd (objid, blockid, x, y, z)
  BlockHelper:blockDigEnd(objid, blockid, x, y, z)
  local disableMsg = '不可被破坏'
  if (blockid == BlockHelper.switchid) then
    PlayerHelper:showToast(objid, '开关', disableMsg)
  elseif (blockid == BlockHelper.doorid) then
    PlayerHelper:showToast(objid, '门', disableMsg)
  end
end

-- 方块被触发
function MyBlockHelper:blockTrigger (objid, blockid, x, y, z)
  BlockHelper:blockTrigger(objid, blockid, x, y, z)
  local pos = MyPosition:new(x, y, z)
  MyBlockHelper:checkCityGates(objid, blockid, pos)
end