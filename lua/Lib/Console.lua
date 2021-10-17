---
--- Created by InvsGhost.
--- DateTime: 2017/12/28 11:51
---


---      Config
local LUA_INFO = true
local DEBUG_MODE  = true
local DEBUG_LEVEL = 0


---      Init
Console = {}
Console.Lua_info    = LUA_INFO
Console.DebugMode   = DEBUG_MODE
Console.DebugLv     = DEBUG_LEVEL
Console.clockT      = 0


---      Interfaces
function Console.KeyInfo(DebugString)
    if Console.Lua_info then
        print(DebugString)
    end
end

function Console.DebugInfo(DebugString, level)
    if Console.Lua_info and Console.DebugMode then
        if level then
            if level <= Console.DebugLv then
                print(DebugString)
            end
        else
            print(DebugString)
        end
    end
end

function Console.clock()
    local t = os.clock()
    print(string.format("Now[%f] - Cost[%f]", t, t - Console.clockT))
    Console.clockT = t
end


---      Procedure