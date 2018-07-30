package Games {
import com.MyClass.MySourceManager;
import com.MyClass.Tools.Tool_Function;

import Games.Datas.Data_Scene_init;
import Games.Fights.FightRole;
import Games.Map.Datas.MAP_Data;

import com.MyClass.Tools.Tool_ObjUtils;

import laya.utils.Handler;

public class Controller_Scene {
	private static var instance:Controller_Scene;
	public static function getInstance():Controller_Scene{
		if(instance==null){instance=new Controller_Scene();}
		return instance;
	}
	public var nowScene:Scene;
	private var DicDatas:* ={};
	public function Controller_Scene() {
	}
	/**
	 * 考虑到加载，用回调函数来获取地图数据
	 * */
	public function getMapData(id:int,  fun:*):void{
		fubenID=id;
		if(DicDatas[id]!=null){
			Tool_Function.onRunFunction(fun,DicDatas[id]);
		}else{
			funWaite=fun;
			MySourceManager.getInstance().addTexture([["mapdata"+id,"json","assets/MapDatas/mapdata"+id+".json"]],Handler.create(this,loadF));
		}
	}
	private var initData:Data_Scene_init;
    private var fubenID:int;
    private var funWaite:*;
	private function loadF():void{
		var str:String =MySourceManager.getInstance().getJson("mapdata"+fubenID);
		if(str==null){
			PlayerMain.getInstance().onErrorF("地图"+fubenID+"数据加载失败！")
			return;
		}
		try{
			var dic:* = JSON.parse(str);
		}catch (e:*) {
			PlayerMain.getInstance().onErrorF("地图"+fubenID+"数据解析JSON失败！")
			return;
		}
		var data:MAP_Data=new MAP_Data();
		data.ID=fubenID;
		data.initF(dic);
		DicDatas[fubenID]=data;
		Tool_Function.onRunFunction(funWaite,DicDatas[fubenID]);
		funWaite=null;
	}
	/** needLoadView：小于0表示无加载界面，0表示小加载界面， 大于0表示对应大加载界面*/
	public function onNewScene(id:int,  needLoadView:int,door:int,source:Array,	fend:*):void{
		if(nowScene)nowScene=Tool_ObjUtils.destroyF_One(nowScene);
		fubenID=id;
        initData=new Data_Scene_init();
        initData.ID=id;
        initData.loadView=needLoadView;
		initData.startDoor=door;
		initData.otherSource=source;
		initData.FunInit=fend;
		getMapData(fubenID,Handler.create(this,onNewSceneEnd));
	}
	private function onNewSceneEnd(data:MAP_Data):void{
        initData.data=data;
        nowScene =new Scene(initData);
	}
	
	
}
}
