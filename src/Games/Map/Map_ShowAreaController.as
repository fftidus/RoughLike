package Games.Map {
import com.MyClass.Tools.Tool_ObjUtils;

import Games.Map.Datas.MapData_Grip;

/**
 * 地图区域显示图块控制
 * 数据排序为xy从小打大。取值范围是起点=x1在范围，终点x0在范围
 * */
public class Map_ShowAreaController {
	private var Map:MAP_Instance;
	private var lastArea:*;
	private var newArea:*;
	private var Dic_grips:* ={};//保存的所有图块
	
	public function Map_ShowAreaController(map:MAP_Instance) {
		this.Map=map;
	}
	/** 检测当前显示范围 */
	public function onCheckF():void{
		var i:int;
		var length:int =this.Map.data.Arr_grips.length;
		var can:Boolean;
		var data:MapData_Grip;
        if(lastArea!=null){
			for(var key:* in lastArea){
				if(key=="min" || key=="max")continue;
				delete lastArea[key];
			}
			newArea["min"]=null;
			newArea["max"]=null;
			for(i=lastArea["min"];i>=0;i--){
				data=this.Map.data.Arr_grips[i][0];
				can=canShowGrip_X(data,this.Map.data.Arr_grips[i][1]);
				if(can==false){
                    if(newArea["min"]!=null) break;
				}else{
					if(canShowGrip_Y(data,this.Map.data.Arr_grips[i][1])==true){
						if(newArea["min"]==null || newArea["min"] > i){
							newArea["min"]=i;
						}
					}
				}
			}
			if(newArea["min"]==null){
                for(i=lastArea["min"]+1;i<length;i++){
                    data=this.Map.data.Arr_grips[i][0];
                    can=canShowGrip_X(data,this.Map.data.Arr_grips[i][1]);
                    if(can==false){
						if(newArea["min"]!=null) break;
                    }else{
                        if(canShowGrip_Y(data,this.Map.data.Arr_grips[i][1])==true){
                            if(newArea["min"]==null || newArea["min"] > i){
                                newArea["min"]=i;
                            }
                        }
                    }
                }
			}
            for(i=lastArea["max"];i<length;i++){
                data=this.Map.data.Arr_grips[i][0];
                can=canShowGrip_X(data,this.Map.data.Arr_grips[i][1]);
                if(can==false){
                    if(newArea["max"]!=null) break;
                }else{
                    if(canShowGrip_Y(data,this.Map.data.Arr_grips[i][1])==true){
                        if(newArea["max"]==null || newArea["max"] < i){
                            newArea["max"]=i;
                        }
                    }
                }
            }
            if(newArea["max"]==null){
                for(i=lastArea["max"];i>=0;i--){
                    data=this.Map.data.Arr_grips[i][0];
                    can=canShowGrip_X(data,this.Map.data.Arr_grips[i][1]);
                    if(can==false){
                        if(newArea["max"]!=null) break;
                    }else{
                        if(canShowGrip_Y(data,this.Map.data.Arr_grips[i][1])==true){
                            if(newArea["max"]==null || newArea["max"]<i){
                                newArea["max"]=i;
                            }
                        }
                    }
                }
            }
            for(i=newArea["min"];i<=newArea["max"];i++){
                lastArea[i]=true;
            }
        }else{
			lastArea={};
			newArea={};
			trace("数据图块总长度："+length);
			for(i=0;i<length;i++){
				data=this.Map.data.Arr_grips[i][0];
				can=canShowGrip_X(data,this.Map.data.Arr_grips[i][1]);
				if(can==false){
					break;
				}else{
					if(canShowGrip_Y(data,this.Map.data.Arr_grips[i][1])==true){
						if(newArea["min"]==null || newArea["min"] > i){newArea["min"]=i;}
						if(newArea["max"]==null || newArea["max"] < i){newArea["max"]=i;}
						lastArea[i]=true;
					}
				}
			}
		}
		if(lastArea["min"] != newArea["min"] || lastArea["max"]!=newArea["max"]){
			onShowF(newArea["min"],newArea["max"]);
			this.Map.needSort=true;
//			trace(this.Map.nowMinX,this.Map.nowMaxX);
			trace("显示的图块数量："+Tool_ObjUtils.getLengthOfObject(this.Dic_grips));
		}
	}
	/** 单个图块能否显示 */
	private function canShowGrip_X(data:MapData_Grip,info:*):Boolean{
		if(data.rec.x0+info.x<=Map.nowMaxX && data.rec.x1+info.x>=Map.nowMinX){
			return true;
		}
		return false;
	}
	private function canShowGrip_Y(data:MapData_Grip,info:*):Boolean{
		if(data.rec.y1+info.y >= Map.nowMinY && data.rec.y0+info.y <= Map.nowMaxY){
			return true;
		}
		return false;
	}
	/** 显示 */
	private function onShowF(newMin:int=-1,newMax:int=-1):void{
		var i:int;
		var objOne:Map_Object;
		if(newMin!=-1) {//先删除部分老数据
			if(newMin>lastArea["min"]){
				for(i=lastArea["min"];i<newMin;i++){
					objOne=Dic_grips[i];
					if(objOne){
						delete Dic_grips[i];
						objOne.removeF();
					}
					delete lastArea[i];
				}
			}
			if(newMax<lastArea["max"]){
				for(i=lastArea["max"];i>newMax;i--){
					objOne=Dic_grips[i];
					if(objOne){
						delete Dic_grips[i];
						objOne.removeF();
					}
					delete lastArea[i];
				}
			}
		}
		//添加新的部分
		lastArea["min"] = newMin;
		lastArea["max"] = newMax;
		for(i=newMin;i<=newMax;i++){
			if(Dic_grips[i]!=null || lastArea[i]!=true){continue;}
			objOne=Map_Object.getOne(this.Map.data.Arr_grips[i][0],this.Map.data.Arr_grips[i][1]);
			Dic_grips[i]=objOne;
			this.Map.addMapObjectToLayer(objOne,objOne.index);
		}
	}
	
	public function destroyF():void{
		this.Map=null;
		Dic_grips=Tool_ObjUtils.destroyF_One(Dic_grips);
	}
}
}
