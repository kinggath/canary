; ---------------------------------------------
; Canary:API.psc - by kinggath
; ---------------------------------------------
; Reusage Rights ------------------------------
; You are free to use this script or portions of it in your own mods, provided you give me credit in your description and maintain this section of comments in any released source code (which includes the IMPORTED SCRIPT CREDIT section to give credit to anyone in the associated Import scripts below.
; 
; Warning !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; Do not directly recompile this script for redistribution without first renaming it to avoid compatibility issues issues with the mod this came from.
; 
; IMPORTED SCRIPT CREDIT
; N/A
; ---------------------------------------------

Scriptname Canary:API Hidden Const




; ------------------------------
; MonitorForDataLoss
;
; Description: Under certain circumstances, all script data from a mod's scripts can be lost in a save file. This includes variables set at run time, event registrations, and timers. (steps for reproducing this error are currently unknown - but it has been verified that the issue can occur)
;
; This system allows you to set up a property on a quest that Canary will set to a specific value and monitor for that value to change from what it set. If it changes, a warning will be presented to the user that they should roll back to a different save. 
;
; Parameters:
; akRequester - Your quest that will be monitored.
;
; asCastAs - The actual script name (and namespace if used) of the script your quest has on it that holds an integer property called iSaveFileMonitor.
;---------------------------------
Function MonitorForDataLoss(Quest akRequester, String asCastAs) global
	Canary:APIQuest API = GetAPI()
	
	if( ! API)
		Debug.Trace("[WSFW] Failed to get API.")
		return
	endif
	
	while( ! API.CanaryHelper.IsRunning())
		Utility.Wait(Utility.RandomFloat(1.0, 5.0))
	endWhile
	
	API.CanaryHelper.RegisterForMonitoring(akRequester, asCastAs)
EndFunction




	; -----------------------------------
	; -----------------------------------
	; Do NOT Use - Functions below here are needed by this API script only
	; -----------------------------------
	; -----------------------------------	



; ------------------------------
; GetAPI
;
; Description: Used internally by these functions to get simple access to properties
; ------------------------------

Canary:APIQuest Function GetAPI() global
	Canary:APIQuest API = Game.GetFormFromFile(0x00000F99, "CanarySaveFileMonitor.esl") as Canary:APIQuest
	
	return API
EndFunction