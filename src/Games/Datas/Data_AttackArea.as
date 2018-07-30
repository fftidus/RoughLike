package Games.Datas {
/**
 * 攻击范围：由点构成多边形决定x轴z轴，y轴由参数决定
 * */
public class Data_AttackArea {
    /** 能否攻击倒地状态的敌人 */
    public var canHitGound:Boolean;
    /** 向上范围 */
    public var yUp:int;
    /** 向下范围 */
    public var yDown:int;
    /** 多边形：xz轴，[x1,y1,x2,y2,……] */
    public var points:Array;
    
    public function Data_AttackArea(dic:*) {
        if(dic){
            canHitGound =dic["对地"]==true;
            yUp=dic["上"];
            yDown=dic["下"];
            points=dic["点"];
        }
    }
}

}
