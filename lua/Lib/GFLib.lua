--region *.lua
--Date

require("Lib.class")
require("Lib.List")
require("Lib.Dictionary")
require("UI.UIUtils")
require("UI.UIManager")

-- global var
vectorone = CS.UnityEngine.Vector3.one
vectorzero = CS.UnityEngine.Vector3.zero

vector2one = CS.UnityEngine.Vector2.one
vector2zero = CS.UnityEngine.Vector2.zero

GFUtils = CS.GFUtils
GFMath = CS.GFMath
CmdConst = CS.CmdConst
GCFGConst = CS.GF2.Data.GCFGConst
CarrierPropNo = CS.GF2.Data.CarrierPropNo
TableData = CS.GF2.Data.TableData
GlobalData = CS.GF2.Data.GlobalData
SystemList = CS.GF2.Data.SystemList
ResSys = CS.ResSys.Instance
GameObject = CS.UnityEngine.GameObject
Transform = CS.UnityEngine.Transform
RectTransform = CS.UnityEngine.RectTransform
InputSys = CS.InputSys.Instance
MessageBox = CS.MessageBox
UISystem = CS.UISystem.Instance
UI3DModelManager = CS.UISystem.Instance;
SceneSys = CS.SceneSys.Instance;
CharacterPicUtils = CS.CharacterPicUtils;
IconUtils = CS.IconUtils;
Tween = CS.DG.Tweening;
DOTween = CS.LuaDOTweenUtils;
NetCmdItemsData = CS.NetCmdItemData.Instance;
Color = CS.UnityEngine.Color;
CSUIUtils = CS.UIUtils;
Vector3 = CS.UnityEngine.Vector3;
Vector2 = CS.UnityEngine.Vector2;
NetCmdTrainGunData = CS.NetCmdTrainGunData.Instance;
MessageSys = CS.GF2.Message.MessageSys.Instance;
TimerSys = CS.GF2.Timer.TimerSys.Instance;
PropertyUtils = CS.PropertyUtils;
NetCmdTeamData = CS.NetCmdTeamData.Instance;
NetCmdPvPData = CS.NetCmdPvPData.Instance;
NetCmdQuestData = CS.NetCmdQuestData.Instance;
NetCmdChatData = CS.NetCmdChatData.Instance
ResourceManager = CS.Framework.ResSys.ResourceManager.ResourceManager.Instance;
-- AVGController = CS.AVGController.Instance;
NetCmdUavData=CS.NetCmdUavData.Instance
NetCmdItemData = CS.NetCmdItemData.Instance;
NetTeamHandle = CS.NetCmdTeamData.Instance;
CampaignPool = CS.CampaignPool.Instance;
TableDataMgr = CS.TableDataManager.Instance;
CarrierTrainNetCmdHandler=CS.CarrierNetCmdHandler.Instance;
CarrierNetCmdHandler=CS.CarrierNetCmdHandler.Instance;
GashaponNetCmdHandler = CS.GashaponNetCmdHandler.Instance;
NetCmdSimulateBattleData = CS.NetCmdSimulateBattleData.Instance;
NetCmdCoreData = CS.NetCmdCoreData.Instance;
NetCmdFacilityData = CS.NetCmdFacilityData.Instance;
NetCmdEquipData = CS.NetCmdEquipData.Instance;
NetCmdGunEquipData = CS.NetCmdGunEquipData.Instance;
NetCmdStoreData = CS.NetCmdStoreData.Instance;
NetCmdNpcData = CS.NetCmdNpcData.Instance;
NetCmdDormData = CS.NetCmdDormData.Instance;
AccountNetCmdHandler = CS.AccountNetCmdHandler.Instance;
NetCmdMailData = CS.NetCmdMailData.Instance;
NetCmdCommanderData = CS.NetCmdCommanderData.Instance;
NetCmdDungeonData=CS.NetCmdDungeonData.Instance;
NetCmdIllustrationData = CS.NetCmdIllustrationData.Instance;
PlayerNetCmdHandler = CS.PlayerNetCmdHandler.Instance;
BattleNetCmdHandler= CS.BattleNetCmdHandler.Instance;
NetCmdStageRecordData = CS.NetCmdStageRecordData.Instance;
CGameTime=CS.CGameTime.Instance;
PostInfoConfig = CS.PostInfoConfig;
NetCmdChipData = CS.NetCmdChipData.Instance;
NetCmdGunSkillData = CS.NetCmdGunSkillData.Instance;
NetCmdExpeditionData = CS.NetCmdExpeditionData.Instance;
NetCmdGuildData = CS.NetCmdGuildData.Instance;
NetCmdFriendData = CS.NetCmdFriendData.Instance;
NetCmdRaidData = CS.NetCmdRaidData.Instance;
NetCmdBannerData = CS.NetCmdBannerData.Instance;
NetCmdAchieveData = CS.NetCmdAchieveData.Instance;
NetCmdCheckInData = CS.NetCmdCheckInData.Instance;
NetCmdTutorialData = CS.NetCmdTutorialData.Instance;
NetCmdWeaponData = CS.NetCmdWeaponData.Instance;
NetCmdWeaponPartsData = CS.NetCmdWeaponPartsData.Instance;
NetCmdRankData = CS.NetCmdRankData.Instance
NetCmdRedPointData = CS.NetCmdRedPointData.Instance
TextData = CS.TextData.Instance
NetCmdDormDataV2 = CS.NetCmdDormDataV2.Instance

