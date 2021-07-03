package com.pixton.editor
{
   import com.pixton.team.Team;
   import com.pixton.team.TeamUser;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public final class PanelInfo extends MovieClip
   {
       
      
      public var contents:MovieClip;
      
      private var txtTime:TextField;
      
      private var locked:MovieClip;
      
      private var txtUser:TextField;
      
      private var _userID:uint = 0;
      
      private var _state:uint;
      
      public function PanelInfo()
      {
         super();
         this.txtTime = this.contents.txtTime;
         this.locked = this.contents.locked;
         this.txtUser = this.contents.txtUser;
         this.setState(Team.PANEL_UNLOCKED);
      }
      
      function setState(param1:uint) : void
      {
         this.txtTime.visible = false;
         this.locked.visible = param1 == Team.PANEL_LOCKED;
         this._state = param1;
      }
      
      function setUser(param1:Object) : void
      {
         var _loc2_:uint = param1.u;
         if(_loc2_ == this._userID)
         {
            return;
         }
         this._userID = _loc2_;
         var _loc3_:String = TeamUser.getInfo(_loc2_,"n");
         if(_loc3_ != null)
         {
            this.txtUser.text = _loc3_;
         }
         else if(param1.n != null)
         {
            this.txtUser.text = param1.n;
         }
         else
         {
            this.txtUser.text = "";
         }
         this.setState(Team.PANEL_LOCKED);
      }
   }
}
