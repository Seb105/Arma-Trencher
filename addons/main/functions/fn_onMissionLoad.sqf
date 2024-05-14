#include "script_component.hpp"
[{
    private _allTrenchPieces = (all3DENEntities#0) select {typeOf _x == QGVAR(Module_TrenchPiece)};
    _allTrenchPieces apply {
        _x call FUNC(registerEntity);
    };
    private _allTrenchNetworks = call FUNC(allTrenchNetworks);
    {
        private _origin = _x#0;
        [_origin] call FUNC(buildTrenchSystem);
    } forEach _allTrenchNetworks;
}] call CBA_fnc_execNextFrame;
