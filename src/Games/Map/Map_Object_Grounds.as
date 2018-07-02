package Games.Map {
import com.MyClass.Config;

public class Map_Object_Grounds extends Map_Object {
	public function Map_Object_Grounds() {
		super();
	}

	override public function get z():Number {return 0;}
	override public function set z(value:Number):void {Config.Log("地面不应该有z！");}
	override public function hitTestWith(obj:Map_Object):Boolean {Config.Log(" 地面不会有碰撞！");return false;}
}
}
