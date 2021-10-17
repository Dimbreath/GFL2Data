require("UI.UIBasePanel")

UAVLevelUpBreakPanel = class("UAVLevelUpBreakPanel", UIBasePanel)
UAVLevelUpBreakPanel.__index = UAVLevelUpBreakPanel

UAVLevelUpBreakPanel.mview = nil

function UAVLevelUpBreakPanel:ctor()
    UAVLevelUpBreakPanel.super.ctor(self)
end

function UAVLevelUpBreakPanel.Init(root, data)
    UAVLevelUpBreakPanel.super.SetRoot(UAVLevelUpBreakPanel, root)
    self=UAVLevelUpBreakPanel
    self.mIsPop = true
    self.mview=UAVLevelUpBreakPanelView.New()
    self.mview:InitCtrl(root)
    self.data=data
    if CS.LuaUtils.IsNullOrDestroyed(data.obj)==false then
        self.raycaster=UIUtils.GetGraphicRaycaster(data.obj.transform)
        self.raycaster.enabled=false
    end
    if data.type=="break" then
        local hint=TableData.GetHintById(105026)
        self.mview.mText_TitleName.text=hint
        self.mview.mText_FirstName.text=hint
        self.mview.mText_Panel.text="G R A D E"
    elseif data.type=="levelup" then
        local hint1=TableData.GetHintById(810)
        self.mview.mText_TitleName.text=hint1
        self.mview.mText_FirstName.text=hint1
        self.mview.mText_Panel.text="L E V E L"
    elseif data.type=="yanfa" then
        self.mview.mText_FirstName.text=data.str
        setactive(self.mview.mTrans_GrpDialog,false)
        TimerSys:DelayCall(1.5,function ()
            UIManager.CloseUI(UIDef.UAVLevelUpBreakPanel)
        end)
        return

    end

    self.mview.mText_FromLv.text=data.fromlv
    self.mview.mText_ToLv.text=data.tolv

    local script=self.mview.mTrans_Content:GetComponent(typeof(CS.ScrollListChild))

    for k,v in ipairs(data[1]) do
        local itemobj=instantiate(script.childItem.gameObject,self.mview.mTrans_Content)
        local itemNametext=UIUtils.GetText(itemobj,"GrpList/Text_Name")
        local itemnownumtext=UIUtils.GetText(itemobj,"Trans_GrpNumRight/Text_NumNow")
        local itemtonumtext=UIUtils.GetText(itemobj,"Trans_GrpNumRight/Text_NumAfter")
        local itemtexttrans=UIUtils.GetRectTransform(itemobj,"Text_Num")
        local itemtexttrans2=UIUtils.GetRectTransform(itemobj,"Trans_GrpNumRight")

        setactive(itemtexttrans2,true)
        setactive(itemtexttrans,false)
        itemNametext.text=v.name
        itemnownumtext.text=v.nownum
        itemtonumtext.text=v.tonum
    end
    UIUtils.GetButtonListener(self.mview.mBtn_Close.gameObject).onClick=function ()
        self=UAVLevelUpBreakPanel
        if CS.LuaUtils.IsNullOrDestroyed(self.data.obj)==false then
            self.raycaster.enabled=true
        end
        UIManager.CloseUI(UIDef.UAVLevelUpBreakPanel)
    end
    
end













