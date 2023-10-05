
# Pulseworks mod

Allows for mechanical circuits and logic
(Uses cellular automata similar to wireworld.)


CELLULAR AUTOMATA RULES::
```r


Electrons travel along WIRE.

Electrons have 3 values:
    electron_power: double. (If electron_power > 0, this cell is charged.)
    velX: X velocity of electron (0 or -1 or 1)
    velY: Y velocity of electron (0 or -1 or 1)

duplicator:
    multiplies electron_power by 2 when an electron passes through.



Similar to wireworld, except 90 degree turns are impossible.
Each electron has a "velocity", and there can only
be 45 degree turns at max; (i.e. diagonal turns).

If the current can go straight forward, it wont make any turn.

Since cells have a velocity, there is also no need for
electron tails.
Pulse flow can be a continuous current, which is cool!

If an electron splits off into two directions, its power is halved between
the two directions.

If two electrons merge together into the same cell, their power
is added together

If two electrons merge at right angles, 
they are subtracted from one another.
Say we have X - Y,
The electron that goes straight is the one that is X,
the electron that hits at the right angle is Y.

NOTE: This subtraction functionality also allows for equality checks between
electrons, which is very cool!

```

VANITY:
Electron tail color should fade out over time, not instantly.
Like this: https://youtu.be/IK7nBOLYzdE



