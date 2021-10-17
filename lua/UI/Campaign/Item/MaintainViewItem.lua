---
--- Created by firwg.
--- DateTime: 2018/9/9 17:12
---


--region *.lua
--Date

require("UI.UIBaseCtrl")


--半身立绘视图
MaintainViewItem = class("MaintainViewItem", UIBaseCtrl);

MaintainViewItem.__index = MaintainViewItem;

--有人像时
MaintainViewItem.mHaveObj=nil;
MaintainViewItem.mImageHead = nil;--头像立绘
MaintainViewItem.mImageUpRightSign = nil;--品质竖标
MaintainViewItem.mImageStar = nil;--星星等级
MaintainViewItem.mTextGunType = nil;--抢种类型
MaintainViewItem.mTextGunName = nil;--抢种名字
--MaintainViewItem.mTextGunHP = nil;--枪种血量文字
--MaintainViewItem.mImageGunHP = nil;--枪种血条
MaintainViewItem.mImageGunFatigue = nil;--枪种疲劳度
--MaintainViewItem.mTextPower = nil;--枪种战力
--MaintainViewItem.mTextLevel = nil;--枪等级
MaintainViewItem.mButtonAccMaintain = nil;--加速维护按钮
MaintainViewItem.mTextMaintainTime = nil;--维护剩余时间

MaintainViewItem.mData = nil;


--已解锁  待添加
MaintainViewItem.mObjAdd=nil;
MaintainViewItem.mButtonAdd=nil;

--未解锁
MaintainViewItem.mObjLocked=nil;


MaintainViewItem.type=nil;


--构造
function MaintainViewItem:ctor()
    MaintainViewItem.super.ctor(self);
end

--初始化
function MaintainViewItem:InitCtrl(parent)

    --实例化
    local obj=instantiate(UIUtils.GetGizmosPrefab("Repair/MaintainListItem.prefab",self));
    self:SetRoot(obj.transform);
    setparent(parent,obj.transform);
    obj.transform.localScale=vectorone;

    --有的话
    self.mHaveObj=self.mUIRoot:Find("Have");
    self.mImageHead = self:GetImage("Have/MiddlePanel/GunHeadMask/HeadPic");
    self.mImageUpRightSign = self:GetImage("Have/GunInfoPanel/Image");
    self.mImageStar = self:GetImage("Have/TopPanel/GunStarPic");
    self.mTextGunType=self:GetText("Have/TopPanel/GunTypeText");
    self.mTextGunName = self:GetText("Have/GunInfoPanel/GunName");
    self.mImageGunFatigue = self:GetImage("Have/GunInfoPanel/GunFatigue");
    self.mButtonAccMaintain = self:GetButton("Have/SpeedUpBtn");
    self.mTextMaintainTime = self:GetText("Have/CountDownPanel/Text");
    --已解锁  待添加
    self.mObjAdd=self.mUIRoot:Find("Add");
    self.mButtonAdd=self:GetButton("Add/AddButton");
    --未解锁
    self.mObjLocked=self.mUIRoot:Find("Locked");

    --默认未解锁
    setactive(self.mObjLocked,true);
    setactive(self.mObjAdd,false);
    setactive(self.mHaveObj,false);

end

function MaintainViewItem:SetData(data)

    if data~=nil then
        setactive(self.mObjLocked,false);
        setactive(self.mObjAdd,false);
        setactive(self.mHaveObj,true);
        local gundata = TableData.GetGunData(data.stc_gun_id);
        if gundata ~=nil then
            self.mImageHead.sprite = CS.IconUtils.GetCharacterHeadSprite(gundata.code);
            self.mImageUpRightSign.color = TableData.GetGlobalGun_Quality_Color2(gundata.rank);
            self.mImageStar.sprite = UIUtils.GetGunMessageSprite("GunStar_"..gundata.rank);
            self.mTextGunName.text = gundata.name;

            self.mTextGunType.text=TableData.GetGlobalGunTypeName(gundata.typeInt);

            --fatigue 疲劳度
            local fatiguePec=data.wear_Pct;
            local batterySpritename=TableData.GetGlobalGunFatigueBatterySpriteNameByPec(fatiguePec);
            self.mImageGunFatigue.sprite=UIUtils.GetGunMessageSprite(batterySpritename);
            self.mImageGunFatigue.color=TableData.GetGlobalGunFatigueBatteryColorByPec(fatiguePec)
        end
    else
        setactive(self.mObjLocked,false);
        setactive(self.mObjAdd,true);
        setactive(self.mHaveObj,false);
    end
end


--endregion