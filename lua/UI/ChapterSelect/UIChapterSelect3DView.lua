--region *.lua

require("UI.UIBasePanel")

UIChapterSelect3DView = class("UIChapterSelect3DView", UIBaseView);
UIChapterSelect3DView.__index = UIChapterSelect3DView;

UIChapterSelect3DView.mChapterInfo = nil;
UIChapterSelect3DView.mText_ChpaterName = nil;
UIChapterSelect3DView.mText_ChpaterNameEng = nil;
UIChapterSelect3DView.mText_SuppressRate = nil;
UIChapterSelect3DView.mText_SuggestedLV = nil;
UIChapterSelect3DView.mText_ProgressRate = nil;
UIChapterSelect3DView.mImage_ProgressRate = nil;

UIChapterSelect3DView.mTweens = nil;
UIChapterSelect3DView.mProgresssRateTweens = nil;

--构造
function UIChapterSelect3DView:ctor()
    UIAreaSelect3DView.super.ctor(self);
end

function UIChapterSelect3DView:InitCtrl(root, data)

    self:SetRoot(root);

    self.mChapterInfo = self:FindChild("ChapterInfo");

    self.mText_ChapterName = self:GetText("ChapterInfo/Chapter/ChapterName");
    self.mText_ChapterNameEng = self:GetText("ChapterInfo/Chapter/ChapterNameEng");
    self.mText_SuppressRate = self:GetText("ChapterInfo/Chapter/SuppressRate/Number");
    self.mText_SuggestedLV = self:GetText("ChapterInfo/Chapter/SuggestedLV/Lv");
    self.mText_ProgressRate = self:GetText("ChapterInfo/Chapter/ProgressRate");
    self.mImage_ProgressRate = self:GetImage("ChapterInfo/Chapter/Progress/Fill");
    
    self.mTweens = List:New("Tweens");
    self.mTweens:Add(getchildcomponent(root, "ChapterInfo/Chapter/SuppressRate", typeof(CS.TweenImageSize)));
    self.mTweens:Add(getchildcomponent(root, "ChapterInfo/Chapter/SuggestedLV", typeof(CS.TweenImageSize)));
    self.mTweens:Add(getchildcomponent(root, "ChapterInfo/Connect/Image", typeof(CS.TweenImageSize)));
    self.mTweens:Add(getchildcomponent(root, "ChapterInfo/Connect/Image2", typeof(CS.TweenImageSize)));
    self.mTweens:Add(getchildcomponent(root, "ChapterInfo/Connect/Image3", typeof(CS.TweenScale)));
    self.mTweens:Add(getchildcomponent(root, "ChapterInfo/Connect/Image3", typeof(CS.TweenFade)));
    self.mTweens:Add(getcomponent(self.mText_ChapterNameEng.gameObject, typeof(CS.TweenFade)));
    self.mTweens:Add(getchildcomponent(root, "ChapterInfo/Chapter/Progress/Back", typeof(CS.TweenImageSize)));
    self.mTweens:Add(getcomponent(self.mText_ProgressRate.gameObject, typeof(CS.TweenFade)));
    self.mTweens:Add(getchildcomponent(self.mText_ProgressRate.gameObject, "Text", typeof(CS.TweenFade)));

    self.mProgresssRateTweens = getcomponent(self.mImage_ProgressRate.gameObject, typeof(CS.TweenImageFillAmount));
    self.mTypeWritterText = getcomponent(self.mText_ChapterName.gameObject, typeof(CS.TypeWritterText));

end

function UIChapterSelect3DView:SetData(data)
    
    setposition(self.mChapterInfo, data.ui_panel_position);
    self.mText_ChapterName.text = data.name;
    self.mTypeWritterText:StartTyper();
    self.mText_ChapterNameEng.text = data.name_eng;
    local overview = CampaignPool:GetChapterOveriew(data.id);

    if overview ~= nil then
        local suppressedpecent = 0;
        if overview.all_zone_num > 0 then
            suppressedpecent = (overview.suppressed_num / overview.all_zone_num) * 100;
        end
        self.mText_SuppressRate.text = string.format("%d", suppressedpecent)..'%';
        self.mText_SuggestedLV.text = "Lv1";
        local missionpecent = 0;
        if overview.all_mission_num > 0 then
            missionpecent = overview.mission_num / overview.all_mission_num;
        end
        self.mText_ProgressRate.text = string.format("%d", (missionpecent * 100))..'%';
        self.mProgresssRateTweens.to = missionpecent;
        self.mProgresssRateTweens:Play();
    else 
        self.mText_SuppressRate.text = "0%";
        self.mText_SuggestedLV.text = "Lv1";
        self.mText_ProgressRate.text = "0%";
        self.mImage_ProgressRate.fillAmount = 0;
        self.mProgresssRateTweens:Kill();
    end

    for i = 1, self.mTweens:Count() do
        self.mTweens[i]:Kill();
        self.mTweens[i]:Play();
    end
end
--endregion
