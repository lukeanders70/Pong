# Data Structure
Each level is made of two parts:
1. a 'metadata.lua' file
2. a 'level.txt' file

# Metadata
the metadata file contains information like the level's name

# Level
the level file encodes what the level actually looks like. Each tile is defined by three characters
```
0001
```
### First Character
the first charater signifies if the tile contains a static block, or an enemy. `0` indicates a block, while `1` indicates an enemy. Enemies will move once the game starts, and are assumed to have air behind them `0000`

### Second Character
the second character signifies if the block is solid. `0` indicates not-solid while `1` indicates solid. If a block is solid, then the player and enemies cannot pass through it. Enemies are always solid, regaurdless of this value.

### Third and Fourth Character
these characters signify the ID of tile. Enemies and Blocks use the same IDs, so `01` might signify a cubit if the first character is `0` but a flappy if the first character is a `1`