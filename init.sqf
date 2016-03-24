execVM "R3F_LOG\init.sqf";

_init = '
        if ( !isDedicated ) then {
                a3g_serverbriefing = this;
                [] spawn {     
                        KK_fnc_collectMrkInfo = { [
                                _x,
                                markerText _x,
                                markerPos _x,
                                mapGridPosition markerPos _x,          
                                markerDir _x,
                                markerSize _x,
                                markerType _x,
                                markerShape _x,
                                markerBrush _x,
                                markerColor _x,
                                markerAlpha _x
                        ] };
                        KK_fnc_setMrkEHs = {
                                scopeName "func";
                                waitUntil {
                                        if ( _this == 53 && getClientState == "GAME LOADED" ) then {
                                                breakOut "func";
                                        };
                                        !isNull findDisplay _this
                                };
                                findDisplay _this displayAddEventHandler [ "KeyDown", {
                                        if ( _this select 1 == 211 ) then {
                                                _mrknames = allMapMarkers;
                                                _mrkdetails = [];
                                                {
                                                        _mrkdetails pushBack ( _x call KK_fnc_collectMrkInfo );
                                                } forEach _mrknames;
                                                0 = [ _mrknames, _mrkdetails ] spawn {
                                                        _mrknames = _this select 0;
                                                        _mrkdetails = _this select 1;
                                                        MrkOpPV = [
                                                                "deleted marker",
                                                                name player,
                                                                getplayerUID player
                                                        ];
                                                        {
                                                                _i = _mrknames find _x;
                                                                if ( _i > -1 ) then {
                                                                        MrkOpPV pushBack ( _mrkdetails select _i );
                                                                };
                                                        } forEach ( _mrknames - allMapMarkers );
                                                        if ( count MrkOpPV > 3 ) then {
                                                                publicVariableServer "MrkOpPV";
                                                        };
                                                };
                                                false
                                        };
                                } ];
                                findDisplay _this displayAddEventHandler [ "ChildDestroyed", {
                                        if ( ctrlIdd ( _this select 1 ) == 54 && _this select 2 == 1 ) then {
                                                0 = all_mrkrs spawn {
                                                        MrkOpPV = [
                                                                "placed marker",
                                                                name player,
                                                                getplayerUID player
                                                        ];
                                                        {
                                                                MrkOpPV pushBack ( _x call KK_fnc_collectMrkInfo );      
                                                        } forEach ( allMapMarkers - _this );
                                                        if ( count MrkOpPV > 3 ) then {
                                                                publicVariableServer "MrkOpPV";
                                                        };  
                                                };
                                        };
                                } ];
                                findDisplay _this displayCtrl 51 ctrlAddEventHandler [ "MouseButtonDblClick", {
                                        0 = 0 spawn {
                                                if ( !isNull findDisplay 54 ) then {
                                                        findDisplay 54 displayCtrl 1
                                                        buttonSetAction "all_mrkrs = allMapMarkers";
                                                };
                                        };
                                } ];
                        };
                        0 = 12 spawn KK_fnc_setMrkEHs;
                        0 = 53 spawn KK_fnc_setMrkEHs;
                        "a3g_happening" addPublicVariableEventHandler {
                                _player = a3g_happening select 1;
                                _did = a3g_happening select 0;
                                _name = a3g_happening select 3 select 1;
                                _mission_started = time > 1;
                                if ( !_mission_started ) then {
                                        player globalChat format [ "%1 %2 %3", _player, _did, _name ];
                                };
                        };
                };
        };
';