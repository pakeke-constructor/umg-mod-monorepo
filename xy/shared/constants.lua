

return {
    --[[ 
    need to differ by more than 0.5 before a sync is enacted.

    When mod launch options are supported, this should be a configurable value.

    ALSO:
    The reason this needs to be a constant, as opposed to a configurable
    option, is because sync.autoSyncComponent MUST be called before
    entities are loaded, since it generates groups.
    ]]
    NUMBER_SYNC_THRESHOLD = 0.5
}


