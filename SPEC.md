# Jail Escape - Game Design Specification

## 1. Game Overview

### 1.1 Core Concept
Jail Escape is a competitive multiplayer prison break game where 1-12 players must escape from a maximum-security prison using various methods. Information warfare, resource management, and stealth are key to success.

### 1.2 Player Count
- **Minimum**: 1 player (Solo mode)
- **Maximum**: 12 players
- **Optimal**: 6-9 players

### 1.3 Win Condition
Be the first player (or team) to successfully escape the prison.

### 1.4 Game Modes
1. **Free for All**: Every player competes individually
2. **Teams**: Teams of 3 compete against each other
3. **Solo**: Single player with enhanced NPC logic and competitive elements

---

## 2. Core Mechanics

### 2.1 Starting State
- All players spawn in individual cells at the start of the game
- Each player receives basic prison uniform
- Initial resources: None (must be acquired through gameplay)
- Starting suspicion level: 0 (neutral)

### 2.2 Escape Methods
Players can escape using various methods, each with unique trade-offs:

**Primary Methods:**
1. **Fence Cutting**: Acquire cutting tools, locate weak points in perimeter fence, cut through undetected
   - **Time**: Medium
   - **Suspicion**: Medium (higher risk of being caught)
   - **Cost**: Medium (requires tools)

2. **Guard Disguise**: Steal guard uniform, acquire ID badge, walk out through main gate
   - **Time**: Short
   - **Suspicion**: Very High (guards become suspicious if caught)
   - **Cost**: Medium (requires uniform and badge)

3. **Cell Digging**: Acquire digging tools, dig tunnel from cell to outside, escape through tunnel
   - **Time**: Very Long (takes significant time to dig)
   - **Suspicion**: Low (minimal suspicion if done carefully)
   - **Cost**: Low to Medium (requires tools, must dispose of dirt)

4. **Parole**: Complete rehabilitation tasks, attend parole hearings, convince warden to grant early release
   - **Time**: Long
   - **Suspicion**: Low (requires maintaining good behavior)
   - **Cost**: Low (but requires completing many tasks)

5. **Cartel Breakout**: Contact external cartel, pay for extraction, wait for rescue
   - **Time**: Medium to Long (requires coordination)
   - **Suspicion**: Low (if done discretely)
   - **Cost**: Very High (requires significant money/resources)

**Design Notes**: 
- Methods should NOT take the same time; instead, they should have different trade-offs:
  - **Time vs. Suspicion**: Longer methods (digging) are less suspicious but take more time
  - **Cost vs. Risk**: Expensive methods (cartel) are less suspicious but require more resources
  - **High Risk, High Reward**: Quick methods (disguise) are high suspicion but fast
- Players are encouraged to attempt multiple escape methods simultaneously
- No single method should be clearly superior; all should be viable based on player preference and situation
- Game should encourage players to navigate any type of escape they want, or try multiple at once

---

## 3. Information & Reporting System

### 3.1 Reporting Mechanics
- Players can report other players' suspicious activities to the warden
- Reports must specify:
  - Target player (anonymous identifier, not name)
  - Location of suspicious activity
  - Type of suspicious behavior observed
  - Time of observation

**Activity Tracking System**:
- System maintains an array/log of player activities for each day
- Tracks all player actions: locations visited, items used, tasks completed, escape method progress
- Can filter to show specifically suspicious activities
- Reporting system references this activity log for verification
- Historical data allows players to report past suspicious behavior
- System must track: location timestamps, item interactions, task completions, escape method progress

### 3.2 Report Outcomes
- **Successful Report**: Reduces reporter's sentence time (reward)
- **False Report**: Reporter sent to solitary confinement for wasting warden's time (penalty)
- **Report Verification**: System checks if reported activity actually occurred

### 3.3 Information Warfare
- Players must hide their escape methods from others
- Observing other players' activities provides intelligence
- Sharing information with teammates (in team mode) is strategic
- False reports can be used to eliminate competition

