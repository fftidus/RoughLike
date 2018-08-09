package Games.Fights.FightActions{
import Games.Datas.Data_FActionStep;
import Games.Models.SkillModel;

import com.MyClass.Tools.Tool_ObjUtils;

import Games.Fights.Fight_ActionCD;
import Games.Fights.Fight_ActionCost;

public class FAction_SkillDefault extends FAction_Default{
	public var skillmodel:SkillModel;
	public var cd:Fight_ActionCD;
	public var cost:Fight_ActionCost;
	public var Arr_aniStep:Array;//动画步骤，null表示播放完
	private var _nowStep:int;//当前动画的步骤
	
	public function FAction_SkillDefault(){
        isSpdEffectByValue="攻速";
	}
	public function initFromSkillModel(sm:SkillModel):void{
		skillmodel=sm;
		if(sm.cd>0) {
            cd = new Fight_ActionCD(Role, this);
        }
        if(skillmodel.costValue!=null) {
            cost = new Fight_ActionCost(Role,skillmodel);
        }
		Arr_aniStep=skillmodel.Steps;
	}
	
	override public function canUse():Boolean	{
		if(cd && cd.canUse()==false){
			return false;
		}
		if(cost && cost.canUse() == false){
			return false;
		}
		return super.canUse();
	}
	
	override public function resetF():void{
		if(cd){
			cd.resetF();
		}
		nowStep=0;
		Role.IronCon.onClearF();
		super.resetF();
	}
	
	override protected function nextFrame():void {
		var rsm:Data_FActionStep=Arr_aniStep[nowStep];
		if(rsm==null || rsm.Arr_frame==null || rsm.loop==true){//没有帧数据，表示必然是循环播放动画！
			if(Role.mapRole && Role.mapRole.Role){
				nowIndex++;
				if(nowIndex >= Role.mapRole.Role.totalFrames){
					if(rsm.loop==true) {
						nowIndex = 0;
					}else{
						nextStep();
					}
				}
			}
		}else{
			if(nowIndex+1>=rsm.Arr_frame.length){
				nextStep();
			}else{
				nowIndex++;
			}
		}
		onCheckToPlaySound();
		setRoleFrameToIndex();
		onDoFrameEvent();
	}
	/** 技能的nowIndex只是在step中的下标，不是帧 */
    override protected function setRoleFrameToIndex():void {
        if(Role.mapRole.Role!=null && isEnd==false){
            var rsm:Data_FActionStep=Arr_aniStep[nowStep];
			if(rsm && rsm.Arr_frame) {
                Role.mapRole.Role.currentFrame = rsm.Arr_frame[nowIndex];
            }
        }
    }
	/** 直接获得当前帧 */
	protected function get nowFrame():int{
        var rsm:Data_FActionStep=Arr_aniStep[nowStep];
        if(rsm && rsm.Arr_frame) {
           return rsm.Arr_frame[nowIndex];
        }
		return -1;
	}

    override protected function onDoFrameEvent():void {
		if(isEnd==false){return;}
        setGodEndure();
	}
    /** 设置霸体、无敌等 **/
	protected function setGodEndure():void{
        var rsm:Data_FActionStep=Arr_aniStep[nowStep];
        if(rsm.isEndure==true){
            if(rsm.frameEndure==null){
				addEndure();
            }else if(rsm.frameEndure.indexOf(nowFrame) != -1){
				addEndure();
			}else{
				removeEndure();
			}
        }
        if(rsm.isGod==true){
            if(rsm.frameGod==null){
                addGod();
            }else if(rsm.frameGod.indexOf(nowFrame) != -1){
                addGod();
            }else{
                removeGod();
            }
        }
	}
	
	/** 下一个步骤动作 */
	public function nextStep():void{
		if(isLoopAni == false){
			if(nowStep+1 >=Arr_aniStep.length){
				onActEndF();
				return;
			}
			nowStep++;
			onChangeRoleMcByURL();
		}
		nowIndex=0;
        setGodEndure();
	}
	
	public function get nowStep():int {return _nowStep;	}
	public function set nowStep(value:int):void {
		_nowStep = value;
		var rsm:Data_FActionStep=Arr_aniStep[_nowStep];
		swf=rsm.swf;
		url=rsm.url;
		soundData=rsm.soundInfo;
		isLoopAni=rsm.loop;
		hitArea=rsm.hitArea;
	}
	
	override public function breakF():void	{
		super.breakF();
	}
	override public function destroyF():void{
		cd=Tool_ObjUtils.destroyF_One(cd);
		cost=Tool_ObjUtils.destroyF_One(cost);
		super.destroyF();
	}
	
	
	
}
}