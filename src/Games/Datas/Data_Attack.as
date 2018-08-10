package Games.Datas {
import com.MyClass.Tools.Tool_Function;

/**
 * 攻击范围、伤害数值数据
 * */
public class Data_Attack {
    /** 作用帧 */
    public var Frames:Array;
    /** 多段攻击 */
    public var isMultihit:Boolean;
    /** 所有范围 */
    public var Areas:Array;
    /** 攻击类型：用于计算硬直：钝击、穿刺、斩击、魔法 */
    public var attackType:String;
    /** 攻击属性：用于计算伤害：主（武器属性），物火雷冰土风光暗无 */
    public var attributes:String;
    /** 静态攻击力：String对应技能中的属性名，int表示不会改变的固定值 */
    public var atk:*;
    /** 百分比攻击力：String对应技能中的属性名，int表示不会改变的固定值 */
    public var atkPer:*;
    /** 削韧系数：最终削韧值为招式系数* 武器属性 */
    public var perCostToughness:*;
    /** 攻击中心点：用来判断是否背后攻击。null表示无法造成背后攻击，其他数字表示来源相对坐标 */
    public var middlePo:*;
    
    /** 攻击硬直 */
    public var hit_CostIron:int;
    /** 攻击击飞：力度 */
    public var hit_awayPower:int;
    /** 攻击击飞：方向：上下左右落:12345 */
    public var hit_awayDirect:int;
    /** 攻击浮空：力度 */
    public var hit_upPower:int;
    
    /** 命中光效：swf,url, 固定坐标:bool(为true表示只有一个相对施法者的光效),x,y */
    public var hitLight:*;
    /** 命中音效 */
    public var hitSound:*;
    
    
    public function Data_Attack(dic:*) {
        Frames=dic["帧"];
        isMultihit=dic["多段"]==true;
        Areas=[];
        if(Tool_Function.isTypeOf(dic["范围"],Array)==true) {
            for (var i:int = 0; i < dic["范围"].length; i++) {
                Areas[i] = new Data_AttackArea(dic["范围"][i]);
            }
        }else{
            Areas[0]=new Data_AttackArea(dic["范围"]);
        }
        attackType=dic["类型"];
        attributes=dic["属性"];
        atk=dic["固定攻击"];
        atkPer=dic["比例攻击"];
        perCostToughness=dic["削韧"];
        middlePo=dic["中心"];
        hit_CostIron=dic["硬直"];
        hit_awayPower=dic["击飞力度"];
        hit_awayDirect=dic["击飞方向"];
        hit_upPower=dic["浮空力度."];
        hitLight=dic["光效"];
        hitSound=dic["音效"];
    }
}
}