### 3.4 Anonymity System
- Players appear as generic NPC prisoners to others
- No visible usernames or player indicators
- Players must identify others through behavior patterns
- Being identified as "a player" or "someone escaping" is dangerous

---

## 4. Suspicion System

### 4.1 Suspicion Tracking
The system tracks suspicious behavior patterns:

- **Location Frequency**: Visiting the same location multiple times per day increases suspicion
- **Contraband Possession**: Carrying illegal items (shivs, tools, outside objects) increases suspicion
- **Unusual Behavior**: Actions outside normal prisoner routine
- **Failed Actions**: Getting caught attempting escape-related activities
- **Not Getting back to jail cell on time**: Automatic solitary confinement
- **Not listening to guards commands**: Automatic solitary confinement

### 4.2 Suspicion & Guard Interaction System

**Suspicion Mechanism**:
- Suspicion represents the likelihood of being watched by guards
- Suspicion does NOT automatically send players to solitary confinement
- Guards must physically interact with player to send to solitary
- High suspicion = increased guard attention = higher chance of being caught

**Warden NPCs**:
- Warden NPCs walk around the prison with daily tasks
- Tasks include: checking cameras, watching over specific areas, patrols
- Players can observe warden behavior to identify their tasks
- Warden tasks can be exploited (e.g., avoid areas being watched)

**Camera System**:
- Security cameras placed throughout prison
- If player is caught on camera performing suspicious activity:
  - Guard is sent to investigate that location
  - Player may be caught in the act if still present
  - Investigation creates temporary high-suspicion zone

**Guard Interaction & Solitary**:
- Guards must physically approach and interact with player to send to solitary
- Items exist to affect wardens/guards:
  - Items to put guards to sleep
  - Distraction items
  - Bribes (high cost)
- If guard catches player in the act or finds evidence:
  - Guard interacts with player
  - Player sent to solitary confinement
  - All held items confiscated
  - Items stored in armory (must retrieve later)

**Solitary Confinement Consequences**:
- Player loses all held items (stored in armory)
- Must work to retrieve items from armory (takes time/effort)
- Escape progress may be reset depending on method
- Temporary removal from general population

### 4.3 Suspicion Decay
- Suspicion decreases over time when player exhibits normal behavior
- Rate of decay depends on current suspicion level
- High suspicion decays slower than low suspicion

### 4.4 Grid-Based Inventory System
- **Grid-Based Inventory**: Items take up space in a grid layout
- Players place items in inventory grid based on their size/shape
- Different items take up different amounts of space:
  - Small items (keys, pills): 1x1 grid space
  - Medium items (tools): 2x1 or 2x2 grid spaces
  - Large items (uniforms): 3x2 or 4x2 grid spaces
- Players must strategically pack items based on available space
- Exceeding inventory capacity is impossible (hard limit)
- Items can be hidden in cells or caches throughout prison when not in inventory
- Smart packing and space management becomes a strategic element

---

## 5. Resource Management

### 5.1 Currency & Trading System

**Money**:
- Primary out-of-jail currency
- Used for trading between players
- Used occasionally for NPC trading
- Obtained from: tasks, trading, stealing, cartel payouts

**Item-Based Trading**:
- **Ramen is NOT the primary trade value**
- NPCs want specific items for specific services:
  - Example: One NPC wants "Gum" for causing a scene in courtyard
  - Example: Another NPC wants "Ramen" for a lock pick
  - Example: Cartel might want "Money" for escape service
- Each NPC has unique item preferences for services
- Promotes strategic item collection and trading

**Item Tracking System**:
- Internal system tracks all items within the prison
- System controls item availability to promote communication
- Limited items encourage player interaction and trading
- Item scarcity creates meaningful choices

**Common Cell Trading Board**:
- Common cell area with prisoner NPC acting as a trading board
- Players can anonymously post:
  - Items they need (buying requests)
  - Items they're selling
  - Trade offers
