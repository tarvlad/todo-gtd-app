XIncludeFile "TasksListUnitForm.pbf"

Declare TasksListSelector_DumpTasksToList()

Procedure TasksListUnit_AddTask()
  Define Input.s
  Input = Trim(GetGadgetText(TasksListUnit_String))
  If Input <> ""
    AddGadgetItem(TasksListUnit_ListView, -1, Input)
    SetGadgetText(TasksListUnit_String, "")
  EndIf
EndProcedure

Procedure TasksListUnit_DelTask()
  Define SelectedIdx
  SelectedIdx = GetGadgetState(TasksListUnit_ListView)
  If SelectedIdx <> -1
    RemoveGadgetItem(TasksListUnit_ListView, SelectedIdx)
  EndIf
EndProcedure

Procedure TasksListUnit_AddEvent(EventType)
  If EventType = #PB_EventType_LeftClick
      TasksListUnit_AddTask()
  EndIf
EndProcedure

Procedure TasksListUnit_DelEvent(EventType)
  If EventType = #PB_EventType_LeftClick
    TasksListUnit_DelTask()
  EndIf
EndProcedure
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 23
; FirstLine = 8
; Folding = -
; EnableXP
; DPIAware