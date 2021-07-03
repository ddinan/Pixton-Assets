package com.pixton.editor
{
   public final class SpellCheck
   {
      
      static const TIMEOUT:uint = 1000;
      
      static const COLOR:uint = 16711680;
      
      static var isAvailable:Boolean = false;
       
      
      public function SpellCheck()
      {
         super();
      }
      
      static function checkSpelling(param1:String, param2:Function) : void
      {
         Utils.remote("checkSpelling",{
            "t":param1,
            "lang":L.id
         },param2);
      }
      
      static function ignore(param1:String) : void
      {
         Utils.remote("ignoreSpelling",{
            "w":param1,
            "lang":L.id
         });
      }
      
      static function add(param1:String) : void
      {
         Utils.remote("addSpelling",{
            "w":param1,
            "lang":L.id
         });
      }
      
      static function onCorrect(param1:String, param2:String) : void
      {
         Utils.remote("onCorrectSpelling",{
            "w1":param1,
            "w2":param2,
            "lang":L.id
         });
      }
   }
}
