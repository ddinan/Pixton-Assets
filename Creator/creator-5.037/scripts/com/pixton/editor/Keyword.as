package com.pixton.editor
{
   public final class Keyword
   {
      
      public static var correctionDict:Object;
      
      private static var accentMap:Object = {
         "á":"a",
         "à":"a",
         "â":"a",
         "ä":"a",
         "é":"e",
         "è":"e",
         "ê":"e",
         "ë":"e",
         "í":"i",
         "ì":"i",
         "î":"i",
         "ï":"i",
         "ó":"o",
         "ò":"o",
         "ô":"o",
         "ö":"o",
         "ú":"u",
         "ù":"u",
         "û":"u",
         "ü":"u",
         "ñ":"n"
      };
      
      private static const MIN_WORD_LENGTH:uint = 3;
       
      
      public function Keyword()
      {
         super();
      }
      
      public static function init(param1:Object) : void
      {
         if(param1.sdict)
         {
            correctionDict = param1.sdict;
         }
      }
      
      public static function prepareUserSearch(param1:String, param2:Boolean = false) : Array
      {
         var _loc3_:* = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         param1 = param1.toLowerCase();
         if(param2)
         {
            return param1.split(/ +/);
         }
         for(_loc3_ in accentMap)
         {
            param1 = param1.replace(_loc3_,accentMap[_loc3_]);
         }
         param1 = param1.replace(/[^\w\s ]/g,"");
         _loc4_ = param1.split(/ +/);
         _loc5_ = [];
         _loc6_ = _loc4_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            if(correctionDict && correctionDict[_loc4_[_loc7_]])
            {
               _loc4_[_loc7_] = correctionDict[_loc4_[_loc7_]];
            }
            if(_loc4_[_loc7_].length >= MIN_WORD_LENGTH)
            {
               _loc5_.push(_loc4_[_loc7_]);
            }
            _loc7_++;
         }
         return _loc5_;
      }
      
      public static function matches(param1:String, param2:Array) : Boolean
      {
         var _loc3_:uint = 0;
         if(param1 == null)
         {
            return false;
         }
         var _loc4_:uint = param2.length;
         var _loc5_:Boolean = true;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1.indexOf(param2[_loc3_]) == -1)
            {
               _loc5_ = false;
               break;
            }
            _loc3_++;
         }
         return _loc5_;
      }
   }
}
