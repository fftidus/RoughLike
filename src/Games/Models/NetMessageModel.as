package Games.Models {
import com.MyClass.Config;
import com.MyClass.MainManager;
import com.MyClass.MyView.LoadingSmall;
import com.MyClass.NetTools.MgsSocket;
import com.MyClass.Tools.AlertWindow;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import CMD.CMD002;
import CMD.CMD003;
import CMD.CMD006;
import CMD.CMD100;
import CMD.CMD101;
import CMD.CMD105;

import Games.PlayerMain;

import StaticDatas.SData_Armor;
import StaticDatas.SData_Bar;
import StaticDatas.SData_CreatGem;
import StaticDatas.SData_DungeonMonster;
import StaticDatas.SData_IP;
import StaticDatas.SData_Item;
import StaticDatas.SData_PlayerJob;
import StaticDatas.SData_Set;
import StaticDatas.SData_Strings;
import StaticDatas.SData_Weapon;

import laya.utils.Handler;

import lzm.util.LSOManager;

import starling.core.Starling;

public class NetMessageModel {
	private static var instance:NetMessageModel;
	public static function getInstance():NetMessageModel{
		if(instance==null){
			instance=new NetMessageModel();
		}
		return instance;
	}
	/**
	 * 网络模块，所有的网络通信尽量由它发送，便于随时调换单机和网络模式
	 * */
	public var isLocal:Boolean=false;
	private var FunDefault:*;
	//默认监听
	private var C101:CMD101;
	private var C6:CMD006;
	private var C3:CMD003;
	private var C2:CMD002;
	public function NetMessageModel() {
	}
	/** 初始化开始，如果是网络模式则监听修改玩家属性等指令 */
	public function initF(f:*):void{
		FunDefault=f;
		if(isLocal==true){
		}else{
			MainManager._instence.MEM.addListenF(MgsSocket.Event_Close,Handler.create(this,on断网F,null,false));
			C101=new CMD101();
			C101.funAddListener(Handler.create(this,valueChanged,null,false),false);
			C6=new CMD006();
			C6.funAddListener(Handler.create(this,net弹窗,null,false),false);
			C3=new  CMD003();
			C3.funAddListener(Handler.create(this,netChangeStatic,null,false),false);
			C2=new CMD002();
			C2.funAddListener(Handler.create(this,net心跳,null,false),false);
		}
	}
	/** 默认事件 */
	private var countReConnect:int=0;
	private function on断网F():void{
		trace("收到断网监听");
		var _账号信息:* =LSOManager.get(SData_Strings.LOCS_LoginInfo);
		if(PlayerMain.getInstance().ID>0 && _账号信息!=null && _账号信息["账号"]!=null && _账号信息["密码"]!=null){
			//已登录
			if(countReConnect==0){//自动重练一次
				countReConnect++;
				MainManager._instence.pause=true;
				MgsSocket.getInstance().needCloseEvent=false;
				LoadingSmall.showF(SData_Strings.Loading_netting);
				if(MgsSocket.getInstance().nowFlag == "连接"){
					onConnectF(true);
				}else{
					onStaticConnectF(onConnectF);
				}
			}else{//提示
				LoadingSmall.removeF();
				countReConnect=0;
				AlertWindow.showF(SData_Strings.Alert_badNet,null,Handler.create(this,on断网F));
			}
		}else{//还未登陆
			LoadingSmall.removeF();
			AlertWindow.showF(SData_Strings.Alert_badNet,null,on重启);
		}
		function onConnectF(suc:*):void{
			if(suc == true){
				onStaticLoginF(onNet重连F, _账号信息["账号"], _账号信息["密码"],true);
			}else{
				LoadingSmall.removeF();
				if(suc is String)		AlertWindow.showF(suc,null,on断网F);
				else					AlertWindow.showF(SData_Strings.Alert_badNet,null,on断网F);
			}
		}
		function onNet重连F(dic:*):void{
			if(dic["结果"]==true){
				MgsSocket.getInstance().needCloseEvent=true;
				MgsSocket.getInstance().onSendCache(on重连指令F);
			}else{
				LoadingSmall.removeF();
				AlertWindow.showF(dic["失败原因"],null,on断网F);
			}
		}
		function on重连指令F():void{
			trace("重连指令处理完毕");
			LoadingSmall.removeF();
			MainManager._instence.pause=false;
		}
		function on重启():void{
			Config.onRestart();
		}
	}
	public function valueChanged(dic:*):void{
		Tool_Function.onRunFunction(FunDefault,{"type":"改变属性","value":dic})
	}
	private function net心跳(val:*):void{
		trace("收到心跳");
		var c2:CMD002=new CMD002();
		c2.sendF(false);
	}
	private function net弹窗(dic:*):void{
		Tool_Function.onRunFunction(FunDefault,{"type":"弹窗","value":dic})
	}
	private function netChangeStatic(dic:*):void{
		for(var key:String in dic){
			Config.Log("修改静态数据："+key,dic[key]);
			switch(key){
				case "SData_PlayerJob":			SData_PlayerJob.getInstance().Dic=dic[key];			break;
				case "SData_Bar":					SData_Bar.getInstance().Dic=dic[key];					break;
				case "SData_Set":						SData_Set.getInstance().Dic=dic[key];					break;
				case "SData_Weapon":			SData_Weapon.getInstance().Dic=dic[key];			break;
				case "SData_Armor":				SData_Armor.getInstance().Dic=dic[key];				break;
				case "SData_DungeonMonster":SData_DungeonMonster.getInstance().Dic=dic[key];break;
				case "SData_Misc":					SData_Item.getInstance().Dic=dic[key];					break;
				case "SData_Gemstone":			SData_CreatGem.getInstance().Dic=dic[key];			break;
				default:
					var c:Class=Tool_Function.getDefinationByName("StaticDatas."+key,null);
					if(c==null){
						trace("未处理的3指令修改静态数据："+key);
					}else{
						try{
							c.getInstance().Dic=dic[key];
						}catch(e:Error){
							trace("3指令修改静态数据报错："+key);
						}
					}
					break;
			}
		}
	}
	/** 连接 */
	public function onStaticConnectF(f:*):void{
		var message:String;
		var c2:CMD002=new CMD002();
		c2.funAddListener(netConnectWrongReson,true);
		function netConnectWrongReson(dic:*):void{
			message=dic["失败原因"];
		}
		var SD:SData_IP=SData_IP.getInstance();
		MgsSocket.getInstance().Fun_connect	= onConnectEff;
		MgsSocket.getInstance().connectF(SD.Dic["ip"],SD.getNowPort());
		function onConnectEff(suc:*):void{
			c2=Tool_ObjUtils.getInstance().destroyF_One(c2);
			if(suc==true){
				Tool_Function.onRunFunction(f,true);
			}else{
				if(message!=null){
					Tool_Function.onRunFunction(f,message);
				}else{
					Tool_Function.onRunFunction(f,false);
				}
			}
		}
	}
	/**  登陆 */
	public function onStaticLoginF(f:*,账号:String,密码:String,重连:Boolean=false):void{
		if(isLocal==true){
			var plInfo:* =LSOManager.get("玩家信息");
			if(plInfo){
				valueChanged(plInfo);
			}
			Tool_Function.onRunFunction(f,{"结果":true});
			return;
		}
		if(MgsSocket.getInstance().nowFlag != "连接"){
			onStaticConnectF(function (suc:*):void{
				if(suc is String){
					Tool_Function.onRunFunction(f,{"结果":false,"失败原因":suc});
				}else if(suc==false){
					Tool_Function.onRunFunction(f,{"结果":false,"失败原因":"联网失败"});
				}else{
					onStaticLoginF(f,账号,密码,重连);
				}
			});
			return;
		}
		Starling.juggler.delayCall(onLoginTimerF,MgsSocket.getInstance().timeLimite);
		var c100:CMD100=new  CMD100();
		c100.funAddListener(netLoginF,true);
		c100.writeValue_Dic("账号",账号);
		c100.writeValue_Dic("密码",密码);
		c100.writeValue_Dic("平台",Config.MainDevice);
		if(Config.DeviceInfos){
			c100.writeValue_Dic("设备信息",Config.DeviceInfos);
		}
		c100.sendF(false);
		function netLoginF(dic:*):void{
			Starling.juggler.removeDelayedCalls(onLoginTimerF);
			Tool_Function.onRunFunction(f,dic);
		}
		function onLoginTimerF():void{
			c100=Tool_ObjUtils.getInstance().destroyF_One(c100);
			Tool_Function.onRunFunction(f,{"结果":false,"失败原因":SData_Strings.Alert_badNet});
		}
	}
	/** 手动修改属性并发送 */
	public function onChangeValueF(want:String,	val:*):void{
		if(isLocal==true){
			var dic:* ={};
			dic[want]=val;
			valueChanged(dic);
		}else {
			var c101:CMD101 = new CMD101();
			c101.writeValue_Dic(want, val);
			c101.sendF(true);
		}
	}
	/** 修改每日 */
	public function on改变Dic_每日(want:String,val:*):void{
		if(isLocal==true){
			var dic:* ={};
			dic["Dic_每日"]=PlayerMain.getInstance().Dic_EveryDay;
			valueChanged(dic);
		}else{
			var c101:CMD101	= new CMD101();
			c101.writeValue_Dic("Dic_每日",PlayerMain.getInstance().Dic_EveryDay);
			c101.sendF(true);
		}
	}
	/** 发送当前界面 */
	public function onSendNowView(name:String):void{
		if(isLocal==false) {
			var c105:CMD105 = new CMD105();
			c105.writeValue_Dic("界面", name);
			c105.sendF(false);
		}
	}

	public function destroyF():void
	{
		instance=null;
		C101=Tool_ObjUtils.getInstance().destroyF_One(C101);
		C6=Tool_ObjUtils.getInstance().destroyF_One(C6);
		C2=Tool_ObjUtils.getInstance().destroyF_One(C2);
		C3=Tool_ObjUtils.getInstance().destroyF_One(C3);
	}
}
}
