package Games.Fights {
import com.MyClass.Tools.MyHitArea;
import com.MyClass.Tools.Tool_ObjUtils;

import Games.Datas.Data_FightRole;
import Games.Fights.FightActions.FAction_Default;
import Games.Map.Map_Object;
import Games.Map.Map_Object_Roles;
import Games.Models.RoleModel;

import StaticDatas.SData_RolesInfo;

/**
 * 角色战斗
 * */
public class FightRole {
    /** 基础属性 */
    public var baseRoleMo:RoleModel;
    /** 属性 */
    public var valueFight:Data_FightRole;
    /** 显示 */
    public var mapRole:Map_Object_Roles;
    /** 控制器 */
    public var controller:RoleController;
    //移动缓存
    private var moveWaite:* =Tool_ObjUtils.getNewObjectFromPool("x",0,"y",0);
    //其他属性
    public var camp:int;//阵营
    public var nowDirection:int=0;//方向：0向右，1向左，10无方向角色
    public var isGod:int=0;//无敌
    public var isIron:int=0;//霸体
    public var isDead:int=0;//死亡的步骤，0未死，1死亡动画中，100可清理
    private var DicActions:Fight_DicActions;
    public var nowAction:FAction_Default;
    public var nextAction:String;
    public var nextAction_Item:Map_Object;//下一个动作来自的某个组件
    
    public function FightRole(rm:RoleModel) {
        baseRoleMo=rm;
        valueFight=new Data_FightRole();
        valueFight.initFromDic(baseRoleMo.getFightRoleInfo());
        mapRole=new Map_Object_Roles();
		mapRole.hitArea=new  MyHitArea();
		mapRole.hitArea.initFromDic({"type":2,"p":{"x":0,"y":0},"r":50});
        DicActions=new Fight_DicActions(this);
        onWantChangeAction(SData_RolesInfo.ActionName_Stand);
    }
    public function getValue(vname:String, nullToZero:Boolean=true):*{
        var value:* =null;
        if(valueFight){
            value =valueFight.getValueByName(vname);
        }
        if(value==null && nullToZero==true)return 0;
        return value;
    }
    /** 改变动画 */
    public function onChangeroleMC(swf:String,url:String):void{
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
        if(DicActions.hasAction(act)==false){
            act= SData_RolesInfo.ActionName_Stand;
        }
        var newact:FAction_Default=DicActions.getActionByName(act);
        if(newact.canUse()==false){return;}
        nextAction=act;
        nextAction_Item=fromComp;
    }

    /** 真实修改动作 */
    protected function onChangeAction():void{
        if(DicActions.hasAction(nextAction)==false){
            nextAction=SData_RolesInfo.ActionName_Stand;
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
        if(moveWaite.x != 0 || moveWaite.y != 0){
            mapRole.moveF(moveWaite);
            moveWaite.x=0;
            moveWaite.y=0;
        }
        if(nextAction!=null){//修改动作，本次帧频不计算
            onChangeAction();
        }else if(nowAction){
            nowAction.enterF();
        }else{
            onWantChangeAction(SData_RolesInfo.ActionName_Stand);
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
    
    public function destroyF():void{
        baseRoleMo=null;
        valueFight=Tool_ObjUtils.destroyF_One(valueFight);
        mapRole=Tool_ObjUtils.destroyF_One(mapRole);
        controller=Tool_ObjUtils.destroyF_One(controller);
        DicActions=Tool_ObjUtils.destroyF_One(DicActions);
        moveWaite=Tool_ObjUtils.destroyF_One(moveWaite);
    }
}
}
