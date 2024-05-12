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
            "A3_Characters_F_Enoch",
            "A3_Supplies_F_Enoch_Bags"};
        author = "Seb";
        VERSION_CONFIG;
    };
};

class CfgWeapons
{
    class ItemCore;

    // Helmets
    class H_HelmetB : ItemCore
    {
        class ItemInfo;
    };
    class H_HelmetB_plain_mcamo;
    class H_HelmetSpecB : H_HelmetB_plain_mcamo
    {
        class ItemInfo;
    };
    class H_HelmetB_light : H_HelmetB
    {
        class ItemInfo;
    };
    // Raven
    class GVAR(H_HelmetSpecter_base_F) : H_HelmetSpecB
    {
        author = "AveryTheKitty, DeathStruck & Midnas";
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        model = QPATHTOF(Headgear\H_HelmetSpecter_F.p3d);
        hiddenSelections[] = {
            "camo"};
        descriptionShort = "Raven Helmet";
        class ItemInfo : ItemInfo
        {
            hiddenSelections[] = {
                "camo"};
            uniformModel = QPATHTOF(Headgear\H_HelmetSpecter_F.p3d);
        };
    };
    class GVAR(H_HelmetSpecter_headset_base_F) : GVAR(H_HelmetSpecter_base_F)
    {
        model = QPATHTOF(Headgear\H_HelmetSpecter_headset_F.p3d);
        hiddenSelections[] = {
            "camo1",
            "camo2"};
        class ItemInfo : ItemInfo
        {
            hiddenSelections[] = {
                "camo1",
                "camo2"};
            uniformModel = QPATHTOF(Headgear\H_HelmetSpecter_headset_F.p3d);
        };
    };
    class GVAR(H_HelmetSpecter_cover_base_F) : GVAR(H_HelmetSpecter_base_F)
    {
        model = QPATHTOF(Headgear\H_HelmetSpecter_cover_F.p3d);
        hiddenSelections[] = {
            "camo1",
            "camo2"};
        class ItemInfo : ItemInfo
        {
            hiddenSelections[] = {
                "camo1",
                "camo2"};
            uniformModel = QPATHTOF(Headgear\H_HelmetSpecter_cover_F.p3d);
        };
    };
    // MK7
    class GVAR(H_MK7_Base_F) : H_HelmetSpecB
    {
        author = "Bran Flakes and TacticalDruid";
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        displayName = "MK7";
        descriptionShort = "MK7 Helmet";
        model = QPATHTOF(Headgear\H_Mk7_F);
        hiddenSelections[] = {
            "Camo",
            "Camo2",
            "Camo3"};
        class ItemInfo : ItemInfo
        {
            mass = 30;
            hiddenSelections[] = {
                "camo"};
            uniformModel = QPATHTOF(Headgear\H_Mk7_F);
            modelSides[] = {1, 3};
            class HitpointsProtectionInfo
            {
                class Head
                {
                    hitpointName = "HitHead";
                    armor = 6;
                    passThrough = 0.5;
                };
            };
        };
    };
    // Light Helmets
    class GVAR(H_HelmetB_light_basic_base) : H_HelmetB_light
    {
        scope = 0;
        model = "\A3\Characters_F\Common\headgear_placeholder.p3d";
        class ItemInfo : ItemInfo
        {
            uniformModel = "\A3\Characters_F\Common\headgear_placeholder.p3d";
        };
    };
    class GVAR(H_HelmetB_light_base) : H_HelmetB_light
    {
        scope = 0;
        model = "\A3\Characters_F\BLUFOR\headgear_B_Helmet_light.p3d";
        class ItemInfo : ItemInfo
        {
            uniformModel = "\A3\Characters_F\BLUFOR\headgear_B_Helmet_light.p3d";
        };
    };
    // Luchnik Helm
    class GVAR(H_HelmetEAST_base_F) : H_HelmetSpecB
    {
        author = "Jamie of the A3 Aegis Team";
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        model = QPATHTOF(Headgear\H_HelmetEAST_F.p3d);
        hiddenSelections[] = {
            "camo"};
        descriptionShort = "Luchnik Helmet";
        class ItemInfo : ItemInfo
        {
            hiddenSelections[] = {
                "camo"};
            uniformModel = QPATHTOF(Headgear\H_HelmetEAST_F.p3d);
        };
    };
    class GVAR(H_HelmetEAST_Headset_F) : GVAR(H_HelmetEAST_base_F)
    {
        model = QPATHTOF(Headgear\H_HelmetEAST_Headset_F.p3d);
        hiddenSelections[] = {
            "camo",
            "camo1"};
        class ItemInfo : ItemInfo
        {
            hiddenSelections[] = {
                "camo",
                "camo1"};
            uniformModel = QPATHTOF(Headgear\H_HelmetEAST_Headset_F.p3d);
        };
    };
    class GVAR(H_HelmetEAST_Cover_base_F) : GVAR(H_HelmetSpecter_base_F)
    {
        model = QPATHTOF(Headgear\H_HelmetEAST_Cover_F.p3d);
        hiddenSelections[] = {
            "camo",
            "camo1",
            "camo2"};
        class ItemInfo : ItemInfo
        {
            hiddenSelections[] = {
                "camo",
                "camo1",
                "camo2"};
            uniformModel = QPATHTOF(Headgear\H_HelmetEAST_Cover_F.p3d);
        };
    };
    // M1
    class GVAR(jam_H_M1) : H_HelmetB_light {
        author = "Jamie";
        displayName = "M1";
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        model = QPATHTOF(Headgear\jam_m1.p3d);
        hiddenSelections[] = {
            "camo"};
        descriptionShort = "M1";
        class ItemInfo : ItemInfo
        {
            hiddenSelections[] = {
                "camo"};
            uniformModel = QPATHTOF(Headgear\jam_m1.p3d);
        };
    };
    class GVAR(jam_H_M1_cover) : GVAR(jam_H_M1) {
        displayName = "M1 (Cover)";
        model = QPATHTOF(Headgear\jam_m1_cover.p3d);
        hiddenSelections[] = {
            "camo",
            "camo1"};
        descriptionShort = "M1 (Cover)";
        class ItemInfo : ItemInfo
        {
            hiddenSelections[] = {
                "camo",
                "camo1"};
            uniformModel = QPATHTOF(Headgear\jam_m1_cover.p3d);
        };
    };
    class GVAR(jam_H_M1_cover_band) : GVAR(jam_H_M1_cover) {
        displayName = "M1 (Cover, Band)";
        model = QPATHTOF(Headgear\jam_m1_cover_band.p3d);
        descriptionShort = "M1 (Cover, Band)";
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Headgear\jam_m1_cover_band.p3d);
        };
    };
    class GVAR(jam_H_M1_net) : GVAR(jam_H_M1_cover) {
        displayName = "M1 (Net)";
        model = QPATHTOF(Headgear\jam_m1_net.p3d);
        descriptionShort = "M1 (Net)";
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Headgear\jam_m1_net.p3d);
        };
    };

    // SSh-68
    class GVAR(jam_H_SSh68) : H_HelmetB_light {
        author = "Jamie";
        displayName = "SSh-68";
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        model = QPATHTOF(Headgear\jam_ssh68.p3d);
        hiddenSelections[] = {
            "camo"};
        descriptionShort = "SSh-68";
        class ItemInfo : ItemInfo
        {
            hiddenSelections[] = {
                "camo"};
            uniformModel = QPATHTOF(Headgear\jam_ssh68.p3d);
        };
    };
    class GVAR(jam_H_SSh68_cover) : GVAR(jam_H_SSh68) {
        displayName = "SSh-68 (Cover)";
        model = QPATHTOF(Headgear\jam_ssh68_cover_01.p3d);
        hiddenSelections[] = {
            "camo",
            "camo1"};
        descriptionShort = "SSh-68 (Cover)";
        class ItemInfo : ItemInfo
        {
            hiddenSelections[] = {
                "camo",
                "camo1"};
            uniformModel = QPATHTOF(Headgear\jam_ssh68_cover_01.p3d);
        };
    };
    class GVAR(jam_H_SSh68_net) : GVAR(jam_H_SSh68_cover) {
        displayName = "SSh-68 (Net)";
        model = QPATHTOF(Headgear\jam_ssh68_net.p3d);
        descriptionShort = "SSh-68 (Net)";
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Headgear\jam_ssh68_net.p3d);
        };
    };
    // Fast MT
    class GVAR(H_HelmetFASTMT_base_F) : H_HelmetSpecB
    {
        displayName = "Opscore Fast MT";
        author = "A3 Aegis Team";
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        model = QPATHTOF(Headgear\H_HelmetFASTMT_F.p3d);
        hiddenSelections[] = {
            "camo"};
        descriptionShort = "Opscore Fast MT";
        class ItemInfo : ItemInfo
        {
            hiddenSelections[] = {
                "camo"};
            uniformModel = QPATHTOF(Headgear\H_HelmetFASTMT_F.p3d);
        };
    };
    class GVAR(H_HelmetFASTMT_Headset_base_F) : GVAR(H_HelmetFASTMT_base_F)
    {
        displayName = "Opscore Fast MT";
        model = QPATHTOF(Headgear\H_HelmetFASTMT_Headset_F.p3d);
        hiddenSelections[] = {
            "camo",
            "camo1"};
        descriptionShort = "Opscore Fast MT";
        class ItemInfo : ItemInfo
        {
            hiddenSelections[] = {
                "camo",
                "camo1"};
            uniformModel = QPATHTOF(Headgear\H_HelmetFASTMT_Headset_F.p3d);
        };
    };
    class GVAR(H_HelmetFASTMT_Cover_base_F) : GVAR(H_HelmetFASTMT_base_F)
    {
        displayName = "Opscore Fast MT (Cover)";
        model = QPATHTOF(Headgear\H_HelmetFASTMT_Cover_F.p3d);
        hiddenSelections[] = {
            "camo",
            "camo1",
            "camo2"};
        descriptionShort = "Opscore Fast MT (Cover)";
        class ItemInfo : ItemInfo
        {
            hiddenSelections[] = {
                "camo",
                "camo1",
                "camo2"};
            uniformModel = QPATHTOF(Headgear\H_HelmetFASTMT_Cover_F.p3d);
        };
    };
    


    // Vests
    class Vest_NoCamo_Base;
    class V_PlateCarrier1_rgr : Vest_NoCamo_Base
    {
        class ItemInfo;
    };
    class V_PlateCarrier2_rgr : Vest_NoCamo_Base
    {
        class ItemInfo;
    };
    class V_PlateCarrierSpec_rgr : Vest_NoCamo_Base
    {
        class ItemInfo;
    };
    class V_PlateCarrierGL_rgr : Vest_NoCamo_Base
    {
        class ItemInfo;
    };
    class Vest_Camo_Base;
    class V_Chestrig_khk : Vest_Camo_Base
    {
        class ItemInfo;
    };
    // Defender Rig
    class GVAR(V_CF_CarrierRig_base_F) : V_PlateCarrier1_rgr
    {
        author = "A3 Aegis Team";
        scope = 0;
        displayName = "Defender Rig";
        descriptionShort = "Defender Rig";
        hiddenSelections[] = {
            "camo"};
        hiddenSelectionsTextures[] = {
            QPATHTOF(Vests\data\V_CF_CarrierRig_CO.paa)};
        model = QPATHTOF(Vests\V_CF_CarrierRig_F.p3d);
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\V_CF_CarrierRig_F.p3d);
            hiddenSelections[] = {
                "camo"};
            hiddenSelectionsTextures[] = {
                QPATHTOF(Vests\data\V_CF_CarrierRig_CO.paa)};
            containerClass = "Supply60";
            mass = 25;
        };
    };
    class GVAR(V_CF_CarrierRig_Lite_base_F) : V_PlateCarrier1_rgr
    {
        author = "A3 Aegis Team";
        scope = 0;
        displayName = "Defender Rig Lite";
        hiddenSelections[] = {
            "camo",
            "camo1"};
        hiddenSelectionsTextures[] = {
            QPATHTOF(Vests\data\V_CF_CarrierRig_CO.paa),
            QPATHTOF(Vests\data\V_CF_CarrierRig_Pouches_CO.paa)};
        model = QPATHTOF(Vests\V_CF_CarrierRig_Lite_F.p3d);
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\V_CF_CarrierRig_Lite_F.p3d);
            hiddenSelections[] = {
                "camo",
                "camo1"};
            hiddenSelectionsTextures[] = {
                QPATHTOF(Vests\data\V_CF_CarrierRig_CO.paa),
                QPATHTOF(Vests\data\V_CF_CarrierRig_Pouches_CO.paa)};
            containerClass = "Supply140";
            mass = 35;
        };
    };
    class GVAR(V_CF_CarrierRig_MG_base_F) : V_PlateCarrier1_rgr
    {
        author = "A3 Aegis Team";
        scope = 0;
        displayName = "Defender Rig Machinegunner";
        hiddenSelections[] = {
            "camo",
            "camo1"};
        hiddenSelectionsTextures[] = {
            QPATHTOF(Vests\data\V_CF_CarrierRig_CO.paa),
            QPATHTOF(Vests\data\V_CF_CarrierRig_Pouches_CO.paa)};
        model = QPATHTOF(Vests\V_CF_CarrierRig_MG_F.p3d);
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\V_CF_CarrierRig_MG_F.p3d);
            hiddenSelections[] = {
                "camo",
                "camo1"};
            hiddenSelectionsTextures[] = {
                QPATHTOF(Vests\data\V_CF_CarrierRig_CO.paa),
                QPATHTOF(Vests\data\V_CF_CarrierRig_Pouches_CO.paa)};
            containerClass = "Supply160";
            mass = 40;
        };
    };

    // Odin Rig
    class GVAR(V_CarrierRigBW_CQB_F) : V_PlateCarrierGL_rgr
    {
        author = "Jamie (Aegis Team)";
        scope = 0;
        displayName = "Odin Rig CQB";
        descriptionShort = "Odin Rig";
        hiddenSelections[] = {
            "camo",
            "camo1",
            "camo2"};
        model = QPATHTOF(Vests\V_CarrierRigBW_CQB_F.p3d);
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\V_CarrierRigBW_CQB_F.p3d);
            hiddenSelections[] = {
                "camo",
                "camo1",
                "camo2"};
        };
    };
    class GVAR(V_CarrierRigBW_F) : V_PlateCarrier1_rgr
    {
        author = "Jamie (Aegis Team)";
        scope = 0;
        displayName = "Odin Rig";
        descriptionShort = "Odin Rig";
        hiddenSelections[] = {
            "camo"};
        model = QPATHTOF(Vests\V_CarrierRigBW_F.p3d);
        class ItemInfo : ItemInfo
        {
            uniformModel = "z\acp\addons\main\Vests\V_CarrierRigBW_F.p3d";
            hiddenSelections[] = {
                "camo"};
        };
    };
    class GVAR(V_CarrierRigBW_GL_F) : V_PlateCarrierGL_rgr
    {
        author = "Jamie (Aegis Team)";
        scope = 0;
        displayName = "Odin Rig GL";
        descriptionShort = "Odin Rig";
        hiddenSelections[] = {
            "camo",
            "camo1",
            "camo2"};
        model = QPATHTOF(Vests\V_CarrierRigBW_GL_F.p3d);
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\V_CarrierRigBW_GL_F.p3d);
            hiddenSelections[] = {
                "camo",
                "camo1",
                "camo2"};
        };
    };
    class GVAR(V_CarrierRigBW_Lite_F) : V_PlateCarrier2_rgr
    {
        author = "Jamie (Aegis Team)";
        scope = 0;
        displayName = "Odin Rig Lite";
        descriptionShort = "Odin Rig";
        hiddenSelections[] = {
            "camo",
            "camo1"};
        model = QPATHTOF(Vests\V_CarrierRigBW_Lite_F.p3d);
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\V_CarrierRigBW_Lite_F.p3d);
            hiddenSelections[] = {
                "camo",
                "camo1"};
        };
    };
    

    // Luchnik Carrier
    class GVAR(Aegis_OCarrierLuchnik_CQB_base_F) : V_PlateCarrierGL_rgr
    {
        author = "Aegis Team";
        scope = 0;
        displayName = "Luchnik Carrier CQB";
        descriptionShort = "Luchnik Carrier";
        hiddenSelections[] = {
            "camo",
            "camo1"};
        model = QPATHTOF(Vests\Aegis_OCarrierLuchnik_CQB_F.p3d);
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\Aegis_OCarrierLuchnik_CQB_F.p3d);
            hiddenSelections[] = {
                "camo",
                "camo1"};
        };
    };
    class GVAR(Aegis_OCarrierLuchnik_base_F) : V_PlateCarrier1_rgr
    {
        author = "Aegis Team";
        scope = 0;
        displayName = "Luchnik Carrier";
        descriptionShort = "Luchnik Carrier";
        hiddenSelections[] = {
            "camo"};
        model = QPATHTOF(Vests\Aegis_OCarrierLuchnik_F.p3d);
        class ItemInfo : ItemInfo
        {
            uniformModel =  QPATHTOF(Vests\Aegis_OCarrierLuchnik_F.p3d);
            hiddenSelections[] = {
                "camo"};
        };
    };
    class GVAR(Aegis_OCarrierLuchnik_GL_base_F) : V_PlateCarrierGL_rgr
    {
        author = "Aegis Team";
        scope = 0;
        displayName = "Luchnik Carrier GL";
        descriptionShort = "Luchnik Carrier";
        hiddenSelections[] = {
            "camo",
            "camo1"};
        model = QPATHTOF(Vests\Aegis_OCarrierLuchnik_GL_F.p3d);
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\Aegis_OCarrierLuchnik_GL_F.p3d);
            hiddenSelections[] = {
                "camo",
                "camo1"};
        };
    };
    class GVAR(Aegis_OCarrierLuchnik_Lite_base_F) : V_PlateCarrier1_rgr
    {
        author = "Aegis Team";
        scope = 0;
        displayName = "Luchnik Carrier Lite";
        descriptionShort = "Luchnik Carrier";
        hiddenSelections[] = {
            "camo"};
        model = QPATHTOF(Vests\Aegis_OCarrierLuchnik_Lite_F.p3d);
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\Aegis_OCarrierLuchnik_Lite_F.p3d);
            hiddenSelections[] = {
                "camo"};
        };
    };

    // Lifchik-M
    class GVAR(V_ChestRigEast_base_F) : V_Chestrig_khk
    {
        author = "Jamie (Aegis Team)";
        scope = 0;
        displayName = "Lifchik-M";
        descriptionShort = "Lifchik-M Chest Rig";
        hiddenSelections[] = {
            "camo"};
        hiddenSelectionsTextures[] = {
            QPATHTOF(Vests\data\VChestrigEast_grn_CO.paa)};
        model = QPATHTOF(Vests\jam_lifchik_v2.p3d);
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\jam_lifchik_v2.p3d);
            hiddenSelections[] = {
                "camo"};
            hiddenSelectionsTextures[] = {
                QPATHTOF(Vests\data\VChestrigEast_grn_CO.paa)};
        };
    };

    // Crye AVS
    class GVAR(Crye_AVS_1_base) : V_PlateCarrier1_rgr
    {
        author = "The Sad Face";
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        displayName = "AVS Assaulter #1 MC";
        model = QPATHTOF(Vests\AVS_1.p3d);
        hiddenSelections[] = {
            "AVS_Base",
            "AVSx3Pouch",
            "Belt556Pouch",
            "BluforceMed",
            "Cumber_x3",
            "Belt",
            "GP_Pouch_BL",
            "Harris152a_FL",
            "PistolmagsBelt",
            "pouch556_FR",
            "SFLandHolster",
            "SidePlate",
            "S20"};
        hiddenSelectionsTextures[] = {
            QPATHTOF(Vests\data\AVS\Vest\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\AVSPouch\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Belt556\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\BluforMed\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Cumberbands\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\BeltGBRS\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\GPpouch\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Radio\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\glockMags\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\pouch556\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\SFL_Holster\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Sideplate\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\S20\S20_CO.paa)};
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\AVS_1.p3d);
            hiddenSelections[] = {
                "AVS_Base",
                "AVSx3Pouch",
                "Belt556Pouch",
                "BluforceMed",
                "Cumber_x3",
                "Belt",
                "GP_Pouch_BL",
                "Harris152a_FL",
                "PistolmagsBelt",
                "pouch556_FR",
                "SFLandHolster",
                "SidePlate",
                "S20"};
            hiddenSelectionsTextures[] = {
                QPATHTOF(Vests\data\AVS\Vest\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\AVSPouch\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Belt556\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\BluforMed\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Cumberbands\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\BeltGBRS\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\GPpouch\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Radio\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\glockMags\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\pouch556\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\SFL_Holster\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Sideplate\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\S20\S20_CO.paa)};
        };
    };
    class GVAR(Crye_AVS_1_1_base) : GVAR(Crye_AVS_1_base)
    {
        displayName = "AVS Assaulter #2 MC";
        model = QPATHTOF(Vests\AVS_1_1.p3d);
        hiddenSelections[] = {
            "AVS_Base",
            "Belt556Pouch",
            "BluforceMed",
            "Cumber_x3",
            "Belt",
            "GP_Pouch_BL",
            "Harris152a_FL",
            "Kangaroo_Pouch",
            "PistolmagsBelt",
            "pouch556_FR",
            "SFLandHolster",
            "SidePlate",
            "S20"};
        hiddenSelectionsTextures[] = {
            QPATHTOF(Vests\data\AVS\Vest\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Belt556\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\BluforMed\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Cumberbands\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\BeltGBRS\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\GPpouch\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Radio\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Kangaroo\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\glockMags\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\pouch556\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\SFL_Holster\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Sideplate\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\S20\S20_CO.paa)};
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\AVS_1_1.p3d);
            hiddenSelections[] = {
                "AVS_Base",
                "Belt556Pouch",
                "BluforceMed",
                "Cumber_x3",
                "Belt",
                "GP_Pouch_BL",
                "Harris152a_FL",
                "Kangaroo_Pouch",
                "PistolmagsBelt",
                "pouch556_FR",
                "SFLandHolster",
                "SidePlate",
                "S20"};
            hiddenSelectionsTextures[] = {
                QPATHTOF(Vests\data\AVS\Vest\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Belt556\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\BluforMed\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Cumberbands\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\BeltGBRS\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\GPpouch\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Radio\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Kangaroo\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\glockMags\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\pouch556\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\SFL_Holster\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Sideplate\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\S20\S20_CO.paa)};
        };
    };
    class GVAR(Crye_AVS_1_2_base) : GVAR(Crye_AVS_1_base)
    {
        displayName = "AVS Assaulter #3 MC";
        model = QPATHTOF(Vests\AVS_1_2.p3d);
        hiddenSelections[] = {
            "AVS_Base",
            "AVS_MK4",
            "Belt556Pouch",
            "BluforceMed",
            "Cumber_x3",
            "Belt",
            "GP_Pouch_BL",
            "Harris152a_FL",
            "PistolmagsBelt",
            "pouch556_FR",
            "SFLandHolster",
            "SidePlate",
            "S20"};
        hiddenSelectionsTextures[] = {
            QPATHTOF(Vests\data\AVS\Vest\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Mk4\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Belt556\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\BluforMed\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Cumberbands\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\BeltGBRS\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\GPpouch\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Radio\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\glockMags\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\pouch556\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\SFL_Holster\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Sideplate\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\S20\S20_CO.paa)};
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\AVS_1_2.p3d);
            hiddenSelections[] = {
                "AVS_Base",
                "AVS_MK4",
                "Belt556Pouch",
                "BluforceMed",
                "Cumber_x3",
                "Belt",
                "GP_Pouch_BL",
                "Harris152a_FL",
                "PistolmagsBelt",
                "pouch556_FR",
                "SFLandHolster",
                "SidePlate",
                "S20"};
            hiddenSelectionsTextures[] = {
                QPATHTOF(Vests\data\AVS\Vest\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Mk4\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Belt556\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\BluforMed\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Cumberbands\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\BeltGBRS\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\GPpouch\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Radio\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\glockMags\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\pouch556\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\SFL_Holster\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Sideplate\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\S20\S20_CO.paa)};
        };
    };
    class GVAR(Crye_AVS_1_3_base) : GVAR(Crye_AVS_1_base)
    {
        displayName = "AVS Assaulter #4 MC";
        model = QPATHTOF(Vests\AVS_1_3.p3d);
        hiddenSelections[] = {
            "AVS_Base",
            "AVSx3Pouch_T",
            "Belt556Pouch",
            "BluforceMed",
            "Cumber_x3",
            "Belt",
            "GP_Pouch_BL",
            "Harris152a_FL",
            "PistolmagsBelt",
            "pouch556_FR",
            "SFLandHolster",
            "SidePlate",
            "S20"};
        hiddenSelectionsTextures[] = {
            QPATHTOF(Vests\data\AVS\Vest\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\AVSPouchT\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Belt556\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\BluforMed\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Cumberbands\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\BeltGBRS\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\GPpouch\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Radio\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\glockMags\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\pouch556\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\SFL_Holster\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Sideplate\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\S20\S20_CO.paa)};
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\AVS_1_3.p3d);
            hiddenSelections[] = {
                "AVS_Base",
                "AVSx3Pouch_T",
                "Belt556Pouch",
                "BluforceMed",
                "Cumber_x3",
                "Belt",
                "GP_Pouch_BL",
                "Harris152a_FL",
                "PistolmagsBelt",
                "pouch556_FR",
                "SFLandHolster",
                "SidePlate",
                "S20"};
            hiddenSelectionsTextures[] = {
                QPATHTOF(Vests\data\AVS\Vest\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\AVSPouchT\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Belt556\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\BluforMed\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Cumberbands\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\BeltGBRS\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\GPpouch\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Radio\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\glockMags\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\pouch556\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\SFL_Holster\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Sideplate\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\S20\S20_CO.paa)};
        };
    };

    class GVAR(Crye_AVS_2_base) : GVAR(Crye_AVS_1_base)
    {
        displayName = "AVS Gunner #1 MC";
        model = QPATHTOF(Vests\AVS_2.p3d);
        hiddenSelections[] = {
            "AVS_Base",
            "AVSx3Pouch",
            "BluforceMed",
            "Cumber_x3",
            "Belt",
            "Harris152a_FL",
            "LMG_Pouches",
            "PistolmagsBelt",
            "SFLandHolster",
            "SidePlate",
            "S20"};
        hiddenSelectionsTextures[] = {
            QPATHTOF(Vests\data\AVS\Vest\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\AVSPouch\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\BluforMed\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Cumberbands\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\BeltGBRS\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Radio\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\lmgpouches\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\glockMags\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\SFL_Holster\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\Sideplate\MC_CO.paa),
            QPATHTOF(Vests\data\AVS\S20\S20_CO.paa)};
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\AVS_2.p3d);
            hiddenSelections[] = {
                "AVS_Base",
                "AVSx3Pouch",
                "BluforceMed",
                "Cumber_x3",
                "Belt",
                "Harris152a_FL",
                "LMG_Pouches",
                "PistolmagsBelt",
                "SFLandHolster",
                "SidePlate",
                "S20"};
            hiddenSelectionsTextures[] = {
                QPATHTOF(Vests\data\AVS\Vest\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\AVSPouch\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\BluforMed\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Cumberbands\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\BeltGBRS\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Radio\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\lmgpouches\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\glockMags\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\SFL_Holster\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\Sideplate\MC_CO.paa),
                QPATHTOF(Vests\data\AVS\S20\S20_CO.paa)};
        };
    };

    // LBT G3
    class GVAR(LBT_G3_base) : V_PlateCarrier1_rgr
    {
        author = "TSF";
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        displayName = "LBT-6094G3-MC";
        model = QPATHTOF(Vests\6094g3.p3d);
        hiddenSelections[] = {
            "PC",
            "Cumberbund",
            "Kangaroo_Panel",
            "belt",
            "BluforceMed",
            "Belt556Pouch",
            "PistolmagsBelt",
            "SFLandHolster"};
        hiddenSelectionsTextures[] = {
            QPATHTOF(Vests\data\AVS\PC\MC_co.paa),
            QPATHTOF(Vests\data\AVS\Cumberbund\MC_co.paa),
            QPATHTOF(Vests\data\AVS\kangaroopanel\MC_co.paa),
            QPATHTOF(Vests\data\AVS\beltgbrs\MC_co.paa),
            QPATHTOF(Vests\data\AVS\bluformed\MC_co.paa),
            QPATHTOF(Vests\data\AVS\belt556\MC_co.paa),
            QPATHTOF(Vests\data\AVS\glockmags\MC_co.paa),
            QPATHTOF(Vests\data\AVS\SFL_holster\MC_co.paa)};
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\6094g3.p3d);
            hiddenSelections[] = {
                "PC",
                "Cumberbund",
                "Kangaroo_Panel",
                "belt",
                "BluforceMed",
                "Belt556Pouch",
                "PistolmagsBelt",
                "SFLandHolster"};
            hiddenSelectionsTextures[] = {
                QPATHTOF(Vests\data\AVS\PC\MC_co.paa),
                QPATHTOF(Vests\data\AVS\Cumberbund\MC_co.paa),
                QPATHTOF(Vests\data\AVS\kangaroopanel\MC_co.paa),
                QPATHTOF(Vests\data\AVS\beltgbrs\MC_co.paa),
                QPATHTOF(Vests\data\AVS\bluformed\MC_co.paa),
                QPATHTOF(Vests\data\AVS\belt556\MC_co.paa),
                QPATHTOF(Vests\data\AVS\glockmags\MC_co.paa),
                QPATHTOF(Vests\data\AVS\SFL_holster\MC_co.paa)};
        };
    };

    class GVAR(LBT_G3_NB_base) : GVAR(LBT_G3_base)
    {
        displayName = "LBT-6094G3-MC-NB";
        model = QPATHTOF(Vests\6094g3_NB.p3d);
        hiddenSelections[] = {"PC", "Cumberbund", "Kangaroo_Panel"};
        hiddenSelectionsTextures[] = {
            QPATHTOF(Vests\data\AVS\PC\MC_co.paa),
            QPATHTOF(Vests\data\AVS\Cumberbund\MC_co.paa),
            QPATHTOF(Vests\data\AVS\kangaroopanel\MC_co.paa)};
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\6094g3_NB.p3d);
            hiddenSelections[] = {"PC", "Cumberbund", "Kangaroo_Panel"};
            hiddenSelectionsTextures[] = {
                QPATHTOF(Vests\data\AVS\PC\MC_co.paa),
                QPATHTOF(Vests\data\AVS\Cumberbund\MC_co.paa),
                QPATHTOF(Vests\data\AVS\kangaroopanel\MC_co.paa)};
        };
    };

    // 6B3
    class GVAR(jam_V_6b3_base) : V_PlateCarrier1_rgr {
        author = "Jamie";
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        displayName = "6b3";
        descriptionShort = "6b3";
        hiddenSelections[] = {
            "camo"};
        hiddenSelectionsTextures[] = {
            QPATHTOF(Vests\data\jam_6b3_khk_CO.paa)
        };
        class ItemInfo : ItemInfo
        {
            uniformModel = QPATHTOF(Vests\jam_6b3.p3d);
            hiddenSelections[] = {
                "camo"
            };
            hiddenSelectionsTextures[] = {
                QPATHTOF(Vests\data\jam_6b3_khk_CO.paa)
            };
        };
    };

    // Uniforms
    class Uniform_Base;
    class U_O_officer_noInsignia_hex_F : Uniform_Base
    {
        class ItemInfo;
    };
    class U_I_CombatUniform : Uniform_Base
    {
        class ItemInfo;
    };
    // Luchnik fatigues
    class GVAR(U_Aegis_O_Soldier_03_base) : U_O_officer_noInsignia_hex_F
    {
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        displayName = "Luchnik Fatigues";
        descriptionShort = "Luchnik Fatigues";
        class ItemInfo : ItemInfo
        {
            uniformClass = QGVAR(Aegis_O_Soldier_03_base);
        };
    };
    class GVAR(U_Aegis_O_Soldier_04_base) : U_O_officer_noInsignia_hex_F
    {
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        displayName = "Luchnik Fatigues (Rolled-up)";
        descriptionShort = "Luchnik Fatigues";
        class ItemInfo : ItemInfo
        {
            uniformClass = QGVAR(Aegis_O_Soldier_04_base);
        };
    };

    // Obr 88 fatigues
    class GVAR(jam_U_obr88_base) : U_I_CombatUniform
    {
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        displayName = "Obr. 88 Fatigues";
        descriptionShort = "Obr. 88 Fatigues";
        class ItemInfo : ItemInfo 
        {
            uniformClass = QGVAR(jam_soldier_obr88);
        };
    };
    class GVAR(jam_obr88_rolled_base) : U_I_CombatUniform
    {
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        displayName = "Obr. 88 Fatigues (Rolled-up)";
        descriptionShort = "Obr. 88 Fatigues (Rolled-up)";
        class ItemInfo : ItemInfo {
            uniformClass = QGVAR(jam_soldier_obr88_rolled);
        };
    };
    class GVAR(jam_U_obr88_tshirt_base) : U_I_CombatUniform
    {
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        displayName = "Obr. 88 Fatigues (T-shirt)";
        descriptionShort = "Obr. 88 Fatigues (T-shirt)";
        class ItemInfo : ItemInfo {
            uniformClass = QGVAR(jam_soldier_obr88_tshirt);
        };
    };

    // KZS suit
    class GVAR(jam_U_KZS_up_base) : U_I_CombatUniform
    {
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        displayName = "KZS Suit (Hood up)";
        descriptionShort = "KZS Suit (Hood up)";
        class ItemInfo : ItemInfo {
            uniformClass = QGVAR(jam_soldier_KZS_up);
        };
    };
    class GVAR(jam_U_KZS_down_base) : U_I_CombatUniform
    {
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        displayName = "KZS Suit (Hood down)";
        descriptionShort = "KZS Suit (Hood down)";
        class ItemInfo : ItemInfo {
            uniformClass = QGVAR(jam_soldier_KZS_down);
        };
    };
};


