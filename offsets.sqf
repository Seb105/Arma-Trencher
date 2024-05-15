[
    [
        "Land_Bunker_01_blocks_3_F",
        [
            [[1.58472,4.27881,0.666987],[[-8.74228e-08,-1,0],[0,0,1]]],
            [[-1.57422,4.27197,0.666987],[[-8.74228e-08,-1,0],[0,0,1]]]
        ]
    ],[
        "Land_Razorwire_F",[
            [[0,-0.23584,2.16478],[[0,1,0],[0,0,1]]]
        ]
    ],[
        "Land_BagFence_Long_F",
        [
            [[2.56104,4.17676,2.23402],[[0,1,0],[0,0,1]]],
            [[-0.236084,4.17676,2.23402],[[0,-1,0],[0,0,1]]],
            [[-2.67896,4.17676,2.23402],[[0,1,0],[0,0,1]]]
        ]
    ]
]



_getOffset = {
    params ["_root", "_obj"];
    private _up = _root vectorWorldToModel (vectorUp _obj);
    private _dir = _root vectorWorldToModel (vectorDir _obj);
    private _pos = _root worldToModel (ASLtoAGL getPosWorld _obj);
    [_pos,[_dir,_up]]
};
private _concrete = [concrete_1, concrete_2];
private _frame = [frame_1, frame_2];
private _barbedWire = [barbedwire_1];
private _sandbags = [sandbag_1, sandbag_2, sandbag_3];
private _allOffsets = [
    // _concrete,
    _frame,
    _barbedWire,
    _sandbags,
] apply {
private _arr = _x;
private _relative = _arr apply {[trench_1,_x] call _getOffset};
private _type = typeOf (_x#0);
[_type,_relative];
};
copyToClipboard str _allOffsets;
private _testObjs = missionNamespace getVariable ["testobjs",[]];
_testObjs apply {deleteVehicle _x};
_testObjs = [];
{
    _x params ["_type", "_offsets"];
    {
        _x params ["_relPos", "_relVectorDirAndUp"];
        private _posASL = (trench_2 modelToWorldWorld _relPos);
        private _vectorDirAndUp = _relVectorDirAndUp apply {trench_2 vectorModelToWorld _x};
        private _veh = createSimpleObject [_type, _posASL];
        _veh setPosWorld _posASL;
        _veh setVectorDirAndUp _vectorDirAndUp;
        _testObjs pushBack _veh; 
    } forEach _offsets;
} forEach _allOffsets;
missionNameSpace setVariable ["testobjs", _testobjs];
