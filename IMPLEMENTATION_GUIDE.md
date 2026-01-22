# Jail Escape - Implementation Guide

## Overview

This document provides guidance for implementing the Jail Escape game based on the architecture and code structure. It highlights what parts/pieces are needed and what dependencies exist.

---

## Required Components

### 1. Core Infrastructure (Must Have First)

#### Event System
**Status**: Need to create  
**Location**: `shared/utils/EventBus.luau`  
**Purpose**: Inter-system communication  
**Dependencies**: None  
**Requirements**:
- Event registration system
- Event emission/broadcasting
- Support for client-server events (RemoteEvents)
- Support for server-only events (BindableEvents)

#### Type Definitions
**Status**: Need to create  
**Location**: `shared/types/*.luau`  
**Purpose**: Type safety and documentation  
**Dependencies**: None  
**Requirements**:
- Player data structures
- Activity log structures
- Item definitions
- Task structures
- Escape method structures
- NPC data structures

#### Configuration Files
**Status**: Need to create  
**Location**: `shared/config/*.luau`  
**Purpose**: Data-driven configuration  
**Dependencies**: Type definitions  
**Requirements**:
- Item definitions (size, suspicion, properties)
- Task templates (categories, pay, suspicion)
- Escape method configurations
- Prison layout data
- Game-wide settings (player count, timing, etc.)

---

### 2. Foundation Systems (Phase 1)

#### Game Manager
**Status**: Need to create  
**Location**: `server/managers/GameManager.luau`  
**Purpose**: Game orchestration  
**Dependencies**: Event system, Player Manager  
**Requirements**:
- Game initialization (10-second wait window)
- Game mode selection
- Game state management
- Win condition detection
- Match session management

#### Player Manager
**Status**: Need to create  
**Location**: `server/managers/PlayerManager.luau`  
**Purpose**: Player lifecycle  
**Dependencies**: Cell Manager, NPC Manager  
**Requirements**:
- Player joining/leaving
- Cell assignment logic
- NPC fill-in system (fill empty slots)
- Player data initialization

#### Cell Manager
**Status**: Need to create  
**Location**: `server/managers/CellManager.luau`  
**Purpose**: Cell assignment  
**Dependencies**: Prison layout config  
**Requirements**:
- Cell availability tracking
- Cell assignment algorithm
- Cell data structure (photo, storage)

---

### 3. Data Tracking Systems (Phase 2)

#### Activity Tracker
**Status**: Need to create  
**Location**: `server/systems/activity/ActivityTracker.luau`  
**Purpose**: Track all player activities  
**Dependencies**: Event system  
**Requirements**:
- Activity logging with timestamps
- Location visit tracking
- Item usage tracking
- Task completion tracking
- Escape method progress tracking
- Daily activity logs (array per day per player)
- Suspicious activity filtering

#### Suspicion System
**Status**: Need to create  
**Location**: `server/systems/suspicion/SuspicionSystem.luau`  
**Purpose**: Calculate and track suspicion  
**Dependencies**: Activity Tracker  
**Requirements**:
- Location frequency calculation
- Contraband possession tracking
- Unusual behavior detection
- Suspicion level calculation (0-100%)
- Suspicion decay over time
- Automatic solitary triggers:
  - Late to cell
  - Not listening to guard commands

---

### 4. Item & Inventory Systems (Phase 2)

#### Item System
**Status**: Need to create  
**Location**: `server/data/ItemSystem.luau`  
**Purpose**: Item management  
**Dependencies**: Item configuration  
**Requirements**:
- Item spawning
- Item property management
- Item availability control (limited items)
- Item interaction handling

#### Inventory System (Grid-Based)
**Status**: Need to create  
**Location**: `server/data/InventorySystem.luau`  
**Purpose**: Grid-based inventory  
**Dependencies**: Item System  
**Requirements**:
- Grid layout management (2D array)
- Item placement validation
- Space calculation (items have different sizes)
- Item rotation support
- Carry capacity limits
- Inventory state replication to client

**Note**: This is a critical system - items have different grid sizes (e.g., 1x1, 2x1, 3x2)

---

### 5. Resource & Trading Systems (Phase 3)

