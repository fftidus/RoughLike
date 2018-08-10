package Games.Models {
import Games.Datas.Data_Attack;
import Games.Fights.FightRole;

/**
 * 一次攻击
 * */
public class AttackModel {
    public var data:Data_Attack;
    /** 攻击来源，角色或飞行 */
    public var fromRole:FightRole;
    
    public function AttackModel(from:FightRole,_data:Data_Attack) {
        data=_data;
        fromRole=from;
    }
    /** 削韧数量 */
    public function get costToughness():int{
//        var base:int =fromRole
//        data.perCostToughness;
		return 0;
    }
    
    public function destroyF():void{
        data=null;
        fromRole=null;
    }
}
}
