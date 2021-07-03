package com.pixton.editor
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   
   public final class Pixton
   {
      
      public static const TARGET_EDITOR:uint = 0;
      
      public static const TARGET_CHARACTER:uint = 1;
      
      public static const TARGET_DIALOG:uint = 2;
      
      public static const TARGET_PROP:uint = 3;
      
      public static const MODE_DEFAULT:uint = 0;
      
      public static const MODE_EXPR:uint = 1;
      
      public static const MODE_LOOKS:uint = 2;
      
      public static const FULLSIZE:Number = 1;
      
      public static var THUMBNAIL:Number = 435 / 900;
      
      public static const THUMBNAIL_PROP:Number = 0.2;
      
      public static const MAX_BITMAP_AREA:uint = 8294400;
      
      public static const MAX_BITMAP_LENGTH:uint = 2880;
      
      public static const CLICK_TIME:Number = 500;
      
      public static const MIN_Z:Number = 0.2;
      
      public static const MAX_Z:Number = 1;
      
      public static const LEFT_SIDE:uint = 0;
      
      public static const RIGHT_SIDE:uint = 1;
      
      public static const TOP_SIDE:uint = 2;
      
      public static const BOTTOM_SIDE:uint = 3;
      
      public static const POOL_ALL:uint = 0;
      
      public static const POOL_CATEGORIES:uint = 1;
      
      public static const POOL_PACK:uint = 2;
      
      public static const POOL_MINE:uint = 3;
      
      public static const POOL_COMMUNITY:uint = 4;
      
      public static const POOL_PRESET:uint = 5;
      
      public static const POOL_LOCKED:uint = 6;
      
      public static const POOL_NEW:uint = 7;
      
      public static const POOL_PRESET_OUTFIT:uint = 8;
      
      public static const POOL_PRESET_2:uint = 9;
       
      
      public function Pixton()
      {
         super();
      }
      
      public static function getEditorImage(param1:Editor, param2:Number, param3:Panel = null, param4:Boolean = true, param5:Boolean = false, param6:Asset = null) : *
      {
         var _loc8_:Bitmap = null;
         var _loc7_:BitmapData = renderEditorImage(param1,param2,param6);
         if(param3 != null)
         {
            if(_loc7_ != null)
            {
               _loc8_ = new Bitmap(_loc7_);
               param3.setContent(_loc8_);
            }
            else
            {
               param3.setContent(null);
            }
         }
         if(param5 || _loc7_ == null)
         {
            return _loc7_;
         }
         return Utils.encodedImage(_loc7_,param2,Utils.IMAGE_PNG,param4);
      }
      
      public static function getImage(param1:MovieClip, param2:Number, param3:Number, param4:Boolean = false) : *
      {
         var _loc5_:Boolean = true;
         var _loc6_:ColorTransform = param1.transform.colorTransform;
         Utils.setColor(param1);
         var _loc7_:BitmapData = Utils.renderImage(param1,1,null,null,param2,param3);
         param1.transform.colorTransform = _loc6_;
         if(param4)
         {
            return _loc7_;
         }
         return encodeBMD(_loc7_);
      }
      
      public static function encodeBMD(param1:BitmapData, param2:Number = 1) : Object
      {
         return Utils.encodedImage(param1,param2,Utils.IMAGE_PNG,true);
      }
      
      public static function renderEditorImage(param1:Editor, param2:Number, param3:Asset = null) : BitmapData
      {
         if(!Main.doFullCapture())
         {
            param1.onRenderStart(param2,param3);
         }
         var _loc4_:BitmapData = Utils.renderImage(!!Main.doFullCapture() ? Main.self : param1,param2,param1.contents,!!Main.doFullCapture() ? param1.getFullRect() : param1.bkgd);
         if(!Main.doFullCapture())
         {
            param1.onRenderEnd(param2,param3);
         }
         return _loc4_;
      }
      
      public static function getTargetType(param1:Object) : int
      {
         if(param1 is Editor)
         {
            return TARGET_EDITOR;
         }
         if(param1 is Character)
         {
            return TARGET_CHARACTER;
         }
         if(param1 is Prop)
         {
            return TARGET_PROP;
         }
         if(param1 is Dialog)
         {
            return TARGET_DIALOG;
         }
         return -1;
      }
   }
}