SceneObjManager= CS.SceneObjManager.Instance;
SceneSwitch = CS.SceneSwitch.Instance;
VirtualList = CS.VirtualList;
GuideManager = CS.GuideManager.Instance;

AFKBattleManager = CS.AFKBattleManager.Instance;

KeyCode = CS.UnityEngine.KeyCode

RedPointSystem = require("UI.RedPoint.RadPointSystem")

GunTypeStr = {"HG","SMG","RF","AR","MG","SG"};
RankFrame = {
    "NewCommonResource_Common_Frame_1",
    "NewCommonResource_Common_Frame_2",
    "NewCommonResource_Common_Frame_3",
    "NewCommonResource_Common_Frame_4",
    "NewCommonResource_Common_Frame_5",
    "NewCommonResource_Common_Frame_6",
}

LeaderBoardType =
{
    AllLeaderBoardType = 0,
    WeeklySimCombatLeaderBoardType = 1,
    NrtPvpLeaderBoardType = 2
}

function gfenum(tbl, index) 
    local enumtbl = {} 
    local enumindex = index or 0 
    for i, v in ipairs(tbl) do 
        enumtbl[v] = enumindex + i 
    end 
    return enumtbl 
end

function formatnum (num)
    if num <= 0 then
        return 0
    else
        local t1, t2 = math.modf(num)
        ---小数如果为0，则去掉
        if t2 > 0 then
            return num
        else
            return t1
        end
    end
end

function gfdestroy(gameobj)
    CS.LuaUtils.Destroy(gameobj)
end

function gf_delay_destroy(gameobj,delay)
    CS.LuaUtils.Destroy(gameobj,delay)
end

function printstack(originalInfo)
    print("<color=#EECF1EFF>" .. originalInfo.. "\n" .. debug.traceback() .. "</color>");
end

local function new_array(item_type, item_count)
    return CS.LuaUtils.CreateArrayInstance(item_type, item_count)
end

-- new泛型list
local function new_list(item_type)
    return CS.LuaUtils.CreateListInstance(item_type)
end

-- new泛型字典
local function new_dictionary(key_type, value_type)
    return CS.LuaUtils.CreateDictionaryInstance(key_type, value_type)
end

-- 获取component
local function new_dictionary(key_type, value_type)
    return CS.LuaUtils.CreateDictionaryInstance(key_type, value_type)
end

--typeof(CS.UnityEngine.UI.Button) target可以是tranform或者gameobject
function getcomponent(target, ctype)
    return CS.LuaUtils.GetComponent(target, ctype)
end

function getcomponentinchildren(target, ctype)
    return CS.LuaUtils.GetComponentInChildren(target, ctype)
end

function addcomponent(target, ctype)
    return CS.LuaUtils.AddComponent(target, ctype)
end

function getchildcomponent(target, child, ctype)
    return CS.LuaUtils.GetChildComponent(target, child, ctype)
end

function getparticlesinchildren(target)
	return CS.LuaUtils.GetParticlesInChildren(target)
end

function instantiate(prefab)
    return CS.UnityEngine.GameObject.Instantiate(prefab);
end

function instantiate(prefab,parent)
    return CS.UnityEngine.GameObject.Instantiate(prefab,parent);
end

function setparent(parent, child)
    return CS.LuaUtils.SetParent(parent, child);
end

function setposition(obj, pos)
    return CS.LuaUtils.SetPosition(obj, pos);
end

function setscale(parent, child)
    return CS.LuaUtils.SetScale(parent, child);
end

function setangles(parent, child)
    return CS.LuaUtils.SetEulerAngles(parent, child);
end

function setrotation(parent, child)
    return CS.LuaUtils.SetRotation(parent, child);
end

function clearallchild(parent)
    return CS.LuaUtils.ClearAllChild(parent);
