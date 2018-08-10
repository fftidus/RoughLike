package Games.Fights {
import com.MyClass.Config;
import com.MyClass.Tools.Tool_Function;

import laya.utils.Handler;

/**
 * 战斗角色的韧性控制，韧性决定霸体状态能否被破除，在霸体下被攻击则减少，被破霸体后直接恢复，或无伤状态xx秒后开始缓慢恢复。
 * */
public class FightRole_ToughnessControl {
    private static const secStartRecover:int =10;//10秒没被攻击就开始恢复
    private static const spdRecover:Number=0.2;//每秒恢复百分比
    private var Role:FightRole;
    private var _nowToughness:int;
    private var isEntering:int=0;
    private var countSec:int;
    private var countFrame:int;
    public function FightRole_ToughnessControl(role:FightRole) {
        Role=role;
	    resetToughness();
    }
    /** 重置韧性 **/
    public function resetToughness():void{
        _nowToughness=Role.valueFight.toughness;
        stopCountTime();
    }
    /** 消耗韧性，如果可以打断技能则返回true，否则返回false **/
    public function costToughness(num:int):Boolean{
        if(Role.isEndure==true) {
            _nowToughness -= num;
            if (_nowToughness <= 0) {//破霸体
                resetToughness();
                return true;
            }else {
                startCountTime();
                return false;
            }
        }
        return true;
    }
    
    /** 计时，超过30秒则恢复 **/
    private function enterF():void{
        if(isEntering==0){return;}
        if(isEntering==1) {
	        if (countFrame++ >= Config.playSpeedTrue) {
		        countFrame = 0;
		        countSec++;
		        if (countSec >= secStartRecover) {
			        isEntering = 2;
		        }
	        }
        }
        else{
            _nowToughness += Tool_Function.onForceConvertType(spdRecover * Role.valueFight.toughness);
            if(_nowToughness>=Role.valueFight.toughness){
                stopCountTime();
            }
        }
    }
    
    /** 开始计时 */
    private function startCountTime():void{
	    countSec=0;
	    countFrame=0;
        if(isEntering!=0){
            return;
        }
        isEntering=1;
        Role.registEnterHandler("韧性",Handler.create(this,enterF,null,false));
    }
    /** 结束计时 */
    private function stopCountTime():void{
        if(isEntering != 0){
            isEntering=0;
            Role.removeEnterHandler("韧性");
        }
    }


    public function destroyF():void{
        Role=null;
    }
}
}
