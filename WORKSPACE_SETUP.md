# Workspace Setup Guide

## Overview

This document outlines all the physical elements you need to build in Roblox Studio before Phase 2 can begin. The code references these elements, so they must exist in your workspace.

**Important**: Use CollectionService tags to identify elements. Name parts consistently for easy identification.

---

## Required Workspace Structure

```
Workspace/
├── Prison/
│   ├── CellBlock/
│   │   └── Cells/ (24 cells)
│   ├── CommonAreas/
│   │   ├── Cafeteria
│   │   ├── Yard
│   │   ├── Library
│   │   ├── Gym
│   │   └── CommonCell (Trading Board Location)
│   ├── Administrative/
│   │   ├── WardenOffice
│   │   ├── GuardStations/ (3 stations)
│   │   └── SecurityRoom
│   ├── ServiceAreas/
│   │   ├── Kitchen
│   │   ├── Laundry
│   │   └── Maintenance
│   ├── RestrictedAreas/
│   │   ├── SolitaryConfinement/ (4 cells)
│   │   ├── MedicalBay
│   │   └── Armory
│   └── Perimeter/
│       ├── Fence (with weak points)
│       ├── MainGate
│       └── GuardTowers/ (4 towers)
├── InteractiveElements/
│   ├── TaskBoards/ (3 boards)
│   ├── TradingBoard (in CommonCell)
│   ├── Lockers/ (20 lockers)
│   ├── VendingMachines/ (5 machines)
│   └── CellPhotos/ (24 photos, one per cell)
├── Security/
│   ├── Cameras/ (Multiple camera parts)
│   └── PatrolRoutes/ (Waypoints for guards)
└── SpawnPoints/
    ├── PlayerSpawns/ (Optional, or spawn in cells)
    ├── GuardSpawns/
    ├── InmateNPCSpawns/
    └── WardenSpawn
```

---

## 1. Cell Block (CRITICAL - Phase 1 Already Uses This)

### Requirements
- **24 Individual Cells** (Minimum)
- Each cell should be approximately 4x8x6 studs
- Each cell needs a door that can be opened/closed
- Cells should be arranged in a cell block

### Cell Setup Per Cell:
1. **Cell Part/Folder**
   - Name: `Cell_1`, `Cell_2`, etc.
   - Tag: `Cell`
   - Attribute: `CellId` (number: 1-24)

2. **Cell Floor** (BasePart)
   - Anchor the floor
   - Tag: `CellFloor`

3. **Cell Door** (BasePart)
   - Make it openable/closable
   - Tag: `CellDoor`
   - Attribute: `CellId` (matching cell)

4. **Cell Photo** (BasePart - ClickDetector or ProximityPrompt)
   - Place near a sink or wall
   - Name: `CellPhoto`
   - Tag: `CellPhoto`
   - Attribute: `CellId` (matching cell)
   - **This is critical** - players interact with this to see escape progress

5. **Cell Spawn Point** (Optional SpawnLocation or BasePart)
   - Where player spawns in cell
   - Tag: `PlayerSpawn`
   - Attribute: `CellId`

### Example Setup:
```
CellBlock/
└── Cells/
    ├── Cell_1/
    │   ├── Floor (Part, tagged "CellFloor")
    │   ├── Door (Part, tagged "CellDoor", Attribute: CellId = 1)
    │   ├── CellPhoto (Part, tagged "CellPhoto", Attribute: CellId = 1)
    │   └── SpawnPoint (Part or SpawnLocation, tagged "PlayerSpawn", Attribute: CellId = 1)
    ├── Cell_2/
    └── ... (continue for 24 cells)
```

---

## 2. Common Areas

### 2.1 Cafeteria
- **Location Marker**: BasePart (invisible or visible)
- **Tag**: `CommonArea`
- **Attribute**: `AreaName` = "Cafeteria"
- **Size**: Should accommodate 12+ players
- **Purpose**: Meal times, main job board location

### 2.2 Yard
- **Location Marker**: BasePart or region
- **Tag**: `CommonArea`
- **Attribute**: `AreaName` = "Yard"
- **Size**: Should accommodate 20+ players
- **Purpose**: Outdoor activities, recreation

### 2.3 Library
- **Location Marker**: BasePart or region
- **Tag**: `CommonArea`
- **Attribute**: `AreaName` = "Library"
- **Size**: Should accommodate 8+ players
- **Purpose**: Education tasks, library job board

