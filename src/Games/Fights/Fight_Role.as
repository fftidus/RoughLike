package Games.Fights {
import com.MyClass.MainManager;
import com.MyClass.MySourceManager;
import com.MyClass.MyView.MyMC;
import com.MyClass.MyView.MyZMovieClip;
import com.MyClass.Tools.MyCheaterNumMultiple;
import com.MyClass.Tools.Tool_ArrayUtils;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import Games.PlayerMain;
import Games.Models.RoleModel;

import StaticDatas.SData_Buff;
import StaticDatas.SData_Faces;
import StaticDatas.SData_Skills;
import StaticDatas.SData_Strings;

import starling.display.Sprite;

public class Fight_Role {
	
	public var ID:*;
	public var rm:RoleModel;
	public var RoleID:int;
//	public var Face:int;
	public var Name:String;
	public var isMainRole:Boolean=false;
	public var Sex:String;
	public var 种族:String;
	public var mainView:ViewClass_FightMain;
	public var busy:int;
	public var isDestroyed:Boolean=false;
	public var AI:Fight_AI;
	public var drop:Array;
	//显示
	public var Role:Sprite;
	public var roleMC:MyMC;
	public var dicMCs:* ={};
	public var Role影子:Sprite;
	public var Arr_mcFollow:Array=[];
	public var McHp:Fight_RoleHPMc;
	protected var haveChangeState:Boolean=false;
	protected var sprDrops:Sprite;
	protected var Arr_DropMc:Array;
	//属性
	public var camp:int;
	public var Role_x:Number=0;
	public var Role_y:Number=0;
	public var Role_z:Number=0;
	public var RoleWidth:int=20;
	public var RoleHeight:int=100;
	public var Position:int;
	public var isDead:Boolean=false;
	public var Dic属性:* =Tool_ObjUtils.getNewObjectFromPool();
	public var safe属性:MyCheaterNumMultiple;
	public var Arr_Buff:Array;
	public var dic_linkBuff:*;
	public var Arr_Skill:Array=[];
	public var action:Fight_ActionDefault;
	public var lastAction:Fight_ActionDefault;//上一次行动的action
	public var nextAction:String;
	public var nowAction:String;
	public var nowMcLink:String;
	public var Dic_Actions:* ={};
	//getter，setter
	public function get x():Number {return Role_x;}
	public function set x(value:*):void {
		Role_x=value;
	}
	public function get y():Number {return Role_y;}
	public function set y(value:*):void {
		Role_y=value;
	}
	public function get z():Number {	return Role_z;}
	public function set z(value:*):void {
		Role_z=value;
	}
	/**
	 * 初始化角色
	 * */
	public function Fight_Role(info:*,v:*) {
		if(info==null){return;}
		mainView=v;
		if(info["rm"]!=null){
			rm=info["rm"];
		}
		Name=info["Name"];
		if(info["ID"]!=null){ID=info["ID"];}
		if(info["RoleID"]!=null){RoleID=info["RoleID"];}
//		Face=info["形象"];
		if(info["阵营"]!=null){camp=info["阵营"];}
		if(info["位置"]!=null){Position=info["位置"];}
		if(info["主角"]==true)isMainRole=true;
		if(info["属性"]!=null){
			Tool_Function.on修改属性ByDic(Dic属性,info["属性"]);
		}
		if(Dic属性["hpMax"]==null){Dic属性["hpMax"]=Dic属性["hp"];}
		else if(Dic属性["hp"]==null){Dic属性["hp"]=Dic属性["hpMax"];}
		Dic属性["mpMax"]=100;
		Dic属性["怒气Max"]=100;
		Dic属性["能量Max"]=100;
		Dic属性["激素Max"]=100;
		Dic属性["印记Max"]=1;//印记的上限每回合加1，最高到?
		safe属性=new  MyCheaterNumMultiple(2);
		//-----------------------------------------------------------------
		var baseinfo:* =SData_Faces.getInstance().Dic[RoleID];
		Dic属性["spine"]=baseinfo["spine"];
		if(baseinfo["属性"]!=null && info["属性"]==null){//当没有传入属性时以静态数据为准
			Tool_Function.on修改属性ByDic(Dic属性,baseinfo["属性"]);
		}
		Dic_Actions[SData_Strings.ActionName_站立]=Tool_Function.onNewClass(Fight_Action_Stand,this,baseinfo["Action"][SData_Strings.ActionName_站立]);
		Dic_Actions[SData_Strings.ActionName_挨打]=Tool_Function.onNewClass(Fight_Action_Hurt,this,baseinfo["Action"][SData_Strings.ActionName_挨打]);
		var i:int;
		var skill:Fight_Action_SkillDefault;
		if(info["技能"] != null){
			for(i=0;i<info["技能"].length;i++){
				skill =addSkillF(info["技能"][i]);
				if(skill.Type == SData_Skills.TypeSkill_Passive){
					skill.onAddBuffToTar(this,100,skill.selfBuff,null);
					continue;
				}
				Dic_Actions[SData_Strings.ActionName_技能+skill.ID]=skill;
				Arr_Skill.push(skill);
			}
		}else if(baseinfo["skill"]){//base数据中有skill的，表示测试用数据
			for(i=0;i<baseinfo["skill"].length;i++){
				skill =addSkillF(baseinfo["skill"][i]);
				if(skill.Type == SData_Skills.TypeSkill_Passive){
					skill.onAddBuffToTar(this,100,skill.selfBuff,null);
					continue;
				}
				Dic_Actions[SData_Strings.ActionName_技能+skill.ID]=skill;
				Arr_Skill.push(skill);
			}
		}
		if(info["baseBuff"]!=null && info["baseBuff"] > 0){
			SData_Buff.getBuffByID(info["baseBuff"],this);
		}
		if(info["武器buff"]!=null){//{buffid:{参数}}
			for(var buffid:int in info["武器buff"]){
				var buff:Fight_Buff=SData_Buff.getBuffByID(buffid,this);
				if(buff)buff.initByDic(info["武器buff"][buffid]);
			}
		}
		for(i=0;i<10;i++){
			if(info["防具buff"+i]!=null){//{buffid:{参数}}
				for(buffid in info["防具buff"+i]){
					buff=SData_Buff.getBuffByID(buffid,this);
					if(buff)buff.initByDic(info["防具buff"+i][buffid]);
				}
			}
		}
		//------------------------------------------------------------------
		if(info["Role_x"]!=null){Role_x=info.Role_x;}
		if(info["Role_y"]!=null){Role_y=info.Role_y;}
		if(info["Role_z"]!=null){Role_z=info.Role_z;}
		McHp=Tool_Function.onNewClass(Fight_RoleHPMc,this);
		if(McHp){
			mainView.addLightMc(McHp);
		}
	}
	
	public function addSkillF(s:*):*{
		if(s==null){return null;}
		if(Tool_Function.isTypeOf(s,Fight_Action_SkillDefault) == true){return s;}
		var c:Class;
		var sid:int;
		if(Tool_Function.isTypeOf(s,Number)){//直接用ID，表示放在SData_RolesInfo中的技能
			sid=s;
			s =SData_Skills.creatSkillF(this,sid,1);
			return s;
		}
		sid=s["id"];
		s =SData_Skills.creatSkillF(this,sid,s["lv"]);
		return s;
	}
	public function getSkillBySID(sid:int):*{
		var i:int;
		for(i=0;i<Arr_Skill.length;i++){
			if(Arr_Skill[i] && Arr_Skill[i].ID == sid){
				return Arr_Skill[i];
			}
		}
		return null;
	}
	
	public function changeRoleFlag(flag:String):void{
		nextAction=null;
		if(action){action.breakF();lastAction=action;action=null;}
		nowAction=flag;
		if(Dic_Actions[nowAction]==null){
			trace(ID+"角色无法进入flag="+flag);
			return;
		}
		action=Dic_Actions[nowAction];
		action.resetF();
	}
	public function onChangeroleMC(swf:String,url:String):void{
		if(roleMC){
			roleMC.gotoAndStop(0);
			roleMC.removeFromParent();
			roleMC=null;
		}
		nowMcLink=url;
		if(dicMCs[url]==null) {
			var mc:* = MySourceManager.getInstance().getMcFromSwf(SData_Strings.SWF_战斗界面,url);
			if(mc==null){
				dicMCs[url]=false;
			}else{
				roleMC=new MyMC(mc);
				dicMCs[url]=roleMC;
			}
		}else if(dicMCs[url]==false){
		}else{
			roleMC=dicMCs[url];
		}
		if(roleMC){
			Role.addChildAt(roleMC,0);
		}else{
			trace("没有找到RID="+RoleID+"："+url);
		}
	}
	public function onChangeroleMC_Spine(url:String):void{
		if(haveChangeState==true){
			roleMC=Tool_ObjUtils.getInstance().destroyF_One(roleMC);
			haveChangeState=false;
		}
		nowMcLink=url;
		if(roleMC==null){
			var swf:String="Role"+RoleID;
			var spine:String =get属性("spine",false);
			if(Dic属性["变身"]>0){
				swf+="_2";
				spine+="2";
			}
			var zmc:MyZMovieClip	=MySourceManager.getInstance().getMcFromSwf(swf,spine);
			if(zmc==null){return;}
			if(zmc && Dic属性["缩放"]){
				zmc.scaleX=Dic属性["缩放"];
				zmc.scaleY=Dic属性["缩放"];
			}
			roleMC=new  MyMC(zmc);
			Role.addChildAt(roleMC,0);
		}
		if(roleMC)
		{
			roleMC.MC.gotoAndStopLable(url);
			roleMC.stop();
		}
	}
	
	public function enterF():void{
		if(isDead==true){
			if(action && nowAction==SData_Strings.ActionName_挨打){
				action.enterF();
			}
			return;
		}
		if(action){
			action.enterF();
		}
		if(Role){
			Role.x =Role_x;
			Role.y =-Role_y+Role_z;
		}
		if(Role影子){
			Role影子.x =Role_x;
			Role影子.y =Role_z;
		}
		enterBuffF();
		if(nextAction){
			changeRoleFlag(nextAction);
		}
	}
	public function enterBuffF():void{
		if(Arr_Buff!=null){
			for(var i:int=0;i<Arr_Buff.length;i++){
				var buff:Fight_Buff =Arr_Buff[i];
				if(buff.end==true){
					Arr_Buff.splice(i--,1);
					if(dic_linkBuff && dic_linkBuff[buff.Name]!=null){
						var arr:Array=dic_linkBuff[buff.Name];
						while(arr.length>0){
							arr[0].endF();
							arr.shift();
						}
						dic_linkBuff[buff.Name]=Tool_ObjUtils.getInstance().destroyF_One(dic_linkBuff[buff.Name]);
					}
				}else{
					buff.enterF();
				}
			}
		}
	}
	/**
	 * 本回合开始行动
	 * */
	public function onRoundStartF():void{
		change属性("沉默",null,true);
		var i:int;
		for(i=0;i<Arr_Skill.length;i++){
			if(Arr_Skill[i]){
				Arr_Skill[i].countCD--;
			}
		}
		if(Arr_Buff!=null){
			for(i=0;i<Arr_Buff.length;i++){
				var buff:* =Arr_Buff[i];
				buff.onRoundF();
			}
		}
		if(isDead==true){//buff致死
			onActionEnd();
		}
		//如果有buff需要播放动画，等待动画：busy=true;
	}
	
	public function get属性(key:String,	nullTOzero:Boolean=true):*{
		checkBuffF(SData_Buff.BuffCheckType_getValues);
		if(tmpDicBuffEffect[key] != null){return tmpDicBuffEffect[key];}
		if(Dic属性[key]==null && nullTOzero==true){return 0;}
		return Dic属性[key];
	}
	public function change属性(key:String,value:*,强制:Boolean=false):void{
		if(safe属性 && safe属性.checkF(key,Dic属性[key])==false){
			PlayerMain.getInstance().onErrorF(ID+"角色属性["+key+"]错误");
			return;
		}
		if(强制==true || value==null || Dic属性[key]==null || Tool_Function.isTypeOf(value,Number)==false){
			Dic属性[key]=value;
			if(safe属性 ){
				safe属性.setValue(key,value);
			}
		}else{
			if(safe属性 ){
				safe属性.setValue(key,Dic属性[key]+value);
			}
			Dic属性[key]+=value;
		}
		if(safe属性 && safe属性.checkF(key,Dic属性[key])==false){
			PlayerMain.getInstance().onErrorF(ID+"角色属性["+key+"]错误");
		}
		if(key=="mp" || key=="怒气" || key=="能量" || key=="印记" || key=="激素"){
			if(Dic属性[key] > Dic属性[key+"Max"]){
				Dic属性[key]=Dic属性[key+"Max"];
				safe属性.setValue(key,Dic属性[key+"Max"]);
			}
			MainManager.getInstence().MEM.dispatchF("第二属性改变",ID);
		}
		else if(key=="变身"){//本游戏的特殊属性，会影响技能的表里状态
			haveChangeState=true;
		}
		else if(key=="hpMax"){
			change属性("hp",value);
			if(Dic属性["hp"]>Dic属性["hpMax"]){
				change属性("hp",Dic属性["hpMax"],true);
			}
		}
//		trace("改变属性："+key,"，结果="+Dic属性[key]);
	}
	
	/**
	 * 添加buff
	 * */
	public function addBuff(buff:*):void{
		if(Arr_Buff==null){Arr_Buff=[];}
		Arr_Buff.push(buff);
		onChangeBuffIconXY();
	}
	/**
	 * 添加关联buff
	 * */
	public function addLinkBuff(waiteBuff:*,	buff:*):void{
		if(dic_linkBuff==null){dic_linkBuff=Tool_ObjUtils.getNewObjectFromPool();}
		if(dic_linkBuff[waiteBuff]==null){dic_linkBuff[waiteBuff]=Tool_ArrayUtils.getNewArrayFromPool();}
		dic_linkBuff[waiteBuff].push(buff);
	}
	/**
	 * 修改buffIcon的显示位置
	 * */
	public function onChangeBuffIconXY():void{
		var arrIcons:Array=Tool_ArrayUtils.getNewArrayFromPool();
		var i:int;
		for(i=0;i<Arr_Buff.length;i++){
			if(Arr_Buff[i] && Arr_Buff[i].icon){
				arrIcons.push(Arr_Buff[i].icon);
			}
		}
		if(arrIcons.length>0){
			var mid:int=2;
			var l:int=SData_Buff.WidthIcon * arrIcons.length + (arrIcons.length-1) * mid;
			var x0:int =-l/2;
			var y0:int =-RoleHeight-SData_Buff.WidthIcon-mid;
			for(i=0;i<arrIcons.length;i++){
				arrIcons[i].setXY(x0 + i * (SData_Buff.WidthIcon+mid),y0);
			}
		}
		arrIcons.length=0;
		Tool_ArrayUtils.returnArrayToPool(arrIcons);
	}
	/**
	 * 检查Buff效果
	 * */
	public function checkBuffF(key:String,  info:* =null):void{
		if(tmpDicBuffEffect==null){tmpDicBuffEffect=Tool_ObjUtils.getNewObjectFromPool();}
		else if(key != SData_Buff.BuffCheckType_getValues){Tool_ObjUtils.getInstance().onClearObj(tmpDicBuffEffect);}
		if(Arr_Buff==null || Arr_Buff.length==0){return;}
		for(var i:int=0;i<Arr_Buff.length;i++){
			var buff:Fight_Buff =Arr_Buff[i];
			if(buff && buff.pause==false && buff.end==false){
				buff.checkF(key,info);
			}
		}
	}
	public var tmpDicBuffEffect:*;

	public function beHurtF(atkP:int,atkM:int,isCritical:Boolean,from:*):void{
		var hurtHp:*;
//		atkP=1;
//		atkM=0;
		if(atkP>0){
			atkP=Tool_Function.on强制转换(atkP);
			if(isCritical==false){
				hurtHp=Tool_Function.onNewClass(FIght_HurtHp,atkP,this);
			}else{
				hurtHp=Tool_Function.onNewClass(FIght_HurtHp,{"暴击":atkP},this);
			}
			mainView.addHurtMc(hurtHp);
			change属性("hp",-atkP);
		}
		if(atkM>0){
			atkM=Tool_Function.on强制转换(atkM);
			if(isCritical==false){
				hurtHp =Tool_Function.onNewClass(FIght_HurtHp,atkM,this);
			}else{
				hurtHp =Tool_Function.onNewClass(FIght_HurtHp,{"暴击":atkM},this);
			}
			mainView.addHurtMc(hurtHp);
			change属性("hp",-atkM);
		}
		if(McHp){McHp.onShowF();}
		if(isDead==true)return;
		var hp:int =get属性("hp");
//		trace(ID+"挨打，hp剩余"+hp);
		if(hp<=0){
			if(action && action.canDead()==false){return;}
			onRealDeadF();
		}
	}
	public function onRealDeadF():void{
		change属性("hp",0,true);
		isDead=true;
		Role.visible=false;
		onCheckDropF();
		trace(ID+"死亡！");
		if(Arr_Buff!=null){
			var i:int;
			for(i=0;i<Arr_Buff.length;i++){
				var buff:* =Arr_Buff[i];
				buff.onRoleDeadF();
			}
			enterBuffF();
		}
	}
	public function bePureF(hp:int,mp:int,from:*):void{
		if(hp>0){
			checkBuffF(SData_Buff.BuffCheckType_BePureHP);
			var hurtHp:* =Tool_Function.onNewClass(FIght_HurtHp,{"回复HP":hp},this);
			mainView.addHurtMc(hurtHp);
			var hpNow:int =get属性("hp");
			var hpMax:int =get属性("hpMax");
			if(hpNow<hpMax){
				if(hpNow+hp <= hpMax){
					change属性("hp",hp);
				}else{
					change属性("hp",hpMax - hpNow);
				}
			}
			if(McHp){McHp.onShowF();}
		}
		if(mp>0){
			hurtHp =Tool_Function.onNewClass(FIght_HurtHp,{"回复MP":mp},this);
			mainView.addHurtMc(hurtHp);
			var mpNow:int =get属性("mp");
			var mpMax:int =get属性("mpMax");
			if(mpNow<mpMax){
				if(mpNow+mp <= mpMax){
					change属性("mp",mp);
				}else{
					change属性("mp",mpMax - mpNow);
				}
			}
		}
	}
	
	public function onActionEnd():void{
		checkBuffF(SData_Buff.BuffCheckType_ActionEnd);
		for(var i:int=0;i<Arr_Skill.length;i++){
			if(Arr_Skill[i]){
				Arr_Skill[i].addIconSpr(null);
			}
		}
	}
	/** 检测掉落 */
	private function onCheckDropF():void{
		if(camp==1 || drop==null || drop.length==0)return;
		sprDrops=new  Sprite();
		Role.parent.addChildAt(sprDrops,Role.parent.getChildIndex(Role));
		sprDrops.x=Role.x;
		sprDrops.y=Role.y;
		Arr_DropMc=[];
		for(var i:int=0;i<drop.length;i++){
			var one:Fight_Drops=new  Fight_Drops(drop[i],0,Math.random()*20-40);
			sprDrops.addChild(one);
			Arr_DropMc.push(one);
		}
	}
	
	public function isFront():Boolean{
		if(Position==1){return true;}
		return false;
	}
	public function isMiddle():Boolean{
		if(Position==2 || Position==3 || Position==4){return true;}
		return false;
	}
	public function isBack():Boolean{
		if(Position==5 || Position==6 || Position==7){return true;}
		return false;
	}
	
	public function destroyF():void{
		mainView=null;
		action=null;
		rm=null;
		AI=Tool_ObjUtils.getInstance().destroyF_One(AI);
		Role=Tool_ObjUtils.getInstance().destroyF_One(Role);
		roleMC=Tool_ObjUtils.getInstance().destroyF_One(roleMC);
		dicMCs=Tool_ObjUtils.getInstance().destroyF_One(dicMCs);
		Role影子=Tool_ObjUtils.getInstance().destroyF_One(Role影子);
		McHp=Tool_ObjUtils.getInstance().destroyF_One(McHp);
		Dic_Actions=Tool_ObjUtils.getInstance().destroyF_One(Dic_Actions);
		Arr_Buff=Tool_ObjUtils.getInstance().destroyF_One(Arr_Buff);
		Dic属性=Tool_ObjUtils.getInstance().destroyF_One(Dic属性);
		safe属性=Tool_ObjUtils.getInstance().destroyF_One(safe属性);
		tmpDicBuffEffect=Tool_ObjUtils.getInstance().destroyF_One(tmpDicBuffEffect);
		dic_linkBuff=Tool_ObjUtils.getInstance().destroyF_One(dic_linkBuff);
		sprDrops=Tool_ObjUtils.getInstance().destroyF_One(sprDrops);
		Arr_DropMc=Tool_ObjUtils.getInstance().destroyF_One(Arr_DropMc);
	}
}
}
