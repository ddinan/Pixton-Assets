package com.pixton.editor
{
   import com.pixton.animate.Animation;
   import com.pixton.team.TeamRole;
   import com.xvisage.utils.StringUtils;
   import de.polygonal.math.PM_PRNG;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.Keyboard;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public final class Dialog extends Moveable
   {
      
      public static const TOP:uint = 0;
      
      public static const RIGHT:uint = 1;
      
      public static const BOTTOM:uint = 2;
      
      public static const LEFT:uint = 3;
      
      public static const TOP_LEFT:uint = 4;
      
      public static const TOP_RIGHT:uint = 5;
      
      public static const BOTTOM_RIGHT:uint = 6;
      
      public static const BOTTOM_LEFT:uint = 7;
      
      public static const NO_CORNER:uint = 8;
      
      public static const ALIGN_CENTER:uint = 0;
      
      public static const ALIGN_LEFT:uint = 1;
      
      public static const ALIGN_RIGHT:uint = 2;
      
      public static const NUM_SHAPES:uint = 9;
      
      public static const SHAPE_ROUNDED:uint = 0;
      
      public static const SHAPE_RECT:uint = 1;
      
      public static const SHAPE_OVAL:uint = 2;
      
      public static const SHAPE_CLOUD:uint = 3;
      
      public static const SHAPE_CLOUD_R:uint = 4;
      
      public static const SHAPE_SPIKY:uint = 5;
      
      public static const SHAPE_SPIKY_R:uint = 6;
      
      public static const SHAPE_NONE:uint = 7;
      
      public static const SHAPE_NOTCHED:uint = 8;
      
      public static const NUM_SPIKES:uint = 5;
      
      public static const SPIKE_STRAIGHT:uint = 0;
      
      public static const SPIKE_CURVED:uint = 1;
      
      public static const SPIKE_THOUGHT:uint = 2;
      
      public static const SPIKE_JAGGED:uint = 3;
      
      public static const SPIKE_LINE:uint = 4;
      
      public static const BKGD:uint = 0;
      
      public static const TEXT:uint = 1;
      
      public static const BORDER:uint = 2;
      
      public static const AUTO_SIZE:uint = 0;
      
      public static const MANUAL_SIZE:uint = 1;
      
      public static const FONT_SIZE_MIN:uint = 9;
      
      public static const FONT_SIZE_MAX:uint = 100;
      
      public static const PADDING_MIN:uint = 5;
      
      public static const PADDING_MAX:uint = 40;
      
      public static const LEADING_MIN:uint = 0;
      
      public static const LEADING_MAX:uint = 10;
      
      public static const BORDER_SIZE_MIN:uint = 1;
      
      public static const BORDER_SIZE_MAX:uint = 10;
      
      public static const FEATURE_FONT:String = "f";
      
      public static const FEATURE_SIZE:String = "s";
      
      public static const FEATURE_COLOR:String = "c";
      
      public static const FEATURE_STYLE:String = "v";
      
      public static const STYLE_REGULAR:uint = 0;
      
      public static const STYLE_BOLD:uint = 1;
      
      public static const STYLE_ITALIC:uint = 2;
      
      public static const STYLE_MAX:uint = STYLE_ITALIC;
      
      public static const STYLE_DEFAULT:uint = STYLE_REGULAR;
      
      private static const ALPHA_TEMPLATE_EMPTY:Number = 0.5;
      
      private static const DEFAULT_X:Number = 2;
      
      private static const DEFAULT_Y:Number = 20;
      
      private static const SPIKE_LENGTH_RATIO:Number = 0.4;
      
      private static const MIN_SPIKE_LENGTH:Number = 10;
      
      private static const MAX_SPIKE_LENGTH:Number = 30;
      
      private static const BUBBLE_RADIUS_MAX:Number = 5;
      
      private static const BUBBLE_RADIUS_MIN:Number = 2;
      
      private static const BUBBLE_FACTOR:uint = 12;
      
      private static const AUTO_ASPECT:Number = 2.5;
      
      private static const MIN_WIDTH:uint = 30;
      
      private static const LINE_SCALE:String = "none";
      
      private static const LINE_CAPS:String = "none";
      
      private static const LINE_JOINTS:String = "miter";
      
      private static const LINE_MITERLIMIT:Number = 20;
      
      private static const NOTCH_FACTOR:Number = 0.4;
      
      private static const TEXT_PART_SEP:String = "|url:";
      
      private static const INTERVAL:uint = 200;
      
      public static var bubbleShapeMap:Array = [SHAPE_ROUNDED,SHAPE_RECT,SHAPE_OVAL,SHAPE_CLOUD_R,SHAPE_SPIKY_R,SHAPE_NONE,SHAPE_NOTCHED];
      
      public static var defPadding:uint = 8;
      
      public static var defLeading:uint = 0;
      
      private static var defFontSize:uint = 12;
      
      private static var defBubbleShape:uint = SHAPE_ROUNDED;
      
      private static var defBorderSize:Number = 1;
      
      private static var defAlign:uint = 0;
      
      private static var defText:String = null;
      
      private static var lockInfo:Object;
      
      public static var RANDOM_PHRASES:Boolean = false;
      
      public static var randomPhrases:Array;
      
      public static var randomPhraseIndex:uint = 0;
      
      public static var maxWidth:Number = 0;
      
      public static var activeInstance:Dialog;
      
      public static var stringUtils:StringUtils;
      
      private static var timeout:int = -1;
      
      private static var interval:int = -1;
      
      private static var suggestions:Object = {};
      
      private static var suggestionMap:Array = [];
      
      private static var currentIndex:int = -1;
      
      private static var recentFont:int;
      
      private static var recentSize:uint;
      
      private static var recentStyle:uint;
      
      private static var recentPadding:uint;
      
      private static var recentLeading:uint;
      
      private static var recentShapeMode:uint;
      
      private static var recentSpikeMode:uint;
      
      private static var recentColor:Array;
      
      private static var recentSilhouette:Boolean;
      
      private static var recentBorderSize:Number;
      
      private static var recentAlign:uint;
      
      private static var randomizer:PM_PRNG;
       
      
      public var spike:MovieClip;
      
      public var bubble:MovieClip;
      
      public var txtDialog:TextField;
      
      public var spikeMode:uint = 0;
      
      public var shapeMode:uint = 0;
      
      public var sizeMode:uint = 0;
      
      public var tempTarget:int = -1;
      
      private var _ready:Boolean = false;
      
      private var overlay:Shape;
      
      private var _targetAsset:Asset;
      
      private var _targetOffset:Object;
      
      private var spikeEnd:Object;
      
      private var O:Object;
      
      private var A:Object;
      
      private var B:Object;
      
      private var C:Object;
      
      private var D:Object;
      
      private var flushCorner:Object;
      
      private var bkgdColorID:uint;
      
      private var borderColorID:uint;
      
      private var _corner:uint;
      
      private var _silhouette:Boolean;
      
      private var borderColor:uint;
      
      private var highlightRGB:Array;
      
      private var fillColor:uint;
      
      private var padding:uint = 0;
      
      private var leading:uint = 0;
      
      private var _textAlign:uint = 0;
      
      private var styles:Array;
      
      private var prevText:String;
      
      private var bubbleBoundsStage:Rectangle;
      
      private var bubbleBounds:Rectangle;
      
      private var isMaxWidth:Boolean = false;
      
      private var _isProp:Boolean = false;
      
      private var _text:String = "";
      
      private var _isResizable:Boolean = true;
      
      private var _soundKey:String;
      
      private var dirty:Boolean = true;
      
      private var _borderSize:Number;
      
      private var _linkURL:String;
      
      private var _previewing:Boolean = false;
      
      private var _selectionActive:Boolean = false;
      
      private var _recentCaretIndex:int = -1;
      
      public function Dialog()
      {
         super();
         this.overlay = new Shape();
         addChild(this.overlay);
         this.setChildIndex(this.overlay,this.getChildIndex(this.txtDialog));
         this.txtDialog.multiline = true;
         this.txtDialog.autoSize = TextFieldAutoSize.LEFT;
         this.txtDialog.antiAliasType = AntiAliasType.NORMAL;
         this.flushCorner = {};
         if(isNaN(recentSize) || recentSize < FONT_SIZE_MIN)
         {
            recentFont = this.getDefault(FEATURE_FONT);
            recentSize = this.getDefault(FEATURE_SIZE);
            recentStyle = this.getDefault(FEATURE_STYLE);
            recentPadding = defPadding;
            recentLeading = defLeading;
            recentSilhouette = false;
            recentColor = [0,0,0];
            recentShapeMode = defBubbleShape;
            recentSpikeMode = SPIKE_STRAIGHT;
            recentBorderSize = defBorderSize;
            recentAlign = defAlign;
         }
         this.reset();
         this.setColor(BKGD,recentColor[BKGD]);
         this.setColor(BORDER,recentColor[BORDER]);
         this.setColor(TEXT,recentColor[TEXT],false);
         this.setFontFace(recentFont,false);
         this.setFontSize(recentSize,false);
         this.setFontStyle(recentStyle,false);
         this.setTextAlign(recentAlign,false);
         this.setPadding(recentPadding,false);
         this.setLeading(recentLeading,false);
         this.setSilhouette(recentSilhouette);
         this.setShapeMode(recentShapeMode,false);
         this.setSpikeMode(recentSpikeMode,false);
         this.borderSize = recentBorderSize;
         this.applyStyles(true);
         if(OS.canInvalidate() && !Main.isHiResRender())
         {
            Utils.addListener(this,Event.RENDER,this.onRender);
         }
      }
      
      public static function init(param1:Object) : void
      {
         stringUtils = new StringUtils();
         if(param1.defFontSize != null)
         {
            defFontSize = param1.defFontSize;
         }
         if(param1.defPadding != null)
         {
            defPadding = param1.defPadding;
         }
         if(param1.defLeading != null)
         {
            defLeading = param1.defLeading;
         }
         if(param1.defBubbleShape != null)
         {
            defBubbleShape = param1.defBubbleShape;
         }
         if(param1.defBorderSize != null)
         {
            defBorderSize = param1.defBorderSize;
         }
         if(param1.defAlign != null)
         {
            defAlign = param1.defAlign;
         }
         if(param1.defText != null)
         {
            defText = param1.defText;
         }
         randomizer = new PM_PRNG();
      }
      
      static function load(param1:MovieClip, param2:Array) : void
      {
         var _loc4_:Dialog = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:DisplayObject = null;
         var _loc11_:Object = null;
         var _loc3_:Array = [];
         var _loc9_:MovieClip = param1 is Editor ? param1.containerD : param1;
         _loc6_ = 0;
         _loc7_ = _loc9_.numChildren;
         _loc5_ = 0;
         while(_loc5_ < _loc7_)
         {
            if((_loc8_ = _loc9_.getChildAt(_loc6_)) is Dialog)
            {
               _loc9_.removeChild(_loc8_);
            }
            else
            {
               _loc6_++;
            }
            _loc5_++;
         }
         _loc6_ = 0;
         var _loc10_:Boolean = false;
         for each(_loc11_ in param2)
         {
            if(_loc3_[_loc6_] != null)
            {
               (_loc4_ = _loc3_[_loc6_++] as Dialog).reset();
               onAdd(param1,_loc4_);
            }
            else
            {
               _loc4_ = add(param1);
            }
            _loc4_.setData(_loc11_);
            if(_loc4_.isProp())
            {
               _loc10_ = true;
               _loc4_.redraw();
            }
            else
            {
               _loc4_.tempTarget = _loc11_.tgt;
            }
         }
         if(_loc10_)
         {
            Editor.updateFromZ(param1 is Editor ? param1.containerC : param1);
         }
      }
      
      static function add(param1:MovieClip) : Dialog
      {
         var _loc2_:Dialog = new Dialog();
         return onAdd(param1,_loc2_,true);
      }
      
      private static function onAdd(param1:MovieClip, param2:Dialog, param3:Boolean = false) : Dialog
      {
         var _loc5_:uint = 0;
         var _loc8_:Moveable = null;
         var _loc6_:uint;
         var _loc4_:MovieClip;
         var _loc7_:uint = _loc6_ = (_loc4_ = param1 is Editor ? param1.containerD : param1).numChildren;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc8_ = _loc4_.getChildAt(_loc5_) as Moveable;
            if(param2.zIndex < 1 && param2.zIndex < _loc8_.zIndex)
            {
               _loc7_ = _loc5_;
               break;
            }
            _loc7_ = _loc5_ + 1;
            _loc5_++;
         }
         _loc4_.addChildAt(param2,_loc7_);
         if(param1 is Editor && param3)
         {
            param1.positionNew(param2 as MovieClip);
            param1.activateTarget(param2 as MovieClip);
         }
         return param2;
      }
      
      public static function setLock(param1:Array) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:Object = null;
         lockInfo = {};
         var _loc3_:uint = param1.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            Utils.initObject(lockInfo,_loc4_.mode_int,_loc4_.value_int);
            lockInfo[_loc4_.mode_int][_loc4_.value_int] = _loc4_;
            _loc2_++;
         }
      }
      
      public static function getLock(param1:uint, param2:uint) : Object
      {
         var _loc3_:String = param1.toString();
         var _loc4_:String = param2.toString();
         if(lockInfo != null && lockInfo[_loc3_] != null && lockInfo[_loc3_][_loc4_] != null)
         {
            return lockInfo[_loc3_][_loc4_];
         }
         return null;
      }
      
      public static function isSpellChecking() : Boolean
      {
         return activeInstance != null && activeInstance.txtDialog.selectable && currentIndex > -1;
      }
      
      public static function getCurrentWord() : String
      {
         return suggestionMap[currentIndex];
      }
      
      public static function getSpellingSuggestions() : Array
      {
         if(suggestionMap[currentIndex] == null)
         {
            return null;
         }
         return suggestions[getCurrentWord()];
      }
      
      private static function ignoreWord(param1:String) : void
      {
         if(suggestions[param1] != null)
         {
            delete suggestions[param1];
         }
         activeInstance.updateSuggestions();
      }
      
      public static function ignoreSpelling() : void
      {
         var _loc1_:String = getCurrentWord();
         SpellCheck.ignore(_loc1_);
         ignoreWord(_loc1_);
      }
      
      public static function addSpelling() : void
      {
         var _loc1_:String = getCurrentWord();
         SpellCheck.add(_loc1_);
         ignoreWord(_loc1_);
      }
      
      public static function correctSpelling(param1:String) : void
      {
         var _loc2_:int = currentIndex;
         var _loc3_:int = currentIndex;
         var _loc4_:String = getCurrentWord();
         while(_loc2_ > 0 && suggestionMap[_loc2_ - 1] == _loc4_)
         {
            _loc2_--;
         }
         var _loc5_:uint = activeInstance.text.length;
         while(_loc3_ < _loc5_ && suggestionMap[_loc3_ + 1] == _loc4_)
         {
            _loc3_++;
         }
         var _loc6_:String = activeInstance.text;
         activeInstance.text = _loc6_.substring(0,_loc2_) + param1 + _loc6_.substr(_loc3_ + 1);
         activeInstance.onUpdateText();
         activeInstance.updateSuggestions();
         SpellCheck.onCorrect(_loc4_,param1);
      }
      
      private static function extractTextParts(param1:String) : Object
      {
         var _loc2_:Object = {
            "text":null,
            "url":null
         };
         var _loc3_:Array = param1.split(TEXT_PART_SEP);
         _loc2_.text = _loc3_[0];
         if(_loc3_[1])
         {
            _loc2_.url = _loc3_[1];
         }
         return _loc2_;
      }
      
      private static function createTextParts(param1:Object) : String
      {
         return param1.text + (param1.url != null ? TEXT_PART_SEP + param1.url : "");
      }
      
      public function redraw(param1:Boolean = false) : void
      {
         this.dirty = true;
         if(param1 || !OS.canInvalidate() || Main.isHiResRender())
         {
            this.onRender();
         }
         else
         {
            Utils.invalidate(this);
         }
      }
      
      function onRender(param1:Event = null, param2:Boolean = false) : void
      {
         if(!this.dirty && !param2)
         {
            return;
         }
         this.dirty = false;
         if(this.isUnicode() && Fonts.useHTML)
         {
            this.txtDialog.htmlText = stringUtils.parseArabic(this.text,this.txtDialog);
         }
         else
         {
            this.txtDialog.text = this.text;
            if(this.isUnicode() && Fonts.addPadding)
            {
               this.txtDialog.appendText("\r");
            }
            if(Template.isActive() && !Main.isTemplatesUser() && this._targetAsset && this._targetAsset is Character)
            {
               Editor.self.updateSpeaking(this._targetAsset as Character,this.txtDialog.text != "");
            }
         }
         this.updateFormat();
         if(this.isProp())
         {
            this.updateWrapping();
         }
         else
         {
            this.isMaxWidth = false;
            this.updateWrapping();
            this.drawBubble();
            this.snapToCorner();
         }
      }
      
      private function snapToCorner() : void
      {
         this.flushCorner[TOP_LEFT] = false;
         this.flushCorner[TOP_RIGHT] = false;
         this.flushCorner[BOTTOM_RIGHT] = false;
         this.flushCorner[BOTTOM_LEFT] = false;
         if(!this._ready || !visible || !this.canSnap())
         {
            return;
         }
         var _loc1_:Rectangle = this.getBubbleBounds();
         var _loc2_:Rectangle = Editor.getRect();
         if(_loc1_ == null)
         {
            return;
         }
         var _loc3_:Object = {};
         _loc3_[TOP] = Math.round(_loc1_.topLeft.y) <= _loc2_.topLeft.y + 0;
         _loc3_[LEFT] = Math.round(_loc1_.topLeft.x) <= _loc2_.topLeft.x;
         _loc3_[BOTTOM] = Math.round(_loc1_.bottomRight.y) >= _loc2_.bottomRight.y - 2;
         _loc3_[RIGHT] = Math.round(_loc1_.bottomRight.x) >= _loc2_.bottomRight.x;
         if(this.target == null)
         {
            if(this.shapeMode == SHAPE_ROUNDED)
            {
               if(_loc3_[TOP] && _loc3_[LEFT])
               {
                  this.flushCorner[TOP_LEFT] = true;
                  this.flushCorner[TOP_RIGHT] = true;
                  this.flushCorner[BOTTOM_LEFT] = true;
               }
               else if(_loc3_[TOP] && _loc3_[RIGHT])
               {
                  this.flushCorner[TOP_RIGHT] = true;
                  this.flushCorner[TOP_LEFT] = true;
                  this.flushCorner[BOTTOM_RIGHT] = true;
               }
               else if(_loc3_[BOTTOM] && _loc3_[RIGHT])
               {
                  this.flushCorner[BOTTOM_RIGHT] = true;
                  this.flushCorner[BOTTOM_LEFT] = true;
                  this.flushCorner[TOP_RIGHT] = true;
               }
               else if(_loc3_[BOTTOM] && _loc3_[LEFT])
               {
                  this.flushCorner[BOTTOM_LEFT] = true;
                  this.flushCorner[BOTTOM_RIGHT] = true;
                  this.flushCorner[TOP_LEFT] = true;
               }
            }
            else if(this.shapeMode == SHAPE_RECT)
            {
               if(_loc3_[TOP])
               {
                  this.flushCorner[TOP_LEFT] = true;
                  this.isMaxWidth = true;
               }
               else if(_loc3_[BOTTOM])
               {
                  this.flushCorner[BOTTOM_LEFT] = true;
                  this.isMaxWidth = true;
               }
            }
         }
         if(!this.isMaxWidth && !this.flushCorner[TOP_LEFT] && !this.flushCorner[TOP_RIGHT] && !this.flushCorner[BOTTOM_RIGHT] && !this.flushCorner[BOTTOM_LEFT])
         {
            return;
         }
         this.updateWrapping();
         this.updateFormat();
         this.drawBubble();
         var _loc4_:Point = new Point(0,0);
         if(_loc3_[LEFT])
         {
            _loc4_.x = _loc2_.topLeft.x;
         }
         else
         {
            _loc4_.x = _loc2_.bottomRight.x;
         }
         if(_loc3_[TOP])
         {
            _loc4_.y = _loc2_.topLeft.y;
         }
         else
         {
            _loc4_.y = _loc2_.bottomRight.y;
         }
         _loc4_ = parent.globalToLocal(_loc4_);
         if(this.isMaxWidth)
         {
            if(_loc3_[LEFT])
            {
               x = _loc4_.x + Math.round(maxWidth * 0.5) - 1;
            }
            else
            {
               x = _loc4_.x - Math.round(maxWidth * 0.5) + 1;
            }
         }
         else if(_loc3_[LEFT])
         {
            x = Math.round(_loc4_.x + this.getTxtWidth() * 0.5 + this.getPadding()) - 1;
         }
         else
         {
            x = Math.round(_loc4_.x - this.getTxtWidth() * 0.5 - this.getPadding()) + 1;
         }
         if(_loc3_[TOP])
         {
            y = Math.round(_loc4_.y + this.getPadding()) - 1;
         }
         else
         {
            y = Math.round(_loc4_.y - this.getPadding() - this.getTxtHeight());
         }
      }
      
      function canSnap() : Boolean
      {
         return this._ready && rotation == 0 && Utils.inArray(this.shapeMode,[SHAPE_RECT,SHAPE_ROUNDED]);
      }
      
      private function resetStyles() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this.styles.length;
         _loc1_ = 1;
         while(_loc1_ < _loc2_)
         {
            delete this.styles[_loc1_];
            _loc1_++;
         }
      }
      
      private function reset() : void
      {
         this._ready = false;
         this.setSound(null);
         this.flushCorner[TOP_LEFT] = true;
         this.flushCorner[TOP_RIGHT] = true;
         this.flushCorner[BOTTOM_LEFT] = true;
         this.flushCorner[BOTTOM_RIGHT] = true;
         this.stopEdit();
      }
      
      private function getDefault(param1:String) : Number
      {
         switch(param1)
         {
            case FEATURE_FONT:
               return Fonts.defaultFont;
            case FEATURE_COLOR:
               return Palette.BLACK_ID;
            case FEATURE_SIZE:
               return defFontSize;
            case FEATURE_STYLE:
               return STYLE_DEFAULT;
            default:
               return -1;
         }
      }
      
      public function setData(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:* = null;
         if(param1 != null)
         {
            x = param1.x;
            y = param1.y;
            if(param1.pr != null)
            {
               this.setProp(param1.pr == 1);
            }
            if(size <= 0)
            {
               this.size = 1;
            }
            if(param1.sd != null)
            {
               this.setSound(param1.sd);
            }
            if(this.isProp() && param1.z != null)
            {
               zIndex = param1.z;
            }
            if(param1.r != null && !isNaN(param1.r))
            {
               rotation = param1.r;
            }
            if(param1.t != null || param1.animating != null)
            {
               if(param1.t != null)
               {
                  _loc3_ = extractTextParts(param1.t);
                  this.text = _loc3_.text;
                  this._linkURL = _loc3_.url;
               }
               this.setSpikeMode(param1.s,false);
               if(param1.sm != null)
               {
                  this.setShapeMode(param1.sm,false);
               }
               else if(param1.s == 2)
               {
                  this.setShapeMode(SHAPE_NONE,false);
               }
               else if(param1.c != null && param1.c > 0)
               {
                  this.setShapeMode(SHAPE_ROUNDED,false);
               }
               else
               {
                  this.setShapeMode(SHAPE_RECT,false);
               }
               if(param1.sz != null)
               {
                  this.setSizeMode(param1.sz,false);
               }
               this.setSilhouette(param1.sh == 1,false);
               if(Template.isActive())
               {
                  _loc2_ = {};
                  _loc2_[FEATURE_FONT] = Fonts.defaultFont;
                  _loc2_[FEATURE_SIZE] = defFontSize;
                  this.styles = [_loc2_];
               }
               else if(param1.animating == null)
               {
                  if(param1.st != null && param1.st != "")
                  {
                     _loc4_ = Utils.decode(param1.st);
                  }
                  else
                  {
                     _loc2_ = {};
                     _loc2_[FEATURE_FONT] = param1.ff;
                     _loc2_[FEATURE_SIZE] = param1.fs;
                     _loc2_[FEATURE_COLOR] = param1.tc;
                     _loc4_ = {"0":_loc2_};
                  }
                  this.styles = [];
                  for(_loc5_ in _loc4_)
                  {
                     this.styles[parseInt(_loc5_)] = _loc4_[_loc5_];
                  }
               }
               if(param1.k != null)
               {
                  this.setColor(BKGD,param1.k);
               }
               this.setPadding(param1.p,false);
               this.applyStyles(true);
            }
            if(param1.ex != null)
            {
               this.setExtraData(param1.ex);
               this.updateColors();
            }
         }
         if(Main.isTemplatesUser() && defText != null)
         {
            this.text = defText;
         }
         this._ready = true;
         this.redraw(true);
      }
      
      function getBubbleBounds() : Rectangle
      {
         return this.bubbleBoundsStage;
      }
      
      private function setStyle(param1:String, param2:Number, param3:int = -1, param4:int = -1) : void
      {
         var _loc5_:int = 0;
         var _loc8_:* = null;
         var _loc6_:int = -1;
         if(param3 == -1 && param4 == -1)
         {
            if(this.hasSelection() && !(param1 == FEATURE_FONT && param2 < 0))
            {
               param3 = this.txtDialog.selectionBeginIndex;
               param4 = this.txtDialog.selectionEndIndex;
            }
            else
            {
               param3 = 0;
               _loc6_ = param4 = this.text.length;
            }
         }
         var _loc7_:Number = this.getFeature(param1,param3 - 1);
         if(!isNaN(_loc7_))
         {
         }
         _loc5_ = param3;
         while(_loc5_ < param4)
         {
            if(!(this.styles == null || this.styles[_loc5_] == null))
            {
               if(this.styles[_loc5_][param1] != null)
               {
                  delete this.styles[_loc5_][param1];
                  if(_loc5_ > 0 && _loc5_ != param3 && this.noFeatures(_loc5_))
                  {
                     this.styles[_loc5_] = null;
                  }
               }
            }
            _loc5_++;
         }
         if(this._ready && _loc6_ > 0)
         {
            for(_loc8_ in this.styles)
            {
               if(parseInt(_loc8_) >= _loc6_)
               {
                  delete this.styles[_loc8_];
               }
            }
         }
         this.setFeature(param1,param3,param2);
         if(param4 < this.text.length)
         {
            if(this.styles[param4] == null)
            {
               this.styles[param4] = {};
            }
            if(this.styles[param4][param1] == null)
            {
               this.styles[param4][param1] = _loc7_;
            }
         }
      }
      
      private function setFeature(param1:String, param2:int, param3:Number, param4:Boolean = true) : void
      {
         if(this.styles == null)
         {
            this.styles = [];
         }
         if(this.styles[param2] == null)
         {
            this.styles[param2] = {};
         }
         if(this.styles[param2][param1] == null || param4)
         {
            this.styles[param2][param1] = param3;
         }
      }
      
      private function noFeatures(param1:uint) : Boolean
      {
         return this.styles[param1] == null || this.styles[param1][FEATURE_FONT] == null && this.styles[param1][FEATURE_SIZE] == null && this.styles[param1][FEATURE_COLOR] == null && this.styles[param1][FEATURE_STYLE] == null;
      }
      
      public function getFeature(param1:String, param2:int = -1, param3:Boolean = false) : Number
      {
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         if(param2 == -1 && this.hasSelection())
         {
            param2 = this.txtDialog.selectionBeginIndex;
         }
         if(param2 > -1)
         {
            _loc5_ = param2;
            while(_loc5_ >= 0)
            {
               if(this.styles != null && this.styles[_loc5_] != null && this.styles[_loc5_][param1] != null)
               {
                  _loc4_ = this.styles[_loc5_][param1];
                  break;
               }
               _loc5_--;
            }
         }
         if(isNaN(_loc4_))
         {
            if(this.styles != null && this.styles[0] != null && this.styles[0][param1] != null)
            {
               _loc4_ = this.styles[0][param1];
            }
            else
            {
               _loc4_ = this.getDefault(param1);
            }
         }
         if(param1 == FEATURE_FONT)
         {
            if(_loc4_ > Fonts.minFontID && !FeatureTrial.can(FeatureTrial.EXTRA_FONTS) && !this._previewing)
            {
               _loc4_ = !!param3 ? Number(Number.MAX_VALUE) : Number(0);
            }
         }
         return _loc4_;
      }
      
      private function getFontList() : Array
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this.text.length;
         var _loc3_:Array = [];
         _loc1_ = 0;
         while(_loc1_ <= _loc2_)
         {
            if(!(this.styles[_loc1_] == null || this.styles[_loc1_][FEATURE_FONT] == null))
            {
               if(!Utils.inArray(this.styles[_loc1_][FEATURE_FONT],_loc3_))
               {
                  _loc3_.push(this.styles[_loc1_][FEATURE_FONT]);
               }
            }
            _loc1_++;
         }
         return _loc3_;
      }
      
      private function applyStyles(param1:Boolean = false) : void
      {
         if(!this._ready && !param1 || Fonts.busy)
         {
            return;
         }
         var _loc2_:Array = this.getFontList();
         if(Fonts.allExist(_loc2_))
         {
            this.finishStyles();
         }
         else
         {
            Fonts.loadAll(_loc2_,this.finishStyles);
         }
      }
      
      function updateFormat(param1:TextField = null) : void
      {
         var _loc3_:uint = 0;
         var _loc5_:TextFormat = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc2_:* = param1 != null;
         if(param1 == null)
         {
            param1 = this.txtDialog;
         }
         var _loc4_:uint = param1.text.length;
         param1.embedFonts = !this.isUnicode();
         param1.cacheAsBitmap = this.isUnicode();
         param1.antiAliasType = AntiAliasType.ADVANCED;
         if(this.isUnicode())
         {
            rotation = 0;
         }
         _loc3_ = 0;
         while(_loc3_ <= _loc4_)
         {
            if(this.styles[_loc3_] != null)
            {
               _loc5_ = new TextFormat();
               switch(this._textAlign)
               {
                  case ALIGN_LEFT:
                     _loc5_.align = TextFormatAlign.LEFT;
                     break;
                  case ALIGN_RIGHT:
                     _loc5_.align = TextFormatAlign.RIGHT;
                     break;
                  default:
                     _loc5_.align = TextFormatAlign.CENTER;
               }
               _loc5_.leading = 0;
               if(this.styles[_loc3_][FEATURE_FONT] != null || this.styles[_loc3_][FEATURE_STYLE] != null)
               {
                  if((_loc7_ = this.getFeature(FEATURE_FONT,_loc3_,true)) == Number.MAX_VALUE)
                  {
                     _loc7_ = this.getDefault(FEATURE_FONT);
                     this.setFeature(FEATURE_FONT,_loc3_,_loc7_);
                  }
                  if((_loc6_ = Fonts.getFontInfo(_loc7_)) != null)
                  {
                     _loc5_.font = _loc6_["instance" + this.getFeature(FEATURE_STYLE,_loc3_)].fontName;
                     _loc5_.bold = _loc6_["bold" + this.getFeature(FEATURE_STYLE,_loc3_)];
                     _loc5_.italic = _loc6_["italic" + this.getFeature(FEATURE_STYLE,_loc3_)];
                     _loc5_.leading = _loc6_["leading"] != null ? parseFloat(_loc6_["leading"]) : 2;
                  }
               }
               _loc5_.leading += this.leading;
               if(!_loc2_)
               {
                  if(this.styles[_loc3_][FEATURE_COLOR] != null)
                  {
                     _loc5_.color = Palette.RGBtoHex(Palette.getColor(this.styles[_loc3_][FEATURE_COLOR]));
                  }
                  if(this.styles[_loc3_][FEATURE_SIZE] != null)
                  {
                     if(_loc6_ == null)
                     {
                        _loc6_ = Fonts.getFontInfo(this.getFeature(FEATURE_FONT,_loc3_));
                     }
                     if(_loc6_["size"] != null)
                     {
                        _loc5_.size = this.styles[_loc3_][FEATURE_SIZE] * _loc6_["size"];
                     }
                     else
                     {
                        _loc5_.size = this.styles[_loc3_][FEATURE_SIZE];
                     }
                  }
               }
               param1.defaultTextFormat = _loc5_;
               if(_loc3_ < _loc4_)
               {
                  if(_loc3_ == 0)
                  {
                     param1.setTextFormat(_loc5_);
                  }
                  else
                  {
                     param1.setTextFormat(_loc5_,_loc3_,_loc4_);
                  }
               }
            }
            _loc3_++;
         }
         this.updateSuggestions();
      }
      
      private function finishStyles() : void
      {
         this.updateFormat();
         this.updateWrapping();
         this.drawBubble();
         this.updateEditor();
      }
      
      private function updateEditor() : void
      {
         if(this._ready)
         {
            dispatchEvent(new PixtonEvent(PixtonEvent.CHANGE,this));
         }
      }
      
      public function startEdit() : void
      {
         activeInstance = this;
         this.cacheAsBitmap = false;
         this.txtDialog.selectable = true;
         stage.focus = this.txtDialog;
         Utils.addListener(this.txtDialog,KeyboardEvent.KEY_DOWN,this.onDownKey);
         Utils.addListener(this.txtDialog,Event.CHANGE,this.onUpdateText);
         Utils.addListener(this.txtDialog,Event.SCROLL,this.onScroll);
         if(SpellCheck.isAvailable)
         {
            Utils.addListener(this.txtDialog,MouseEvent.MOUSE_MOVE,this.onMove);
            Utils.addListener(this.txtDialog,MouseEvent.ROLL_OUT,this.onMove);
         }
         Utils.addListener(this.bubble,MouseEvent.MOUSE_UP,this.doNothing);
         mouseChildren = true;
         this.spellCheck();
         this.resetInterval();
         interval = setInterval(this.checkSelection,INTERVAL);
      }
      
      public function hasFocus() : Boolean
      {
         return stage != null && stage.focus == this.txtDialog;
      }
      
      public function setBorderColor(param1:Array = null) : void
      {
         this.highlightRGB = param1;
         this.updateColors();
         this.drawBubble();
      }
      
      private function updateColors() : void
      {
         this.fillColor = Palette.RGBtoHex(Palette.getColor(this.bkgdColorID));
         if(this.highlightRGB == null)
         {
            this.borderColor = !!this.getSilhouette() ? uint(this.fillColor) : uint(Palette.RGBtoHex(Palette.getColor(this.borderColorID)));
         }
         else
         {
            this.borderColor = Palette.RGBtoHex(this.highlightRGB);
         }
      }
      
      public function resetSelection() : void
      {
         this.txtDialog.setSelection(0,0);
      }
      
      public function stopEdit() : void
      {
         this.txtDialog.selectable = false;
         Utils.removeListener(this.txtDialog,KeyboardEvent.KEY_DOWN,this.onDownKey);
         this.cacheAsBitmap = Main.CACHE_AS_BITMAPS;
         Utils.removeListener(this.txtDialog,Event.CHANGE,this.onUpdateText);
         Utils.removeListener(this.txtDialog,Event.SCROLL,this.onScroll);
         if(SpellCheck.isAvailable)
         {
            Utils.removeListener(this.txtDialog,MouseEvent.MOUSE_MOVE,this.onMove);
            Utils.removeListener(this.txtDialog,MouseEvent.ROLL_OUT,this.onMove);
         }
         Utils.removeListener(this.bubble,MouseEvent.MOUSE_UP,this.doNothing);
         mouseChildren = false;
         currentIndex = -1;
         this.resetTimeout();
         this.clearSpellCheck();
         this.resetInterval();
      }
      
      private function doNothing(param1:MouseEvent) : void
      {
      }
      
      private function checkSelection() : void
      {
         if(this.txtDialog.selectionBeginIndex != this.txtDialog.selectionEndIndex)
         {
            if(!this._selectionActive)
            {
               Editor.self.refreshMenu();
            }
            this._selectionActive = true;
         }
         else
         {
            if(this._selectionActive)
            {
               Editor.self.refreshMenu();
            }
            this._selectionActive = false;
         }
      }
      
      private function spliceStyle(param1:uint, param2:int) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         if(param2 < 0)
         {
            _loc3_ = this.getFeature(FEATURE_FONT,param1 - param2);
            _loc4_ = this.getFeature(FEATURE_SIZE,param1 - param2);
            _loc5_ = this.getFeature(FEATURE_COLOR,param1 - param2);
            _loc6_ = this.getFeature(FEATURE_STYLE,param1 - param2);
            if(this.text.length == 0)
            {
               param2++;
            }
            this.styles.splice(param1,-param2);
            this.setFeature(FEATURE_FONT,param1,_loc3_,false);
            this.setFeature(FEATURE_SIZE,param1,_loc4_,false);
            this.setFeature(FEATURE_COLOR,param1,_loc5_,false);
            this.setFeature(FEATURE_STYLE,param1,_loc6_,false);
         }
         else if(param2 > 0)
         {
            if((_loc8_ = param1 - param2) == 0)
            {
               _loc8_++;
            }
            _loc7_ = 0;
            while(_loc7_ < param2)
            {
               this.styles.splice(_loc8_,0,null);
               _loc7_++;
            }
         }
      }
      
      public function onBlur() : void
      {
         this.clearSpellCheck();
         this.text = Filter.filter(this.text);
         this.redraw();
      }
      
      public function onUpdateText(param1:Event = null) : void
      {
         var _loc2_:int = 0;
         if(param1 != null)
         {
            this.text = this.txtDialog.text;
            if(this.isUnicode() && Fonts.addPadding)
            {
               this.text = this.text.replace(/\r$/,"");
            }
         }
         this.updateEditor();
         if(param1 != null)
         {
            this.clearSpellCheck();
            this.checkSpelling();
         }
         if(this.styles != null)
         {
            if(this.prevText != null && this.prevText != this.text)
            {
               _loc2_ = this.text.length - this.prevText.length;
               this.spliceStyle(this.txtDialog.caretIndex,_loc2_);
            }
            this.prevText = this.text;
            this.applyStyles();
         }
         Guide.onChangeText();
      }
      
      public function clearSpellCheck() : void
      {
         this.overlay.graphics.clear();
      }
      
      private function resetTimeout() : void
      {
         if(timeout != -1)
         {
            clearTimeout(timeout);
            timeout = -1;
         }
      }
      
      private function resetInterval() : void
      {
         this._selectionActive = false;
         if(interval != -1)
         {
            clearInterval(interval);
            interval = -1;
         }
      }
      
      private function checkSpelling() : void
      {
         if(!this.txtDialog.selectable || !SpellCheck.isAvailable)
         {
            return;
         }
         this.resetTimeout();
         timeout = setTimeout(this.spellCheck,SpellCheck.TIMEOUT);
      }
      
      private function spellCheck() : void
      {
         if(this.text == "" || !SpellCheck.isAvailable)
         {
            return;
         }
         SpellCheck.checkSpelling(this.text,this.onSpellCheck);
      }
      
      private function onSpellCheck(param1:Object) : void
      {
         if(!this.txtDialog.selectable || param1 == null || param1.suggestions == null)
         {
            return;
         }
         suggestions = param1.suggestions;
         this.updateSuggestions();
      }
      
      public function updateSuggestions() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Rectangle = null;
         var _loc5_:Rectangle = null;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:String = null;
         var _loc9_:RegExp = null;
         var _loc10_:uint = 0;
         var _loc11_:* = null;
         if(!this.txtDialog.selectable || !this.hasFocus())
         {
            return;
         }
         suggestionMap = [];
         this.clearSpellCheck();
         if(!this.txtDialog.selectable)
         {
            return;
         }
         this.overlay.graphics.lineStyle(1,SpellCheck.COLOR);
         for(_loc11_ in suggestions)
         {
            _loc3_ = 0;
            _loc10_ = 0;
            while(++_loc10_ < 10)
            {
               if(_loc3_ >= this.text.length)
               {
                  break;
               }
               _loc9_ = new RegExp(_loc11_);
               _loc2_ = (_loc8_ = this.text.substr(_loc3_)).search(_loc9_);
               if(_loc2_ == -1)
               {
                  break;
               }
               _loc2_ = _loc3_ + _loc2_;
               _loc3_ = _loc2_ + _loc11_.length - 1;
               _loc4_ = this.txtDialog.getCharBoundaries(_loc2_);
               _loc5_ = this.txtDialog.getCharBoundaries(_loc3_);
               _loc6_ = this.globalToLocal(this.txtDialog.localToGlobal(new Point(_loc4_.x,_loc4_.y + _loc4_.height)));
               _loc7_ = this.globalToLocal(this.txtDialog.localToGlobal(new Point(_loc5_.x + _loc5_.width,_loc4_.y + _loc4_.height)));
               this.overlay.graphics.moveTo(_loc6_.x - 2,_loc6_.y - 5);
               this.overlay.graphics.lineTo(_loc7_.x - 2,_loc7_.y - 5);
               _loc1_ = _loc2_;
               while(_loc1_ <= _loc3_)
               {
                  suggestionMap[_loc1_] = _loc11_;
                  _loc1_++;
               }
               _loc3_++;
            }
         }
      }
      
      private function onScroll(param1:Event) : void
      {
         this.txtDialog.scrollV = 0;
      }
      
      private function onMove(param1:MouseEvent) : void
      {
         if(param1.stageX < 0)
         {
            return;
         }
         var _loc2_:Point = this.globalToLocal(new Point(param1.stageX,param1.stageY));
         currentIndex = this.txtDialog.getCharIndexAtPoint(_loc2_.x - this.txtDialog.x,_loc2_.y);
      }
      
      public function isEmpty() : Boolean
      {
         return this.text == "";
      }
      
      public function isResizable() : Boolean
      {
         return this._isResizable;
      }
      
      public function updateWrapping() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(!this._ready && !this.isProp())
         {
            return;
         }
         this._isResizable = false;
         if(this.isProp())
         {
            this.txtDialog.wordWrap = false;
         }
         else
         {
            _loc1_ = this.text.match(/ /g);
            this.txtDialog.wordWrap = false;
            if(this.isEmpty())
            {
               this.txtDialog.height = 20;
            }
            else
            {
               _loc2_ = this.getTxtWidth();
               _loc3_ = maxWidth - this.getPadding() * 2;
               if(this.isMaxWidth)
               {
                  this.txtDialog.wordWrap = true;
                  this.txtDialog.width = _loc3_;
                  this.isMaxWidth = true;
               }
               else
               {
                  if(this.sizeMode == AUTO_SIZE && (this.text.indexOf("\r") == -1 || this.text.indexOf("\r") == this.text.length - 1) && (_loc1_ != null && _loc1_.length > 1 || this.text.length > 16))
                  {
                     this._isResizable = true;
                     _loc4_ = this.getTxtHeight();
                     this.txtDialog.width = Math.max(MIN_WIDTH,Math.sqrt(_loc2_ * _loc4_ / AUTO_ASPECT) * AUTO_ASPECT * size);
                     this.txtDialog.wordWrap = true;
                  }
                  if(maxWidth > 0 && this.getTxtWidth() > _loc3_)
                  {
                     this.txtDialog.wordWrap = true;
                     this.txtDialog.width = _loc3_;
                     if(this.canSnap())
                     {
                        this._isResizable = false;
                     }
                     this.isMaxWidth = true;
                  }
               }
            }
         }
         this.txtDialog.x = -Math.round(this.getTxtWidth() * 0.5);
      }
      
      private function updateIcons() : void
      {
      }
      
      private function onPlay(param1:MouseEvent) : void
      {
         Sounds.play(this.getSound());
      }
      
      private function getTxtWidth() : Number
      {
         return Math.round(this.txtDialog.width);
      }
      
      private function getTxtHeight() : Number
      {
         var _loc1_:Number = Math.round(this.txtDialog.height);
         if(this.isUnicode() && Fonts.addPadding)
         {
            _loc1_ -= this.getExtraPadding();
         }
         return _loc1_;
      }
      
      private function getExtraPadding() : Number
      {
         return this.getFontSize() + this.getLeading();
      }
      
      public function getLeading() : int
      {
         return this.leading;
      }
      
      public function setLeading(param1:int, param2:Boolean = true) : void
      {
         this.leading = param1;
         if(!this.isProp())
         {
            recentLeading = this.getLeading();
         }
         if(param2)
         {
            this.applyStyles();
         }
      }
      
      public function getPadding() : int
      {
         return this.padding;
      }
      
      public function setPadding(param1:int, param2:Boolean = true) : void
      {
         this.padding = param1;
         if(!this.isProp())
         {
            recentPadding = this.getPadding();
         }
         if(param2)
         {
            this.drawBubble();
            this.updateEditor();
         }
      }
      
      public function setSilhouette(param1:Boolean, param2:Boolean = true) : void
      {
         this._silhouette = param1;
         recentSilhouette = this.getSilhouette();
         if(param2)
         {
            this.updateColors();
            this.drawBubble();
         }
      }
      
      public function getSilhouette() : Boolean
      {
         return this._silhouette;
      }
      
      private function getMetrics() : Object
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Rectangle = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(Template.isActive() && this.isEmpty() && !(Editor.self.mode == Editor.MODE_EXPR && Editor.self.selector.target == this))
         {
            _loc1_ = 24;
            _loc2_ = 16;
            _loc4_ = -_loc1_;
            _loc6_ = _loc1_;
            _loc5_ = -6;
            _loc7_ = _loc2_ * 2 - 6;
         }
         else
         {
            _loc3_ = this.txtDialog.getBounds(this);
            if(this.isMaxWidth)
            {
               _loc4_ = -Math.round(maxWidth * 0.5) - 2;
               _loc6_ = Math.round(maxWidth * 0.5) + 2;
               _loc5_ = _loc3_.y - this.getPadding() - 1;
               _loc7_ = _loc3_.bottom + this.getPadding() + 1;
            }
            else
            {
               _loc4_ = _loc3_.x - this.getPadding() - 1;
               _loc6_ = _loc3_.right + this.getPadding() + 1;
               _loc5_ = _loc3_.y - this.getPadding();
               _loc7_ = _loc3_.bottom + this.getPadding();
            }
            if(this.isEmpty())
            {
               _loc4_ -= 15;
               _loc6_ += 15;
            }
            if(this.isUnicode() && Fonts.addPadding)
            {
               _loc7_ -= this.getExtraPadding();
            }
         }
         return {
            "x1":_loc4_,
            "y1":_loc5_,
            "x2":_loc6_,
            "y2":_loc7_
         };
      }
      
      public function drawBubble(param1:Point = null, param2:Boolean = false) : void
      {
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Point = null;
         var _loc18_:Point = null;
         var _loc19_:Point = null;
         var _loc20_:Object = null;
         var _loc21_:Object = null;
         var _loc22_:Object = null;
         var _loc23_:Object = null;
         var _loc27_:uint = 0;
         var _loc28_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:uint = 0;
         var _loc38_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc43_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc45_:Number = NaN;
         var _loc46_:Number = NaN;
         var _loc47_:Number = NaN;
         var _loc48_:Number = NaN;
         var _loc49_:Number = NaN;
         var _loc51_:Object = null;
         var _loc52_:Object = null;
         var _loc53_:Object = null;
         var _loc54_:Object = null;
         var _loc55_:Object = null;
         var _loc57_:Number = NaN;
         var _loc60_:uint = 0;
         var _loc61_:uint = 0;
         var _loc63_:Number = NaN;
         var _loc64_:Number = NaN;
         var _loc65_:Object = null;
         var _loc66_:Boolean = false;
         var _loc67_:Boolean = false;
         var _loc68_:uint = 0;
         var _loc69_:uint = 0;
         var _loc70_:Object = null;
         var _loc71_:Object = null;
         var _loc72_:Object = null;
         var _loc73_:Object = null;
         var _loc74_:Number = NaN;
         var _loc75_:uint = 0;
         var _loc76_:uint = 0;
         if(!this._ready || parent == null)
         {
            return;
         }
         var _loc3_:Boolean = false;
         var _loc4_:Number = Number.POSITIVE_INFINITY;
         var _loc5_:Number = Number.NEGATIVE_INFINITY;
         var _loc6_:Number = Number.POSITIVE_INFINITY;
         var _loc7_:Number = Number.NEGATIVE_INFINITY;
         var _loc10_:Object = this.getMetrics();
         var _loc11_:Graphics = this.bubble.graphics;
         this.O = {
            "x":_loc10_.x1 + (_loc10_.x2 - _loc10_.x1) * 0.5,
            "y":_loc10_.y1 + (_loc10_.y2 - _loc10_.y1) * 0.5
         };
         this.A = {
            "x":_loc10_.x1,
            "y":_loc10_.y1
         };
         this.B = {
            "x":_loc10_.x2,
            "y":_loc10_.y1
         };
         this.C = {
            "x":_loc10_.x2,
            "y":_loc10_.y2
         };
         this.D = {
            "x":_loc10_.x1,
            "y":_loc10_.y2
         };
         if(param1 != null)
         {
            if(this.target != null)
            {
               _loc65_ = this.calculateOffset(param1);
               _loc17_ = this.globalToLocal(this.applyOffset(_loc65_));
            }
            else
            {
               _loc17_ = this.globalToLocal(param1);
            }
         }
         else if(this.target != null)
         {
            if(this.offset != null)
            {
               _loc17_ = this.globalToLocal(this.applyOffset(this.offset));
            }
            else
            {
               _loc17_ = this.globalToLocal(this.target.getAttachPos());
            }
         }
         var _loc24_:Number = Math.abs(this.A.x - this.C.x);
         var _loc25_:Number = Math.abs(this.A.y - this.C.y);
         var _loc26_:Number = 0;
         var _loc29_:Number = Math.PI * (3 * _loc24_ + 3 * _loc25_ - Math.sqrt((_loc24_ + 3 * _loc25_) * (_loc25_ + 3 * _loc24_)));
         if(this.shapeMode == SHAPE_ROUNDED)
         {
            _loc28_ = Math.max(8,this.getFontSize() * 8 / 16);
            _loc27_ = Math.max(5,Math.ceil(Math.PI * _loc28_ / 8)) * 4 + 4;
         }
         else if(this.shapeMode == SHAPE_NOTCHED)
         {
            _loc28_ = Math.max(8,this.getFontSize() * 8 / 16);
            _loc27_ = 12;
         }
         else if(this.shapeMode == SHAPE_RECT || this.shapeMode == SHAPE_NONE)
         {
            _loc28_ = 0;
            _loc27_ = 4;
         }
         else if(this.shapeMode == SHAPE_OVAL)
         {
            _loc28_ = 0;
            _loc27_ = Math.max(32,Math.floor(_loc29_ / 8));
         }
         else if(this.shapeMode == SHAPE_SPIKY || this.shapeMode == SHAPE_SPIKY_R)
         {
            _loc27_ = Math.max(11,Math.round(_loc29_ / this.getFontSize() * 0.5)) * 2;
            _loc28_ = Math.round(Math.sqrt(_loc29_ / _loc27_) * (this.shapeMode == SHAPE_SPIKY_R ? 3 : 2));
         }
         else if(this.shapeMode == SHAPE_CLOUD || this.shapeMode == SHAPE_CLOUD_R)
         {
            _loc27_ = Math.max(7,Math.round(_loc29_ / Math.max(12,this.getFontSize()) * 0.2)) * 2;
            _loc28_ = Math.round(Math.sqrt(_loc29_ / _loc27_) * 2);
         }
         if(this.shapeMode == SHAPE_CLOUD_R || this.shapeMode == SHAPE_SPIKY_R)
         {
            _loc26_ = 1;
         }
         var _loc32_:Number = 360 / _loc27_;
         var _loc39_:Number = Math.abs(this.A.y - this.O.y);
         var _loc40_:Number = Math.abs(this.B.x - this.O.x);
         var _loc41_:* = false;
         var _loc50_:Array = [];
         var _loc56_:Boolean = this.hasSpikeThickness();
         var _loc58_:Boolean = Utils.inArray(this.shapeMode,[SHAPE_CLOUD,SHAPE_CLOUD_R]);
         var _loc59_:Number = this.getSpikeRadius(_loc29_);
         var _loc62_:int = -1;
         _loc11_.clear();
         _loc11_.lineStyle(this.borderSize,this.borderColor,1,false,LINE_SCALE,LINE_CAPS,LINE_JOINTS,LINE_MITERLIMIT);
         this.spike.graphics.clear();
         _loc33_ = ((_loc38_ = Math.sqrt(Math.pow(this.B.x - this.O.x,2) + Math.pow(this.B.y - this.O.y,2))) - Math.max(_loc39_,_loc40_)) * 0.5;
         _loc40_ += _loc33_;
         _loc39_ += _loc33_;
         randomizer.reset();
         _loc37_ = 0;
         while(_loc37_ <= _loc27_)
         {
            _loc42_ = _loc37_ * _loc32_;
            if(isNaN(_loc43_) || _loc37_ == _loc27_)
            {
               _loc42_ = _loc37_ * _loc32_;
               _loc44_ = _loc28_;
            }
            else
            {
               if(!_loc58_ && _loc26_ > 0 && _loc37_ % 2 == 0 && !isNaN(_loc57_))
               {
                  _loc57_ = (_loc42_ = _loc43_ + _loc57_) - _loc43_;
               }
               else
               {
                  _loc42_ = (_loc37_ + _loc26_ * (randomizer.nextDouble() - 0.5) * 0.8) * _loc32_;
               }
               _loc44_ = _loc28_ * (_loc42_ - _loc43_) / _loc32_;
            }
            _loc30_ = Utils.d2r(_loc42_);
            if(this.shapeMode == SHAPE_ROUNDED || this.shapeMode == SHAPE_NOTCHED)
            {
               _loc60_ = _loc37_ % (_loc27_ / 4);
               _loc61_ = Math.floor(_loc37_ / (_loc27_ / 4));
               if(this.shapeMode == SHAPE_ROUNDED)
               {
                  _loc42_ = _loc60_ / (_loc27_ / 4 - 1) * 90;
                  if(_loc61_ % 2 == 0)
                  {
                     _loc42_ = 90 - _loc42_;
                  }
                  _loc30_ = Utils.d2r(_loc42_);
                  switch(_loc61_)
                  {
                     case 4:
                     case 0:
                        if(this.flushCorner[TOP_RIGHT])
                        {
                           _loc35_ = this.B.x;
                           _loc36_ = this.B.y;
                        }
                        else
                        {
                           _loc35_ = this.B.x - _loc28_ + Math.cos(_loc30_) * _loc28_;
                           _loc36_ = this.B.y + _loc28_ - Math.sin(_loc30_) * _loc28_;
                        }
                        break;
                     case 1:
                        if(this.flushCorner[BOTTOM_RIGHT])
                        {
                           _loc35_ = this.C.x;
                           _loc36_ = this.C.y;
                        }
                        else
                        {
                           _loc35_ = this.C.x - _loc28_ + Math.cos(_loc30_) * _loc28_;
                           _loc36_ = this.C.y - _loc28_ + Math.sin(_loc30_) * _loc28_;
                        }
                        break;
                     case 2:
                        if(this.flushCorner[BOTTOM_LEFT])
                        {
                           _loc35_ = this.D.x;
                           _loc36_ = this.D.y;
                        }
                        else
                        {
                           _loc35_ = this.D.x + _loc28_ - Math.cos(_loc30_) * _loc28_;
                           _loc36_ = this.D.y - _loc28_ + Math.sin(_loc30_) * _loc28_;
                        }
                        break;
                     case 3:
                        if(this.flushCorner[TOP_LEFT])
                        {
                           _loc35_ = this.A.x;
                           _loc36_ = this.A.y;
                        }
                        else
                        {
                           _loc35_ = this.A.x + _loc28_ - Math.cos(_loc30_) * _loc28_;
                           _loc36_ = this.A.y + _loc28_ - Math.sin(_loc30_) * _loc28_;
                        }
                  }
               }
               else
               {
                  _loc63_ = Math.floor(_loc60_ / (_loc27_ / 4 - 1));
                  _loc64_ = Math.ceil(_loc60_ / (_loc27_ / 4 - 1));
                  switch(_loc61_)
                  {
                     case 4:
                     case 0:
                        _loc35_ = this.B.x - _loc28_ * NOTCH_FACTOR * (1 - _loc63_);
                        _loc36_ = this.B.y + _loc28_ * NOTCH_FACTOR * _loc64_;
                        break;
                     case 1:
                        _loc35_ = this.C.x - _loc28_ * NOTCH_FACTOR * _loc64_;
                        _loc36_ = this.C.y - _loc28_ * NOTCH_FACTOR * (1 - _loc63_);
                        break;
                     case 2:
                        _loc35_ = this.D.x + _loc28_ * NOTCH_FACTOR * (1 - _loc63_);
                        _loc36_ = this.D.y - _loc28_ * NOTCH_FACTOR * _loc64_;
                        break;
                     case 3:
                        _loc35_ = this.A.x + _loc28_ * NOTCH_FACTOR * _loc64_;
                        _loc36_ = this.A.y + _loc28_ * NOTCH_FACTOR * (1 - _loc63_);
                  }
               }
            }
            else if(this.shapeMode == SHAPE_RECT || this.shapeMode == SHAPE_NONE)
            {
               switch(_loc37_)
               {
                  case 4:
                  case 0:
                     _loc35_ = this.A.x;
                     _loc36_ = this.A.y;
                     break;
                  case 1:
                     _loc35_ = this.B.x;
                     _loc36_ = this.B.y;
                     break;
                  case 2:
                     _loc35_ = this.C.x;
                     _loc36_ = this.C.y;
                     break;
                  case 3:
                     _loc35_ = this.D.x;
                     _loc36_ = this.D.y;
               }
            }
            else if(_loc58_)
            {
               _loc35_ = this.O.x + Math.cos(_loc30_) * _loc40_;
               _loc36_ = this.O.y + Math.sin(_loc30_) * _loc39_;
            }
            else
            {
               _loc35_ = this.O.x + Math.cos(_loc30_) * (_loc40_ + (!!_loc41_ ? _loc44_ : 0));
               _loc36_ = this.O.y + Math.sin(_loc30_) * (_loc39_ + (!!_loc41_ ? _loc44_ : 0));
            }
            if(_loc17_ != null)
            {
               _loc34_ = (_loc31_ = Math.atan2(_loc17_.y - this.O.y,_loc17_.x - this.O.x)) - Math.PI * 0.5;
               _loc20_ = {
                  "x":this.O.x + Math.cos(_loc34_) * _loc59_,
                  "y":this.O.y + Math.sin(_loc34_) * _loc59_
               };
               _loc22_ = {
                  "x":_loc17_.x + Math.cos(_loc34_) * _loc59_,
                  "y":_loc17_.y + Math.sin(_loc34_) * _loc59_
               };
               _loc34_ += Math.PI;
               _loc21_ = {
                  "x":this.O.x + Math.cos(_loc34_) * _loc59_,
                  "y":this.O.y + Math.sin(_loc34_) * _loc59_
               };
               _loc23_ = {
                  "x":_loc17_.x + Math.cos(_loc34_) * _loc59_,
                  "y":_loc17_.y + Math.sin(_loc34_) * _loc59_
               };
               _loc19_ = new Point(_loc35_,_loc36_);
               if(_loc18_ != null)
               {
                  if(_loc53_ == null)
                  {
                     _loc12_ = Utils.getIntersection2(_loc20_,_loc22_,_loc18_,_loc19_);
                     if(_loc3_ && _loc12_ != null)
                     {
                        this.spike.graphics.lineStyle(this.borderSize,65280,1,false,LINE_SCALE,LINE_CAPS,LINE_JOINTS,LINE_MITERLIMIT);
                        this.spike.graphics.moveTo(_loc20_.x,_loc20_.y);
                        this.spike.graphics.lineTo(_loc22_.x,_loc22_.y);
                        this.spike.graphics.lineStyle(this.borderSize,65535,1,false,LINE_SCALE,LINE_CAPS,LINE_JOINTS,LINE_MITERLIMIT);
                        this.spike.graphics.moveTo(_loc18_.x,_loc18_.y);
                        this.spike.graphics.lineTo(_loc19_.x,_loc19_.y);
                     }
                     if(_loc12_ != null)
                     {
                        _loc53_ = {
                           "x":_loc12_.x,
                           "y":_loc12_.y,
                           "spikeStart":true
                        };
                        _loc50_.push(_loc53_);
                        if(_loc3_)
                        {
                           this.spike.graphics.lineStyle(this.borderSize,16711680,1,false,LINE_SCALE,LINE_CAPS,LINE_JOINTS,LINE_MITERLIMIT);
                           this.spike.graphics.drawCircle(this.O.x,this.O.y,this.getSpikeRadius(_loc29_));
                           this.spike.graphics.drawCircle(_loc17_.x,_loc17_.y,this.getSpikeRadius(_loc29_));
                           this.spike.graphics.drawCircle(_loc53_.x,_loc53_.y,3);
                        }
                        if(_loc54_ != null)
                        {
                           break;
                        }
                     }
                  }
                  if(_loc54_ == null)
                  {
                     if((_loc13_ = Utils.getIntersection2(_loc21_,_loc23_,_loc18_,_loc19_)) != null)
                     {
                        _loc54_ = {
                           "x":_loc13_.x,
                           "y":_loc13_.y,
                           "spikeEnd":true
                        };
                        if(_loc53_ == null)
                        {
                           _loc62_ = _loc50_.length;
                        }
                        _loc50_.push(_loc54_);
                        if(_loc3_)
                        {
                           this.spike.graphics.lineStyle(this.borderSize,16711680,1,false,LINE_SCALE,LINE_CAPS,LINE_JOINTS,LINE_MITERLIMIT);
                           this.spike.graphics.drawCircle(_loc54_.x,_loc54_.y,3);
                           this.spike.graphics.lineStyle(this.borderSize,255,1,false,LINE_SCALE,LINE_CAPS,LINE_JOINTS,LINE_MITERLIMIT);
                           this.spike.graphics.moveTo(_loc21_.x,_loc21_.y);
                           this.spike.graphics.lineTo(_loc23_.x,_loc23_.y);
                           this.spike.graphics.lineStyle(this.borderSize,65535,1,false,LINE_SCALE,LINE_CAPS,LINE_JOINTS,LINE_MITERLIMIT);
                           this.spike.graphics.moveTo(_loc18_.x,_loc18_.y);
                           this.spike.graphics.lineTo(_loc19_.x,_loc19_.y);
                        }
                     }
                  }
               }
               _loc18_ = _loc19_;
            }
            _loc51_ = {
               "x":_loc35_,
               "y":_loc36_
            };
            if(_loc35_ < _loc4_)
            {
               _loc4_ = _loc35_;
            }
            else if(_loc35_ > _loc5_)
            {
               _loc5_ = _loc35_;
            }
            if(_loc36_ < _loc6_)
            {
               _loc6_ = _loc36_;
            }
            else if(_loc36_ > _loc7_)
            {
               _loc7_ = _loc36_;
            }
            if(_loc58_)
            {
               this.addControlPoint(_loc51_,this.O,_loc40_,_loc39_,_loc42_,_loc43_,_loc44_,_loc32_);
            }
            _loc50_.push(_loc51_);
            _loc41_ = !_loc41_;
            _loc43_ = _loc42_;
            _loc45_ = _loc44_;
            _loc37_++;
         }
         if(_loc53_ != null && _loc54_ != null)
         {
            _loc55_ = {
               "x":(_loc53_.x + _loc54_.x) * 0.5,
               "y":(_loc53_.y + _loc54_.y) * 0.5
            };
            _loc15_ = Utils.distanceBetween(_loc17_,_loc55_);
            _loc16_ = this.spikeMode == SPIKE_THOUGHT ? Number(0.8) : Number(SPIKE_LENGTH_RATIO);
            if(param1 != null || this.offset != null)
            {
               _loc14_ = 1;
            }
            else if(_loc15_ * _loc16_ < MIN_SPIKE_LENGTH)
            {
               _loc14_ = MIN_SPIKE_LENGTH / _loc15_;
            }
            else if(_loc15_ * _loc16_ > MAX_SPIKE_LENGTH)
            {
               _loc14_ = MAX_SPIKE_LENGTH / _loc15_;
            }
            else
            {
               _loc14_ = _loc16_;
            }
            this.spikeEnd = {
               "rx":_loc55_.x,
               "ry":_loc55_.y,
               "x":_loc55_.x + (_loc17_.x - _loc55_.x) * _loc14_,
               "y":_loc55_.y + (_loc17_.y - _loc55_.y) * _loc14_
            };
         }
         if(this.shapeMode == SHAPE_NONE)
         {
            this.bubbleBoundsStage = this.txtDialog.getBounds(stage);
         }
         else
         {
            _loc11_.beginFill(this.fillColor,1);
            _loc66_ = true;
            _loc67_ = false;
            _loc69_ = _loc50_.length;
            _loc68_ = 0;
            while(_loc68_ < _loc69_)
            {
               if(!(_loc56_ && _loc62_ > 0 && _loc53_ != null && _loc68_ < _loc62_))
               {
                  _loc51_ = _loc50_[_loc68_];
                  if(!(_loc56_ && _loc67_ && _loc54_ != null && _loc51_.spikeEnd == null))
                  {
                     if(_loc66_)
                     {
                        _loc66_ = false;
                        _loc11_.moveTo(_loc51_.x,_loc51_.y);
                     }
                     else if(_loc51_.cx != null)
                     {
                        _loc11_.curveTo(_loc51_.cx,_loc51_.cy,_loc51_.x,_loc51_.y);
                     }
                     else if(!_loc58_)
                     {
                        _loc11_.lineTo(_loc51_.x,_loc51_.y);
                     }
                     if(_loc56_ && _loc51_.spikeStart != null && _loc53_ != null && _loc54_ != null)
                     {
                        _loc51_ = _loc53_;
                        _loc52_ = _loc54_;
                        _loc67_ = true;
                        if(this.spikeMode == SPIKE_STRAIGHT)
                        {
                           _loc11_.lineTo(this.spikeEnd.x,this.spikeEnd.y);
                           _loc11_.lineTo(_loc52_.x,_loc52_.y);
                        }
                        else if(this.spikeMode == SPIKE_CURVED)
                        {
                           _loc70_ = {
                              "x":_loc51_.x + (_loc17_.x - _loc51_.x) * _loc14_ * 0.5,
                              "y":_loc51_.y + (_loc17_.y - _loc51_.y) * _loc14_ * 0.5
                           };
                           _loc71_ = {
                              "x":_loc52_.x + (_loc17_.x - _loc52_.x) * _loc14_ * 0.5,
                              "y":_loc52_.y + (_loc17_.y - _loc52_.y) * _loc14_ * 0.5
                           };
                           if(this.O.x > _loc17_.x)
                           {
                              _loc72_ = {
                                 "x":_loc70_.x + (_loc70_.x - _loc71_.x) * 0.5,
                                 "y":_loc70_.y + (_loc70_.y - _loc71_.y) * 0.5
                              };
                              _loc11_.curveTo(_loc72_.x,_loc72_.y,this.spikeEnd.x,this.spikeEnd.y);
                              _loc11_.curveTo(_loc70_.x,_loc70_.y,_loc52_.x,_loc52_.y);
                           }
                           else
                           {
                              _loc72_ = {
                                 "x":_loc71_.x + (_loc71_.x - _loc70_.x) * 0.5,
                                 "y":_loc71_.y + (_loc71_.y - _loc70_.y) * 0.5
                              };
                              _loc11_.curveTo(_loc71_.x,_loc71_.y,this.spikeEnd.x,this.spikeEnd.y);
                              _loc11_.curveTo(_loc72_.x,_loc72_.y,_loc52_.x,_loc52_.y);
                           }
                        }
                        else if(this.spikeMode == SPIKE_JAGGED)
                        {
                           _loc70_ = {
                              "x":_loc51_.x + (_loc17_.x - _loc51_.x) * _loc14_ * 0.5,
                              "y":_loc51_.y + (_loc17_.y - _loc51_.y) * _loc14_ * 0.5
                           };
                           _loc71_ = {
                              "x":_loc52_.x + (_loc17_.x - _loc52_.x) * _loc14_ * 0.5,
                              "y":_loc52_.y + (_loc17_.y - _loc52_.y) * _loc14_ * 0.5
                           };
                           _loc72_ = {
                              "x":_loc70_.x + (_loc70_.x - _loc71_.x) * 0.5,
                              "y":_loc70_.y + (_loc70_.y - _loc71_.y) * 0.5
                           };
                           _loc73_ = {
                              "x":_loc71_.x + (_loc71_.x - _loc70_.x) * 0.5,
                              "y":_loc71_.y + (_loc71_.y - _loc70_.y) * 0.5
                           };
                           if(this.O.x > _loc17_.x)
                           {
                              _loc11_.curveTo(_loc71_.x,_loc71_.y,_loc70_.x,_loc70_.y);
                              _loc11_.curveTo(_loc72_.x,_loc72_.y,this.spikeEnd.x,this.spikeEnd.y);
                              _loc11_.curveTo(_loc70_.x,_loc70_.y,_loc71_.x,_loc71_.y);
                              _loc11_.curveTo(_loc73_.x,_loc73_.y,_loc52_.x,_loc52_.y);
                           }
                           else
                           {
                              _loc11_.curveTo(_loc72_.x,_loc72_.y,_loc70_.x,_loc70_.y);
                              _loc11_.curveTo(_loc71_.x,_loc71_.y,this.spikeEnd.x,this.spikeEnd.y);
                              _loc11_.curveTo(_loc73_.x,_loc73_.y,_loc71_.x,_loc71_.y);
                              _loc11_.curveTo(_loc70_.x,_loc70_.y,_loc52_.x,_loc52_.y);
                           }
                        }
                     }
                     if(_loc51_.spikeEnd != null)
                     {
                        _loc67_ = false;
                     }
                  }
               }
               _loc68_++;
            }
            _loc11_.endFill();
            _loc8_ = this.bubble.localToGlobal(new Point(_loc4_,_loc6_));
            _loc9_ = this.bubble.localToGlobal(new Point(_loc5_,_loc7_));
            this.bubbleBoundsStage = new Rectangle(_loc8_.x,_loc8_.y,_loc9_.x - _loc8_.x,_loc9_.y - _loc8_.y);
            _loc8_ = parent.globalToLocal(_loc8_);
            _loc9_ = parent.globalToLocal(_loc9_);
         }
         this.bubbleBounds = Utils.rectGlobalToLocal(this.bubbleBoundsStage,this);
         if(_loc55_ != null)
         {
            switch(this.spikeMode)
            {
               case SPIKE_LINE:
                  _loc11_.moveTo(_loc55_.x,_loc55_.y);
                  _loc11_.lineTo(this.spikeEnd.x,this.spikeEnd.y);
                  break;
               case SPIKE_THOUGHT:
                  _loc51_ = _loc55_;
                  _loc74_ = Point.distance(new Point(_loc51_.x,_loc51_.y),new Point(this.spikeEnd.x,this.spikeEnd.y));
                  _loc76_ = Math.max(Math.floor(_loc74_ / (BUBBLE_FACTOR + 2 * (this.borderSize - 1))),3);
                  _loc75_ = 0;
                  while(_loc75_ < _loc76_)
                  {
                     _loc11_.beginFill(this.fillColor);
                     _loc11_.lineStyle(this.borderSize,this.borderColor,1,false,LINE_SCALE,LINE_CAPS,LINE_JOINTS,LINE_MITERLIMIT);
                     _loc11_.drawCircle(_loc51_.x + (this.spikeEnd.x - _loc51_.x) * (_loc75_ + 0.75) / _loc76_,_loc51_.y + (this.spikeEnd.y - _loc51_.y) * (_loc75_ + 0.75) / _loc76_,BUBBLE_RADIUS_MAX - (BUBBLE_RADIUS_MAX - BUBBLE_RADIUS_MIN) * _loc75_ / _loc76_ + (this.borderSize - 1));
                     _loc11_.endFill();
                     _loc75_++;
                  }
            }
         }
         this.updateIcons();
         this.updateSelect(param2);
      }
      
      private function addControlPoint(param1:Object, param2:Object, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void
      {
         var _loc9_:Number = Utils.d2r((param5 + param6) * 0.5);
         param1.cx = param2.x + Math.cos(_loc9_) * (param3 + param7 * Math.sqrt((param5 - param6) / param8 * 0.5));
         param1.cy = param2.y + Math.sin(_loc9_) * (param4 + param7 * Math.sqrt((param5 - param6) / param8 * 0.5));
      }
      
      private function getSpikeRadius(param1:Number) : Number
      {
         return Utils.limit(Math.sqrt(param1) * 0.25,5,20);
      }
      
      public function getSpikePos() : Point
      {
         if(this.spikeEnd == null)
         {
            return this.getAttachPos();
         }
         return this.spike.localToGlobal(new Point(this.spikeEnd.x,this.spikeEnd.y));
      }
      
      public function getSpikeBase() : Point
      {
         if(this.spikeEnd == null)
         {
            return this.getAttachPos();
         }
         return this.spike.localToGlobal(new Point(this.spikeEnd.rx,this.spikeEnd.ry));
      }
      
      public function getRemovePos() : Point
      {
         if(this.target != null)
         {
            return this.target.getAttachPos();
         }
         return null;
      }
      
      override public function getAttachPos() : Point
      {
         return new Point(this.bubbleBoundsStage.x + this.bubbleBoundsStage.width * 0.5,this.bubbleBoundsStage.bottomRight.y);
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function get offset() : Object
      {
         return this._targetOffset;
      }
      
      public function set offset(param1:Object) : void
      {
         this._targetOffset = param1;
      }
      
      public function get borderSize() : Number
      {
         return this._borderSize;
      }
      
      public function set borderSize(param1:Number) : *
      {
         this._borderSize = param1;
         recentBorderSize = param1;
      }
      
      private function applyOffset(param1:Object) : Point
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         if(param1.x != null)
         {
            _loc2_ = new Point(param1.x,param1.y);
            return this.target.localToGlobal(_loc2_);
         }
         _loc2_ = this.target.getAttachPos();
         _loc3_ = this.localToGlobal(new Point(0,0));
         _loc4_ = _loc2_.y - _loc3_.y;
         _loc5_ = _loc2_.x - _loc3_.x;
         _loc6_ = _loc3_.x + _loc5_ * param1.ratio;
         _loc7_ = _loc3_.y + _loc4_ * param1.ratio;
         _loc8_ = Utils.d2r(param1.angle);
         _loc9_ = Math.cos(_loc8_) * (_loc6_ - _loc2_.x) - Math.sin(_loc8_) * (_loc7_ - _loc2_.y) + _loc2_.x;
         _loc10_ = Math.sin(_loc8_) * (_loc6_ - _loc2_.x) + Math.cos(_loc8_) * (_loc7_ - _loc2_.y) + _loc2_.y;
         return new Point(_loc9_,_loc10_);
      }
      
      public function setOffset(param1:Point) : void
      {
         this.offset = this.calculateOffset(param1);
      }
      
      private function calculateOffset(param1:Point) : Object
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         if(this.target is Photo)
         {
            _loc2_ = this.target.globalToLocal(param1);
            return {
               "x":_loc2_.x,
               "y":_loc2_.y
            };
         }
         _loc2_ = this.target.getAttachPos();
         _loc3_ = this.localToGlobal(new Point(0,0));
         _loc4_ = _loc3_.y - _loc2_.y;
         _loc5_ = _loc3_.x - _loc2_.x;
         _loc6_ = param1.y - _loc2_.y;
         _loc7_ = param1.x - _loc2_.x;
         if(_loc5_ == 0 || _loc7_ == 0 || _loc4_ == 0)
         {
            _loc10_ = 0;
            _loc14_ = 1;
         }
         else
         {
            _loc8_ = Math.atan2(_loc4_,_loc5_);
            _loc10_ = (_loc9_ = Math.atan2(_loc6_,_loc7_)) - _loc8_;
            _loc12_ = Math.cos(-_loc10_) * (param1.x - _loc2_.x) - Math.sin(-_loc10_) * (param1.y - _loc2_.y) + _loc2_.x;
            _loc13_ = (_loc11_ = Math.sin(-_loc10_) * (param1.x - _loc2_.x) + Math.cos(-_loc10_) * (param1.y - _loc2_.y) + _loc2_.y) - _loc2_.y;
            _loc14_ = Utils.limit(1 - _loc13_ / _loc4_,0.2,1);
         }
         _loc10_ = Utils.r2d(_loc10_);
         return {
            "angle":_loc10_,
            "ratio":_loc14_
         };
      }
      
      public function set target(param1:Asset) : void
      {
         if(param1 == null)
         {
            if(this._targetAsset != null)
            {
               this._targetAsset.unlinkTarget(this);
            }
            this.offset = null;
         }
         else
         {
            param1.linkTarget(this);
         }
         this._targetAsset = param1;
         this.drawBubble();
      }
      
      public function get target() : Asset
      {
         return this._targetAsset;
      }
      
      public function getTargetIndex() : int
      {
         if(this.target == null || this.target.parent == null || this.isProp())
         {
            return -1;
         }
         return this.target.parent.getChildIndex(this.target);
      }
      
      public function incrementStyle(param1:Boolean = true) : void
      {
         var _loc2_:uint = (this.getFeature(FEATURE_STYLE) + 1) % (STYLE_MAX + 1);
         this.setStyle(FEATURE_STYLE,_loc2_);
         if(param1)
         {
            this.applyStyles();
         }
      }
      
      public function setColor(param1:uint, param2:uint = 0, param3:Boolean = true) : void
      {
         if(param2 == 0)
         {
            param2 = param1 == BKGD ? uint(Palette.WHITE_ID) : uint(Palette.BLACK_ID);
         }
         switch(param1)
         {
            case TEXT:
               this.setStyle(FEATURE_COLOR,param2);
               recentColor[param1] = param2;
               this.updateColors();
               if(param3)
               {
                  this.applyStyles();
               }
               break;
            case BORDER:
               this.borderColorID = param2;
               recentColor[param1] = param2;
               if(param3)
               {
                  this.updateColors();
                  this.onUpdateText();
               }
               break;
            case BKGD:
            default:
               this.bkgdColorID = param2;
               recentColor[param1] = param2;
               if(param3)
               {
                  this.updateColors();
                  this.onUpdateText();
               }
         }
      }
      
      private function getStyles() : Object
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this.styles.length;
         var _loc3_:Object = {};
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.styles[_loc1_] != null)
            {
               _loc3_[_loc1_.toString()] = this.styles[_loc1_];
            }
            _loc1_++;
         }
         return Utils.encode(_loc3_);
      }
      
      public function getData() : Object
      {
         return {
            "x":x,
            "y":y,
            "w":this.txtDialog.width,
            "h":this.getTxtHeight(),
            "z":(!!this.isProp() ? zIndex : parent.getChildIndex(this)),
            "r":rotation,
            "t":createTextParts({
               "text":this.text,
               "url":this._linkURL
            }),
            "tgt":this.getTargetIndex(),
            "s":this.spikeMode,
            "sm":this.shapeMode,
            "sz":this.sizeMode,
            "k":this.bkgdColorID,
            "ff":this.getFontList().join("|"),
            "st":this.getStyles(),
            "p":this.getPadding(),
            "sh":(!!this.getSilhouette() ? 1 : 0),
            "pr":(!!this.isProp() ? 1 : 0),
            "sd":this.getSound(),
            "ex":Utils.encode(this.getExtraData())
         };
      }
      
      private function getExtraData() : Object
      {
         var _loc1_:Object = {};
         _loc1_.size = size;
         if(this.offset != null)
         {
            _loc1_.o = this.offset;
         }
         _loc1_.b = this.borderSize;
         _loc1_.bc = this.borderColorID;
         _loc1_.l = this.leading;
         _loc1_.a = this.getTextAlign();
         return _loc1_;
      }
      
      private function setExtraData(param1:String) : void
      {
         var _loc2_:Object = Utils.decode(param1);
         if(_loc2_ != null)
         {
            this.size = _loc2_.size;
            if(_loc2_.o != null)
            {
               this.offset = _loc2_.o;
            }
            if(_loc2_.b != null)
            {
               this.borderSize = _loc2_.b;
            }
            if(_loc2_.bc != null)
            {
               this.borderColorID = _loc2_.bc;
            }
            if(_loc2_.l != null)
            {
               this.leading = _loc2_.l;
            }
            if(_loc2_.a != null)
            {
               this.setTextAlign(_loc2_.a);
            }
            else
            {
               this.setTextAlign(ALIGN_CENTER);
            }
         }
         else
         {
            this.size = parseInt(param1);
         }
      }
      
      public function getAnimationPositionData() : Object
      {
         return {
            "x":x,
            "y":y
         };
      }
      
      private function hasSpikeThickness() : Boolean
      {
         return !Utils.inArray(this.spikeMode,[SPIKE_THOUGHT,SPIKE_LINE]);
      }
      
      public function setShapeMode(param1:int = -1, param2:Boolean = true, param3:Boolean = true, param4:Boolean = false) : void
      {
         if(param1 == -1)
         {
            param1 = SHAPE_ROUNDED;
         }
         if(param3 && Globals.isLocked(getLock(Globals.BUBBLE_SHAPE,param1)) && TeamRole.can(TeamRole.DIALOG))
         {
            param1 = SHAPE_ROUNDED;
            Editor.warnFeatureLoss();
         }
         if(param4 && this.shapeMode != param1)
         {
            if(param1 == SHAPE_CLOUD || param1 == SHAPE_CLOUD_R)
            {
               this.setSpikeMode(SPIKE_THOUGHT,false,param3);
            }
            else if(param1 == SHAPE_NONE)
            {
               this.setSpikeMode(SPIKE_LINE,false,param3);
            }
            else if(param1 == SHAPE_NOTCHED)
            {
               this.setSpikeMode(SPIKE_STRAIGHT,false,param3);
            }
            else if(this.spikeMode == SPIKE_THOUGHT)
            {
               this.setSpikeMode(SPIKE_STRAIGHT,false,param3);
            }
         }
         this.shapeMode = param1;
         if(param1 != SHAPE_NONE)
         {
            recentShapeMode = param1;
         }
         if(param2)
         {
            this.drawBubble();
            this.updateEditor();
         }
      }
      
      public function setSpikeMode(param1:int = -1, param2:Boolean = true, param3:Boolean = true) : void
      {
         if(param1 == -1)
         {
            param1 = SPIKE_STRAIGHT;
         }
         if(param3 && Globals.isLocked(getLock(Globals.BUBBLE_SPIKE,param1)) && TeamRole.can(TeamRole.DIALOG))
         {
            param1 = SPIKE_STRAIGHT;
            Editor.warnFeatureLoss();
         }
         this.spikeMode = param1;
         recentSpikeMode = param1;
         if(param2)
         {
            this.drawBubble();
            this.updateEditor();
         }
      }
      
      public function setSizeMode(param1:uint, param2:Boolean = true) : void
      {
         this.sizeMode = param1;
         if(param2)
         {
            this.updateWrapping();
            this.updateEditor();
         }
      }
      
      public function setFontStyle(param1:uint, param2:Boolean = true) : void
      {
         this.setStyle(FEATURE_STYLE,param1);
         recentStyle = param1;
         if(param2)
         {
            this.applyStyles();
         }
      }
      
      public function setFontFace(param1:int, param2:Boolean = true) : void
      {
         this.setStyle(FEATURE_FONT,param1);
         recentFont = param1;
         if(param2)
         {
            this.applyStyles();
         }
      }
      
      public function setFontSize(param1:uint, param2:Boolean = true) : void
      {
         this.setStyle(FEATURE_SIZE,param1);
         recentSize = param1;
         if(param2)
         {
            this.applyStyles();
         }
      }
      
      public function setTextAlign(param1:uint, param2:Boolean = true) : void
      {
         this._textAlign = param1;
         recentAlign = param1;
         if(param2)
         {
            this.updateFormat();
         }
      }
      
      public function getTextAlign() : uint
      {
         return this._textAlign;
      }
      
      public function isUnicode() : Boolean
      {
         return this.styles[0][FEATURE_FONT] < 0;
      }
      
      public function hasSelection() : Boolean
      {
         return this.txtDialog.selectable && this.txtDialog.selectionBeginIndex != this.txtDialog.selectionEndIndex;
      }
      
      public function getFontSize() : uint
      {
         return this.getFeature(FEATURE_SIZE);
      }
      
      public function getAnimationData() : Object
      {
         return {
            "x":x,
            "y":y,
            "w":this.txtDialog.width,
            "h":this.getTxtHeight(),
            "r":rotation,
            "s":this.spikeMode,
            "sm":this.shapeMode,
            "sz":this.sizeMode,
            "p":this.getPadding(),
            "sh":(!!this.getSilhouette() ? 1 : 0),
            "hh":0
         };
      }
      
      public function getInterpolatedPositionData(param1:Array, param2:Number) : Object
      {
         return this.setAnimationData(param1,param2,true);
      }
      
      public function setAnimationData(param1:Array, param2:Number, param3:Boolean = false) : Object
      {
         var _loc4_:Object = null;
         setHidden(Animation.interpolate(param1[0].hh,param1[1].hh,param1[2].hh,param1[3].hh,param2,0,false,Animation.INTERPOLATE_BINARY_ONKEY) == 1);
         if(!getHidden() || param3)
         {
            (_loc4_ = {}).x = Animation.interpolate(param1[0].x,param1[1].x,param1[2].x,param1[3].x,param2);
            _loc4_.y = Animation.interpolate(param1[0].y,param1[1].y,param1[2].y,param1[3].y,param2);
            _loc4_.w = Animation.interpolate(param1[0].w,param1[1].w,param1[2].w,param1[3].w,param2);
            _loc4_.h = Animation.interpolate(param1[0].h,param1[1].h,param1[2].h,param1[3].h,param2);
            _loc4_.r = Animation.interpolate(param1[0].r,param1[1].r,param1[2].r,param1[3].r,param2);
            _loc4_.s = Animation.interpolate(param1[0].s,param1[1].s,param1[2].s,param1[3].s,param2,0,false,Animation.INTERPOLATE_BINARY);
            _loc4_.sm = Animation.interpolate(param1[0].sm,param1[1].sm,param1[2].sm,param1[3].sm,param2,0,false,Animation.INTERPOLATE_BINARY);
            _loc4_.sz = Animation.interpolate(param1[0].sz,param1[1].sz,param1[2].sz,param1[3].sz,param2,0,false,Animation.INTERPOLATE_BINARY);
            _loc4_.sh = Animation.interpolate(param1[0].sh,param1[1].sh,param1[2].sh,param1[3].sh,param2,0,false,Animation.INTERPOLATE_BINARY);
            _loc4_.p = Animation.interpolate(param1[0].p,param1[1].p,param1[2].p,param1[3].p,param2);
            if(param3)
            {
               return _loc4_;
            }
            if(!getHidden())
            {
               _loc4_.animating = 1;
               this.setData(_loc4_);
               this.onRender(null,true);
            }
         }
         return null;
      }
      
      public function hasTarget() : Boolean
      {
         return this.target != null;
      }
      
      public function isProp() : Boolean
      {
         return this._isProp;
      }
      
      public function setProp(param1:Boolean) : void
      {
         this._isProp = param1;
         if(this.target != null)
         {
            this.target = null;
         }
         if(param1)
         {
            this.updateWrapping();
            this.setShapeMode(SHAPE_NONE,false);
            this.setPadding(0,false);
            this.setSilhouette(false);
         }
         else
         {
            this.setShapeMode(SHAPE_ROUNDED,false);
            this.setSizeMode(this.getDefault(FEATURE_SIZE),false);
            this.setPadding(defPadding,false);
         }
         Editor.self.setDialogMode(this);
      }
      
      override function set size(param1:Number) : void
      {
         _size = param1;
      }
      
      public function hasSound() : Boolean
      {
         return this._soundKey != null;
      }
      
      function setSound(param1:String) : void
      {
         if(param1 == "" || param1 == null || param1.substr(0,1) == "[")
         {
            this._soundKey = null;
         }
         else
         {
            this._soundKey = param1;
         }
         this.updateIcons();
      }
      
      function getSound() : String
      {
         return this._soundKey;
      }
      
      function checkBounds(param1:Number, param2:Number) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Number = -this.txtDialog.width * 0.5;
         var _loc5_:Number = param1 + this.txtDialog.width * 0.5;
         var _loc6_:Number = -this.txtDialog.width * 0.5;
         var _loc7_:Number = param2 + this.txtDialog.width * 0.5;
         if(x > _loc5_)
         {
            x = _loc5_;
            _loc3_ = true;
         }
         else if(x < _loc4_)
         {
            x = _loc4_;
            _loc3_ = true;
         }
         if(y > _loc7_)
         {
            y = _loc7_;
            _loc3_ = true;
         }
         else if(y < _loc6_)
         {
            y = _loc6_;
            _loc3_ = true;
         }
         if(_loc3_)
         {
            this.redraw();
         }
      }
      
      public function addText(param1:String, param2:int = -1) : void
      {
         var _loc3_:uint = 0;
         if(Editor.self.mode == Editor.MODE_EXPR)
         {
            _loc3_ = param2 > -1 ? uint(param2) : uint(this.txtDialog.caretIndex);
            this.text = this.text.substr(0,_loc3_) + param1 + this.text.substr(_loc3_);
         }
         else
         {
            this.text = param1;
         }
         this.resetStyles();
         this.onRender(null,true);
         this.updateEditor();
      }
      
      function randomPhrase() : void
      {
         var onLoaded:Function = function():void
         {
            if(randomPhrases == null || randomPhrases.length == 0)
            {
               return;
            }
            if(randomPhraseIndex >= randomPhrases.length)
            {
               randomPhraseIndex = 0;
            }
            text = randomPhrases[randomPhraseIndex++];
            resetStyles();
            onRender(null,true);
            updateEditor();
         };
         if(randomPhrases == null)
         {
            Main.loadRandomPhrases(onLoaded);
         }
         else
         {
            onLoaded();
         }
      }
      
      function canVaryStyles() : Boolean
      {
         return Fonts.fontHasStyles(this.getFeature(FEATURE_FONT));
      }
      
      override public function getSelectableRect(param1:DisplayObject = null) : Rectangle
      {
         return this.bubbleBounds;
      }
      
      function setPreviewing(param1:Boolean) : void
      {
         this._previewing = param1;
      }
      
      private function onDownKey(param1:KeyboardEvent) : void
      {
         if(!stage.mouseChildren)
         {
            return;
         }
         switch(param1.keyCode)
         {
            case Keyboard.ESCAPE:
               Editor.self.onClickAway();
         }
      }
      
      override public function onSelect(param1:Boolean = true) : void
      {
         this.drawBubble(null,param1);
      }
      
      private function updateSelect(param1:Boolean = true) : void
      {
         var _loc2_:Number = NaN;
         if(!this.bubble || !Template.isActive())
         {
            return;
         }
         if(Template.isActive() && !param1 && this.isEmpty())
         {
            _loc2_ = ALPHA_TEMPLATE_EMPTY;
         }
         else
         {
            _loc2_ = 1;
         }
         if(_loc2_ != this.bubble.alpha)
         {
            this.bubble.alpha = _loc2_;
         }
      }
      
      public function hasLink() : Boolean
      {
         return this._linkURL != null;
      }
      
      public function getLink() : String
      {
         return this._linkURL;
      }
      
      public function setLink(param1:String) : void
      {
         if(param1 == "")
         {
            param1 = null;
         }
         this._linkURL = param1;
      }
      
      public function rememberCaret() : void
      {
         this._recentCaretIndex = this.txtDialog.caretIndex;
      }
      
      public function recallCaret(param1:String) : void
      {
         if(param1)
         {
            this.addText(param1,this._recentCaretIndex++);
         }
         this.txtDialog.setSelection(this._recentCaretIndex,this._recentCaretIndex);
         stage.focus = this.txtDialog;
         this._recentCaretIndex = -1;
      }
   }
}
