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

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNatives();
	CreateForwards();
	
	RegPluginLibrary("casino");
	
	return APLRes_Success;
}

public void OnPluginStart()
{

}