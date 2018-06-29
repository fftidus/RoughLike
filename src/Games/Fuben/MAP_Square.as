package Games.Fuben{
import Games.Fuben.Datas.MAP_Data;

import com.MyClass.Config;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import Plugins.Plugins__map_topview_square;
import Plugins.Plugins__sortController;

import laya.maths.Rectangle;
import laya.utils.Handler;
	
import starling.display.Sprite;

public class MAP_Square extends Sprite{
	public var data:MAP_Data;
	public function get SquareSize():int{return 0;}
	private var LayerG:Sprite=new  Sprite();
	private var LayerUp:Sprite =new  Sprite();
	private var LayerTop:Sprite=new  Sprite();
	private var Dic_Event:*;
	public var plugins_main:Plugins__map_topview_square;
	private var plugins_sort:Plugins__sortController;
	
	public var mainRole:*;
	
	public function MAP_Square(_data:*, rec:Rectangle=null){
		data=_data;
		this.addChild(LayerG);
		this.addChild(LayerUp);
		this.addChild(LayerTop);
		this.touchGroup=false;
		if(rec==null){
			rec=new Rectangle(0,0,Config.stageW,Config.stageH);
		}
		plugins_main=new  Plugins__map_topview_square(this,LayerG,LayerUp,rec,data,null);
		plugins_main.FunChanged=Handler.create(this,onMapChanged,null,false);
		plugins_sort=new Plugins__sortController(LayerUp,"row",0.5);
		plugins_sort.arrSortKeys=["renderIndex"];
	}
	/** 必须调用的初始化 */
	public function setMainRole(role:*):void{
		mainRole=role;
		plugins_main.mainRole=mainRole;
		enterF();
	}
	/** 限制角色移动范围 */
	public function onLimiteRole(role:*):void{
		plugins_main.onLimiteRole(role);
	}
	/** 根据世界坐标得到对应行 */
	public function getRowByY(_y:Number):int{
		_y -=this.y;
		_y -= LayerG.y;
		var row:int = Tool_Function.on强制转换(_y / data["h0"]);
		if(row>plugins_main.allRow)return -1;
		return row;
	}
	/** 根据世界坐标得到对应列 */
	public function getColumnByX(_x:Number):int{
		_x -=this.x;
		_x -= LayerG.x;
		var col:int = Tool_Function.on强制转换(_x / data["w0"]);
		if(col>plugins_main.allColumn)return -1;
		return col;
	}
	/** 手动修改某个位置的地面，编辑器使用 */
	public function onChangeOne(r:int,c:int,type:String):void{
		plugins_main.onChangeOneGround(r,c,type);
	}
	/** 手动修改某个位置的物品，编辑器使用 */
	public function onChangeOneItem(r:int,c:int,type:String):void{
		plugins_main.onChangeOneItem(r,c,type);
	}
	/** 获得某个位置的物品 */
	public function getItemByRC(r:int,c:int):MAP_Item{
		var item:MAP_Item= plugins_main.getItemObjectByRC(r,c);
		return item;
	}
	/** 获得某个位置地面 */
	public function getGroundOneByRC(r:int,c:int):MAP_Ground{
		var g:MAP_Ground= plugins_main.getGroundObjectByRC(r,c);
		return g;
	}
	/** 获得某个位置的事件 */
	public function getEventByRC(r:int,c:int):MAP_Event{
		if(Dic_Event[r] && Dic_Event[r][c]){
			return Dic_Event[r][c];
		}
		return null;
	}
	
	/**
	 * 事件相关
	 * */
	private function onCheckEvent():void{
		if(Dic_Event==null){
			initEvent();
		}
		for(var row:int in Dic_Event){
			var dic:* =Dic_Event[row];
			for(var col:int in dic){
				if(dic[col]==null){continue;}
				var one:MAP_Event =dic[col];
				if(row<plugins_main.last行 || row > plugins_main.last行+plugins_main.numShow行 || col < plugins_main.last列 || col> plugins_main.last列+plugins_main.numShow列){
					one.onVisible(false);
				}else{
					one.onVisible(true);
				}
			}
		}
	}
	private function initEvent():void{
		if(Dic_Event==null)Dic_Event={};
		var dic:* =data["事件"];
		if(dic==null)return;
		for(var key:String in dic){
			var tmp:Array =key.split(":");
			var row:int =int(tmp[0]);
			var col:int =int(tmp[1]);
			if(Dic_Event[row]==null)Dic_Event[row]={};
			if(Dic_Event[row][col]!=null){continue;}
			var one:MAP_Event= MAP_Event.getOneByInfo(dic[key]);
			one.row =row;
			one.col =col;
			one.x =SquareSize * col;
			one.y =SquareSize * row;
			one.map=this;
			LayerUp.addChild(one);
			Dic_Event[row][col] =one;
		}
	}
	
	public function enterF():void{
		plugins_main.enterF();
		LayerTop.x =LayerUp.x;
		LayerTop.y =LayerUp.y;
		if(plugins_sort){
			plugins_sort.enterF();
		}
		onCheckEvent();
	}
	private function onMapChanged():void{
//		MainManager.getInstence().MEM.dispatchF(SData_EventNames.Fuben_mapRefresh);
	}
	/** 添加role */
	public function addRoleF(role:*):void{
		LayerUp.addChild(role);
	}
	/** 添加动画到人物和物品层级 */
	public function addMcToLayerUp(mc:MAP_TmpMovieclip):void{
		LayerUp.addChild(mc);
		if(plugins_sort){
			plugins_sort.on刷新冷却F();
		}
	}
	/** 添加动画到最上层级 */
	public function addMcToTop(mc:*):void{
		LayerTop.addChild(mc);
	}
	
	public function destroyF():void{
		Tool_ObjUtils.getInstance().destroyDisplayObj(this);
		LayerG=Tool_ObjUtils.getInstance().destroyF_One(LayerG);
		LayerUp=Tool_ObjUtils.getInstance().destroyF_One(LayerUp);
		LayerTop=Tool_ObjUtils.getInstance().destroyF_One(LayerTop);
		Dic_Event=Tool_ObjUtils.getInstance().destroyF_One(Dic_Event);
		plugins_main=Tool_ObjUtils.getInstance().destroyF_One(plugins_main);
		plugins_sort=Tool_ObjUtils.getInstance().destroyF_One(plugins_sort);
	}
}
}