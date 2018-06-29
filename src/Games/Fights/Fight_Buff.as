package Games.Fights{
	import com.MyClass.Config;
	import com.MyClass.MySourceManager;
	import com.MyClass.Tools.Tool_ArrayUtils;
	import com.MyClass.Tools.Tool_Function;
	import com.MyClass.Tools.Tool_ObjUtils;
	import com.MyClass.Tools.Tool_StringBuild;
	
	import StaticDatas.SData_Buff;
	import StaticDatas.SData_Strings;
	
	import lzm.starling.swf.display.SwfMovieClip;

public class Fight_Buff{
	public var ID:*;
	public var Name:String;
	public var strIntro:String;
	public var isBad:Boolean=false;
	public var isScence:Boolean=false;
	public var TypeCreat:String;
	public var TypeLast:String;//持续
	public var TypeAct:String;//生效条件
	public var TypeActNeed:String;//生效判定对象
	public var TypeCheckTime:String;
	public var TypeEffect:String;
	public var lastRounds:int;
	public var costValueName:String;
	public var costValueNum:int;
	public var costIsFouce:Boolean=false;
	public var TypeSuperpose:String;//buff叠加的方式：不叠加，叠加，不允许重复
	public var dicSpeValues:*;
	public var fromRole:Fight_Role;
	
	public var Role:Fight_Role;
	public var end:Boolean=false;
	public var pause:Boolean=false;//暂停
	//改变属性
	public var dic_values:*;
	public var haveChangedValues:*;
	//显示
	public var URL_Icon:String;
	public var URL_Mc:String;
	public var TypeAniPosition:String;//动画的位置：脚底，中心，头上
	public var icon:Fight_BuffIcon;
	
	public function Fight_Buff(_role:*,dic:*,_fromRole:* =null,	info:* =null){
		Role=_role;
		fromRole=_fromRole;
		if(dic["ID"]!=null){ID=dic["ID"];}
		if(dic["Name"]!=null){Name=dic["Name"];}
		if(dic["介绍"]!=null){strIntro=dic["介绍"];}
		if(dic["异常状态"]!=null){isBad=dic["异常状态"];}
		if(dic["场景buff"]==true){isScence=true;}
		if(dic["叠加"]!=null){TypeSuperpose=dic["叠加"];}
		TypeCreat=dic["生成条件"];
		TypeLast=dic["持续方式"];
		if(dic["持续回合"]!=null){lastRounds=dic["持续回合"];}
		TypeAct=dic["生效条件"];
		if(dic["生效条件对象"]!=null){TypeActNeed=dic["生效条件对象"];}
		if(dic["消耗属性名"]!=null){costValueName=dic["消耗属性名"];}
		if(dic["消耗属性量"]!=null){costValueNum=dic["消耗属性量"];}
		if(dic["消耗强制"]==true){costIsFouce=true;}
		TypeCheckTime=dic["生效时间"];
		TypeEffect=dic["生效方式"];
		if(dic["属性"]!=null){
			if(dic_values==null){
				dic_values=Tool_ObjUtils.getNewObjectFromPool();
			}
			var key:String;
			for(key in dic["属性"]){
				dic_values[key]=dic["属性"][key];
			}
		}
		if(dic["图标"]!=null){URL_Icon=dic["图标"];}
		if(dic["动画"]!=null){URL_Mc=dic["动画"];}
		if(dic["动画坐标"]!=null){TypeAniPosition=dic["动画坐标"];}
		if(dic["特殊"]!=null){
			dicSpeValues=Tool_ObjUtils.getInstance().CopyF(dic["特殊"]);
		}
		if(checkCanCreat(info)==false){//赋值了基本属性后再计算是否能生成
			Role=null;
			return;
		}
		onShowIconF();
		onShowAniF();
		Role.addBuff(this);
		onStartF();
	}
	public function initByDic(dic:*):void{
		if(dic){
			for(var key:String in dic){
				try{
					this[key]=dic[key];
				}catch(e:Error){
					Config.Log(Name+"：buff修改属性错误："+key);
				}
			}
		}
	}
	
	public function checkCanCreat(info:*):Boolean{
		if(onCheckSameBuff()==false){
			return false;
		}//终止
		if(TypeCreat==SData_Buff.TypeCreat_hit){
			if(info==null){
				return false;
			}
		}
		Role.checkBuffF(SData_Buff.BuffCheckType_otherBuff,Name);
		if(Role.tmpDicBuffEffect["buff抵抗"]==true){
			return false;
		}
		return true;
	}
	public function onCheckSameBuff():Boolean{
		if(isScence==true){return true;}
		if(TypeSuperpose==null || TypeSuperpose==SData_Buff.TypeSuperpose_single){return true;}
		var i:int;
		var buff:*;
		if(Role.Arr_Buff){
			for(i=0;i<Role.Arr_Buff.length;i++){
				buff=Role.Arr_Buff[i];
				if(buff && buff.ID==ID){
					if(TypeSuperpose==SData_Buff.TypeSuperpose_only){
						return false;
					}else if(TypeSuperpose==SData_Buff.TypeSuperpose_need){
						onSuperpose(buff);
						return false;
					}
					break;
				}
			}
		}
		return true;
	}
	
	public function onSuperpose(buff:Fight_Buff):void{
		if(TypeLast==SData_Buff.TypeLast_rounds){
			if(lastRounds>buff.lastRounds){
				buff.lastRounds=lastRounds;
				buff.onShowIconF();
			}
		}
	}
	
	public function onStartF():void{
		checkF(SData_Buff.BuffCheckType_BuffStart,null);
	}
	
	/**
	 * 改变属性类buff的操作
	 * @param type 增加，减少，强制，还原
	 * */
	public function onChangeValues(type:String):void{
		if(Role==null || dic_values==null){return;}
		var key:String;
		var per:int;
		var now:int;
		var value:int;
		if(type=="增加"){
			if(haveChangedValues==null){haveChangedValues=Tool_ObjUtils.getNewObjectFromPool();}
			for(key in dic_values){
				if(Tool_Function.isTypeOf(dic_values[key],String)==true){
					per =Tool_Function.on强制转换((dic_values[key] as String).substr(0,dic_values[key].length-1));
					now=Role.get属性(key);
					value =now * per * 0.01;
				}else{
					value=dic_values[key];
				}
				Role.change属性(key,value);
				if(key!="hp"){
					if(haveChangedValues[key]==null){haveChangedValues[key]=value;}
					else {haveChangedValues[key]+=value;}
				}else if(key == "hp"){//扣除hp不会恢复
					var hurtHp:* =Tool_Function.onNewClass(FIght_HurtHp,value,Role);
					Role.mainView.addHurtMc(hurtHp);
				}
			}
		}else if(type=="减少"){
			if(haveChangedValues==null){return;}
			for(key in haveChangedValues){
				Role.change属性(key,-haveChangedValues[key]);
			}
			haveChangedValues=Tool_ObjUtils.getInstance().destroyF_One(haveChangedValues);
		}
	}
	
	public function enterF():void{//mc移动和播放等
		if(end==true){return;}
		if(icon){icon.enterF();}
	}
	
	public function checkF(key:String,	info:*):void{
		if(end==true || pause==true){return;}
		if(key != TypeCheckTime){return;}
		if(dicSpeValues!=null && dicSpeValues["生效"]==false){return;}
		//生效条件
		if(TypeAct==SData_Buff.TypeAct_haveBadBuff){
			if(Tool_Function.isTypeOf(info,Fight_Role)==false){return;}
			var i:int;
			var tar:Fight_Role =info;
			var haveBad:Boolean=false;
			if(tar.Arr_Buff!=null){
				for(i=0;i<tar.Arr_Buff.length;i++){
					if(tar.Arr_Buff[i] && tar.Arr_Buff[i].end==false && tar.Arr_Buff[i].isBad==true){
						haveBad=true;
						break;
					}
				}
			}
			if(haveBad==false){return;}
		}
		else if(TypeAct==SData_Buff.TypeAct_isLowHp){
			tar=info;
			var per:int= 100 * tar.get属性("hp") / tar.get属性("hpMax");
			var need:int;
			if(dicSpeValues["hp"] is String){
				need=Tool_Function.on强制转换(Tool_StringBuild.replaceSTR(dicSpeValues["hp"],"%",""));
			}else{
				need=dicSpeValues["hp"];
			}
			if(per > dicSpeValues["hp"]){
				return;
			}
		}
		else if(TypeAct==SData_Buff.TypeAct_isFront){
			if(Tool_Function.isTypeOf(info,Fight_Role)==false){return;}
			tar=info;
			if(tar.Position!=1){return;}
		}
		else if(TypeAct==SData_Buff.TypeAct_isMiddle){
			if(Tool_Function.isTypeOf(info,Fight_Role)==false){return;}
			tar=info;
			if(tar.Position!=2 && tar.Position!=3 && tar.Position!=4){return;}
		}
		else if(TypeAct==SData_Buff.TypeAct_isBack){
			if(Tool_Function.isTypeOf(info,Fight_Role)==false){return;}
			tar=info;
			if(tar.Position!=5 && tar.Position!=6 && tar.Position!=7){return;}
		}
		//生效成功
		onEffectF(key,info);
	}
	public function onEffectF(key:String,info:*):void{
		if(TypeEffect==SData_Buff.TypeEffect_valuesChange){//直接改变属性
			if(dic_values && dic_values[key] != null){
				Tool_ObjUtils.getInstance().onClearObj(Role.tmpDicBuffEffect);
				Role.tmpDicBuffEffect[key]=dic_values[key];
			}
		}
		else if(TypeEffect == SData_Buff.TypeEffect_valuesAdd){
			onChangeValues("增加");
		}
		else if(TypeEffect == SData_Buff.TypeEffect_recoverl){
			onPureTarF(Role);
		}
		else if(TypeEffect == SData_Buff.TypeEffect_stop){
			Role.tmpDicBuffEffect["无法行动"]=true;
		}
		else if(TypeEffect == SData_Buff.TypeEffect_breakSkill){
			Role.tmpDicBuffEffect["中断技能"]=true;
		}
		else if(TypeEffect == SData_Buff.TypeEffect_cannotBeTar){
			if(fromRole && fromRole.Position==info){
				Role.tmpDicBuffEffect["无法选择"]=true;
			}
		}
		else if(TypeEffect==SData_Buff.TypeEffect_Silence){
			Role.change属性("沉默",dicSpeValues["允许"],true);
		}
		else if(TypeEffect == SData_Buff.TypeEffect_moreToFront){//对前排加成
			if(Tool_Function.isTypeOf(info,Fight_Role)==false){return;}
			var tar:Fight_Role =info;
			if(tar.Position==1){
				onChangeValues("增加");
			}
		}
		else if(TypeEffect == SData_Buff.TypeEffect_moreToMiddle){//对中排加成
			if(Tool_Function.isTypeOf(info,Fight_Role)==false){return;}
			tar =info;
			if(tar.Position==2 || tar.Position==3 || tar.Position==4){
				onChangeValues("增加");
			}
		}
		else if(TypeEffect == SData_Buff.TypeEffect_moreToMiddle){//对后排加成
			if(Tool_Function.isTypeOf(info,Fight_Role)==false){return;}
			tar =info;
			if(tar.Position==5 || tar.Position==6 || tar.Position==7){
				onChangeValues("增加");
			}
		}
		else if(TypeEffect==SData_Buff.TypeEffect_newBuff){
			Role.tmpDicBuffEffect["额外buff"]=dicSpeValues["额外buff"];
		}
		else if(TypeEffect==SData_Buff.TypeEffect_backHurt){//反弹伤害
			if(info["from"]==null){return;}
			if( dicSpeValues["反弹概率"]!=null && Math.random() * 100 > dicSpeValues["反弹概率"]){return;}
			atkTarReal(info["from"],	Tool_Function.on强制转换(dicSpeValues["反弹比例"] * info["物理"] * 0.01),		Tool_Function.on强制转换(dicSpeValues["反弹比例"] * info["魔法"] * 0.01));
			//			if(Role.tmpDicBuffEffect["反弹伤害"]==null)Role.tmpDicBuffEffect["反弹伤害"]=[];
			//			Role.tmpDicBuffEffect["反弹伤害"].push([Tool_Function.on强制转换(dicSpeValues["反弹比例"] * info["物理"] * 0.01),Tool_Function.on强制转换(dicSpeValues["反弹比例"] * info["魔法"] * 0.01)]);
		}
	}
	/**
	 * 显示
	 * */
	public function onShowIconF():void{
		if(URL_Icon==null){return;}
		if(icon==null){
			icon=Tool_Function.onNewClass(Fight_BuffIcon,this);
		}
		if(icon){
			icon.onShowF();
		}
	}
	public static var Dic_BuffAni:*;
	public function onShowAniF():void{
		if(URL_Mc==null || isScence==true){return;}
		if(Dic_BuffAni==null){Dic_BuffAni=Tool_ObjUtils.getNewObjectFromPool();}
		if(Dic_BuffAni[Role.ID+"_"+ID] != null){
			Dic_BuffAni[Role.ID+"_"+ID]["num"]++;
		}else{
			var mc:SwfMovieClip=MySourceManager.getInstance().getMcFromSwf(SData_Strings.SWF_战斗界面,URL_Mc);
			if(mc){
				mc.loop=true;
				Role.Role.addChild(mc);
				var dic:* =Tool_ObjUtils.getNewObjectFromPool();
				dic["num"]=1;
				dic["mc"]=mc;
				Dic_BuffAni[Role.ID+"_"+ID]=dic;
				if(TypeAniPosition==SData_Buff.TypeAniPosition_top){
					mc.y = -Role.RoleHeight;
				}else if(TypeAniPosition==SData_Buff.TypeAniPosition_middle){
					mc.y = -Role.RoleHeight/2;
				}
				if(TypeLast==SData_Buff.TypeLast_delay){
					if(mc.hasLabel("R"+lastRounds)){
						mc.gotoAndPlay("R"+lastRounds);
					}
				}
			}
		}
	}
	
	public function endF():void{
		if(end==true){return;}
		end=true;
		if(TypeEffect==SData_Buff.TypeEffect_valuesAdd){
			onChangeValues("减少");
		}
		destroyF();
	}
	public function atkTarReal(tar:Fight_Role,atkP:int,atkM:int):void{
		var defP:int =tar.get属性("物防");
		var defM:int =tar.get属性("魔防");
		atkP-=defP;
		atkM-=defM;
		var isCritical:Boolean=false;
		var per:int =tar.get属性("物理减免");
		var per2:int =tar.get属性("魔法减免");
		if(per != 0){atkP -= atkP * per * 0.01;}
		if(per2 != 0){atkM -= atkM * per2 * 0.01;}
		//		tar.checkBuffF(SData_Buff.BuffCheckType_被击后);
		tar.beHurtF(atkP,atkM,isCritical,null);
	}
	
	public function onRoleDeadF():void{
		if(TypeLast != SData_Buff.TypeLast_forever){
			destroyF();
		}else{
			if(icon){
				icon.visible=false;
			}
		}
	}
	
	public function onPureTarF(tar:Fight_Role):void{
		var pureHP:int=0;
		var pureMP:int=0;
		if(dicSpeValues["hp"] > 0){
			pureHP=dicSpeValues["hp"] * Role.get属性("魔攻") * 0.01;
		}
		if(dicSpeValues["mp"] > 0){
			pureMP=dicSpeValues["mp"] * Role.get属性("魔攻") * 0.01;
		}
		if(pureHP>0 || pureMP>0){
			tar.bePureF(pureHP,pureMP,null);
		}
		if(dicSpeValues["解除异常"]==null){
			return;
		}
		var pureRecoverBuff:int =1;
		if(pureRecoverBuff > 0){
			var perRecover:int=Role.get属性("技能命中");
			var arrBads:Array=Tool_ArrayUtils.getNewArrayFromPool();
			var i:int;
			var buff:*;
			if(tar.Arr_Buff){
				for(i=0;i<tar.Arr_Buff.length;i++){
					buff =tar.Arr_Buff[i];
					if(buff.isBad == true && buff.end==false){
						arrBads.push(buff);
					}
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
	}
	
	public function destroyF():void{
		endF();
		dic_values=Tool_ObjUtils.getInstance().destroyF_One(dic_values);
		dicSpeValues=Tool_ObjUtils.getInstance().destroyF_One(dicSpeValues);
		icon=Tool_ObjUtils.getInstance().destroyF_One(icon);
		if(Role){
			if(URL_Mc && Dic_BuffAni != null && Dic_BuffAni[Role.ID+"_"+ID] != null){
				Dic_BuffAni[Role.ID+"_"+ID]["num"]--;
				if(Dic_BuffAni[Role.ID+"_"+ID]["num"]<=0){
					Dic_BuffAni[Role.ID+"_"+ID]=Tool_ObjUtils.getInstance().destroyF_One(Dic_BuffAni[Role.ID+"_"+ID]);
				}
			}
			Role=null;
		}
		fromRole=null;
	}
	
	
}
}