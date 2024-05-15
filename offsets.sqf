[
    [
        "Land_Bunker_01_blocks_3_F",
        [
            [[1.58472,4.27881,0.666987],[[-8.74228e-08,-1,0],[0,0,1]]],
            [[-1.57422,4.27197,0.666987],[[-8.74228e-08,-1,0],[0,0,1]]]
        ]
    ],[
        "Land_TrenchFrame_01_F",
        [
            [[1.87695,4.48779,0.667629],[[0,0.993379,0.114885],[0,-0.114885,0.993379]]],
            [[-2.13794,4.50879,0.648629],[[0.000157269,0.998019,0.0629126],[0.0017975,0.0629122,-0.998017]]]
        ]
    ],[
        "Land_TinWall_01_m_4m_v2_F",
        [
            [[1.93701,4.6001,-0.622549],[[-0.000192014,-0.99494,-0.100466],[0,-0.100466,0.994941]]],
            [[-2.01904,4.41113,0.980452],[[-0.000192014,-0.99494,-0.100466],[0,-0.100466,0.994941]]],
            [[1.93701,4.43896,0.980452],[[-0.000192014,-0.99494,-0.100466],[0,-0.100466,0.994941]]],
            [[-2.01904,4.56787,-0.622549],[[-0.000192014,-0.99494,-0.100466],[0,-0.100466,0.994941]]]
        ]
    ],[
        "Land_Razorwire_F",
        [
            [[0,-0.23584,2.16478],[[0,1,0],[0,0,1]]]
        ]
    ],[
        "Land_BagFence_Long_F",
        [
            [[2.56104,4.05273,2.23402],[[0,1,0],[0,0,1]]],
            [[-0.236084,4.05273,2.23402],[[0,-1,0],[0,0,1]]],
            [[-2.67896,4.05273,2.23402],[[0,1,0],[0,0,1]]]
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
private _sheets = [sheet_1, sheet_2, sheet_3, sheet_4];
private _barbedWire = [barbedwire_1];
private _sandbags = [sandbag_1, sandbag_2, sandbag_3];
private _allOffsets = [
    // _concrete,
    // _frame,
    _sheets,
    _barbedWire,
    _sandbags
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
