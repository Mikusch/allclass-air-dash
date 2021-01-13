/*
 * Copyright (C) 2021  Mikusch
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include <sourcemod>
#include <memorypatch>

#pragma semicolon 1
#pragma newdecls required

ConVar tf_all_classes_can_air_dash;
MemoryPatch g_MemoryPatchAllClassesCanAirDash;

public Plugin myinfo = 
{
	name = "TF2 all-class air dash", 
	author = "Mikusch", 
	description = "Allows all classes to perform an air dash", 
	version = "1.1.0", 
	url = "https://github.com/Mikusch/air-dash"
}

public void OnPluginStart()
{
	tf_all_classes_can_air_dash = CreateConVar("tf_all_classes_can_air_dash", "1", "When enabled, all classes are allowed to perform an air dash", _, true, 0.0, true, 1.0);
	tf_all_classes_can_air_dash.AddChangeHook(OnConVarChanged);
	
	GameData gamedata = new GameData("air-dash");
	if (gamedata == null)
		SetFailState("Could not find air-dash gamedata");
	
	MemoryPatch.SetGameData(gamedata);
	CreateMemoryPatch(g_MemoryPatchAllClassesCanAirDash, "MemoryPatch_AllClassesCanAirDash");
	
	delete gamedata;
}

public void OnPluginEnd()
{
	if (g_MemoryPatchAllClassesCanAirDash != null)
		g_MemoryPatchAllClassesCanAirDash.Disable();
}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if (g_MemoryPatchAllClassesCanAirDash != null)
	{
		if (convar.BoolValue)
			g_MemoryPatchAllClassesCanAirDash.Enable();
		else
			g_MemoryPatchAllClassesCanAirDash.Disable();
	}
}

void CreateMemoryPatch(MemoryPatch &handle, const char[] name)
{
	handle = new MemoryPatch(name);
	if (handle != null)
		handle.Enable();
	else
		LogError("Failed to create memory patch %s", name);
}
