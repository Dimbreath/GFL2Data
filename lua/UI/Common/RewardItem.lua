---
--- Created by firwg.
--- DateTime: 2018/10/22 17:12
---


--region *.lua
--Date

require("UI.UIBaseCtrl")

--头像立绘视图
RewardItem = class("RewardItem", UIBaseCtrl);

RewardItem.__index = RewardItem;

RewardItem.mImage_Icon = nil;
RewardItem.mText_Num = nil;
RewardItem.mObj = nil;

--构造
function RewardItem:ctor()
    RewardItem.super.ctor(self);
end

--初始化
function RewardItem:InitCtrl(root)
    mObj=instantiate(UIUtils.GetGizmosPrefab("CampaignMission/RewardItem.prefab",self));
    self:SetRoot(mObj.transform);
    setparent(root,mObj.transform);
    mObj.transform.localScale=vectorone;
    self.mImage_Icon = self:GetImage("Icon");
    self.mText_Num = self:GetText("Number");
end

--设置枪 数据
function RewardItem:SetData(itemdata)

    if itemdata~=nil then
        setactive(mObj,true);
        self.mText_Num.text = itemdata.num;
        self.mImage_Icon.sprite=CS.IconUtils.GetIconSprite(CS.GF2Icon.Item,itemdata.item.icon);
    else
        setactive(mObj,false);

        --gfdebug("Data===null");
    end

end



--endregion