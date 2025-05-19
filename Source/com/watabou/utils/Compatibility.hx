package com.watabou.utils;

/**
 * This class provides compatibility functions for working with Lime and OpenFL newer versions
 */
class Compatibility {
    /**
     * Helper method to convert ArrayBufferView to the right type
     */
    public static function toArrayBufferView(view:Dynamic):lime.utils.ArrayBufferView {
        return view;
    }
    
    /**
     * Helper method to convert data to DataPointer
     */
    public static function toDataPointer(data:Dynamic):lime.utils.DataPointer {
        return data;
    }
    
    /**
     * Helper method to convert ByteArray to Bytes
     */
    public static function toBytes(byteArray:Dynamic):lime.utils.Bytes {
        return byteArray;
    }
}
