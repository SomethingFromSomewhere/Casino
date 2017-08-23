#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name = "[CORE] Обдираловка",
	author = "Someone",
	version = "1.0",
	url = "http://www.hlmod.ru/"
};

#include "casino/natives.sp"
#include "casino/forwards.sp"
#include "casino/menu.sp"
#include "casino/functions.sp"

char g_sCurrentGame[MAX_MODULE_NAME_LENGTH];
ArrayList g_hGames, g_hSorting;
StringMap g_hGamesTrie;
Menu g_hMenu;
int g_iPlayerValue[MAXPLAYERS+1];
bool g_bPlaying[MAXPLAYERS+1], g_bGameRunning, g_bStarted;

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNatives();
	CreateForwards();
	
	RegPluginLibrary("casino");
	
	return APLRes_Success;
}

public void OnPluginStart()
{
	LoadTranslations("casino.core.phrases");
	LoadTranslations("casino.modules.phrases");
	g_hGames = new ArrayList(ByteCountToCells(MAX_CLASS_NAME_LENGTH));
	g_hGamesTrie = new StringMap();
	g_hMenu = new Menu(ClassesMenu_Handled, MenuAction_Select|MenuAction_Display|MenuAction_DisplayItem|MenuAction_DrawItem);

	LoadSortings();
	RegConsoleCmd("sm_casino", CMD_CLASS);
	Forward_OnPluginStart();
}

public Action CMD_CLASS(int iClient, int iArgs)
{
	DisplayCasinoMenu(iClient);
	return Plugin_Handled;
}

void LoadSortings()
{
	char sBuffer[MAX_CLASS_NAME_LENGTH];
	Handle hFile = OpenFile("addons/sourcemod/data/casino/sorting.ini", "r");
	if (hFile != INVALID_HANDLE)
	{
		g_hSorting = new ArrayList(ByteCountToCells(MAX_CLASS_NAME_LENGTH));
		while (!IsEndOfFile(hFile) && ReadFileLine(hFile, sBuffer, MAX_CLASS_NAME_LENGTH))
		{
			TrimString(sBuffer);
			if (sBuffer[0])
			{
				g_hSorting.PushString(sBuffer);
			}
		}
	}
	//else	SetFailState("[Sorting] [ERROR] Config file not found.");
}

public void OnClientPutInServer(int iClient)
{
	if(!IsFakeClient(iClient))
	{
		DB_LoadPlayer(iClient);
	}
}