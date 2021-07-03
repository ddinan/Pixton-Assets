package com.xvisage.utils
{
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.system.Capabilities;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextLineMetrics;
   
   public class StringUtils
   {
       
      
      private var chars:String;
      
      private var tag:TextField;
      
      private var format:TextFormat;
      
      private var temp:TextField;
      
      private var tempData:String;
      
      private var htmlTags:Array;
      
      private var brackets:String = "(){}[]<>";
      
      private var specialChars:String = "اأإآدذرزوؤء";
      
      private var isMAC:Boolean;
      
      public var latinOnly:Boolean = false;
      
      public var wrapFactor:Number = 1;
      
      public var data:String;
      
      public var htmlLines:Array;
      
      public var numLines:Number;
      
      public function StringUtils()
      {
         this.htmlTags = ["A","B","BR","FONT","IMG","I","LI","P","SPAN","TEXTFORMAT","U","UL"];
         super();
         this.isMAC = false;
         var _loc1_:String = Capabilities.version;
         if(_loc1_.toLowerCase().indexOf("mac") != -1)
         {
            this.isMAC = true;
         }
         this.specialChars += String.fromCharCode(65276,65275,65272,65271,65274,65273,65270,65269);
      }
      
      public function parseArabic(param1:String, param2:TextField, param3:TextFormat = null) : String
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:String = null;
         var _loc20_:String = null;
         this.tag = param2;
         if(param3)
         {
            this.format = param3;
         }
         else
         {
            this.format = this.tag.getTextFormat();
         }
         this.data = param1;
         this.htmlLines = [];
         var _loc4_:* = param1;
         if(param1.length > 0)
         {
            _loc5_ = "";
            _loc6_ = "";
            _loc7_ = "";
            _loc8_ = "";
            _loc9_ = "";
            this.chars = param1;
            this.chars = this.chars.split("\r\n").join("\n");
            if(this.tag.multiline)
            {
               this.chars = this.chars.split("\r").join("<br />");
               this.chars = this.chars.split("\n").join("<br />");
               this.chars = this.properHTMLLines(this.chars);
               this.chars = this.splitBulletList(this.chars);
            }
            else
            {
               this.chars = this.chars.split("\r").join("");
               this.chars = this.chars.split("\n").join("");
            }
            this.chars = this.stripDiacritics();
            this.temp = new TextField();
            this.temp.x = -1000;
            this.temp.y = -1000;
            this.temp.width = Number(this.format.size);
            this.temp.height = Number(this.format.size) + 2;
            this.tag.parent.addChild(this.temp);
            this.temp.autoSize = TextFieldAutoSize.LEFT;
            if(this.tag.embedFonts)
            {
               this.temp.embedFonts = true;
            }
            this.temp.selectable = false;
            this.temp.text = "";
            this.tempData = "";
            _loc10_ = false;
            _loc11_ = false;
            _loc12_ = [];
            _loc13_ = [];
            _loc14_ = 0;
            _loc15_ = 0;
            _loc16_ = 0;
            while(_loc14_ < this.chars.length)
            {
               if(this.chars.charAt(_loc14_ - 1) == ">" && _loc10_)
               {
                  _loc10_ = false;
               }
               if(this.chars.charAt(_loc14_) == "<" && this.validateHTMLTag(_loc14_))
               {
                  _loc10_ = true;
               }
               if(this.chars.charAt(_loc14_) != " ")
               {
                  if(!this.latinOnly)
                  {
                     if(this.validateArabic(_loc14_) || this.validateSymbol(_loc14_,_loc10_))
                     {
                        _loc11_ = true;
                     }
                     else
                     {
                        _loc11_ = false;
                     }
                  }
               }
               if(!_loc11_)
               {
                  if(_loc6_.length > 0)
                  {
                     _loc12_.push({
                        "arabic":true,
                        "html":false,
                        "value":_loc6_
                     });
                     _loc6_ = "";
                  }
               }
               if(_loc11_ || !_loc11_ && _loc10_)
               {
                  if(_loc8_.length > 0)
                  {
                     _loc12_.push({
                        "arabic":false,
                        "html":false,
                        "value":_loc8_
                     });
                     _loc8_ = "";
                  }
               }
               if(_loc11_ || !_loc11_ && !_loc10_)
               {
                  if(_loc9_.length > 0)
                  {
                     _loc12_.push({
                        "arabic":false,
                        "html":true,
                        "value":_loc9_
                     });
                     _loc9_ = "";
                  }
               }
               if(_loc11_)
               {
                  _loc5_ = this.getCharState(_loc14_);
                  _loc5_ = this.symmetricalSwapping(_loc5_,_loc14_);
                  _loc6_ += _loc5_;
                  this.tempData += _loc5_;
               }
               else
               {
                  _loc7_ = this.chars.charAt(_loc14_);
                  if(_loc10_)
                  {
                     _loc9_ += _loc7_;
                  }
                  else
                  {
                     _loc8_ += _loc7_;
                  }
                  this.tempData += this.chars.charAt(_loc14_);
               }
               this.temp.htmlText = this.tempData;
               this.temp.setTextFormat(this.format);
               if(this.breakTextLine(_loc14_,_loc10_))
               {
                  if(_loc6_.length > 0)
                  {
                     _loc12_.push({
                        "arabic":true,
                        "html":false,
                        "value":_loc6_
                     });
                     _loc6_ = "";
                  }
                  if(_loc9_.length > 0)
                  {
                     if(this.chars.charAt(_loc14_) != ">")
                     {
                        _loc15_ = _loc14_ + 1;
                        while(_loc15_ < this.chars.length)
                        {
                           _loc9_ += this.chars.charAt(_loc15_);
                           if(this.chars.charAt(_loc15_) == ">")
                           {
                              break;
                           }
                           _loc15_++;
                        }
                        _loc14_ = _loc15_;
                     }
                     _loc12_.push({
                        "arabic":false,
                        "html":true,
                        "value":_loc9_
                     });
                     _loc9_ = "";
                  }
                  if(_loc8_.length > 0)
                  {
                     _loc12_.push({
                        "arabic":false,
                        "html":false,
                        "value":_loc8_
                     });
                     _loc8_ = "";
                  }
                  if(_loc12_.length > 0)
                  {
                     _loc13_.push(_loc12_);
                     _loc12_ = [];
                  }
                  this.temp.text = "";
                  this.tempData = "";
               }
               _loc14_++;
            }
            this.tag.parent.removeChild(this.temp);
            if(_loc6_.length > 0)
            {
               _loc12_.push({
                  "arabic":true,
                  "html":false,
                  "value":_loc6_
               });
            }
            if(_loc9_.length > 0)
            {
               _loc12_.push({
                  "arabic":false,
                  "html":true,
                  "value":_loc9_
               });
            }
            if(_loc8_.length > 0)
            {
               _loc12_.push({
                  "arabic":false,
                  "html":false,
                  "value":_loc8_
               });
            }
            if(_loc12_.length > 0)
            {
               _loc13_.push(_loc12_);
            }
            this.numLines = 0;
            _loc4_ = "";
            _loc15_ = 0;
            while(_loc15_ < _loc13_.length)
            {
               _loc17_ = false;
               _loc16_ = 0;
               while(_loc16_ < _loc13_[_loc15_].length)
               {
                  if(_loc13_[_loc15_][_loc16_].html)
                  {
                     _loc17_ = true;
                     break;
                  }
                  _loc16_++;
               }
               if(_loc17_)
               {
                  this.autoCompleteHTMLTags(_loc15_,_loc13_);
               }
               _loc15_++;
            }
            _loc15_ = 0;
            while(_loc15_ < _loc13_.length)
            {
               _loc18_ = false;
               _loc16_ = 0;
               while(_loc16_ < _loc13_[_loc15_].length)
               {
                  if(_loc13_[_loc15_][_loc16_].arabic)
                  {
                     _loc18_ = true;
                     break;
                  }
                  _loc16_++;
               }
               if(_loc18_)
               {
                  if(!this.isMAC || this.tag.embedFonts && this.isMAC)
                  {
                     _loc13_.splice(_loc15_,1,this.reorderTextLine(_loc13_[_loc15_]));
                  }
                  else if(_loc13_[_loc15_][0].arabic)
                  {
                  }
               }
               _loc19_ = "";
               _loc16_ = 0;
               while(_loc16_ < _loc13_[_loc15_].length)
               {
                  _loc19_ += _loc13_[_loc15_][_loc16_].value;
                  if(_loc13_[_loc15_][_loc16_].arabic)
                  {
                     _loc4_ += this.reverseChars(_loc13_[_loc15_][_loc16_].value);
                  }
                  else
                  {
                     _loc20_ = _loc13_[_loc15_][_loc16_].value;
                     if(!this.latinOnly)
                     {
                        if(!this.isMAC || this.tag.embedFonts && this.isMAC)
                        {
                           if(_loc20_.charAt(_loc20_.length - 1) == " " && !_loc13_[_loc15_][_loc16_].html)
                           {
                              _loc20_ = " " + _loc20_.substr(0,-1);
                           }
                        }
                     }
                     _loc4_ += _loc20_;
                  }
                  _loc16_++;
               }
               this.htmlLines.push(_loc19_);
               if(_loc15_ < _loc13_.length - 1)
               {
                  _loc4_ += "";
               }
               ++this.numLines;
               _loc15_++;
            }
         }
         else
         {
            this.numLines = 1;
         }
         return "<font face=\"" + this.format.font + "\">" + _loc4_ + "</font>";
      }
      
      private function validateHTMLTag(param1:Number) : Boolean
      {
         var _loc2_:String = "";
         var _loc3_:Number = param1 + 1;
         while(_loc3_ < this.chars.length)
         {
            if(this.chars.charAt(_loc3_) == " " || this.chars.charAt(_loc3_) == ">")
            {
               break;
            }
            _loc2_ += this.chars.charAt(_loc3_);
            _loc3_++;
         }
         var _loc4_:Boolean = false;
         _loc3_ = 0;
         while(_loc3_ < this.htmlTags.length)
         {
            if(_loc2_.toLowerCase().indexOf(this.htmlTags[_loc3_].toLowerCase()) != -1)
            {
               _loc4_ = true;
               break;
            }
            _loc3_++;
         }
         return _loc4_;
      }
      
      private function getHTMLOpenTag(param1:Number, param2:String) : String
      {
         var _loc3_:String = "";
         var _loc4_:Boolean = false;
         var _loc5_:Number = param1;
         while(_loc5_ < param2.length)
         {
            if(_loc4_)
            {
               if(param2.charAt(_loc5_) == " " || param2.charAt(_loc5_) == ">")
               {
                  break;
               }
               _loc3_ += param2.charAt(_loc5_);
            }
            if(param2.charAt(_loc5_) == "<" && param2.charAt(_loc5_ + 1) != "/")
            {
               _loc4_ = true;
            }
            _loc5_++;
         }
         var _loc6_:Boolean = false;
         _loc5_ = 0;
         while(_loc5_ < this.htmlTags.length)
         {
            if(_loc3_.toLowerCase() == this.htmlTags[_loc5_].toLowerCase())
            {
               _loc6_ = true;
               break;
            }
            _loc5_++;
         }
         if(_loc6_)
         {
            return _loc3_;
         }
         return "";
      }
      
      private function validateArabic(param1:Number) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:Number = this.chars.charCodeAt(param1);
         if(_loc3_ >= 1536 && _loc3_ <= 1791 || _loc3_ >= 1872 && _loc3_ <= 1919 || _loc3_ >= 64336 && _loc3_ <= 65023 || _loc3_ >= 65136 && _loc3_ <= 65279 || _loc3_ == 8226)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      private function validateSymbol(param1:Number, param2:Boolean) : Boolean
      {
         var _loc5_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:Number;
         if((_loc4_ = this.chars.charCodeAt(param1)) >= 33 && _loc4_ <= 47 || _loc4_ >= 58 && _loc4_ <= 63 || _loc4_ >= 123 && _loc4_ <= 126)
         {
            if((_loc5_ = this.validateBiDirectional(param1,param2)).isBiDirectional || _loc5_.isArabic)
            {
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      private function validateBiDirectional(param1:Number, param2:Boolean) : Object
      {
         var _loc8_:Number = NaN;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         if(param2)
         {
            if(param1 > 0)
            {
               _loc8_ = param1 - 1;
               while(_loc8_ >= 0)
               {
                  if(this.chars.charAt(_loc8_) == "<" && !_loc7_)
                  {
                     _loc7_ = true;
                  }
                  if(this.chars.charAt(_loc8_) != " " && _loc7_)
                  {
                     if(this.validateArabic(_loc8_))
                     {
                        _loc3_ = true;
                     }
                     break;
                  }
                  _loc8_--;
               }
            }
            _loc7_ = false;
            if(param1 < this.chars.length)
            {
               _loc8_ = param1 + 1;
               while(_loc8_ <= this.chars.length)
               {
                  if(this.chars.charAt(_loc8_) == ">" && !_loc7_)
                  {
                     _loc7_ = true;
                  }
                  if(this.chars.charAt(_loc8_) != " " && _loc7_)
                  {
                     if(this.validateArabic(_loc8_))
                     {
                        _loc4_ = true;
                     }
                     break;
                  }
                  _loc8_++;
               }
            }
         }
         else
         {
            if(param1 > 0)
            {
               _loc8_ = param1 - 1;
               while(_loc8_ >= 0)
               {
                  if(this.chars.charAt(_loc8_) != " ")
                  {
                     if(this.validateArabic(_loc8_))
                     {
                        _loc3_ = true;
                     }
                     break;
                  }
                  _loc8_--;
               }
            }
            if(param1 < this.chars.length)
            {
               _loc8_ = param1 + 1;
               while(_loc8_ <= this.chars.length)
               {
                  if(this.chars.charAt(_loc8_) != " ")
                  {
                     if(this.validateArabic(_loc8_))
                     {
                        _loc4_ = true;
                     }
                     break;
                  }
                  _loc8_++;
               }
            }
         }
         if(!_loc3_ && _loc4_ || _loc3_ && !_loc4_)
         {
            _loc5_ = true;
         }
         else if(_loc3_ && _loc4_)
         {
            _loc6_ = true;
         }
         return {
            "isBiDirectional":_loc5_,
            "isArabic":_loc6_,
            "prevArabic":_loc3_,
            "nextArabic":_loc4_
         };
      }
      
      private function symmetricalSwapping(param1:String, param2:Number) : String
      {
         if(this.brackets.indexOf(param1) != -1)
         {
            switch(param1)
            {
               case "(":
                  param1 = ")";
                  break;
               case ")":
                  param1 = "(";
                  break;
               case "{":
                  param1 = "}";
                  break;
               case "}":
                  param1 = "{";
                  break;
               case "[":
                  param1 = "]";
                  break;
               case "]":
                  param1 = "[";
                  break;
               case "<":
                  param1 = ">";
                  break;
               case ">":
                  param1 = "<";
            }
         }
         return param1;
      }
      
      private function breakTextLine(param1:Number, param2:Boolean) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:TextLineMetrics = null;
         var _loc3_:Boolean = false;
         if(this.tag.multiline && this.chars.charAt(param1) == " ")
         {
            _loc4_ = false;
            _loc5_ = this.tempData;
            _loc6_ = param1 + 1;
            while(_loc6_ < this.chars.length)
            {
               _loc5_ += this.chars.charAt(_loc6_);
               if(param2)
               {
                  if(this.chars.charAt(_loc6_) == ">")
                  {
                     if(this.chars.charAt(_loc6_ - 5) == "<" && this.chars.charAt(_loc6_ - 4) == "b" && this.chars.charAt(_loc6_ - 3) == "r" && this.chars.charAt(_loc6_ - 2) == " " && this.chars.charAt(_loc6_ - 1) == "/")
                     {
                        _loc3_ = true;
                        break;
                     }
                     _loc4_ = true;
                  }
               }
               else
               {
                  _loc4_ = true;
               }
               if(this.chars.charAt(_loc6_) == " " && _loc4_)
               {
                  break;
               }
               _loc6_++;
            }
            if(!_loc3_)
            {
               this.temp.htmlText = _loc5_;
               this.temp.setTextFormat(this.format);
               _loc7_ = false;
               if(this.isMAC && Number(this.format.size) % 2 == 0)
               {
                  if((_loc8_ = this.temp.getLineMetrics(0)).width >= this.tag.width * this.wrapFactor - (!!this.format.leftMargin ? Number(this.format.leftMargin) : 0) - (!!this.format.rightMargin ? Number(this.format.rightMargin) : 0))
                  {
                     _loc7_ = true;
                  }
               }
               else if(Math.ceil(this.temp.width) >= this.tag.width - (!!this.format.leftMargin ? Number(this.format.leftMargin) : 0) - (!!this.format.rightMargin ? Number(this.format.rightMargin) : 0))
               {
                  _loc7_ = true;
               }
               if(_loc7_)
               {
                  _loc3_ = true;
               }
               else
               {
                  this.temp.htmlText = this.tempData;
               }
               this.temp.setTextFormat(this.format);
            }
         }
         return _loc3_;
      }
      
      private function autoCompleteHTMLTags(param1:Number, param2:Array) : *
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:Boolean = false;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Array = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Object = null;
         if(param1 > 0)
         {
            _loc3_ = param2[param1 - 1];
            _loc4_ = param2[param1];
            _loc5_ = "";
            _loc6_ = "";
            _loc7_ = [];
            _loc8_ = false;
            _loc9_ = 0;
            while(_loc9_ < _loc4_.length)
            {
               if(_loc4_[_loc9_].html && _loc4_[_loc9_].value.indexOf("</") != -1)
               {
                  _loc10_ = 0;
                  while(_loc10_ < _loc4_[_loc9_].value.length)
                  {
                     if(_loc4_[_loc9_].value.charAt(_loc10_ - 2) == "<" && _loc4_[_loc9_].value.charAt(_loc10_ - 1) == "/")
                     {
                        _loc8_ = true;
                        _loc6_ = "";
                     }
                     if(_loc8_)
                     {
                        if(_loc4_[_loc9_].value.charAt(_loc10_) == ">")
                        {
                           if(_loc6_.length > 0)
                           {
                              _loc7_.push(_loc6_.toLowerCase());
                           }
                           _loc8_ = false;
                        }
                        else
                        {
                           _loc6_ += _loc4_[_loc9_].value.charAt(_loc10_);
                        }
                     }
                     _loc10_++;
                  }
               }
               _loc9_++;
            }
            _loc13_ = [];
            if(_loc7_.length > 0)
            {
               _loc10_ = 0;
               while(_loc10_ < _loc7_.length)
               {
                  _loc11_ = -1;
                  _loc9_ = 0;
                  while(_loc9_ < _loc4_.length)
                  {
                     if(_loc4_[_loc9_].html)
                     {
                        if(_loc4_[_loc9_].value.indexOf("<" + _loc7_[_loc10_] + " ") != -1)
                        {
                           _loc11_ = _loc9_;
                        }
                        else if(_loc4_[_loc9_].value.indexOf("</" + _loc7_[_loc10_] + ">") != -1)
                        {
                           _loc12_ = _loc9_;
                        }
                     }
                     _loc9_++;
                  }
                  if(_loc11_ == -1 || _loc12_ < _loc11_)
                  {
                     _loc13_.push(_loc7_[_loc10_]);
                  }
                  _loc10_++;
               }
               if(_loc13_.length > 0)
               {
                  _loc10_ = 0;
                  while(_loc10_ < _loc13_.length)
                  {
                     _loc9_ = _loc3_.length - 1;
                     while(_loc9_ > 0)
                     {
                        if(_loc3_[_loc9_].html && _loc3_[_loc9_].value.toLowerCase().indexOf("<" + _loc13_[_loc10_] + " ") != -1)
                        {
                           _loc15_ = _loc14_ = _loc3_[_loc9_].value.toLowerCase().lastIndexOf("<" + _loc13_[_loc10_] + " ");
                           while(_loc15_ < _loc3_[_loc9_].value.length)
                           {
                              if(_loc3_[_loc9_].value.charAt(_loc15_) == ">")
                              {
                                 break;
                              }
                              _loc15_++;
                           }
                           _loc5_ = _loc3_[_loc9_].value.substring(_loc14_,_loc15_ + 1);
                        }
                        _loc9_--;
                     }
                     if(_loc5_.length > 0)
                     {
                        if(_loc3_[_loc3_.length - 1].html)
                        {
                           _loc16_ = _loc3_.pop();
                           _loc16_.value += "</" + _loc13_[_loc10_] + ">";
                        }
                        else
                        {
                           _loc16_ = {
                              "arabic":false,
                              "html":true,
                              "value":"</" + _loc13_[_loc10_] + ">"
                           };
                        }
                        _loc3_.push(_loc16_);
                        if(_loc4_[0].html)
                        {
                           (_loc16_ = _loc4_.shift()).value = _loc5_ + _loc16_.value;
                        }
                        else
                        {
                           _loc16_ = {
                              "arabic":false,
                              "html":true,
                              "value":_loc5_
                           };
                        }
                        _loc4_.unshift(_loc16_);
                     }
                     _loc10_++;
                  }
               }
            }
         }
      }
      
      private function reorderTextLine(param1:Array) : Array
      {
         var _loc5_:Object = null;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc6_:String = "";
         var _loc7_:Boolean = false;
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         while(_loc8_ < param1.length)
         {
            if(param1[_loc8_].html)
            {
               if(_loc6_ == "")
               {
                  _loc9_ = 0;
                  while(_loc9_ < param1[_loc8_].value.length)
                  {
                     if((_loc6_ = this.getHTMLOpenTag(_loc9_,param1[_loc8_].value)) != "")
                     {
                        _loc7_ = true;
                        break;
                     }
                     _loc9_++;
                  }
               }
               else
               {
                  _loc9_ = 0;
                  while(_loc9_ < param1[_loc8_].value.length)
                  {
                     if(param1[_loc8_].value.indexOf("</" + _loc6_ + ">") != -1)
                     {
                        _loc6_ = "";
                        _loc7_ = false;
                        break;
                     }
                     _loc9_++;
                  }
               }
            }
            if(_loc7_)
            {
               _loc3_.push(param1[_loc8_]);
            }
            else if(_loc3_.length > 0)
            {
               _loc3_.push(param1[_loc8_]);
               _loc9_ = 0;
               while(_loc9_ < _loc3_.length)
               {
                  if(!_loc3_[_loc9_].html)
                  {
                     _loc4_.push(_loc3_[_loc9_]);
                  }
                  _loc9_++;
               }
               _loc4_.reverse();
               _loc11_ = 0;
               _loc9_ = 0;
               while(_loc9_ < _loc3_.length)
               {
                  if(!_loc3_[_loc9_].html)
                  {
                     _loc3_.splice(_loc9_,1,_loc4_[_loc11_]);
                     _loc11_++;
                  }
                  _loc9_++;
               }
               _loc4_ = [];
               _loc2_.push(_loc3_);
               _loc3_ = [];
            }
            else
            {
               _loc2_.push([param1[_loc8_]]);
            }
            _loc8_++;
         }
         _loc2_.reverse();
         var _loc12_:Array = [];
         _loc8_ = 0;
         while(_loc8_ < _loc2_.length)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc2_[_loc8_].length)
            {
               _loc12_.push(_loc2_[_loc8_][_loc9_]);
               _loc9_++;
            }
            _loc8_++;
         }
         return _loc12_;
      }
      
      private function reverseChars(param1:String) : String
      {
         var _loc2_:Array = param1.split("");
         if(!this.isMAC || this.tag.embedFonts && this.isMAC)
         {
            _loc2_.reverse();
         }
         return _loc2_.join("");
      }
      
      private function properHTMLLines(param1:String) : String
      {
         if(this.tag.multiline)
         {
            if(param1.indexOf("<BR />") != -1)
            {
               param1 = param1.split("<BR />").join("<br />");
            }
            if(param1.indexOf("<bR />") != -1)
            {
               param1 = param1.split("<bR />").join("<br />");
            }
            if(param1.indexOf("<Br />") != -1)
            {
               return param1.split("<Br />").join("<br />");
            }
            if(param1.indexOf("<BR>") != -1)
            {
               param1 = param1.split("<BR>").join("<br />");
            }
            if(param1.indexOf("<br>") != -1)
            {
               param1 = param1.split("<br>").join("<br />");
            }
            if(param1.indexOf("<bR>") != -1)
            {
               param1 = param1.split("<bR>").join("<br />");
            }
            if(param1.indexOf("<Br>") != -1)
            {
               param1 = param1.split("<Br>").join("<br />");
            }
         }
         return param1;
      }
      
      private function splitBulletList(param1:String) : String
      {
         if(this.tag.multiline)
         {
            if(param1.indexOf("<UL>") != -1)
            {
               param1 = param1.split("<UL>").join("");
            }
            if(param1.indexOf("<Ul>") != -1)
            {
               param1 = param1.split("<Ul>").join("");
            }
            if(param1.indexOf("<uL>") != -1)
            {
               param1 = param1.split("<uL>").join("");
            }
            if(param1.indexOf("<ul>") != -1)
            {
               param1 = param1.split("<ul>").join("");
            }
            if(param1.indexOf("</UL>") != -1)
            {
               param1 = param1.split("</UL>").join("<br />");
            }
            if(param1.indexOf("</Ul>") != -1)
            {
               param1 = param1.split("</Ul>").join("<br />");
            }
            if(param1.indexOf("</uL>") != -1)
            {
               param1 = param1.split("</uL>").join("<br />");
            }
            if(param1.indexOf("</ul>") != -1)
            {
               param1 = param1.split("</ul>").join("<br />");
            }
            if(param1.indexOf("<LI>") != -1)
            {
               param1 = param1.split("<LI>").join("<br /> • ");
            }
            if(param1.indexOf("<Li>") != -1)
            {
               param1 = param1.split("<Li>").join("<br /> • ");
            }
            if(param1.indexOf("<lI>") != -1)
            {
               param1 = param1.split("<lI>").join("<br /> • ");
            }
            if(param1.indexOf("<li>") != -1)
            {
               param1 = param1.split("<li>").join("<br /> • ");
            }
            if(param1.indexOf("</LI>") != -1)
            {
               param1 = param1.split("</LI>").join("");
            }
            if(param1.indexOf("</Li>") != -1)
            {
               param1 = param1.split("</Li>").join("");
            }
            if(param1.indexOf("</lI>") != -1)
            {
               param1 = param1.split("</lI>").join("");
            }
            if(param1.indexOf("</li>") != -1)
            {
               param1 = param1.split("</li>").join("");
            }
         }
         return param1;
      }
      
      private function validateArabicChar(param1:Number) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:Number = this.chars.charCodeAt(param1);
         if(_loc3_ >= 1570 && _loc3_ <= 1594 || _loc3_ >= 1601 && _loc3_ <= 1610 || _loc3_ >= 65154 && _loc3_ <= 65276)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      private function getCharState(param1:Number) : String
      {
         var _loc2_:String = null;
         switch(this.chars.charAt(param1))
         {
            case "ا":
               _loc2_ = this.setChar(param1,String.fromCharCode(1575),String.fromCharCode(1575),String.fromCharCode(65166),String.fromCharCode(65166));
               break;
            case "أ":
               _loc2_ = this.setChar(param1,String.fromCharCode(1571),String.fromCharCode(1571),String.fromCharCode(65156),String.fromCharCode(65156));
               break;
            case "إ":
               _loc2_ = this.setChar(param1,String.fromCharCode(1573),String.fromCharCode(1573),String.fromCharCode(65160),String.fromCharCode(65160));
               break;
            case "آ":
               _loc2_ = this.setChar(param1,String.fromCharCode(1570),String.fromCharCode(1570),String.fromCharCode(65154),String.fromCharCode(65154));
               break;
            case "ب":
               _loc2_ = this.setChar(param1,String.fromCharCode(1576),String.fromCharCode(65169),String.fromCharCode(65170),String.fromCharCode(65168));
               break;
            case "ت":
               _loc2_ = this.setChar(param1,String.fromCharCode(1578),String.fromCharCode(65175),String.fromCharCode(65176),String.fromCharCode(65174));
               break;
            case "ث":
               _loc2_ = this.setChar(param1,String.fromCharCode(1579),String.fromCharCode(65179),String.fromCharCode(65180),String.fromCharCode(65178));
               break;
            case "ج":
               _loc2_ = this.setChar(param1,String.fromCharCode(1580),String.fromCharCode(65183),String.fromCharCode(65184),String.fromCharCode(65182));
               break;
            case "ح":
               _loc2_ = this.setChar(param1,String.fromCharCode(1581),String.fromCharCode(65187),String.fromCharCode(65188),String.fromCharCode(65186));
               break;
            case "خ":
               _loc2_ = this.setChar(param1,String.fromCharCode(1582),String.fromCharCode(65191),String.fromCharCode(65192),String.fromCharCode(65190));
               break;
            case "د":
               _loc2_ = this.setChar(param1,String.fromCharCode(1583),String.fromCharCode(1583),String.fromCharCode(65194),String.fromCharCode(65194));
               break;
            case "ذ":
               _loc2_ = this.setChar(param1,String.fromCharCode(1584),String.fromCharCode(1584),String.fromCharCode(65196),String.fromCharCode(65196));
               break;
            case "ر":
               _loc2_ = this.setChar(param1,String.fromCharCode(1585),String.fromCharCode(1585),String.fromCharCode(65198),String.fromCharCode(65198));
               break;
            case "ز":
               _loc2_ = this.setChar(param1,String.fromCharCode(1586),String.fromCharCode(1586),String.fromCharCode(65200),String.fromCharCode(65200));
               break;
            case "س":
               _loc2_ = this.setChar(param1,String.fromCharCode(1587),String.fromCharCode(65203),String.fromCharCode(65204),String.fromCharCode(65202));
               break;
            case "ش":
               _loc2_ = this.setChar(param1,String.fromCharCode(1588),String.fromCharCode(65207),String.fromCharCode(65208),String.fromCharCode(65206));
               break;
            case "ص":
               _loc2_ = this.setChar(param1,String.fromCharCode(1589),String.fromCharCode(65211),String.fromCharCode(65212),String.fromCharCode(65210));
               break;
            case "ض":
               _loc2_ = this.setChar(param1,String.fromCharCode(1590),String.fromCharCode(65215),String.fromCharCode(65216),String.fromCharCode(65214));
               break;
            case "ط":
               _loc2_ = this.setChar(param1,String.fromCharCode(1591),String.fromCharCode(65219),String.fromCharCode(65220),String.fromCharCode(65218));
               break;
            case "ظ":
               _loc2_ = this.setChar(param1,String.fromCharCode(1592),String.fromCharCode(65223),String.fromCharCode(65224),String.fromCharCode(65222));
               break;
            case "ع":
               _loc2_ = this.setChar(param1,String.fromCharCode(1593),String.fromCharCode(65227),String.fromCharCode(65228),String.fromCharCode(65226));
               break;
            case "غ":
               _loc2_ = this.setChar(param1,String.fromCharCode(1594),String.fromCharCode(65231),String.fromCharCode(65232),String.fromCharCode(65230));
               break;
            case "ف":
               _loc2_ = this.setChar(param1,String.fromCharCode(1601),String.fromCharCode(65235),String.fromCharCode(65236),String.fromCharCode(65234));
               break;
            case "ق":
               _loc2_ = this.setChar(param1,String.fromCharCode(1602),String.fromCharCode(65239),String.fromCharCode(65240),String.fromCharCode(65238));
               break;
            case "ك":
               _loc2_ = this.setChar(param1,String.fromCharCode(1603),String.fromCharCode(65243),String.fromCharCode(65244),String.fromCharCode(65242));
               break;
            case "ل":
               _loc2_ = this.setChar(param1,String.fromCharCode(1604),String.fromCharCode(65247),String.fromCharCode(65248),String.fromCharCode(65246));
               break;
            case "م":
               _loc2_ = this.setChar(param1,String.fromCharCode(1605),String.fromCharCode(65251),String.fromCharCode(65252),String.fromCharCode(65250));
               break;
            case "ن":
               _loc2_ = this.setChar(param1,String.fromCharCode(1606),String.fromCharCode(65255),String.fromCharCode(65256),String.fromCharCode(65254));
               break;
            case "ه":
               _loc2_ = this.setChar(param1,String.fromCharCode(1607),String.fromCharCode(65259),String.fromCharCode(65260),String.fromCharCode(65258));
               break;
            case "ة":
               _loc2_ = this.setChar(param1,String.fromCharCode(1577),"","",String.fromCharCode(65172));
               break;
            case "و":
               _loc2_ = this.setChar(param1,String.fromCharCode(1608),String.fromCharCode(1608),String.fromCharCode(65262),String.fromCharCode(65262));
               break;
            case "ؤ":
               _loc2_ = this.setChar(param1,String.fromCharCode(1572),String.fromCharCode(1572),String.fromCharCode(65158),String.fromCharCode(65158));
               break;
            case "ى":
               _loc2_ = this.setChar(param1,String.fromCharCode(1609),String.fromCharCode(1609),String.fromCharCode(65264),String.fromCharCode(65264));
               break;
            case "ي":
               _loc2_ = this.setChar(param1,String.fromCharCode(1610),String.fromCharCode(65267),String.fromCharCode(65268),String.fromCharCode(65266));
               break;
            case "ئ":
               _loc2_ = this.setChar(param1,String.fromCharCode(1574),String.fromCharCode(65163),String.fromCharCode(65164),String.fromCharCode(65162));
               break;
            case "ء":
               _loc2_ = String.fromCharCode(1569);
               break;
            case "ـ":
               _loc2_ = String.fromCharCode(1600);
               break;
            case "?":
               _loc2_ = String.fromCharCode(1567);
               break;
            case ",":
               _loc2_ = String.fromCharCode(1548);
               break;
            case ";":
               _loc2_ = String.fromCharCode(1563);
               break;
            case "%":
               _loc2_ = String.fromCharCode(1642);
               break;
            default:
               _loc2_ = this.chars.charAt(param1);
         }
         return _loc2_;
      }
      
      private function setChar(param1:Number, param2:String, param3:String, param4:String, param5:String) : String
      {
         var _loc6_:String = "";
         if(this.chars.charAt(param1) == "ل" && this.chars.charAt(param1 + 1) == "ا")
         {
            if(this.validateArabicChar(param1 - 1) && this.specialChars.indexOf(this.chars.charAt(param1 - 1)) == -1)
            {
               _loc6_ = String.fromCharCode(65276);
            }
            else
            {
               _loc6_ = String.fromCharCode(65275);
            }
            this.chars = this.chars.substring(0,param1) + _loc6_ + this.chars.substring(param1 + 2,this.chars.length);
         }
         else if(this.chars.charAt(param1) == "ل" && this.chars.charAt(param1 + 1) == "أ")
         {
            if(this.validateArabicChar(param1 - 1) && this.specialChars.indexOf(this.chars.charAt(param1 - 1)) == -1)
            {
               _loc6_ = String.fromCharCode(65272);
            }
            else
            {
               _loc6_ = String.fromCharCode(65271);
            }
            this.chars = this.chars.substring(0,param1) + _loc6_ + this.chars.substring(param1 + 2,this.chars.length);
         }
         else if(this.chars.charAt(param1) == "ل" && this.chars.charAt(param1 + 1) == "إ")
         {
            if(this.validateArabicChar(param1 - 1) && this.specialChars.indexOf(this.chars.charAt(param1 - 1)) == -1)
            {
               _loc6_ = String.fromCharCode(65274);
            }
            else
            {
               _loc6_ = String.fromCharCode(65273);
            }
            this.chars = this.chars.substring(0,param1) + _loc6_ + this.chars.substring(param1 + 2,this.chars.length);
         }
         else if(this.chars.charAt(param1) == "ل" && this.chars.charAt(param1 + 1) == "آ")
         {
            if(this.validateArabicChar(param1 - 1) && this.specialChars.indexOf(this.chars.charAt(param1 - 1)) == -1)
            {
               _loc6_ = String.fromCharCode(65270);
            }
            else
            {
               _loc6_ = String.fromCharCode(65269);
            }
            this.chars = this.chars.substring(0,param1) + _loc6_ + this.chars.substring(param1 + 2,this.chars.length);
         }
         else if(param1 == 0)
         {
            if(this.specialChars.indexOf(this.chars.charAt(param1)) != -1)
            {
               _loc6_ = param2;
            }
            else
            {
               _loc6_ = param3;
            }
         }
         else if(param1 == this.chars.length - 1)
         {
            if(this.specialChars.indexOf(this.chars.charAt(param1 - 1)) != -1)
            {
               _loc6_ = param2;
            }
            else
            {
               _loc6_ = param5;
            }
         }
         else if(this.validateArabicChar(param1 - 1) && this.validateArabicChar(param1 + 1))
         {
            if(this.specialChars.indexOf(this.chars.charAt(param1 - 1)) != -1)
            {
               if(this.specialChars.indexOf(this.chars.charAt(param1)) != -1)
               {
                  _loc6_ = param2;
               }
               else
               {
                  _loc6_ = param3;
               }
            }
            else if(this.specialChars.indexOf(this.chars.charAt(param1)) != -1 || this.chars.charAt(param1 + 1) == "ء" || this.chars.charAt(param1) == "ة")
            {
               if(this.chars.charAt(param1 - 1) != "ة")
               {
                  _loc6_ = param5;
               }
               else
               {
                  _loc6_ = param3;
               }
            }
            else if(this.chars.charAt(param1 - 1) != "ة")
            {
               _loc6_ = param4;
            }
            else
            {
               _loc6_ = param3;
            }
         }
         else if(this.validateArabicChar(param1 - 1) && !this.validateArabicChar(param1 + 1))
         {
            if(this.specialChars.indexOf(this.chars.charAt(param1 - 1)) != -1)
            {
               _loc6_ = param2;
            }
            else
            {
               _loc6_ = param5;
            }
         }
         else if(!this.validateArabicChar(param1 - 1) && this.validateArabicChar(param1 + 1))
         {
            if(this.specialChars.indexOf(this.chars.charAt(param1)) != -1)
            {
               _loc6_ = param2;
            }
            else
            {
               _loc6_ = param3;
            }
         }
         else if(!this.validateArabicChar(param1 - 1) && !this.validateArabicChar(param1 + 1))
         {
            _loc6_ = param2;
         }
         return _loc6_;
      }
      
      private function stripDiacritics() : String
      {
         var _loc1_:String = "";
         var _loc2_:Number = 0;
         while(_loc2_ < this.chars.length)
         {
            if(this.chars.charCodeAt(_loc2_) < 1611 || this.chars.charCodeAt(_loc2_) > 1618)
            {
               _loc1_ += this.chars.charAt(_loc2_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function createArabicInput(param1:String, param2:String, param3:TextField) : void
      {
         this.tag = param3;
         var _loc4_:Point = new Point(this.tag.x,this.tag.y);
         this.tag.localToGlobal(_loc4_);
         ExternalInterface.call("createArabicInput",param1,param2,"",_loc4_.x,_loc4_.y,this.tag.width,this.tag.height,"multiline");
      }
      
      public function convertNumbers(param1:Number) : String
      {
         var _loc2_:String = "";
         var _loc3_:Number = 0;
         while(_loc3_ < String(param1).length)
         {
            switch(String(param1).charAt(_loc3_))
            {
               case "0":
                  _loc2_ += String.fromCharCode(1632);
                  break;
               case "1":
                  _loc2_ += String.fromCharCode(1633);
                  break;
               case "2":
                  _loc2_ += String.fromCharCode(1634);
                  break;
               case "3":
                  _loc2_ += String.fromCharCode(1635);
                  break;
               case "4":
                  _loc2_ += String.fromCharCode(1636);
                  break;
               case "5":
                  _loc2_ += String.fromCharCode(1637);
                  break;
               case "6":
                  _loc2_ += String.fromCharCode(1638);
                  break;
               case "7":
                  _loc2_ += String.fromCharCode(1639);
                  break;
               case "8":
                  _loc2_ += String.fromCharCode(1640);
                  break;
               case "9":
                  _loc2_ += String.fromCharCode(1641);
                  break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}
