package com.pixton.editor
{
   public class PhotoSet
   {
      
      private static var photoSets:Object;
      
      private static var buttons:Array;
       
      
      public function PhotoSet()
      {
         super();
      }
      
      static function setData(param1:Object) : void
      {
         photoSets = param1.phs;
      }
      
      static function isVisible(param1:String) : Boolean
      {
         var _loc2_:* = null;
         for(_loc2_ in photoSets)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      static function getButtons() : Array
      {
         var _loc1_:* = null;
         var _loc2_:Object = null;
         buttons = [];
         for(_loc1_ in photoSets)
         {
            _loc2_ = photoSets[_loc1_];
            if(_loc2_ != null)
            {
               buttons.push(new PhotoSetButton(parseInt(_loc1_),_loc2_["n"],parseInt(_loc2_["icon"])));
            }
         }
         return buttons;
      }
   }
}
