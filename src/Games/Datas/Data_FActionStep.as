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
    
    public function Data_FActionStep() {
    }
}
}
