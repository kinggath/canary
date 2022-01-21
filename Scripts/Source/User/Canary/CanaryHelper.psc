Scriptname Canary:CanaryHelper extends Quest Conditional

import Canary:DataStructures

Int Property iPapyrusDataVerification = 9235 autoReadOnly ; Arbitrary value we use to confirm that the quest is correctly holding papyrus data
String Property sExpectedPropertyName = "iSaveFileMonitor" autoReadOnly

Actor Property PlayerRef Auto Const Mandatory
GlobalVariable Property gGameLoadCounter Auto Const Mandatory
GlobalVariable Property gModVersion Auto Const Mandatory

Float Property fVersionWhenLastGameLoadedEventFired Auto Hidden Conditional
Float Property fLastLoadedGameTime Auto Hidden Conditional

CustomScriptQuest[] Property QuestsToCheck01 Auto Hidden
CustomScriptQuest[] Property QuestsToCheck02 Auto Hidden
CustomScriptQuest[] Property QuestsToCheck03 Auto Hidden
CustomScriptQuest[] Property QuestsToCheck04 Auto Hidden
CustomScriptQuest[] Property QuestsToCheck05 Auto Hidden
CustomScriptQuest[] Property QuestsToCheck06 Auto Hidden
CustomScriptQuest[] Property QuestsToCheck07 Auto Hidden
CustomScriptQuest[] Property QuestsToCheck08 Auto Hidden

Int Property iSelfMonitor Auto Hidden ; Used for Canary to monitor itself

Event OnQuestInit()
	HandleQuestInit()
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
	HandlePlayerLoadGame()
EndEvent

Function MessageDemo()
	Message testMessage = Game.GetFormFromFile(0x00000F9F, "CanarySaveFileMonitor.esl") as Message
	testMessage.Show()
EndFunction

Function HandleQuestInit()
	RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
	iSelfMonitor = iPapyrusDataVerification
EndFunction


Function HandlePlayerLoadGame()
	gGameLoadCounter.Mod(1.0)
	fLastLoadedGameTime = Utility.GetCurrentGameTime()	
	fVersionWhenLastGameLoadedEventFired = gModVersion.GetValue()
EndFunction


Function RegisterForMonitoring(Quest akRequester, String asCastAs)
	int iIndex = FindMonitoredQuestIndex(akRequester)
				
	if(iIndex < 0)		
		ScriptObject thisQuest = akRequester.CastAs(asCastAs)
				
		if( ! thisQuest)
			Debug.MessageBox("Canary: Failed to register a quest for monitoring. It likely does not have the requested script " + asCastAs + " applied.")
			return
		endif
		
		; Store the value we're checking for on the quest property
		thisQuest.SetPropertyValue(sExpectedPropertyName, iPapyrusDataVerification)
	
		CustomScriptQuest newEntry = new CustomScriptQuest
		newEntry.QuestToUse = akRequester
		newEntry.sCastAs = asCastAs
		
		if(QuestsToCheck01 == None)
			QuestsToCheck01 = new CustomScriptQuest[0]
		endif
		
		if(QuestsToCheck01.Length < 128)
			QuestsToCheck01.Add(newEntry)
		else
			if(QuestsToCheck02 == None)
				QuestsToCheck02 = new CustomScriptQuest[0]
			endif
			
			if(QuestsToCheck02.Length < 128)
				QuestsToCheck02.Add(newEntry)
			else
				if(QuestsToCheck03 == None)
					QuestsToCheck03 = new CustomScriptQuest[0]
				endif
				
				if(QuestsToCheck03.Length < 128)
					QuestsToCheck03.Add(newEntry)
				else
					if(QuestsToCheck04 == None)
						QuestsToCheck04 = new CustomScriptQuest[0]
					endif
					
					if(QuestsToCheck04.Length < 128)
						QuestsToCheck04.Add(newEntry)
					else
						if(QuestsToCheck05 == None)
							QuestsToCheck05 = new CustomScriptQuest[0]
						endif
						
						if(QuestsToCheck05.Length < 128)
							QuestsToCheck05.Add(newEntry)
						else
							if(QuestsToCheck06 == None)
								QuestsToCheck06 = new CustomScriptQuest[0]
							endif
							
							if(QuestsToCheck06.Length < 128)
								QuestsToCheck06.Add(newEntry)
							else
								if(QuestsToCheck07 == None)
									QuestsToCheck07 = new CustomScriptQuest[0]
								endif
								
								if(QuestsToCheck07.Length < 128)
									QuestsToCheck07.Add(newEntry)
								else
									if(QuestsToCheck08 == None)
										QuestsToCheck08 = new CustomScriptQuest[0]
									endif
									
									if(QuestsToCheck08.Length < 128)
										QuestsToCheck08.Add(newEntry)
									else
										Debug.Trace("[Canary] Save File Monitor system has max number of quests registered. This should not happen and likely means a mod has implemented this functionality incorrectly.")
									endif
								endif
							endif
						endif
					endif
				endif
			endif
		endif
	endif