end



function setactive(objtranscomp, active)
    if objtranscomp == nil then
        print("设置了空的对象！！！！！")
    end
    return CS.LuaUtils.SetActive(objtranscomp, active);
end

function setchildactive(objtranscomp, index, active)
    if objtranscomp == nil then
        print("设置了空的对象！！！！！")
    end
    return CS.LuaUtils.SetChildActive(objtranscomp, index, active);
end

-- cs数组迭代器
function array_iter(cs_array, index)
    if index < cs_array.Length then
        return index + 1, cs_array[index]
    end
end

function array_ipairs(cs_array)
    return array_iter, cs_array, 0
end

-- cs列表迭代器
function list_iter(cs_ilist, index)
    if index < cs_ilist.Count then
        return index + 1, cs_ilist[index]
    end
end

function list_ipairs(cs_ilist)
    return list_iter, cs_ilist, 0
end

-- cs字典迭代器
function dictionary_iter(cs_enumerator)
    if cs_enumerator:MoveNext() then
        local current = cs_enumerator.Current
        return current.Key, current.Value
    end
end

function dictionary_ipairs(cs_idictionary)
    local cs_enumerator = cs_idictionary:GetEnumerator()
    return dictionary_iter, cs_enumerator
end


function gfdebug(msg)
    CS.LuaUtils.Debug(msg)
end

function gferror(msg)
    CS.LuaUtils.Error(msg)
end

function gfwarning(msg)
    CS.LuaUtils.Warning(msg)
end

function string_format(fmt,...)
  assert(fmt ~= nil,"Format error:Invalid Format String")
  local parms = {...}
  
  function search(k)
    --从 C# 数组习惯转到 Lua
    k = k+1
    assert(k <= #parms and k >=0 ,"Format error:IndexOutOfRange")
    return tostring(parms[k])
  end
  
  return (string.gsub(fmt,"{(%d)}",search))
end

function setlayer(gameobj,layer,include_child)
	CS.LuaUtils.SetLayer(gameobj,layer,include_child)
end

--字符串分割
function string.split(str, separator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
        local nFindLastIndex = string.find(str, separator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(str, nFindStartIndex, string.len(str))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(str, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(separator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

function math.pow(x,y)
    return x ^ y;
end

function FormatNum (num)
    if num <= 0 then
        return 0
    else
        local t1, t2 = math.modf(num)
        ---小数如果为0，则去掉
        if t2 > 0 then
            return num
        else
            return t1
        end
    end
end

--按比特位取值
function math.bit(value,bit_idx)
    if bit_idx <= 0 or value <= 0 then
        return 0;
    end
    local a = 2^bit_idx;
    return math.floor((value % a) * 2 / a);
end

function setRectTransformHeight(rt,height)
    local sizeDelta = rt.sizeDelta;
    sizeDelta.y = height;
    rt.sizeDelta = sizeDelta;
end

function setRectTransformWidth(rt,width)
    local sizeDelta = rt.sizeDelta;
    sizeDelta.x = width;
    rt.sizeDelta = sizeDelta;
end

function trim(str)
    return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
end

function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

local rawpairs = pairs
-------------------------------------------
-- 可以按指定顺序遍历的map迭代器
-- @param tbl   要迭代的表
-- @param func  比较函数
-- @example
--      for k,v in pairs(tbl,defaultComp) do print(k,v) end
function pairsBySort(tbl, func)
    if func == nil then
        return rawpairs(tbl)
    end

    -- 为tbl创建一个对key排序的数组
    -- 自己实现插入排序，table.sort遇到nil时会失效
    local ary = {}
    local lastUsed = 0
    for key in rawpairs(tbl) do
        if (lastUsed == 0) then
            ary[1] = key
        else
            local done = false
            for j=1,lastUsed do  -- 进行插入排序
                if (func(key, ary[j]) == true) then
                    -- arrayInsert( ary, key, j )
                    done = true
                    break
                end
            end
            if (done == false) then
                ary[lastUsed + 1] = key
            end
        end
        lastUsed = lastUsed + 1
    end

    -- 定义并返回迭代器
    local i = 0
    local iter = function ()
        i = i + 1
        if ary[i] == nil then
            return nil
        else
            return ary[i], tbl[ary[i]]
        end
    end
    return iter
end

function deep_copy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end

    return _copy(object)
end

function tableIsContain(table, match)
    if type(table) == "table" then
        for i, item in ipairs(table) do
            if match(item) then
                return i, item
            end
        end
    end
    return -1, nil
end

function luaRoundNum(num)
    local n = math.modf(num)
    return n
end

--endregion