#### Resource System
**Status**: Need to create  
**Location**: `server/data/ResourceSystem.luau`  
**Purpose**: Money and resource management  
**Dependencies**: None  
**Requirements**:
- Money tracking per player
- Resource distribution
- Economy balance

#### Trading System
**Status**: Need to create  
**Location**: `server/systems/trading/TradingManager.luau`  
**Purpose**: All trading mechanics  
**Dependencies**: Item System, Inventory System  
**Requirements**:
- Common cell trading board
- Anonymous posting system
- Receipt generation and visibility
- Direct player-to-player trading
- NPC trading (item-based, not just money)
- Item availability tracking

**Critical Requirements**:
- NPCs want specific items (not just ramen/money)
- Receipts visible to everyone (hurts anonymity)
- Limited items promote communication

---

### 6. Task System (Phase 3)

#### Task Manager
**Status**: Need to create  
**Location**: `server/systems/tasks/TaskManager.luau`  
**Purpose**: Task management  
**Dependencies**: Resource System, NPC System  
**Requirements**:
- Task generation (dynamic)
- Task assignment (players/NPCs)
- Task completion tracking
- Reward distribution
- Task board management

**Task Categories**:
- Labor tasks (low suspicion, varies by task)
- Skilled tasks (medium suspicion, higher pay)
- Illegal tasks (on job board, high suspicion, good pay)
- Super illegal tasks (gang members only, very high suspicion, very good pay)
- Rehabilitation tasks (low suspicion, low pay, reduces suspicion)

**Pay Scale**: Less suspicious = higher pay (e.g., woodworking > bathroom cleaning)

---

### 7. Escape Methods System (Phase 3)

#### Escape Method Manager
**Status**: Need to create  
**Location**: `server/systems/escape/EscapeMethodManager.luau`  
**Purpose**: Coordinate all escape methods  
**Dependencies**: Item System, Activity Tracker, Cell System  
**Requirements**:
- Track progress for multiple methods per player
- Validate method requirements
- Handle method completion
- Calculate escape completion percentage
- Support multiple simultaneous methods

#### Escape Method Implementations
**Status**: Need to create  
**Location**: `server/systems/escape/methods/*.luau`  
**Dependencies**: Escape Method base class  
**Required Methods**:

1. **Fence Cutting** (`FenceCuttingMethod.luau`)
   - Requirements: Cutting tool, knowledge of weak points
   - Steps: Acquire tool → Locate weak point → Wait for low guard activity → Cut → Escape
   - Trade-offs: Medium time, Medium suspicion, Medium cost

2. **Guard Disguise** (`GuardDisguiseMethod.luau`)
   - Requirements: Guard uniform, ID badge
   - Steps: Acquire uniform → Acquire badge → Learn routines → Disguise → Walk out
   - Trade-offs: Short time, Very High suspicion, Medium cost

3. **Cell Digging** (`CellDiggingMethod.luau`)
   - Requirements: Digging tool, cell location, dirt disposal method
   - Steps: Acquire tool → Identify location → Dig tunnel → Dispose dirt → Escape
   - Trade-offs: Very Long time, Low suspicion, Low-Medium cost

4. **Parole** (`ParoleMethod.luau`)
   - Requirements: Rehabilitation tasks, low suspicion, parole hearing attendance
   - Steps: Complete rehab tasks → Maintain good behavior → Attend hearings → Pass evaluation → Legal release
   - Trade-offs: Long time, Low suspicion, Low cost (time investment)

5. **Cartel Breakout** (`CartelBreakoutMethod.luau`)
   - Requirements: Cartel contact, significant money/resources
   - Steps: Acquire contact → Pay cartel → Coordinate extraction → Wait → Escape via transport
   - Trade-offs: Medium-Long time, Low suspicion, Very High cost

**Base Class Requirements**:
- `getRequirements()`: Return required items/progress
- `getSteps()`: Return method steps
- `updateProgress()`: Update progress percentage
- `canComplete()`: Check if method can be completed
- `getNextItemsNeeded()`: Return items needed for next step (for cell photo)

---

### 8. Cell Photo System (Phase 3)

#### Cell Photo
**Status**: Need to create  
**Location**: `server/data/CellSystem.luau` (photo functionality)  
**Purpose**: Show escape progress to players  
**Dependencies**: Escape Method System  
**Requirements**:
- Photo interaction in each cell
- Display escape progress per method (percentage)
- Show items needed for next step per method
- Visual indicator for newer players

