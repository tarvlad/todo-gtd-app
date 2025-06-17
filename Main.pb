EnableExplicit

Structure TasksStorage
  SelectedNow.i
  List Basket.s()
  List HardPlanned.s()
  List SoftPlanned.s()
  List Sometime.s()
  List ReferenceMaterials.s()
  List Delegated.s()
EndStructure

Global Tasks.TasksStorage
XIncludeFile "Tasks.pb"

XIncludeFile "TasksListSelector.pb"

Tasks_Lock()
Tasks_ReadData()

OpenTaskListSelector_Window()

Define Event
Repeat
  Event = WaitWindowEvent()
  
  Select Event
    Case #PB_Event_CloseWindow
      If EventWindow() = TaskListSelector_Window
        Tasks_SaveTasksToDisk()
        Break
      Else
        If EventWindow() = TasksListUnit_Window
          TasksListSelector_DumpTasksToList()
        EndIf
        CloseWindow(EventWindow())
      EndIf
    Case TaskListSelector_Window_Events(Event)
      Continue
    Case TasksListUnit_Window_Events(Event)
      Continue
  EndSelect
ForEver

Tasks_Unlock()
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 43
; FirstLine = 19
; EnableXP
; DPIAware
; Executable = GTD.exe