package Games.Fights {
import com.MyClass.Config;
import com.MyClass.Tools.Tool_Function;

/**
 * 硬直控制器：硬直含义=对方动作需要停顿多少毫秒
 * */
public class FightRole_IronControl {
    private var Role:FightRole;
    private var msDefault:Number =Config.frameMS;//每帧耗时，根据硬直可变化
    public var nowNum:int=0;
    
    public function FightRole_IronControl(fr:FightRole) {
        Role=fr;
    }
    /** 归零硬直 */
    public function onClearF():void{
        nowNum = 0;
    }
    /** 修改硬直：需要减去角色的硬直抗性 */
    public function costIron(num:int):void{
        num -= Tool_Function.onForceConvertType(num * Role.valueFight.iron * 0.01);
        if(num>nowNum) {
            nowNum = num;
        }
    }
    
    /** 每帧实际消耗时间，有硬直则减去硬直额外时间 */
    public function getMsEveryFrame():Number{
        if(nowNum > 0){
            if(msDefault>=nowNum){
                nowNum=0;
                return msDefault - nowNum;
            }else{
                nowNum -=msDefault;
                return 0;
            }
        }
        return msDefault;
    }
    
    public function destroyF():void{
        Role=null;
    }
}
}
