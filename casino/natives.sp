void CreateNatives()
{
	CreateNative("CC_ShowCasinoMenu",	Native_ShowClassesMenu);
	CreateNative("CC_IsCoreStarted",	Native_IsCoreStarted);
	
	CreateNative("CC_StartGame", 		Native_StartGame);
	CreateNative("CC_IsGameRunning", 		Native_IsGameRunning);
	CreateNative("CC_GetCurrentGame", 	Native_GetCurrentGame);
	CreateNative("CC_EndGame", 			Native_EndGame);
	
	CreateNative("CC_AddModule",		Native_AddModule);
	CreateNative("CC_RemoveModule",		Native_RemoveModule);
}

public int Native_AddModule(Handle hPlugin, int numParams)
{
	char sBuffer[MAX_MODULE_NAME_LENGTH];
	GetNativeString(1, sBuffer, MAX_MODULE_NAME_LENGTH);
	if(sBuffer[0])
	{
		if(g_hClasses.FindString(sBuffer) == -1)
		{	
			AddGameToMenu(sBuffer);
			DataPack hPack = new DataPack();
			hPack.WriteCell(hPlugin);
			hPack.WriteFunction(GetNativeCell(3));
			hPack.WriteFunction(GetNativeCell(4));
			hPack.WriteFunction(GetNativeCell(5));
			g_hCasinoTrie.SetValue(sBuffer, hPack);
			g_hGames.PushString(sBuffer);
		}
		else	ThrowNativeError(SP_ERROR_NATIVE, "[AddModule] [ERROR] Module '%s' already exists.", sBuffer);
	}
	else ThrowNativeError(SP_ERROR_NATIVE, "[AddModule] [ERROR] Empty module name.");
}

public int Native_RemoveModule(Handle hPlugin, int numParams)
{
	char sBuffer[MAX_MODULE_NAME_LENGTH];
	GetNativeString(1, sBuffer, MAX_MODULE_NAME_LENGTH);
	if(sBuffer[0])
	{
		if(!Delete(sBuffer))	ThrowNativeError(SP_ERROR_NATIVE, "[RemoveModule] [ERROR] Module '%s' not found.", sBuffer);
	}
	else ThrowNativeError(SP_ERROR_NATIVE, "[RemoveModule] [ERROR] Empty module name.");
}