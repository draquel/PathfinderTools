# PathfinderTools

    Simple chat command tools to make recruiting easier and streamlined

## Commands

### Recruit

    /pf recruit [name] - Whisper recruitment blurb to the player [name] or your current target if name is omitted

### Welcome

    /pf welcome [name] - Sends obiligitory "Welcome [name]" to guild chat and whispers intro information about guild to [name]. Defaults to current target if [name] is omitted.

### Discord

    /pf discord [destination] - Sends discord server link to [destination]. Accepted destinations include "raid", "party", "guild" or a player name. If the destination is omitted the current target will be used if it is a player.

### Stats

    /pf stats - dsiplayes recruitment stats

## To-Do

    * Create options to customize recruitment and orientation text 
    * See if we can combine /ginvite with welcome functionality
    ** Would modify welcome to include ginvite and check guild log to wait for player joining the guild.
    ** This would need a timeout for the life of the invite and duplicaiton protection.
    *** what is in the log? does it show declines?