- Anyone can view all transactions and requests
- Transactions can be completed anonymously
- **Receipts System**: All transactions are logged with receipts
- Receipts are visible to everyone (hurts anonymity)
- Players can see what items others bought/sold
- Strategic players must balance anonymity vs. using the board
- Board creates a hub for resource exchange
- Direct player-to-player and player-to-NPC trading still available

### 5.2 Task System
Tasks are the primary way to earn money and resources:

**Task Distribution**:
- **Illegal Jobs**: Available on job boards (medium suspicion, good pay)
- **Super Illegal Jobs**: Done by gang members (high suspicion, very good pay)
- **Common Tasks**: Given to prisoners (most common type)

**Pay Scale**:
- **Less Suspicious = Higher Pay**
- Examples:
  - **Wood Working**: Low suspicion, High pay (skilled, legitimate work)
  - **Cleaning Bathroom**: Higher suspicion, Low pay (unpleasant but necessary)
  - **Library Organization**: Low suspicion, Medium-High pay
  - **Contraband Smuggling**: High suspicion, Very High pay

**Task Mechanics**:
- Tasks appear on job boards throughout prison
- Tasks have time requirements and difficulty levels
- Completion rewards vary by task type and suspicion level
- Some tasks require specific skills or items
- Tasks can be shared/competed for by multiple players
- Gang member NPCs may offer special high-risk, high-reward tasks

### 5.3 NPC Interactions

#### 5.3.1 Inmate NPCs
- **Distraction Services**: Pay NPCs to cause distractions (e.g., 4 ramen = 1 hour distraction)
- **Information Brokers**: Sell information about guard schedules, weak points, etc.
- **Item Traders**: Buy/sell contraband and tools
- **Task Providers**: Offer specialized tasks with unique rewards

#### 5.3.2 Commissary System
- Players can order items during conjugal visits
- Items arrive after a delay (realistic delivery time)
- Requires money earned from tasks or trading
- Items can be intercepted if suspicion is high

#### 5.3.3 Guard NPCs
- Patrol routes using pathfinding
- React to suspicious behavior
- Can be bribed (high cost, high risk)
- Must be avoided or neutralized for certain escape methods
- If suspicion is higher the guard might order a inmate to leave there current task

---

## 6. Escape Method Details

### 6.1 Fence Cutting Method
**Requirements**:
- Cutting tool (wire cutters, saw, etc.)
- Knowledge of fence weak points
- Low guard presence at target location
- Sufficient time to complete cutting

**Steps**:
1. Acquire cutting tool (task reward, NPC trade, or steal)
2. Locate fence weak point (exploration or NPC information)
3. Wait for low guard activity (timing critical)
4. Cut fence section (takes time, makes noise)
5. Escape through opening

**Trade-offs**:
- **Time**: Medium duration
- **Suspicion**: Medium (risk of being caught on camera or by patrol)
- **Cost**: Medium (requires specific tools)
- **Skill**: Requires timing and awareness of guard patrols

### 6.2 Guard Disguise Method
**Requirements**:
- Guard uniform (stolen from locker room or guard)
- Guard ID badge (stolen or forged)
- Knowledge of guard routines
- Successfully avoid guard suspicion

**Steps**:
1. Acquire guard uniform (stealth or distraction required)
2. Acquire/forge ID badge
3. Learn guard patrol patterns and routines
4. Disguise as guard during shift change
5. Walk out through main gate

**Trade-offs**:
- **Time**: Short duration (fastest method)
- **Suspicion**: Very High (guards become extremely suspicious if caught)
- **Cost**: Medium (requires uniform and badge)
- **Skill**: Requires perfect timing and behavior mimicry

### 6.3 Cell Digging Method
**Requirements**:
- Digging tool (shovel, pickaxe, improvised tool)
- Cell location suitable for digging
- Significant time to dig tunnel
- Method to dispose of dirt quietly

