-- 我的方块工具类
MyBlockHelper = {}

-- 初始化
function MyBlockHelper:init ()
  -- body
  -- initBlocks()
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
            TimeHelper:callFnFastRuns(function ()
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
  -- body
  -- local disableMsg = '不可被破坏'
  -- if (blockid == BlockHelper.switchid) then
  --   PlayerHelper:showToast(objid, '开关', disableMsg)
  -- elseif (blockid == BlockHelper.doorid) then
  --   PlayerHelper:showToast(objid, '门', disableMsg)
  -- end
end

-- 方块被触发
function MyBlockHelper:blockTrigger (objid, blockid, x, y, z)
  BlockHelper:blockTrigger(objid, blockid, x, y, z)
  -- body
  -- local pos = MyPosition:new(x, y, z)
  -- MyBlockHelper:checkCityGates(objid, blockid, pos)
end