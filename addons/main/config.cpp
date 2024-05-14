#include "script_component.hpp"
// This is line 230
class CfgPatches
{
    class ADDON
    {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "cba_main",
            "TerrainLib_main",
            "Peer_Trenches_Vehicles"
        };
        author = "Seb";
        VERSION_CONFIG;
    };
};

class CfgFunctions
{
    class ADDON
    {
        class ADDON
        {
            file = QPATHTOF(functions);
            class allTrenchNetworks {};
            class buildTrenchSystem {};
            class cleanUpNodes {};
            class connectedTrenchPieces {};
            class getObjsToHide {};
            class getTerrainModPoints {};
            class handleObjects {};
            class handleTerrain {};
            class onEntityAdded {};
            class onMissionLoad {};
            class registerEntity {};
            class uniquePairs {};
        };
    };
};


class CfgVehicles
{
    class Logic;
    class Module_F: Logic {
        class AttributesBase
        {
            class Default;
            class Edit;					// Default edit box (i.e., text input field)
            class Combo;				// Default combo box (i.e., drop-down menu)
            class Checkbox;				// Default checkbox (returned value is Boolean)
            class CheckboxNumber;		// Default checkbox (returned value is Number)
            class ModuleDescription;	// Module description
            class Units;				// Selection of units on which the module is applied
        };
        // Description base classes, for more information see below
        class ModuleDescription
        {
            class AnyBrain;
        };
    };

    class GVAR(Module_TrenchPiece): Module_F
    {
        author = "Seb";
        scope = 2;
        scopeCurator = 0;
        displayName = "Trench Piece";
        category = "Trench_Category";
        isGlobal = 1;
        isTriggerActivated = 0;
        isDisposable = 0;
        is3DEN = 1;
        icon =  "\a3\Missions_F_Beta\data\img\iconMPTypeDefense_ca.paa";
    };
    class GVAR(Module_TrenchController): GVAR(Module_TrenchPiece) {
        displayName = "Trench Controller";
        icon = "A3\Modules_F_Tacops\Data\CivilianPresence\icon32_ca.paa";
        class Arguments
        {
            class TrenchDepth
            {
                displayName = "Depth";
                property = "TrenchDepth";
                description = "Depth of the upper lip of the trench to the bottom";
                typeName = "NUMBER";
                defaultValue = "2";
            };
            class TrenchWidth
            {
                displayName = "Width";
                property = "TrenchWidth";
                description = "Width of the trench";
                typeName = "NUMBER";
                defaultValue = "4";
            };
        };
    };
};
class Cfg3DEN {
    class EventHandlers {
        class ADDON {
            OnMissionLoad = QUOTE(call FUNC(onMissionLoad));
            OnEditableEntityAdded = QUOTE(_this call FUNC(onEntityAdded));
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class Trench_Category: NO_CATEGORY {
        displayName = "Trench Systems";
    };
};
