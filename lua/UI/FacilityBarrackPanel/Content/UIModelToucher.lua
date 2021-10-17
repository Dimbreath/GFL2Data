UIModelToucher = {}
UIModelToucher.weaponToucher = nil
UIModelToucher.startEuler = nil
UIModelToucher.startScale = nil
UIModelToucher.weaponToucherEventEnd = nil
UIModelToucher.weaponToucherEventBegin = nil
UIModelToucher.weaponModel = nil
UIModelToucher.characterToucher = nil
UIModelToucher.lastTweener = nil


function UIModelToucher.CreateWeapon(weaponCmd)
	UIModelToucher.weaponModel = CS.ResSys.Instance:GetBarrackWeaponInstance(weaponCmd.ModelShow)
	UIModelToucher.weaponModel.transform.position = UIUtils.SplitStrToVector(weaponCmd.Position)
	UIModelToucher.weaponModel.transform.localScale = UIUtils.SplitStrToVector(weaponCmd.Scale)
	UIModelToucher.weaponModel.transform.localEulerAngles = UIUtils.SplitStrToVector(weaponCmd.Rotation)
	UIModelToucher.startEuler = UIModelToucher.weaponModel.transform.localEulerAngles
	UIModelToucher.startScale = UIModelToucher.weaponModel.transform.localScale;
	
	GFUtils.MoveToLayer(UIModelToucher.weaponModel.transform,CS.UnityEngine.LayerMask.NameToLayer("Friend"))
	UIModelToucher.AttachWeaponTransToTouch(UIModelToucher.weaponModel)
	
	return UIModelToucher.weaponModel;
end

function UIModelToucher.OnWeaponTouchEnd(v2)
	UIModelToucher.lastTweener = CS.UITweenManager.PlayRotationTween(UIModelToucher.weaponModel.transform, 
		UIModelToucher.weaponModel.transform.localEulerAngles, UIModelToucher.startEuler, 
		UIModelToucher.weaponToucher.ResetDuration, 0, nil, UIModelToucher.weaponToucher.EaseType,
		 CS.DG.Tweening.RotateMode.Fast);
end

function UIModelToucher.OnWeaponTouchBegin(v2)
	if UIModelToucher.lastTweener ~= nil then
		CS.UITweenManager.TweenKill(UIModelToucher.lastTweener)
	end
end

function UIModelToucher.ReleaseWeaponToucher()
	UIModelToucher.DetachAllWeaponEvents()
	UIModelToucher.weaponToucher = nil
	UIModelToucher.weaponToucherEventBegin = nil
	UIModelToucher.weaponToucherEventEnd = nil
end

function UIModelToucher.DetachAllWeaponEvents()
	if(UIModelToucher.weaponToucher ~= nil) then
		if UIModelToucher.weaponToucherEventEnd ~= nil then
			UIModelToucher.weaponToucher:DetachOneFingerDraggingEndHandle(UIModelToucher.weaponToucherEventEnd)
			UIModelToucher.weaponToucher:DetachTwoFingerDraggingEndHandle(UIModelToucher.weaponToucherEventEnd)
		end

		if UIModelToucher.weaponToucherEventBegin then
			UIModelToucher.weaponToucher:DetachOneFingerDraggingBeingHandle(UIModelToucher.weaponToucherEventBegin)
			UIModelToucher.weaponToucher:DetachTwoFingerDraggingBeingHandle(UIModelToucher.weaponToucherEventBegin)
		end
	end
end

function UIModelToucher.ReleaseCharacterToucher()
	UIModelToucher.characterToucher = nil
end


function UIModelToucher.AttachCharacterTransToTouch(gameObject)
	local camera = UISystem.CharacterCamera
	UIModelToucher.characterToucher = CS.CharacterCameraScaleController.Get(camera.gameObject)
	UIModelToucher.characterToucher:SetModel(gameObject)
end

function UIModelToucher.AttachWeaponTransToTouch(gameObject)
	local camera = UISystem.CharacterCamera
	UIModelToucher.weaponToucher = CS.WeaponTouchController.Get(camera.gameObject)
	UIModelToucher.weaponToucher:SetModel(gameObject)
end

--------------------------------------------
--
--    必须在界面打开或者需要的时候调用      --
--
--------------------------------------------
--1 = character, 2 = weapon
function UIModelToucher.SwitchToucher(type)
	local camera = UISystem.CharacterCamera
	UIModelToucher.characterToucher = CS.CharacterCameraScaleController.Get(camera.gameObject)
	if UIModelToucher.characterToucher == nil then
		return
	end
	UIModelToucher.weaponToucher = CS.WeaponTouchController.Get(camera.gameObject)
	if UIModelToucher.weaponToucher == nil then
		return
	end
	UIModelToucher.weaponToucher:DetachEvents()
	UIModelToucher.characterToucher:DetachEvents()
	UIModelToucher.DetachAllWeaponEvents()
	
	if type == 1 then
		UIModelToucher.characterToucher.enabled = true
		UIModelToucher.weaponToucher.enabled = false
		UIModelToucher.characterToucher:AttachEvents()
	elseif type == 2 then
		UIModelToucher.characterToucher.enabled = false
		UIModelToucher.weaponToucher.enabled = true
		UIModelToucher.weaponToucher:AttachEvents()
		UIModelToucher.AttachWeaponTouchEvents()
	end
end

function UIModelToucher.AttachWeaponTouchEvents()
	if UIModelToucher.weaponToucher == nil then
		return
	end
	if UIModelToucher.weaponToucherEventEnd == nil then
		UIModelToucher.weaponToucherEventEnd = function (v2)
			UIModelToucher.OnWeaponTouchEnd(v2)
		end
	end
	
	UIModelToucher.weaponToucher:AttachOneFingerDraggingEndHandle(UIModelToucher.weaponToucherEventEnd);
	UIModelToucher.weaponToucher:AttachTwoFingerDraggingEndHandle(UIModelToucher.weaponToucherEventEnd);
	
	if UIModelToucher.weaponToucherEventBegin == nil then
		UIModelToucher.weaponToucherEventBegin = function (v2)
			UIModelToucher.OnWeaponTouchBegin(v2)
		end
	end
	
	UIModelToucher.weaponToucher:AttachOneFingerDraggingBeingHandle(UIModelToucher.weaponToucherEventBegin);
	UIModelToucher.weaponToucher:AttachTwoFingerDraggingBeingHandle(UIModelToucher.weaponToucherEventBegin);

end
