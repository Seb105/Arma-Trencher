private _prettyFormat = {
    // Modified version of CBA_fnc_prettyFormat
    params [
        ["_array", [], [[]]],
        ["_indent", "    ", [""]],
        ["_lineBreak", endl, [""]],
        ["_depth", 0, [0]]
    ];
    
    private _maxDepth = 2;
    private _indent_arr = [];
    _indent_arr resize [_depth, _indent];
    private _indents = _indent_arr joinString "";
    
    if (_array isEqualTo []) exitWith {
        _indents + "[]" // return
    };
    
    private _lines = _array apply {
        if (_x isEqualType [] && _depth <= _maxDepth) then {
            [_x, _indent, _lineBreak, _depth + 1] call _prettyFormat
        } else {
            _indents + _indent + str _x
        };
    };
    
    _indents + "[" + _lineBreak + (_lines joinString ("," + _lineBreak)) + _lineBreak + _indents + "]" // return
};
private _getOffset = {
    params ["_root", "_obj"];
    private _type = typeOf _obj;
    private _up = _root vectorWorldToModel (vectorUp _obj);
    private _dir = _root vectorWorldToModel (vectorDir _obj);
    private _pos = _root worldToModel (ASLtoAGL getPosWorld _obj);
    _up = _up apply {parseNumber ([_x,1,3] call CBA_fnc_formatNumber)};
    _dir = _dir apply {parseNumber ([_x,1,3] call CBA_fnc_formatNumber)};
    _pos = _pos apply {parseNumber ([_x,1,3] call CBA_fnc_formatNumber)};
    [_type, _pos,[_dir,_up]]
};
private _concrete = [concrete_1, concrete_2, concrete_3];
private _frame = [frame_1, frame_2, frame_3, frame_4];
private _sheets = [sheet_1, sheet_2, sheet_3, sheet_4, sheet_5, sheet_6];
private _barbedWire = [barbedwire_1];
private _sandbags = [sandbag_1, sandbag_2, sandbag_3];
private _lower = [lower_segment];
private _offset = [offset_segment];
private _hescos = [hesco_1, hesco_2];
private _hesco_ramp = [hesco_ramp];
private _dragonsTeeth = [dragonsteeth_1, dragonsteeth_2, dragonsteeth_3, dragonsteeth_4, dragonsteeth_5, dragonsteeth_6];
private _hedgeHogs = [hedgehog_1, hedgehog_2, hedgehog_3, hedgehog_4];
private _allOffsets = [
    ["WALLS: CONC", _concrete],
    ["WALLS: FRAME", _frame],
    ["WALLS: METAL", _sheets],
    ["WALLS: HESCOS", _hescos],
    ["WALLS: HESCOS RAMP", _hesco_ramp],
    ["BARBED WIRE", _barbedWire],
    ["SANDBAGS", _sandbags],
    ["LOWER SEGMENT", _lower],
    ["UPPER SEGMENT", _offset],
    ["DRAGONS TEETH", _dragonsTeeth],
    ["HEDGEHOGS", _hedgeHogs]
] apply {
    _x params ["_name", "_arr"];
    private _relative = _arr apply {[trench_1,_x] call _getOffset};
    [_name, _relative]
};
copyToClipboard ([_allOffsets] call _prettyFormat);
private _testObjs = missionNamespace getVariable ["testobjs",[]];
_testObjs apply {deleteVehicle _x};
_testObjs = [];
{
    private _trench = _x;
    {
        _x params ["_name", "_offsets"];
        {
            _x params ["_type", "_relPos", "_relVectorDirAndUp"];
            private _posASL = (_trench modelToWorldWorld _relPos);
            private _vectorDirAndUp = _relVectorDirAndUp apply {_trench vectorModelToWorld _x};
            private _veh = createSimpleObject [_type, _posASL];
            _veh setPosWorld _posASL;
            _veh setVectorDirAndUp _vectorDirAndUp;
            _testObjs pushBack _veh; 
        } forEach _offsets;
    } forEach _allOffsets;
} forEach [trench_2, trench_3, trench_4];
