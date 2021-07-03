package com.pixton.editor
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.setTimeout;
   
   public final class Guide
   {
      
      public static var isActive:Boolean = false;
      
      private static var _clickDelay:uint = 0;
      
      private static var _clickTarget:DisplayObject;
      
      private static var _currentTargetType:Class;
      
      private static var _currentAction:String;
      
      private static var _currentTargetID:String;
      
      private static var _nextOnStateChange:Boolean = false;
      
      private static var _nextOnSelection:Boolean = false;
      
      private static var _nextOnDeselection:Boolean = false;
      
      private static var _nextOnAttach:Boolean = false;
      
      private static var _nextOnDetach:Boolean = false;
      
      private static var _nextOnSearch:Boolean = false;
      
      private static var _nextOnLoad:Boolean = false;
      
      private static var _hasHighlight:Boolean = false;
       
      
      public function Guide()
      {
         super();
      }
      
      public static function getTarget(param1:Object) : Object
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:DisplayObject = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc10_:Array = null;
         var _loc11_:Rectangle = null;
         var _loc12_:Rectangle = null;
         var _loc13_:Rectangle = null;
         if(_currentTargetID == "title" && (!param1 || param1.force !== true) && (Main.self.team.txtTitle.text == "" || Main.self.team.txtTitle.text == L.text("untitled")))
         {
            return false;
         }
         isActive = false;
         _currentAction = null;
         _currentTargetType = null;
         _currentTargetID = null;
         _nextOnStateChange = _nextOnSelection = _nextOnDeselection = _nextOnAttach = _nextOnDetach = _nextOnSearch = _nextOnLoad = _hasHighlight = false;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:String = param1.target;
         if(param1 == null || _loc2_ == null)
         {
            return null;
         }
         var _loc3_:Array = _loc2_.split("|");
         if(_clickTarget)
         {
            Utils.removeListener(_clickTarget,MouseEvent.CLICK,onTargetClick);
         }
         _clickTarget = null;
         _currentAction = param1.action;
         if(_currentAction == "deselect" && Editor.self.currentTarget == null)
         {
            return true;
         }
         _nextOnStateChange = _currentAction == "change";
         _nextOnSelection = _currentAction == "select";
         _nextOnDeselection = _currentAction == "deselect";
         _nextOnAttach = _currentAction == "attach";
         _nextOnDetach = _currentAction == "detach";
         _nextOnSearch = _currentAction == "search";
         _nextOnLoad = _currentAction == "load";
         _clickDelay = param1.delay != null ? uint(param1.delay) : uint(50);
         _currentTargetID = _loc3_[0].substr(2);
         var _loc6_:String = _loc3_[1];
         var _loc9_:Boolean = false;
         if(param1.pool)
         {
            _loc7_ = (_loc10_ = param1.pool.split("|"))[0];
            if((_loc8_ = _loc10_[1]) == "presets")
            {
               if(_loc7_ == "characters")
               {
                  Character.lastPool = Pixton.POOL_PRESET;
               }
               else if(_loc7_ == "backgrounds")
               {
                  PropSet.lastPool = Pixton.POOL_PRESET;
               }
            }
         }
         switch(_currentTargetID)
         {
            case "title":
               _loc4_ = Main.self.team.txtTitle;
               break;
            case "panel":
               _clickTarget = Panel(Comic.self.panels[parseInt(_loc6_) - 1]);
               if(!_clickTarget)
               {
                  if(parseInt(_loc6_) > 1)
                  {
                     _loc4_ = Main.self.btnNew;
                  }
               }
               else
               {
                  _loc4_ = Panel(Comic.self.panels[parseInt(_loc6_) - 1]).contents;
               }
               break;
            case "mnu":
               _loc4_ = Editor.self["mnu" + _loc6_] as DisplayObject;
               break;
            case "selection":
               _loc4_ = Editor.self.currentTarget as DisplayObject;
               _loc9_ = true;
               break;
            case "asset":
               if(_loc6_ == "dialog")
               {
                  _currentTargetType = Dialog;
               }
               else if(_loc6_ == "character")
               {
                  _currentTargetType = Character;
               }
               else
               {
                  _currentTargetType = Prop;
               }
               _loc4_ = Editor.self.getAsset(_currentTargetType);
               _loc9_ = true;
               break;
            case "selector":
               _loc4_ = Editor.self.selector[_loc6_];
               break;
            case "picker":
               switch(_loc6_)
               {
                  case "select":
                     _loc4_ = Picker.bkgd;
                     _clickTarget = Picker.select;
                     _loc5_ = Picker.select && Picker.select.options && Picker.select.options.length > 0 ? SelectOption(Picker.select.options[0]).bkgdOn : null;
                     break;
                  case "search":
                     _loc4_ = Picker.navigation;
                     _clickTarget = Picker.btnSearch;
                     break;
                  case "item":
                     _loc4_ = Picker.bkgd;
                     _clickTarget = Picker.target.stage;
               }
         }
         if(_loc4_ && _loc4_.stage && isVisible(_loc4_))
         {
            if(!_clickTarget)
            {
               _clickTarget = _loc4_;
            }
            if(_currentAction == "click")
            {
               Utils.addListener(_clickTarget,MouseEvent.CLICK,onTargetClick);
            }
            _loc11_ = _loc4_.getBounds(_loc4_.stage);
            if(_loc9_ && Editor.self.bkgd.stage)
            {
               _loc13_ = Editor.self.bkgd.getBounds(Editor.self.bkgd.stage);
               _loc11_ = _loc11_.intersection(_loc13_);
            }
            if(!_loc5_)
            {
               _loc12_ = _loc11_;
            }
            else
            {
               _loc12_ = _loc5_.getBounds(_loc5_.stage);
            }
            _hasHighlight = _loc12_ != null;
            isActive = true;
            return {
               "rect":{
                  "x":_loc11_.x,
                  "y":_loc11_.y,
                  "w":_loc11_.width,
                  "h":_loc11_.height,
                  "ox":-Main.getLeftX()
               },
               "highlight":{
                  "x":_loc12_.x,
                  "y":_loc12_.y,
                  "w":_loc12_.width,
                  "h":_loc12_.height,
                  "ox":-Main.getLeftX()
               }
            };
         }
         if(_currentTargetID == "panel")
         {
            return true;
         }
         return null;
      }
      
      public static function isBlockingClickAway() : Boolean
      {
         return isActive && _hasHighlight && !_nextOnDeselection && _currentAction != null && _currentAction != "load";
      }
      
      public static function isBlockingSelection(param1:Object) : Boolean
      {
         return isActive && _currentTargetType && !(param1 is _currentTargetType);
      }
      
      public static function onStateChange() : void
      {
         if(!isActive || !_nextOnStateChange)
         {
            return;
         }
         _nextOnStateChange = false;
         onTargetClick();
      }
      
      public static function onSelection() : void
      {
         if(!isActive || !_nextOnSelection)
         {
            return;
         }
         _nextOnSelection = false;
         onTargetClick();
      }
      
      public static function onDeselection() : void
      {
         if(!isActive || !_nextOnDeselection)
         {
            return;
         }
         _nextOnDeselection = false;
         onTargetClick();
      }
      
      public static function onAttach() : void
      {
         if(!isActive || !_nextOnAttach)
         {
            return;
         }
         _nextOnAttach = false;
         onTargetClick();
      }
      
      public static function onDetach() : void
      {
         if(!isActive || !_nextOnDetach)
         {
            return;
         }
         _nextOnDetach = false;
         onTargetClick();
      }
      
      public static function onSearch() : void
      {
         if(!isActive || !_nextOnSearch)
         {
            return;
         }
         _nextOnSearch = false;
         onTargetClick();
      }
      
      public static function onChangeText() : void
      {
         if(!isActive)
         {
            return;
         }
         Utils.javascript("Pixton.tour.refresh");
      }
      
      public static function onLoad() : void
      {
         if(!isActive || !_nextOnLoad)
         {
            return;
         }
         _nextOnLoad = false;
         onTargetClick();
      }
      
      private static function nextStep() : void
      {
         Utils.javascript("Pixton.tour.advance");
      }
      
      private static function onTargetClick(param1:MouseEvent = null) : void
      {
         setTimeout(nextStep,_clickDelay);
         if(param1)
         {
            Utils.removeListener(param1.currentTarget,MouseEvent.CLICK,onTargetClick);
         }
      }
      
      private static function isVisible(param1:DisplayObject) : Boolean
      {
         if(!param1.visible)
         {
            return false;
         }
         if(param1.parent && param1.parent == param1.stage)
         {
            return true;
         }
         return isVisible(param1.parent);
      }
   }
}
