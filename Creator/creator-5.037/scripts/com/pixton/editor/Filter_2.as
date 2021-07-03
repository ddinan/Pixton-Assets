package com.pixton.editor
{
   public final class Filter
   {
      
      private static const WORD_EDGE:String = " ,.;:!?\\n\\r\\t\\[\\]«»¿¡*…“”‘’`{}\\(\\)\'\"-";
      
      private static var regExp:RegExp;
      
      private static var regExpTest:RegExp;
      
      private static var grawlixChars:Array = ["@","#","$","%"];
      
      private static var isActive:Boolean = false;
       
      
      public function Filter()
      {
         super();
      }
      
      public static function init(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc6_:* = null;
         var _loc5_:Array = [];
         if(param1.bw != null && param1.bw.length > 0)
         {
            for each(_loc4_ in param1.bw)
            {
               _loc5_.push(_loc4_.w);
            }
            if(_loc5_.length > 0)
            {
               _loc6_ = "[" + WORD_EDGE + "](" + _loc5_.join("|").replace(/\.\*/g,"[^" + WORD_EDGE + "]*") + ")[" + WORD_EDGE + "]";
               regExp = new RegExp(_loc6_,"gi");
               regExpTest = new RegExp(_loc6_,"i");
            }
            isActive = true;
         }
      }
      
      public static function filter(param1:String) : String
      {
         var _loc2_:uint = 0;
         if(!isActive || !regExp)
         {
            return param1;
         }
         var _loc3_:* = " " + param1 + " ";
         _loc2_ = 0;
         while(regExpTest.test(_loc3_) && _loc2_ < 100)
         {
            _loc3_ = _loc3_.replace(regExp,makeGrawlix);
            _loc2_++;
         }
         return _loc3_.substr(1,_loc3_.length - 2);
      }
      
      private static function makeGrawlix(param1:String, param2:String, ... rest) : String
      {
         Utils.shuffle(grawlixChars);
         var _loc4_:String = grawlixChars.slice(0,param2.length).join("");
         return param1.replace(param2,_loc4_);
      }
   }
}
