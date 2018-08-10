package Games.Map {
import Games.Fights.FightRole_FlyRole;

public class Map_Object_FLys extends Map_Object{
    private var roleFight:FightRole_FlyRole;
    public function Map_Object_FLys(fr:FightRole_FlyRole) {
        super();
        roleFight=fr;
    }

    override public function moveF(moveWaite:*):void {
        if(moveWaite==null)return;
        if(map==null){return; }
        if(moveWaite.x != null)this.x += moveWaite.x;
        if(moveWaite.y != null)this.y += moveWaite.y;
    }

    override public function destroyF():void {
        super.destroyF();
        roleFight=null;
    }
}
}
