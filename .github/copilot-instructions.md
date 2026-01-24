# Chinese Chess (中国象棋) - AI Coding Instructions

## Project Overview
纯 HTML5 Canvas 实现的中国象棋游戏，使用原生 JavaScript 开发，包含完整的 AI 对手系统。**关键特点：零依赖、无后端、客户端 AI 计算**。

## Architecture & Core Components

### 1. Module Structure (Namespace Pattern)
所有核心逻辑通过全局命名空间对象组织：
- `com` - 通用工具、Canvas 渲染、棋盘管理 ([js/common.js](js/common.js))
- `play` - 游戏流程控制、用户交互 ([js/play.js](js/play.js))
- `AI` - Alpha-Beta 剪枝算法、局面评估 ([js/AI.js](js/AI.js))
- `bill` - 棋谱管理器 ([js/bill.js](js/bill.js))

### 2. State Management
**游戏状态存储在简单变量中（无状态管理库）**：
- `com.mans` - 所有棋子对象的哈希表（key: `"c0"`, `"J0"` 等）
- `play.map` - 10x9 二维数组表示棋盘当前状态
- `com.initMap` - 棋盘初始布局模板
- `play.pace` - 走棋历史记录

### 3. Data Flow
```
用户点击 Canvas → play.clickCanvas() 
  → 坐标转换 (canvas → 棋盘网格坐标) 
  → 规则校验 (com.bylaw[piece].bl())
  → 更新 map + mans 对象
  → AI.init() 计算响应 (Alpha-Beta 搜索)
  → com.show() 重绘 Canvas
```

## Key Patterns & Conventions

### Coordinate Systems
**混合坐标系统（易错点）**：
- **Canvas 像素坐标**: `com.pointStartX/Y + n * com.spaceX/Y`
- **棋盘网格坐标**: 0-8 (X轴), 0-9 (Y轴)
- 转换函数: 参见 [common.js#L100-130](js/common.js) 中的坐标计算逻辑

### Piece Naming Convention
棋子 key 格式: `[类型][编号]`
- 小写 = 红方 (玩家默认): `"c0"` (车), `"m0"` (马), `"j0"` (将)
- 大写 = 黑方 (AI): `"C0"` (车), `"M0"` (马), `"J0"` (帅)
- `com.args` 定义所有棋子类型及属性 ([common.js#L600](js/common.js))

### AI Search Algorithm
**Alpha-Beta 剪枝 + 历史表 + 开局库**：
1. 优先查询 `com.gambit` 开局库（棋谱字符串匹配）
2. 否则执行 `AI.getAlphaBeta()` 递归搜索
3. 搜索深度 `play.depth` (2=菜鸟, 3=中级, 4=高手)
4. 评估函数 `AI.evaluate()` 基于棋子位置价值表

参见 [AI.js#L121-L200](js/AI.js) 中的核心算法实现。

### Canvas Rendering
**渲染循环通过 `com.childList` 管理**：
```javascript
com.childList = [com.bg, com.dot, com.pane, ...棋子对象]
com.show() → 清除画布 → 遍历 childList 调用 .show()
```
每个对象必须实现 `.show()` 方法。参见 [common.js#L220](js/common.js)。

## Critical Workflows

### Starting a Game
```javascript
play.init(depth, map)  // depth: AI难度, map: 可选棋局
  → 清空 play.mans → com.createMans(map) → 绑定点击事件
```

### Making a Move
1. 用户点击选中棋子 → `play.nowManKey` 存储
2. 再次点击 → 校验合法性 (`man.bl(map)` 返回可走位置数组)
3. 更新 `play.map` 和棋子 `.x/.y` 属性
4. 推入 `play.pace` 记录
5. 触发 AI 回合 (`AI.init(play.pace)`)

### Undo Move (悔棋)
`play.regret()` - 回退两步（玩家 + AI 各一步），重放历史 `play.pace`。

## File Organization

### Critical Files
- **[js/common.js](js/common.js)** (848行) - 基础设施：Canvas、工具函数、棋子定义、坐标系统
- **[js/AI.js](js/AI.js)** (223行) - Alpha-Beta搜索、局面评估
- **[js/play.js](js/play.js)** (338行) - 游戏循环、交互逻辑
- **[js/gambit.all.js](js/gambit.all.js)** - 开局库（空格分隔的着法字符串）

### Asset Loading
三套皮肤 (`stype_1/2/3`)，运行时切换：
```javascript
com.init("stype2") → 加载对应 img/ 目录下的资源
```

## Testing & Debugging

### Debug Utilities
- `z()` - `com.alert()` 的简写，用于 console.log
- `l()` - `console.log` 别名
- AI 搜索日志：控制台输出最佳着法、搜索深度、评估分数

### Common Issues
1. **坐标混淆**: 始终区分像素坐标 vs 网格坐标
2. **对象引用**: `play.map` 深拷贝用 `com.arr2Clone()`，避免意外修改
3. **AI 超时**: 深度过深时资源耗尽，参见 [README.md](README.md) v1.0.2 修复记录

## Code Style
- **命名**: 拼音缩写常见 (`bl` = 兵/棋子走法, `man` = 棋子对象)
- **中文注释**: 代码注释和日志使用中文
- **全局污染**: 所有函数挂在命名空间对象上，避免 `var` 污染
- **ES5 语法**: 不使用 ES6+ 特性（浏览器兼容性考虑）
