package Games{
import Games.Models.PackageModel.PackageModel;

import com.MyClass.Config;
import com.MyClass.MainManager;
import com.MyClass.SoundManagerMy;
import com.MyClass.Tools.AlertWindow;
import com.MyClass.Tools.MyLocalStorage;
import com.MyClass.Tools.MyNetAlertWindow;
import com.MyClass.Tools.Tool_ObjUtils;

import Games.Models.ArmorModel;
import Games.Models.ItemModel;
import Games.Models.MaterialModel;
import Games.Models.NetMessageModel;
import Games.Models.RoleModel;
import Games.Models.Server_Config;
import Games.Models.WeaponModel;

import StaticDatas.SData_Default;
import StaticDatas.SData_Strings;

import laya.utils.Handler;

public class PlayerMain{
	private static var Instance:PlayerMain;
	public static function getInstance():PlayerMain{
		if(Instance==null)Instance=new PlayerMain();
		return Instance;
	}
	
	public var ID:int=-1;
	public var nickName:String;
	public var gold:int;
	public var money:int;
	public var money2:int;//绑定钻石
	public var headIcon:*;
	public var sex:String;
	public var vigor:int;//体力
	public var Dic_SD:* ={};//所有没有定义为变量的属性
	public var Dic_Roles:*;
	public var Dic_Formation:*;
	public var Dic_Shop:*;
	public var Dic_EveryDay:*;
	public var Dic_Tasks:*;
	public var Dic_Flag:*;
	public var Dic_Fuben:*;
	
	public function PlayerMain(){
		var soundObj:* =MyLocalStorage.getF(SData_Strings.LOCS_SoundControl);
		if(soundObj && soundObj[SData_Strings.LOCS_SoundControl_volume]!=null){
			SoundManagerMy.soundVal=soundObj[SData_Strings.LOCS_SoundControl_volume];
			SoundManagerMy.getInstance().setVol(SoundManagerMy.soundVal);
		}
		PackageModel.getInstance();
		NetMessageModel.getInstance().initF(Handler.create(this,onNetMessageF,null,false));
	}
	
	private function onNetMessageF(dic:*):void{
		if(dic["type"] == "弹窗"){
			netWindow(dic["value"]);
		}else if(dic["type"]=="改变属性"){
			valueChanged(dic["value"]);
		}
	}
	/** 改变玩家属性 */
	public function valueChanged(dic:*):void{
		for(var vname:String in dic){
			var val:*	= dic[vname];
			switch (vname){
				case "修改背包":	onChangePackageF(val);break;
				case "修改佣兵":    onRoleChangeF(val);break;
				case "修改任务":    onChangeTaskF(val);break;
				default:
					onChangeValueDefault(vname,val);
					break;
			}
			delete dic[vname];
		}
	}
	public function onChangePackageF(dic:*):void{
	}
	public function onRoleChangeF(val:*):void{//{"netid","baseid","lv","rank","属性","skill"}
		if(Dic_Roles==null){Dic_Roles={};}
		for(var nid:int in val){
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
//			MainManager.getInstence().MEM.dispatchF(SData_EventNames.Role_Change,nid);
		}
	}
	private function onChangeTaskF(val:*):void{
		Config.Log("收到修改任务：",val);
		if(Dic_Tasks==null){
			Dic_Tasks=val;
		}else{
			Tool_ObjUtils.getInstance().onComboObject(Dic_Tasks,val,false);
		}
		MainManager.getInstence().MEM.dispatchF("玩家"+"Dic_Tasks"+"改变",null);
	}
	/** 将服务器发过来的属性名改到本地属性名 */
	private function onChangeValueDefault(vname:String,val:*):void{
		var key:String;
		var dic:*;
		switch (vname){
			case "uid":		vname="ID";break;
			case Server_Config.Columns_User_NickName:	vname="nickName";break;
			case Server_Config.Columns_User_Sex:	vname="sex";break;
			case Server_Config.Columns_User_Gold:	vname="gold";break;
			case Server_Config.Columns_User_Money:	vname="money";break;
			case Server_Config.Columns_User_vigor:	vname="vigor";break;
			case Server_Config.Columns_User_Team:	vname="Dic_Formation";break;
			case Server_Config.Columns_User_Shop:	vname="Dic_Shop";break;
			case Server_Config.Columns_User_EveryDay:	vname="Dic_EveryDay";break;
			case Server_Config.Columns_User_Flag:	vname="Dic_Flag";break;
			case Server_Config.Columns_User_Tasks:	vname="Dic_Tasks";break;
			case Server_Config.Columns_User_Fuben: vname="Dic_Fuben";break;
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
			case Server_Config.Columns_User_Package:
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
		return null;
	}
	public function getArmorByNetID(needid:int):ArmorModel{
		return null;
	}
	public function getItemByBaseID(needid:int):ItemModel{
		return null;
	}
	public function getItemByNetID(needid:int):ItemModel{
		return null;
	}
	public function getMatByNetID(needid:int):MaterialModel{
		return null;
	}
	
	public function getRoleModelByNetID(nid:int):RoleModel{
		var role:RoleModel =Dic_Roles[nid];
		return role;
	}
	/** 手动改变玩家某个属性并发送网络 */
	public function onChangeValueF(want:String,	val:*,		f:*):void{
		MainManager._instence.MEM.addListenF("玩家"+want+"改变",f,null,true);
		NetMessageModel.getInstance().onChangeValueF(want,val);
	}
	/** 改变每日数据 */
	public function onChangeEveryDay(want:*,	val:*,	f:*):void{
		if(f){
			MainManager._instence.MEM.addListenF("玩家Dic_EveryDay改变",f,null,true);
		}
		NetMessageModel.getInstance().on改变Dic_每日(want,val);
	}
	public function onSendNowView(name:String):void{
		var sd:SData_Default=SData_Default.getInstance();
		if(sd.Dic["上传界面"]==false)return;
		NetMessageModel.getInstance().onSendNowView(name);
	}
	
	public function onErrorF(info:*):void{
		Config.Log("报错："+info);
		MainManager.getInstence().clearF();
		AlertWindow.showF(SData_Strings.Alert_Error,SData_Strings.Alert_ErrorTitle,Config.onCloseProgram);
	}
	
	private function netWindow(dic:*):void{
		new MyNetAlertWindow(dic);
	}
	
	
	
	
	
	
	//-------------------------------------------------------
	public function destroyF():void{
		Instance=null;
		NetMessageModel.getInstance().destroyF();
	}
}
}