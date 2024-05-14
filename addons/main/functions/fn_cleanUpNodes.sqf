// Deletes all trench pieces and restores terrain to original height.
params ["_nodes"];
{
    private _node = _x;        
    {
        deleteVehicle _x;
    } forEach (_node getVariable ["trenchPieces", []]); // TODO: Make macro name
    _node setVariable ["trenchPieces", []];

    private _points = _node getVariable [
        "points",
        []
    ];
    private _originalHeights = _points apply {[_x] call TerrainLib_fnc_unmodifiedTerrainHeight};
    [_originalHeights, true, true] call TerrainLib_fnc_setTerrainHeight;
    _node setVariable ["points", []];


    {
        _x hideObjectGlobal false;
    } forEach (_node getVariable ["hiddenObjects", []]);
    _node setVariable ["hiddenObjects", []];
} forEach _nodes;
