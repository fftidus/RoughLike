package Games {
import Games.Map.Map_Object_Roles;

import com.MyClass.MainManagerOne;
import com.MyClass.MySourceManagerOne;
import com.MyClass.MyView.LayerStarlingManager;
import com.MyClass.MyView.LoadingSmall;
import com.MyClass.Tools.MyPools;
import com.MyClass.Tools.Tool_ObjUtils;

import Games.Map.MAP_Instance;
import Games.Map.Map_Object;
import Games.Map.Datas.MAP_Data;

import laya.utils.Handler;

import starling.display.Sprite;

/**
 * 游戏场景
 * */
public class Scene extends Sprite{
	public var ID:int;
	public var pool:MyPools=new MyPools();
	private var mso:MySourceManagerOne=new MySourceManagerOne();
	private var mmo:MainManagerOne=new MainManagerOne();
	public var Map:MAP_Instance;
	private var mainRole:Map_Object;
	
	public function Scene(data:MAP_Data,    loadView:int) {
		LayerStarlingManager.instance.LayerView.addChild(this);
		ID=data.ID;
		this.Map=new MAP_Instance(data);
		var source:Array=[
		];
		data.addSource(source);
		if(loadView<0){
			mso.addSource(source,Handler.create(this,initF),false);
		}else if(loadView==0){
			LoadingSmall.showF();
			mso.addSource(source,Handler.create(this,initF),false);
		}else{
			mso.addSource(source,Handler.create(this,initF),loadView);
		}
	}
	private function initF():void{
		if(mso==null){return;}
		LoadingSmall.removeF();
		this.addChild(this.Map);
		this.Map.initF();
		mainRole=new Map_Object_Roles();
		mainRole.initF(null,{"x":0,"y":0});
		this.Map.setMainRole(mainRole);
		mmo.addEnterFrameFun(Handler.create(this,enterF,null,false));
	}
	
	private function enterF():void{
		this.Map.enterF();
	}
	
	public function destroyF():void{
		if(Controller_Scene.getInstance().nowScene==this){
			Controller_Scene.getInstance().nowScene=null;
		}
		Tool_ObjUtils.destroyDisplayObj(this);
		Map=Tool_ObjUtils.destroyF_One(Map);
		mso=Tool_ObjUtils.destroyF_One(mso);
		mmo=Tool_ObjUtils.destroyF_One(mmo);
        pool=Tool_ObjUtils.destroyF_One(pool);
	}
}
}
