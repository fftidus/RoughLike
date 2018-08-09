package Games.Map{
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import Games.Map.Datas.MAP_Data;

import lzm.starling.swf.display.SwfSprite;

import starling.display.Sprite;
import starling.filters.FragmentFilter;

public class MAP_Instance extends Sprite{
	private static const Index_Object:int=4;
	public var data:MAP_Data;
	public var areaControll:Map_ShowAreaController;
	public var camera:Map_Camera;
	public var mainRole:*;
	private var dicLayers:* ={};
	public var needSort:Boolean=false;
	public function get nowMinX():int{return camera.nowX-camera.cameraW;}
	public function get nowMaxX():int{return camera.nowX+camera.cameraW;}
	public function get nowMinY():int{return camera.nowY-camera.cameraH;}
	public function get nowMaxY():int{
		return camera.nowY+camera.cameraH;
	}
	
	public function MAP_Instance(_data:*){
		data=_data;
		this.touchGroup=false;
		for(var i:int=1;i<=5;i++){
			dicLayers[i]=new SwfSprite();
			this.addChild(dicLayers[i]);
			if(i == 3){//阴影层，添加滤镜
				dicLayers[i].filter = new FragmentFilter();
				dicLayers[i].alpha=0.5;
			}
		}
	}
	public function initF():void{
		camera=new Map_Camera(this);
		areaControll=new Map_ShowAreaController(this);
		enterF();
	}
	/** 必须调用的初始化 */
	public function setMainRole(role:*):void{
		mainRole=role;
        addMapObjectToLayer(role);
	}
	/**
	 * 帧频事件
	 * */
	public function enterF():void{
		camera.enterF();
		areaControll.onCheckF();
		if(needSort){
			onSortGrips();
		}
	}
	/** 排序图块 */
	private function onSortGrips():void{
		needSort=false;
		for(var index:int in dicLayers) {
			if(index==Index_Object-1){continue;}
			var _layer:SwfSprite =dicLayers[index];
			var arrGrips:* = _layer._children;
			arrGrips.sort(function (obj1:Map_Object, obj2:Map_Object):Number {
				if (obj1.y > obj2.y) return 1;
				if (obj1.y < obj2.y) return -1;
				if (obj1.x > obj2.x) return 1;
				return -1;
			});
			_layer.setRequiresRedraw();
		}
		this.setRequiresRedraw();
	}
	/** 添加obj */
	public function addMapObjectToLayer(role:Map_Object,   index:int=-1):void{
		if(index==-1) {//默认添加到物体层
			index =Index_Object;
		}
		dicLayers[index].addChild(role);
        role.map=this;
		needSort=true;
	}
	/** 添加动画到最上层级 */
	public function addMcToTopLayer(mc:*):void{
		if(dicLayers && dicLayers[Index_Object+1]){
			dicLayers[Index_Object+1].addChild(mc);
		}
	}
	
	/** 根据世界坐标得到对应行 */
	public function getRowByY(_y:Number):int{
		_y -=this.y;
		var row:int = Tool_Function.onForceConvertType(_y / data.size);
		return row;
	}
	/** 根据世界坐标得到对应列 */
	public function getColumnByX(_x:Number):int{
		_x -=this.x;
		var col:int = Tool_Function.onForceConvertType(_x / data.size);
		return col;
	}
	/** 获得所有层级4上的物体 */
	public function getAllObjects():*{
		return dicLayers[Index_Object]._children;
	}
	
	public function destroyF():void{
		Tool_ObjUtils.getInstance().destroyDisplayObj(this);
		dicLayers=Tool_ObjUtils.destroyF_One(dicLayers);
		camera=Tool_ObjUtils.destroyF_One(camera);
		areaControll=Tool_ObjUtils.destroyF_One(areaControll);
	}
}
}