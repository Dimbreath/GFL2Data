require("UI.UAVPanel.UIUAVContentBase")
UAVFuelNotEnougContent = class("UAVFuelNotEnougContent",UIUAVContentBase)
UAVFuelNotEnougContent.__index = UAVFuelNotEnougContent
UAVFuelNotEnougContent.PrefabPath = "UAV/UAVFuelNotEnoughDialogV2.prefab"

function UAVFuelNotEnougContent:ctor(obj)
    UAVFuelNotEnougContent.super.ctor(self, obj)
end

function UAVFuelNotEnougContent:__InitCtrl()
    UISystem:AddContentUi("UAVFuelNotEnoughDialogV2")
    self.mText_TitleName=self:GetText("Root/GrpDialog/GrpTop/GrpText/TitleText")
    self.mBtn_BgClose=self:GetButton("Root/GrpBg/Btn_Close")
    self.mBtn_Close=self:GetButton("Root/GrpDialog/GrpTop/GrpClose/Btn_Close")
    self.mBtn_Cancle=UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/Trans_BtnCancel"))
    self.mBtn_Confirm=UIUtils.GetTempBtn(self:GetRectTransform("Root/GrpDialog/GrpAction/BtnConfirm"))
    self.mText_Des=self:GetText("Root/GrpDialog/GrpCenter/GrpText/Text_Content")
    self.mText_Des2=self:GetText("Root/GrpDialog/BtnHint/Btn_Hint/GrpText/Text_Name")
    self.mToggle_hint=self:GetToggle("Root/GrpDialog/BtnHint/Btn_Hint")
    self.mTrans_Hide=self:GetRectTransform("Root/GrpDialog/GrpAction/Trans_BtnGoTo")

    self.mText_Des.text=TableData.GetHintById(105025)
    self.mText_Des2.text=TableData.GetHintById(901016)
    setactive(self.mTrans_Hide,false)

    self.mToggle_hint.onValueChanged:AddListener(function (isOn)
        if isOn then
         AccountNetCmdHandler.UAVHint=1
        
        else
            AccountNetCmdHandler.UAVHint=0
        end
    end)
    UIUtils.GetButtonListener(self.mBtn_BgClose.gameObject).onClick=function()
        self:OnClickClose()
        if self.callback~=nil then
            self.callback()
        end
    end
    UIUtils.GetButtonListener(self.mBtn_Close.gameObject).onClick=function()
        self:OnClickClose()
        if self.callback~=nil then
            self.callback()
        end
    end
    UIUtils.GetButtonListener(self.mBtn_Cancle.gameObject).onClick=function()
        self:OnClickClose()
        if self.callback~=nil then
            self.callback()
        end
    end
    UIUtils.GetButtonListener(self.mBtn_Confirm.gameObject).onClick=function()
        self.FuelGetPanel = UAVFuelGetDialogContent.New()
        self.FuelGetPanel:InitCtrl(self.mParent)
        self.FuelGetPanel:SetData(nil,self.mParent,true)
        self:OnClickClose()
    end
end

function UAVFuelNotEnougContent:OnClickClose()
    gfdestroy(self.mUIRoot)
end

function UAVFuelNotEnougContent:SetData(data, parent)
    UAVFuelNotEnougContent.super.SetData(self, data, parent)
    CS.LuaUIUtils.AddCanvas(self.mUIRoot.gameObject,GlobalConfig.ContentPrefabOrder)
    self.callback=data
    
end

function UAVFuelNotEnougContent:OnRelease()
    self.FuelGetPanel=nil
end


