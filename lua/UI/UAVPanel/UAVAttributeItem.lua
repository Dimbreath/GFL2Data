require("UI.UIBaseCtrl")

UAVAttributeItem = class("UAVAttributeItem", UIBaseCtrl);
UAVAttributeItem.__index = UAVAttributeItem

function UAVAttributeItem:__InitCtrl()
    self.mText_Name=self:GetText("GrpText/TextName")
    self.mText_Num=self:GetText("Text_Num")
end


function UAVAttributeItem:InitCtrl(root)
	self:SetRoot(root)
	self:__InitCtrl()

end

function UAVAttributeItem:InitData(Name,Num)
    self.mText_Name.text=Name
    self.mText_Num.text=Num
end


