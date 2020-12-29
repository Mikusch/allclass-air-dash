/*
 * Copyright (C) 2020  Mikusch
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
#include <tf2_stocks>
#include <dhooks>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "TF2 all-class air dash", 
	author = "Mikusch", 
	description = "Allows all classes to perform an air dash", 
	version = "v1.0", 
	url = "https://github.com/Mikusch/air-dash"
}

DynamicDetour detour;
ConVar tf_all_classes_can_air_dash;

TFClassType oldPlayerClass[MAXPLAYERS + 1];

public void OnPluginStart()
{
	tf_all_classes_can_air_dash = CreateConVar("tf_all_classes_can_air_dash", "1", "When enabled, all classes are allowed to perform an air dash", _, true, 0.0, true, 1.0);
	tf_all_classes_can_air_dash.AddChangeHook(OnConVarChanged);
	
	GameData gamedata = new GameData("air-dash");
	if (gamedata == null)
		SetFailState("Could not find air-dash gamedata");
	
	detour = DynamicDetour.FromConf(gamedata, "CTFPlayer::CanAirDash");
	if (detour)
	{
		detour.Enable(Hook_Pre, DHookCallback_PreCanAirDash);
		detour.Enable(Hook_Post, DHookCallback_PostCanAirDash);
	}
	else
	{
		SetFailState("Failed to create detour setup handle for function CTFPlayer::CanAirDash");
	}
	
	delete gamedata;
}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if (convar.BoolValue)
	{
		detour.Enable(Hook_Pre, DHookCallback_PreCanAirDash);
		detour.Enable(Hook_Post, DHookCallback_PostCanAirDash);
	}
	else
	{
		detour.Disable(Hook_Pre, DHookCallback_PreCanAirDash);
		detour.Disable(Hook_Post, DHookCallback_PostCanAirDash);
	}
}

public MRESReturn DHookCallback_PreCanAirDash(int client)
{
	oldPlayerClass[client] = TF2_GetPlayerClass(client);
	TF2_SetPlayerClass(client, TFClass_Scout);
}

public MRESReturn DHookCallback_PostCanAirDash(int client)
{
	TF2_SetPlayerClass(client, oldPlayerClass[client]);
}