**Client Side**: `client/ui/CellPhotoUI.luau`
- UI for displaying progress
- Item requirements display
- Percentage indicators

---

### 9. Guard & Camera Systems (Phase 4)

#### Guard Manager
**Status**: Need to create  
**Location**: `server/systems/guards/GuardManager.luau`  
**Purpose**: Guard NPC management  
**Dependencies**: NPC System, Pathfinding  
**Requirements**:
- Guard patrol routes
- Investigation system
- Physical guard-player interactions
- Guard orders (can order inmates to leave tasks)
- Escalating responses based on suspicion

#### Camera System
**Status**: Need to create  
**Location**: `server/systems/guards/CameraSystem.luau`  
**Purpose**: Security camera monitoring  
**Dependencies**: Activity Tracker, Guard Manager  
**Requirements**:
- Camera placement in prison
- Detection of suspicious activity on camera
- Trigger guard investigation when caught on camera
- Camera monitoring zones

#### Warden AI
**Status**: Need to create  
**Location**: `server/systems/guards/WardenAI.luau`  
**Purpose**: Intelligent warden behavior  
**Dependencies**: Suspicion System, Activity Tracker  
**Requirements**:
- Tracks commonly visited areas per player/NPC
- Makes educated decisions based on suspicion levels
- Actively tries to stop suspicious behaviors
- Assigns guards based on behavior patterns
- Has daily tasks (check cameras, watch areas)
- Tasks can be identified by observant players
- Adjusts surveillance based on behavior patterns

**Critical**: Warden should be "very smart" and adaptive

---

### 10. NPC System (Phase 4)

#### NPC Manager
**Status**: Need to create  
**Location**: `server/systems/npcs/NPCManager.luau`  
**Purpose**: NPC lifecycle management  
**Dependencies**: Pathfinding Service  
**Requirements**:
- NPC spawning
- Fill empty player slots with NPCs
- NPC behavior management

#### Inmate NPC
**Status**: Need to create  
**Location**: `server/systems/npcs/InmateNPC.luau`  
**Purpose**: Inmate NPC behavior  
**Dependencies**: NPC Base, Task System, Trading System  
**Requirements**:
- Randomly buy items from common board
- Randomly take tasks from job boards
- Make it hard to tell if activity is from player or NPC
- Any action a player can do, NPCs can also do
- Appear like real prisoners trying to escape

**Solo Mode Enhancement**:
- NPCs have difficulty levels
- NPCs consider options based on available information
- Deeper information = smarter decisions
- Difficulty controls evaluation depth
- NPCs seem like real prisoners

#### NPC Pathfinding
**Status**: Need to create  
**Location**: `server/systems/npcs/NPCPathfinding.luau`  
**Purpose**: Pathfinding wrapper for NPCs  
**Dependencies**: Roblox PathfindingService  
**Requirements**:
- Efficient pathfinding for multiple NPCs
- No major obstacles in paths
- Patrol route pathfinding
- Common area navigation

---

### 11. Reporting System (Phase 4)

#### Reporting Manager
**Status**: Need to create  
**Location**: `server/systems/reporting/ReportingManager.luau`  
**Purpose**: Handle player reports  
**Dependencies**: Activity Tracker, Guard System  
**Requirements**:
- Accept player reports
- Report structure:
  - Target player (anonymous)
  - Location of activity
  - Type of behavior
  - Time of observation
- Report verification against activity log
- Report outcomes:
  - Successful report → Reward reporter
  - False report → Send reporter to solitary
- Track report history

---

### 12. Solitary & Armory System (Phase 4)

#### Solitary Confinement
**Status**: Need to create  
**Location**: `server/systems/guards/SolitarySystem.luau` (or integrated in Guard System)  
**Purpose**: Handle solitary confinement  
**Dependencies**: Guard System, Inventory System  
**Requirements**:
- Confiscate all held items (store in armory)
- Remove player from general population
- Reset escape progress (depending on method)
- Temporary restriction
- Item retrieval from armory (requires work)

#### Armory System
**Status**: Need to create  
**Location**: `server/systems/guards/ArmorySystem.luau`  
**Purpose**: Store confiscated items  
**Dependencies**: Inventory System  
**Requirements**:
- Store confiscated items
- Allow item retrieval (with effort)
- Track item ownership