### 2.4 Gym
- **Location Marker**: BasePart or region
- **Tag**: `CommonArea`
- **Attribute**: `AreaName` = "Gym"
- **Size**: Should accommodate 10+ players
- **Purpose**: Exercise, recreation

### 2.5 Common Cell (Trading Board Location)
- **Location Marker**: BasePart or region
- **Tag**: `CommonArea`
- **Attribute**: `AreaName` = "CommonCell"
- **Size**: Should accommodate 15+ players
- **Purpose**: Trading board hub
- **Must contain**: Trading Board (see Interactive Elements)

---

## 3. Administrative Areas

### 3.1 Warden's Office
- **Location Marker**: BasePart or folder
- **Tag**: `AdministrativeArea`
- **Attribute**: `AreaName` = "WardenOffice"
- **Purpose**: Warden NPC location, parole hearings
- **Contains**: Desk, chair, office props

### 3.2 Guard Stations (3 stations)
- **Location Marker**: BasePart per station
- **Tag**: `GuardStation`
- **Attribute**: `StationId` (1, 2, 3)
- **Purpose**: Reporting system, guard interactions
- **Must have**: ProximityPrompt or ClickDetector for reporting

### 3.3 Security Room
- **Location Marker**: BasePart or folder
- **Tag**: `AdministrativeArea`
- **Attribute**: `AreaName` = "SecurityRoom"
- **Purpose**: Camera monitoring center (for warden tasks)

---

## 4. Service Areas

### 4.1 Kitchen
- **Location Marker**: BasePart or region
- **Tag**: `ServiceArea`
- **Attribute**: `AreaName` = "Kitchen"
- **Purpose**: Kitchen prep tasks

### 4.2 Laundry
- **Location Marker**: BasePart or region
- **Tag**: `ServiceArea`
- **Attribute**: `AreaName` = "Laundry"
- **Purpose**: Laundry duty tasks

### 4.3 Maintenance
- **Location Marker**: BasePart or region
- **Tag**: `ServiceArea`
- **Attribute**: `AreaName` = "Maintenance"
- **Purpose**: Maintenance tasks, maintenance job board

---

## 5. Restricted Areas

### 5.1 Solitary Confinement (4 cells)
- **Location Marker**: BasePart per cell
- **Tag**: `SolitaryCell`
- **Attribute**: `SolitaryCellId` (1-4)
- **Purpose**: Punishment area
- **Each cell**: Door, floor, spawn point

### 5.2 Medical Bay
- **Location Marker**: BasePart or region
- **Tag**: `RestrictedArea`
- **Attribute**: `AreaName` = "MedicalBay"
- **Purpose**: Medical care

### 5.3 Armory
- **Location Marker**: BasePart or region
- **Tag**: `RestrictedArea`
- **Attribute**: `AreaName` = "Armory"
- **Purpose**: Confiscated item storage
- **Must have**: ProximityPrompt or ClickDetector for item retrieval

---

## 6. Perimeter

### 6.1 Fence
- **Type**: Multiple Parts or MeshPart
- **Tag**: `PerimeterFence`
- **Must have**: **3 Weak Points** (for fence cutting escape method)
  - Tag weak points: `FenceWeakPoint`
  - Attribute: `WeakPointId` (1, 2, 3)
  - Make these sections visually different or tag them

### 6.2 Main Gate
- **Location Marker**: BasePart or folder
- **Tag**: `MainGate`
- **Purpose**: Main entrance/exit (for guard disguise escape)
- **Must have**: Gate mechanism (door/barrier)

### 6.3 Guard Towers (4 towers)
- **Location Marker**: BasePart per tower
- **Tag**: `GuardTower`
- **Attribute**: `TowerId` (1-4)
- **Purpose**: Guard patrol points, surveillance

---

## 7. Interactive Elements

### 7.1 Task Boards (3 boards)
- **Type**: BasePart with ProximityPrompt or ClickDetector
- **Tag**: `TaskBoard`
- **Attribute**: `BoardId` (1, 2, 3)
- **Attribute**: `Location` ("cafeteria", "library", "maintenance")
- **Purpose**: Display and accept tasks
- **Must be placed in**:
  - Cafeteria (Main Job Board)
  - Library (Library Job Board)
  - Maintenance (Maintenance Job Board)

### 7.2 Trading Board (In Common Cell)
- **Type**: BasePart with ProximityPrompt or ClickDetector
- **Tag**: `TradingBoard`
- **Attribute**: `Location` = "CommonCell"
- **Purpose**: Common trading hub, anonymous trading
- **Must be placed in**: Common Cell area

