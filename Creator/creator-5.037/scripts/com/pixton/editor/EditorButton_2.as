package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class EditorButton extends MovieClip
   {
      
      private static const ICON_PADDING:Number = 4;
       
      
      public var txtLabel:TextField;
      
      public var bkgdOff:MovieClip;
      
      public var bkgdOn:MovieClip;
      
      public var fill2:MovieClip;
      
      public var checkOn:MovieClip;
      
      public var checkOff:MovieClip;
      
      public var icon:MovieClip;
      
      public var hasLabel:Boolean = false;
      
      public var fixedWidth:Number = 0;
      
      public var labelContainer:MovieClip;
      
      public var iconContainer:MovieClip;
      
      private var handler:Function;
      
      private var passThis:Boolean;
      
      private var tf:TextFormat;
      
      private var enabledState:Boolean;
      
      private var isPriority:Boolean = false;
      
      private var _checked:Boolean = false;
      
      public function EditorButton()
      {
         var _loc1_:MovieClip = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super();
         if(this.iconContainer != null)
         {
            _loc3_ = this.iconContainer.numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc1_ = this.iconContainer.getChildAt(_loc2_) as MovieClip;
               _loc1_.visible = false;
               _loc2_++;
            }
            removeChild(this.iconContainer);
         }
         if(this.labelContainer != null)
         {
            this.labelContainer.mouseEnabled = false;
            this.labelContainer.mouseChildren = false;
            this.txtLabel = this.labelContainer.txtLabel;
         }
         if(this.txtLabel != null)
         {
            this.tf = new TextFormat();
            this.tf.bold = true;
            this.txtLabel.mouseEnabled = false;
            if(this.bkgdOn != null)
            {
               this.txtLabel.autoSize = TextFieldAutoSize.CENTER;
            }
            else
            {
               this.txtLabel.autoSize = TextFieldAutoSize.LEFT;
            }
         }
         this.enable();
         this.onOut();
      }
      
      private function isCheckbox() : Boolean
      {
         return this.checkOn != null;
      }
      
      function showIcon(param1:String) : void
      {
         if(this.iconContainer.parent == null)
         {
            addChild(this.iconContainer);
         }
         MovieClip(this.iconContainer[param1]).visible = true;
      }
      
      public function makePriority(param1:Boolean = true) : void
      {
         this.isPriority = param1;
         this.updateColor();
      }
      
      public function updateColor() : void
      {
         this.onOut();
         if(this.isCheckbox())
         {
            Utils.setColor(this.checkOn,Palette.colorHot);
         }
         else if(this.bkgdOn.middle)
         {
            Utils.setColor(this.bkgdOn.middle.fill,Palette.colorHot);
            Utils.setColor(this.bkgdOn.left.fill,Palette.colorHot);
            Utils.setColor(this.bkgdOn.right.fill,Palette.colorHot);
            if(this.bkgdOn.middle.line)
            {
               Utils.setColor(this.bkgdOn.middle.line,Palette.colorHot);
               Utils.setColor(this.bkgdOn.left.line,Palette.colorHot);
               Utils.setColor(this.bkgdOn.right.line,Palette.colorHot);
            }
         }
         else
         {
            Utils.setColor(this.bkgdOn.fill,Palette.colorHot);
            if(this.bkgdOn.line)
            {
               Utils.setColor(this.bkgdOn.line,Palette.colorHot);
            }
         }
         if(this.bkgdOff)
         {
            if(this.bkgdOff.middle)
            {
               Utils.setColor(this.bkgdOff.middle.fill,!!this.isPriority ? Palette.colorLink : Palette.colorBkgd);
               Utils.setColor(this.bkgdOff.left.fill,!!this.isPriority ? Palette.colorLink : Palette.colorBkgd);
               Utils.setColor(this.bkgdOff.right.fill,!!this.isPriority ? Palette.colorLink : Palette.colorBkgd);
               if(this.bkgdOff.middle.line)
               {
                  Utils.setColor(this.bkgdOff.middle.line,!!this.isPriority ? Palette.colorLink : Palette.colorBkgd);
                  Utils.setColor(this.bkgdOff.left.line,!!this.isPriority ? Palette.colorLink : Palette.colorBkgd);
                  Utils.setColor(this.bkgdOff.right.line,!!this.isPriority ? Palette.colorLink : Palette.colorBkgd);
               }
            }
            else
            {
               Utils.setColor(this.bkgdOff.fill,!!this.isPriority ? Palette.colorLink : Palette.colorBkgd);
               if(this.bkgdOff.line)
               {
                  Utils.setColor(this.bkgdOff.line,!!this.isPriority ? Palette.colorLink : Palette.colorBkgd);
               }
            }
         }
         if(this.fill2)
         {
            Utils.setColor(this.fill2,!!this.isPriority ? Palette.colorLink : Palette.colorBkgd);
         }
         if(this.checkOff != null)
         {
            Utils.setColor(this.checkOff.contents,!!this.isPriority ? Palette.colorLink : Palette.colorBkgd);
         }
      }
      
      public function get label() : String
      {
         return this.txtLabel.text;
      }
      
      public function set label(param1:String) : void
      {
         var _loc2_:Number = NaN;
         this.txtLabel.text = param1.replace("&amp;","&");
         this.txtLabel.setTextFormat(this.tf);
         if(this.bkgdOn != null)
         {
            if(this.fixedWidth == 0)
            {
               _loc2_ = this.txtLabel.width;
               if(this.iconContainer != null && this.iconContainer.parent != null)
               {
                  _loc2_ += this.iconContainer.width + ICON_PADDING;
                  this.txtLabel.x = -(this.txtLabel.width - this.iconContainer.width - ICON_PADDING) * 0.5;
                  this.iconContainer.x = Math.round(this.txtLabel.x - this.iconContainer.width - ICON_PADDING);
               }
               else
               {
                  this.txtLabel.x = -this.txtLabel.width * 0.5;
               }
            }
            else
            {
               _loc2_ = this.fixedWidth - this.bkgdOn.right.width - this.bkgdOn.left.width;
            }
            if(this.bkgdOn.middle != null)
            {
               this.bkgdOn.middle.width = _loc2_ + 6;
               this.bkgdOn.right.x = Math.floor(_loc2_ * 0.5);
               this.bkgdOn.left.x = -this.bkgdOn.right.x;
            }
            if(this.bkgdOff != null)
            {
               this.bkgdOff.middle.width = this.bkgdOn.middle.width;
               this.bkgdOff.right.x = this.bkgdOn.right.x;
               this.bkgdOff.left.x = this.bkgdOn.left.x;
            }
         }
         this.hasLabel = param1 != "";
      }
      
      public function setHandler(param1:Function = null, param2:Boolean = true) : void
      {
         if(param1 == null)
         {
            Utils.removeListener(this,MouseEvent.CLICK,this.onClick);
            this.enable(false);
         }
         else
         {
            this.handler = param1;
            this.passThis = param2;
            Utils.addListener(this,MouseEvent.CLICK,this.onClick);
         }
      }
      
      function enable(param1:Boolean = true) : void
      {
         Utils.useHand(this,param1);
         this.enabledState = param1;
         if(param1)
         {
            Utils.addListener(this,MouseEvent.ROLL_OVER,this.onOver);
            Utils.addListener(this,MouseEvent.ROLL_OUT,this.onOut);
         }
         else
         {
            Utils.removeListener(this,MouseEvent.ROLL_OVER,this.onOver);
            Utils.removeListener(this,MouseEvent.ROLL_OUT,this.onOut);
            this.onOut();
         }
      }
      
      function onRemove() : void
      {
         this.enable(false);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(!this.enabledState)
         {
            return;
         }
         if(this.handler != null)
         {
            this.handler(!!this.passThis ? this : param1);
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this.isCheckbox())
         {
            this.checkOn.visible = true;
            this.checkOff.visible = true;
         }
         else if(this.bkgdOn != null)
         {
            if(this.bkgdOff != null)
            {
               this.bkgdOff.visible = false;
            }
            this.bkgdOn.visible = true;
         }
         if(this.txtLabel != null && this.bkgdOn != null)
         {
            this.tf.color = Palette.rgb2hex(Palette.colorBkgd);
            this.txtLabel.setTextFormat(this.tf);
         }
         if(this.icon != null)
         {
            Utils.setColor(this.icon,Palette.colorBkgd);
         }
         if(this.iconContainer != null && this.iconContainer.parent != null)
         {
            Utils.setColor(this.iconContainer,Palette.colorBkgd);
         }
      }
      
      private function onOut(param1:MouseEvent = null) : void
      {
         if(Palette.colorLink == null)
         {
            return;
         }
         if(this.isCheckbox())
         {
            this.checkOn.visible = this._checked;
            this.checkOff.visible = true;
         }
         else if(this.bkgdOn != null)
         {
            if(this.bkgdOff != null)
            {
               this.bkgdOff.visible = true;
            }
            this.bkgdOn.visible = false;
         }
         if(this.txtLabel != null)
         {
            this.tf.color = Palette.rgb2hex(!!this.isPriority ? Palette.colorBkgd : Palette.colorLink);
            this.txtLabel.setTextFormat(this.tf);
         }
         if(this.icon != null)
         {
            Utils.setColor(this.icon,!!this.isPriority ? Palette.colorBkgd : Palette.colorLink);
         }
         if(this.iconContainer != null && this.iconContainer.parent != null)
         {
            Utils.setColor(this.iconContainer,!!this.isPriority ? Palette.colorBkgd : Palette.colorLink);
         }
      }
      
      public function getWidth() : Number
      {
         if(this.isCheckbox())
         {
            return width;
         }
         if(this.bkgdOn != null)
         {
            return this.bkgdOn.width;
         }
         return this.txtLabel.width;
      }
      
      public function getHeight() : Number
      {
         if(this.isCheckbox())
         {
            return this.bkgdOff.height;
         }
         if(this.bkgdOn != null)
         {
            return this.bkgdOn.height;
         }
         return this.txtLabel.height;
      }
      
      public function setChecked(param1:Boolean) : void
      {
         this._checked = param1;
         this.onOut();
      }
   }
}
