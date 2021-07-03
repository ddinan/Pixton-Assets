package org.sepy.io
{
   public class Serializer
   {
      
      public static const version:String = "3.0.0";
      
      static var c:uint;
      
      static var pattern:RegExp = /[A-Z][a-z]{2}, \d{2} [A-Z][a-z]{2} \d{4} \d{2}:\d{2}:\d{2} \+|\-\d{4}/g;
       
      
      public function Serializer()
      {
         super();
      }
      
      public static function serialize(param1:*) : String
      {
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         if(param1 is Boolean)
         {
            _loc2_ = "b:" + uint(param1) + ";";
         }
         else if(param1 is int)
         {
            _loc2_ = "i:" + param1.toString() + ";";
         }
         else if(param1 is Number)
         {
            _loc2_ = "d:" + param1.toString() + ";";
         }
         else if(param1 is String)
         {
            _loc2_ = "s:" + Serializer.stringLength(param1) + ":\"" + param1 + "\";";
         }
         else if(param1 is Array)
         {
            _loc7_ = param1.length;
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc3_.push(Serializer.serialize(_loc4_));
               _loc3_.push(Serializer.serialize(param1[_loc6_]));
               _loc4_ += 1;
               _loc6_++;
            }
            _loc2_ = "a:" + _loc4_ + ":{" + _loc3_.join("") + "}";
         }
         else if(param1 is Object)
         {
            for(_loc5_ in param1)
            {
               _loc3_.push(Serializer.serialize(_loc5_));
               _loc3_.push(Serializer.serialize(param1[_loc5_]));
               _loc4_ += 1;
            }
            _loc2_ = "O:8:\"stdClass\":" + _loc4_ + ":{" + _loc3_.join("") + "}";
         }
         else if(param1 == null || param1 == undefined)
         {
            _loc2_ = "N;";
         }
         else
         {
            _loc2_ = "i:0;";
         }
         return _loc2_;
      }
      
      public static function unserialize(param1:String) : *
      {
         Serializer.c = 0;
         return Serializer.unserialize_internal(param1);
      }
      
      static function unserialize_internal(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc8_:uint = 0;
         var _loc9_:* = undefined;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc4_:Array = new Array();
         var _loc5_:String = param1.charAt(Serializer.c);
         var _loc6_:uint = 0;
         var _loc7_:Boolean = true;
         switch(_loc5_)
         {
            case "N":
               _loc2_ = null;
               Serializer.c += 2;
               break;
            case "b":
               _loc2_ = param1.substr(Serializer.c + 2,1) == "1";
               Serializer.c += 4;
               break;
            case "i":
               _loc4_.push(param1.indexOf(";",Serializer.c));
               _loc6_ = Serializer.c + 2;
               Serializer.c = _loc4_[0] + 1;
               _loc2_ = int(param1.substring(_loc6_,_loc4_[0]));
               break;
            case "d":
               _loc4_.push(param1.indexOf(";",Serializer.c));
               _loc6_ = Serializer.c + 2;
               Serializer.c = _loc4_[0] + 1;
               _loc2_ = Number(param1.substring(_loc6_,_loc4_[0]));
               break;
            case "s":
               _loc4_.push(int(param1.indexOf(":",Serializer.c + 2)));
               _loc4_.push(_loc4_[0] + 2);
               _loc6_ = Serializer.c + 2;
               _loc4_.push(0);
               _loc4_.push(int(param1.substring(_loc6_,_loc4_[0])));
               if(_loc4_[3] == 0)
               {
                  _loc2_ = "";
                  Serializer.c = _loc6_ + 5;
               }
               else if((_loc10_ = Serializer.stringCLength(param1,Serializer.c,_loc4_[3])) != _loc4_[3])
               {
                  _loc2_ = param1.substr(_loc4_[0] + 2,_loc10_);
                  Serializer.c = _loc4_[0] + 4 + _loc10_;
               }
               else
               {
                  _loc2_ = param1.substr(_loc4_[0] + 2,_loc4_[3]);
                  Serializer.c = _loc4_[0] + 4 + _loc4_[3];
               }
               break;
            case "a":
               _loc6_ = Serializer.c + 2;
               _loc4_.push(int(param1.indexOf(":",_loc6_)));
               _loc4_.push(int(param1.substring(_loc6_,_loc4_[0])));
               Serializer.c = _loc4_[0] + 2;
               _loc2_ = [];
               _loc8_ = 0;
               while(_loc8_ < _loc4_[1])
               {
                  _loc3_ = Serializer.unserialize_internal(param1);
                  _loc2_[_loc3_] = Serializer.unserialize_internal(param1);
                  if(!(_loc3_ is int) || _loc3_ < 0)
                  {
                     _loc7_ = false;
                  }
                  _loc8_++;
               }
               if(_loc7_)
               {
                  _loc4_.push([]);
                  _loc11_ = 0;
                  while(_loc11_ < _loc2_.length)
                  {
                     _loc6_ = _loc4_[2].length;
                     while(_loc11_ > _loc6_)
                     {
                        _loc4_[2].push(null);
                        _loc6_ += 1;
                     }
                     _loc4_[2].push(_loc2_[_loc11_]);
                     _loc11_++;
                  }
                  _loc2_ = _loc4_[2];
               }
               Serializer.c += 1;
               break;
            case "O":
               _loc6_ = param1.indexOf("\"",Serializer.c) + 1;
               Serializer.c = param1.indexOf("\"",_loc6_);
               _loc4_.push(param1.substring(_loc6_,Serializer.c));
               Serializer.c += 2;
               _loc8_ = Serializer.c;
               Serializer.c = param1.indexOf(":",_loc8_);
               _loc8_ = int(param1.substring(_loc8_,Serializer.c));
               Serializer.c += 2;
               _loc2_ = {};
               while(_loc8_ > 0)
               {
                  _loc9_ = Serializer.unserialize_internal(param1);
                  _loc2_[_loc9_] = Serializer.unserialize_internal(param1);
                  _loc8_--;
               }
               Serializer.c += 1;
         }
         return _loc2_;
      }
      
      static function stringCLength(param1:String, param2:uint = 0, param3:uint = 0) : int
      {
         var _loc4_:uint = 0;
         var _loc6_:int = 0;
         var _loc5_:uint = param3;
         var _loc7_:uint = param2 + 4 + param3.toString().length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if((_loc6_ = param1.charCodeAt(_loc4_ + _loc7_)) > 65536)
            {
               _loc5_ -= 3;
            }
            else if(_loc6_ > 2048)
            {
               _loc5_ -= 2;
            }
            else if(_loc6_ > 128)
            {
               _loc5_--;
            }
            _loc4_++;
         }
         return _loc5_;
      }
      
      static function stringLength(param1:String) : uint
      {
         var data:String = param1;
         var code:int = 0;
         var result:int = 0;
         var slen:int = data.length;
         while(slen)
         {
            slen--;
            try
            {
               code = data.charCodeAt(slen);
            }
            catch(e:Error)
            {
               code = 65536;
            }
            if(code < 128)
            {
               result += 1;
            }
            else if(code < 2048)
            {
               result += 2;
            }
            else if(code < 65536)
            {
               result += 3;
            }
            else
            {
               result += 4;
            }
         }
         return result;
      }
   }
}
