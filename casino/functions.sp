bool Delete(const char[] sModule)
{
	char sItem[MAX_GAME_NAME_LENGTH];
	int i, b, iSize = GetMenuItemCount(g_hMenu);
	DataPack hPack;
	
	for(i = 0; i < iSize; i++)
	{
		g_hMenu.GetItem(i, sItem, sizeof(sItem));
		if(strcmp(sItem, sModule, true) == 0)
		{
			g_hGamesTrie.GetValue(sModule, hPack);
			delete hPack;
			g_hGamesTrie.Remove(sModule);
			g_hGames.Erase(g_hGames.FindString(sModule));
			g_hMenu.RemoveItem(i);
			
			// Возврат фишек после выгрузки модуля, если игра была активна.
			
			return true;
		}
	}
	return false;
}

void AddGameToMenu(const char[] sModule)
{
	if (g_hSorting != null)
	{
		ResortClassesArray();
		
		g_hMenu.RemoveAllItems();
		
		int i, iSize = g_hClasses.Length;
		char sBuffer[MAX_GAME_NAME_LENGTH];
		for (i = 0; i < iSize; i++)
		{
			g_hClasses.GetString(i, sBuffer, MAX_GAME_NAME_LENGTH);
			g_hMenu.AddItem(sBuffer, sBuffer);
		}
	}
	else	g_hMenu.AddItem(sModule, sModule);
}

void ResortClassesArray()
{
	if(g_hGames.Length < 2)	return;
	
	char sBuffer[MAX_GAME_NAME_LENGTH];
	int i, x, iSize = g_hSorting.Length, iIndex;

	for (i = 0; i < iSize; i++)
	{
		g_hSorting.GetString(i, sBuffer, MAX_GAME_NAME_LENGTH);
		iIndex = g_hGames.FindString(sBuffer);
		if (iIndex != -1)
		{
			if (iIndex != x)
			{
				g_hGames.SwapAt(iIndex, x);
			}
			
			x++;
		}
	}
}

Function GetFunction(DataPack hPack, int iPosition)
{
	hPack.Position += view_as<DataPackPos>(iPosition);
	return	hPack.ReadFunction();
}