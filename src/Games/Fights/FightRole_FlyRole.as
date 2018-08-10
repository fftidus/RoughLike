package Games.Fights {
import Games.Map.Map_Object_FLys;

/**
 * 飞行物体、技能
 * */
public class FightRole_FlyRole extends FightRole{
    protected var ownerRole:FightRole;
    
    public function FightRole_FlyRole(_role:FightRole) {
        super(null);
        ownerRole=_role;
        mapRole=new Map_Object_FLys(this);
        mapRole.needHitOthers=false;
    }
    
    
    
    
    
    
}
}