class CfgVehicles
{
    class O_A_officer_F;
    class O_A_soldier_F;
    // Light fatigues no insignia
    class GVAR(O_A_officer_F) : O_A_officer_F
    {
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        hiddenSelectionsMaterials[] = {
            QPATHTOF(uniforms\data\officer_noinsignia.rvmat)};
    };

    // Luchnik fatigues
    class GVAR(Aegis_O_Soldier_03_base) : O_A_soldier_F
    {
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        displayName = "Luchnik Fatigues";
        descriptionShort = "Luchnik Fatigues";
        author = "Jamie of the A3 Aegis Team";
        uniformClass = QGVAR(U_Aegis_O_Soldier_03_base);
        model = QPATHTOF(Uniforms\Aegis_O_Soldier_03.p3d);
        hiddenSelections[] = {
            "camo",
            "camo1",
            "camo2"
        };
        hiddenSelectionsTextures[] = {
            QPATHTOF(Uniforms\Data\clothing2_rutaiga_CO.paa),
            QPATHTOF(Uniforms\Data\TacGloves_grn_CO.paa),
            "\A3\Characters_F\OPFOR\Data\clothing_co.paa"};
    };
    class GVAR(Aegis_O_Soldier_04_base) : GVAR(Aegis_O_Soldier_03_base)
    {
        displayName = "Luchnik Fatigues (Rolled-up)";
        descriptionShort = "Luchnik Fatigues";
        uniformClass = QGVAR(U_Aegis_O_Soldier_04_base);
        model = QPATHTOF(Uniforms\Aegis_O_Soldier_04.p3d);
    };


