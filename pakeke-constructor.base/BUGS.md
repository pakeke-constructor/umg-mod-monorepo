
# bugs


Physics player bug:
Physics collisions are done on both server-side and client side;
but for player entities, the collisions are firstly done on the client-side,
and the client side moves the players away from the physics blocks before it
can be registered on the server! 
Oh no!

Hacky solution:  Maybe make player hitboxes smaller on client-side?



