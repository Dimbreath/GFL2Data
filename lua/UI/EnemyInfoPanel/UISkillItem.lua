require("UI.UIBaseCtrl")

UISkillItem = class("UISkillItem", UIBaseCtrl);
UISkillItem.__index = UISkillItem
--@@ GF Auto Gen Block Begin
UISkillItem.mImage_Icon = nil;
UISkillItem.mText_Name = nil;
UISkillItem.mTrans_Selected = nil;

function UISkillItem:__InitCtrl()

	self.mImage_Icon = self:GetImage("Icon/Image_Icon");
	self.mText_Name = self:GetText("Text_Name");
	self.mTrans_Selected = self:GetRectTransform("Trans_Selected");
end

--@@ GF Auto Gen Block End

function UISkillItem:InitCtrl(parent)
    --实例化
    local obj=instantiate(UIUtils.GetGizmosPrefab("SLG/UISkillItem.prefab",self));
    self:SetRoot(obj.transform);
    setparent(parent,obj.transform);
    obj.transform.localScale=vectorone;
    self:SetRoot(obj.transform);
    self:__InitCtrl();
end



function UISkillItem:SetData(data)
    if data~=nil then
        setactive(self.mUIRoot,true);
        self.mImage_Icon = CS.IconUtils.GetIconSprite(12,data.icon);
        self.mText_Name.text=data.name;
    else
        setactive(self.mUIRoot,false);
    end
end

function UISkillItem:SetSelected(state)
    setactive(self.mTrans_Selected,state);
end