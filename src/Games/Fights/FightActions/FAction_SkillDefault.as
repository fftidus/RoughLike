package Games.Fights.FightActions{
import Games.Datas.Data_FActionStep;

import com.MyClass.Tools.Tool_ObjUtils;

import Games.Fights.Fight_ActionCD;
import Games.Fights.Fight_ActionCost;

public class FAction_SkillDefault extends FAction_Default{
	public var cd:Fight_ActionCD;
	public var cost:Fight_ActionCost;
	public var Arr_aniStep:Array;//动画步骤，null表示播放完
	private var _nowStep:int;//当前动画的步骤
	
	public function FAction_SkillDefault(){
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
		super.resetF();
	}
	
	override protected function nextFrame():void {
		var rsm:Data_FActionStep;
		if(Arr_aniStep)rsm=Arr_aniStep[_nowStep];
		if(rsm==null || rsm.Arr_frame==null || rsm.loop==true){//没有帧数据，表示必然是循环播放动画！
			if(Role.mapRole && Role.mapRole.Role){
				nowIndex++;
				if(nowIndex >= Role.mapRole.Role.totalFrames){
					nowIndex=0;
				}
			}
		}else{
			if(nowIndex+1>=rsm.Arr_frame.length){
				nextStep();
			}else{
				nowIndex++;
			}
		}
		onDoFrameEvent();
	}
	
	/** 下一个步骤动作 */
	public function nextStep():void{
		if(isLoopAni == false){
			if(_nowStep+1 >=Arr_aniStep.length){
				onActEndF();
				return;
			}
			_nowStep++;
		}
		nowIndex=0;
	}
	
	public function get nowStep():int {return _nowStep;	}
	public function set nowStep(value:int):void {
		_nowStep = value;
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