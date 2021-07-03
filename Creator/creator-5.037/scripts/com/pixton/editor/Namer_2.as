package com.pixton.editor
{
   import com.pixton.character.BodyPart;
   import com.pixton.character.BodyParts;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   
   public class Namer extends MovieClip
   {
      
      private static const DISABLED:Boolean = true;
      
      private static const ITEM_PADDING:Number = 2;
       
      
      public var inputText:InputText;
      
      private var target:Object;
      
      private var editorMode:uint;
      
      private var items:Array;
      
      public function Namer()
      {
         super();
         this.reset();
      }
      
      private function reset() : void
      {
         var _loc1_:NamerItem = null;
         this.inputText.visible = false;
         visible = false;
         if(this.items != null)
         {
            for each(_loc1_ in this.items)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
      }
      
      public function updatePosition() : void
      {
         visible = true;
      }
      
      function setTarget(param1:uint, param2:Object = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:NamerItem = null;
         var _loc7_:uint = 0;
         var _loc8_:Array = null;
         var _loc9_:BodyPart = null;
         if(DISABLED)
         {
            return;
         }
         if(this.target == param2 && this.editorMode == param1)
         {
            return;
         }
         this.target = param2;
         this.editorMode = param1;
         if(param2 == null)
         {
            this.reset();
         }
         else
         {
            this.updatePosition();
            if(param2 is Character)
            {
               _loc3_ = Character(param2).getName();
               if(_loc3_ == Character.defaultName)
               {
                  this.inputText.text = L.text("type-here");
               }
               else
               {
                  this.inputText.text = Character(param2).getName();
               }
               this.items = [];
               _loc4_ = 0;
               _loc5_ = this.inputText.y + this.inputText.height + ITEM_PADDING;
               switch(param1)
               {
                  case Editor.MODE_LOOKS:
                     _loc7_ = BodyParts.LOOKS;
                     break;
                  case Editor.MODE_COLORS:
                     _loc7_ = BodyParts.COLORS;
                     break;
                  case Editor.MODE_SCALE:
                     _loc7_ = BodyParts.SCALABLE;
                     break;
                  default:
                     _loc7_ = BodyParts.ALL;
               }
               _loc8_ = Character(param2).bodyParts.getParts(_loc7_,true);
               for each(_loc9_ in _loc8_)
               {
                  (_loc6_ = new NamerItem()).label = _loc9_.getTargetName();
                  _loc6_.x = _loc4_;
                  _loc6_.y = _loc5_;
                  this.addChild(_loc6_);
                  _loc5_ += _loc6_.height + ITEM_PADDING;
                  this.items.push(_loc6_);
               }
            }
         }
      }
      
      public function set renamable(param1:Boolean) : void
      {
         if(this.target is Character)
         {
            this.inputText.setActive(!Utils.SCREEN_CAPTURE_MODE,this.onName,this.onKey,Character.defaultName,!param1);
         }
         else
         {
            this.inputText.setActive(param1 && !Utils.SCREEN_CAPTURE_MODE,this.onName,this.onKey,Character.defaultName);
         }
      }
      
      private function onKey(param1:KeyboardEvent) : void
      {
      }
      
      private function onName(param1:Event) : void
      {
         if(this.target is Character)
         {
            Character(this.target).setName(this.inputText.text);
         }
      }
      
      public function setColor(param1:Array) : void
      {
      }
   }
}
