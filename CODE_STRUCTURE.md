# Jail Escape - Code Structure Guide

## Directory Structure

```
src/
├── shared/
│   ├── types/
│   │   ├── Player.luau           # Player type definitions
│   │   ├── Activity.luau         # Activity type definitions
│   │   ├── Item.luau             # Item type definitions
│   │   ├── Task.luau             # Task type definitions
│   │   ├── EscapeMethod.luau     # Escape method type definitions
│   │   └── NPC.luau              # NPC type definitions
│   │
│   ├── config/
│   │   ├── Items.luau            # Item definitions
│   │   ├── Tasks.luau            # Task definitions
│   │   ├── EscapeMethods.luau    # Escape method configurations
│   │   ├── Prison.luau           # Prison layout configuration
│   │   └── GameSettings.luau     # Game-wide settings
│   │
│   ├── events/
│   │   ├── ActivityEvents.luau   # Activity tracking events
│   │   ├── SuspicionEvents.luau  # Suspicion system events
│   │   ├── EscapeEvents.luau     # Escape method events
│   │   ├── TaskEvents.luau       # Task system events
│   │   ├── TradingEvents.luau    # Trading system events
│   │   └── GuardEvents.luau      # Guard system events
│   │
│   ├── utils/
│   │   ├── EventBus.luau         # Event bus implementation
│   │   ├── DataStructures.luau   # Custom data structures
│   │   └── Helpers.luau          # Utility functions
│   │
│   └── constants/
│       └── Constants.luau        # Game constants
│
├── server/
│   ├── init.server.luau          # Server entry point
│   │
│   ├── managers/
│   │   ├── GameManager.luau      # Main game coordinator
│   │   ├── PlayerManager.luau    # Player lifecycle management
│   │   ├── CellManager.luau      # Cell assignment and management
│   │   └── TeamManager.luau      # Team management
│   │
│   ├── systems/
│   │   ├── activity/
│   │   │   ├── ActivityTracker.luau      # Main activity tracking
│   │   │   ├── ActivityLogger.luau       # Activity logging
│   │   │   └── ActivityFilter.luau       # Suspicious activity filtering
│   │   │
│   │   ├── suspicion/
│   │   │   ├── SuspicionSystem.luau      # Main suspicion system
│   │   │   ├── SuspicionCalculator.luau  # Suspicion calculation
│   │   │   ├── SuspicionTracker.luau     # Per-player tracking
│   │   │   └── BehaviorAnalyzer.luau     # Behavior pattern analysis
│   │   │
│   │   ├── escape/
│   │   │   ├── EscapeMethodManager.luau  # Main escape coordinator
│   │   │   ├── EscapeMethod.luau         # Base escape method class
│   │   │   ├── methods/
│   │   │   │   ├── FenceCuttingMethod.luau
│   │   │   │   ├── GuardDisguiseMethod.luau
│   │   │   │   ├── CellDiggingMethod.luau
│   │   │   │   ├── ParoleMethod.luau
│   │   │   │   └── CartelBreakoutMethod.luau
│   │   │   └── EscapeProgressTracker.luau # Track progress across methods
│   │   │
│   │   ├── tasks/
│   │   │   ├── TaskManager.luau          # Main task system
│   │   │   ├── TaskGenerator.luau        # Dynamic task generation
│   │   │   ├── TaskBoard.luau            # Job board management
│   │   │   └── TaskAssigner.luau         # Task assignment logic
│   │   │
│   │   ├── trading/
│   │   │   ├── TradingManager.luau       # Main trading system
│   │   │   ├── CommonBoard.luau          # Trading board system
│   │   │   ├── ReceiptSystem.luau        # Receipt tracking
│   │   │   └── ItemTracker.luau          # Item availability tracking
│   │   │
│   │   ├── guards/
│   │   │   ├── GuardManager.luau         # Main guard system
│   │   │   ├── GuardPatrol.luau          # Patrol route management
│   │   │   ├── GuardInvestigation.luau   # Investigation logic
│   │   │   ├── WardenAI.luau             # Intelligent warden behavior
│   │   │   └── CameraSystem.luau         # Security camera monitoring
│   │   │
│   │   ├── npcs/
│   │   │   ├── NPCManager.luau           # Main NPC system
│   │   │   ├── NPCBase.luau              # Base NPC class
│   │   │   ├── GuardNPC.luau             # Guard NPC implementation
│   │   │   ├── InmateNPC.luau            # Inmate NPC implementation
│   │   │   ├── WardenNPC.luau            # Warden NPC implementation
│   │   │   ├── NPCBehaviorTree.luau      # Behavior tree system
│   │   │   └── NPCPathfinding.luau       # Pathfinding wrapper
│   │   │
│   │   └── reporting/
│   │       ├── ReportingManager.luau     # Main reporting system
│   │       ├── ReportVerifier.luau       # Report verification
│   │       └── ReportProcessor.luau      # Process report outcomes
│   │
│   ├── data/
│   │   ├── ItemSystem.luau               # Item management
│   │   ├── InventorySystem.luau          # Grid-based inventory
│   │   ├── ResourceSystem.luau           # Money and resources
│   │   └── CellSystem.luau               # Cell management and photo
│   │
│   └── modes/
│       ├── GameMode.luau                 # Base game mode
│       ├── FreeForAllMode.luau           # Free for all mode
│       ├── TeamsMode.luau                # Teams mode
│       └── SoloMode.luau                 # Solo mode
│
└── client/
    ├── init.client.luau                  # Client entry point
    │
    ├── ui/
    │   ├── InventoryUI.luau              # Inventory interface
    │   ├── TaskBoardUI.luau              # Task board interface
    │   ├── TradingBoardUI.luau           # Trading board interface
    │   ├── CellPhotoUI.luau              # Cell photo interface
    │   ├── ReportingUI.luau              # Reporting interface
    │   └── EscapeProgressUI.luau         # Escape progress display
    │
    ├── controllers/
    │   ├── InputController.luau          # Input handling
    │   ├── InteractionController.luau    # Item/NPC interactions
    │   └── CameraController.luau         # Camera controls
    │
    └── managers/
        └── ClientStateManager.luau       # Local client state
```