**Steps**:
1. Acquire digging tool
2. Identify dig location in cell
3. Dig tunnel (takes very long time, produces dirt)
4. Dispose of dirt (flush, hide, or trade)
5. Escape through tunnel

**Trade-offs**:
- **Time**: Very Long (slowest method)
- **Suspicion**: Low (minimal suspicion if done carefully and discretely)
- **Cost**: Low to Medium (requires tools, must dispose of dirt)
- **Skill**: Requires patience and careful dirt disposal

### 6.4 Parole Method
**Requirements**:
- Complete many rehabilitation tasks
- Maintain low suspicion throughout
- Attend scheduled parole hearings
- Convince warden through behavior and task completion

**Steps**:
1. Complete rehabilitation program tasks
2. Maintain good behavior (low suspicion critical)
3. Attend scheduled parole hearings
4. Pass warden's evaluation
5. Walk out legally

**Trade-offs**:
- **Time**: Long duration (many tasks required)
- **Suspicion**: Low (requires maintaining good behavior)
- **Cost**: Low (mostly time investment)
- **Skill**: Requires consistency and task management

### 6.5 Cartel Breakout Method
**Requirements**:
- Contact external cartel (through NPC or item)
- Pay significant money/resources for extraction
- Coordinate extraction time and location
- Maintain secrecy until extraction

**Steps**:
1. Acquire cartel contact (through tasks, NPC, or item)
2. Pay cartel for extraction service (very high cost)
3. Coordinate extraction location and time
4. Wait for cartel to arrive (medium-long wait time)
5. Escape via cartel vehicle/transport

**Trade-offs**:
- **Time**: Medium to Long (requires coordination and waiting)
- **Suspicion**: Low (if done discretely, minimal suspicious activity)
- **Cost**: Very High (requires significant money/resources)
- **Skill**: Requires resource management and timing

### 6.6 Multiple Method Strategy
- Players can and should attempt multiple escape methods simultaneously
- Progress on multiple methods provides backup options
- Different methods can complement each other (items from one help another)
- Game encourages experimentation and flexible strategies

---

## 7. Game Modes

### 7.1 Free for All Mode
- Every player competes individually
- No team coordination
- Maximum information warfare
- First to escape wins
- 1-12 players

### 7.2 Teams Mode
- Players divided into teams of 3
- Teams compete to be first to have all members escape
- Win condition: Entire team escapes (or first team with all members out)
- 6-12 players (2-4 teams)

**Team Mechanics**:
- Resources are NOT pooled (each player manages own resources)
- Players can see teammates' inventories (transparency within team)
- Team communication channels
- Coordinated escape attempts
- Team members can share information about escape methods and items
- Team members can trade items/resources directly

**Implementation Note**: 
- Start with one game mode first (recommend Free for All)
- Add additional modes (Teams, Solo) after core mechanics are solid
- Resources remain individual even in team mode

### 7.3 Solo Mode
- Single player experience
- Enhanced NPC logic and behavior
- Competitive elements (leaderboards, time records)
- More challenging but fair experience
- 1 player

**Solo Mode Enhancements**:
- More NPCs to interact with
- More complex NPC behaviors
- Time-based scoring system
- Achievement system

---

## 8. Prison Layout & Environment

### 8.1 Prison Structure
Single prison map with the following areas:

- **Cell Block**: Individual cells for each player
- **Common Areas**: Cafeteria, yard, library, gym
- **Administrative**: Warden's office, guard stations, security room
- **Service Areas**: Kitchen, laundry, maintenance
- **Perimeter**: Fence, gates, guard towers
- **Restricted Areas**: Solitary confinement, medical bay

### 8.2 Pathfinding Requirements
- NPCs use pathfinding to navigate between locations
- No major obstacles in NPC paths
- Guards follow patrol routes
- Inmates move between common areas
- Pathfinding must be efficient and reliable

