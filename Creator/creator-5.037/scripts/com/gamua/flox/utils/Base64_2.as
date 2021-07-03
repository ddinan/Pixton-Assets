package com.gamua.flox.utils
{
   import flash.utils.ByteArray;
   
   public class Base64
   {
      
      private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
      
      private static var sOutputBuilder:ByteArray = new ByteArray();
      
      private static var sDataBuffer:Vector.<uint> = new Vector.<uint>(0);
      
      private static var sOutputBuffer:Vector.<uint> = new Vector.<uint>(0);
       
      
      public function Base64()
      {
         super();
         throw new Error("Base64 class is static container only");
      }
      
      public static function encode(param1:String) : String
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         return encodeByteArray(_loc2_);
      }
      
      public static function encodeByteArray(param1:ByteArray) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         param1.position = 0;
         var _loc7_:int = 0;
         sDataBuffer[_loc7_] = _loc7_;
         sDataBuffer[2] = sDataBuffer[1] = _loc7_;
         while(param1.bytesAvailable > 0)
         {
            _loc3_ = param1.bytesAvailable >= 3 ? 3 : int(param1.bytesAvailable);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               sDataBuffer[_loc4_] = param1.readUnsignedByte();
               _loc4_++;
            }
            sOutputBuffer[0] = (sDataBuffer[0] & 252) >> 2;
            sOutputBuffer[1] = (sDataBuffer[0] & 3) << 4 | sDataBuffer[1] >> 4;
            sOutputBuffer[2] = (sDataBuffer[1] & 15) << 2 | sDataBuffer[2] >> 6;
            sOutputBuffer[3] = sDataBuffer[2] & 63;
            _loc5_ = _loc3_;
            while(_loc5_ < 3)
            {
               sOutputBuffer[int(_loc5_ + 1)] = 64;
               _loc5_++;
            }
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
               sOutputBuilder.writeUTFBytes(BASE64_CHARS.charAt(sOutputBuffer[_loc6_]));
               _loc6_++;
            }
         }
         sOutputBuilder.position = 0;
         _loc2_ = sOutputBuilder.readUTFBytes(sOutputBuilder.length);
         sOutputBuilder.length = sOutputBuffer.length = sDataBuffer.length = 0;
         return _loc2_;
      }
      
      public static function decode(param1:String) : String
      {
         var _loc2_:ByteArray = decodeToByteArray(param1);
         return _loc2_.readUTFBytes(_loc2_.length);
      }
      
      public static function decodeToByteArray(param1:String, param2:ByteArray = null) : ByteArray
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc3_:int = param1.length;
         if(param2 != null)
         {
            param2.length = 0;
         }
         else
         {
            param2 = new ByteArray();
         }
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = 0;
            while(_loc5_ < 4 && _loc4_ + _loc5_ < _loc3_)
            {
               sDataBuffer[_loc5_] = BASE64_CHARS.indexOf(param1.charAt(_loc4_ + _loc5_));
               _loc5_++;
            }
            sOutputBuffer[0] = (sDataBuffer[0] << 2) + ((sDataBuffer[1] & 48) >> 4);
            sOutputBuffer[1] = ((sDataBuffer[1] & 15) << 4) + ((sDataBuffer[2] & 60) >> 2);
            sOutputBuffer[2] = ((sDataBuffer[2] & 3) << 6) + sDataBuffer[3];
            _loc6_ = 0;
            while(_loc6_ < 3)
            {
               if(sDataBuffer[int(_loc6_ + 1)] == 64)
               {
                  break;
               }
               param2.writeByte(sOutputBuffer[_loc6_]);
               _loc6_++;
            }
            _loc4_ += 4;
         }
         param2.position = 0;
         sOutputBuffer.length = sDataBuffer.length = 0;
         return param2;
      }
   }
}
