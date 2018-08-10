package Games.Fights.FightActions {
import Games.Datas.Data_AttackArea;
import Games.Datas.Data_FActionStep_sound;
import Games.Datas.Data_Sound;

import StaticDatas.SData_EventNames;

import com.MyClass.Config;
import com.MyClass.MainManager;
import com.MyClass.Tools.Tool_ObjUtils;

import Games.Fights.FightRole;

import StaticDatas.SData_Strings;

public class FAction_Default {
    public var Role:FightRole;
    public var Name:String;
    public var swf:String;
    public var url:String;
    public var keyborad:String;//0,1,2
    /** 特殊的被击打范围 */
    public var hitArea:Data_AttackArea;
    public var isGod:Boolean=false;
    public var isEndure:Boolean=false;
	
	private var _nowIndex:int;//当前步骤的位置
    protected var isSpdEffectByValue:String;//动作的速度受到某属性影响
    protected var isLoopAni:Boolean=false;//循环动画
    protected var nowCountMSecond:Number;//当前动画的计时，100速度下每次加Config.frameMS
    protected var perMSofFrame:Number;
    protected var isEnd:Boolean=false;
    //过程效果
    protected var soundData:Data_FActionStep_sound;
    //按键记录，判断自身按钮的按下情况
    protected var isListeningKey:Boolean=false;
    protected var keys:*;
    
    public function FAction_Default() {
    }
    public function initF(info:*):void{
        if(info){
            if(info["swf"]!=null)swf=info["swf"];
            if(info["url"]!=null)url=info["url"];
            if(info["被击范围"]!=null)hitArea=new Data_AttackArea(info["被击范围"]);
	        if(info["音效"]!=null){
		        soundData =new Data_FActionStep_sound();
		        soundData.initF(info["音效"]);
	        }
        }
    }
    public function canUse():Boolean{
        return true;
    }
    /** 判断能否被使用物品操作打断 */
    public function checkCanStopByItem():Boolean{
        return false;
    }
    /** 修改角色能否掉落的属性 */
    protected function setCanDrop(can:Boolean):void{
        
    }
    /** 进入该动作前 */
    public function resetF():void{
        nowCountMSecond=0;
        perMSofFrame =1;
        nowIndex=0;
        isEnd=false;
        onCheckAtkSpd();
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
    
    /** 检测落下 **/
    protected function onCheckFallDown():Boolean{
        if(Role.mapRole.nowGroundType==8 || Role.z > 0){
            Role.onWantChangeAction(SData_Strings.ActionName_Jump);
            return true;
        }
        return false;
    }

    public function enterF():void{
        if(isEnd==true){onActEndF();return;}
        if(isListeningKey==true){
            var nowSkillKey:String ="" +Role.controller.isDown_AnySkill;
            if(nowSkillKey==keyborad){
                if(keys["down"]!=true) {
                    keys["down"] = true;
                    keys["click"]=true;
                    keys["time"] = MainManager.getInstence().Time;
                }else{
                    keys["long"] = MainManager.getInstence().Time - keys["time"];
                }
            }else if(nowSkillKey=="-1"){
                if(keys["down"]==true) {
                    keys["down"] = false;
                }
            }else{//按下了其他技能按键
                keys["click"]=false;
                keys["down"] = false;
            }
        }
        nowCountMSecond+=Role.IronCon.getMsEveryFrame() * perMSofFrame;
        while(nowCountMSecond>= Config.frameMS){
            nowCountMSecond-= Config.frameMS;
            nextFrame();
        }
    }

    /** 检测键盘事件，如果在监听则保存记录 */
    protected function checkKeyController():void{
    }
    /** 检测跳 */
    protected function checkKey_Jump():Boolean{
        if(Role.controller && Role.controller.isDown_Jump==true){
            Role.onWantChangeAction(SData_Strings.ActionName_Jump);
            return true;
        }
        return false;
    }
    /** 检测普攻 */
    protected function checkKey_NormalAttack():Boolean{
        if(Role.controller && Role.controller.isDown_NorAttack==true){
            Role.onWantChangeAction(SData_Strings.ActionName_NorAttack);
            return true;
        }
        return false;
    }
    /** 下一帧动作 */
    protected function nextFrame():void{
	    nowIndex++;
        if(Role.mapRole==null || Role.mapRole.Role==null || nowIndex > Role.mapRole.Role.totalFrames-1){
            onAtLastFrame();
            if(isEnd==true){return;}
        }
	    setRoleFrameToIndex();
        onCheckToPlaySound();
        onDoFrameEvent();
    }
    /** 跳转动画到当前帧:默认动作index就是帧 **/
    protected function setRoleFrameToIndex():void{
        if(Role.mapRole.Role!=null && isEnd==false){
            Role.mapRole.Role.currentFrame = nowIndex;
        }
    }
    /** 播放音效 */
    protected function onCheckToPlaySound():void{
        if(soundData && soundData.dicFrame && soundData.dicFrame[nowIndex] != null){
            var soundone:Data_Sound =Data_Sound.getNewData(soundData.dicFrame[nowIndex],Role.x,Role.y);
            MainManager.getInstence().MEM.dispatchF(SData_EventNames.Scene_Sound,soundone);
        }
    }
	public function get nowIndex():int {	return _nowIndex;}
	public function set nowIndex(value:int):void {_nowIndex = value;}
    /** 执行本帧上的操作：攻击、位移、震动、残影…… */
    protected function onDoFrameEvent():void{
        if(isEnd==false){return;}
    }
    /** 动画完成 */
    protected function onAtLastFrame():void{
        if(isLoopAni==true) {
            nowIndex = 0;
        }else{
            onActEndF();
        }
    }
    /** 动作结束 */
    protected function onActEndF():void{
        isEnd=true;
        if(Role.nowAction==this){
            Role.onWantChangeAction(SData_Strings.ActionName_Stand);
        }
    }
    /** 开始监听键盘事件 **/
    protected function startListenKey():void{
        if(isListeningKey==true){return;}
        isListeningKey=true;
        keys=Tool_ObjUtils.getNewObjectFromPool();
    }
    /** 结束 */
    public function breakF():void{
        removeGod();
        removeEndure();
        isListeningKey=false;
        keys=Tool_ObjUtils.destroyF_One(keys);
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
    /** 添加霸体 */
    public function addEndure():void{
        if(isEndure==false){
            isEndure=true;
            Role.isEndure++;
        }
    }
    /** 删除霸体 */
    public function removeEndure():void{
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
