Scriptname Canary:CanaryLocationTrigger extends Quest

;/
The goal of this system is to monitor for save files losing papyrus data, which has been proven to be possible under certain circumstances, this includes variables changed at runtime, event registrations, and timers - effectively breaking the affected mod's functionality. (Steps to reproduce this issue are currently unknown)

This is done by recording a specific value in each quest registering to be monitored. This script is configured to run whenever the player changes location the first time each time they load their save, if the specific value is not found on the registered quest, the player will be warned that they should roll back their save file.
/;

import Canary:DataStructures

String sPCHelpMessage = "Please upload your .fos save file and a few other recent save files for this character to dropbox or google drive, and share them with me. \n\nIf you recall what you last did with the character, or your load order, such as adding/removing/upgrading any mods, include those in your message. I can be reached on the simsettlements.com forums or nexusmods.com. \n\nThanks! - kinggath" Const

Canary:CanaryHelper Property CanaryHelper Auto Const Mandatory
GlobalVariable Property gGameLoadReactedCounter Auto Const Mandatory
Message Property WarningMessage Auto Const Mandatory

Event OnStoryChangeLocation(ObjectReference akActor, Location akOldLocation, Location akNewLocation)
	; Make sure CanaryHelper is sill registered for game load
	CanaryHelper.RegisterForRemoteEvent(Game.GetPlayer(), "OnPlayerLoadGame")

	Bool bRerunCompleted = false
	Float fGameLoadCounter = CanaryHelper.gGameLoadCounter.GetValue()
	if(fGameLoadCounter > gGameLoadReactedCounter.GetValue())
		RecheckQuests()
		
		; Now update our reacted counter to match the game load counter
		gGameLoadReactedCounter.SetValue(fGameLoadCounter)
		bRerunCompleted = true
	elseif(CanaryHelper.gModVersion.GetValue() > CanaryHelper.fVersionWhenLastGameLoadedEventFired || Utility.GetCurrentGameTime() - 3.0 > CanaryHelper.fLastLoadedGameTime)
		; The mod version has changed or it has been more than 3 in-game days since CanaryHelper last triggered, to be safe let's go ahead and RecheckQuests anyway.
			; Update CanaryHelper so this won't trigger again for the exact same conditions
		CanaryHelper.fLastLoadedGameTime = Utility.GetCurrentGameTime()
		CanaryHelper.fVersionWhenLastGameLoadedEventFired = CanaryHelper.gModVersion.GetValue()
		
		RecheckQuests()
		bRerunCompleted = true
	endif
	
	if( ! bRerunCompleted)
		;Debug.Notification("RecheckQuests not needed.")
	endif
	
	Stop()
EndEvent


Function RecheckQuests()
	; Check self to start
	if(CanaryHelper.iSelfMonitor != CanaryHelper.iPapyrusDataVerification)
		WarnPlayer()
		return
	endif
	
	CustomScriptQuest[] thisGroup
	
	thisGroup = CanaryHelper.QuestsToCheck01
	RerunGroupChecks(thisGroup)
	thisGroup = CanaryHelper.QuestsToCheck02
	RerunGroupChecks(thisGroup)
	thisGroup = CanaryHelper.QuestsToCheck03
	RerunGroupChecks(thisGroup)
	thisGroup = CanaryHelper.QuestsToCheck04
	RerunGroupChecks(thisGroup)
	thisGroup = CanaryHelper.QuestsToCheck05
	RerunGroupChecks(thisGroup)
	thisGroup = CanaryHelper.QuestsToCheck06
	RerunGroupChecks(thisGroup)
	thisGroup = CanaryHelper.QuestsToCheck07
	RerunGroupChecks(thisGroup)
	thisGroup = CanaryHelper.QuestsToCheck08
	RerunGroupChecks(thisGroup)
EndFunction


Function RerunGroupChecks(CustomScriptQuest[] aGroup)
	if(aGroup == None || aGroup.Length == 0)
		return
	endif
	
	int iPapyrusDataVerification = CanaryHelper.iPapyrusDataVerification
	String sExpectedPropertyName = CanaryHelper.sExpectedPropertyName
	
	int i = 0
	while(i < aGroup.Length)
		if(aGroup[i].QuestToUse != None)
			ScriptObject thisQuest = aGroup[i].QuestToUse.CastAs(aGroup[i].sCastAs)
			
			if(thisQuest)
				if(thisQuest.GetPropertyValue(sExpectedPropertyName) as Int != iPapyrusDataVerification)
					WarnPlayer()
					
					return
				endif
			endif
		endif
		
		i += 1
	endWhile
EndFunction


Function WarnPlayer()
	int iConfirm = WarningMessage.Show()
	if(iConfirm == 1)
		Debug.MessageBox(sPCHelpMessage)
	endif
EndFunction