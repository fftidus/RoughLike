package Games.Fights {
import laya.utils.Handler;

/**
 * 战斗角色的韧性控制，韧性被攻击时减少，进入受伤状态后恢复，或无伤状态30秒后恢复，技能会提供韧性倍率，每次使用技能会重置为当前韧性 * 倍率。
 * */
public class FightRole_ToughnessControl {
    private var Role:FightRole;
    private var baseToughness:int;
    private var _nowToughness:int;
    public function FightRole_ToughnessControl(role:FightRole) {
        Role=role;
		Role.registEnterHandler("韧性",Handler.create(this,enterF,null,false));
        baseToughness=Role.valueFight.toughness;
        if(baseToughness==0)baseToughness=100;
        nowToughness=baseToughness;
    }
    
    public function resetToughness(value:int):void{
        nowToughness=value;
    }
    
    public function enterF():void{
        
    }
    
    
    public function get nowToughness():int {
        return _nowToughness;
    }
    public function set nowToughness(value:int):void {
        _nowToughness = value;
    }


    public function destroyF():void{
        Role=null;
    }
}
}
