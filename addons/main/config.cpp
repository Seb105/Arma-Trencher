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

// class CfgFunctions
// {
//     class ADDON
//     {
//         class ADDON
//         {
//             file = QPATHTOF(functions);
//             class onMissionLoad {};
//         };
//     };
// };


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
                    class Hesco {
                        default = 0;
                        name = "Hesco";
                        value = 3;
                    };
                    class HescoRamp
                    {
                        default = 0;
                        name = "Hesco (Ramp)";
                        value = 4;
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
                description = "Add barbed wire to lip of trench. WARNING: Barbed wire objects are simulated and therefore can cause performance issues";
                typeName = "BOOL";
                defaultValue = "false";
            };
            class TankTrapType 
            {
                displayName = "Tank traps";
                description = "Add tank traps to lip of trench";
                class Values {
                    // Note: values are parsed as strings in game
                    class None {
                        default = 1;
                        name = "None";
                        value = -1;
                    };
                    class Hedgehog {
                        default = 0;
                        name = "Hedgehog";
                        value = 0;
                    };
                    class DragonTeeth {
                        default = 0;
                        name = "Dragon's Teeth";
                        value = 1;
                    };
                };
            };
            class AdditionalHorizSegments
            {
                displayName = "Extra Horizontal Segments";
                description = "Extend the trench slope with additional horizontal segments. Good for terrains with large cell sizes";
                typeName = "NUMBER";
                defaultValue = "0";
            };
            class SkipTerrain
            {
                displayName = "Skip Terrain";
                description = "Skip generating terrain modifications for the trench.";
                typeName = "BOOL";
                defaultValue = "false";
            };
            class SkipObjects
            {
                displayName = "Skip Objects";
                description = "Skip adding objects to the trench.";
                typeName = "BOOL";
                defaultValue = "false";
            };
            class SkipHidingObjects
            {
                displayName = "Skip Hiding Objects";
                description = "Skip hiding terrain objects in the trench area.";
                typeName = "BOOL";
                defaultValue = "false";
            };
        };
    };
};
class Cfg3DEN 
{
    // class EventHandlers 
    // {
    //     class ADDON 
    //     {
    //         onMissionLoad = QUOTE(call FUNC(onMissionLoad));
    //         onEditableEntityAdded = QUOTE(_this call FUNC(onEntityAdded));
    //     };
    // };
    class Mission 
    {
        class ADDON 
        {
            displayName = "Trencher";
            class AttributeCategories 
            {
                class MissionData 
                {
                    class Attributes 
                    {
                        class SimpleObjects 
                        {
                            defaultValue = "";
                            property = QGVAR(simpleObjects);
                        };
                        class SimulatedObjects 
                        {
                            defaultValue = "";
                            property = QGVAR(simulatedObjects);
                        };
                        class TrenchPieces 
                        {
                            defaultValue = "";
                            property = QGVAR(trenchPieces);
                        };
                        class HideAreas 
                        {
                            defaultValue = "";
                            property = QGVAR(hideAreas);
                        };
                        class TerrainPoints 
                        {
                            defaultValue = "";
                            property = QGVAR(terrainPoints);
                        };
                    };
                };
            };
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
