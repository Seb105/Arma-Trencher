params ["_pos", "_dir", "_offset"];
_pos vectorAdd [
    sin _dir * _offset,
    cos _dir * _offset,
    0
]
