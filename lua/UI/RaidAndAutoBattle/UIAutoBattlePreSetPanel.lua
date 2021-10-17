require("UI.UIBasePanel")
require("UI.RaidAndAutoBattle.UIAutoBattlePreSetView");

UIAutoBattlePreSetPanel = class("UIAutoBattlePreSetPanel", UIBasePanel);
UIAutoBattlePreSetPanel.__index = UIAutoBattlePreSetPanel;

UIAutoBattlePreSetPanel.mView = nil;
UIAutoBattlePreSetPanel.mStageData = nil;
UIAutoBattlePreSetPanel.lineUpGuns = {};

function UIAutoBattlePreSetPanel:ctor()
    UIAutoBattlePreSetPanel.super.ctor(self);
end

function UIAutoBattlePreSetPanel.Open(data)
    self = UIAutoBattlePreSetPanel;
    UIManager.OpenUIByParam(UIDef.UIAutoBattlePreSetPanel,data);
    --UIAutoBattlePreSetPanel:InitShow();
end

function UIAutoBattlePreSetPanel.Close()
    UIManager.CloseUI(UIDef.UIAutoBattlePreSetPanel);
end

function UIAutoBattlePreSetPanel.Hide()
    self = UIAutoBattlePreSetPanel;
    self:Show(false);
end

function UIAutoBattlePreSetPanel.Init(root, data)
    UIAutoBattlePreSetPanel.super.SetRoot(UIAutoBattlePreSetPanel, root);
    UIAutoBattlePreSetPanel.mStageData = data;

    UIAutoBattlePreSetPanel.mView = UIAutoBattlePreSetView;
    UIAutoBattlePreSetPanel.mView:InitCtrl(root);

    UIUtils.GetListener(self.mView.mBtn_start.gameObject).onClick=self.OnStartClicked;
    UIUtils.GetListener(self.mView.mBtn_enterPre.gameObject).onClick=self.OnEnterPrepare;
    UIUtils.GetListener(self.mView.mBtn_Cancel.gameObject).onClick=self.OnReturnClick;
end


function UIAutoBattlePreSetPanel.OnInit()
    self = UIAutoBattlePreSetPanel;
end

function UIAutoBattlePreSetPanel.OnShow()
    self = UIAutoBattlePreSetPanel;
end

function UIAutoBattlePreSetPanel.OnRelease()
    self = UIAutoBattlePreSetPanel;
end

function UIAutoBattlePreSetPanel.OnReturnClick(gameobj)
    self = UIAutoBattlePreSetPanel;
    UIManager.CloseUI(UIDef.UIAutoBattlePreSetPanel);
end

function UIAutoBattlePreSetPanel.SetupGuns()
    self  = UIAutoBattlePreSetPanel;

    self.lineUpGuns = {};
    local stageConfig =  TableData.GetStageConfigData(self.mStageData.id);
    local GunBirthPoints = {}

    local gun_birth_points = string.split(stageConfig.gun_birth_points,"|");
    for _,point in ipairs(gun_birth_points) do
        local data = string.split(point,":");
        local grid_id = tonumber(data[1]);
        table.insert(GunBirthPoints,grid_id);
    end

    local lineUp = NetCmdTeamData:GetStageLineupByType(self.mStageData.type);
    local lineUpCount = 0;
    if lineUp ~= nil then
        for i = 0, lineUp.Guns.Length - 1 do
            if GunBirthPoints[i + 1] ~= nil and lineUp.Guns[i] > 0 then
                if lineUpCount < stageConfig.gun_limit then
                    local grid_id = tonumber(GunBirthPoints[i + 1]);
                    self.lineUpGuns[grid_id] = lineUp.Guns[i];
                    lineUpCount = lineUpCount + 1;

                    gfdebug(lineUpCount)
                end
            end
        end
    end
end

function UIAutoBattlePreSetPanel.OnStartClicked(gameObject)
    self = UIAutoBattlePreSetPanel;

    self.SetupGuns();
    local guns = {};
    for k,v in pairs(self.lineUpGuns)do
        local value = CS.StageUseGun();
        value.gun_id = v;
        value.point_id = k;
        print("gun_id =" ..value.gun_id .. "point_id =" .. value.point_id);
        table.insert(guns,value);
    end

    if(#guns > 0) then
        AFKBattleManager:StartAutoRepeatBattle(self.mStageData,guns);
    else
        self.OnEnterPrepare(nil);
    end

    self.Close()
end


function UIAutoBattlePreSetPanel.OnEnterPrepare(gameObject)
    self = UIAutoBattlePreSetPanel;
    -- if(self.mStageData.stamina_cost>NetCmdSimulateBattleData:GetLocalStamina())then
	-- 	local title = TableData.GetHintById(208)
	-- 	local hint = TableData.GetHintById(203)
	-- 	MessageBox.Show(title,hint,nil,nil,nil,self.OnBoxConfirm,nil)
	-- 	return nil
    -- end
    if not TipsManager.CheckStaminaIsEnough(self.mStageData.stamina_cost) then
		return
	end
	SceneSys:OpenBattleScene(self.mStageData);
    self.Close()
end
