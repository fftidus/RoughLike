package Games.Fights.FightActions{
import com.MyClass.Tools.Tool_ObjUtils;

import Games.Fights.Fight_ActionCD;
import Games.Fights.Fight_ActionCost;

public class FAction_SkillDefault extends FAction_Default{
	public var cd:Fight_ActionCD;
	public var cost:Fight_ActionCost;
	
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
		super.resetF();
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