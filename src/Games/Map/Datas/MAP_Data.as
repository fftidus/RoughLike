package Games.Map.Datas{
import Games.Models.RoleModel;

import StaticDatas.SData_RolesInfo;

import com.MyClass.Tools.Tool_Function;

/**
 * 地图的整体数据
 * */
public class MAP_Data{
	public var ID:int;
	public var Name:String;
	public var size:int=40;
	public var rec:* ={"x0":0,"x1":500,"y0":0,"y1":500};//显示区域
	public var Arr_gripSource:Array=[];
	public var Arr_grips:Array;
	public var dicGripSegmentation:*;//地块分段
	public var Arr_groundType:Array;//二维数组，地形
	public var dicComps:*;//组件
	public var arrRoles:Array;
	
	public function MAP_Data(){
	}
	
	public function initF(dic:*):void{
		if(dic==null){return;}
		Name=dic["Name"];
		size=dic["size"];
		rec=dic["rec"];
		Arr_gripSource=dic["资源"];
		Arr_grips=dic["地图"];
        dicGripSegmentation=dic["分段"];
		Arr_groundType=dic["地形"];
		dicComps=dic["组件"];
		
		var tmpdic:* ={};
		if(Arr_gripSource){
			for(var i:int=0;i<Arr_gripSource.length;i++){
				var data:MapData_Grip=new MapData_Grip();
				data.initFromDic(Arr_gripSource[i]);
				Arr_gripSource[i]=data;
				tmpdic[data.Url]=data;
			}
		}
		if(Arr_grips && Arr_gripSource){//{"type","info":{"x","y"}}
			for(i=0;i<Arr_grips.length;i++){
				if(Arr_grips[i]["type"] is String == false){
					Arr_grips[i]["type"] =Arr_gripSource[Arr_grips[i]["type"]].Url;
				}
				if(Arr_grips[i]["info"]["x"]==null)Arr_grips[i]["info"]["x"]=0;
				if(Arr_grips[i]["info"]["y"]==null)Arr_grips[i]["info"]["y"]=0;
				if(Arr_grips[i]["info"]["层级"]==null)Arr_grips[i]["info"]["层级"]=1;
				Arr_grips[i]=[tmpdic[Arr_grips[i]["type"]],Arr_grips[i]["info"]];
			}
		}
	}
	
	public function addSource(source:Array):void{
		var arrswf:Array=[];
		if(Arr_gripSource!=null) {
			for (var i:int = 0; i < Arr_gripSource.length; i++) {
				var data:MapData_Grip =Arr_gripSource[i];
				if(arrswf.indexOf(data.swf)==-1){
					arrswf.push(data.swf);
					source.push([data.swf,"swf"]);
				}
			}
		}
		if(dicComps){
			if(dicComps["独立"]){//"独立":[{"info":{"y":700,"EID":"1","x":560},"type":"怪物点"}]
				for(i=0;i<dicComps["独立"].length;i++){
					if(dicComps["独立"][i]["type"]=="怪物点"){
						var eid:int =dicComps["独立"][i]["info"]["EID"];
						if(arrswf.indexOf("EID="+eid)==-1){
							arrswf.push("EID="+eid);
							if(arrRoles==null)arrRoles=[];
							var rm:RoleModel =new RoleModel();
                            rm.initRoleInfo(SData_RolesInfo.getInstance().Dic[eid]);
                            rm.addSource(source,null);
							rm.NetID=-(arrRoles.length+1);
							arrRoles.push([rm,dicComps["独立"][i]["info"]]);
						}
					}
				}
			}
		}
	}
	/** 根据坐标获得地形 */
	public function getGroundType(row:int,col:int):*{
		if(Arr_groundType==null)return null;
		if(Arr_groundType[row]){
			return Arr_groundType[row][col];
		}
		return null;
	}
		
		
}
}