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
    class GVAR(Module_TrenchSkipper): Module_F {
        author = "Seb";
        scope = 2;
        scopeCurator = 0;
        displayName = "Skip Area";
        category = "Trench_Category";
        isGlobal = 1;
        isTriggerActivated = 0;
        isDisposable = 0;
        is3DEN = 1;
        canSetArea = 1;
        canSetAreaHeight = 0;
        canSetAreaShape = 1;
        icon =  "\a3\Modules_F_Curator\Data\iconRespawnTickets_ca.paa";
        portrait = "\a3\Modules_F_Curator\Data\portraitRespawnTickets_ca.paa";
        class AttributeValues
        {
            size3[] = {30,30,-1};
            isRectangle = 1;
        };
        class Attributes: AttributesBase
        {
            class GVAR(skipTerrain): Checkbox
            {
                property = QGVAR(skipTerrain);
                displayName = "Skip Terrain";
                tooltip = "Skip terrain modifications in area";
                typeName = "BOOL";
                defaultValue = "false";
            };
            class GVAR(segmentSkip): Checkbox
            {
                property = QGVAR(segmentSkip);
                displayName = "Skip Trench Objects";
                tooltip = "Skip trench segments in area";
                typeName = "BOOL";
                defaultValue = "false";
            };
            class GVAR(wallSkip): Checkbox
            {
                property = QGVAR(wallSkip);
                displayName = "Skip Trench Wall";
                tooltip = "Skip fortifications in area";
                typeName = "BOOL";
                defaultValue = "false";
            };
            class GVAR(sandbagSkip): Checkbox
            {
                property = QGVAR(sandbagSkip);
                displayName = "Skip Sandbags";
                tooltip = "Skip sandbags in area";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class GVAR(barbedWireSkip): Checkbox
            {
                property = QGVAR(barbedWireSkip);
                displayName = "Skip Barbed Wire";
                tooltip = "Skip barbed wire in area";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class GVAR(tankTrapSkip): Checkbox
            {
                property = QGVAR(tankTrapSkip);
                displayName = "Skip Tank Traps";
                tooltip = "Skip tank traps in area";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class GVAR(additonalHorizSkip): Checkbox
            {
                property = QGVAR(additonalHorizSkip);
                displayName = "Skip Additional Horizontal Segments";
                tooltip = "Skip additional horizontal segments in area";
                typeName = "BOOL";
                defaultValue = "false";
            };
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
        class Attributes: AttributesBase
        {
            class TrenchDepth: Edit
            {
                property = "TrenchDepth";
                displayName = "Depth";
                tooltip = "Depth of the upper lip of the trench to the bottom";
                typeName = "NUMBER";
                defaultValue = "2";
            };
            class TrenchWidth: Edit
            {
                property = "TrenchWidth";
                displayName = "Width";
                tooltip = "Width of the trench";
                typeName = "NUMBER";
                defaultValue = "4";
            };
            class BlendEnds: Checkbox
            {
                property = "BlendEnds";
                displayName = "Blend Ends";
                tooltip = "Blend the ends of the trench into the terrain";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class TrenchPitch: Edit
            {
                property = "TrenchPitch";
                displayName = "Pitch";
                tooltip = "Angle of trench wall";
                typeName = "NUMBER";
                defaultValue = "0";
            };
            class WallType: Combo
            {
                property = "WallType";
                displayName = "Wall Type";
                tooltip = "Reinforce the trench wall with one of the folowing";
                typeName = "STRING";
                defaultValue = "-1";
                class Values {
                    // Note: values are parsed as strings in game
                    class None {
                        default = 1;
                        name = "None";
                        value = "-1";
                    };
                    class Concrete {
                        default = 0;
                        name = "Concrete";
                        value = "0";
                    };
                    class Wood {
                        default = 0;
                        name = "Wood";
                        value = "1";
                    };
                    class Metal {
                        default = 0;
                        name = "Metal";
                        value = "2";
                    };
                    class Hesco {
                        default = 0;
                        name = "Hesco";
                        value = "3";
                    };
                    class HescoRamp
                    {
                        default = 0;
                        name = "Hesco (Ramp)";
                        value = "4";
                    };
                };
            };
            class DoSandbags: Combo
            {
                property = "DoSandbags";
                displayName = "Sandbags";
                tooltip = "Add sandbags to lip of trench";
                typeName = "STRING";
                defaultValue = "-1";
                class Values {
                    // Note: values are parsed as strings in game
                    class None {
                        default = 1;
                        name = "None";
                        value = "-1";
                    };
                    class Tan {
                        default = 0;
                        name = "Tan";
                        value = "0";
                    };
                    class Green {
                        default = 0;
                        name = "Green";
                        value = "1";
                    };
                };
            };
            class DoBarbedWire: Checkbox
            {
                property = "DoBarbedWire";
                displayName = "Barbed Wire";
                tooltip = "Add barbed wire to lip of trench. WARNING: Barbed wire objects are simulated and therefore can cause performance issues";
                typeName = "BOOL";
                defaultValue = "false";
            };
            class TankTrapType: Combo
            {
                property = "TankTrapType";
                displayName = "Tank traps";
                tooltip = "Add tank traps to lip of trench";
                typeName = "STRING";
                defaultValue = "-1";
                class Values {
                    // Note: values are parsed as strings in game
                    class None {
                        default = 1;
                        name = "None";
                        value = "-1";
                    };
                    class Hedgehog {
                        default = 0;
                        name = "Hedgehog";
                        value = "0";
                    };
                    class DragonTeeth {
                        default = 0;
                        name = "Dragon's Teeth";
                        value = "1";
                    };
                };
            };
            class AiBuildingPosition: Combo
            {
                property = "AiBuildingPosition";
                displayName = "AI Building Positions";
                tooltip = "Add points AI to garrison in  the trench";
                typeName = "STRING";
                defaultValue = "-1";
                class Values {
                    class None {
                        default = 1;
                        name = "None";
                        value = "-1";
                    };
                    class Waypoint {
                        default = 0;
                        name = "Yes";
                        value = "0";
                    };
                    class WaypointVisualised {
                        default = 0;
                        name = "Yes (Eden Visualisation)";
                        value = "1";
                    };
                };
            };
            class AdditionalHorizSegments: Edit
            {
                property = "AdditionalHorizSegments";
                displayName = "Extra Horizontal Segments";
                tooltip = "Extend the trench slope with additional horizontal segments. Good for terrains with large cell sizes";
                typeName = "NUMBER";
                defaultValue = "0";
            };
            class TransitionLength: Edit
            {
                property = "TransitionLength";
                displayName = "Terrain Transition Length";
                tooltip = "Distance from the edge of the trench to blend into the natural terrain";
                typeName = "NUMBER";
                defaultValue = "0";
            };
            class SkipTerrain: Checkbox
            {
                property = "SkipTerrain";
                displayName = "Skip Terrain";
                tooltip = "Skip generating terrain modifications for the trench.";
                typeName = "BOOL";
                defaultValue = "false";
            };
            class SkipObjects: Checkbox
            {
                property = "SkipObjects";
                displayName = "Skip Objects";
                tooltip = "Skip adding objects to the trench.";
                typeName = "BOOL";
                defaultValue = "false";
            };
                
            class SkipHidingObjects: Checkbox
            {
                property = "SkipHidingObjects";
                displayName = "Skip Hiding Objects";
                tooltip = "Skip hiding terrain objects in the trench area.";
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
