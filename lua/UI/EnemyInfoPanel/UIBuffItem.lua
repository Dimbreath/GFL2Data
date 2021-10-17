require("UI.UIBaseCtrl")

UIBuffItem = class("UIBuffItem", UIBaseCtrl);
UIBuffItem.__index = UIBuffItem
--@@ GF Auto Gen Block Begin
UIBuffItem.mImage_Icon = nil;
UIBuffItem.mText_Tier = nil;
UIBuffItem.mTrans_Tier = nil;
UIBuffItem.mTrans_Selected = nil;

function UIBuffItem:__InitCtrl()

	self.mImage_Icon = self:GetImage("Image_Icon");
	self.mText_Tier = self:GetText("Trans_Text_Tier");
	self.mTrans_Tier = self:GetRectTransform("Trans_Text_Tier");
	self.mTrans_Selected = self:GetRectTransform("Trans_Selected");
end

--@@ GF Auto Gen Block End

function UIBuffItem:InitCtrl(parent)
    --实例化
    local obj=instantiate(UIUtils.GetGizmosPrefab("SLG/UIBuffItem.prefab",self));
    self:SetRoot(obj.transform);
    setparent(parent,obj.transform);
    obj.transform.localScale=vectorone;

    self:SetRoot(obj.transform);
    self:__InitCtrl();
end

function UIBuffItem:SetData(data)
    if data~=nil then
        setactive(self.mUIRoot,true);
        self.mImage_Icon.sprite = CS.IconUtils.GetIconSprite(11,data.BuffData.icon_name);

        self.mText_Tier = data.BuffTier;

        if data.BuffTier >1 then
            setactive(self.mTrans_Tier,true);
        else
            setactive(self.mTrans_Tier,false);
        end
    else
        setactive(self.mUIRoot,false);
    end
end

function UIBuffItem:SetSelected(state)
    setactive(self.mTrans_Selected,state);
end