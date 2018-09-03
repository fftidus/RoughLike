package Games.Datas {
/**
 * 飞行类数据
 * */
public class Data_FlyObj {
    //初始
    public var startX:int;
    public var startY:int;
    public var startZ:int;
    //移动
    public var spdX:Number=0;
    public var spdY:Number=0;
    public var spdZ:Number=0;
    public var aX:*;
    public var aY:*;
    public var aZ:*;
    public var moveType:int;//0不移动，1匀变速，2匀变速不回弹，3乒乓，4环绕xy轴
    //动画
    public var swf:String;
    public var url:String;
    public var urlG:String;
    public var loop:Boolean;
    public var labels:*;//帧标签，null表示单个动画。否则key =初始化、循环、消失
    /** 持续毫秒，0表示动画播放完一次 */
    public var timeLast:int;
    /** 攻击 **/
    public var dataAtk:Data_Attack;
    /** 多段攻击间隔：当dataAtk中帧为null时候 **/
    public var hit_attackTime:int;
    /** 多段攻击清理一次命中的时间 **/
    public var hit_clearMultiTime:int;
    /** 命中后生成新飞行物体 **/
    public var afterHit_newFly:Data_FlyObj;
    
    
    public function Data_FlyObj() {
    }
    
    
    public function destroyF():void{
    }
}
}
