package com.pixton.editor
{
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.setInterval;
   
   public final class ActivityLog
   {
      
      public static var enabled:Boolean = false;
      
      public static var interval:Number = 30;
      
      private static var _instance:ActivityLog;
       
      
      private var _activity:Boolean;
      
      public function ActivityLog()
      {
         super();
         if(!_instance)
         {
            _instance = this;
            return;
         }
         throw Error("This is a singleton, use getInstance(), do not call the constructor directly.");
      }
      
      public static function getInstance() : ActivityLog
      {
         return !!_instance ? _instance : new ActivityLog();
      }
      
      public function init(param1:Stage) : void
      {
         if(!enabled)
         {
            return;
         }
         Utils.addListener(param1,MouseEvent.MOUSE_MOVE,this.onActivity);
         Utils.addListener(param1,KeyboardEvent.KEY_DOWN,this.onActivity);
         setInterval(this.onInterval,interval * 1000);
      }
      
      private function onActivity(param1:*) : void
      {
         if(!Main.displayManager.GET(Editor.self,DisplayManager.P_VIS))
         {
            return;
         }
         this._activity = true;
      }
      
      private function onInterval() : void
      {
         if(this._activity)
         {
            Utils.remote("onActivity",{
               "key":Comic.self.getKey(),
               "user":Main.userID,
               "interval":interval
            });
         }
         this._activity = false;
      }
   }
}
