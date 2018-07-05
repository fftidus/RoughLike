package Games.Fights.FightActions {
import Games.Fights.FightRole;
import Games.Fights.Fight_ActionCost;

import StaticDatas.SData_RolesInfo;

import com.MyClass.Config;

import com.MyClass.Tools.Tool_ObjUtils;

public class FAction_Default {
    public var Role:FightRole;
    public var Name:String;
    public var swf:String;
    public var url:String;
    public var Arr_step:Array;
    public var cost:Fight_ActionCost;
    public var isGod:Boolean=false;
    public var isIron:Boolean=false;

    protected var isEffectBySpd:Boolean=true;//受到攻速影响
    protected var isLoopAni:Boolean=false;//循环动画
    public var Arr_aniStep:Array;//动画步骤，null表示循环播放
    public var nowStep:int;//当前动画的步骤
    public var nowIndex:int;//当前步骤的位置
    protected var nowCountFrame:Number;//当前动画的计时，100速度下每次加Config.frameMS
    protected var perMSofFrame:Number;
    protected var MsOfSwf:Number =1000/Config.swfFPS;
    protected var isEnd:Boolean=false;
    //控制：记录按下过的按键
    protected var isListeningKey:Boolean=false;
    protected var keys:*;
    
    public function FAction_Default() {
    }
    public function canUse():Boolean{
        if(cost){
            return cost.canUse();       
        }
        return true;
    }
    /** 判断能否被使用物品操作打断 */
    public function checkCanStopByItem():Boolean{
        return false;
    }
    public function resetF():void{
        nowCountFrame=0;
        nowStep=0;
        nowIndex=0;
        perMSofFrame =1;
        isEnd=false;
        onChangeRoleMcByURL();
    }
    public function onChangeRoleMcByURL():void{
        Role.onChangeroleMC(swf,url);
    }

    /** 收到攻速影响的动作 */
    protected function onCheckAtkSpd():void{
        if(isEffectBySpd==false){return;}
        var spdAtk:int =Role.getValue("攻速");
        if(spdAtk>0){//y = x/(x+0.5)		厂形状弧线，永不达到1
            perMSofFrame += spdAtk / (spdAtk + 60);
        }else if(spdAtk<0){
            perMSofFrame -= -spdAtk / (-spdAtk + 50);
        }
    }

    public function enterF():void{
        if(isEnd==true){onActEndF();return;}
        nowCountFrame+= Config.frameMS * perMSofFrame;
        while(nowCountFrame>=MsOfSwf){
            nowCountFrame-=MsOfSwf;
            nextFrame();
        }
    }

    /** 检测键盘事件，如果在监听则保存记录 */
    protected function checkKeyController():void{
    }

    /** 下一帧动作 */
    protected function nextFrame():void{
//        var rsm:RoleActionStepModel=Arr_aniStep[nowStep];
//        if(rsm==null || rsm.Arr_frame==null){//没有帧数据，表示必然是循环播放动画！
//            if(Role.roleMc && Role.roleMc.mc){
//                nowIndex++;
//                if(nowIndex >= Role.roleMc.mc.totalFrames){
//                    nowIndex=0;
//                }
//            }
//        }else{
//            if(nowIndex+1>=rsm.Arr_frame.length){
//                nextStep();
//            }else{
//                nowIndex++;
//            }
//        }
        onDoFrameEvent();
    }
    /** 下一个步骤动作 */
    protected function nextStep():void{
        if(isLoopAni == false){
            if(nowStep+1 >=Arr_aniStep.length){
                onActEndF();
                return;
            }
            nowStep++;
        }
        nowIndex=0;
    }
    /** 执行本帧上的操作：攻击、位移、震动、残影…… */
    protected function onDoFrameEvent():void{
    }
    /** 判断应该掉落时，确定该动作能否中断并进入掉落 */
    public function checkCanFalling():Boolean{
        return true;
    }
    /** 动作结束 */
    protected function onActEndF():void{
        isEnd=true;
        if(Role.nowAction==this){
            Role.onWantChangeAction(SData_RolesInfo.ActionName_Stand);
        }
    }
    /** 开始监听键盘事件 */
    protected function startListenKey():void{
        if(isListeningKey==true){return;}
        isListeningKey=true;
        if(keys==null){
            keys=Tool_ObjUtils.getNewObjectFromPool();
        }
    }
    /** 结束 */
    public function breakF():void{
        removeGod();
        removeIcon();
        isListeningKey=false;
        keys=Tool_ObjUtils.getInstance().destroyF_One(keys);
    }
    /**===============================修改霸体和无敌状态==============================*/
    public function addGod():void{
        if(isGod==false){
            isGod=true;
            Role.isGod++;
        }
    }
    public function removeGod():void{
        if(isGod==true){
            isGod=false;
            Role.isGod--;
        }
    }
    public function addIron():void{
        if(isIron==false){
            isIron=true;
            Role.isIron++;
        }
    }
    public function removeIcon():void{
        if(isIron==true){
            isIron=false;
            Role.isIron--;
        }
    }
    /** 获得介绍文字 */
    public function getIntroduceString():String{
        return "";
    }

    public function destroyF():void{
        Role=null;
        cost=Tool_ObjUtils.destroyF_One(cost);
    }
}
}
