#include "script_component.hpp"
private _allTrenchPieces = (all3DENEntities#0) select {typeOf _x == QGVAR(Module_TrenchPiece)};
_allTrenchPieces apply {
    _x call FUNC(registerEntity);
}