### 7.3 Lockers (20 lockers)
- **Type**: BasePart per locker with ProximityPrompt or ClickDetector
- **Tag**: `Locker`
- **Attribute**: `LockerId` (1-20)
- **Purpose**: Item storage
- **Must have**: Open/close mechanism

### 7.4 Vending Machines (5 machines)
- **Type**: BasePart per machine with ProximityPrompt or ClickDetector
- **Tag**: `VendingMachine`
- **Attribute**: `MachineId` (1-5)
- **Purpose**: Commissary purchases

### 7.5 Cell Photos (24 photos, one per cell)
- **Type**: BasePart with ProximityPrompt or ClickDetector
- **Tag**: `CellPhoto`
- **Attribute**: `CellId` (1-24)
- **Purpose**: Display escape progress to players
- **Must be placed in**: Each cell (see Cell Block section)

---

## 8. Security System

### 8.1 Security Cameras
- **Type**: BasePart per camera
- **Tag**: `SecurityCamera`
- **Attribute**: `CameraId` (unique ID)
- **Attribute**: `Location` ("cafeteria", "yard", "perimeter", "mainGate", etc.)
- **Attribute**: `CoverageRange` (number in studs)
- **Purpose**: Detect suspicious activity
- **Recommended locations**:
  - Cafeteria (coverage: 50 studs)
  - Yard (coverage: 60 studs)
  - Perimeter fence (coverage: 100 studs)
  - Main Gate (coverage: 30 studs)
  - Additional cameras as needed

### 8.2 Guard Patrol Routes
- **Type**: Multiple Parts or SpawnLocations (waypoints)
- **Tag**: `PatrolWaypoint`
- **Attribute**: `RouteId` (string: "MainPerimeter", "CellBlockA", "CellBlockB", etc.)
- **Attribute**: `WaypointIndex` (number, order in route)
- **Purpose**: Guards follow these routes using pathfinding
- **Must have**: No major obstacles between waypoints

**Example Setup**:
```
PatrolRoutes/
├── MainPerimeter/
│   ├── Waypoint_1 (Part, tagged "PatrolWaypoint", RouteId="MainPerimeter", Index=1)
│   ├── Waypoint_2 (Part, RouteId="MainPerimeter", Index=2)
│   └── ...
├── CellBlockA/
│   ├── Waypoint_1 (Part, RouteId="CellBlockA", Index=1)
│   └── ...
└── CellBlockB/
    └── ...
```

---

## 9. Spawn Points

### 9.1 Player Spawns
- **Option 1**: Spawn directly in cells (recommended)
  - Use cell spawn points (see Cell Block section)
- **Option 2**: Separate spawn area
  - Tag: `PlayerSpawn`
  - Then teleport to assigned cell

### 9.2 Guard Spawns
- **Type**: SpawnLocation or BasePart
- **Tag**: `GuardSpawn`
- **Purpose**: Where guard NPCs spawn
- **Quantity**: Multiple spawn points

### 9.3 Inmate NPC Spawns
- **Type**: SpawnLocation or BasePart
- **Tag**: `InmateNPCSpawn`
- **Purpose**: Where inmate NPCs spawn
- **Quantity**: Multiple spawn points

