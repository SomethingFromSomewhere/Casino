static Handle g_hForward_OnPluginStart, g_hForward_OnValueChange, g_hForward_OnSelectGame, g_hForward_OnGameStart, g_hForward_OnGameEnd;

void CreateForwards()
{
	g_hForward_OnPluginStart 	= 	CreateGlobalForward("CC_OnCoreStarted",		ET_Ignore);
	g_hForward_OnValueChange 	=	CreateGlobalForward("CC_OnValueChange",		ET_Single, 		Param_Cell, 	Param_Cell, 	Param_Cell);
	g_hForward_OnSelectGame	 	= 	CreateGlobalForward("CC_OnSelectGame", 		ET_Single, 		Param_Cell, 	Param_String);
	g_hForward_OnGameStart 		=	CreateGlobalForward("CC_OnGameStart"		ET_Single, 		Param_String);
	g_hForward_OnGameEnd 		=	CreateGlobalForward("CC_OnGameEnd"			ET_Ignore, 		Param_String);
}

void Forward_OnPluginStart()
{
	Call_StartForward(g_hForward_OnPluginStart);
	Call_Finish();
	g_bStarted = true;
}

bool Forward_OnValueChange(int iClient, int iOldValue, int iNewValue)
{
	bool bResult = true;
	Call_StartForward(g_hForward_OnValueChange);
	Call_PushCell(iClient);
	Call_PushCell(iOldValue);
	Call_PushCellRef(iNewValue);
	Call_Finish(bResult);
	return bResult;
}

bool Forward_OnSelectGame(int iClient, const char[] sName)
{
	bool bResult = true;
	Call_StartForward(g_hForward_OnSelectGame);
	Call_PushCell(iClient);
	Call_PushString(sName);
	Call_Finish(bResult);
	return bResult;
}

bool Forward_OnGameStart(int iClient, const char[] sName)
{
	bool bResult = true;
	Call_StartForward(g_hForward_OnGameStart);
	Call_PushString(sName);
	Call_Finish(bResult);
	if(bResult)	g_bGameRunning = true;
	
	return bResult;
}

void Forward_OnGameEnd()
{
	Call_StartForward(g_hForward_OnGameEnd);
	Call_Finish();
	g_bGameRunning = false;
}