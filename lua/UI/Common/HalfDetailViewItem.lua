---
--- Created by firwg.
--- DateTime: 2018/8/5 17:12
---


--region *.lua
--Date

require("UI.UIBaseCtrl")


--半身立绘视图
HalfDetailViewItem = class("HalfDetailViewItem", UIBaseCtrl);

HalfDetailViewItem.__index = HalfDetailViewItem;
HalfDetailViewItem.mImageMainHalf = nil;--半身立绘
HalfDetailViewItem.mImageCornerSign = nil;--品质角标
HalfDetailViewItem.mImageUpRightSign = nil;--品质竖标
HalfDetailViewItem.mImageStar = nil;--星星等级
HalfDetailViewItem.mImageGunType = nil;--抢种类型
HalfDetailViewItem.mTextGunName = nil;--抢种名字
HalfDetailViewItem.mTextGunHP = nil;--枪种血量文字
HalfDetailViewItem.mImageGunHP = nil;--枪种血条
HalfDetailViewItem.mImageGunFatigue = nil;--枪种疲劳度
HalfDetailViewItem.mTextPower = nil;--枪种战力
HalfDetailViewItem.mTextLevel = nil;--枪等级
HalfDetailViewItem.mButtonGunRepair = nil;--修理按钮

HalfDetailViewItem.mNoGunObj = nil;
HalfDetailViewItem.mHaveObj = nil;

HalfDetailViewItem.mData = nil;
HalfDetailViewItem.type=nil;


--星星List
HalfDetailViewItem.mStarUpStarList=nil;

--构造
function HalfDetailViewItem:ctor()
    HalfDetailViewItem.super.ctor(self);
end

--初始化
function HalfDetailViewItem:InitCtrl(root)

    local obj=instantiate(UIUtils.GetGizmosPrefab("Repair/HalfViewItem.prefab",self));

    setparent(root,obj.transform);
    obj.transform.localScale=vectorone;

    self:SetRoot(obj.transform);

    self.mImageMainHalf = self:GetImage("Have/BG/GunImgMask/GunImg");
    self.mImageCornerSign = self:GetImage("Have/BG/QualitySubscript");
    self.mImageStar = self:GetRectTransform("Have/BG/Star");
    self.mImageUpRightSign = self:GetImage("Have/BG/QualityLine");
    self.mImageGunType = self:GetImage("Have/BG/GunType");
    self.mTextGunName = self:GetText("Have/BG/GunName");
    self.mTextGunHP = self:GetText("Have/BG/HP");
    self.mImageGunHP= self:GetImage("Have/BG/Asornment/HPBG");
    self.mImageGunFatigue = self:GetImage("Have/BG/FatigueBAR");
    self.mImageGunFatigueBattery = self:GetImage("Have/BG/FatigueBAR/Image");

    self.mButtonGunRepair = self:GetButton("Have/RepairButton");
    self.mTextPower = self:GetText("Have/PropertyPanel/CombatText");
    self.mTextLevel = self:GetText("Have/PropertyPanel/LVDetail");

    self.mNoGunObj=self.mUIRoot:Find("NoGun").gameObject;
    self.mHaveObj=self.mUIRoot:Find("Have").gameObject;


    self.mStarUpStarList=List:New();

end

function HalfDetailViewItem:SetData(data)

    if data~=nil then
        setactive(self.mNoGunObj,false);
        setactive(self.mHaveObj,true);
        local gundata = TableData.GetGunData(data.stc_gun_id);

        if gundata ~=nil then
            --半身立绘
            self.mImageMainHalf.sprite=CS.IconUtils.GetCharacterHeadSprite(gundata.code);

            --星级相关
            for i = 1, self.mStarUpStarList:Count() do
                setactive(self.mStarUpStarList[i],false)
            end


            for i = 1, data.upgrade do
                if i<=self.mStarUpStarList:Count() then
                    setactive(self.mStarUpStarList[i],true)
                else
                    local obj=instantiate(UIUtils.GetGizmosPrefab("UICommonFramework/StarA.prefab",self));
                    setparent(self.mImageStar,obj.transform);
                    obj.transform.localScale=vectorone;
                    self.mStarUpStarList:Add(obj);
                end
            end



            self.mImageCornerSign.color = TableData.GetGlobalGun_Quality_Color1(gundata.rank);
            ----self.mImageStar.sprite = UIUtils.GetGunMessageSprite("GunStar_"..gundata.rank);
            self.mImageUpRightSign.color = TableData.GetGlobalGun_Quality_Color2(gundata.rank);

            --枪的种类
            self.mImageGunType.sprite = UIUtils.GetGunMessageSprite("Combat_GunTypeIcon_"..tostring(gundata.typeInt));
            self.mTextGunName.text = gundata.name;

            --HP 血量
            self.type=12;
            local hpColorStr=TableData.GetGlobalCFHPColor();
            self.mTextGunHP.text = "<color=#"..hpColorStr..">"..data.hp.."</color>/"..data.max_hp;
            local hpPec=data.hp/data.max_hp;
            self.mImageGunHP.fillAmount=hpPec;
            self.mImageGunHP.color=TableData.GetGlobalGunHpColorByPec(hpPec);

            --fatigue 疲劳度
            local fatiguePec=data.wear_Pct;
            self.mImageGunFatigue.fillAmount = fatiguePec;
            local batterySpritename=TableData.GetGlobalGunFatigueBatterySpriteNameByPec(fatiguePec)
            --gfdebug(batterySpritename);
            self.mImageGunFatigueBattery.sprite=UIUtils.GetGunMessageSprite(batterySpritename);
            self.mImageGunFatigueBattery.color=TableData.GetGlobalGunFatigueBatteryColorByPec(fatiguePec)
            self.mImageGunFatigue.color = TableData.GetGlobalGunFatigueBatteryColorByPec(fatiguePec)
            self.mTextPower.text = data.Power;
            self.mTextLevel.text = data.level;


            --RepairGun

            local str1=NetTeamHandle:CheckRepairGun(data.id);

            if str1 =="" then
                self.mButtonGunRepair.interactable=true;
                UIUtils.GetListener(self.mButtonGunRepair.gameObject).onClick = self.OnRepairClick;
                UIUtils.GetListener(self.mButtonGunRepair.gameObject).param=data.id;
            else
                UIUtils.GetListener(self.mButtonGunRepair.gameObject).onClick = nil;
                UIUtils.GetListener(self.mButtonGunRepair.gameObject).param=nil;
                self.mButtonGunRepair.interactable=false;
                --gfdebug(str1);
            end



        end
    else
        setactive(self.mNoGunObj,true);
        setactive(self.mHaveObj,false);
    end
end


--维修人形--
function HalfDetailViewItem.OnRepairClick(gameobj)
    local eventClick=UIUtils.GetListener(gameobj);
    local isRepair=CampaignPool:TryCalRepairGun(eventClick.param);
    if (isRepair == true) then
        UIManager.OpenUI(UIDef.UIRepairConfirmPanel);
    else
        UIUtils.OpenNoticeUIPanel("这个枪 不能修")
    end
end


--endregion