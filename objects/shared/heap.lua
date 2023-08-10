
--[[
	heap data structure
]]

local Class = require("shared.class")

local Heap = Class("objects:Heap")



local floor = math.floor

local function defaultCompare(a, b)
	if a > b then
		return true
	else
		return false
	end
end

local function siftUp(heap, index)
	local parentIndex
	if index ~= 1 then
		parentIndex = floor(index/2)
		if heap.compare(heap[parentIndex], heap[index]) then
			heap[parentIndex], heap[index] = heap[index], heap[parentIndex]
			siftUp(heap, parentIndex)
		end
	end
end

local function siftDown(heap, index)
	local leftChildIndex, rightChildIndex, minIndex
	leftChildIndex = index * 2
	rightChildIndex = index * 2 + 1
	if rightChildIndex > #heap then
		if leftChildIndex > #heap then
			return
		else
			minIndex = leftChildIndex
		end
	else
		if not heap.compare(heap[leftChildIndex], heap[rightChildIndex]) then
			minIndex = leftChildIndex
		else
			minIndex = rightChildIndex
		end
	end
	
	if heap.compare(heap[index], heap[minIndex]) then
		heap[minIndex], heap[index] = heap[index], heap[minIndex]
		siftDown(heap, minIndex)
	end
end

function Heap:init(comparator)
	self.compare = comparator or defaultCompare
end

function Heap:insert(newValue)
	table.insert(self, newValue)
	
	if #self <= 1 then
		return
	end
	
	siftUp(self, #self)
end

function Heap:pop()
	if #self > 0 then
		local toReturn = self[1]
		self[1] = self[#self]
		table.remove(self, #self)
		if #self > 0 then
			siftDown(self, 1)
		end
		return toReturn
	else
		return nil
	end
end

function Heap:peek()
	if #self > 0 then
		return self[1]
	else
		return nil
	end
end

function Heap:toTable()
	local newTable = { }
	for i = 1, #self do
		table.insert(newTable, self[i])
	end
	return newTable
end

function Heap:clear()
	for k in ipairs(self) do
		self[k] = nil
	end
end


function Heap:size()
	return #self
end

function Heap:clone()
	local newHeap = Heap.new(self.compare)
	for i = 1, #self do
		table.insert(newHeap, self[i])
	end
	return newHeap
end

function Heap:heapify(oldTable, comparator)
	local newHeap = Heap.new(comparator)
	for i = #oldTable, 1, -1 do
		newHeap:insert(oldTable[i])
		table.remove(oldTable, i)
	end
	return newHeap
end



return Heap
