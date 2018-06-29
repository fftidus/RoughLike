package Games.Fights{
import com.MyClass.MySourceManager;
import com.MyClass.MyView.TmpMovieClip;
import com.MyClass.Tools.Tool_ArrayUtils;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import StaticDatas.SData_Buff;
import StaticDatas.SData_Skills;
import StaticDatas.SData_Strings;

import lzm.starling.swf.display.SwfMovieClip;

import starling.display.Sprite;

public class Fight_Action_SkillDefault extends Fight_ActionDefault{
	public var ID:*;
	public var Lv:int;
	public var 介绍:String;
	public var needClose:int=0;//近战技能？需要接近到离目标多少距离
	public var isPassive:Boolean=false;
	public var cd:int;
	public var countCD:int;
	public var cost:*;
	public var costValue:*;//消耗的属性：mp，怒气……
	public var dependValue:String;//需要但不消耗的属性
	public var dependValueNum:int;
	public var isShield:Boolean=false;//被屏蔽
	public var Type:String;
	public var TypeArea:String;
	public var canSelectTar:Boolean=false;
	public var Dic_Values:*;
	public var Arr_hit:Array=[];
	//攻击
	public var TypeAtk:String;
	public var Atk:int;
	public var AtkP:int;
	public var isTruthHurt:Boolean=false;
	public var tarBuffPer:*;
	public var tarBuff:*;
	public var selfBuffPer:*;
	public var selfBuff:*;
	public var tarScenceBuffPer:*;
	public var tarScenceBuff:*;
	//辅助
	public var pureHP:int;
	public var pureMP:int;
	public var pureRecoverBuff:int;
	public var canToDead:int;//能否对死亡角色使用(0：不能，1：必须，2：都可以)
	//特效
	public var TypeAni:String;
	public var swfHitLight:String;
	public var urlHitLight:String;
	public var Fly_swf:String;
	public var Fly_url:String;
	public var Fly_x0:int=50;
	public var Fly_y0:int;
	public var Fly_spd:Number=10;
	public var Ani_swf:String;
	public var Ani_url:String;
	public var Ani_urlG:String;
	public var Ani_hurtFrame:*;//特效伤害帧，null则表示播放完才伤害
	public var isEnd:Boolean;
	public var isBreak:Boolean;
	//图标
	protected var sprIcon:Sprite;
	protected var imgIcon:*;
	protected var mcCD:*;
	protected var mcCannot:*;
	
	public var Arr_AtkFrame:Array;
	
	public function Fight_Action_SkillDefault(r:*,info:*)	{
		super(r);
		Tool_Function.on修改属性ByDic(this,info);
	}
	
	public function canUse():Boolean{
		if(isShield==true){return false;}
		if(countCD>0){return false;}
		var i:int;
		if(costValue!=null){
			if(Tool_Function.isTypeOf(costValue,Array) == false){
				if(costValue == "hp" && Tool_Function.isTypeOf(cost,String) == true){
					if(Role.get属性("hp")/Role.get属性("hpMax") < Tool_Function.on强制转换((cost as String).substr(cost.length-1))){
						return false;
					}
				}else	if(Role.get属性(costValue) < cost){
					return false;
				}
			}else{
				for(i=0;i<costValue.length;i++){
					if(Role.get属性(costValue[i]) < cost[i]){	return false;	}
				}
			}
		}
		if(dependValue!=null){
			if(dependValue=="hp比例"){
				if(Role.get属性("hp")/Role.get属性("hpMax") < dependValueNum){
					return false;
				}
			}else{
				if(Role.get属性(dependValue) < dependValueNum){
					return false;
				}
			}
		}
		return true;
	}
	
	override public function resetF():void{
		if(cd>0){
			countCD=cd+1;
		}
		isEnd=false;
		isBreak=false;
		Arr_hit.length=0;
		var i:int;
		if(costValue!=null){
			if(Tool_Function.isTypeOf(costValue,Array) == false){
				if(costValue == "hp" && Tool_Function.isTypeOf(cost,String) == true){
					var per:int = Tool_Function.on强制转换((cost as String).substr(0,cost.length-1));
					Role.beHurtF(Tool_Function.on强制转换(Role.get属性("hpMax") * per * 0.01),0,false,null);
				}else{
					Role.change属性(costValue,-cost);
				}
			}else{
				for(i=0;i<costValue.length;i++){
					if(costValue[i] == "hp" && Tool_Function.isTypeOf(cost[i],String) == true){
						per = Tool_Function.on强制转换((cost[i] as String).substr(0,cost[i].length-1));
						Role.beHurtF(Tool_Function.on强制转换(Role.get属性("hpMax") * per * 0.01),0,false,null);
					}else{
						Role.change属性(costValue[i] , -cost[i]);
					}
				}
			}
		}
	}
	
	override public function enterF():void{
	}
	
	/**
	 * 攻击其他角色
	 * */
	public function checkAtkF():void{
	}
	public function onCreatFlyObj(tar:*):void{
		Tool_Function.onNewClass(Fight_FlyObject,this,tar);
	}
	public function onCreatAnimc(tar:*):void{
//		Tool_Function.onNewClass(Fight_SkillAni,this,tar);
	}
	
	public function onAtkTarF(tar:Fight_Role):void{
		if(tar.isDead==true){
			trace("目标已死");
			return;
		}
		var out:Array=getRoleAtkToTar(tar);
		var atk_wuli:int=out[0];
		var atk_mofa:int=out[1];
		Tool_ObjUtils.getInstance().destroyF_One(out);
		if(Arr_hit.indexOf(tar.ID) == -1){
			Arr_hit.push(tar.ID);
		}
		var hitInfo:*;
		var hitRadio:int =Role.get属性("命中");
		var missRadio:int =tar.get属性("闪避");
		var perMiss:int =Math.random() * 100;
		if(perMiss > (hitRadio-missRadio)){//闪避
			trace("成功闪避：随机数 "+perMiss+"，命中"+hitRadio+"，闪避"+missRadio);
			var hurtHp:* =Tool_Function.onNewClass(FIght_HurtHp,{"闪避":true},tar);
			Role.mainView.addHurtMc(hurtHp);
			tar.checkBuffF(SData_Buff.BuffCheckType_被击后,{});
		}else{
			out=getBaseHurtToTar(atk_wuli,atk_mofa,tar,true);
			atk_wuli=out[0];
			atk_mofa=out[1];
			var isCritical:Boolean=out[2];
			out=Tool_ObjUtils.getInstance().destroyF_One(out);
			
			tar.checkBuffF(SData_Buff.BuffCheckType_被击后,{"hp":atk_mofa+atk_wuli,"物理":atk_wuli,"魔法":atk_mofa,"暴击":isCritical,		"from":Role});
			if(tar.tmpDicBuffEffect["中断技能"]==true){
				isBreak=true;
			}
			if(tar.tmpDicBuffEffect["伤害减免"]!=null){
				atk_wuli=tar.tmpDicBuffEffect["伤害减免"]["物理"];
				atk_mofa=tar.tmpDicBuffEffect["伤害减免"]["魔法"];
			}
			tar.beHurtF(atk_wuli,atk_mofa,isCritical,Role);
			onCreatHitLight(tar);
			hitInfo=Tool_ObjUtils.getNewObjectFromPool();
			hitInfo["伤害"]=atk_mofa+atk_wuli;
			hitInfo["暴击"]=isCritical;
		}
		var per:int =tar.get属性("吸血");
		var per2:int =tar.get属性("吸血加成");
		if(per > 0 && hitInfo && hitInfo["伤害"]>0){
			var hp:int =hitInfo["伤害"] * per * 0.01;
			if(per2>0){hp +=per2 * hp * 0.01;}
			Role.bePureF(hp,0,null);
		}
		trace(Name+"：目标buff：",tarBuff);
		onAddBuffToTar(tar,tarBuffPer,tarBuff,hitInfo);//本游戏中buff和命中分开
		onAddBuffToTar(tar,tarScenceBuffPer,tarScenceBuff,hitInfo);//本游戏中buff和命中分开
		if( hitInfo && hitInfo["伤害"]>0 && Role.tmpDicBuffEffect["额外buff"] != null){
			onAddBuffToTar(tar,100,Role.tmpDicBuffEffect["额外buff"],hitInfo);
		}
	}
	public function getRoleAtkToTar(tar:Fight_Role):*{
		var atk_wuli:int;
		var atk_mofa:int;
		Role.checkBuffF(SData_Buff.BuffCheckType_攻击前,tar);
		var perAtk:int =Role.get属性("伤害加成");
		var perAtk2:int=0;
		if(TypeAtk==SData_Skills.TypeAtk_Physics){
			atk_wuli=Role.get属性("物攻") * AtkP * 0.01;
			atk_mofa=Role.get属性("武器魔攻");
			perAtk2=Role.get属性("物攻加成");
		}
		else if(TypeAtk == SData_Skills.TypeAtk_Magic){
			atk_wuli=Role.get属性("武器物攻");
			atk_mofa=Role.get属性("魔攻") * AtkP * 0.01;
			perAtk2=Role.get属性("魔攻加成");
		}else{//没有攻击
		}
		perAtk+=perAtk2;
		if(perAtk>0){
			atk_wuli+=atk_wuli * perAtk * 0.01;
			atk_mofa+=atk_mofa * perAtk * 0.01;
		}
		var out:Array=Tool_ArrayUtils.getNewArrayFromPool(atk_wuli,atk_mofa);
		return out;
	}
	/** 秒杀型AI使用 */
	public function getBaseHurtToTar(atk_wuli:int,atk_mofa:int,tar:Fight_Role,	needCritical:Boolean):*{
		if(isTruthHurt==false){
			var defP:int =tar.get属性("物防");
			var defM:int =tar.get属性("魔防");
			atk_wuli-=defP;
			atk_mofa-=defM;
			if(atk_wuli<0){atk_wuli=0;}
			if(atk_mofa<0){atk_mofa=0;}
		}
		var per:int =Role.get属性("暴击率");
		var per2:int =Role.get属性("暴击值");
		if(per2==0){per2=150;}
		var isCritical:Boolean=false;
		if(isTruthHurt==false || needCritical==true){//本游戏中真实伤害不能暴击
			if(Math.random() * 100 < per){
				isCritical=true;
				atk_wuli =per2 * atk_wuli * 0.01;
				atk_mofa =per2 * atk_mofa * 0.01;
			}
		}
		if(isTruthHurt==false){
			per =tar.get属性("物理减免");
			per2 =tar.get属性("魔法减免");
			if(per != 0){atk_wuli -= atk_wuli * per * 0.01;}
			if(per2 != 0){atk_mofa -= atk_mofa * per2 * 0.01;}
		}
		var out:Array=Tool_ArrayUtils.getNewArrayFromPool(atk_wuli,atk_mofa,isCritical);
		return out;
	}
	public function onAddBuffToTar(tar:Fight_Role,		per:*,buffs:*,	info:*):void{
		if(buffs==null || tar.isDead==true){return;}
		var perHit:int=Role.get属性("技能命中");
		var perMiss:int=tar.get属性("技能抵抗");
		var per:int=Math.random() * 100;
		if(Tool_Function.isTypeOf(per,Number)==true && per>0){//buff自带命中
			if( per > per){	return;	}
		}else if(per > perHit - perMiss){
			trace("闪避buff："+per+"，命中"+perHit+"，闪避"+perMiss);
			return;
		}
		var buff:*;
		var dic:*;
		if(Tool_Function.isTypeOf(buffs,Array)==true){
			for(var i:int=0;i<buffs.length;i++){
				addOneBuffToTar(buffs[i],tar,info);
			}
		}else{
			addOneBuffToTar(buffs,tar,info);
		}
	}
	public function addOneBuffToTar(bid:*,tar:Fight_Role,info:*):void{
		var buff:Fight_Buff=SData_Buff.getBuffByID(bid,tar,info);
		if(buff==null || buff.Role==null){return;}
	}
	
	public function onPureTarF(tar:*):void{
		trace(Name+"：目标buff：",tarBuff);
		onAddBuffToTar(tar,tarBuffPer,tarBuff,null);//本游戏中buff和命中分开
		var addHP:int = pureHP * Role.get属性("魔攻") * 0.01;
		var addMP:int =pureMP * Role.get属性("魔攻") * 0.01;
		tar.bePureF(addHP,addMP,Role);
		if(pureRecoverBuff > 0){
			var perRecover:int=Role.get属性("技能命中");
			var arrBads:Array=Tool_ArrayUtils.getNewArrayFromPool();
			var i:int;
			var buff:*;
			for(i=0;i<tar.Arr_Buff.length;i++){
				buff =tar.Arr_Buff[i];
				if(buff.isBad == true && buff.end==false){
					arrBads.push(buff);
				}
			}
			for(i=0;i<arrBads.length;i++){
				if(Math.random() * 100 < perRecover){
					arrBads[i].endF();
					perRecover = SData_Buff.getInstance().Dic["配置"]["解除衰减"] * perRecover;
				}
			}
			arrBads=Tool_ObjUtils.getInstance().destroyF_One(arrBads);
		}
		onCreatHitLight(tar);
	}
	
	public function onCreatHitLight(tar:*):void{
		if(urlHitLight==null){return;}
		var mc:SwfMovieClip;
		if(swfHitLight==null){
			mc=MySourceManager.getInstance().getMcFromSwf(SData_Strings.SWF_战斗界面,urlHitLight);
		}else{
			mc=MySourceManager.getInstance().getMcFromSwf(swfHitLight,urlHitLight);
		}
		if(mc==null){
			trace("没有击打光效："+urlHitLight);
			return;
		}
		if(tar.camp==1){
			mc.scaleX=-1;
		}
		var tmc:TmpMovieClip=new  TmpMovieClip(mc);
		tmc.x =tar.x;
		tmc.y =tar.Role_z - tar.RoleHeight/2;
		tar.mainView.addLightMc(tmc);
	}
	
	public function onAniEndF():void{
		if(isEnd){return;}
		isEnd=true;
		Role.checkBuffF(SData_Buff.BuffCheckType_攻击后,Arr_hit);
		onAddBuffToTar(Role,selfBuffPer,selfBuff,Arr_hit);
		Role.onActionEnd();
	}
	
	override public function breakF():void{
		sprIcon=Tool_ObjUtils.getInstance().destroyF_One(sprIcon);
		imgIcon=Tool_ObjUtils.getInstance().destroyF_One(imgIcon);
		mcCD=Tool_ObjUtils.getInstance().destroyF_One(mcCD);
		mcCannot=Tool_ObjUtils.getInstance().destroyF_One(mcCannot);
		super.breakF();
	}
	
	override public function destroyF():void{
		Arr_AtkFrame=Tool_ObjUtils.getInstance().destroyF_One(Arr_AtkFrame);
		super.destroyF();
	}
}
}