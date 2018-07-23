package Games.Fights{
import com.MyClass.Config;

import Games.Fights.FightActions.FAction_SkillDefault;

import laya.utils.Handler;

/**
 * 技能cd管理器
 * */
public class Fight_ActionCD{
	private var Role:FightRole;
	private var skill:FAction_SkillDefault;
	public var cd:Number;
	private var countCDmax:int;
	private var countCD:int=-1;
	public function Fight_ActionCD(r:FightRole,	_skill:FAction_SkillDefault){
		Role=r;
		skill=_skill;
		//TODO 初始化cd
	}
	
	public function canUse():Boolean{
		if(countCD>0)return false;
		return true;
	}
	/** 使用了技能 */
	public function resetF():void{
		if(cd>0){
			countCD =Config.playSpeedTrue * cd;
			countCDmax=countCD;
			Role.registEnterHandler(skill.Name+"_cd",Handler.create(this,enterF,null,false));
		}
	}
	
	public function enterF():void{
		countCD--;
		if(countCD <= 0){
			Role.removeEnterHandler(skill.Name+"_cd");
		}
	}
	
	public function destroyF():void{
		Role=null;
		skill==null;
	}
}
}