### 8.3 Interactive Elements
- Lockers (for storing items)
- Job boards (for tasks)
- Vending machines (for purchases)
- Guard stations (for reporting)
- Fence sections (for cutting)
- Cell fixtures (for digging)

---

## 9. Technical Requirements

### 9.1 Core Systems
- **Player Management**: Spawn, respawn, team assignment, cell assignment
- **Suspicion System**: Behavior tracking, level calculation, guard interaction, camera detection
- **Reporting System**: Report submission, verification, outcomes
- **Activity Tracking System**: Array/log of player activities per day, tracking locations, items, tasks, escape progress
- **Task System**: Task generation, assignment, completion tracking, reward distribution
- **NPC System**: Pathfinding, behavior trees, interactions, task assignment
- **Item System**: Grid-based inventory, item properties, space management
- **Escape System**: Method tracking, progress, completion, multiple simultaneous methods
- **Resource System**: Money management, item-based trading, item tracking, common cell board
- **Trading System**: Player-to-player, player-to-NPC, common cell board, receipt system
- **Guard System**: Warden NPCs, patrol routes, camera monitoring, investigation system
- **Solitary System**: Confiscation, armory storage, item retrieval

**Player Progress Tracking**:
- System tracks completed tasks and escape method progress for reporting verification
- Players can report others based on observed activities
- System must verify reports against tracked activities
- Historical data allows reporting of past suspicious behavior

**Cell Photo System**:
- In each player's cell, there is a photo by the sink
- Players can interact with the photo to view escape progress
- Photo shows:
  - How close player is to escaping via different routes
  - What items are needed next for specific routes
  - Percentage completion for each escape method
- Helps newer players understand progression paths
- Visual indicator of escape method advancement
- Strategic tool for planning next steps

### 9.2 Data Persistence
- Player progress (suspicion, resources, escape progress)
- Game state (tasks, NPC states, events)
- Match history (for solo mode leaderboards)

### 9.3 Networking
- Client-server architecture
- Replication for game state
- Anti-cheat considerations
- Lag compensation for time-sensitive actions

### 9.4 Performance
- Efficient pathfinding for multiple NPCs
- Optimized suspicion calculations
- Smooth gameplay at 12 players
- Minimal lag during escape attempts

---

## 10. Balance Considerations

### 10.1 Escape Method Balance
- Methods should NOT take the same time; instead they should have different trade-offs
- **Balance through Risk vs. Reward**:
  - Long methods (digging) = Low suspicion but High time investment
  - Quick methods (disguise) = High suspicion but Low time investment
  - Expensive methods (cartel) = Low suspicion but High resource cost
  - Consistent methods (parole) = Low suspicion but High time and task requirements
- Each method should have unique risks and rewards
- No single method should be clearly superior in all situations
- Methods should require different skill sets and strategies
- Players should be encouraged to attempt multiple methods simultaneously
- Balance creates variety and prevents meta dominance

### 10.2 Resource Economy
- Task rewards balanced against item costs
- NPC service costs proportional to value
- Money earning rate balanced with spending needs
- Resource scarcity creates meaningful choices

### 10.3 Suspicion Balance
- Suspicion increases should be meaningful but not crippling
- Decay rate prevents permanent punishment
- High-risk, high-reward activities should exist
- False reports should have appropriate penalties

### 10.4 Information Balance
- Observing others should be rewarding but risky
- Reporting should be strategic, not spammy
- Anonymity should be maintainable but not guaranteed
- Information should be valuable but not game-breaking

### 10.5 Experience vs. New Players
- Tutorial system for new players
- Clear progression paths
- Experienced players have advantages but not insurmountable
- Multiple viable strategies prevent meta dominance

---

## 11. Task Design

### 11.1 Task Categories

#### Labor Tasks
- Kitchen prep (30 min, $5, low suspicion)
- Laundry duty (45 min, $7, low suspicion)
- Cleaning detail (20 min, $4, low suspicion)
- Maintenance work (60 min, $10, low suspicion)

