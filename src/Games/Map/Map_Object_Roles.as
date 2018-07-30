package Games.Map {
import Games.Models.RoleModel;

public class Map_Object_Roles extends Map_Object{
    public var RM:RoleModel;
    public function Map_Object_Roles(rm:RoleModel) {
        super();
        RM=rm;
    }
    override public function initF(data:*,info:*):void{
        super.initData(data,info);
        if(Role==null){
            Role=new Map_ObjectView_Roles(this);
            this.addChild(Role);
        }
    }
    
}
}
