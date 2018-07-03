package Games.Map {
public class Map_Object_Roles extends Map_Object{
    public function Map_Object_Roles() {
        super();
    }
    override public function initF(data:*,info:*):void{
        super.initData(data,info);
        if(Role==null){
            Role=new Map_ObjectView_Roles();
            this.addChild(Role);
        }
    }
    
    
}
}
