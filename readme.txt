📁 game  
├── 📁 autoload  
│   ├── 📄 game_events.gd       # 游戏事件总线
│   ├── 📄 mouse_manager.gd     # 鼠标光标管理
│   ├── 📄 input_manager.gd     # 输入管理（替代game_input_events）
│   ├── 📄 game_manager.gd      # 游戏状态管理
│   └── 📄 resource_manager.gd  # 资源加载管理
│  
├── 📁 core  
│   ├── 📁 base  
│   │   ├── 📄 base_actor.gd       # 基础角色类
│   │   ├── 📄 base_state.gd       # 基础状态类
│   │   ├── 📄 base_stats.gd       # 基础属性类
│   │   ├── 📄 base_item.gd        # 基础物品类
│   │   └── 📄 base_interactable.gd # 基础交互类
│   │  
│   ├── 📁 interfaces  
│   │   ├── 📄 i_usable.gd         # 可使用接口
│   │   ├── 📄 i_equippable.gd     # 可装备接口
│   │   ├── 📄 i_interactable.gd   # 可交互接口
│   │   └── 📄 i_saveable.gd       # 可保存接口
│   │  
│   └── 📁 utils  
│       ├── 📄 state_machine.gd     # 状态机
│       ├── 📄 object_pool.gd       # 对象池
│       └── 📄 time_manager.gd      # 时间管理
│  
├── 📁 scenes  
│   ├── 📄 main_scene.gd  
│   └── 📄 main_scene.tscn  
│  
├── 📁 systems  
│   ├── 📁 player  
│   │   ├── 📄 player.gd  
│   │   ├── 📄 player.tscn  
│   │   ├── 📄 player_stats.gd      # 玩家属性
│   │   ├── 📄 player_inventory.gd  # 玩家背包
│   │   └── 📁 states               # 玩家状态
│   │       ├── 📄 player_idle_state.gd
│   │       ├── 📄 player_walk_state.gd
│   │       ├── 📄 player_tool_idle_state.gd
│   │       ├── 📄 player_tool_walk_state.gd
│   │       └── 📄 player_tool_use_state.gd
│   │  
│   ├── 📁 farming  
│   │   ├── 📄 farm_manager.gd      # 农场管理
│   │   ├── 📁 crops                # 作物系统
│   │   │   ├── 📄 base_crop.gd
│   │   │   └── 📄 crop_database.gd
│   │   └── 📁 land                 # 土地系统
│   │       ├── 📄 farm_plot.gd
│   │       └── 📄 water_plot.gd
│   │  
│   ├── 📁 tools                    # 工具系统
│   │   ├── 📄 tool_manager.gd
│   │   └── 📁 tool_actions
│   │       ├── 📄 hoe_action.gd
│   │       └── 📄 watering_action.gd
│   │  
│   └── 📁 crafting                 # 制作系统
│       ├── 📄 crafting_manager.gd
│       └── 📁 recipes
│           └── 📄 recipe_database.gd
│  
├── 📁 ui  
│   ├── 📄 ui_layer.gd              # UI层管理
│   ├── 📄 ui_layer.tscn
│   ├── 📁 components               # UI组件
│   │   ├── 📄 item_slot.gd
│   │   └── 📄 item_slot.tscn
│   │  
│   ├── 📁 hud                      # 游戏内HUD
│   │   ├── 📄 player_hud.gd
│   │   └── 📄 player_hud.tscn
│   │  
│   └── 📁 windows                  # 游戏窗口
│       ├── 📄 inventory_window.gd
│       └── 📄 inventory_window.tscn
│  
└── 📁 data  
    ├── 📁 items                    # 物品数据
    │   ├── 📄 item_database.gd
    │   └── 📁 items
    │       ├── 📁 tools
    │       │   ├── 📄 hoe.gd
    │       │   └── 📄 tools_hoe.tres
    │       ├── 📁 crops
    │       └── 📁 materials
    │  
    └── 📁 save                     # 存档系统
        └── 📄 save_manager.gd
