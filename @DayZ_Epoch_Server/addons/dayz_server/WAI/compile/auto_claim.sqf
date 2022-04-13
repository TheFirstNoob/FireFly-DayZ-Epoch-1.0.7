			if (!_claimed) then {
				// Find the closest player and send an alert
				if (isNull _closestPlayer) then {
					if (!isNull _claimPlayer && {alive _claimPlayer} && {_claimPlayer distance _position <= WAI_AcAlertDistance}) then {
						_closestPlayer = _claimPlayer;
						_claimPlayer = objNull;
					} else {
						_closestPlayer = [_position, WAI_AcAlertDistance] call isClosestPlayer; // Find the closest player
					};
					if (!isNull _closestPlayer) then {
						[_closestPlayer,_name,"Start"] call WAI_AutoClaimAlert; // Send alert
						_claimTime = diag_tickTime; // Set the time variable for countdown
					};
				};
				
				// After the delay time, check player's location and either claim or not claim
				if ((diag_tickTime - _claimTime) > WAI_AcDelayTime) then {
					if ((_closestPlayer distance _position) > WAI_AcAlertDistance || {!alive _closestPlayer}) then {
						[_closestPlayer,_name,"Stop"] call WAI_AutoClaimAlert; // Send alert to player who is closest
						_closestPlayer = objNull; // Set to default
						_acArray = []; // Set to default
					} else {
						_claimed = true;
						[_closestPlayer,_name,"Claimed"] call WAI_AutoClaimAlert; // Send alert to all players
						diag_log text format ["WAI Auto Claim: mission %1 has been claimed by %2",_name,(name _closestPlayer)];
						_acArray = [getplayerUID _closestPlayer, name _closestPlayer]; // Add player UID and name to array
						_markers set [3, [[(_position select 0) + 100, (_position select 1) + 100],_autoMarkDot,"ColorBlack","mil_objective","","",[],["STR_CL_CLAIM_MARKER",(name _closestPlayer)],0]];
						DZE_ServerMarkerArray set [_markerIndex, _markers];
						PVDZ_ServerMarkerSend = ["createSingle",(_markers select 3)];
						publicVariable "PVDZ_ServerMarkerSend";
					};
				};
			};
			
			if (_claimed) then {
				
				// Used in the marker when a player has left the mission area
				_leftTime = round (WAI_AcTimeout - (diag_tickTime - _claimTime));
				
				// This marker should run continuously until the mission is unclaimed or the player returns.
				if (_left) then {
					_autoText = ["STR_CL_TIMEOUT_MARKER",(_acArray select 1),_leftTime];
					(_markers select 3) set [7, _autoText];
					DZE_ServerMarkerArray set [_markerIndex, _markers];
					PVDZ_ServerMarkerSend = ["textSingle",[_autoMarkDot,_autoText]];
					publicVariable "PVDZ_ServerMarkerSend";
				};
				
				// If the player dies at the mission, change marker to countdown and set player variable to null
				if ((!alive _closestPlayer) && !_left) then {
					_closestPlayer = objNull; // Set the variable to null to prevent null player errors
					_claimTime = diag_tickTime; // Set the time for countdown
					_left = true; // Changes the marker to countdown
				};
				
				// Check to see if the dead player has returned to the mission
				if (isNull _closestPlayer) then {
					_closestPlayer = [_position,_acArray] call isReturningPlayer;
				};
				
				// Notify the player that he/she is outside the mission area
				if (!(isNull _closestPlayer) && ((_closestPlayer distance _position) > WAI_AcAlertDistance) && !_left) then {
					[_closestPlayer,_name,"Return"] call WAI_AutoClaimAlert;
					_claimTime = diag_tickTime; // Set the time for the countdown
					_left = true; // Set the mission marker to countdown
				};
				
				// If the player returns to the mission before the clock runs out then change the marker
				if (!(isNull _closestPlayer) && ((_closestPlayer distance _position) < WAI_AcAlertDistance) && _left) then {
					[_closestPlayer,_name,"Reclaim"] call WAI_AutoClaimAlert;
					_left = false; // Change the mission marker back to claim
					_autoText = ["STR_CL_CLAIM_MARKER",(name _closestPlayer)];
					(_markers select 3) set [7, _autoText];
					DZE_ServerMarkerArray set [_markerIndex, _markers];
					PVDZ_ServerMarkerSend = ["textSingle",[_autoMarkDot,_autoText]];
					publicVariable "PVDZ_ServerMarkerSend";
				};
				
				// Warn other players in mission area
				{
					local _inside = _x distance _position < WAI_AcAlertDistance;
					local _inArray = _x in _warnArray;
					if (!(_x in (units group _closestPlayer)) && _inside && !_inArray) then {
						RemoteMessage = ["rollingMessages", ["STR_CL_CLAIM_WARNING",_acArray select 1]];
						(owner _x) publicVariableClient "RemoteMessage";
						_warnArray set [count _warnArray, _x]; // add player to temp array so it does not spam the message.
					};
					
					if (!_inside && _inArray) then {
						_warnArray = _warnArray - [_x]; // Remove player from the array so the message can repeat if player reenters the mission area.
					};
				} count playableUnits;
				
				// If the player lets the clock run out, then set the mission to unclaimed and set the variables to default
				// Player left the server
				if ((isNull _closestPlayer) && ((diag_tickTime - _claimTime) > WAI_AcTimeout)) then {
					[_acArray ,_name,"Unclaim"] call WAI_AutoClaimAlert; // Send alert to all players
					_claimed = false;
					_left = false;
					_acArray = [];
					_warnArray = [];
					PVDZ_ServerMarkerSend = ["removeSingle",_autoMarkDot];
					publicVariable "PVDZ_ServerMarkerSend";
					_markers set [3, 1];
					DZE_ServerMarkerArray set [_markerIndex, _markers];
				} else {
					// Player is alive but did not return to the mission
					if (((diag_tickTime - _claimTime) > WAI_AcTimeout) && ((_closestPlayer distance _position) > WAI_AcAlertDistance)) then {
						[_closestPlayer,_name,"Unclaim"] call WAI_AutoClaimAlert; // Send alert to all players
						_closestPlayer = objNull;
						_claimed = false;
						_left = false;
						_acArray = [];
						_warnArray = [];
						PVDZ_ServerMarkerSend = ["removeSingle",_autoMarkDot];
						publicVariable "PVDZ_ServerMarkerSend";
						_markers set [3, 1];
						DZE_ServerMarkerArray set [_markerIndex, _markers];
						
					};
				};
			};
