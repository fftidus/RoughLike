package Games.Map {
import com.MyClass.MySourceManager;
import com.MyClass.MyView.MyMC;
import com.MyClass.Tools.Tool_ObjUtils;

import starling.display.Canvas;

public class Map_ObjectView_Roles extends Map_ObjectView{
    private var mapRole:Map_Object_Roles;
    private var can:Canvas;
    
    public function Map_ObjectView_Roles(_role:Map_Object_Roles) {
        super();
        mapRole=_role;
    }

    override public function initBaseMc(swf:String, url:String):void {
        if(mapRole.RM.spine != null){
            if(mc==null){
                var zmc:* =MySourceManager.getInstance().getMcFromSwf(mapRole.RM.spine,mapRole.RM.spine);
                if(zmc){
                    mc=new MyMC(zmc);
                    this.addChild(mc);
                }
            }
            if(mc){
                mc.gotoAndStopLabel(url);
            }
        }else{
            mc=Tool_ObjUtils.destroyF_One(mc);
//            if(swf && swf.indexOf("Roles/")!=0)swf="Roles/"+swf;
            var smc:* =MySourceManager.getInstance().getMcFromSwf(swf,url);
            if(smc){
                mc=new MyMC(smc);
                this.addChild(smc);
            }
        }
        //TODO 测试碰撞完毕后删除canvas
        can=Tool_ObjUtils.destroyF_One(can);
        if(mc==null){
            can=new Canvas();
            can.beginFill(0xFFFFFF);
            can.drawCircle(-0,-0,50);
            can.endFill();
            this.addChild(can);
        }
    }
}
}
