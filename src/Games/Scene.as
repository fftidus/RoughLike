package Games {
import Games.Datas.Data_Scene_init;
import Games.Fights.Fight_DicRoles;

import com.MyClass.MainManagerOne;
import com.MyClass.MySourceManagerOne;
import com.MyClass.MyView.LayerStarlingManager;
import com.MyClass.MyView.LoadingSmall;
import com.MyClass.Tools.MyPools;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import Games.Map.MAP_Instance;
import Games.Map.Datas.MAP_Data;

import laya.utils.Handler;

import starling.display.Sprite;

/**
 * 游戏场景
 * */
public class Scene extends Sprite{
	public var initData:Data_Scene_init;
	public var pool:MyPools=new MyPools();
	private var mso:MySourceManagerOne=new MySourceManagerOne();
	private var mmo:MainManagerOne=new MainManagerOne();
	public var Map:MAP_Instance;
    public var DicRoles:Fight_DicRoles;
	
	public function Scene(info:Data_Scene_init) {
        initData=info;
		var data:MAP_Data=info.data;
		LayerStarlingManager.instance.LayerView.addChild(this);
		this.Map=new MAP_Instance(data);
		var source:Array=[
		];
		data.addSource(source);
		if(initData.otherSource!=null){
			source=source.concat(initData.otherSource);
		}
		if(info.loadView<0){
			mso.addSource(source,Handler.create(this,initF),false);
		}else if(info.loadView==0){
			LoadingSmall.showF();
			mso.addSource(source,Handler.create(this,initF),false);
		}else{
			mso.addSource(source,Handler.create(this,initF),info.loadView);
		}
	}
	private function initF():void{
		if(mso==null){return;}
		LoadingSmall.removeF();
		this.addChild(this.Map);
		DicRoles=new Fight_DicRoles(this);
		this.Map.initF();
		mmo.addEnterFrameFun(Handler.create(this,enterF,null,false));
		Tool_Function.onRunFunction(initData.FunInit);
	}
	
	private function enterF():void{
        DicRoles.enterF();
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
        DicRoles=Tool_ObjUtils.destroyF_One(DicRoles);
	}
}
}
