package Games.Map{
import com.MyClass.Tools.MyHitArea;
import com.MyClass.Tools.MyPools;
import com.MyClass.Tools.Tool_ArrayUtils;
import com.MyClass.Tools.Tool_ObjUtils;

import Games.Controller_Scene;
import Games.Map.Datas.MapData_Grip;

import starling.display.Sprite;

/**
 * 地图上的所有物体
 * */
public class Map_Object extends Sprite{
	public static const PoolName_Ground:String="Map_G";
    public static function getOne(data:MapData_Grip,    info:*):Map_Object{
		if(info["层级"]<4) {
			var pool:MyPools;
			if(Controller_Scene.getInstance().nowScene){
				pool=Controller_Scene.getInstance().nowScene.pool;
			}
            if (pool && pool.hasPool(PoolName_Ground) == false) {
                pool.registF(PoolName_Ground);
            }
            var one:Map_Object;
			if(pool){
				one= pool.getFromPool(PoolName_Ground);
            }
            if (one == null) {
                one = new Map_Object_Grounds();
            }
            one.initF(data, info);
        }else{
			one =new Map_Object();
            one.initF(data, info);
		}
        return one;
    }
    /*******************************************************************************/
    /*******************************************************************************/
	public var map:MAP_Instance;
	public var Role:Map_ObjectView;
	private var _z:Number=0;
	public var index:int=1;
	public var hitArea:MyHitArea;
	
	public function Map_Object(){
	}
	protected function initData(data:*,	info:*):void{
        if(info) {
            if (info["x"] != null) this.x = info.x;
            if (info["y"] != null) this.y = info.y;
            if (info["层级"] != null) this.index = info["层级"];
        }
        if(data && data.hitRec)initHitArea(data.hitRec);
	}
	
	public function initF(data:*,	info:*):void{
		initData(data,info);
        if(Role==null){
            Role=Map_ObjectView.getOne(data.swf,data.Url);
            this.addChild(Role);
        }
        Role.initBaseMc(null,null);
	}

	public function initHitArea(dic:*):Boolean{
		var hitArea:MyHitArea = MyHitArea.getHitArea(dic);
		if(hitArea != null){
			this.hitArea = hitArea;
			return true;
		}
		return false;
	}
	
	/**
	 * 移动XY，判断碰撞
	 * */
	public function moveF(moveWaite:*):void{
		if(hitArea==null){
			hitArea=new  MyHitArea();
			hitArea.initFromDic({"type":2,"p":{"x":0,"y":0},"r":1});
		}
		if(moveWaite==null)return;
        if(map==null){
            trace("没有map，不计算碰撞和移动！");
            return;
        }
		var arrHit:Array=Tool_ArrayUtils.getNewArrayFromPool();
        var arr:* =map.getAllObjects();
        var tar:Map_Object;
        for(var i:int=0;i<arr.length;i++){
            tar=arr[i];
            if(tar==this)continue;
            if(hitTestWith(tar)==true){
                arrHit.push(tar);
			}
        }
		if(arrHit.length>0){
			for(i=0;i<arrHit.length;i++){
				tar =arrHit[i];
				var tmpMove:* =hitArea.moveTest(tar.hitArea,this.x,this.y,tar.x,tar.y,moveWaite);
				if(tmpMove !=null){
					if((moveWaite.x > 0 && tmpMove.x < moveWaite.x) || (moveWaite.x < 0 && tmpMove.x > moveWaite.x) || (moveWaite.x ==0 && tmpMove.x != 0) ){
							moveWaite.x =tmpMove.x;
					}
					if((moveWaite.y > 0 && tmpMove.y < moveWaite.y) || (moveWaite.y < 0 && tmpMove.y > moveWaite.y) || (moveWaite.y ==0 && tmpMove.y != 0) ){
						moveWaite.y =tmpMove.y;
					}
					Tool_ObjUtils.onClearObj(tmpMove);
					Tool_ObjUtils.returnObjectToPool(tmpMove);
				}
			}
		}
		if(moveWaite.x != null)this.x += moveWaite.x;
		if(moveWaite.y != null)this.y += moveWaite.y;
		Tool_ArrayUtils.returnArrayToPool(arrHit);
	}

	public function get z():Number{return _z;}
	public function set z(value:Number):void {
		_z = value;
		Role.y =-_z;
	}
	
	/** 碰撞检测 */
	protected function checkHit():Map_Object{
		if(map==null){
			trace("没有map");
			return null;
        }
        if(this.hitArea==null){return null;}
		var arr:* =map.getAllObjects();
		var tar:Map_Object;
		for(var i:int=0;i<arr.length;i++){
			tar=arr[i];
			if(tar==this)continue;
			if(hitTestWith(tar)==true)return tar;
		}
		return null;
	}
	protected function hitTestWith(obj:Map_Object):Boolean{
		if(this.hitArea==null || obj.hitArea==null){return false;}
		return hitArea.hitTest(obj.hitArea,this.x,this.y,this._z,obj.x,obj.y,obj._z);
	}

	/** 清理：人物等不缓存，直接清理。地面等地图素材缓存。 */
	public function removeF():void{
		destroyF();
	}
	public function destroyF():void{
		map=null;
		Tool_ObjUtils.destroyDisplayObj(this);
		Role=Tool_ObjUtils.destroyF_One(Role);
		hitArea=Tool_ObjUtils.destroyF_One(hitArea);
	}
}
}