package Games
{
import com.MyClass.Config;
import com.MyClass.MainManager;
import com.MyClass.MySourceManagerOne;
import com.MyClass.SoundManagerMy;
import com.MyClass.MyView.LoadingSmall;
import com.MyClass.Tools.AlertWindow;
import com.MyClass.Tools.MyLocalStorage;
import com.MyClass.Tools.MyNetAlertWindow;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import CMD.CMD103;

import Games.Models.ItemModel;
import Games.Models.MaterialModel;
import Games.Models.NetMessageModel;
import Games.Models.RoleModel;
import Games.Models.Server_Config;
import Games.Models.WeaponModel;

import StaticDatas.SData_Default;
import StaticDatas.SData_EventNames;
import StaticDatas.SData_Faces;
import StaticDatas.SData_Strings;

import laya.utils.Handler;
import Games.Models.ArmorModel;

public class PlayerMain
{
	private static var Instance:PlayerMain;
	public static function getInstance():PlayerMain
	{
		if(Instance==null)Instance=new PlayerMain();
		return Instance;
	}
	private static var tmpMso:MySourceManagerOne;
	public static function getStaticMSO():MySourceManagerOne{
		if(tmpMso==null){
			tmpMso=new  MySourceManagerOne();
		}
		return tmpMso;
	}
	public static var DicRoleSource:*;
	public static function addFightRoleSource(rid:int,fun:*):void{
		if(DicRoleSource==null){
			DicRoleSource={};
		}
		if(DicRoleSource[rid]==null){
			DicRoleSource[rid]=true;
			var source:Array=[];
			var info:* =SData_Faces.getInstance().Dic[rid];
			if(info["spine"]!=null){
				source.push(["Role"+rid,"zmc","Role"+rid]);
			}else{
				source.push(["Role"+rid,"swf"]);
			}
			var j:int;
			if(info["swf资源"]!=null){
				for(j=0;j<info["swf资源"].length;j++){
					source.push([info["swf资源"][j],"swf"]);
				}
			}
			if(info["spine资源"]!=null){
				for(j=0;j<info["spine资源"].length;j++){
					source.push([info["spine资源"][j],"zmc",info["spine资源"][j]]);
				}
			}
			getStaticMSO().addSource(source,fun,false);
		}else{
			Tool_Function.onRunFunction(fun);
		}
	}
	
	public var ID:int=-1;
	public var 金币:int;
	public var 钻石:int;
	public var 头像:int;
	public var 性别:String;
	public var 体力:int;
	public var Dic_SD:* ={};//所有没有定义为变量的属性
	public var Dic_Roles:*;
	public var Dic_Formation:*;
	public var Dic_商城:*;
	public var Dic_每日:*;
	public var Dic_任务:*;
	public var Dic_Flag:*;
	public var Dic_背包:*;//背包的详情
	public var Info背包:*;//背包的其他属性
	public var Dic_仓库:*;
	public var Info仓库:*;
	public var Dic_酒馆:*;
	public var Dic_Fuben:*;
	
	public function PlayerMain()
	{
		var soundObj:* =MyLocalStorage.getF(SData_Strings.LOCS_声音信息);
		if(soundObj && soundObj[SData_Strings.LOCS_声音信息_音量]!=null){
			SoundManagerMy.soundVal=soundObj[SData_Strings.LOCS_声音信息_音量];
			SoundManagerMy.getInstance().setVol(SoundManagerMy.soundVal);
		}
		NetMessageModel.getInstance().initF(Handler.create(this,onNetMessageF,null,false));
	}
	
	private function onNetMessageF(dic:*):void{
		if(dic["type"] == "弹窗"){
			net弹窗(dic["value"]);
		}else if(dic["type"]=="改变属性"){
			valueChanged(dic["value"]);
		}
	}
	/** 改变玩家属性 */
	public function valueChanged(dic:*):void{
		for(var vname:String in dic){
			var val:*	= dic[vname];
			var key:String;
			switch (vname){
				case "修改背包":	onChangePackageF(val);break;
				case "修改仓库":	onChangeStorageF(val);break;
				case "修改佣兵":    onRoleChangeF(val);break;
				case "修改商品":	onChangeShopGoods(val);break;
				case "修改任务":    onChangeTaskF(val);break;
				default:
					onChangeValueDefault(vname,val);
					break;
			}
			delete dic[vname];
		}
	}
	public function onChangePackageF(dic:*):void{
		if(Dic_背包==null){Dic_背包={};}
		if(dic["页数"]!=null){
			Info背包["页数"]=dic["页数"];
			delete dic["页数"];
			MainManager.getInstence().MEM.dispatchF(SData_EventNames.Package_Update);
		}
		for(var i:int in dic){
			var val:* =dic[i];//val = {"类型","id","baseid","num"}
			var po:int=i;
			Config.Log("收到修改背包po="+i,val);
			if(val == "删除"){
				Dic_背包[po]=null;
			}else{
				Dic_背包[po]=getObjByInfo(val);
			}
			MainManager.getInstence().MEM.dispatchF(SData_EventNames.Package_Change,po);
		}
	}
	private function onChangeStorageF(dic:*):void{
		if(Dic_仓库==null){Dic_仓库={};}
		if(dic["页数"]!=null){
			Info仓库["页数"]=dic["页数"];
			delete dic["页数"];
			MainManager.getInstence().MEM.dispatchF(SData_EventNames.Storage_Update);
		}
		for(var i:int in dic){
			var val:* =dic[i];//val = {"类型","id","baseid","num"}
			var po:int=i;
			Config.Log("收到修改仓库po="+i,val);
			if(val == "删除"){
				Dic_仓库[po]=null;
			}else{
				Dic_仓库[po]=getObjByInfo(val);
			}
			MainManager.getInstence().MEM.dispatchF(SData_EventNames.Storage_Change,po);
		}
	}
	public function onRoleChangeF(val:*):void{//{"netid","baseid","lv","rank","属性","skill"}
		if(Dic_Roles==null){Dic_Roles={};}
		for(var nid:int in val){
			Config.Log("收到修改佣兵：",val[nid]);
			var dic:* = val[nid];
			if(dic=="删除"){
				if(Dic_Roles[nid]!=null){
					Tool_ObjUtils.getInstance().destroyF_One(Dic_Roles[nid]);
				}
			}else{
				if(Dic_Roles[nid]!=null){
					role =Dic_Roles[nid];
					role.initRoleInfo(dic);
				}else{
					var role:RoleModel=new RoleModel();
					role.initRoleInfo(dic);
					Dic_Roles[nid]=role;
				}
			}
			MainManager.getInstence().MEM.dispatchF(SData_EventNames.Role_Change,nid);
		}
	}
	private function onChangeShopGoods(val:*):void{// {1::{货币::1, 单价::500, 售罄::1, 类型::武器, baseid::1}}
		var dicGoods:* =Dic_商城["商店"]["商品"];
		for(var id:int in val){
			Config.Log("收到修改商品：",val[id]);
			dicGoods[id]=val[id];
		}
	}
	private function onChangeTaskF(val:*):void{
		Config.Log("收到修改任务：",val);
		if(Dic_任务==null){
			Dic_任务=val;
		}else{
			Tool_ObjUtils.getInstance().on合并Object(Dic_任务,val,false);
		}
		MainManager.getInstence().MEM.dispatchF("玩家"+"Dic_任务"+"改变",null);
	}
	/** 将服务器发过来的属性名改到本地属性名 */
	private function onChangeValueDefault(vname:String,val:*):void{
		var key:String;
		var dic:*;
		switch (vname){
			case "uid":		vname="ID";break;
			case Server_Config.Columns_User_昵称:	vname="昵称";break;
			case Server_Config.Columns_User_性别:	vname="性别";break;
			case Server_Config.Columns_User_金币:	vname="金币";break;
			case Server_Config.Columns_User_钻石:	vname="钻石";break;
			case Server_Config.Columns_User_体力:	vname="体力";break;
			case Server_Config.Columns_User_编队:	vname="Dic_Formation";break;
			case Server_Config.Columns_User_商城:	vname="Dic_商城";break;
			case Server_Config.Columns_User_酒馆: vname="Dic_酒馆";break;
			case Server_Config.Columns_User_每日:	vname="Dic_每日";break;
			case Server_Config.Columns_User_Flag:	vname="Dic_Flag";break;
			case Server_Config.Columns_User_任务:	vname="Dic_任务";break;
			case Server_Config.Columns_User_副本: vname="Dic_Fuben";break;
			case Server_Config.Columns_User_Roles:
				vname="Dic_Roles";
				dic={};
				for(key in val){//{"netid","baseid || 职业","lv","rank","属性","skill"}
					var role:RoleModel=new RoleModel();
					role.initRoleInfo(val[key]);
					dic[key]=role;
				}
				val=dic;
				break;
			case Server_Config.Columns_User_背包:
			case Server_Config.Columns_User_仓库:
				if(vname==Server_Config.Columns_User_背包){
					vname="Dic_背包";
					Info背包=val;
				}else{
					vname="Dic_仓库";
					Info仓库=val;
				}
				dic=val["详情"];
				for(key in dic){//{"level","容量","详情"}，详情=po:{"类型"，“属性”}，属性={"id","baseid","数量"}
					if(dic[key]==null){continue;}
					dic[key]=getObjByInfo(dic[key]);
				}
				delete val["详情"];
				val =dic;
				break;
			default:break;
		}
		Config.Log("收到玩家属性：",vname,"->"+vname+" =",val);
		try{
			this[vname]=val;
		}catch(e:Error){
			Dic_SD[vname]=val;
		}
		MainManager.getInstence().MEM.dispatchF("玩家"+vname+"改变",null);
	}
	public function getObjByInfo(dic:*):*{
		if(dic["类型"]==null){return null;}
		var type:String=dic["类型"];
		dic=dic["内容"];
		if(dic["netid"]!=null){dic["id"]=dic["netid"];}
		if(type == "道具"){
			var item:ItemModel=new ItemModel(dic["id"],dic["baseid"],dic["数量"]);
			item.needSafeNum();
			return item;
		}else if(type == "武器"){
			var wea:WeaponModel=new WeaponModel(dic["id"]);
			wea.setInfo(dic);
			return wea;
		}else if(type == "防具"){
			var arm:ArmorModel=new ArmorModel(dic["id"]);
			arm.setInfo(dic);
			return arm;
		}else if(type == "素材"){
			var mat:MaterialModel=new MaterialModel(dic["id"],dic["baseid"],dic["数量"]);
			mat.needSafeNum();
			return mat;
		}
	}
	
	public function getValue(want:String,	_参数:* = null):*{
		switch (want){
			default:
				try{
					return this[want];
				}
				catch(errObject:Error) {
					return Dic_SD[want];
				}
				break;
		}
	}
	
	public function getWeaponByNetID(needid:int):WeaponModel{
		if(Dic_背包){
			for(var nid:int in Dic_背包){
				if(Dic_背包[nid]!=null && Tool_Function.isTypeOf(Dic_背包[nid],WeaponModel)==true){
					if((Dic_背包[nid]as WeaponModel).NetID==needid){
						return Dic_背包[nid];
					}
				}
			}
		}
		return null;
	}
	public function getArmorByNetID(needid:int):ArmorModel{
		if(Dic_背包){
			for(var nid:int in Dic_背包){
				if(Dic_背包[nid]!=null && Tool_Function.isTypeOf(Dic_背包[nid],ArmorModel)==true){
					if((Dic_背包[nid]as ArmorModel).NetID==needid){
						return Dic_背包[nid];
					}
				}
			}
		}
		return null;
	}
	public function getItemByBaseID(needid:int):ItemModel{
		if(Dic_背包){
			for(var nid:int in Dic_背包){
				if(Dic_背包[nid]!=null && Tool_Function.isTypeOf(Dic_背包[nid],ItemModel)==true){
					if((Dic_背包[nid]as ItemModel).baseID==needid){
						return Dic_背包[nid];
					}
				}
			}
		}
		return null;
	}
	public function getItemByNetID(needid:int):ItemModel{
		if(Dic_背包){
			for(var nid:int in Dic_背包){
				if(Dic_背包[nid]!=null && Tool_Function.isTypeOf(Dic_背包[nid],ItemModel)==true){
					if((Dic_背包[nid]as ItemModel).NetID==needid){
						return Dic_背包[nid];
					}
				}
			}
		}
		return null;
	}
	public function getMatByNetID(needid:int):MaterialModel{
		if(Dic_背包){
			for(var nid:int in Dic_背包){
				if(Dic_背包[nid]!=null && Tool_Function.isTypeOf(Dic_背包[nid],MaterialModel)==true){
					if((Dic_背包[nid]as MaterialModel).NetID==needid){
						return Dic_背包[nid];
					}
				}
			}
		}
		return null;
	}
	
	public function getRoleModelByNetID(nid:int):RoleModel{
		var role:RoleModel =Dic_Roles[nid];
		return role;
	}
	
	public function getPlayerMainRole():RoleModel{
		for(var nid:int in Dic_Roles){
			var role:RoleModel =Dic_Roles[nid];
			if(role.isMainRole==true){
				return role;
			}
		}
		return null;
	}
	
	public function on手动修改F(want:String,	val:*,		f:*):void{
		MainManager._instence.MEM.addListenF("玩家"+want+"改变",f,null,true);
		NetMessageModel.getInstance().on手动修改F(want,val);
	}
	public function on改变Dic_每日(want:*,	val:*,	f:*):void{
		if(Dic_每日 && want!=null){
			if(val is Number && Dic_每日[want]>=val){
				Tool_Function.onRunFunction(f);
				return;
			}
			if(Tool_ObjUtils.getInstance().判断相等(Dic_每日[want],val)==true){
				Tool_Function.onRunFunction(f);
				return;
			}
		}
		if(Dic_每日==null){
			Dic_每日={};
		}
		if(want!=null){
			Dic_每日[want]=val;
		}
		if(f){
			MainManager._instence.MEM.addListenF("玩家Dic_每日改变",f,null,true);
		}
		NetMessageModel.getInstance().on改变Dic_每日(want,val);
	}
	public function on发送当前界面(name:String):void{
		var sd:SData_Default=SData_Default.getInstance();
		if(sd.Dic["上传界面"]==false)return;
		NetMessageModel.getInstance().on发送当前界面(name);
	}
	
	public function onErrorF(info:*):void{
		Config.Log("报错："+info);
		MainManager.getInstence().clearF();
		AlertWindow.showF(SData_Strings.Alert_意外错误,SData_Strings.Alert_意外错误Title,Config.on直接关闭);
	}
	
	private function net弹窗(dic:*):void{
		new MyNetAlertWindow(dic);
	}
	//==============================================
	/** 装备 */
	public function onWantEquipF(roleid:int,	equip:*, fun:*):void{
		var c103:CMD103=new  CMD103();
		c103.writeValue_Dic("操作","穿上");
		if(Tool_Function.isTypeOf(equip,WeaponModel))		c103.writeValue_Dic("类型","武器");
		else																		c103.writeValue_Dic("类型","防具");
		c103.writeValue_Dic("rid",roleid);
		c103.writeValue_Dic("eid",equip.NetID);
		c103.func_添加监听(fun,true);
		LoadingSmall.showF();
		c103.sendF();
	}
	/** 卸下 */
	public function onWantRemoveF(roleid:int,equip:*,	fun:*):void{
		var c103:CMD103=new  CMD103();
		c103.writeValue_Dic("操作","脱下");
		if(Tool_Function.isTypeOf(equip,WeaponModel))		c103.writeValue_Dic("类型","武器");
		else																		c103.writeValue_Dic("类型","防具");
		c103.writeValue_Dic("rid",roleid);
		c103.writeValue_Dic("eid",equip.NetID);
		c103.func_添加监听(fun,true);
		LoadingSmall.showF();
		c103.sendF();
	}
	/** 鉴定 */
	public function onWantCheckEquip(obj:*,	fun:*):void{
		var c103:CMD103=new  CMD103();
		c103.writeValue_Dic("操作","辨识");
		if(Tool_Function.isTypeOf(obj,WeaponModel)){
			c103.writeValue_Dic("类型","武器");
		}else{
			c103.writeValue_Dic("类型","防具");
		}
		c103.writeValue_Dic("eid",obj.NetID);
		c103.func_添加监听(fun,true);
		LoadingSmall.showF();
		c103.sendF();
	}
	
	
	
	
	
	
	//-------------------------------------------------------
	public function destroyF():void{
		Instance=null;
		tmpMso=Tool_ObjUtils.getInstance().destroyF_One(tmpMso);
		DicRoleSource=null;
		NetMessageModel.getInstance().destroyF();
	}
}
}