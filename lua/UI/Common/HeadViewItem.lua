---
--- Created by firwg.
--- DateTime: 2018/8/5 17:12
---


--region *.lua
--Date

require("UI.UIBaseCtrl")

--头像立绘视图
HeadViewItem = class("HeadViewItem", UIBaseCtrl);

HeadViewItem.__index = HeadViewItem;

HeadViewItem.mHaveObj = nil;--存在的Obj

HeadViewItem.mImageHead = nil;--头像图标
HeadViewItem.mImageRankRing = nil;--品质圆环
HeadViewItem.mImageBG = nil;--背景
HeadViewItem.mImageHP = nil;--品质竖标
HeadViewItem.mImageWearPct = nil;--疲劳度百分比电池图标
HeadViewItem.mStatuebj = nil;--不存在的Obj  留白Obj


HeadViewItem.mHaveNotObj = nil;--不存在的Obj  留白Obj



--构造
function HeadViewItem:ctor()
    HeadViewItem.super.ctor(self);
end

--初始化
function HeadViewItem:InitCtrl(root)

    local obj=instantiate(UIUtils.GetGizmosPrefab("Repair/HeadViewItem.prefab",self));
    self:SetRoot(obj.transform);
    setparent(root,obj.transform);
    obj.transform.localScale=vectorone;
    self:SetRoot(obj.transform);
    self.mHaveObj=self.mUIRoot:Find("Have");
    self.mImageHead = self:GetImage("Have/Head/Mask/Icon");
    self.mImageRankRing = self:GetImage("Have/Head/QualityRound");
    self.mImageBG = self:GetImage("Have/Head/QualityBG");
    self.mImageHP = self:GetImage("Have/HpBG/HPMask");
    self.mHaveNotObj=self.mUIRoot:Find("Havnt");
    self.mStatuebj=self.mUIRoot:Find("Have/Statue");
    self.mImageWearPct=self:GetImage("Have/Statue/StatueIcon");
end

--设置枪 数据
function HeadViewItem:SetGunData(data)

    if data~=nil then
        --gfdebug("SetGunData"..data.id)
        setactive(self.mHaveNotObj,false);
        setactive(self.mHaveObj,true);
        setactive(self.mStatuebj,true);
        local gundata = TableData.GetGunData(data.stc_gun_id);

        if gundata ~=nil then

            self.mImageHead.sprite = CS.IconUtils.GetCharacterHeadSprite(gundata.code);
            self.mImageRankRing.color = TableData.GetGlobalGun_Quality_Color1(gundata.rank);
            --if UIDispatchPanel.mPanelType ==nil then
                self.mImageHP.fillAmount = (data.hp/data.max_hp);
            --else
               --self.mImageHP.fillAmount = 1
            --end

            if (data.wear_Pct<0.9) then
                setactive(self.mStatuebj,false);
            else
                setactive(self.mStatuebj,true);
                local batterySpritename=TableData.GetGlobalGunFatigueBatterySpriteNameByPec(data.wear_Pct);
                gfdebug(batterySpritename);
                self.mImageWearPct.sprite=UIUtils.GetGunMessageSprite(batterySpritename);
            end
            --gfdebug(batterySpritename);
        else

        end

    else
        --gfdebug("Data===null")
        setactive(self.mHaveNotObj,true);
        setactive(self.mHaveObj,false);
        setactive(self.mStatuebj,false);
    end
end

--设置 载具数据
function HeadViewItem:SetCarrierData(data)

    if data~=nil then
        setactive(self.mHaveNotObj,false);
        setactive(self.mHaveObj,true);
        setactive(self.mStatuebj,false);
        local gundata = TableData.GetCarrierBaseBodyData(data.stc_carrier_id);
        if gundata ~=nil then

            self.mImageHead.sprite =CS.UISystem.Instance.mCampaignAtlas:GetSprite("Campaign_Repair_EchelonIcon_Big");
            self.mImageRankRing.color = TableData.GetGlobalGun_Quality_Color1(gundata.rank);
            self.mImageBG.color=CS.GF2.UI.UITool.StringToColor("FFB400FF");
            if UIDispatchPanel.mPanelType ==nil then
                self.mImageHP.fillAmount = (data.hp/data.prop.max_hp);
            else
                self.mImageHP.fillAmount = 1
            end
        else

        end

    else

    end
end




--设置为没有数据  留白
function HeadViewItem:SetHavntData(value)
    setactive(self.mHaveNotObj,value);
    setactive(self.mHaveObj,~value);
end

--endregion