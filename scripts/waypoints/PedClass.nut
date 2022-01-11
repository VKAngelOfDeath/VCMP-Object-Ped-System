class Ped 
{
	WP = null;            // Waypoint the ped is walking from. 
	NextWP = null;        // Next waypoint.
	NextNodeIndex = null; // Node index the ped is walking from (used for accessing values) 
	SkipWPIndex = null;
	Obj = null;           // Object itself.
	MovingTime = 0;       // Speed and time to reach the checkpoint.
	ObjModel = 0;         // Saved Object model in case we need to re-create the model (NOT NEEDED for now)
	IsDead = 1;           // Status if the ped is alive or not.

	constructor (Index) // Starts the ped from a certain waypoint and immediately makes them walk to the next
	{
		Create();
		Spawn(Index);
	}

	function Create()
	{
		ObjModel = ::CivilianObjectModel(Random(1,17));
		Obj = ::CreateObject(ObjModel, 1, Vector(1,1,1), 255); // CivilianModel(Num)
		Obj.TrackingShots = true;

	}

	function Delete()
	{
		if (Obj != null) Obj.Delete();
		Obj = null;
		WP.ChangePedAmount(-1, NextNodeIndex);
	}

	function Spawn(Index) // Used for respawn and spawn.
	{
		if (IsDead == 1)
		{
			WP = GetWaypoint(Index);
			NextWP = null;
			NextNodeIndex = 0;
			MovingTime = 0;
			IsDead = 0;
			SkipWPIndex = -1;

			Obj.Pos = Vector(WP.X,WP.Y,WP.Z);
			Obj.SetAlpha(255, 0);

			MoveToNextWP();
		}
	}

	function Die()
	{
		if (IsDead == 0)
		{
			Obj.Pos.z -= 0.8;
			Obj.MoveTo(Obj.Pos, 0);
			Obj.RotateToEuler(Vector(0, 1.61, Obj.RotationEuler.z), 500);
			Obj.SetAlpha(90, 0);
			WP.ChangePedAmount(-1, NextNodeIndex); // One less ped walking from the WP to the NextWP. 
			IsDead = 1;
		}
	}
	

	function MoveToNextWP() // Function called for setting the next WP and moving the ped
	{
		SetNextWP(); // Sets the next waypoint after this one. 
		PedMoveTo(); // Makes the ped/object move to the position of the NextWP. 
	}

	function SetNextWP() // Finds and set the next WP
	{
		NextNodeIndex = WP.FindNextNode(SkipWPIndex); // Find next node index for the next waypoint, makes sure it's not the same as previous one
		local NextWPIndex = WP.GetNextNode(NextNodeIndex); // The next waypoint index stored inside nextNode array.

		WP.ChangePedAmount(1, NextNodeIndex); // One more ped walking from the WP to the NextWP. 
		
		NextWP = GetWaypoint(NextWPIndex);
		if (NextWP.SameNode != -1) NextWP = GetWaypoint(NextWP.SameNode); // Two external nodes at the same position skip to the next one.  
		
		
	}

	function PedMoveTo() // Function for actually moving the peds. Splitting for future support.
	{	
		
		local Amount = WP.GetAmount(NextNodeIndex);
		local Pos = NextWP.GetPos(); // We are moving to the position of the next checkpoint
		local Angle = WP.GetAngle(NextNodeIndex); // Using the values of the current checkpoint to move to the next

		Pos = GetRightPos(Pos, Angle, 0.5);

		MovingTime = WP.GetSpeed(NextNodeIndex) + Amount*500; 
		 
		Obj.MoveTo(Pos,MovingTime );
		Obj.RotateToEuler(Vector(0,0,Angle), 0);
		
	}

	function NextWPReached() // Called when the NPC has reached it's next waypoint (Spawning does not count)
	{
		WP.ChangePedAmount(-1, NextNodeIndex); // One less ped walking from the WP to the NextWP. 
		SkipWPIndex = WP.Index; // Makes sure we don't walk back again if there are other options.
		WP = NextWP; // Current waypoint becomes the next one. 
	}

	function Do() // Timer
	{
		if (IsDead == 0)
		{
			MovingTime -= 100;
			if (MovingTime < 100) 
			{
				NextWPReached(); // When PED reaches the NextWP.
				MoveToNextWP();
			}

		}
	}

	function onObjectShot(player, weapon)
	{
		Die();
	}


	function PrintStatus(NextNodeIndex)
	{
		if (PrevWP != null) print("[WAYPOINT] Current Checkpoint: " + WP.Index + " " + WP.GetPos() + ". Prev Checkpoint: " + PrevWP.Index + " " + PrevWP.GetPos()+ ". Distance: " + WP.Dist[NextNodeIndex] + ". Speed: " + MovingTime + ".");
		else print("[WAYPOINT] Current Checkpoint: " + WP.Index + " " + WP.GetPos() + ". Prev Checkpoint: None. Distance: " + WP.Dist[NextNodeIndex] + ". Speed: " + MovingTime + ".");
	}


}