### 9.4 Warden Spawn
- **Type**: SpawnLocation or BasePart
- **Tag**: `WardenSpawn`
- **Purpose**: Where warden NPC spawns
- **Quantity**: 1 spawn point (in or near Warden's Office)

---

## 10. Tags and CollectionService

### Required Tags (Add using CollectionService)

**Area Tags**:
- `Cell`
- `CommonArea`
- `AdministrativeArea`
- `ServiceArea`
- `RestrictedArea`

**Interactive Element Tags**:
- `CellPhoto`
- `TaskBoard`
- `TradingBoard`
- `Locker`
- `VendingMachine`
- `GuardStation`
- `CellDoor`
- `CellFloor`

**Security Tags**:
- `SecurityCamera`
- `PatrolWaypoint`
- `FenceWeakPoint`
- `MainGate`
- `GuardTower`

**Spawn Tags**:
- `PlayerSpawn`
- `GuardSpawn`
- `InmateNPCSpawn`
- `WardenSpawn`

---

## 11. Attributes (Required)

### Cell Attributes:
- `CellId` (number): 1-24, unique per cell

### Area Attributes:
- `AreaName` (string): "Cafeteria", "Yard", "Library", etc.

### Task Board Attributes:
- `BoardId` (number): 1-3
- `Location` (string): Area where board is located

### Camera Attributes:
- `CameraId` (string): Unique identifier
- `Location` (string): Area camera monitors
- `CoverageRange` (number): Detection range in studs

### Patrol Waypoint Attributes:
- `RouteId` (string): Route name
- `WaypointIndex` (number): Order in route

### Fence Weak Point Attributes:
- `WeakPointId` (number): 1-3

### Guard Station Attributes:
- `StationId` (number): 1-3

### Locker Attributes:
- `LockerId` (number): 1-20

### Vending Machine Attributes:
- `MachineId` (number): 1-5

### Guard Tower Attributes:
- `TowerId` (number): 1-4

### Solitary Cell Attributes:
- `SolitaryCellId` (number): 1-4

---

## 12. Minimum Requirements for Phase 2

### Must Have (Critical):
1. ✅ **24 Cells** - Players spawn here
2. ✅ **Cell Photos** - 24 photos (one per cell) for escape progress display
3. ✅ **Task Boards** - At least 1 task board (in cafeteria)
4. ✅ **Trading Board** - In Common Cell area
5. ✅ **Guard Stations** - At least 1 for reporting system
6. ✅ **Camera System** - At least 1 camera (for suspicion system)
7. ✅ **Common Areas** - At least Cafeteria and Yard
8. ✅ **Perimeter Fence** - With at least 1 weak point
9. ✅ **Main Gate** - For guard disguise escape method

### Should Have (Important):
1. **Lockers** - At least 5 for item storage
2. **More Task Boards** - Library and Maintenance boards
3. **More Cameras** - Cafeteria, Yard, Perimeter
4. **Guard Patrol Routes** - At least 1 patrol route
5. **Solitary Confinement** - At least 1 solitary cell
6. **Armory** - For confiscated items

### Nice to Have (Can Add Later):
1. All 4 guard towers
2. All 20 lockers
3. All 5 vending machines
4. Medical bay
5. All service areas (Kitchen, Laundry, Maintenance)
6. All common areas (Library, Gym)

---

## 13. Testing Checklist

Before Phase 2, verify:
- [ ] All 24 cells exist and are tagged
- [ ] All 24 cell photos exist and are tagged
- [ ] At least 1 task board exists and is tagged
- [ ] Trading board exists in Common Cell and is tagged
- [ ] At least 1 guard station exists and is tagged
- [ ] At least 1 camera exists and is tagged
- [ ] Perimeter fence exists with at least 1 weak point
- [ ] Main gate exists and is tagged
- [ ] Common areas (Cafeteria, Yard) are tagged
- [ ] Player spawns work (can spawn in cells or spawn area)

---

## 14. Notes

### Pathfinding Requirements
- Ensure guards can pathfind between waypoints
- No major obstacles blocking patrol routes
- Doors should be openable by guards or automatically open

### Cell Photo Placement
- Place near sink or prominent wall in each cell
- Make it clearly interactive (ProximityPrompt or ClickDetector)
- Visual: Could be a picture frame or poster

### Task Board Visual
- Should look like a job board or bulletin board
- Clear visual indication that it's interactive
- Can be a simple Part with ProximityPrompt

### Trading Board Visual
- Should be distinct from task boards
- Located in Common Cell area
- Large enough for multiple players to interact

---

## 15. Quick Reference

**Minimum Setup for Phase 2**:
1. 24 Cells (tagged `Cell`, Attribute `CellId`)
2. 24 Cell Photos (tagged `CellPhoto`, Attribute `CellId`)
3. 1 Task Board in Cafeteria (tagged `TaskBoard`)
4. 1 Trading Board in Common Cell (tagged `TradingBoard`)
5. 1 Guard Station (tagged `GuardStation`)
6. 1 Camera (tagged `SecurityCamera`)
7. Cafeteria area (tagged `CommonArea`, Attribute `AreaName` = "Cafeteria")
8. Yard area (tagged `CommonArea`, Attribute `AreaName` = "Yard")
9. Perimeter Fence with 1 weak point (tagged `FenceWeakPoint`)
10. Main Gate (tagged `MainGate`)

Once these exist, Phase 2 can begin! Additional elements can be added as development continues.

---

**Document Version**: 1.0  
**Last Updated**: [Current Date]  
**Status**: Ready for Workspace Setup
