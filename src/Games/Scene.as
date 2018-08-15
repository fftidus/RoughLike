package Games {
import Games.Datas.Data_Scene_init;
import Games.Fights.FightRole;
import Games.Fights.Fight_DicRoles;

import com.MyClass.Config;


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
    public static var G:Number=0;
	public static var G_away:Number=0;
	
	public var initData:Data_Scene_init;
	public var pool:MyPools=new MyPools();
	private var mso:MySourceManagerOne=new MySourceManagerOne();
	private var mmo:MainManagerOne=new MainManagerOne();
	private var sCon:Scene_Sounds;
	public var Map:MAP_Instance;
    public var DicRoles:Fight_DicRoles;
	
	public function Scene(info:Data_Scene_init) {
		if(G==0){
			G=50/Config.playSpeedTrue;
            G_away=50/Config.playSpeedTrue;
		}
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
        sCon=new Scene_Sounds(this);
		this.addChild(this.Map);
		DicRoles=new Fight_DicRoles(this);
		this.Map.initF();
		mmo.addEnterFrameFun(Handler.create(this,enterF,null,false));
		Tool_Function.onRunFunction(initData.FunInit);
	}
	
	private function enterF():void{
        DicRoles.enterF();
		this.sCon.enterF();
		this.Map.enterF();
	}
	/**
	 * 获得角色：camp==-1：全部||阵营。传入function获得role，return false则表示停止遍历
	 * @param camp 阵营，默认0表示全部，大于0表示指定阵营，小于0表示不等于该阵营
	 * **/
	public function getAllFightRolesByCamp(fun:*	,camp:int=0):void{
		var role:FightRole;
		for(var nid:* in DicRoles.dicRoles){
			role =DicRoles.dicRoles[nid];
			if(role==null || role.isDead>=100){
				continue;
			}
			if(camp==0 || (camp>0 && camp==role.camp) || (camp<0 && role.camp != -camp)){
                if(Tool_Function.onRunFunction(fun,role) == false){
                    break;
                }
			}
		}
        Tool_ObjUtils.destroyF_One(fun);
	}
	
	
	
	
	public function destroyF():void{
		if(Controller_Scene.getInstance().nowScene==this){
			Controller_Scene.getInstance().nowScene=null;
		}
		Tool_ObjUtils.destroyDisplayObj(this);
		Map=Tool_ObjUtils.destroyF_One(Map);
		mso=Tool_ObjUtils.destroyF_One(mso);
		mmo=Tool_ObjUtils.destroyF_One(mmo);
        sCon=Tool_ObjUtils.destroyF_One(sCon);
        pool=Tool_ObjUtils.destroyF_One(pool);
        DicRoles=Tool_ObjUtils.destroyF_One(DicRoles);
	}
}
}
