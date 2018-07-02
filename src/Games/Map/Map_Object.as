package Games.Map{
import com.MyClass.Tools.Tool_ObjUtils;
	
	import starling.display.Sprite;

/**
 * 地图上的所有物体
 * */
public class Map_Object	{
	public var Role:Sprite
	private var _x:Number=0;
	private var _y:Number=0;
	private var _z:Number=0;
	public var width:int;
	public var height:int;
	
	public function Map_Object(){
	}
	
	
	public function get x():Number {
		return _x;
	}
	public function set x(value:Number):void {
		_x = value;
	}
	public function get y():Number {
		return _y;
	}
	public function set y(value:Number):void {
		_y = value;
	}
	public function get z():Number {
		return _z;
	}
	public function set z(value:Number):void {
		_z = value;
	}



	public function destroyF():void{
		Role=Tool_ObjUtils.destroyF_One(Role);
	}
}
}