#### Skilled Tasks
- Library organization (40 min, $8, medium suspicion)
- Education tutoring (50 min, $10, medium suspicion)
- Administrative filing (35 min, $7, medium suspicion)
- Medical assistance (45 min, $9, medium suspicion)

#### Illegal Tasks
- Contraband smuggling (20 min, $15, high suspicion)
- Information gathering (30 min, $12, high suspicion)
- Distraction creation (15 min, $10, high suspicion)
- Item theft (25 min, $14, high suspicion)

#### Rehabilitation Tasks
- Group therapy (60 min, $3, reduces suspicion)
- Educational courses (90 min, $5, reduces suspicion)
- Community service (120 min, $8, reduces suspicion)
- Behavior modification (45 min, $2, reduces suspicion)

### 11.2 Task Mechanics
- Tasks appear dynamically based on game state
- Some tasks require prerequisites
- Tasks can be competed for by multiple players
- Task availability changes based on time of day
- Special events create unique tasks

### 11.3 Task Rewards
- Money (primary reward)
- Items (tools, materials, consumables)
- Information (guard schedules, weak points)
- Reputation (affects NPC interactions)
- Suspicion reduction (rehabilitation tasks)

---

## 12. NPC Behavior

### 12.1 Guard NPCs
- Follow patrol routes using pathfinding
- React to suspicious behavior
- Conduct random searches
- Respond to reports
- Can be distracted or bribed
- Escalate response based on suspicion level

### 12.2 Inmate NPCs
- Move between common areas using pathfinding
- Offer services (distractions, information, trading)
- Have daily routines that appear realistic
- React to player actions

**Trading & Task Behavior**:
- NPCs randomly buy items from common cell board
- NPCs randomly take tasks from job boards
- Makes it difficult to tell if board activity is from player or NPC
- Any action a player can theoretically do, NPCs can also do
- NPCs create realistic prison population feel

**Solo Mode Enhanced AI**:
- NPCs have difficulty levels that affect decision-making
- NPCs consider options based on available information within prison
- NPCs make decisions based on depth of available information
- Deeper information = smarter NPC decisions
- Difficulty controls how NPCs evaluate options
- Daily actions controlled by NPC decision-making system
- NPCs should seem like real prisoners attempting to escape
- Creates competitive environment even in solo mode

**Communication**:
- NPCs may report suspicious behavior
- NPCs can be recruited for assistance (with proper payment/items)
- NPCs have memory of player interactions

### 12.3 Warden NPC (Intelligent AI)
- Processes reports from players and NPCs
- Conducts parole hearings
- Makes escape-related decisions based on suspicion levels
- Has office in administrative area
- Can be observed for information about tasks and behaviors

**Intelligent Behavior**:
- Warden makes educated decisions based on player/NPC suspicion levels
- Tracks commonly visited areas by each player/NPC
- Identifies suspicious behavior patterns
- Actively tries to stop suspicious behaviors
- Assigns guards to investigate high-suspicion areas
- Adjusts surveillance based on behavior patterns
- Very smart decision-making that adapts to player actions
- Warden tasks can be identified by observant players
- Warden may increase surveillance on players showing patterns

---

## 13. Time System

### 13.1 Accelerated Time
- Game uses accelerated time scale
- 1 game hour = ~5-10 real minutes (to be balanced)
- Day/night cycles affect gameplay
- Some activities only available at certain times
- Tasks have time requirements in game time

### 13.2 Time-Based Events
- Meal times (cafeteria access)
- Yard time (outdoor activities)
- Lockdown periods (restricted movement)
- Shift changes (guard rotations)
- Conjugal visits (item ordering)

---

## 14. Future Expansion Considerations

### 14.1 Multiple Prisons (Modular Design)
- **Modular Prison System**: Code should be designed to easily integrate other prisons
- Each prison can have:
  - Different layouts and structures
  - Varying difficulty levels
  - Unique escape methods or variants
  - Prison-specific mechanics and items
