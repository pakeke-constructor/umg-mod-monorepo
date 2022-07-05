
# bugs


Physics player bug:
Physics collisions are done on both server-side and client side;
but for player entities, the collisions are firstly done on the client-side,
and the client side moves the players away from the physics blocks before it
can be registered on the server! 
Oh no!

Ignore it for now- who cares :)
Hacky solution:  Make player hitboxes smaller on client-side








Position desync for client/serverside.
This can be seen through the physics bodies.

Perhaps it's a desync between physics bodies and entities 
instead of position values on server/client?





Memory leak for entities moving upwards:
If an entity moves up for an infinite amount of time, it will cause a memory leak.
This is because the DrawIndex data structure repeatedly creates new sparse sets.

Replace it with a regular list data structure.
Then, create a custom sorting function that removes (and adds) entities in place
whilst sorting.
(This allows entity removal and addition to be O(1). )



