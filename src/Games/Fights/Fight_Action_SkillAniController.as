package Games.Fights
{
	import com.MyClass.Config;
	import com.MyClass.MyView.MyMC;
	import com.MyClass.Tools.Tool_ObjUtils;
	
	import StaticDatas.SData_Faces;
	import StaticDatas.SData_Skills;
	import StaticDatas.SData_Strings;

	public class Fight_Action_SkillAniController
	{
		public var Role:*;
		private var Skill:*;
		private var Flag:String;
		private var MCLight:*;
		private var MCGround:*;
		private var MCLight_AsMyMC:Boolean=false;
		private var MCGround_AsMyMC:Boolean=false;
		private var dicHurted:* =Tool_ObjUtils.getNewObjectFromPool();
		//
		private var startX:int;
		private var startZ:int;
		private var endX:int;
		private var endZ:int;
		private var spdX:Number;
		private var spdZ:Number;
		
		public function Fight_Action_SkillAniController(skill:*)
		{
			Role=skill.Role;
			Skill=skill;
		}
		
		public function resetF():void{
			Flag=null;
			startX=Role.Role_x;
			startZ=Role.Role_z;
			Tool_ObjUtils.getInstance().onClearObj(dicHurted);
			onNextStepF();
		}
		public function onNextStepF():void{
			if(Flag=="结束"){return;}
			if(Flag==null){
				if(Skill.needClose==0 || Role.nowTars==null || Role.nowTars.length==0){
					Flag="接近";
					onNextStepF();
					return;
				}
				else {
					Flag="接近";
					changeRoleMc(SData_Faces.getInstance().Dic[Role.RoleID]["Action"][SData_Strings.ActionName_前进]["url"]);
					if(Role.roleMC)(Role.roleMC as MyMC).loop=true;
					var minpo:int=99;
					for(var i:int=0;i<Role.nowTars.length;i++){
						if(Role.nowTars[i]["Position"] < minpo){
							minpo =Role.nowTars[i]["Position"];
							endX=Role.nowTars[i].Role_x;
							if(Role.camp == 1){
								endX -=(Role.nowTars[i].RoleWidth+ Skill.needClose);
							}else{
								endX +=(Role.nowTars[i].RoleWidth + Skill.needClose);
							}
							endZ=Role.nowTars[i].Role_z;
						}
					}
					var timeF:int =Config.playSpeedTrue * 0.2;
					spdX =(endX - startX) / timeF;
					spdZ =(endZ - startZ) / timeF;
				}
			}
			else if(Flag=="接近"){
				Flag="动作";
				changeRoleMc(Skill.url);
				if(Role.roleMC)(Role.roleMC as MyMC).loop=false;
			}
			else if(Flag=="动作"){
				if(Skill.needClose==0){
					Flag="退回";
					onNextStepF();
					return;
				}
				else {
					Flag="退回";
					changeRoleMc(SData_Faces.getInstance().Dic[Role.RoleID]["Action"][SData_Strings.ActionName_后退]["url"]);
					if(Role.roleMC)(Role.roleMC as MyMC).loop=true;
					endX=startX;
					endZ=startZ;
					timeF =Config.playSpeedTrue * 0.2;
					spdX =(endX - Role.Role_x) / timeF;
					spdZ =(endZ - Role.Role_z) / timeF;
				}
			}
			else if(Flag=="退回"){
				Flag="结束";
				Role.x =startX;
				Role.z =startZ;
				Role.changeRoleFlag(SData_Strings.ActionName_站立);
				if(Skill.TypeAni == SData_Skills.TypeAni_Fly || Skill.TypeAni == SData_Skills.TypeAni_movieClip){
					Skill.onWaiteFlyEndF();
				}else{
					Skill.onAniEndF();
				}
			}
//			trace("Flag="+Flag);
		}
		/** 外部强制结束 */
		public function onEndByFource():void{
			if(Flag!="结束" && Flag!="退回"){
				Flag="动作";
				onNextStepF();
			}
		}
		public function enterF():void{
			if(Flag=="结束"){	return;	}
			if(Flag=="接近" || Flag=="退回"){
				Role.x += spdX;
				if(spdX>0){
					if(Role.Role_x >= endX){
						Role.x =endX;
					}
				}else if(spdX < 0){
					if(Role.Role_x <= endX){
						Role.x =endX;
					}
				}else{
					Role.x =endX;
				}
				Role.z += spdZ;
				if(spdZ>0){
					if(Role.Role_z >= endZ){
						Role.z =endZ;
					}
				}else if(spdZ < 0){
					if(Role.Role_z <= endZ){
						Role.z =endZ;
					}
				}else{
					Role.z =endZ;
				}
				if(Role.Role_x == endX && Role.Role_z == endZ){
					onNextStepF();
				}
				return;
			}
			onEnterRoleMc();
			setMCLightXY();
		}
		
		private function changeRoleMc(url:String):void{
			if(Role.get属性("spine")!=null){
				Role.onChangeroleMC_Spine(url);
			}else{
				if(Skill.swf==null){Skill.swf=SData_Strings.SWF_战斗界面;}
				Role.onChangeRoleMC(Skill.swf,url);
			}
		}
		
		private function onEnterRoleMc():void{
			if(Role.roleMC){
				var lastFrame:int =(Role.roleMC as MyMC).currentFrame;
				if((Role.roleMC as MyMC).isComplete()){
					if(Skill.Arr_AtkFrame==null){
						Skill.checkAtkF();
					}else{
						for(var i:int=lastFrame;i<=(Role.roleMC as MyMC).totalFrames;i++){//spine动画有可能最后播放不完
							if(Skill.Arr_AtkFrame.indexOf(i)!=-1 && dicHurted[i]!=true){
								dicHurted[i]=true;
								Skill.checkAtkF();
								if(Skill.isBreak==true){		break;	}
							}
						}
					}
					onNextStepF();
					return;
				}
				(Role.roleMC as MyMC).enterPlayF();
				var nowFrame:int =(Role.roleMC as MyMC).currentFrame;
				setMCLightFrame(nowFrame);
				if(Skill.Arr_AtkFrame!=null){
					while(lastFrame < nowFrame){
						if(Skill.Arr_AtkFrame.indexOf(lastFrame)!=-1 && dicHurted[lastFrame]!=true){
							dicHurted[lastFrame]=true;
							Skill.checkAtkF();
							if(Skill.isBreak==true){
								onNextStepF();
								return;
							}
						}
						lastFrame++;
					}
				}
			}else{//没有动画
				if(Skill.Arr_AtkFrame==null){
					Skill.checkAtkF();
				}else{
					for(i=0;i<Skill.Arr_AtkFrame.length;i++){
						Skill.checkAtkF();
						if(Skill.isBreak==true){break;}
					}
				}
				onNextStepF();
			}
		}
		
		//---------------------------------------------------------------------------
		private function setMCLightFrame(f:int):void{
			if(MCLight){
				if(MCLight_AsMyMC==false){
					if(f >= MCLight.totalFrames){return;}
					MCLight.gotoAndStop(f);
				}
				else{
					(MCLight as MyMC).nextFrame();
				}
			}
			setMCGroundFrame(f);
		}
		private function setMCGroundFrame(f:int):void{
			if(MCGround){
				if(MCGround_AsMyMC==false){
					if(f >= MCGround.totalFrames){return;}
					MCGround.gotoAndStop(f);
				}
				else{
					if(MCGround.currentFrame >= MCGround.totalFrames-1){
						MCGround=Tool_ObjUtils.getInstance().destroyF_One(MCGround);
					}
					else{
						(MCGround as MyMC).nextFrame();
					}
				}
			}
		}
		private function setMCLightXY():void{
			if(MCLight){
				MCLight.x	= Role.Role_x;
				MCLight.y	= -Role.Role_y+Role.Role_z;
			}
			setMCGroundXY();
		}
		private function setMCGroundXY():void{
			if(MCGround){
				MCGround.x=Role.Role_x;
				MCGround.y=Role.Role_z;
			}
		}
		
		
		public function destroyF():void{
			dicHurted=Tool_ObjUtils.getInstance().destroyF_One(dicHurted);
		}
	}
}