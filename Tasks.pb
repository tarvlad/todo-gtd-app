Procedure.s Tasks_GetDataPath()
  Define HomeDir.s
  
  HomeDir = GetHomeDirectory()
  ; TODO consider place in AppData\Local
  ProcedureReturn HomeDir + "GTD.dat"
EndProcedure

Procedure Tasks_Lock()
  Define LockPath.s
  LockPath = Tasks_GetDataPath() + ".lock"
  
  Define LockFileNum
  LockFileNum = ReadFile(#PB_Any, LockPath, #PB_File_NoBuffering)
  If LockFileNum <> 0
    MessageRequester("ERROR", "App is already running. If you sure that not then delete lock file " + LockPath)
    End 3
  EndIf
  ; TODO possible race there
  LockFileNum = CreateFile(#PB_Any, LockPath, #PB_File_NoBuffering)
  CloseFile(LockFileNum)
EndProcedure

Procedure Tasks_Unlock()
  DeleteFile(Tasks_GetDataPath() + ".lock")
EndProcedure

#GTD_Selected_Nothing = -1
#GTD_Selected_Basket = 0
#GTD_Selected_HardPlanned = 1
#GTD_Selected_SoftPlanned = 2
#GTD_Selected_Sometime = 3
#GTD_Selected_ReferenceMaterials = 4
#GTD_Selected_Delegated = 5

Procedure Tasks_SaveTasksListToDisk(FileNum, List Tasks.s())
  Define I
  
  For I = 0 To ListSize(Tasks()) - 1
    SelectElement(Tasks(), I)
    Define Element.s
    Element = Tasks()
    
    WriteString(FileNum, Element)
    WriteCharacter(FileNum, 0)
  Next I
EndProcedure

Procedure Tasks_SaveTasksToDisk()
  Define DataPath.s
  Define FileNum
  
  DataPath = Tasks_GetDataPath()
  FileNum = OpenFile(#PB_Any, DataPath)
  If Not FileNum
    MessageRequester("ERROR", "Couldn't open data file for save tasks")
    End 2
  EndIf
  
  Define.s Header
  Header = Str(ListSize(Tasks\Basket())) + "\n"
  Header + Str(ListSize(Tasks\HardPlanned())) + "\n"
  Header + Str(ListSize(Tasks\SoftPlanned())) + "\n"
  Header + Str(ListSize(Tasks\Sometime())) + "\n"
  Header + Str(ListSize(Tasks\ReferenceMaterials())) + "\n"
  Header + Str(ListSize(Tasks\Delegated())) + "\n"
  Header = UnescapeString(Header)
  
  WriteString(FileNum, Header)
  Tasks_SaveTasksListToDisk(FileNum, Tasks\Basket())
  Tasks_SaveTasksListToDisk(FileNum, Tasks\HardPlanned())
  Tasks_SaveTasksListToDisk(FileNum, Tasks\SoftPlanned())
  Tasks_SaveTasksListToDisk(FileNum, Tasks\Sometime())
  Tasks_SaveTasksListToDisk(FileNum, Tasks\ReferenceMaterials())
  Tasks_SaveTasksListToDisk(FileNum, Tasks\Delegated())
  CloseFile(FileNum)
EndProcedure

Procedure Tasks_ReadTasks(FileNum, TasksNum, List Storage.s())
  Define I
  Define Buffer.s
  For I = 0 To TasksNum - 1
    Buffer = ReadString(FileNum, #PB_File_IgnoreEOL)
    AddElement(Storage())
    Storage() = Buffer
  Next I
  SelectElement(Storage(), 0)
EndProcedure

Procedure Tasks_AddTask(List Storage.s(), Task.s)
  AddElement(Storage())
  Storage() = Task
  SelectElement(Storage(), 0)
EndProcedure

Procedure Tasks_ReadData()
  Define DataPath.s
  Define FileNum
  
  DataPath = Tasks_GetDataPath()
  
  FileNum = ReadFile(#PB_Any, DataPath.s)
  If FileNum = 0
    FileNum = CreateFile(#PB_Any, DataPath.s)
    Define.s Header
    Define.s DefaultValue
    DefaultValue = "0\n"
    
    Header = DefaultValue
    Header + DefaultValue
    Header + DefaultValue
    Header + DefaultValue
    Header + DefaultValue
    Header + DefaultValue
    
    WriteString(FileNum, UnescapeString(Header))
    CloseFile(FileNum)
    
    FileNum = ReadFile(#PB_Any, DataPath.s)
    If Not FileNum
      MessageRequester("ERROR", "Couldn't open data file")
      End 1
    EndIf
  EndIf
  
  Define BasketNum
  Define HardPlannedNum
  Define SoftPlannedNum
  Define SometimeNum
  Define ReferenceMaterialsNum
  Define DelegatedNum
  
  BasketNum = Val(ReadString(FileNum))
  HardPlannedNum = Val(ReadString(FileNum))
  SoftPlannedNum = Val(ReadString(FileNum))
  SometimeNum = Val(ReadString(FileNum))
  ReferenceMaterialsNum = Val(ReadString(FileNum))
  DelegatedNum = Val(ReadString(FileNum))
  
  Tasks\SelectedNow = #GTD_Selected_Nothing
  NewList Tasks\Basket()
  NewList Tasks\HardPlanned()
  NewList Tasks\SoftPlanned()
  NewList Tasks\Sometime()
  NewList Tasks\ReferenceMaterials()
  NewList Tasks\Delegated()
  
  Tasks_ReadTasks(FileNum, BasketNum, Tasks\Basket())
  Tasks_ReadTasks(FileNum, HardPlannedNum, Tasks\HardPlanned())
  Tasks_ReadTasks(FileNum, SoftPlannedNum, Tasks\SoftPlanned())
  Tasks_ReadTasks(FileNum, SometimeNum, Tasks\Sometime())
  Tasks_ReadTasks(FileNum, ReferenceMaterialsNum, Tasks\ReferenceMaterials())
  Tasks_ReadTasks(FileNum, DelegatedNum, Tasks\Delegated())
  CloseFile(FileNum)
EndProcedure
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 18
; FirstLine = 6
; Folding = --
; EnableXP
; DPIAware