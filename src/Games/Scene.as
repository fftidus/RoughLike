package Games {
import Games.Map.Datas.MAP_Data;
import Games.Map.MAP_Instance;

import com.MyClass.MainManagerOne;

import com.MyClass.MySourceManagerOne;

import com.MyClass.MyView.LayerStarlingManager;
import com.MyClass.MyView.LoadingSmall;
import com.MyClass.Tools.Tool_ObjUtils;

import laya.utils.Handler;

import starling.display.Sprite;

/**
 * 游戏场景
 * */
public class Scene extends Sprite{
	public var ID:int;
	public var Map:MAP_Instance;
	private var mso:MySourceManagerOne=new MySourceManagerOne();
	private var mmo:MainManagerOne=new MainManagerOne();
	
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
		mmo.addEnterFrameFun(Handler.create(this,enterF,null,false));
	}
	
	private function enterF():void{
		this.Map.enterF();
	}
	
	public function destroyF():void{
		Tool_ObjUtils.destroyDisplayObj(this);
		Map=Tool_ObjUtils.destroyF_One(Map);
		mso=Tool_ObjUtils.destroyF_One(mso);
		mmo=Tool_ObjUtils.destroyF_One(mmo);
	}
}
}
