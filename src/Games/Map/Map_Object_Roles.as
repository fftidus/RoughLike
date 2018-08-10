package Games.Map {
import Games.Fights.FightRole;
import Games.Models.RoleModel;

public class Map_Object_Roles extends Map_Object{
    private var roleFight:FightRole;
    public var RM:RoleModel;
    public function Map_Object_Roles(fr:FightRole) {
        super();
        roleFight=fr;
        RM=fr.baseRoleMo;
        needHitOthers=false;
    }
    override public function initF(data:*,info:*):void{
        super.initData(data,info);
        if(Role==null){
            Role=new Map_ObjectView_Roles(this);
            this.addChild(Role);
        }
    }

    override public function destroyF():void {
        super.destroyF();
        roleFight=null;
        RM=null;
    }
}
}