EndFunction

Function RemoveByQuest(Quest akRemoveMe)
	int iIndex = FindMonitoredQuestIndex(akRemoveMe)
	RemoveByIndex(iIndex)
EndFunction

Function RemoveByIndex(Int aiIndex)
	if(aiIndex >= 896 && aiIndex < 1024)
		QuestsToCheck08.Remove(aiIndex - 896)
	elseif(aiIndex >= 768 && aiIndex < 896)
		QuestsToCheck07.Remove(aiIndex - 768)
	elseif(aiIndex >= 640 && aiIndex < 768)
		QuestsToCheck06.Remove(aiIndex - 640)		
	elseif(aiIndex >= 512 && aiIndex < 768)
		QuestsToCheck05.Remove(aiIndex - 512)
	elseif(aiIndex >= 384 && aiIndex < 512)
		QuestsToCheck04.Remove(aiIndex - 384)
	elseif(aiIndex >= 256 && aiIndex < 384)
		QuestsToCheck03.Remove(aiIndex - 256)
	elseif(aiIndex >= 128 && aiIndex < 256)
		QuestsToCheck02.Remove(aiIndex - 128)
	elseif(aiIndex >= 0 && aiIndex < 128)
		QuestsToCheck01.Remove(aiIndex)
	endif
EndFunction

Function RemoveMissingQuests()
	int i = QuestsToCheck01.Length - 1
	while(i >= 0)
		if(QuestsToCheck01[i].QuestToUse == None)
			QuestsToCheck01.Remove(i)
		endif
		
		i -= 1
	endWhile
	
	i = QuestsToCheck02.Length - 1
	while(i >= 0)
		if(QuestsToCheck02[i].QuestToUse == None)
			QuestsToCheck02.Remove(i)
		endif
		
		i -= 1
	endWhile
	
	i = QuestsToCheck03.Length - 1
	while(i >= 0)
		if(QuestsToCheck03[i].QuestToUse == None)
			QuestsToCheck03.Remove(i)
		endif
		
		i -= 1
	endWhile
	
	i = QuestsToCheck04.Length - 1
	while(i >= 0)
		if(QuestsToCheck04[i].QuestToUse == None)
			QuestsToCheck04.Remove(i)
		endif
		
		i -= 1
	endWhile
	
	i = QuestsToCheck05.Length - 1
	while(i >= 0)
		if(QuestsToCheck05[i].QuestToUse == None)
			QuestsToCheck05.Remove(i)
		endif
		
		i -= 1
	endWhile
	
	i = QuestsToCheck06.Length - 1
	while(i >= 0)
		if(QuestsToCheck06[i].QuestToUse == None)
			QuestsToCheck06.Remove(i)
		endif
		
		i -= 1
	endWhile
	
	i = QuestsToCheck07.Length - 1
	while(i >= 0)
		if(QuestsToCheck07[i].QuestToUse == None)
			QuestsToCheck07.Remove(i)
		endif
		
		i -= 1
	endWhile
	
	i = QuestsToCheck08.Length - 1
	while(i >= 0)
		if(QuestsToCheck08[i].QuestToUse == None)
			QuestsToCheck08.Remove(i)
		endif
		
		i -= 1
	endWhile
EndFunction


Int Function FindMonitoredQuestIndex(Quest akRequester)
	if ( akRequester == none )
		return -1
	endif
	
	int iIndex = GetQuestToCheckIndex(QuestsToCheck01, akRequester)
	if ( iIndex > -1 )
		return iIndex
	endif
	
	iIndex = GetQuestToCheckIndex(QuestsToCheck02, akRequester)
	if ( iIndex > -1 )
		return iIndex + 128
	endif
	
	iIndex = GetQuestToCheckIndex(QuestsToCheck03, akRequester)
	if ( iIndex > -1 )
		return iIndex + 256
	endif
	
	iIndex = GetQuestToCheckIndex(QuestsToCheck04, akRequester)
	if ( iIndex > -1 )
		return iIndex + 384
	endif
	
	iIndex = GetQuestToCheckIndex(QuestsToCheck05, akRequester)
	if ( iIndex > -1 )
		return iIndex + 512
	endif
	
	iIndex = GetQuestToCheckIndex(QuestsToCheck06, akRequester)
	if ( iIndex > -1 )
		return iIndex + 640
	endif
	
	iIndex = GetQuestToCheckIndex(QuestsToCheck07, akRequester)
	if ( iIndex > -1 )
		return iIndex + 768
	endif
	
	iIndex = GetQuestToCheckIndex(QuestsToCheck08, akRequester)
	if ( iIndex > -1 )
		return iIndex + 896
	endif
	
	; all checks failed
	return -1
EndFunction

int Function GetQuestToCheckIndex(CustomScriptQuest[] aCheckMe, Quest akRequester)
	if ( aCheckMe == none || aCheckMe.Length < 1 )
		return -1
	endif
	
	return aCheckMe.FindStruct("QuestToUse", akRequester)
EndFunction