    // Obr 88 fatigues
    class GVAR(jam_soldier_obr88) : O_A_soldier_F
    {
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        displayName = "Obr. 88 Fatigues";
        descriptionShort = "Obr. 88 Fatigues";
        author = "Jamie";
        uniformClass = QGVAR(jam_U_obr88_base);
        model = QPATHTOF(Uniforms\jam_obr88.p3d);
        hiddenSelections[] = {
            "camo",
            "camo1",
            "branch"
        };
        hiddenSelectionsTextures[] = {
            QPATHTOF(Uniforms\Data\jam_obr88_jacket_khk_CO.paa),
            QPATHTOF(Uniforms\Data\jam_U_obr88_pants_khk_CO.paa)
        };
    };
    class GVAR(jam_soldier_obr88_rolled) : GVAR(jam_soldier_obr88)
    {
        displayName = "Obr. 88 Fatigues (Rolled-up)";
        descriptionShort = "M88 Fatigues";
        uniformClass = QGVAR(jam_obr88_rolled_base);
        model = QPATHTOF(Uniforms\jam_obr88_rolled.p3d);
    };
    class GVAR(jam_soldier_obr88_tshirt) : GVAR(jam_soldier_obr88)
    {
        displayName = "Obr. 88 Fatigues (T-Shirt)";
        descriptionShort = "M88 Fatigues";
        uniformClass = QGVAR(jam_U_obr88_tshirt);
        hiddenSelections[] = {
            "camo",
            "camo1"
        };
        hiddenSelectionsTextures[] = {
            QPATHTOF(Uniforms\Data\jam_telnyashka_01_blue_CO.paa),
            QPATHTOF(Uniforms\Data\jam_U_obr88_pants_khk_CO.paa)
        };
        model = QPATHTOF(Uniforms\jam_obr88_telnyashka_01.p3d);
    };

