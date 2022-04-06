//--------------------------------------------------------
// Waypoint Functions
//--------------------------------------------------------

function CreateWaypoint(Index, NextNodes, SameNode, X, Y, Z, Dist, Angle, Amount )
{
	WaypointsList[Index] = Waypoint(Index, NextNodes, SameNode, X, Y, Z, Dist, Angle, Amount);
}

function GetWaypoint(Index)
{
	return WaypointsList[Index];

}

function GetWaypointPos(Index)
{
	return Vector(WaypointsList[Index].X, WaypointsList[Index].Y, WaypointsList[Index].Z);

}



//--------------------------------------------------------
// PED Functions
//--------------------------------------------------------

function CreatePeds(Num)
{
	Peds.append(Ped(Num));

}

function CreatePeds2(HowMany)
{
	for (local i = 1; i <= HowMany; i++) Peds.append(Ped(Random2(1,WaypointsList.len())-1));

}

function DeletePed(Index)
{
	Peds[Index].Delete();
	Peds.remove(Index);
}


function DeleteAllPeds()
{
	foreach (Ped in Peds)
	{
		Ped.Delete();
	}
	Peds.clear();
}


function GetPedPos(Index)
{
	return Peds[Index].Obj.Pos;

}


function CivilianObjectModel(Num)
{ 
	switch (Num)
	{
		case 1: return 6000; 
		case 2: return 6001;
		case 3: return 6002;
		case 4: return 6003; 
		case 5: return 6004;
		case 6: return 6005;
		case 7: return 6006;
		case 8: return 6007;
		case 9: return 6008;
		case 10: return 6009;
		case 11: return 6010;
		case 12: return 6011;
		case 13: return 6012;
		case 14: return 6013;
		case 15: return 6014;
		case 16: return 6015; 
		case 17: return 6016; 
		default: return 6000;
	}
	
}



//--------------------------------------------------------
// Timer Functions
//--------------------------------------------------------

function RunWPTimerRespawn() // 5 second timer. 
{
	foreach (PedInst in Peds) PedInst.Spawn(Random2(1,WaypointsList.len())-1); // Respawns if dead
}

function RunWPTimer() // 0.1 second timer.
{
	if (PlayerDebugView != -1)
	{
		local player = FindPlayer(PlayerDebugView);
		if (player != null)
		{
			local Distr = GetDistrictName(player.Pos.x, player.Pos.y);

			foreach (i, WP in WaypointsList) WP.DebugObject(player, 100, Distr); // Despawns/spawns debugobjects close to the player
		}
	}

	foreach (PedInst in Peds) // just calling do() with empty with 500000 NPCs will increase the performance. 
	{
		
		PedInst.Do();
	}
}
