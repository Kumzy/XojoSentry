#tag Class
Protected Class App
Inherits MobileApplication
	#tag CompatibilityFlags = TargetIOS
	#tag Event
		Sub Activated()
		  if app.Sentry <> nil then
		    app.Sentry.AddBreadcrumb(CurrentMethodName, "")
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Sub Deactivating()
		  if app.Sentry <> nil then
		    app.Sentry.AddBreadcrumb(CurrentMethodName, "")
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Sub LowMemoryWarning()
		  
		  //Add a breadcrumb for LowMemoryWarning
		  
		  Dim message As String
		  
		  dim ObjectCount as integer
		  Dim memoryUsed As Integer
		  ObjectCount  = Runtime.ObjectCount
		  MemoryUsed  = Round(Runtime.MemoryUsed / 10000) / 100
		  
		  message = "ObjectCount: " + ObjectCount.ToString + EndOfLine + _
		  "MemoryUsed: " + memoryUsed.ToString + " MB"
		  
		  if app.Sentry <> nil then
		    app.Sentry.AddBreadcrumb(CurrentMethodName, message)
		  end if
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  
		  
		  
		  Dim DSN As String = "<<YOUR DSN>>"
		  
		  //Initialise Sentry
		  If DSN.IsEmpty or DSN = "<<YOUR DSN>>" then
		    Break //Get a DSN string from https://sentry.io
		    
		    Return
		  End If
		  
		  self.sentry = SentryController.GetInstance( DSN )
		  self.sentry.SendOfflineExceptions //Send exceptions that were triggered when offline
		  
		  
		  //If necessary, Sentry has a few options
		  'self.sentry.Options.get_battery_status = True //Only relevant on iOS
		  self.sentry.Options.include_StackFrame_address = False
		  self.sentry.Options.max_breadcrumbs = 100
		  self.sentry.Options.sample_rate = 1.0 //Keep this value at 1.0 when debugging, change value for a released app
		  
		  
		  
		  //If your app handles user authentication add the info to sentry
		  
		  Var user as new Xojo_Sentry.SentryUser
		  user.email = "name@example.com"
		  user.language = "en" //The language the user is running the app in
		  user.locale = locale.Current
		  'user.ip = "1.1.1.1" //Uncomment this if necessary. Default is "{{auto}}"
		  user.user_id = "1234" //The user's unique ID
		  
		  self.sentry.user = user
		End Sub
	#tag EndEvent

	#tag Event
		Function UnhandledException(exc As RuntimeException) As Boolean
		  #if DebugBuild
		    Dim reason As String
		    reason = exc.Message
		  #endif
		  
		  //Exception
		  
		  try
		    #if DebugBuild
		      app.Sentry.SubmitException(exc, "", "", Xojo_Sentry.errorLevel.debug)
		    #else
		      app.Sentry.SubmitException(exc, "", "", Xojo_Sentry.errorLevel.error)
		    #endif
		    
		    
		    
		    //Make sure we do not create another exception by sending it to Sentry
		  Catch err
		    
		  end try
		  
		  //Return true to let the app running
		  Return True
		End Function
	#tag EndEvent


	#tag Property, Flags = &h0
		sentry As SentryController
	#tag EndProperty


End Class
#tag EndClass
