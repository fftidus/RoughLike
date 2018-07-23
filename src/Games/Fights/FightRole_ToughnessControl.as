package Games.Fights {
	import laya.utils.Handler;

/**
 * 战斗角色的韧性控制，韧性被攻击时减少，进入受伤状态后恢复，或无伤状态30秒后恢复，技能会提供韧性倍率，每次使用技能会重置为当前韧性 * 倍率。
 * */
public class FightRole_ToughnessControl {
    private var Role:FightRole;
    public function FightRole_ToughnessControl(role:FightRole) {
        Role=role;
		Role.registEnterHandler("韧性",Handler.create(this,enterF,null,false));
    }
    
    public function enterF():void{
        
    }
    
    
    public function destroyF():void{
        Role=null;
    }
}
}