---

## Module Details

### Shared Modules

#### Types (`shared/types/`)

**Purpose**: TypeScript-style type definitions for Luau

**Files**:
- `Player.luau`: Player data structures
- `Activity.luau`: Activity log structures
- `Item.luau`: Item definitions
- `Task.luau`: Task structures
- `EscapeMethod.luau`: Escape method structures
- `NPC.luau`: NPC data structures

**Example** (`shared/types/Player.luau`):
```lua
export type PlayerData = {
    userId: number,
    cellId: number,
    suspicion: number,
    money: number,
    teamId: number?,
    inventory: Inventory,
    escapeProgress: Map<string, number>, -- escapeMethodId -> progress %
}
```

#### Configuration (`shared/config/`)

**Purpose**: Data-driven configuration files

**Files**:
- `Items.luau`: All item definitions
- `Tasks.luau`: Task templates and categories
- `EscapeMethods.luau`: Escape method configurations
- `Prison.luau`: Prison layout data
- `GameSettings.luau`: Game-wide constants

**Example** (`shared/config/Items.luau`):
```lua
return {
    wireCutters = {
        id = "wireCutters",
        name = "Wire Cutters",
        category = "Tool",
        gridSize = {width = 2, height = 1},
        suspicionValue = 5,
        properties = {
            toolType = "cutting",
            durability = 100,
        }
    },
    -- ... more items
}
```

#### Events (`shared/events/`)

**Purpose**: Event definitions for inter-system communication

**Pattern**: Each file exports event creation functions

**Example** (`shared/events/ActivityEvents.luau`):
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventBus = require(script.Parent.Parent.utils.EventBus)

