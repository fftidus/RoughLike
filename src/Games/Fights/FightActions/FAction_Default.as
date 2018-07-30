package Games.Fights.FightActions {
import Games.Datas.Data_AttackArea;

import com.MyClass.Config;
import com.MyClass.Tools.Tool_ObjUtils;

import Games.Datas.Data_FActionStep;
import Games.Fights.FightRole;

import StaticDatas.SData_Strings;

public class FAction_Default {
    public var Role:FightRole;
    public var Name:String;
    public var swf:String;
    public var url:String;
    public var hitArea:Data_AttackArea;
    public var isGod:Boolean=false;
    public var isEndure:Boolean=false;
	
	private var _nowIndex:int;//当前步骤的位置
    protected var isSpdEffectByValue:String;//动作的速度受到某属性影响
    protected var isLoopAni:Boolean=false;//循环动画
    protected var nowCountFrame:Number;//当前动画的计时，100速度下每次加Config.frameMS
    protected var perMSofFrame:Number;
    protected var MsOfSwf:Number =1000/Config.swfFPS;
    protected var isEnd:Boolean=false;
    //控制：记录按下过的按键
    protected var isListeningKey:Boolean=false;
    protected var keys:*;
    
    public function FAction_Default() {
    }
    public function initF(info:*):void{
        if(info){
            if(info["swf"]!=null)swf=info["swf"];
            if(info["url"]!=null)url=info["url"];
            if(info["被击范围"]!=null)hitArea=new Data_AttackArea(info["被击范围"]);
        }
    }
    public function canUse():Boolean{
        return true;
    }
    /** 判断能否被使用物品操作打断 */
    public function checkCanStopByItem():Boolean{
        return false;
    }
    public function resetF():void{
        nowCountFrame=0;
        perMSofFrame =1;
        nowIndex=0;
        isEnd=false;
        onChangeRoleMcByURL();
    }
    public function onChangeRoleMcByURL():void{
        Role.onChangeroleMC(swf,url);
    }

    /** 收到攻速影响的动作 */
    protected function onCheckAtkSpd():void{
        if(isSpdEffectByValue==null){return;}
        var spdAtk:int =Role.getValue(isSpdEffectByValue);
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
	    nowIndex++;
        if(Role.mapRole.Role==null || nowIndex > Role.mapRole.Role.totalFrames-1){
            nowIndex=0;
        }
	    if(Role.mapRole.Role!=null){
            Role.mapRole.Role.currentFrame = nowIndex;
	    }
        onDoFrameEvent();
    }
	public function get nowIndex():int {	return _nowIndex;}
	public function set nowIndex(value:int):void {_nowIndex = value;}
    /** 执行本帧上的操作：攻击、位移、震动、残影…… */
    protected function onDoFrameEvent():void{
    }
    /** 动作结束 */
    protected function onActEndF():void{
        isEnd=true;
        if(Role.nowAction==this){
            Role.onWantChangeAction(SData_Strings.ActionName_Stand);
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
        removeIron();
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
        if(isEndure==false){
            isEndure=true;
            Role.isEndure++;
        }
    }
    public function removeIron():void{
        if(isEndure==true){
            isEndure=false;
            Role.isEndure--;
        }
    }
    /** 获得介绍文字 */
    public function getIntroduceString():String{
        return "";
    }

    public function destroyF():void{
        Role=null;
    }
}
}