- Current implementation: Single prison only
- Menu system will eventually allow prison selection
- For now, while no hub exists, this is the only available prison
- Design for modularity from the start to facilitate future expansion

### 14.2 Additional Escape Methods
- Helicopter escape
- Sewer system escape
- Hostage situation
- Riot-based escape

### 14.3 Advanced Features
- Weather system (affects escape methods)
- Dynamic events (prison transfers, inspections)
- Character progression (skills, abilities)
- Customization (prisoner appearance, cell decoration)

---

## 15. Game Initialization & Player Management

### 15.1 Player Joining System
- **Current State**: No hub exists yet; build as if waiting for players
- **Joining Window**: Game waits up to 10 seconds after first player joins
- **Player Assignment**: System decides which cell each player should occupy
- **Fill Empty Slots**: If game doesn't fill to 12 players, remaining slots filled with NPCs
- **NPC Escapers**: NPCs placed in empty slots will attempt to escape like players
- **Match Start**: Game begins after 10-second window or when 12 players join (whichever comes first)

### 15.2 Cell Assignment
- System assigns players to cells based on:
  - Player count
  - Team assignments (if team mode)
  - Ensuring balanced distribution
- NPCs assigned to remaining cells
- Each player gets individual cell with photo system

### 15.3 Hub Integration (Future)
- Will eventually connect to hub where players queue for games
- Hub will manage matchmaking and player count
- Current system designed to work standalone until hub is ready

---

## 16. Implementation Phases

### Phase 1: Core Systems
- Basic prison layout
- Player spawning and movement
- Cell system
- Basic suspicion tracking
- Simple task system

### Phase 2: Escape Methods
- Implement all four escape methods
- Tool/item system
- Escape completion logic
- Method-specific mechanics

### Phase 3: Advanced Systems
- Reporting system
- NPC pathfinding and behavior
- Resource management
- Commissary system

### Phase 4: Game Modes
- Free for All mode
- Teams mode
- Solo mode enhancements

### Phase 5: Polish & Balance
- Task variety expansion
- Suspicion system refinement
- Balance tuning
- Performance optimization

### Phase 6: Testing & Iteration
- Playtesting
- Bug fixes
- Balance adjustments
- Player feedback integration

---

## 17. Success Metrics

### 16.1 Balance Metrics
- Average escape time per method (should be similar)
- Win rate by method (should be balanced)
- Resource economy health
- Suspicion system effectiveness

### 16.2 Engagement Metrics
- Average session length
- Player retention
- Task completion rates
- Escape attempt frequency

### 16.3 Fun Metrics
- Player enjoyment surveys
- Replayability indicators
- Strategic depth assessment
- Social interaction frequency

---

## 18. Appendix A: Glossary

- **Contraband**: Illegal items (tools, weapons, outside objects)
- **Suspicion**: Measure of how suspicious a player's behavior is
- **Solitary Confinement**: Punishment area, restricts movement and resets progress
- **Commissary**: Prison store where items can be ordered
- **Conjugal Visit**: Scheduled event where items can be ordered
- **Parole**: Legal method of early release
- **Shiv**: Improvised weapon, increases suspicion if found
- **Distraction**: NPC-caused event that draws guard attention
- **Report**: Player-submitted information about suspicious activity

---

## 19. Appendix B: Design Principles

1. **Information is King**: Knowledge and observation are powerful tools
2. **Risk vs. Reward**: Higher risk activities should offer greater rewards
3. **Multiple Paths to Victory**: No single dominant strategy
4. **Meaningful Choices**: Every decision should matter
5. **Fair Competition**: Balance ensures skill determines winners
6. **Emergent Gameplay**: Systems interact to create unexpected situations
7. **Player Agency**: Players control their own destiny
8. **Social Dynamics**: Player interactions create interesting scenarios

---

**Document Version**: 2.0  
**Last Updated**: [Current Date]  
**Status**: Updated - Incorporating Player Feedback
