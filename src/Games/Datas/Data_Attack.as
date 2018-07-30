package Games.Datas {
import com.MyClass.Tools.Tool_Function;

/**
 * 攻击范围、伤害数值数据
 * */
public class Data_Attack {
    /** 作用帧 */
    public var Frames:Array;
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
    
    /** 攻击作用-硬直 */
    public var hit_CostIron:*;
    /** 攻击作用-上：y轴 */
    public var hit_up:*;
    /** 攻击作用-下：y轴 */
    public var hit_down:*;
    /** 攻击作用-左 */
    public var hit_left:*;
    /** 攻击作用-右 */
    public var hit_right:*;
    /** 攻击作用-浮空 */
    public var hit_sky:*;
    /** 攻击作用-下落 */
    public var hit_ground:*;
    
    /** 命中光效：swf,url, 固定坐标:bool(为true表示只有一个相对施法者的光效),x,y */
    public var hitLight:*;
    /** 命中音效 */
    public var hitSound:*;
    
    
    public function Data_Attack(dic:*) {
        Frames=dic["帧"];
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
        hit_up=dic["上"];
        hit_down=dic["下"];
        hit_left=dic["左"];
        hit_right=dic["右"];
        hit_sky=dic["升"];
        hit_ground=dic["落"];
        hitLight=dic["光效"];
        hitSound=dic["音效"];
    }
}
}
