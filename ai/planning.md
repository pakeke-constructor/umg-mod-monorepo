

# AI OVERVIEW:

FEELINGS:
Environment (or events in environment) affects the feelings of an agent
ACTIONS:
Changing from one state to another.
Actions will also change the feelings of an agent
STATES:
The current state of an agent.




Ideal features:

### We want AI states to be **declarative.**
I.e. we define the state, what the state does,
and what kind of stuff causes an entry into the state.


### We want the AI system to make transitions automatically.
This includes stuff like:
- Deciding to chase player
- Lying down to sleep
- Going over to eat food
- etc


### We want to make it super easy for the AI to read the environment.
Many factors should be taken into account here, and it should be EASY to represent.
Things that should be taken into account:
- How hungry the agent is
- How much health the agent has
- If the agent has backup or allies in vicinity
- If the agent is surrounded by enemies/hostile forces
- If food/other goods are nearby


### We want actions to be able to be specified easily.
For example, instead of programming all of the code for "chase player"
inside of the AI system, we should rather tag into `moveBehaviour`.
Likewise, for attacking, we should tag into `attackBehaviour`.

This could include having parameters passed into the option functions



