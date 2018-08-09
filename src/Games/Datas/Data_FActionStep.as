package Games.Datas {
import com.MyClass.Tools.Tool_Function;

/**
 * 动作的步骤数据
 * */
public class Data_FActionStep {
    public var swf:String;
    public var url:String;
    /** 帧，null表示全部执行 */
    public var Arr_frame:Array;
    /** 循环，true则不会自动进入下一步，需要外部触发 */
    public var loop:Boolean=false;
	/** 特殊的碰撞范围 */
    public var hitArea:Data_AttackArea;
    /** 攻击 */
    public var attackInfo:Array;
    /** 飞行物体 */
    public var flyobjInfo:Array;
    /** 是否霸体 */
    public var isEndure:Boolean;
    /** 霸体帧：isEndure为true时，霸体帧为null表示一直霸体 */
    public var frameEndure:Array;
    /** 是否无敌 */
    public var isGod:Boolean;
    /** 无敌帧：isGod为true时，无敌帧为null表示一直无敌 */
    public var frameGod:Array;
    /** 位移 */
    public var moveInfo:*;
    /** 音效 */
    public var soundInfo:Data_FActionStep_sound;
    /** 残影 */
    public var ghostInfo:*;
    /** 震动 */
    public var shockInfo:*;
    
    public function Data_FActionStep(dic:*) {
        if(dic){
            swf =dic["swf"];
            url =dic["url"];
            Arr_frame=dic["帧"];
            loop=dic["循环"]==true;
            if(dic["被击范围"]!=null)hitArea=new Data_AttackArea(dic["被击范围"]);
            if(dic["伤害"]!=null){//[{范围，伤害……}]
                attackInfo=[];
                if(Tool_Function.isTypeOf(dic["伤害"],Array)==true) {
                    for (var i:int = 0; i < dic["伤害"].length; i++) {
                        attackInfo[i] = new Data_Attack(dic["伤害"][i]);
                    }
                }else{
                    attackInfo[0] = new Data_Attack(dic["伤害"]);
                }
            }
            isEndure=dic["霸体"]==true;
            frameEndure=dic["霸体帧"];
            isGod=dic["无敌"]==true;
            frameGod=dic["无敌帧"];
            moveInfo=dic["位移"];
            if(dic["音效"]){
                soundInfo=new Data_FActionStep_sound();
                soundInfo.initF(dic["音效"]);
            }
            ghostInfo=dic["残影"];
            shockInfo=dic["震动"];
//            if(dic["飞行"]!=null)flyobjInfo
        }
    }
}
}