    // KZS suit
    class GVAR(jam_soldier_KZS_up) : O_A_soldier_F
    {
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        displayName = "KZS Suit (Hood up)";
        descriptionShort = "KZS Suit (Hood up)";
        author = "Jamie";
        uniformClass = QGVAR(jam_U_KZS_up_base);
        model = QPATHTOF(Uniforms\jam_suit_kzs_up.p3d);
        hiddenSelections[] = {
            "camo"
        };
        hiddenSelectionsTextures[] = {
            QPATHTOF(Uniforms\Data\jam_suit_kzs_spets_CO.paa),
        };
    };
    class GVAR(jam_soldier_KZS_down) : GVAR(jam_soldier_KZS_up)
    {
        displayName = "KZS Suit (Hood down)";
        descriptionShort = "KZS Suit (Hood down)";
        uniformClass = QGVAR(jam_U_KZS_down_base);
        model = QPATHTOF(Uniforms\jam_suit_kzs_down.p3d);
    };

    // Patrol backpack
    class B_Bergen_Base_F;
    class GVAR(B_Patrol_Base_F): B_Bergen_Base_F
    {
        scope = 0;
        scopeCurator = 0;
        scopeArsenal = 0;
        hiddenSelections[] = {
            "camo"};
        hiddenSelectionsMaterials[] = {"\A3\Supplies_F_Orange\Bags\Data\UAV_backpack.rvmat"};
        hiddenSelectionsTextures[] = {"\A3\Supplies_F_Orange\Bags\Data\UAV_06_backpack_NATO_co.paa"};
        model = "\A3\Drones_F\Weapons_F_Gamma\Ammoboxes\Bags\UAV_backpack_F.p3d";
    };
};
