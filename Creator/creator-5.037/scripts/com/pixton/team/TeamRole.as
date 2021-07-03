package com.pixton.team
{
   import com.pixton.editor.L;
   
   public final class TeamRole
   {
      
      public static const PANELS:uint = 10;
      
      public static const CHARACTERS:uint = 11;
      
      public static const PROPS:uint = 21;
      
      public static const DIALOG:uint = 31;
      
      public static var approved:Boolean = true;
      
      private static var roleData:Object;
       
      
      public function TeamRole()
      {
         super();
      }
      
      public static function setData(param1:Object, param2:Boolean = true) : Boolean
      {
         var _loc4_:* = null;
         var _loc3_:Boolean = false;
         if(param2)
         {
            roleData = param1.roles;
            _loc3_ = true;
         }
         else
         {
            for(_loc4_ in param1.roles)
            {
               if(roleData[_loc4_] != param1.roles[_loc4_])
               {
                  roleData[_loc4_] = param1.roles[_loc4_];
                  _loc3_ = true;
               }
            }
         }
         return _loc3_;
      }
      
      public static function hasRoles() : Boolean
      {
         return roleData != null;
      }
      
      public static function can(param1:uint) : Boolean
      {
         if(!approved)
         {
            return false;
         }
         if(param1 != DIALOG && L.multiLangID > 0)
         {
            return false;
         }
         return roleData == null || parseInt(roleData["f" + param1]) == 1;
      }
   }
}
