package Games.Map{
import com.MyClass.Tools.MyHitArea;
import com.MyClass.Tools.Tool_ObjUtils;
/**
 * 地图上的所有物体
 * */
public class Map_Object	{
	public var Role:Map_ObjectRole;
	private var _x:Number=0;
	private var _y:Number=0;
	private var _z:Number=0;
	public var hitArea:MyHitArea;
	
	public function Map_Object(){

	}

	public function initHitArea(dic:*):Boolean{
		var hitArea:MyHitArea = MyHitArea.getHitArea(dic);
		if(hitArea != null){
			this.hitArea = hitArea;
			return true;
		}
		return false;
	}

	public function get x():Number {return _x;}
	public function set x(value:Number):void {
		_x = value;
	}
	public function get y():Number {return _y;}
	public function set y(value:Number):void {
		_y = value;
	}
	public function get z():Number {return _z;}
	public function set z(value:Number):void {
		_z = value;
	}
	
	/** 碰撞检测 */
	public function hitTestWith(obj:Map_Object):Boolean{
		if(this.hitArea==null || obj.hitArea==null){return false;}
		return hitArea.hitTest(obj.hitArea,this._x,this._y,this._z,obj._x,obj._y,obj._z);
	}

	public function destroyF():void{
		Role=Tool_ObjUtils.destroyF_One(Role);
	}
}
}