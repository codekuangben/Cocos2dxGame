package com.pblabs.engine.serialization
{
    //import com.pblabs.engine.debug.Logger;
    
    //import flash.utils.Dictionary;
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    /**
     * TypeUtility is a static class containing methods that aid in type
     * introspection and reflection.
     */
    public class TypeUtility
    {        
        /**
         * Returns the fully qualified name of the type
         * of the passed in object.
         * 
         * @param object The object whose type is being retrieved.
         * 
         * @return The name of the specified object's type.
         */
        public static function getObjectClassName(object:*):String
        {
            return flash.utils.getQualifiedClassName(object);
        }
        
        /**
         * Returns the Class object for the given class.
         * 
         * @param className The fully qualified name of the class being looked up.
         * 
         * @return The Class object of the specified class, or null if wasn't found.
         */
        public static function getClassFromName(className:String):Class
        {
            return getDefinitionByName(className) as Class;
        }
        
        public static function getClass(item:*):Class
        {
            if(item is Class || item == null)
                return item;
            
            return Object(item).constructor;
        }
    }
}