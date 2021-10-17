UAVUtility={}
UAVUtility.NowArmId=-1
UAVUtility.NowRealBottomArmId=-2
UAVUtility.NowBottomPos=-1
UAVUtility.NowFakeBottomArmId=-2
UAVUtility.IsClickUninstall=false
UAVUtility.OnlyRefreshOnce=false
UAVUtility.AniState=-1
UAVUtility.BreakLevelDic=nil
UAVUtility.uavmaxlevelDic=nil

function UAVUtility:InitData()
    if self.BreakLevelDic==nil then
        self.BreakLevelDic=Dictionary:New()
        local uavgrade=0
        local leveldata=TableData.GetUavLevelData()
        for i = 0, leveldata.Count-1 do
            if leveldata[i].UavMaterial~=0 then
                self.BreakLevelDic:Add(uavgrade,leveldata[i].Level)
                uavgrade=uavgrade+1
            end
        end
    end

    if self.uavmaxlevelDic==nil then
        self.uavmaxlevelDic=Dictionary:New()
        local index=0
        local leveldata=TableData.GetUavLevelData()
        for i = 0, leveldata.Count-1 do
            if leveldata[i].UavMaterial~=0 then
                self.uavmaxlevelDic:Add(index,leveldata[i].Level)
                index=index+1
            end
        end
        local maxlevel=leveldata[leveldata.Count - 1].Level
        self.uavmaxlevelDic:Add(index,maxlevel)
    end
    
end




function UAVUtility:GetUavGrade(uavlevel)
    local grade=-1
    for k,v in pairs(self.BreakLevelDic) do
        grade=grade+1
        --0阶特殊处理
        if uavlevel>=1 and uavlevel <=self.BreakLevelDic[0] then
            return 0
        end
        if uavlevel>=self.BreakLevelDic[grade]+1 and self.BreakLevelDic:ContainsKey(grade+1)==false then
            return self.BreakLevelDic:Count()
        end
        if uavlevel>=self.BreakLevelDic[grade]+1 and uavlevel<= self.BreakLevelDic[grade+1] then
            return grade+1
        end
    end
    gferror("无法返回对应的阶数")
    return 0
end

function UAVUtility:GetUavLevelMax(uavgrade)
    return self.uavmaxlevelDic[uavgrade]
end 

function UAVUtility:GetUavRealMaxLevel()
    local uavdata=NetCmdUavData:GetUavData()
    local nowuavlevel=uavdata.UavLevel
    local leveluptalbe=TableData.GetUavLevelData()
    local playerlevel=AccountNetCmdHandler:GetLevel()
    local temp=TableData.GlobalSystemData.UavExceedlevel
    local uavlimitlevel=temp+playerlevel
    local uavMaxLevel=0
    local realmaxLevel=0
    local maxlevel=TableData.listUavLevelDatas:GetList().Count
    if uavlimitlevel>=maxlevel then
        uavlimitlevel=maxlevel
    end

    for i = nowuavlevel-1,leveluptalbe.Count-1  do
        if leveluptalbe[i].UavMaterial~=0 then
            uavMaxLevel=leveluptalbe[i].Level
            if self:GetUavGrade(nowuavlevel) ~= uavdata.UavGrade then
                uavMaxLevel = leveluptalbe[i].Level + self.BreakLevelDic[uavdata.UavGrade+1]-self.self.BreakLevelDic[uavdata.UavGrade]
                break
            end 
            break
        end
    end

    realmaxLevel= uavMaxLevel>=uavlimitlevel and uavlimitlevel or uavMaxLevel
    return realmaxLevel
end

