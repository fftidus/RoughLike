package Games.Fights.FightActions {
import Games.Fights.FightRole;
/**
 * 被击动作，包含硬直、浮空、击飞、击退过程。不包括落地！
 * */
public class FAction_Hurt extends FAction_Default{
	private var nowFlag:String;
	public function FAction_Hurt(fr:FightRole) {
		Role=fr;
		Name="被击";
	}
    override public function resetF():void {
        super.resetF();
    }
}
}
