package Games.Fights {
import Games.Controller_Scene;
import Games.Models.RoleModel;
import Games.Scene;

import StaticDatas.SData_RolesInfo;

import StaticDatas.SData_Strings;

import com.MyClass.Config;

import com.MyClass.MainManagerOne;

import com.MyClass.Tools.Tool_ObjUtils;

import laya.utils.Handler;

import starling.display.Sprite;

/**
 * 战斗场景+UI
 * */
public class ViewClass_FightMain extends Sprite{
    private var scene:Scene;
    private var UI:Fight_UI;
    private var mainRoleModel:RoleModel;
    private var conMainRole:RoleController_Player;
    private var mmo:MainManagerOne=new MainManagerOne();
    
    public function ViewClass_FightMain(info:*) {
        mainRoleModel=new RoleModel();
        mainRoleModel.initRoleInfo(SData_RolesInfo.getInstance().Dic[1]);
        var source:Array=[
            [SData_Strings.SWF_FightUI,"swf"]
        ];
        mainRoleModel.addSource(source,null);
        Controller_Scene.getInstance().onNewScene(1,1,0,source,Handler.create(this,initF));
    }
    private function initF():void{
        scene=Controller_Scene.getInstance().nowScene;
        var mainRole:FightRole=new FightRole(mainRoleModel);
        scene.DicRoles.addMainRole(mainRole);
        mainRole.mapRole.y=600;
        conMainRole=new RoleController_Player(mainRole);
        UI=new Fight_UI(this);
        if(Config.OS=="WIN"){
            UI.conMove.setMKM(conMainRole.mkm);
        }
        conMainRole.btnCon =UI.conMove;
    }
    
    
    public function destroyF():void{
        Tool_ObjUtils.destroyDisplayObj(this);
        scene=Tool_ObjUtils.destroyF_One(scene);
        UI=Tool_ObjUtils.destroyF_One(UI);
        mmo=Tool_ObjUtils.destroyF_One(mmo);
        mainRoleModel=Tool_ObjUtils.destroyF_One(mainRoleModel);
        conMainRole=Tool_ObjUtils.destroyF_One(conMainRole);
    }
}
}
