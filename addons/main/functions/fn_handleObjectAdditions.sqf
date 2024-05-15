params ["_trenchPiece", "_trenchPieces", "_extraComponents"];
_extraComponents params ["_wallType", "_doSandbags", "_doBarbedWire"];
if (_wallType isNotEqualTo -1) then {
    private _types = [
        [
            "Land_Bunker_01_blocks_3_F",
            [
                [[1.58472,4.27881,0.666987],[[0,-1,0],[0,0,1]]],
                [[-1.57422,4.27197,0.666987],[[0,-1,0],[0,0,1]]]
            ]
        ],
        [
            "Land_TrenchFrame_01_F",
            [
                [[1.87695,4.48779,0.667629],[[0,0.993379,0.114885],[0,-0.114885,0.993379]]],
                [[-2.13794,4.50879,0.648629],[[0.000157269,0.998019,0.0629126],[0.0017975,0.0629122,-0.998017]]]
            ]
        ],
        [
            "Land_TinWall_01_m_4m_v2_F",
            [
                [[1.93701,4.6001,-0.622549],[[-0.000192014,-0.99494,-0.100466],[0,-0.100466,0.994941]]],
                [[-2.01904,4.41113,0.980452],[[-0.000192014,-0.99494,-0.100466],[0,-0.100466,0.994941]]],
                [[1.93701,4.43896,0.980452],[[-0.000192014,-0.99494,-0.100466],[0,-0.100466,0.994941]]],
                [[-2.01904,4.56787,-0.622549],[[-0.000192014,-0.99494,-0.100466],[0,-0.100466,0.994941]]]
            ]
        ]
    ];
    (_types#_wallType) params ["_type", "_positions"];
    _positions apply {
        _x params ["_relativePos", "_relativeDirAndUp"];
        private _posASL = _trenchPiece modelToWorldWorld _relativePos;
        private _vectorDirAndUp = _relativeDirAndUp apply {_trenchPiece vectorModelToWorld _x};
        private _concPiece = createSimpleObject [_type, _posASL];
        _concPiece setPosWorld _posASL;
        _concPiece setVectorDirAndUp _vectorDirAndUp;
        _concPiece enableSimulationGlobal false;
        _trenchPieces pushBack _concPiece;
    };
};
if (_doBarbedWire) then {
    private _relativePos = [0,-0.23584,2.16478];
    private _relativeDirAndUp = [[0,1,0],[0,0,1]];
    private _posASL = _trenchPiece modelToWorldWorld _relativePos;
    private _vectorDirAndUp = _relativeDirAndUp apply {_trenchPiece vectorModelToWorld _x};
    // This object should be simulated so it can be destroyed
    private _barbedWire = createVehicle ["Land_Razorwire_F", _posASL];   
    _barbedWire setPosWorld _posASL;
    _barbedWire setVectorDirAndUp _vectorDirAndUp;
    _barbedWire enableDynamicSimulation true;
    _trenchPieces pushBack _barbedWire;
};
if (_doSandbags) then {
    {
        _x params ["_relativePos", "_relativeDirAndUp"];
        private _posASL = _trenchPiece modelToWorldWorld _relativePos;
        private _vectorDirAndUp = _relativeDirAndUp apply {_trenchPiece vectorModelToWorld _x};
        private _sandbag = createSimpleObject ["Land_BagFence_Long_F", _posASL];
        _sandbag setPosWorld _posASL;
        _sandbag setVectorDirAndUp _vectorDirAndUp;
        _sandbag enableSimulationGlobal false;
        _trenchPieces pushBack _sandbag;
    } forEach [
        [[2.56104,4.05273,2.23402],[[0,1,0],[0,0,1]]],
        [[-0.236084,4.05273,2.23402],[[0,-1,0],[0,0,1]]],
        [[-2.67896,4.05273,2.23402],[[0,1,0],[0,0,1]]]
    ]
}
