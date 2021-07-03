package com.pixton.editor
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public final class HelpTab extends MovieClip
   {
      
      private static var PADDING:uint = 14;
      
      private static var PADDING_LEFT:uint = 16;
      
      private static var PADDING_ICON:uint = 2;
      
      private static var PADDING_ICON_2:uint = 7;
       
      
      public var bkgd:MovieClip;
      
      public var info:MovieClip;
      
      public var txtLabel:TextField;
      
      public var txtCredits:TextField;
      
      public var iconCredits:MovieClip;
      
      public var iconPaidPlus:MovieClip;
      
      public var iconFreePlus:MovieClip;
      
      public var iconMulticolor:MovieClip;
      
      private var rightAlign:Boolean = false;
      
      public function HelpTab()
      {
         super();
         this.txtLabel = this.info.txtLabel;
         this.txtCredits = this.info.txtCredits;
         this.iconCredits = this.info.iconCredits;
         this.iconPaidPlus = this.info.iconPaidPlus;
         this.iconFreePlus = this.info.iconFreePlus;
         this.iconMulticolor = this.info.iconMulticolor;
         this.txtLabel.autoSize = TextFieldAutoSize.LEFT;
         this.txtCredits.autoSize = TextFieldAutoSize.LEFT;
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function isEmpty() : Boolean
      {
         return !this.txtLabel.visible && !this.txtCredits.visible;
      }
      
      public function setText(param1:String, param2:Boolean = false) : void
      {
         this.rightAlign = param2;
         this.txtLabel.text = param1;
         this.txtLabel.visible = param1 != "";
         this.setPricing(null);
      }
      
      public function setPricing(param1:Object = null, param2:PickerItem = null) : void
      {
         var _loc3_:MovieClip = null;
         this.iconCredits.visible = false;
         this.iconPaidPlus.visible = false;
         this.iconFreePlus.visible = false;
         this.iconMulticolor.visible = false;
         if(param1 != null)
         {
            if(param1.platformFree_bool == 1 && Platform.exists())
            {
               _loc3_ = null;
            }
            else if(param1.plusOnly_bool == 1 && param1.plusFree_bool == 1)
            {
               _loc3_ = this.iconFreePlus;
            }
            else if(param1.plusOnly_bool == 1)
            {
               _loc3_ = this.iconPaidPlus;
            }
            else if(param1.plusFree_bool == 1)
            {
               _loc3_ = !!Globals.isFullVersion() ? null : this.iconCredits;
            }
            else
            {
               _loc3_ = this.iconCredits;
            }
         }
         this.txtCredits.visible = false;
         if(this.txtCredits.visible)
         {
            if(parseInt(param1.credits_int) > 0)
            {
               this.txtCredits.text = Utils.formatNumber(param1.credits_int);
            }
            else if(parseInt(param1.promoCredits_int) > 0)
            {
               this.txtCredits.text = Utils.formatNumber(param1.promoCredits_int);
            }
         }
         var _loc4_:uint = 0;
         if(this.txtLabel.visible)
         {
            _loc4_ += Math.round(this.txtLabel.textWidth);
         }
         this.bkgd.block.width = _loc4_ + PADDING;
         this.bkgd.roundedEnd.x = this.bkgd.block.x + this.bkgd.block.width - 2;
         if(this.rightAlign)
         {
            this.bkgd.scaleX = -1;
            this.info.x = -_loc4_ - PADDING_LEFT - 4;
         }
         else
         {
            this.bkgd.scaleX = 1;
            this.info.x = PADDING_LEFT;
         }
      }
      
      public function updateColor() : void
      {
         Utils.setColor(this.iconPaidPlus.symbol.outer,Palette.colorLink);
         Utils.setColor(this.iconFreePlus.symbol.outer,Palette.colorLink);
      }
   }
}
