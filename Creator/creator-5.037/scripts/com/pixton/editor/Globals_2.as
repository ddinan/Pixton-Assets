package com.pixton.editor
{
   public final class Globals
   {
      
      public static var IDE:Boolean = false;
      
      public static const MAX_CLICK_RADIUS:Number = 5;
      
      public static const HIGHLIGHTING_ALPHA:Number = 0.5;
      
      public static const HUMAN:uint = 0;
      
      public static const CARNIVORE:uint = 1;
      
      public static const HORSE:uint = 2;
      
      public static const BIRD:uint = 3;
      
      public static const DINOSAUR:uint = 4;
      
      public static const REDNOSE:uint = 99;
      
      public static const SOUTH_PARK:uint = 100;
      
      public static const GAIA:uint = 150;
      
      public static const MARVEL:uint = 160;
      
      public static const MARVEL2:uint = 161;
      
      public static const NICK_SB:uint = 170;
      
      public static const HOT_DOG:uint = 200;
      
      public static const KINECTION:uint = 210;
      
      public static const FLIP_X:String = "X";
      
      public static const FLIP_Y:String = "Y";
      
      public static const FLIP_Z:String = "Z";
      
      public static const SKIN_COLOR:uint = 0;
      
      public static const HAIR_COLOR:uint = 1;
      
      public static const LIP_COLOR:uint = 2;
      
      public static const SHIRT_COLOR:uint = 3;
      
      public static const PANT_COLOR:uint = 4;
      
      public static const SHOE_COLOR:uint = 5;
      
      public static const HAT_COLOR:uint = 6;
      
      public static const GLOVE_COLOR:uint = 7;
      
      public static const ACCESSORY_COLOR:uint = 8;
      
      public static const IRIS_COLOR:uint = 9;
      
      public static const EYELID_COLOR:uint = 10;
      
      public static const SOCK_COLOR:uint = 11;
      
      public static const BELT_COLOR:uint = 12;
      
      public static const EARRING_COLOR:uint = 13;
      
      public static const EYEWEAR_COLOR:uint = 14;
      
      public static const BUCKLE_COLOR:uint = 15;
      
      public static const CAPE_COLOR:uint = 16;
      
      public static const MAX_COLOR:uint = 16;
      
      public static const POSES:uint = 100;
      
      public static const FACES:uint = 101;
      
      public static const CHARACTERS:uint = 102;
      
      public static const EXPRESSION:uint = 103;
      
      public static const LOOKS:uint = 104;
      
      public static const COLORS:uint = 105;
      
      public static const OUTFITS:uint = 106;
      
      public static const BODY_PHOTOS:uint = 107;
      
      public static const PROPS:uint = 108;
      
      public static const ASSET_COLOR:uint = 109;
      
      public static const TEXT_COLOR:uint = 110;
      
      public static const BKGD_COLOR:uint = 111;
      
      public static const BKGD_GRADIENT:uint = 112;
      
      public static const ALPHA:uint = 113;
      
      public static const PROPSETS:uint = 114;
      
      public static const FONT_FACE:uint = 115;
      
      public static const FONT_SIZE:uint = 116;
      
      public static const PADDING:uint = 117;
      
      public static const LEADING:uint = 118;
      
      public static const CORNER_RADIUS:uint = 119;
      
      public static const EFFECTS:uint = 120;
      
      public static const SEQUENCES:uint = 121;
      
      public static const BUBBLE_SHAPE:uint = 122;
      
      public static const BUBBLE_SPIKE:uint = 123;
      
      public static const BUBBLE_BORDER:uint = 124;
      
      public static const BUBBLE_BORDER_COLOR:uint = 125;
      
      public static const BLUR_AMOUNT:uint = 126;
      
      public static const BLUR_ANGLE:uint = 127;
      
      public static const BORDER_SHAPE:uint = 128;
      
      public static const BORDER_SIZE:uint = 129;
      
      public static const BORDER_COLOR:uint = 130;
      
      public static const PANEL_SATURATION:uint = 131;
      
      public static const PANEL_BRIGHTNESS:uint = 132;
      
      public static const PANEL_CONTRAST:uint = 133;
      
      public static const PHOTOS:uint = 134;
      
      public static const DESIGNER:uint = 135;
      
      public static const LINE_ALPHA:uint = 136;
      
      public static const GLOW_AMOUNT:uint = 137;
      
      private static var _fullVersion:Boolean = false;
      
      private static var _isAdmin:Boolean = false;
       
      
      public function Globals()
      {
         super();
      }
      
      public static function setFullVersion(param1:Boolean) : void
      {
         _fullVersion = param1;
      }
      
      public static function isFullVersion() : Boolean
      {
         return _fullVersion;
      }
      
      public static function setAdmin(param1:Boolean) : void
      {
         _isAdmin = param1;
      }
      
      public static function isAdmin() : Boolean
      {
         return _isAdmin;
      }
      
      public static function isLocked(param1:Object) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         if(param1.plusFree_bool == 1 && isFullVersion() || param1.platformFree_bool == 1 && Platform.exists())
         {
            return false;
         }
         return true;
      }
   }
}
