package Games.Fights {
import Games.Datas.Data_AttackArea;
import Games.Datas.Data_Hurt;
import Games.Models.AttackModel;

import com.MyClass.Tools.MyHitArea;
import com.MyClass.Tools.Tool_Function;
import com.MyClass.Tools.Tool_ObjUtils;

import Games.Datas.Data_FightRole;
import Games.Fights.FightActions.FAction_Default;
import Games.Map.Map_Object;
import Games.Map.Map_Object_Roles;
import Games.Models.RoleModel;

import StaticDatas.SData_Strings;

/**
 * 角色战斗
 * */
public class FightRole {
    /** netid */
    public function get netID():*{return baseRoleMo.NetID;}
    /** 基础属性 */
    public var baseRoleMo:RoleModel;
    /** 战斗数据 */
    public var infoFight:*;
    /** 属性 */
    public var valueFight:Data_FightRole;
    /** 显示 */
    public var mapRole:Map_Object;
    /** 控制器 */
    public var controller:RoleController;
    /** 移动缓存*/
    private var moveWaite:* =Tool_ObjUtils.getNewObjectFromPool("x",0,"y",0);
	/** Buff */
	public var buffs:FightRole_Buffs;
    //其他属性
    public var camp:int;//阵营
    public var nowDirection:int=0;//方向：0向右，1向左，10无方向角色
    public var isGod:int=0;//无敌
    public var isEndure:int=0;//霸体
    /** 韧性控制器 */
    public var ToughnessCon:FightRole_ToughnessControl;
    /** 硬直控制器 */
    public var IronCon:FightRole_IronControl;
    /** 掉落 */
    public var isFalling:Boolean=false;
    /** 死亡的步骤，0未死，1死亡动画中，100可清理 */
    public var isDead:int=0;
    //动作
    private var DicActions:FightRole_DicActions;
    public var nowAction:FAction_Default;
    public var nextAction:String;
    public var nextAction_Item:Map_Object;//下一个动作来自的某个组件
    public var hurtData:Data_Hurt;
	/** 帧频事件 */
	public var DicEnterHandler:*;
    
    public function FightRole(rm:RoleModel) {
        if(rm==null)return;
        baseRoleMo=rm;
        valueFight=new Data_FightRole();
        infoFight =baseRoleMo.getFightRoleInfo();
        valueFight.initFromDic(infoFight["属性"]);
        DicActions=new FightRole_DicActions(this);
		buffs=new  FightRole_Buffs(this);
        ToughnessCon=new FightRole_ToughnessControl(this);
        IronCon=new FightRole_IronControl(this);
        initF();
        onWantChangeAction(SData_Strings.ActionName_Stand);
    }
    /** 初始化 */
    public function initF():void{
        mapRole=new Map_Object_Roles(this);
        mapRole.mhitArea=new  MyHitArea();
        if(baseRoleMo.hitArea) {
            mapRole.mhitArea.initFromDic({"type": 3, "p": {"x": 0, "y": 0}, "a": -baseRoleMo.hitArea.points[0], "b": baseRoleMo.hitArea.yUp});
        }else{
            mapRole.mhitArea.initFromDic({"type": 3, "p": {"x": 0, "y": 0}, "a": 30, "b": 15});
        }
    }
    /** 获得基础属性 */
    public function getBaseValue(vname:String, nullToZero:Boolean=true):*{
        var value:* =null;
        if(this.baseRoleMo && baseRoleMo.DicBaseValues){
            value =baseRoleMo.DicBaseValues[vname];
        }
        if(value==null && nullToZero==true)return 0;
        return value;
    }
    /** 获得属性 */
    public function getValue(vname:String, nullToZero:Boolean=true):*{
        var value:* =null;
        if(valueFight){
            value =valueFight.getValueByName(vname);
        }
        if(value==null && nullToZero==true)return 0;
        return value;
    }
    /** 修改属性 */
    public function changeValue(vname:String,   val:*):void{
        if(valueFight){
            valueFight.setValueByName(vname,val);
        }
    }
    /** 修改韧性 */
    public function changeToughness(value:int):void{
        ToughnessCon.resetToughness();
    }
    
    /** 改变动画 */
    public function onChangeroleMC(swf:String,url:String):void{
        mapRole.Role.initBaseMc(swf,url);
    }
    /** 改变方向 */
    public function onChangeDirect(dir:String):void{
        if(nowDirection==10){return;}
        if(dir=="左"){
            nowDirection=1;
            mapRole.scaleX=-1;
        }else{
            nowDirection=0;
            mapRole.scaleX=1;
        }
    }
    /** 修改动作，但不会立刻修改 */
    public function onWantChangeAction(act:String,fromComp:Map_Object=null):void{
        if(nextAction==SData_Strings.ActionName_Hurt){return;}
        if(DicActions.hasAction(act)==false){
            act= SData_Strings.ActionName_Stand;
        }
        var newact:FAction_Default=DicActions.getActionByName(act);
        if(newact.canUse()==false){return;}
        nextAction=act;
        nextAction_Item=fromComp;
    }

    /** 真实修改动作 */
    protected function onChangeAction():void{
        if(DicActions.hasAction(nextAction)==false){
            nextAction=SData_Strings.ActionName_Stand;
        }
        if(nowAction){
            nowAction.breakF();
        }
        nowAction=DicActions.getActionByName(nextAction);
        nextAction=null;
        nowAction.resetF();
        nextAction_Item=null;
    }
    
    public function enterF():void{
        if(isDead==1){
            isDead=100;
            destroyF();
            return;
        }else if(isDead==100){return;}
		//属性
		onRunEnterHandler();
		//移动
        onRealMoveF();
		//动作
        if(nextAction!=null){//修改动作，本次帧频不计算
            onChangeAction();
        }else if(nowAction){
            nowAction.enterF();
        }else{
            onWantChangeAction(SData_Strings.ActionName_Stand);
        }
    }
    /** 真实移动 */
    public function onRealMoveF():void{
        if(moveWaite.x != 0 || moveWaite.y != 0){
            mapRole.moveF(moveWaite);
            moveWaite.x=0;
            moveWaite.y=0;
        }
    }
    /** 掉落到地下 */
    public function onFalling():void{
        if(isFalling==false) {
            isFalling = true;
            mapRole.map.addMapObjectToLayer(mapRole, 1);
        }
        if(z<-200){
            mapRole.z =-200;
//	        mapRole.map.addMapObjectToLayer(Role.mapRole);//复活
            onDeadF();
        }
    }
	
	/** 注册帧频事件 */
	public function registEnterHandler(key:String,handler:*):void{
		if(DicEnterHandler==null){
			DicEnterHandler =Tool_ObjUtils.getNewObjectFromPool();
		}
		if(DicEnterHandler[key]!=null){
			Tool_ObjUtils.destroyF_One(DicEnterHandler[key]);
		}
		DicEnterHandler[key]=handler;
	}
	/** 注册的帧频事件 */
	private function onRunEnterHandler():void{
		if(DicEnterHandler==null)return;
		for(var key:String in DicEnterHandler){
			Tool_Function.onRunFunction(DicEnterHandler[key]);
		}
	}
	/** 移除帧频事件 */
	public function removeEnterHandler(key:String):void{
		if(DicEnterHandler && DicEnterHandler[key]!=null){
			Tool_ObjUtils.destroyF_One(DicEnterHandler[key]);
			delete DicEnterHandler[key];
		}
	}
	
	
    /** 移动 */
    public function onWantMoveX(_x:Number):void{
        moveWaite.x +=_x;
    }
    public function onWantMoveY(_y:Number):void{
        moveWaite.y +=_y;
    }
    public function onWantMoveZ(_z:Number):void{
        mapRole.z+=_z;
    }
    
    /** 坐标 */
    public function get x():Number{
        if(mapRole)return mapRole.x;
        return 0;
    }
    public function get y():Number{
        if(mapRole)return mapRole.y;
        return 0;
    }
    public function get z():Number{
        if(mapRole)return mapRole.z;
        return 0;
    }
    public function get nowGroundType():*{
        if(mapRole)return mapRole.nowGroundType;
        return null;
    }
    
    /** 被击打范围：如果当前动作有特殊范围则使用，没有则用默认rolemodel的范围 **/
    public function get hitArea():Data_AttackArea{
        if(nowAction && nowAction.hitArea){
            return nowAction.hitArea;
        }
        if(baseRoleMo.hitArea){return baseRoleMo.hitArea;}
        return null;
    }
    
    /** 被击打 */
    public function beHurt(hurtone:AttackModel):void{
        if(hurtone==null){return;}
        //有霸体则不进入被击打状态
        if(isEndure==true){
            if(ToughnessCon && ToughnessCon.costToughness(hurtone.data.perCostToughness)==false){
                return;
            }
        }
        if(nowAction && nowAction.Name!="挨打") {
            nextAction = SData_Strings.ActionName_Hurt;
        }
        if(hurtData==null){
            hurtData=Data_Hurt.getNewOne(this);
        }
        hurtData.beHurt(hurtone);
    }
    
    /** 死亡 */
    public function onDeadF():void{
        if(isDead!=0){return;}
        isDead=1;
        if(DicActions.hasAction("死亡")==false){
            isDead=100;
            clearF();
        }else{
            nextAction="死亡";
            onChangeAction();
        }
    }
    
    /** 清理数据，但保留引用等待进入下一个场景 */
    public function clearF():void{
        if(mapRole){
            mapRole.removeFromParent(false);
            mapRole=null;
        }
    }
    public function destroyF():void{
        baseRoleMo=null;
        valueFight=Tool_ObjUtils.destroyF_One(valueFight);
        mapRole=Tool_ObjUtils.destroyF_One(mapRole);
        controller=Tool_ObjUtils.destroyF_One(controller);
        DicActions=Tool_ObjUtils.destroyF_One(DicActions);
		buffs=Tool_ObjUtils.destroyF_One(buffs);
        moveWaite=Tool_ObjUtils.destroyF_One(moveWaite);
		DicEnterHandler=Tool_ObjUtils.destroyF_One(DicEnterHandler);
        ToughnessCon=Tool_ObjUtils.destroyF_One(ToughnessCon);
        IronCon=Tool_ObjUtils.destroyF_One(IronCon);
        hurtData=Tool_ObjUtils.destroyF_One(hurtData);
    }
}
}
