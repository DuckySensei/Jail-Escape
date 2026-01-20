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
Players can escape using one of four primary methods:

1. **Fence Cutting**: Acquire cutting tools, locate weak points in perimeter fence, cut through undetected
2. **Guard Disguise**: Steal guard uniform, acquire ID badge, walk out through main gate
3. **Cell Digging**: Acquire digging tools, dig tunnel from cell to outside, escape through tunnel
4. **Parole**: Complete rehabilitation tasks, attend parole hearings, convince warden to grant early release

**Design Note**: All methods must be balanced to take approximately the same time when executed optimally.

---

## 3. Information & Reporting System

### 3.1 Reporting Mechanics
- Players can report other players' suspicious activities to the warden
- Reports must specify:
  - Target player (anonymous identifier, not name)
  - Location of suspicious activity
  - Type of suspicious behavior observed
  - Time of observation

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

### 4.2 Suspicion Levels
- **Low (0-30%)**: Normal prisoner behavior, no consequences
- **Medium (31-60%)**: Increased guard patrols, random searches
- **High (61-80%)**: Frequent searches, restricted movement, cell inspections
- **Critical (81-100%)**: Solitary confinement, all items confiscated, escape attempt reset

### 4.3 Suspicion Decay
- Suspicion decreases over time when player exhibits normal behavior
- Rate of decay depends on current suspicion level
- High suspicion decays slower than low suspicion

### 4.4 Minimum Carry Amount
- Players can only carry a limited number of items
- Exceeding carry limit increases suspicion
- Must strategically choose what to carry and when
- Items can be hidden in cells or caches throughout prison

---

## 5. Resource Management

### 5.1 Currency System
- **Money**: Primary currency, obtained from tasks, trading, or stealing
- **Ramen**: Secondary currency/resource, obtained from commissary or tasks
- **Items**: Tools, materials, and consumables

### 5.2 Task System
Tasks are the primary way to earn money and resources:

**Task Categories**:
- **Labor Tasks**: Kitchen duty, cleaning, maintenance (low pay, low suspicion)
- **Skilled Tasks**: Library work, education programs (medium pay, medium suspicion)
- **Illegal Tasks**: Smuggling, contraband handling (high pay, high suspicion)
- **Rehabilitation Tasks**: Required for parole method (low pay, reduces suspicion)

**Task Mechanics**:
- Tasks appear on job boards throughout prison
- Tasks have time requirements and difficulty levels
- Completion rewards vary by task type
- Some tasks require specific skills or items
- Tasks can be shared/competed for by multiple players

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

**Balancing Factors**:
- Tool acquisition difficulty
- Fence cutting time
- Guard patrol frequency
- Noise detection radius

### 6.2 Guard Disguise Method
**Requirements**:
- Guard uniform (stolen from locker room or guard)
- Guard ID badge (stolen or forged)
- Knowledge of guard routines
- Low suspicion level

**Steps**:
1. Acquire guard uniform (stealth or distraction required)
2. Acquire/forge ID badge
3. Learn guard patrol patterns and routines
4. Disguise as guard during shift change
5. Walk out through main gate

**Balancing Factors**:
- Uniform acquisition difficulty
- ID badge security
- Guard recognition system
- Suspicion when wearing uniform

### 6.3 Cell Digging Method
**Requirements**:
- Digging tool (shovel, pickaxe, improvised tool)
- Cell location suitable for digging
- Time to dig tunnel
- Method to dispose of dirt

**Steps**:
1. Acquire digging tool
2. Identify dig location in cell
3. Dig tunnel (takes significant time, produces dirt)
4. Dispose of dirt (flush, hide, or trade)
5. Escape through tunnel

**Balancing Factors**:
- Digging tool acquisition
- Digging time and noise
- Dirt disposal difficulty
- Tunnel collapse risk

### 6.4 Parole Method
**Requirements**:
- Complete rehabilitation tasks
- Maintain low suspicion
- Attend parole hearings
- Convince warden (RNG or skill-based)

**Steps**:
1. Complete rehabilitation program tasks
2. Maintain good behavior (low suspicion)
3. Attend scheduled parole hearings
4. Pass warden's evaluation
5. Walk out legally

**Balancing Factors**:
- Rehabilitation task availability
- Parole hearing frequency
- Warden evaluation difficulty
- Time investment vs. other methods

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
- Team members can share information and resources
- Teams compete to be first to have all members escape
- Win condition: Entire team escapes (or first team with all members out)
- 6-12 players (2-4 teams)

**Team Mechanics**:
- Shared resource pool (optional)
- Team communication channels
- Coordinated escape attempts
- Team-based tasks

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
- **Player Management**: Spawn, respawn, team assignment
- **Suspicion System**: Behavior tracking, level calculation, consequences
- **Reporting System**: Report submission, verification, outcomes
- **Task System**: Task generation, assignment, completion tracking
- **NPC System**: Pathfinding, behavior trees, interactions
- **Item System**: Inventory, carry limits, item properties
- **Escape System**: Method tracking, progress, completion
- **Resource System**: Money, ramen, item management

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
- All methods should take approximately equal time when executed optimally
- Each method should have unique risks and rewards
- No single method should be clearly superior
- Methods should require different skill sets

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
- Move between common areas
- Offer services (distractions, information, trading)
- Have daily routines
- React to player actions
- Can be recruited for assistance
- May report suspicious behavior

### 12.3 Warden NPC
- Processes reports
- Conducts parole hearings
- Makes escape-related decisions
- Has office in administrative area
- Can be observed for information

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

### 14.1 Multiple Prisons
- Different prison layouts
- Varying difficulty levels
- Unique escape methods per prison
- Prison-specific mechanics

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

## 15. Implementation Phases

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

## 16. Success Metrics

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

## Appendix A: Glossary

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

## Appendix B: Design Principles

1. **Information is King**: Knowledge and observation are powerful tools
2. **Risk vs. Reward**: Higher risk activities should offer greater rewards
3. **Multiple Paths to Victory**: No single dominant strategy
4. **Meaningful Choices**: Every decision should matter
5. **Fair Competition**: Balance ensures skill determines winners
6. **Emergent Gameplay**: Systems interact to create unexpected situations
7. **Player Agency**: Players control their own destiny
8. **Social Dynamics**: Player interactions create interesting scenarios

---

**Document Version**: 1.0  
**Last Updated**: [Current Date]  
**Status**: Draft - Ready for Review
