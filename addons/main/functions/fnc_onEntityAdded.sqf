#include "script_component.hpp"
params ["_obj"];
if !(_obj isEqualType objNull) exitwith {};
if (_obj isKindOf QGVAR(Module_TrenchPiece) || _obj isKindOf QGVAR(Module_TrenchSkipper)) then {
    _obj call FUNC(registerEntity);
};
