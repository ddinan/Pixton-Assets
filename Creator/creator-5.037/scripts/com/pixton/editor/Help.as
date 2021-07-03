package com.pixton.editor
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public final class Help
   {
      
      private static var tab:HelpTab;
       
      
      public function Help()
      {
         super();
      }
      
      public static function init(param1:HelpTab) : void
      {
         Help.tab = param1;
         hide();
      }
      
      public static function show(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Object = null, param7:PickerItem = null) : void
      {
         var _loc8_:Point = null;
         var _loc10_:Rectangle = null;
         tab.setText(param1,param3);
         if(param6 != null || param7 != null)
         {
            tab.setPricing(param6,param7);
         }
         if(param2 is MenuItem)
         {
            param2 = param2.bkgd;
         }
         var _loc9_:Rectangle = param2.getBounds(tab.parent);
         tab.rotation = 0;
         if(param3)
         {
            _loc8_ = new Point(_loc9_.x,_loc9_.y + _loc9_.height * 0.5);
         }
         else
         {
            _loc8_ = new Point(_loc9_.x + _loc9_.width,_loc9_.y + _loc9_.height * 0.5);
         }
         if(MovieClip(Editor.self.contents).contains(param2 as DisplayObject))
         {
            _loc10_ = Editor.self.bkgd.getBounds(tab.parent);
            if(param5)
            {
               if(_loc8_.x > _loc10_.x + _loc10_.width)
               {
                  _loc8_.x = _loc10_.x + _loc10_.width - (!!param3 ? 0 : tab.width);
               }
               else if(_loc8_.x < _loc10_.x)
               {
                  _loc8_.x = _loc10_.x + (!!param3 ? tab.width : 0);
               }
            }
            if(_loc8_.y > _loc10_.y + _loc10_.height)
            {
               _loc8_.y = _loc10_.y + _loc10_.height - tab.height;
            }
            else if(_loc8_.y < _loc10_.y)
            {
               _loc8_.y = _loc10_.y + tab.height;
            }
         }
         tab.x = Math.round(_loc8_.x);
         tab.y = Math.round(_loc8_.y);
         if(param3 && _loc8_.x - tab.width < Main.getLeftX())
         {
            if(param5)
            {
               tab.x = Main.getLeftX() + tab.width;
            }
            else
            {
               show(param1,param2,!param3,param4,true);
            }
         }
         else if(!param3 && _loc8_.x + tab.width > Main.getRightX())
         {
            if(param5)
            {
               tab.x = Main.getRightX();
            }
            else
            {
               show(param1,param2,!param3,param4,true);
            }
         }
         if(!param5)
         {
            tab.visible = (param1 != "" || param6 != null) && (AppSettings.getActive(AppSettings.TOOLTIPS) || param4) && !tab.isEmpty();
         }
      }
      
      public static function hide() : void
      {
         tab.visible = false;
      }
   }
}
