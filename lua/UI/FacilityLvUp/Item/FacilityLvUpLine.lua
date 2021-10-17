require("UI.UIBaseCtrl")

FacilityLvUpLine = class("FacilityLvUpLine", UIBaseCtrl);
FacilityLvUpLine.__index = FacilityLvUpLine
--@@ GF Auto Gen Block Begin
FacilityLvUpLine.mImage_Line3 = nil;
FacilityLvUpLine.mImage_Line = nil;
FacilityLvUpLine.mImage_arrow = nil;
FacilityLvUpLine.mImage_Line2 = nil;
FacilityLvUpLine.mImage_Line1 = nil;
FacilityLvUpLine.mText_Preview = nil;

function FacilityLvUpLine:__InitCtrl()

	self.mImage_Line3 = self:GetImage("LineRoot/Image_Line3");
	self.mImage_Line = self:GetImage("LineRoot/Image_Line");
	self.mImage_arrow = self:GetImage("LineRoot/Image_arrow");
	self.mImage_Line2 = self:GetImage("LineRoot/Image_Line2");
	self.mImage_Line1 = self:GetImage("LineRoot/Image_Line1");
	self.mText_Preview = self:GetText("Text_Lv_Preview");
end

--@@ GF Auto Gen Block End

FacilityLvUpLine.mStartFacID=nil;
FacilityLvUpLine.mEndFacID=nil;

function FacilityLvUpLine:InitCtrl(root,startID,endID)
    self:SetRoot(root);
    self:__InitCtrl();
    self.mStartFacID=startID;
    self.mEndFacID=endID;
end

function FacilityLvUpLine:UpdateView()

    local cmdData=NetCmdFacilityData:GetFacilityCmdDataById(self.mEndFacID);

    if cmdData ~=nil then

        local facilityPropertyData=TableData.GetFacilityPropertyData(self.mEndFacID,cmdData.level);
        --等级

        self.mText_Preview.text="Lv."..facilityPropertyData:GetRequestFacilityLv(self.mStartFacID);

        --线条颜色



    else
        gferror("[设施升级树]不存在服务器设施数据 ID："..self.mEndFacID);
    end

end






