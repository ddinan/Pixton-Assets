package com.pixton.editor
{
   public final class FeatureTrial
   {
      
      public static const CHARACTER_STRETCH:uint = 1;
      
      public static const PROP_GROUPING:uint = 2;
      
      public static const IMAGE_UPLOADS:uint = 3;
      
      public static const BROWSE_PHOTOS:uint = 4;
      
      public static const SAVE_POSES:uint = 5;
      
      public static const BLUR:uint = 7;
      
      public static const EXTRA_FONTS:uint = 8;
      
      public static const ADVANCED_MODE:uint = 9;
      
      public static const GLOW:uint = 10;
      
      public static const TEAM_COMICS:uint = 50;
      
      public static const ANIMATION:uint = 51;
      
      public static const COMMUNITY:int = -1;
      
      public static const POSING:int = -2;
      
      public static const PRESET_BKGDS:uint = 60;
      
      public static const PRESET_CHARS:uint = 61;
      
      private static var allowedFeatures:Array;
       
      
      public function FeatureTrial()
      {
         super();
      }
      
      public static function setData(param1:Object) : void
      {
         if(param1.trial != null)
         {
            allowedFeatures = param1.trial;
         }
      }
      
      public static function can(param1:uint) : Boolean
      {
         if(Globals.isFullVersion() || param1 == CHARACTER_STRETCH || param1 == GLOW || param1 == BROWSE_PHOTOS)
         {
            return true;
         }
         return false;
      }
   }
}
