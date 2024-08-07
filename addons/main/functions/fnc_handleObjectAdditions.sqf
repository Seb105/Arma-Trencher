#include "script_component.hpp"
params ["_nodes", "_controller", "_pitch"];
// Default value of combos is always a number, but subsequent values are always strings so handle that
private _combos = [
    _controller getVariable "WallType",
    _controller getVariable "DoSandbags",
    _controller getVariable "TankTrapType",
    _controller getVariable "AiBuildingPosition"
] apply {
    private _val = _x;
    if (_x isEqualType "") then {
        _val = parseNumber _val;
    };
    _val
};
_combos params [
    "_wallType", 
    "_sandBagType", 
    "_tankTrapType", 
    "_aiBuildingPositions"
];
private _extraHorizSegments = _controller getVariable "AdditionalHorizSegments";
private _doBarbedWire = _controller getVariable "DoBarbedWire";

_nodes apply {
    private _node = _x;
    private _simulatedObjects = _node getVariable QGVAR(simulatedObjects);
    private _simpleObjects = _node getVariable QGVAR(simpleObjects);
    private _trenchPieces = _node getVariable QGVAR(trenchPieces);
    private _edenObjects = _node getVariable QGVAR(edenObjects);

    private _skippers = (_node getVariable QGVAR(skippers));

    private _fnc_shouldPlace = {
        params ["_pos", "_skippers", "_skipVar"];
        private _relSkippers = _skippers select {
            _x getVariable _skipVar
        } apply {
            _x getVariable QGVAR(area)
        };
        _relSkippers findIf {_pos inArea _x} isEqualTo -1
    };

    (+_trenchPieces) apply {
        private _trenchPiece = _x;
        private _pieceType = typeOf _trenchPiece;
        // Extra trench pieces to add due to height of trench
        private _wallPieces = [_trenchPiece];
        private _topSegmentHeight = (getPosASL _trenchPiece)#2 - 1.85;
        private _behindTrench = _trenchPiece modelToWorld [0,5,0];
        private _pieceDir = getDir _trenchPiece;
        // Only offset backwards to object, ignore lateral movement
        private _bottomHeight = getTerrainHeightASL _behindTrench;
        private _height = _topSegmentHeight - _bottomHeight;
        private _piecePos = getPosWorld _trenchPiece;
        private _numExtraVertical = (ceil (_height / SEGMENT_HEIGHT)) max 0;
        for "_i" from 1 to _numExtraVertical do {
            private _relativeStep = [[0,0.11], -_pieceDir] call BIS_fnc_rotateVector2D;
            _relativeStep set [2, -SEGMENT_HEIGHT];
            private _dirAndUp = [vectorDir _trenchPiece, vectorUp _trenchPiece];
            // Only care about Z
            private _pos = (_relativeStep vectorMultiply _i) vectorAdd _piecePos;
            // Use simple backwards offset. This means that the piece will be directly below and behind the previous piece to match its angle];
            private _extraVertical = createSimpleObject [_pieceType, [0,0,0]];
            _extraVertical setPosWorld _pos;
            _extraVertical setVectorDirAndUp _dirAndUp;
            _extraVertical enableSimulationGlobal false;
            _extraVertical setObjectTextureGlobal [0, (surfaceTexture _pos)];
            _extraVertical setObjectMaterialGlobal [0, SEGMENT_MATERIAL];
            _extraVertical hideSelection ["snow", true];
            _wallPieces pushBack _extraVertical;
            _trenchPieces pushBack _extraVertical;
        };
        if (_wallType isNotEqualTo -1) then {
            private _types = [
                // Concrete
                [
                    [
                        "Land_Mil_WallBig_4m_F",
                        [2.085,4.25,-0.402],
                        [[0,-0.999,-0.044],[0,-0.044,0.999]]
                    ],
                    [
                        "Land_Mil_WallBig_4m_battered_F",
                        [-1.853,4.25,-0.402],
                        [[0,-0.999,-0.044],[0,-0.044,0.999]]
                    ],
                    [
                        "Land_Mil_WallBig_Corner_F",
                        [-0.043,4.454,-0.402],
                        [[-0.707,0.703,0.077],[0,-0.109,0.994]]
                    ]
                ],
                // Frame
                [
                    [
                        "Land_TrenchFrame_01_F",
                        [1.877,4.488,0.668],
                        [[0,0.993,0.115],[0,-0.115,0.993]]
                    ],
                    [
                        "Land_TrenchFrame_01_F",
                        [-2.425,4.492,0.649],
                        [[0,0.998,0.063],[0.002,0.063,-0.998]]
                    ],
                    [
                        "Land_TrenchFrame_01_F",
                        [1.888,4.727,-1.318],
                        [[0,0.998,0.063],[0.002,0.063,-0.998]]
                    ],
                    [
                        "Land_TrenchFrame_01_F",
                        [-2.213,4.72,-1.374],
                        [[0,0.993,0.115],[0,-0.115,0.993]]
                    ]
                ],
                // Tin
                [
                    [
                        "Land_TinWall_01_m_4m_v2_F",
                        [1.937,4.6,-0.317],
                        [[0,-0.995,-0.1],[0,-0.1,0.995]]
                    ],
                    [
                        "Land_TinWall_01_m_4m_v2_F",
                        [-2.197,4.411,0.98],
                        [[0,-0.995,-0.1],[0,-0.1,0.995]]
                    ],
                    [
                        "Land_TinWall_01_m_4m_v2_F",
                        [1.937,4.439,0.98],
                        [[0,-0.995,-0.1],[0,-0.1,0.995]]
                    ],
                    [
                        "Land_TinWall_01_m_4m_v2_F",
                        [-2.197,4.568,-0.317],
                        [[0,-0.995,-0.1],[0,-0.1,0.995]]
                    ],
                    [
                        "Land_TinWall_01_m_4m_v2_F",
                        [-2.197,4.69,-1.624],
                        [[0,-0.995,-0.1],[0,-0.1,0.995]]
                    ],
                    [
                        "Land_TinWall_01_m_4m_v2_F",
                        [1.937,4.72,-1.624],
                        [[0,-0.995,-0.1],[0,-0.1,0.995]]
                    ]
                ],
                // Hescos
                [
                    [
                        "Land_HBarrier_Big_F",
                        [-0.185,3.83,-1.499],
                        [[0,0.994,0.113],[0,-0.113,0.994]]
                    ],
                    [
                        "Land_HBarrier_Big_F",
                        [-0.185,3.579,0.823],
                        [[0,-0.994,-0.113],[0,-0.113,0.994]]
                    ]
                ],
                // Hesco (ramp)
                [
                    [
                        "Land_HBarrierWall6_F",
                        [0,5.497,0.287],
                        [[0,-0.99863,-0.052336],[0,-0.052336,0.99863]]
                    ]
                ]
            ];
            private _wallObjs = _types#_wallType;
            _wallObjs apply {
                _x params ["_type", "_relativePos", "_relativeDirAndUp"];
                _wallPieces apply {
                    private _wall = _x;
                    private _posASL = _wall modelToWorldWorld _relativePos;
                    if !([_posASL, _skippers, QGVAR(wallSkip)] call _fnc_shouldPlace) then {continue};
                    private _vectorDirAndUp = _relativeDirAndUp apply {_wall vectorModelToWorld _x};
                    private _wallPiece = createSimpleObject [_type, _posASL];
                    _wallPiece setPosWorld _posASL;
                    _wallPiece setVectorDirAndUp _vectorDirAndUp;
                    _wallPiece enableSimulationGlobal false;
                    _simpleObjects pushBack _wallPiece;
                };
            };
        };

        if (_doBarbedWire) then {
            private _relativePos = [0,1.113,2.348];
            private _relativeDirAndUp = [[0,0.994,0.108],[0,-0.108,0.994]];
            private _posASL = _trenchPiece modelToWorldWorld _relativePos;
            if !([_posASL, _skippers, QGVAR(barbedWireSkip)] call _fnc_shouldPlace) exitWith {};
            private _vectorDirAndUp = _relativeDirAndUp apply {_trenchPiece vectorModelToWorld _x};
            // This object should be simulated so it can be destroyed.
            // Don't need to simulate it in eden but add to different array
            private _barbedWire = createSimpleObject ["Land_Razorwire_F", _posASL];   
            _barbedWire setPosWorld _posASL;
            _barbedWire setVectorDirAndUp _vectorDirAndUp;
            _barbedWire enableDynamicSimulation true;
            _simulatedObjects pushBack _barbedWire;
        };

        if (_sandBagType isNotEqualTo -1) then {
            private _sandbagClass = ["Land_BagFence_Long_F", "Land_BagFence_01_long_green_F"]#_sandBagType;
            [
                [
                    "Land_BagFence_Long_F",
                    [2.37,4.066,2.32],
                    [[0,0.999,0.052],[0.06,-0.052,0.997]]
                ],
                [
                    "Land_BagFence_Long_F",
                    [-0.474,4.061,2.419],
                    [[0,-0.999,-0.046],[0.005,-0.046,0.999]]
                ],
                [
                    "Land_BagFence_Long_F",
                    [-2.917,4.069,2.272],
                    [[0,0.999,0.052],[-0.148,-0.052,0.988]]
                ]
            ] apply {
                _x params ["_", "_relativePos", "_relativeDirAndUp"];
                private _posASL = _trenchPiece modelToWorldWorld _relativePos;
                if !([_posASL, _skippers, QGVAR(sandbagSkip)] call _fnc_shouldPlace) then {continue};
                private _vectorDirAndUp = _relativeDirAndUp apply {_trenchPiece vectorModelToWorld _x};
                // private _vectorDirAndUp = [_trenchPiece vectorModelToWorld _relativeDirAndUp#0, [0,0,1]];
                private _sandbag = createSimpleObject [_sandbagClass, _posASL];
                _sandbag setPosWorld _posASL;
                _sandbag setVectorDirAndUp _vectorDirAndUp;
                _sandbag enableSimulationGlobal false;
                _simpleObjects pushBack _sandbag;
            };
        };

        if (_tankTrapType isNotEqualTo -1) then {
            private _types = [
                [
                    [
                        "Land_CzechHedgehog_01_old_F",
                        [-2.759,-0.749,2.265],
                        [[0,1,0],[0,0,1]]
                    ],
                    [
                        "Land_CzechHedgehog_01_old_F",
                        [1.14,-0.785,2.133],
                        [[0,1,0],[0.11,0,0.994]]
                    ],
                    [
                        "Land_CzechHedgehog_01_old_F",
                        [-1.08,-2.739,1.948],
                        [[0,0.986,0.167],[-0.017,-0.166,0.986]]
                    ],
                    [
                        "Land_CzechHedgehog_01_old_F",
                        [2.812,-2.961,1.98],
                        [[0,1,0],[0,0,1]]
                    ]
                ],
                [
                    [
                        "Land_DragonsTeeth_01_1x1_old_F",
                        [-2.089,-0.825,2.164],
                        [[0.999,-0.048,0],[0,0,1]]
                    ],
                    [
                        "Land_DragonsTeeth_01_1x1_old_F",
                        [0.499,-0.877,2.18],
                        [[0.994,-0.048,-0.101],[0.097,-0.078,0.992]]
                    ],
                    [
                        "Land_DragonsTeeth_01_1x1_old_F",
                        [3.197,-0.791,2.099],
                        [[0.999,-0.048,0],[0,0,1]]
                    ],
                    [
                        "Land_DragonsTeeth_01_1x1_old_F",
                        [-3.516,-2.84,1.947],
                        [[-0.492,-0.848,-0.197],[-0.107,-0.166,0.98]]
                    ],
                    [
                        "Land_DragonsTeeth_01_1x1_old_F",
                        [-0.812,-3.001,1.824],
                        [[0.998,-0.049,-0.041],[0.041,-0.005,0.999]]
                    ],
                    [
                        "Land_DragonsTeeth_01_1x1_old_F",
                        [1.863,-3.041,1.948],
                        [[0.999,-0.048,0],[0,0,1]]
                    ]
                ]
            ];
            private _tankTraps = _types#_tankTrapType;
            _tankTraps apply {
                _x params ["_type", "_relativePos", "_relativeDirAndUp"];
                private _posASL = _trenchPiece modelToWorldWorld _relativePos;
                if !([_posASL, _skippers, QGVAR(tankTrapSkip)] call _fnc_shouldPlace) then {continue};
                private _vectorDirAndUp = _relativeDirAndUp apply {_trenchPiece vectorModelToWorld _x};
                private _concPiece = createSimpleObject [_type, _posASL];
                _concPiece setPosWorld _posASL;
                _concPiece setVectorDirAndUp _vectorDirAndUp;
                _concPiece enableSimulationGlobal false;
                _simpleObjects pushBack _concPiece;
            };
        };

        if (_extraHorizSegments > 0) then {
            for "_i" from 1 to _extraHorizSegments do {
                private _relativePosCentre = [0,-SEGMENT_WIDTH,-0.671] vectorMultiply _i;
                private _relativeEdge = [0,-SEGMENT_WIDTH,0] vectorMultiply (_i+0.5);
                private _dirAndUp = [[0,1,0],[0,0,1]] apply {
                    _trenchPiece vectorModelToWorld _x
                };
                private _posASL = _trenchPiece modelToWorldWorld _relativePosCentre;
                private _edgePos = _trenchPiece modelToWorldWorld _relativeEdge;
                private _edgeATL = (ASLtoATL _edgePos)#2;
                if (_edgeATL > SEGMENT_SLOPE_BOTTOM) then {
                    break;
                };
                if !([_posASL, _skippers, QGVAR(additonalHorizSkip)] call _fnc_shouldPlace) then {continue};
                private _extraHorizontal = createSimpleObject [_pieceType, [0,0,0]];
                _extraHorizontal setPosWorld _posASL;
                _extraHorizontal setVectorDirAndUp _dirAndUp;
                _extraHorizontal enableSimulationGlobal false;
                _extraHorizontal setObjectTextureGlobal [0, (surfaceTexture _posASL)];
                _extraHorizontal setObjectMaterialGlobal [0, SEGMENT_MATERIAL];
                _extraHorizontal hideSelection ["snow", true];
                // _wallPieces pushBack _extraHorizontal;
                _trenchPieces pushBack _extraHorizontal;
            };
        };

        if (_aiBuildingPositions isNotEqualTo -1) then {
            private _pos = [getPos _trenchPiece, _pieceDir, 2.2] call FUNC(offset);
            _pos set [2, getTerrainHeightASL _pos];
            private _garrison = createVehicle ["CBA_BuildingPos", _pos];
            _garrison setPosASL _pos;
            _simulatedObjects pushBack _garrison;
            if (_aiBuildingPositions isEqualTo 1) then {
                private _dummy = createSimpleObject ["Sign_Sphere100cm_F", _pos];
                _dummy setPosASL _pos;
                _edenObjects pushBack _dummy;
            };
        };
    };
};
