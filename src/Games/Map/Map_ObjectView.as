package Games.Map {
import com.MyClass.Tools.Tool_ObjUtils;

import starling.display.Sprite;

/**
 * 地图物体的显示元件
 * */
public class Map_ObjectView extends Sprite{
	public function Map_ObjectView() {
	}
	public function initF():void{
	}
	
	public function removeF():void{
		destroyF();
	}
	public function destroyF():void{
		Tool_ObjUtils.destroyDisplayObj(this);
	}
}
}