---

### 13. Client Systems (Phase 5)

#### Inventory UI
**Status**: Need to create  
**Location**: `client/ui/InventoryUI.luau`  
**Purpose**: Grid-based inventory interface  
**Dependencies**: Inventory System (server)  
**Requirements**:
- Grid layout display
- Item drag-and-drop
- Item rotation
- Space highlighting
- Visual feedback

#### Task Board UI
**Status**: Need to create  
**Location**: `client/ui/TaskBoardUI.luau`  
**Purpose**: Browse and accept tasks  
**Dependencies**: Task System (server)  
**Requirements**:
- Display available tasks
- Task details (pay, suspicion, time)
- Task acceptance
- Task progress tracking

#### Trading Board UI
**Status**: Need to create  
**Location**: `client/ui/TradingBoardUI.luau`  
**Purpose**: Trading board interface  
**Dependencies**: Trading System (server)  
**Requirements**:
- Browse posted items
- Post items for sale
- Post item requests
- View receipts (hurts anonymity)
- Complete trades

#### Cell Photo UI
**Status**: Need to create  
**Location**: `client/ui/CellPhotoUI.luau`  
**Purpose**: Display escape progress  
**Dependencies**: Escape Method System (server)  
**Requirements**:
- Display progress per method (percentage)
- Show items needed for next steps
- Visual progress indicators
- Interaction with photo in cell

#### Reporting UI
**Status**: Need to create  
**Location**: `client/ui/ReportingUI.luau`  
**Purpose**: Submit reports  
**Dependencies**: Reporting System (server)  
**Requirements**:
- Select target (anonymous)
- Specify location
- Specify behavior type
- Specify observation time
- Submit report

---

### 14. Game Modes (Phase 6)

#### Free for All Mode
**Status**: Need to create  
**Location**: `server/modes/FreeForAllMode.luau`  
**Purpose**: Individual competition mode  
**Dependencies**: Game Manager  
**Requirements**:
- Individual player competition
- First to escape wins
- No team mechanics

#### Teams Mode
**Status**: Need to create  
**Location**: `server/modes/TeamsMode.luau`  
**Purpose**: Team competition mode  
**Dependencies**: Team Manager, Game Manager  
**Requirements**:
- Teams of 3
- Resources NOT pooled (individual)
- Players can see teammate inventories
- Team win condition (all members escape)
- Team communication channels

#### Solo Mode
**Status**: Need to create  
**Location**: `server/modes/SoloMode.luau`  
**Purpose**: Single player mode  
**Dependencies**: Game Manager, Enhanced NPC System  
**Requirements**:
- Single player experience
- Enhanced NPC AI with difficulty levels
- Competitive elements (leaderboards, time records)
- More NPCs for interaction

---

## Dependencies & Prerequisites

### Roblox Services Required
- `ReplicatedStorage`: Shared code storage
- `ServerScriptService`: Server-side code
- `StarterPlayer`: Client-side code
- `PathfindingService`: NPC pathfinding
- `RunService`: Game loops
- `CollectionService`: Instance tagging (optional but recommended)

### Tools Required
- **Rojo**: Code organization (already set up)
- **Luau**: Roblox's Lua dialect
- **Roblox Studio**: Development environment

### External Libraries (Optional but Recommended)
- **Promise**: Async/await patterns (useful for pathfinding, etc.)
- **Net**: Networking wrapper (simplifies RemoteEvent management)
- **Rodux**: State management (optional, for complex client state)

---

## Implementation Priority

### Phase 1: Foundation (Critical Path)
1. Event System (`shared/utils/EventBus.luau`)
2. Type Definitions (`shared/types/`)
3. Configuration Files (`shared/config/`)
4. Game Manager (`server/managers/GameManager.luau`)
5. Player Manager (`server/managers/PlayerManager.luau`)
6. Cell Manager (`server/managers/CellManager.luau`)

### Phase 2: Core Tracking (Critical Path)
1. Activity Tracker (`server/systems/activity/`)
2. Suspicion System (`server/systems/suspicion/`)
3. Item System (`server/data/ItemSystem.luau`)
4. Inventory System (`server/data/InventorySystem.luau`) - **Important: Grid-based**
5. Resource System (`server/data/ResourceSystem.luau`)

