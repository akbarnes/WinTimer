#tag Class
Protected Class App
Inherits Application
	#tag MenuHandler
		Function TimerPause() As Boolean Handles TimerPause.Action
			PauseTimer
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function TimerPreferences() As Boolean Handles TimerPreferences.Action
			Dim prefsDialog as New PrefsWindow
			prefsDialog.ShowModal
			
			App.CountdownSeconds = prefsDialog.CountDownSeconds
			MainWindow.UpdateTime
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function TimerReset() As Boolean Handles TimerReset.Action
			ResetTimer
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function TimerStart() As Boolean Handles TimerStart.Action
			StartTimer
			Return True
			
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h0
		Sub LoadPreferences()
		  
		  Dim prefFolder as FolderItem
		  
		  prefFolder = SpecialFolder.ApplicationData.Child("WinTimer")
		  
		  if prefFolder <> Nil and prefFolder.Exists then
		    Dim prefFile as FolderItem = prefFolder.Child("Preferences.json")
		    
		    Dim tis as TextinputStream
		    
		    Try
		      tis = TextInputStream.Open(prefFile)
		      
		      Dim prefs as JSONItem
		      prefs = New JSONItem(tis.ReadAll)
		      tis.Close
		      
		      App.CountdownSeconds = prefs.Value("CountdownSeconds")
		    Catch
		    End Try
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PauseTimer()
		  App.TimerState = App.TIMER_PAUSED
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResetTimer()
		  if App.TimerState = App.TIMER_PAUSED then
		    App.TimerState = App.TIMER_STOPPED
		  end if
		  
		  if App.TimerState = App.TIMER_STOPPED then
		    App.SecondsRemaining = App.CountdownSeconds
		  end
		  
		  MainWindow.UpdateTime
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SavePreferences()
		  Dim prefs as New JSONItem
		  
		  prefs.Value("CountdownSeconds") = App.CountdownSeconds
		  
		  Dim prefFolder as FolderItem
		  
		  prefFolder = SpecialFolder.ApplicationData.Child("WinTimer")
		  
		  if prefFolder <> Nil then
		    if not prefFolder.Exists then
		      prefFolder.CreateAsFolder
		    end if
		    
		    Dim prefFile as FolderItem = prefFolder.Child("Preferences.json")
		    
		    Dim tos as TextOutputStream
		    tos = TextOutputStream.Create(prefFile)
		    tos.Write(prefs.ToString)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StartTimer()
		  if App.TimerState = App.TIMER_STOPPED then
		    App.SecondsRemaining = App.CountdownSeconds
		  end if
		  
		  App.TimerState = App.TIMER_RUNNING
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		CountdownSeconds As Integer = 15
	#tag EndProperty

	#tag Property, Flags = &h0
		SecondsRemaining As Integer = 1500
	#tag EndProperty

	#tag Property, Flags = &h0
		TimerState As Integer = App.TIMER_STOPPED
	#tag EndProperty


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant

	#tag Constant, Name = TIMER_PAUSED, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TIMER_RUNNING, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TIMER_STOPPED, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="CountdownSeconds"
			Visible=false
			Group="Behavior"
			InitialValue="15"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SecondsRemaining"
			Visible=false
			Group="Behavior"
			InitialValue="1500"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TimerState"
			Visible=false
			Group="Behavior"
			InitialValue="App.TIMER_STOPPED"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
