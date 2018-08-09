package Games.Map{
import com.MyClass.Tools.MyHitArea;
import com.MyClass.Tools.MyPools;
import com.MyClass.Tools.Tool_ArrayUtils;
import com.MyClass.Tools.Tool_Function;
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
	public var nowGroundType:*;
	private var _z:Number=0;
	public var index:int=1;
	public var mhitArea:MyHitArea;
	public var canFall:Boolean=true;
	
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
        checkMoveOnGroundType(null);
	}

	public function initHitArea(dic:*):Boolean{
		var _hitArea:MyHitArea = MyHitArea.getHitArea(dic);
		if(_hitArea != null){
			this.mhitArea = _hitArea;
			return true;
		}
		return false;
	}
	
	/**
	 * 移动XY，判断碰撞
	 * */
	public function moveF(moveWaite:*):void{
		if(mhitArea==null){
			mhitArea=new  MyHitArea();
			mhitArea.initFromDic({"type":2,"p":{"x":0,"y":0},"r":1});
		}
		if(moveWaite==null)return;
        if(map==null){
            trace("没有map，不计算碰撞和移动！");
            return;
        }
		//地形
        moveWaite= checkMoveOnGroundType(moveWaite);
        if(moveWaite==null)return;
		//与其他物体的碰撞
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
				var tmpMove:* =mhitArea.moveTest(tar.mhitArea,this.x,this.y,tar.x,tar.y,moveWaite);
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
	/** 获得当前脚底的地形,{"1":"通用","2":"水面","3":"泥地","8":"落下","9":"无法通行"} */
	public function getNowGroundType():*{
        var row:int =Tool_Function.onForceConvertType(this.y/map.data.size);
        var col:int =Tool_Function.onForceConvertType(this.x/map.data.size);
        var nowType:* =map.data.getGroundType(row,col);
		return nowType;
	}
	/** 移动检测 */
	protected function checkMoveOnGroundType(moveWaite:*):*{
		if(map==null)return null;
        var row:int =Tool_Function.onForceConvertType(this.y/map.data.size);
        var col:int =Tool_Function.onForceConvertType(this.x/map.data.size);
        nowGroundType =map.data.getGroundType(row,col);
        if(moveWaite==null)return null;
        if(nowGroundType==8 && canFall==true){
			return null;
        }
        var canx:Boolean=true;
		var cany:Boolean=true;
		var row2:int =Tool_Function.onForceConvertType((this.y+moveWaite.y)/map.data.size);
		if(row2!=row){
            var nowType2:* =map.data.getGroundType(row2,col);
			if(isCannotMoveType(nowType2)==true)cany=false;
		}
        var col2:int =Tool_Function.onForceConvertType((this.x+moveWaite.x)/map.data.size);
        if(col2 != col){
            var nowType3:* =map.data.getGroundType(row,col2);
            if(isCannotMoveType(nowType3)==true)canx=false;
        }
		if(canx==false && cany==false)return null;
		if(canx==false) moveWaite.x =0;
		if(cany==false) moveWaite.y =0;
		return moveWaite;
	}
	/** type是否属于无法移动的格子，9为无法移动，部分敌人的8无法移动（不允许掉落） */
	protected function isCannotMoveType(type:int):Boolean{
		if(type==9)return true;
		if(canFall==false && type==8)return true;
		return false;
	}

	public function get z():Number{return _z;}
	public function set z(value:Number):void {
		_z = value;
		Role.y =-_z;
	}
	
	/** 碰撞检测 */
	protected function hitTestWith(obj:Map_Object):Boolean{
		if(this.mhitArea==null || obj.mhitArea==null){return false;}
		return mhitArea.hitTestWith(obj.mhitArea,this.x,this.y,this._z,obj.x,obj.y,obj._z);
	}

	/** 清理：人物等不缓存，直接清理。地面等地图素材缓存。 */
	public function removeF():void{
		destroyF();
	}
	public function destroyF():void{
		map=null;
		Tool_ObjUtils.destroyDisplayObj(this);
		Role=Tool_ObjUtils.destroyF_One(Role);
		mhitArea=Tool_ObjUtils.destroyF_One(mhitArea);
	}
}
}