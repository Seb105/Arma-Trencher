#include "script_component.hpp"
params ["_module"];

// _module call FUNC(buildTrenchSystem);
if (_module isKindOf QGVAR(Module_TrenchPiece)) then {
    private _ehs = [
        "AttributesChanged3DEN",
        "ConnectionChanged3DEN",
        "RegisteredToWorld3DEN"
    ];
    {
        private _eh = _x;
        _module addEventHandler [_eh, {
            params ["_object"];
            if (time < 1) exitWith {};
            // systemchat str [_object, _thisEvent];
            _object call FUNC(buildTrenchSystem);
            // systemChat str [get3DENEntityID _object, _thisEvent];
            // [_object, diag_frameNo] spawn {
            //     params ["_object", "_frameNo"];
            //     waitUntil {diag_frameNo > _frameNo};
            //     isNil {
            //         _object call FUNC(buildTrenchSystem);
            //     };
            // };
        }];
    } forEach _ehs;
    // Object is deleted AFTER this eh fires.
    _module addEventHandler ["UnregisteredFromWorld3DEN", {
        params ["_object"];
        // Delete anything assosciated with this node.
        [[_object]] call FUNC(cleanUpNodes);
        // Connections are deleted before this EH fires, so get cached.
        private _connections = _object getVariable [QGVAR(connections), []];
        [_connections, diag_frameNo] spawn {
            params ["_connections", "_frameNo"];
            waitUntil {diag_frameNo > _frameNo};
            isNil {
                _connections apply {_x call FUNC(buildTrenchSystem)};
            };
        };

        // Write blank SQM if no nodes are left.
        private _allNodes = all3DENEntities#3 select {_x isKindOf QGVAR(Module_TrenchPiece)};
        if (count _allNodes == 0) then {
            call FUNC(writeToSQM);
        }
    }];
};
if (_module isKindOf QGVAR(Module_TrenchSkipper)) then {
    private _skipper = _module;
    private _size = (_skipper get3DENAttribute "Size3")#0;
    _size params ["_sideX", "_sideY"];
    private _isRectangle = (_skipper get3DENAttribute "isRectangle")#0;
    private _area = [getPos _skipper, _sideX, _sideY, getDir _skipper, _isRectangle, -1];
    private _radius = sqrt(_sideX^2 + _sideY^2);
    _skipper setVariable [QGVAR(radius), sqrt(_sideX^2 + _sideY^2)];
    _skipper setVariable [QGVAR(area), _area];
    private _nodes = all3DENEntities#3 select {
        _x isKindOf QGVAR(Module_TrenchPiece)
    } select {
        private _node = _x;
        private _nodeRadius = _node getVariable [QGVAR(radius), 0];
        private _distance = _node distance2d _skipper;
        _distance < (_nodeRadius + _radius)
    };
    _skipper setVariable [QGVAR(affectedNodes), _nodes];

    private _ehs = [
        "AttributesChanged3DEN",
        "ConnectionChanged3DEN",
        "RegisteredToWorld3DEN"
    ];
    {
        private _eh = _x;
        _module addEventHandler [_eh, {
            params ["_skipper"];
            private _oldNodes = _skipper getVariable [QGVAR(affectedNodes), []];


            private _size = (_skipper get3DENAttribute "Size3")#0;
            _size params ["_sideX", "_sideY"];
            private _isRectangle = (_skipper get3DENAttribute "isRectangle")#0;
            private _area = [getPos _skipper, _sideX, _sideY, getDir _skipper, _isRectangle, -1];
            private _radius = sqrt(_sideX^2 + _sideY^2);
            _skipper setVariable [QGVAR(radius), sqrt(_sideX^2 + _sideY^2)];
            _skipper setVariable [QGVAR(area), _area];

            if (time < 1) exitWith {};
            private _nodes = all3DENEntities#3 select {
                _x isKindOf QGVAR(Module_TrenchPiece)
            } select {
                private _node = _x;
                private _nodeRadius = _node getVariable [QGVAR(radius), 0];
                private _distance = _node distance2d _skipper;
                _distance < (_nodeRadius + _radius)
            };
            _nodes apply {_x call FUNC(buildTrenchSystem)};
            _skipper setVariable [QGVAR(affectedNodes), _nodes];

            _oldNodes = _oldNodes - _nodes;
            [_oldNodes, diag_frameNo] spawn {
                params ["_oldNodes", "_frameNo"];
                waitUntil {diag_frameNo > _frameNo};
                isNil {
                    _oldNodes apply {_x call FUNC(buildTrenchSystem)};
                };
            };
        }];

        _skipper addEventHandler ["UnregisteredFromWorld3DEN", {
            params ["_skipper"];
            // Delete anything assosciated with this node.
            private _oldNodes = _skipper getVariable [QGVAR(affectedNodes), []];
            [_oldNodes, diag_frameNo] spawn {
                params ["_oldNodes", "_frameNo"];
                waitUntil {diag_frameNo > _frameNo};
                isNil {
                    _oldNodes apply {_x call FUNC(buildTrenchSystem)};
                };
            };
        }];
    } forEach _ehs;
}
