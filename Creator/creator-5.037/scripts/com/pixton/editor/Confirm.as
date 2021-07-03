package com.pixton.editor
{
   public final class Confirm
   {
      
      private static var onAffirm:Function;
       
      
      public function Confirm()
      {
         super();
      }
      
      public static function alert(param1:String, param2:Boolean = true, param3:* = "") : void
      {
         open("Pixton.editorAlert",{
            "message":param1,
            "isKey":param2,
            "arg":param3
         });
      }
      
      public static function open(param1:String, param2:* = null, param3:Function = null, param4:* = null) : void
      {
         Confirm.onAffirm = param3;
         Main.self.enable(false);
         if(Utils.javascript(param1,param2,param4))
         {
            onClose(true);
         }
      }
      
      public static function onClose(param1:*) : void
      {
         Main.self.enable(true);
         if(onAffirm != null)
         {
            onAffirm(param1);
            onAffirm = null;
         }
      }
   }
}
