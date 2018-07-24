package Games.Datas {
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
    /** 攻击 */
    public var attackInfo:*;
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
    public var soundInfo:*;
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
            if(dic["伤害"]!=null){
                
            }else{
                attackInfo=null;
            }
        }
    }
}
}
