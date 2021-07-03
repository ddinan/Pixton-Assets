package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public final class Select extends MovieClip
   {
      
      static var MIN_WIDTH:Number = 0;
      
      static var FIXED_HEIGHT:Number = 36;
       
      
      public var value:int = -1;
      
      public var arrow:MovieClip;
      
      public var optionContainer:MovieClip;
      
      public var options:Array;
      
      private var map:Object;
      
      public function Select()
      {
         super();
         visible = false;
         Utils.addListener(this,MouseEvent.ROLL_OVER,this.onOver);
         Utils.addListener(this,MouseEvent.ROLL_OUT,this.onOut);
      }
      
      function updateColor() : void
      {
         Utils.setColor(this.arrow,Palette.WHITE);
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         var _loc2_:SelectOption = null;
         for each(_loc2_ in this.options)
         {
            _loc2_.visible = true;
         }
         this.rearrange();
      }
      
      private function onOut(param1:MouseEvent = null) : void
      {
         var _loc2_:SelectOption = null;
         for each(_loc2_ in this.options)
         {
            _loc2_.visible = _loc2_.selected;
         }
         this.rearrange();
      }
      
      private function rearrange() : void
      {
         var _loc1_:uint = 0;
         var _loc4_:SelectOption = null;
         var _loc2_:uint = this.options.length;
         var _loc3_:int = -1;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(SelectOption(this.options[_loc1_]).selected)
            {
               _loc3_ = _loc1_;
               break;
            }
            _loc1_++;
         }
         if(_loc3_ > -1)
         {
            _loc4_ = this.options[_loc3_];
            this.options.splice(_loc3_,1);
            this.options.unshift(_loc4_);
         }
         var _loc5_:Number = 0;
         for each(_loc4_ in this.options)
         {
            _loc4_.y = _loc5_;
            if(_loc4_.visible)
            {
               _loc5_ += _loc4_.getHeight();
            }
         }
      }
      
      public function setData(param1:Array = null) : void
      {
         var _loc2_:Array = null;
         var _loc3_:SelectOption = null;
         for each(_loc3_ in this.options)
         {
            _loc3_.setHandler(null);
            this.optionContainer.removeChild(_loc3_);
         }
         this.options = [];
         this.map = {};
         if(param1 != null)
         {
            for each(_loc2_ in param1)
            {
               _loc3_ = new SelectOption();
               _loc3_.setHandler(this.selectOption);
               this.optionContainer.addChild(_loc3_);
               _loc3_.setData(_loc2_[1],_loc2_[0]);
               _loc3_.updateColor();
               this.map[_loc2_[1].toString()] = _loc3_;
               this.options.push(_loc3_);
            }
         }
         this.arrow.visible = param1.length > 1;
         this.value = -1;
         visible = this.options.length > 1;
      }
      
      public function setWidth(param1:uint) : void
      {
         var _loc2_:SelectOption = null;
         for each(_loc2_ in this.options)
         {
            _loc2_.fixedWidth = param1;
            _loc2_.label = _loc2_.label;
            _loc2_.x = Math.floor(_loc2_.getWidth() * 0.5);
         }
         this.arrow.x = param1 - 8;
      }
      
      function setSelected(param1:int = -1) : void
      {
         this.selectOption(null,param1);
      }
      
      function deselect() : void
      {
         this.selectOption(null,-2);
      }
      
      private function selectOption(param1:SelectOption = null, param2:int = -1) : void
      {
         var _loc4_:SelectOption = null;
         var _loc3_:int = this.value;
         var _loc5_:Boolean = false;
         if(param1 == null)
         {
            if(param2 == -1)
            {
               _loc4_ = this.options[0];
            }
            else if(param2 != -2)
            {
               _loc4_ = this.map[param2.toString()];
            }
         }
         else
         {
            _loc4_ = param1;
         }
         if(_loc4_ != null)
         {
            if(_loc4_.value == this.value)
            {
               _loc5_ = true;
            }
            else
            {
               this.value = _loc4_.value;
            }
         }
         else
         {
            this.value = param2;
         }
         if(_loc5_)
         {
            return;
         }
         if(_loc3_ >= 0)
         {
            SelectOption(this.map[_loc3_.toString()]).selected = false;
         }
         if(_loc4_ != null)
         {
            _loc4_.selected = true;
         }
         if(param1 != null)
         {
            dispatchEvent(new PixtonEvent(PixtonEvent.CLICK,this,this.value));
         }
         this.onOut();
      }
   }
}