return EventBus:CreateEventGroup("Activity", {
    "ActivityLogged",      -- (playerId, activity)
    "ActivityVerified",    -- (playerId, activity, verified)
    "SuspiciousActivity",  -- (playerId, activity)
})
```

---

### Server Modules

#### Managers (`server/managers/`)

**Purpose**: High-level game coordination

**GameManager.luau**:
- Initializes all systems
- Manages game state
- Handles win conditions
- Coordinates game modes

**PlayerManager.luau**:
- Handles player joining/leaving
- Manages player lifecycle
- Coordinates with CellManager for assignments
- Fills empty slots with NPCs

**CellManager.luau**:
- Assigns players to cells
- Manages cell availability
- Handles cell interactions

**TeamManager.luau**:
- Forms teams in team mode
- Manages team assignments
- Handles team win conditions

#### Systems (`server/systems/`)

Each system folder contains modular components for that system's functionality.

**Activity System**:
- `ActivityTracker.luau`: Main coordinator
- `ActivityLogger.luau`: Logs activities with timestamps
- `ActivityFilter.luau`: Filters suspicious activities

**Suspicion System**:
- `SuspicionSystem.luau`: Main coordinator
- `SuspicionCalculator.luau`: Calculates suspicion scores
- `SuspicionTracker.luau`: Tracks per-player suspicion
- `BehaviorAnalyzer.luau`: Analyzes behavior patterns

**Escape Methods System**:
- `EscapeMethodManager.luau`: Coordinates all escape methods
- `EscapeMethod.luau`: Abstract base class
- `methods/*.luau`: Specific escape method implementations
- Each method is self-contained and extensible

**Task System**:
- `TaskManager.luau`: Main task coordinator
- `TaskGenerator.luau`: Dynamically generates tasks
- `TaskBoard.luau`: Manages job boards
- `TaskAssigner.luau`: Assigns tasks to players/NPCs

**Trading System**:
- `TradingManager.luau`: Main trading coordinator
- `CommonBoard.luau`: Trading board implementation
- `ReceiptSystem.luau`: Receipt generation and tracking
- `ItemTracker.luau`: Tracks item availability in prison

**Guard System**:
- `GuardManager.luau`: Main guard coordinator
- `GuardPatrol.luau`: Manages patrol routes
- `GuardInvestigation.luau`: Handles investigations
- `WardenAI.luau`: Intelligent warden decision-making
- `CameraSystem.luau`: Security camera monitoring

**NPC System**:
- `NPCManager.luau`: Main NPC coordinator
- `NPCBase.luau`: Base class for all NPCs
- `GuardNPC.luau`, `InmateNPC.luau`, `WardenNPC.luau`: Specific implementations
- `NPCBehaviorTree.luau`: Behavior tree for NPC actions
- `NPCPathfinding.luau`: Pathfinding wrapper

**Reporting System**:
- `ReportingManager.luau`: Main reporting coordinator
- `ReportVerifier.luau`: Verifies reports against activity log
- `ReportProcessor.luau`: Processes report outcomes

#### Data Systems (`server/data/`)

**ItemSystem.luau**:
- Manages item spawning
- Handles item properties
- Controls item availability

**InventorySystem.luau**:
- Grid-based inventory management
- Item placement validation
- Space calculations
- Server-authoritative inventory state

**ResourceSystem.luau**:
- Money management
- Resource tracking
- Economy balance

**CellSystem.luau**:
- Cell management
- Photo system for escape progress
- Cell storage for hidden items

#### Game Modes (`server/modes/`)

**GameMode.luau**: Base class for all game modes

**FreeForAllMode.luau**, **TeamsMode.luau**, **SoloMode.luau**: Specific mode implementations

---

### Client Modules

#### UI (`client/ui/`)

All UI components for player interactions:

- `InventoryUI.luau`: Grid-based inventory interface
- `TaskBoardUI.luau`: Task board browsing
- `TradingBoardUI.luau`: Trading board interface
- `CellPhotoUI.luau`: Cell photo interaction and display
- `ReportingUI.luau`: Report submission interface
- `EscapeProgressUI.luau`: Escape method progress display

#### Controllers (`client/controllers/`)

- `InputController.luau`: Handles player input
- `InteractionController.luau`: Manages interactions with items/NPCs
- `CameraController.luau`: Camera controls (if needed)

#### Managers (`client/managers/`)

- `ClientStateManager.luau`: Manages local client state, UI state

---

## Coding Conventions

### Naming Conventions

- **Files**: PascalCase (e.g., `PlayerManager.luau`)
- **Modules**: PascalCase (e.g., `PlayerManager`)
- **Functions**: camelCase (e.g., `calculateSuspicion`)
- **Variables**: camelCase (e.g., `playerData`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_PLAYERS`)
- **Types**: PascalCase (e.g., `PlayerData`)

### Roblox-Specific Requirements

**Module Requiring**:
- When requiring a module in the **same folder**, use `script.Parent.[FileName]`
  - Example: `local ActivityLogger = require(script.Parent.ActivityLogger)`
- When requiring a module in a **parent folder**, use `script.Parent.Parent.[FolderName].[FileName]`
  - Example: `local GameSettings = require(script.Parent.Parent.Parent.shared.config.GameSettings)`
- **Never use** `script.[FileName]` for sibling modules - this will cause errors in Roblox Studio

### Code Organization

1. **Module Pattern**: Each file exports a table or class
2. **Dependency Injection**: Pass dependencies through constructors
3. **Event-Driven**: Use events for inter-system communication
4. **Single Responsibility**: Each module has one clear purpose

### Example Module Structure

```lua
-- server/systems/suspicion/SuspicionCalculator.luau

local SuspicionCalculator = {}
SuspicionCalculator.__index = SuspicionCalculator

-- Constructor
function SuspicionCalculator.new(activityTracker)
    local self = setmetatable({}, SuspicionCalculator)
    self.activityTracker = activityTracker
    return self
end

-- Public methods
function SuspicionCalculator:calculate(playerId)
    -- Implementation
end

return SuspicionCalculator
```

---

## Dependencies & Requirements

### Required Roblox Services

- `ReplicatedStorage`: Shared code and events
- `ServerScriptService`: Server-side code
- `StarterPlayer`: Client-side code
- `PathfindingService`: NPC pathfinding
- `RunService`: Game loops
- `CollectionService`: Instance tagging

### Required Tools

- **Rojo**: Code organization and synchronization
- **Luau**: Roblox's Lua dialect

### External Libraries (Optional)

Consider using community libraries for:
- Promise/async patterns (e.g., `Promise`)
- State management (e.g., `Rodux`)
- Networking (e.g., `Net` wrapper)

---

## Extension Points

### Adding a New Escape Method

1. Create new file in `server/systems/escape/methods/YourMethod.luau`
2. Extend `EscapeMethod` base class
3. Implement required methods:
   - `getRequirements()`
   - `getSteps()`
   - `updateProgress()`
   - `canComplete()`
4. Register in `EscapeMethodManager`
5. Add configuration to `shared/config/EscapeMethods.luau`

### Adding a New Task Type

1. Add task definition to `shared/config/Tasks.luau`
2. Define category, pay, suspicion level
3. `TaskGenerator` will automatically include it

### Adding a New Item

1. Add item definition to `shared/config/Items.luau`
2. Define properties (size, suspicion, category)
3. Add spawn logic to `ItemSystem` if needed

### Adding a New Prison

1. Create prison layout file in `shared/config/Prisons/YourPrison.luau`
2. Define:
   - Cell locations
   - Task board locations
   - Guard routes
   - Interactive element locations
3. Update `Prison.luau` to include new prison
4. Systems automatically adapt to new layout

---

## Testing Strategy

### Unit Tests

Place unit tests in parallel structure:
```
tests/
├── server/
│   └── systems/
│       └── suspicion/
│           └── SuspicionCalculator.test.luau
```

### Integration Tests

Test system interactions:
```
tests/
└── integration/
    └── EscapeFlow.test.luau
```

---

## Implementation Order

### Phase 1: Foundation
1. Event system (`shared/utils/EventBus.luau`)
2. Type definitions (`shared/types/`)
3. Configuration files (`shared/config/`)
4. Player management (`server/managers/PlayerManager.luau`)
5. Cell system (`server/data/CellSystem.luau`)

### Phase 2: Core Systems
1. Activity tracking (`server/systems/activity/`)
2. Suspicion system (`server/systems/suspicion/`)
3. Item system (`server/data/ItemSystem.luau`)
4. Inventory system (`server/data/InventorySystem.luau`)
5. Resource system (`server/data/ResourceSystem.luau`)

### Phase 3: Gameplay Systems
1. Task system (`server/systems/tasks/`)
2. Escape methods (`server/systems/escape/`)
3. Trading system (`server/systems/trading/`)
4. Reporting system (`server/systems/reporting/`)

### Phase 4: NPC & Guard Systems
1. NPC system (`server/systems/npcs/`)
2. Guard system (`server/systems/guards/`)
3. Warden AI (`server/systems/guards/WardenAI.luau`)

### Phase 5: Client Integration
1. UI systems (`client/ui/`)
2. Controllers (`client/controllers/`)
3. Client state (`client/managers/`)

### Phase 6: Game Modes
1. Free for All mode
2. Teams mode
3. Solo mode

---

**Document Version**: 1.0  
**Last Updated**: [Current Date]  
**Status**: Code Structure Guide Complete
