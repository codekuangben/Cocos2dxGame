package com.pblabs.engine.debug
{
	//import com.pblabs.engine.serialization.TypeUtility;
	import com.util.DebugBox;
	import com.util.PBUtil;
	
	import flash.external.ExternalInterface;

    /**
     * The Logger class provides mechanisms to print and listen for errors, warnings,
     * and general messages. The built in 'trace' command will output messages to the
     * console, but this allows you to differentiate between different types of
     * messages, give more detailed information about the origin of the message, and
     * listen for log events so they can be displayed in a UI component.
     * 
     * You can use Logger for localized logging by instantiating an instance and
     * referencing it. For instance:
     * 
     * <code>protected static var logger:Logger = new Logger(MyClass);
     * logger.print("Output for MyClass.");</code>
     *  
     * @see LogEntry
     */
    public class Logger
    {
        /**
         * Prints a general message to the log. Log entries created with this method
         * will have the MESSAGE type.
         * 
         * @param reporter The object that reported the message. This can be null.
         * @param message The message to print to the log.
         */
        public static function print(reporter:*, message:String):void
		{
			logout(reporter, null, message, LogColor.PRINT);
        }
        
		/**
		 * Prints an info message to the log. Log entries created with this method
		 * will have the INFO type.
		 * 
		 * @param reporter The object that reported the warning. This can be null.
		 * @param method The name of the method that the warning was reported from.
		 * @param message The warning to print to the log.
		 */
		public static function info(reporter:*, method:String, message:String):void
		{
			logout(reporter, method, message, LogColor.INFO);
		}
		
		/**
		 * Prints a debug message to the log. Log entries created with this method
		 * will have the DEBUG type.
		 * 
		 * @param reporter The object that reported the debug message. This can be null.
		 * @param method The name of the method that the debug message was reported from.
		 * @param message The debug message to print to the log.
		 */
		public static function debug(reporter:*, method:String, message:String):void
		{
			logout(reporter, method, message, LogColor.DEBUG);
		}
		
        /**
         * Prints a warning message to the log. Log entries created with this method
         * will have the WARNING type.
         * 
         * @param reporter The object that reported the warning. This can be null.
         * @param method The name of the method that the warning was reported from.
         * @param message The warning to print to the log.
         */
        public static function warn(reporter:*, method:String, message:String):void
        {
			logout(reporter, method, message, LogColor.WARN);
			DebugBox.info(message);
        }
        
        /**
         * Prints an error message to the log. Log entries created with this method
         * will have the ERROR type.
         * 
         * @param reporter The object that reported the error. This can be null.
         * @param method The name of the method that the error was reported from.
         * @param message The error to print to the log.
         */
        public static function error(reporter:*, method:String, message:String):void
        {
			logout(reporter, method, message, LogColor.ERROR);
			DebugBox.info(message);
        }
		
		public static function logout(reporter:*, method:String, message:String, type:String = "1"):void
		{
			if (PBUtil.LOGGEROPEN)
			{
				var cmd:String;
				if(LogColor.PRINT == type)
				{
					cmd = "console.info";
				}
				else if(LogColor.INFO == type)
				{
					cmd = "console.info";
				}
				else if(LogColor.DEBUG == type)
				{
					cmd = "console.debug";
				}
				else if(LogColor.WARN == type)
				{
					cmd = "console.warn";
				}
				else if(LogColor.ERROR == type)
				{
					cmd = "console.error";
				}
				else
				{
					cmd = "console.log";
				}

				if (PBUtil.TRACESTACK)
				{
					if (ExternalInterface.available)
					{
						ExternalInterface.call(cmd, type + ": " + PBUtil.debug_printStackTrace() + " - " + message);
					}
					else
					{
						trace(type + ": " + PBUtil.debug_printStackTrace() + " - " + message);
					}
				}
				else
				{
					if (ExternalInterface.available)
					{
						ExternalInterface.call(cmd, type + ": " + message);
					}
					else
					{
						trace(type + ": " + message);
					}
				}
			}
		}
    }
}