package com.pixton.editor
{
   public final class Credit
   {
       
      
      public function Credit()
      {
         super();
      }
      
      static function purchaseFeature(param1:Object, param2:Function = null, param3:PickerItem = null, param4:Boolean = true) : void
      {
         param1.key = Comic.key;
         delete param1.created_date;
         param2(false);
      }
   }
}