### Phase 3: Gameplay Systems (Critical Path)
1. Task System (`server/systems/tasks/`)
2. Trading System (`server/systems/trading/`) - **Important: Common board with receipts**
3. Escape Methods (`server/systems/escape/`)
4. Cell Photo System (`server/data/CellSystem.luau` photo functionality)

### Phase 4: NPC & Guard Systems
1. NPC System (`server/systems/npcs/`)
2. Guard System (`server/systems/guards/`)
3. Camera System (`server/systems/guards/CameraSystem.luau`)
4. Warden AI (`server/systems/guards/WardenAI.luau`) - **Important: Intelligent behavior**
5. Reporting System (`server/systems/reporting/`)
6. Solitary & Armory (`server/systems/guards/SolitarySystem.luau`)

### Phase 5: Client Integration
1. Inventory UI (`client/ui/InventoryUI.luau`) - **Important: Grid-based**
2. Task Board UI (`client/ui/TaskBoardUI.luau`)
3. Trading Board UI (`client/ui/TradingBoardUI.luau`)
4. Cell Photo UI (`client/ui/CellPhotoUI.luau`)
5. Reporting UI (`client/ui/ReportingUI.luau`)

### Phase 6: Game Modes
1. Free for All Mode (`server/modes/FreeForAllMode.luau`)
2. Teams Mode (`server/modes/TeamsMode.luau`)
3. Solo Mode (`server/modes/SoloMode.luau`)

---

## Key Design Considerations

### 1. Scalability
- Systems designed to handle 1-12 players
- NPCs fill empty slots seamlessly
- Efficient data structures for activity tracking
- Optimized pathfinding for multiple NPCs

### 2. Modularity
- Each escape method is independent (easy to add new ones)
- Task system is data-driven (easy to add new tasks)
- Item system is configuration-based (easy to add new items)
- Prison system is modular (easy to add new prisons)

### 3. Balance
- Escape methods have different trade-offs (not equal time)
- Suspicion system must be meaningful but not crippling
- Item economy balanced (limited items promote trading)
- Pay scale: Less suspicious = higher pay

### 4. Anonymity
- Receipts visible to all (hurts anonymity)
- Players can operate anonymously but risk being tracked
- Common board creates anonymity challenges
- Strategic players must balance anonymity vs. efficiency

### 5. Intelligence
- Warden AI must be "very smart"
- NPCs in solo mode have difficulty-based decision-making
- NPCs should seem like real prisoners

---

## What's Still Needed (Summary)

### Critical Infrastructure (Must Have First)
- [ ] Event Bus system
- [ ] Type definitions
- [ ] Configuration files structure
- [ ] Game Manager
- [ ] Player Manager

### Core Systems (High Priority)
- [ ] Activity Tracking System
- [ ] Suspicion System
- [ ] Grid-Based Inventory System
- [ ] Item System
- [ ] Resource System

### Gameplay Systems (High Priority)
- [ ] Task System (with pay scale: less suspicious = higher pay)
- [ ] Trading System (common board with receipts)
- [ ] Escape Methods (all 5 methods)
- [ ] Cell Photo System

### AI Systems (Medium Priority)
- [ ] NPC System (with solo mode AI)
- [ ] Guard System (patrols, investigations)
- [ ] Camera System
- [ ] Warden AI (intelligent behavior)

### Client Systems (Medium Priority)
- [ ] All UI components
- [ ] Input handling
- [ ] Interaction controllers

### Game Modes (Lower Priority - Can Start with One)
- [ ] Free for All Mode (start here)
- [ ] Teams Mode
- [ ] Solo Mode

---

## Next Steps

1. **Start with Phase 1**: Foundation systems (Event System, Types, Config, Managers)
2. **Then Phase 2**: Core tracking (Activity, Suspicion, Items, Inventory)
3. **Then Phase 3**: Gameplay systems (Tasks, Trading, Escape Methods)
4. **Build incrementally**: Test each system as you build it
5. **Start with one mode**: Free for All mode is simplest to start

---

**Document Version**: 1.0  
**Last Updated**: [Current Date]  
**Status**: Implementation Guide Complete
