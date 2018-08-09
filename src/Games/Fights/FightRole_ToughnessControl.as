package Games.Fights {
import laya.utils.Handler;

/**
 * 战斗角色的韧性控制，韧性决定霸体状态能否被破除，在霸体下被攻击则减少，被破霸体后直接恢复，或无伤状态xx秒后开始缓慢恢复。
 * */
public class FightRole_ToughnessControl {
    private static const secStartRecover:int =10;//10秒没被攻击就开始恢复
    private static const spdRecover:Number=0.2;//每秒恢复百分比
    private var Role:FightRole;
    private var _nowToughness:int;
    private var isEntering:Boolean=false;
    public function FightRole_ToughnessControl(role:FightRole) {
        Role=role;
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
            if (_nowToughness <= 0) {
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
    public function enterF():void{
        if(isEntering==false){return;}
    }
    
    /** 开始计时 */
    private function startCountTime():void{
        if(isEntering==true){return;}
        isEntering=true;
        Role.registEnterHandler("韧性",Handler.create(this,enterF,null,false));
    }
    /** 结束计时 */
    private function stopCountTime():void{
        if(isEntering==true){
            isEntering=false;
            Role.removeEnterHandler("韧性");
        }
    }


    private function get nowToughness():int {
        return _nowToughness;
    }
    public function destroyF():void{
        Role=null;
    }
}
}
