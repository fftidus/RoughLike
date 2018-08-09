package Games.Models {
import Games.Datas.Data_Attack;
import Games.Fights.FightRole;

/**
 * 一次攻击
 * */
public class AttackModel {
    public var data:Data_Attack;
    /** 攻击来源 */
    public var fromRole:FightRole;
    /** 缓存命中率 */
    public var hit:int;
    /** 缓存是否暴击 */
    public var isCritical:Boolean=false;
    /** 缓存暴击值 */
    public var numCritical:int;
    
    public function AttackModel(from:FightRole,_data:Data_Attack) {
        data=_data;
        fromRole=from;
    }
    /** 削韧数量 */
    public function get costToughness():int{
        var base:int =fromRole
        data.perCostToughness;
    }
    
    public function destroyF():void{
        data=null;
        fromRole=null;
    }
}
}
