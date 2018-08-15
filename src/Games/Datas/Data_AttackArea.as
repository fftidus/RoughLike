package Games.Datas {
import Games.Fights.FightRole;

import com.MyClass.Tools.Tool_ArrayUtils;

/**
 * 攻击范围：由点构成多边形决定x轴z轴，y轴由参数决定
 * 被击范围：仅使用多边形points
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
        if(dic is Array){//x，y，z
            points=[-dic[0],0    ,-dic[0],dic[2],   dic[0],dic[2]    ,dic[0],0];
            yUp=dic[1];
            yDown=dic[1];
        }else if(dic){
            canHitGound =dic["对地"]==true;
            yUp=dic["上"];
            yDown=dic["下"];
            points=dic["点"];
        }
    }
    /** 获得翻转后的点 */
    public function getScaleXPoints():Array{
        var arr:Array =Tool_ArrayUtils.getNewArrayFromPool();
        for(var i:int=0;i<points.length;i+=2){
            arr[i]=-points[i];
            arr[i+1]=points[i+1];
        }
        return arr;
    }

    /** 获得相对于某角色的新的多边形点数组 **/
    public function getLocalPoints(fr:FightRole,_x:Number,_y:Number):Array{
        var out:Array =Tool_ArrayUtils.getNewArrayFromPool();
        for(var i:int=0;i<points.length;i+=2){
            if(fr.nowDirection==1) {//朝左
                out[i] = -points[i] + _x;
            }else{
                out[i] = points[i] + _x;
            }
            out[i+1]=points[i+1]+_y;
        }
        return out;
    }
}
}
