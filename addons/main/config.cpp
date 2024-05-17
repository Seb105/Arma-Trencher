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
            // class buildTrenchSystem {};
            class cleanUpNodes {};
            class connectedTrenchPieces {};
            class getObjsToHide {};
            class getTerrainModPoints {};
            class handleObjectAdditions {};
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
        portrait = "\a3\Missions_F_Beta\data\img\portraitMPTypeDefense_ca.paa";
    };
    class GVAR(Module_TrenchController): GVAR(Module_TrenchPiece) {
        displayName = "Trench Controller";
        icon = "A3\Modules_F_Tacops\Data\CivilianPresence\icon32_ca.paa";
        portrait = "A3\Modules_F_Tacops\Data\CivilianPresence\icon32_ca.paa";
        class Arguments
        {
            class TrenchDepth
            {
                displayName = "Depth";
                description = "Depth of the upper lip of the trench to the bottom";
                typeName = "NUMBER";
                defaultValue = "2";
            };
            class TrenchWidth
            {
                displayName = "Width";
                description = "Width of the trench";
                typeName = "NUMBER";
                defaultValue = "4";
            };
            class BlendEnds
            {
                displayName = "Blend Ends";
                description = "Blend the ends of the trench into the terrain";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class TrenchPitch
            {
                displayName = "Pitch";
                description = "Angle of trench wall";
                typeName = "NUMBER";
                defaultValue = "0";
            };
            class WallType 
            {
                displayName = "Wall Type";
                description = "Reinforce the trench wall with one of the folowing";
                class Values {
                    // Note: values are parsed as strings in game
                    class None {
                        default = 1;
                        name = "None";
                        value = -1;
                    };
                    class Concrete {
                        default = 0;
                        name = "Concrete";
                        value = 0;
                    };
                    class Wood {
                        default = 0;
                        name = "Wood";
                        value = 1;
                    };
                    class Metal {
                        default = 0;
                        name = "Metal";
                        value = 2;
                    };
                };
            };
            class DoSandbags 
            {
                displayName = "Sandbags";
                description = "Add sandbags to lip of trench";
                typeName = "BOOL";
                defaultValue = "false";
            };
            class DoBarbedWire 
            {
                displayName = "Barbed Wire";
                description = "Add barbed wire to lip of trench";
                typeName = "BOOL";
                defaultValue = "false";
            };
        };
    };
};
class Cfg3DEN {
    class EventHandlers {
        class ADDON {
            onMissionLoad =  QUOTE([] call FUNC(onMissionLoad));
            onEditableEntityAdded = QUOTE(_this call FUNC(onEntityAdded));
        };
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class Trench_Category: NO_CATEGORY {
        displayName = "Trench Systems";
    };
};

#include "CfgEventHandlers.hpp"
