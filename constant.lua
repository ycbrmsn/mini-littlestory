-- 常量
MyConstant = {
  INIT_HOUR = 7, -- 初始时间
  FLY_SPEED = 0.0785, -- 飞行速度
  FLY_ADVANCE_SPEED = 0.05, -- 飞行前进速度
  PROJECTILE_HURT = 6, -- 通用投掷物固定伤害
  
  -- 人物ID
  FLY_SWORD_ID = 2, -- 御剑

  -- 怪物ID

  -- boss

  -- 道具ID
  ITEM = {
    GAME_DATA_MAIN_INDEX_ID = 4098, -- 主线剧情序号
    GAME_DATA_MAIN_PROGRESS_ID = 4099, -- 主线剧情进度数据
    GAME_DATA_LEVEL_ID = 4100, -- 人物等级数据
    GAME_DATA_EXP_ID = 4101 -- 人物经验数据
  },
  WEAPON = {
    TEN_THOUSAND_SWORD_ID = 4107 -- 万剑诀飞剑
  },
  BODY_EFFECT = {
    SMOG1 = 1226, -- 一团小烟雾随即消失

    BOOM1 = 1186, -- 黄色的小爆炸脚下一个圈

    LIGHT3 = 1008, -- 一颗心加血特效
    LIGHT4 = 1023, -- 三格大小四散旋转的黄光
    LIGHT9 = 1150, -- 一堆心加血特效
    LIGHT10 = 1185, -- 两格大小的两个气旋不停旋转
    LIGHT19 = 1223, -- 一格大小的淡蓝色方框气流圈住流动
    LIGHT22 = 1227, -- 一圈紫色光幕围住并盘旋着锁链
    LIGHT24 = 1231, -- 黄色的无敌盾保护圈
    LIGHT26 = 1235, -- 红十字加血特效
    LIGHT47 = 1337, -- 接近一格大小的一团蓝色光雾周围一些小蓝点

    PARTICLE24 = 1341 -- 两格大小的一个黄色小光源
  },
  SOUND_EFFECT = {
    SKILL9 = 10086 -- 一阵风的声音
  }
}

-- 武器属性
MyWeaponAttr = {
  -- 剑
  controlSword = { -- 御剑
    attack = 10,
    defense = 5,
    cd = 15,
    cdReason = '御剑失控，短时间内无法再次御剑',
    skillname = '御剑飞行',
    addAttPerLevel = 4,
    addDefPerLevel = 4
  },
  tenThousandsSword = { -- 万剑
    attack = 20,
    defense = 5,
    cd = 30,
    cdReason = '万剑诀技能冷却中',
    skillname = '万剑诀',
    hurt = 8,
    addAttPerLevel = 6,
    addDefPerLevel = 6
  }
}

-- 武器id
MyWeaponAttr.controlSword.levelIds = { 4105 } -- 御剑
MyWeaponAttr.tenThousandsSword.levelIds = { 4106 } -- 万剑
