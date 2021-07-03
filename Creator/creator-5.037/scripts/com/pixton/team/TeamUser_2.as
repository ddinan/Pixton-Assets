package com.pixton.team
{
   public final class TeamUser
   {
      
      public static var map:Object;
      
      public static var num:uint = 1;
       
      
      public function TeamUser()
      {
         super();
      }
      
      public static function getInfo(param1:uint, param2:String) : *
      {
         if(map[param1.toString()] == null || map[param1.toString()][param2] == null)
         {
            return null;
         }
         return map[param1.toString()][param2];
      }
   }
}
