XIncludeFile "TasksListSelectorForm.pbf"
XIncludeFile "TasksListUnit.pb"

Procedure TasksListSelector_PutTasksToView(List Tasks.s())
  Define NumElements
  Define I
  NumElements = ListSize(Tasks())
  ClearGadgetItems(TasksListUnit_ListView)
  
  For I = 0 To NumElements - 1
    Define Element.s
    SelectElement(Tasks(), I)
    Element = Tasks()
    AddGadgetItem(TasksListUnit_ListView, -1, Element)
  Next I
  
  SelectElement(Tasks(), 0)
EndProcedure

Procedure TasksListSelector_DumpTasksToGivenList(List Selected.s())
  ClearList(Selected())
  
  Define NumElements
  
  Define I
  NumElements = CountGadgetItems(TasksListUnit_ListView)
  For I = 0 To NumElements - 1
    Define Element.s
    Element = GetGadgetItemText(TasksListUnit_ListView, I)
    AddElement(Selected())
    Selected() = Element
  Next I
  ClearGadgetItems(TasksListUnit_ListView)
  SelectElement(Selected(), 0)
EndProcedure

Procedure TasksListSelector_DumpTasksToList()
  Select Tasks\SelectedNow
    Case #GTD_Selected_Basket
      TasksListSelector_DumpTasksToGivenList(Tasks\Basket())
    Case #GTD_Selected_HardPlanned
      TasksListSelector_DumpTasksToGivenList(Tasks\HardPlanned())
    Case #GTD_Selected_SoftPlanned
      TasksListSelector_DumpTasksToGivenList(Tasks\SoftPlanned())
    Case #GTD_Selected_Sometime
      TasksListSelector_DumpTasksToGivenList(Tasks\Sometime())
    Case #GTD_Selected_ReferenceMaterials
      TasksListSelector_DumpTasksToGivenList(Tasks\ReferenceMaterials())
    Case #GTD_Selected_Delegated
      TasksListSelector_DumpTasksToGivenList(Tasks\Delegated())
  EndSelect
EndProcedure

Procedure TasksListSelector_ButtonEvent(EventType, ExpectedEventType, ExpectedSelectedNow, List RelatedList.s())
  If EventType = ExpectedEventType
    If Not IsWindow(TasksListUnit_Window)
      OpenTasksListUnit_Window()
    Else
      If Tasks\SelectedNow <> ExpectedSelectedNow
        TasksListSelector_DumpTasksToList()
      EndIf
    EndIf
    Tasks\SelectedNow = ExpectedSelectedNow
    TasksListSelector_PutTasksToView(RelatedList())
  EndIf
EndProcedure

Procedure TasksListSelector_BasketButtonEvent(EventType)
  TasksListSelector_ButtonEvent(EventType, #PB_EventType_LeftClick, #GTD_Selected_Basket, Tasks\Basket())
EndProcedure

Procedure TasksListSelector_HardPlannedButtonEvent(EventType)
  TasksListSelector_ButtonEvent(EventType, #PB_EventType_LeftClick, #GTD_Selected_HardPlanned, Tasks\HardPlanned())
EndProcedure

Procedure TasksListSelector_SoftPlannedButtonEvent(EventType)
  TasksListSelector_ButtonEvent(EventType, #PB_EventType_LeftClick, #GTD_Selected_SoftPlanned, Tasks\SoftPlanned())
EndProcedure

Procedure TasksListSelector_SometimeButtonEvent(EventType)
  TasksListSelector_ButtonEvent(EventType, #PB_EventType_LeftClick, #GTD_Selected_Sometime, Tasks\Sometime())
EndProcedure

Procedure TasksListSelector_ReferenceMaterialsButtonEvent(EventType)
  TasksListSelector_ButtonEvent(EventType, #PB_EventType_LeftClick, #GTD_Selected_ReferenceMaterials, Tasks\ReferenceMaterials())
EndProcedure

Procedure TasksListSelector_DelegatedButtonEvent(EventType)
  TasksListSelector_ButtonEvent(EventType, #PB_EventType_LeftClick, #GTD_Selected_Delegated, Tasks\Delegated())
EndProcedure
; IDE Options = PureBasic 6.21 (Windows - x64)
; CursorPosition = 5
; Folding = --
; EnableXP
; DPIAware