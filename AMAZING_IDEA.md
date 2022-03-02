
# AMAZING IDEA:

Okay, so a big issue is when entities are bobbing and swaying, they all
adhere to the same frequency, because they have no component that tells them
what frequency they should be on.

A way to solve this is to use the `ent.id` as a hash value.
I.e, have 6 bobbing oscillators, and have 
`bobbing_channel = (ent.id % 6) + 1`

This can be done for animations too!!!

It works great, because entity ids are constants, and they don't take up
any extra space!!!! 
amazing!!!


