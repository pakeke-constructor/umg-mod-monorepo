
local objects = {}

objects.Class = require("shared.class");
objects.Set = require("shared.set");
objects.Array = require("shared.array");
objects.Heap = require("shared.heap");
objects.Partition = require("shared.partition");
objects.Enum = require("shared.enum")
objects.Color = require("shared.color")

umg.expose("objects", objects)

