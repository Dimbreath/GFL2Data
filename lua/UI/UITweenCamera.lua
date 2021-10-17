require("UI.UIManager")
require("UI.UIUtils")

UITweenCamera = {};

UITweenCamera.TweenTrans = nil;

-- function UITweenCamera.TweenCamera(cameraTrans,targetTrans)
    -- --cameraTrans.eulerAngles = targetTrans.eulerAngles;
	-- UITweenCamera.TweenTrans = cameraTrans;
    -- DOTween.TweenPosition(GetTweenPos, SetTweenPos, targetTrans.position, 0.5);
    -- DOTween.TweenPosition(GetTweenRot, SetTweenRot, targetTrans.forward, 0.5);
-- end

function UITweenCamera.TweenCamera(cameraTrans,targetTrans,duration)
    --cameraTrans.eulerAngles = targetTrans.eulerAngles;
	UITweenCamera.TweenTrans = cameraTrans;
    DOTween.TweenPosition(GetTweenPos, SetTweenPos, targetTrans.position, duration);
    DOTween.TweenPosition(GetTweenRot, SetTweenRot, targetTrans.forward, duration);
end

function GetTweenPos()
    return UITweenCamera.TweenTrans.position;
end

function SetTweenPos(position)
    UITweenCamera.TweenTrans.position = position;
end

function GetTweenRot()
    return UITweenCamera.TweenTrans.forward;
end

function SetTweenRot(forward)
    UITweenCamera.TweenTrans.forward = forward;
end
