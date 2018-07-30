package Games.Map {
import Games.Map.Datas.MapData_Grip;

import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

/**
 * 地图区域显示图块控制
 * 数据排序为xy从小打大。取值范围是起点=x1在范围，终点x0在范围
 * */
public class Map_ShowAreaController {
	private var Map:MAP_Instance;
	private var lastArea:* ={};
	private var newArea:* ={};
	public var Dic_grips:* ={};//保存的所有图块
	private var lastMinx:int=-1;
	private var lastMaxx:int=-1;
	private var lastMiny:int=-1;
	private var lastMaxy:int=-1;
	
	public function Map_ShowAreaController(map:MAP_Instance) {
		this.Map=map;
	}
	/** 检测当前显示范围 */
	public function onCheckF():void{
		var i:int;
		Tool_ObjUtils.onClearObj(newArea);
		//处理分段
		if(lastMinx == Map.nowMinX && lastMaxx==Map.nowMaxX && lastMiny==Map.nowMinY && lastMaxy==Map.nowMaxY){return;}
		lastMinx=Map.nowMinX;
		lastMaxx=Map.nowMaxX;
		lastMiny=Map.nowMinY;
		lastMaxy=Map.nowMaxY;
		var L:int =this.Map.data.dicGripSegmentation["距离"];
		var min:int= Tool_Function.onForceConvertType(Map.nowMinX / L);
		var max:int= Tool_Function.onForceConvertType(Map.nowMaxX / L)+1;
		var miny:int= Tool_Function.onForceConvertType(Map.nowMinY / L);
		var maxy:int= Tool_Function.onForceConvertType(Map.nowMaxY / L)+1;
		for(i=min;i<=max;i++){
			if(Map.data.dicGripSegmentation["x"][i]){
				Tool_ObjUtils.onComboObject(newArea,Map.data.dicGripSegmentation["x"][i],false);
			}
		}
		for(var key:* in newArea){
			var haveY:Boolean=false;
			for(i=miny;i<=maxy;i++){
				if(Map.data.dicGripSegmentation["y"][i]){
					if(Map.data.dicGripSegmentation["y"][i][key]==true){
						haveY=true;
						break;
					}
				}
			}
			if(haveY==false){
				delete newArea[key];
			}else{
				if(	canShowGrip(this.Map.data.Arr_grips[key][0],this.Map.data.Arr_grips[key][1]) ==false){
					delete newArea[key];
				}
			}
		}
		
		onShowF();
	}
	/** 单个图块能否显示 */
	private function canShowGrip(data:MapData_Grip,info:*):Boolean{
		if(data.rec.x0+info.x<=Map.nowMaxX && data.rec.x1+info.x>=Map.nowMinX){
			if(data.rec.y1+info.y >= Map.nowMinY && data.rec.y0+info.y <= Map.nowMaxY){
				return true;
			}
		}
		return false;
	}
	/** 显示 */
	private function onShowF():void{
		var objOne:Map_Object;
		var haveChange:Boolean=false;
		//先删除不需要的
		for(var po:int in lastArea){
			if(newArea[po]==null) {
				objOne = Dic_grips[po];
				if (objOne) {
					delete Dic_grips[po];
					objOne.removeF();
				}
				delete lastArea[po];
				haveChange=true;
			}
		}
		//添加新的
		for(var po:int in newArea){
			if(lastArea[po] == null) {
				objOne = Map_Object.getOne(this.Map.data.Arr_grips[po][0], this.Map.data.Arr_grips[po][1]);
				Dic_grips[po] = objOne;
				this.Map.addMapObjectToLayer(objOne, objOne.index);
				lastArea[po]=true;
				haveChange=true;
			}
		}
        this.Map.needSort = true;
        if(haveChange) {
			trace("显示的图块数量：" + Tool_ObjUtils.getLengthOfObject(this.Dic_grips));
		}
	}
	
	public function destroyF():void{
		this.Map=null;
		Dic_grips=Tool_ObjUtils.destroyF_One(Dic_grips);
	}
}
}
