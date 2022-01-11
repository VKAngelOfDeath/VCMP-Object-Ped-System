class Waypoint
{
	Index = null;
	NextNodes = null;
	SameNode = null; // Another node on the exact same position belonging to another group
	X = null;
	Y = null;
	Z = null;
	Amount = null; // Amount for NPC
	Speed = null;
	Angle = null; // Angle for NPC
	Distr = null;
	WayPointObj = null; // Object used for debugging and seeing the waypoints
	

	constructor(Index, NextNodes, SameNode, X, Y, Z, Speed, Angle, Amount)
	{
		this.Index = Index;
		this.NextNodes = NextNodes;
		this.SameNode = SameNode;
		this.X = X;
		this.Y = Y;
		this.Z = Z; 
		this.Speed = Speed;
		this.Angle = Angle;
		this.Amount = Amount;

		for (local i = 0; i < this.Speed.len(); i++) this.Speed[i] = (this.Speed[i]/::PedSpeed).tointeger(); // Adjusting the speed. 

		// DEBUG VALUES
		this.Distr = ::GetDistrictName(X, Y);
		this.WayPointObj = null;
		
	}
	
	function FindNextNode(PrevWaypoint) // Finds the next waypoint index. Either random or switch direction if dead end. 
	{
		local IterationCount = 0;
		local NextNode, RandValue;

		if (NextNodes.len() == 1 && PrevWaypoint == NextNodes[0]) return 0; // Dead end. Walk back to the previous one.
		
		while (IterationCount < 100) // Selects a random waypoint that isn't the previous one
		{
			RandValue = Random2(1, NextNodes.len())-1;
			
			if (NextNodes[RandValue] != PrevWaypoint) return RandValue;
			IterationCount++;
		}		
	}


	function GetNextNode(NodeIndex) 
	{
		return NextNodes[NodeIndex];
	}

	function GetAngle(NodeIndex)
	{
		return Angle[NodeIndex];
	}

	function GetSpeed(NodeIndex)
	{
		return Speed[NodeIndex]; 
	}

	function GetPos()
	{
		return Vector(X, Y, Z);
	}

	function GetAmount(NodeIndex)
	{
		return this.Amount[NodeIndex];
	}

	function ChangePedAmount(Amount, NodeIndex) // Changes the ped amount based NodeIndex after FindNextWaypoint
	{
		local NewAmount = this.Amount[NodeIndex] + Amount;
		if (NewAmount > 0) this.Amount[NodeIndex] = NewAmount;
		else this.Amount[NodeIndex] = 0;
		return this.Amount[NodeIndex];
	}

	//--------------------------------------------------------
	// DEBUG FUNCTIONS - ONLY FOR TESTING
	//--------------------------------------------------------

	function onObjectBump(player)
	{
		DebugObjectPrint(player);
	}

	function onObjectShot(player, weapon)
	{
		DebugObjectPrint(player);
	}

	function InsideArea(Entity, XOffset, YOffset) // Checks if Entity is within the offset 
	{
		if ( (X-XOffset) <= Entity.Pos.x && (X+XOffset) >= Entity.Pos.x && (Y-YOffset) <= Entity.Pos.y && (Y+YOffset) >= Entity.Pos.y) return 1;
		return 0;
	}

	function CheckDistrictArea(Entity, Distance, District) // Checks if the entity is in the correct district and area
	{
		if (Distr == District) return InsideArea(Entity, Distance, Distance)
		else return 0;

	}


	function DebugObject(Entity, Distance, District) // Spawns/despawns the objects at the spawn point.
	{
		local SpawnWPObject = CheckDistrictArea(Entity, Distance, District); // Determines if the WP object should be spawned or not. 
		if (WayPointObj == null)
		{
			if (SpawnWPObject) 
			{
				WayPointObj = ::CreateObject(302, 1, Vector(X,Y,Z-1), 255); // obj pos is -1 to make it reach ground.
				WayPointObj.TrackingShots = true; 
				WayPointObj.TrackingBumps = true;
			}
		}
		else
		{
			if (!SpawnWPObject) 
			{
				WayPointObj.Delete();
				WayPointObj = null;
			}
		}

	}

	function DebugObjectPrint(player)
	{
		::ClientMessage("[#33CC33]Information: [#FFFFFF]Index: " + Index + ". Pos: Vector(" + X + ", " + Y + ", " + (Z+1) + ").", player, 0, 0, 0); // +1 in Z to get actual pos. 
	}


}