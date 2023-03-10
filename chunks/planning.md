

# Chunks mod

PLANNING:
Do we want a chunk class or not?
(i.e. publically exposed)



```lua

for _, ent in chunks.iter(x, y) do
    print(ent)
end



```









# Things we definitely want:

- Access to spatial partitioner outside of the chunks mod
- Iterate over chunked entities in a sensible way
- Entities get chunked automatically.




# For future:
Saving / loading of chunks.
 ^^^ Allows for infinite worlds



