package com.pixton.editor
{
   import com.pixton.preloader.Status;
   import flash.events.Event;
   import flash.text.Font;
   
   public final class Fonts
   {
      
      private static const styleNames:Array = ["","b","i"];
      
      public static var unicode:Array = ["_sans","_serif"];
      
      public static var defaultFont:int;
      
      public static var busy:Boolean = false;
      
      public static var useHTML:Boolean = false;
      
      public static var minFontID:int;
      
      public static var maxFontID:int;
      
      public static var allowChoice:Boolean = false;
      
      public static var addPadding:Boolean = false;
      
      private static var files:Array;
      
      private static var currentIndex:int;
      
      private static var loadingIDs:Array;
      
      private static var includeUnicode:uint;
      
      private static var fontInfo:Object;
      
      private static var missingStyles:Boolean = false;
       
      
      public function Fonts()
      {
         super();
      }
      
      public static function init(param1:Object) : void
      {
         files = param1.fnt;
         defaultFont = param1.def;
         includeUnicode = param1.uni;
         useHTML = param1.html;
         allowChoice = param1.allowChoice;
         minFontID = param1.minFontID;
         maxFontID = param1.maxFontID;
         addPadding = param1.addPadding;
         if(includeUnicode == 0)
         {
            unicode = [];
         }
         fontInfo = param1.fontData;
      }
      
      public static function loadInit(param1:Array, param2:Function) : void
      {
         var IDs:Array = param1;
         var onCompleteAll:Function = param2;
         if(getFileNumOffset() == 1)
         {
            Utils.load(files[0],function(param1:Event):*
            {
               loadAll(IDs,onCompleteAll);
            },true,File.BUCKET_ASSET);
         }
         else
         {
            loadAll(IDs,onCompleteAll);
         }
      }
      
      public static function loadAll(param1:Array, param2:Function, param3:Boolean = false) : void
      {
         var _loc4_:uint = 0;
         busy = true;
         var _loc5_:uint = param1.length;
         var _loc6_:uint = getNum();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param1[_loc4_] >= _loc6_)
            {
               param1.splice(_loc4_--,1);
            }
            _loc4_++;
         }
         if(param1.length > 0)
         {
            if(param3)
            {
               defaultFont = param1[0];
            }
            loadingIDs = param1;
            currentIndex = 0;
            loadNext(param2);
         }
         else
         {
            busy = false;
            param2();
         }
      }
      
      private static function loadNext(param1:Function) : void
      {
         var onCompleteAll:Function = param1;
         if(currentIndex < loadingIDs.length)
         {
            loadFont(loadingIDs[currentIndex++],function():void
            {
               loadNext(onCompleteAll);
            });
         }
         else
         {
            if(Main.isInitComplete())
            {
               Status.reset();
            }
            busy = false;
            onCompleteAll();
         }
      }
      
      public static function loadFont(param1:int, param2:Function) : void
      {
         var id:int = param1;
         var onComplete:Function = param2;
         if(Status.busy && onComplete == null)
         {
            return;
         }
         if(id >= getNum())
         {
            id = defaultFont;
         }
         if(id < 0 || id > maxFontID)
         {
            onComplete();
         }
         else if(fontExists(id))
         {
            onComplete();
         }
         else
         {
            if(Main.isInitComplete())
            {
               Status.setMessage(L.text("please-wait"),true);
            }
            Utils.load(files[id + getFileNumOffset()],function(param1:Event):void
            {
               onLoadFont(id,onComplete);
            },false,File.BUCKET_ASSET);
         }
      }
      
      private static function onLoadFont(param1:int, param2:Function) : void
      {
         var _loc4_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:Class = null;
         var _loc3_:Object = {};
         var _loc5_:uint = styleNames.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.toString() + styleNames[_loc4_];
            if((_loc7_ = getFontClass(_loc6_)) != null)
            {
               Font.registerFont(_loc7_);
            }
            _loc4_++;
         }
         if(param2 != null)
         {
            param2();
         }
      }
      
      public static function allExist(param1:Array) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = param1.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(!fontExists(param1[_loc2_]))
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      private static function fontExists(param1:int) : Boolean
      {
         if(param1 < 0)
         {
            return true;
         }
         return Utils.hasDefinition("com.pixton.fonts.Font" + param1);
      }
      
      private static function getFontClass(param1:String) : Class
      {
         return Utils.getDefinition("com.pixton.fonts.Font" + param1) as Class;
      }
      
      public static function getFontInfo(param1:int) : Object
      {
         var _loc3_:uint = 0;
         var _loc4_:Class = null;
         var _loc5_:Class = null;
         var _loc8_:Boolean = false;
         if(!fontExists(param1))
         {
            param1 = defaultFont;
         }
         var _loc2_:String = param1.toString();
         var _loc6_:uint = styleNames.length;
         var _loc7_:Boolean = true;
         if(fontInfo == null)
         {
            fontInfo = {};
         }
         if(fontInfo[_loc2_] == null)
         {
            fontInfo[_loc2_] = {};
         }
         if(fontInfo[_loc2_]["instance0"] == null)
         {
            if(param1 < 0)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc6_)
               {
                  fontInfo[_loc2_]["instance" + _loc3_] = {"fontName":unicode[-param1 - 1]};
                  fontInfo[_loc2_]["bold" + _loc3_] = _loc3_ == 1;
                  fontInfo[_loc2_]["italic" + _loc3_] = _loc3_ == 2;
                  _loc3_++;
               }
            }
            else
            {
               _loc3_ = 0;
               while(_loc3_ < _loc6_)
               {
                  _loc4_ = getFontClass(param1.toString() + styleNames[_loc3_]);
                  fontInfo[_loc2_]["class" + _loc3_] = _loc4_;
                  if(_loc4_ == null)
                  {
                     _loc4_ = _loc5_;
                     _loc8_ = true;
                  }
                  else
                  {
                     _loc7_ = false;
                     _loc8_ = false;
                  }
                  fontInfo[_loc2_]["instance" + _loc3_] = new _loc4_();
                  fontInfo[_loc2_]["bold" + _loc3_] = _loc8_ && _loc3_ == 1;
                  fontInfo[_loc2_]["italic" + _loc3_] = _loc8_ && _loc3_ == 2;
                  _loc5_ = _loc4_;
                  _loc3_++;
               }
               if(_loc7_)
               {
                  missingStyles = true;
               }
            }
         }
         return fontInfo[_loc2_];
      }
      
      private static function getFileNumOffset() : uint
      {
         return files.length > 1 || includeUnicode > 0 && files.length > 0 ? uint(1) : uint(0);
      }
      
      public static function getNum() : int
      {
         return files.length + includeUnicode - getFileNumOffset();
      }
      
      public static function hasStyles() : Boolean
      {
         return !(missingStyles && includeUnicode == 0);
      }
      
      public static function fontHasStyles(param1:int) : Boolean
      {
         var _loc2_:uint = 0;
         if(param1 < 0)
         {
            return true;
         }
         var _loc3_:uint = styleNames.length;
         var _loc4_:String = param1.toString();
         var _loc5_:Object = getFontInfo(param1);
         var _loc6_:Boolean = true;
         _loc2_ = 1;
         while(_loc2_ < _loc3_)
         {
            if(_loc5_["class" + _loc2_] != null)
            {
               _loc6_ = false;
               break;
            }
            _loc2_++;
         }
         return !_loc6_;
      }
   }
}
