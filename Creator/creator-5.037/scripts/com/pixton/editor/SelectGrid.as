package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public final class SelectGrid extends MovieClip
   {
      
      private static const MAX_HEIGHT:Number = 326;
       
      
      public var value:int = -1;
      
      private var options:Array;
      
      private var map:Object;
      
      private var maxX:Number = 0;
      
      private var maxY:Number = 0;
      
      public function SelectGrid()
      {
         super();
         visible = false;
      }
      
      private function rearrange() : void
      {
         var _loc3_:SelectGridOption = null;
         this.maxX = 0;
         this.maxY = 0;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         for each(_loc3_ in this.options)
         {
            _loc3_.x = _loc1_;
            _loc3_.y = _loc2_;
            this.maxX = _loc3_.x + _loc3_.getWidth();
            this.maxY = Math.max(this.maxY,_loc3_.y + _loc3_.getHeight());
            _loc2_ += _loc3_.getHeight() + 1;
            if(_loc2_ + _loc3_.getHeight() > MAX_HEIGHT)
            {
               _loc1_ += _loc3_.getWidth() + 1;
               _loc2_ = 0;
            }
         }
      }
      
      public function setData(param1:Array = null) : void
      {
         var _loc2_:Array = null;
         var _loc3_:SelectGridOption = null;
         for each(_loc3_ in this.options)
         {
            Utils.removeListener(_loc3_,MouseEvent.CLICK,this.selectOption);
            _loc3_.cleanUp();
            removeChild(_loc3_);
         }
         this.options = [];
         this.map = {};
         if(param1 != null)
         {
            for each(_loc2_ in param1)
            {
               _loc3_ = new SelectGridOption();
               Utils.addListener(_loc3_,MouseEvent.CLICK,this.selectOption);
               addChild(_loc3_);
               _loc3_.setData(_loc2_[1],_loc2_[0]);
               this.map[_loc2_[1].toString()] = _loc3_;
               this.options.push(_loc3_);
            }
         }
         this.value = -1;
         this.rearrange();
         visible = !Template.isActive();
      }
      
      function setSelected(param1:int = -1) : void
      {
         this.selectOption(null,param1);
      }
      
      function deselect() : void
      {
         this.selectOption(null,-2);
      }
      
      private function selectOption(param1:MouseEvent = null, param2:int = -1) : void
      {
         var _loc4_:SelectGridOption = null;
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
            _loc4_ = param1.currentTarget as SelectGridOption;
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
            SelectGridOption(this.map[_loc3_.toString()]).selected = false;
         }
         if(_loc4_ != null)
         {
            _loc4_.selected = true;
         }
         if(param1 != null)
         {
            dispatchEvent(new PixtonEvent(PixtonEvent.CLICK,this,this.value));
         }
      }
      
      function getWidth() : Number
      {
         return this.maxX;
      }
      
      function getHeight() : Number
      {
         return this.maxY;
      }
   }
}
