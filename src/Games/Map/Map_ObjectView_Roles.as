package Games.Map {
import starling.display.Canvas;

public class Map_ObjectView_Roles extends Map_ObjectView{
    public function Map_ObjectView_Roles() {
        super();
        var can:Canvas=new Canvas();
        can.beginFill(0xFFFFFF);
        can.drawCircle(0,-25,50);
        can.endFill();
        this.addChild(can);
    }
}
}
