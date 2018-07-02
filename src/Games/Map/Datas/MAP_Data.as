package Games.Map.Datas{
/**
 * 地图的整体数据
 * */
public class MAP_Data{
	public var Name:String;
	public var size:int=40;
	public var rec:* ={"x0":0,"x1":500,"y0":0,"y1":500};//显示区域
	public var hitRec:*;//碰撞区域
	public var Arr_gripSource:Array=[];
	public var Arr_grips:Array;
	public var Arr_groundType:Array;
	
	public function MAP_Data(){
	}
	
	public function initF(dic:*):void{
		if(dic==null){return;}
		Name=dic["Name"];
		size=dic["size"];
		rec=dic["rec"];
		hitRec=dic["hit"];
		Arr_gripSource=dic["资源"];
		Arr_grips=dic["地图"];
		Arr_groundType=dic["地形"];
		
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
				Arr_grips[i]=[tmpdic[Arr_grips[i]["type"]],Arr_grips[i]["info"]];
			}
		}
	}
		
		
}
}