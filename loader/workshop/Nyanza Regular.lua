local l_pui_0 = require("neverlose/pui");
local l_base64_0 = require("neverlose/base64");
local l_clipboard_0 = require("neverlose/clipboard");
local l_ffi_0 = require("ffi");
local v4 = nil;
v4 = require("neverlose/lagrecord");
v4 = v4 ^ v4.SIGNED;
local _ = require("neverlose/drag_system");
local _ = require("neverlose/wapi");
l_pui_0.colors.warn = color("#BABD5B");
cvar.sv_outofammo_indicator:int(1);
v4.set_update_callback(function(v7)
    if v7 == entity.get_local_player() then
        return true;
    else
        return;
    end;
end);
local v8 = {};
local v9 = {
    rage = {
        main = {
            dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"), 
            dt_lag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"), 
            hs_lag = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"), 
            hs = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots")
        }
    }, 
    antiaim = {
        angles = {
            pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"), 
            extract_yaw = {
                yaw = ui.find("Aimbot", "Anti Aim", "Angles", "yaw"), 
                offset = ui.find("Aimbot", "Anti Aim", "Angles", "yaw", "Offset"), 
                base = ui.find("Aimbot", "Anti Aim", "Angles", "yaw", "Base"), 
                snap = ui.find("Aimbot", "Anti Aim", "Angles", "yaw", "Hidden"), 
                avoid_backstab = ui.find("Aimbot", "Anti Aim", "Angles", "yaw", "Avoid Backstab")
            }, 
            extract_modifier = {
                mode = ui.find("Aimbot", "Anti Aim", "Angles", "yaw Modifier"), 
                offset = ui.find("Aimbot", "Anti Aim", "Angles", "yaw Modifier", "Offset")
            }, 
            extract_desync = {
                switch = ui.find("Aimbot", "Anti Aim", "Angles", "Body yaw"), 
                left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body yaw", "left Limit"), 
                right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body yaw", "right Limit"), 
                tweaks = ui.find("Aimbot", "Anti Aim", "Angles", "Body yaw", "Options"), 
                inverter = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"), 
                freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding")
            }, 
            extract_freestanding = {
                switch = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"), 
                disable_jitter = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable yaw Modifiers"), 
                body = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding")
            }
        }, 
        misc = {
            fake_duck = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"), 
            slow_walk = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"), 
            slidewalk_directory = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement")
        }
    }, 
    visuals = {
        world = {
            main = {
                zoom_scope = ui.find("Visuals", "World", "Main", "Override Zoom"), 
                scope_overlay = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay")
            }
        }
    }, 
    misc = {
        main = {
            other = {
                ping_spike = ui.find("Miscellaneous", "Main", "Other", "Fake Latency")
            }
        }
    }
};
local v10 = {
    home = {
        about = l_pui_0.create("\v\239\138\189", " ", 1), 
        presets = l_pui_0.create("\v\239\138\189", "Presets", 2), 
        discord = l_pui_0.create("\v\239\138\189", ""), 
        watermark = l_pui_0.create("\v\239\138\189", "Watermark"), 
        products = l_pui_0.create("\v\239\138\189", "Our Products")
    }, 
    antiaim = {
        circumstances = l_pui_0.create("\v\239\138\163", " ", 1), 
        builder = l_pui_0.create("\v\239\138\163", "Builder", 2), 
        extra = l_pui_0.create("\v\239\138\163", ""), 
        snap_builder = l_pui_0.create("\v\239\138\163", "Snap Builder")
    }, 
    other = {
        player_animations = l_pui_0.create("\v\239\139\155", "Player Animations", 1), 
        movement = l_pui_0.create("\v\239\139\155", "Movement", 2), 
        aimbot = l_pui_0.create("\v\239\139\155", "Aimbot"), 
        visuals = l_pui_0.create("\v\239\139\155", "Visuals"), 
        other_visuals = l_pui_0.create("\v\239\139\155", ""), 
        other = l_pui_0.create("\v\239\139\155", "Other")
    }
};
local v11 = {
    states = {
        [1] = "\v\239\134\131     \rStanding", 
        [2] = "\v\239\156\140    \rRunning", 
        [3] = "\v\239\149\148     \rSlowing", 
        [4] = "\v\239\134\147   \rCrouching", 
        [5] = "\v\238\139\142    \rSneaking", 
        [6] = "\v\238\149\134    \rAir", 
        [7] = "\v\238\149\135  \rAir Crouching", 
        [8] = "\v\238\147\129   \rFreestanding"
    }, 
    home = {}, 
    antiaim = {}, 
    other = {}
};
local v12 = nil;
v11.home.about = v10.home.about:label("\a[warn]\239\129\177   \rThe script is a work in progress and some features may not work as intended.");
v11.home.about_list = v10.home.about:list("", "\v\239\128\135       \rAbout");
v11.home.preset_input = v10.home.presets:input("\v\239\149\179  \rName:", "New Config!");
v11.home.preset_list = v10.home.presets:list("", {});
local v13 = {
    [1] = {
        index = "create", 
        name = "\v\239\131\170  \aDEFAULTCreate"
    }, 
    [2] = {
        index = "save", 
        name = "\a4CAF50FF\239\131\135  \aDEFAULTSave"
    }, 
    [3] = {
        index = "delete", 
        name = "      \aF44336FF\239\139\173      "
    }, 
    [4] = {
        index = "import", 
        name = "\aB0BEC5FF\239\149\175  \aDEFAULTImport"
    }, 
    [5] = {
        index = "export", 
        name = "\aB0BEC5FF\239\149\174  \aDEFAULTExport"
    }, 
    [6] = {
        index = "load", 
        preset_do = false, 
        name = "                                      Load                                       "
    }
};
for _, v15 in ipairs(v13) do
    v15.preset_do = v15.preset_do ~= false;
    v11.home[v15.index] = v10.home.presets:button(v15.name, nil, v15.preset_do);
end;
v11.home.report = v10.home.discord:label("\239\134\136  Report Bugs");
v11.home.discord = v10.home.discord:button("\v\239\142\146 \rDiscord Server", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/BfV7xXxFNS");
end, true);
v11.home.load_line = v10.home.discord:slider("\238\132\186  Versions", 1, 33, 1, nil, function(v16)
    local v17 = {};
    for v18 = 1, 33 do
        if v18 <= 23 then
            v17[v18] = string.format("V%03d", v18);
        else
            v17[v18] = string.format("V%03d", v18);
        end;
    end;
    return v17[v16];
end);
v11.home.watermark_base = v10.home.watermark:label("\v\238\134\149  \rOptions");
local v19 = v11.home.watermark_base:create();
local v20 = render.screen_size();
v11.home.watermark_accent = v19:color_picker("Global Accent", color(255, 255, 255, 255));
v11.home.watermark_position = v19:slider("Position", 1, 2, 1, nil, function(v21)
    return v21 == 1 and "Script" or "Custom";
end):depend({
    [1] = nil, 
    [2] = 50, 
    [1] = v11.home.load_line
});
v11.home.watermark_input = v19:input("", "NYANZA.MEOW");
v11.home.watermark_font = v19:slider("Font", 1, 4, 1, nil, function(v22)
    if v22 == 1 then
        return "Default";
    elseif v22 == 2 then
        return "Pixel";
    elseif v22 == 3 then
        return "Console";
    elseif v22 == 4 then
        return "Bold";
    else
        return nil;
    end;
end);
v11.home.watermark_gradient = v19:slider("Gradient", 0, 1, 0, nil, function(v23)
    return v23 == 0 and "Off" or "On";
end);
v11.home.watermark_gradient_rainbow = v19:slider("\a[warn]~  \rRainbow", 0, 1, 0, nil, function(v24)
    return v24 == 0 and "Off" or v24 == 1 and "On" or nil;
end):depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v11.home.watermark_gradient
});
v11.home.watermark_gradient_hue = v19:slider("\a[warn]~  \rHue", 0, 9, 0, nil, function(v25)
    return ({
        [1] = "Red", 
        [2] = "Orange", 
        [3] = "Salad", 
        [4] = "Green", 
        [5] = "Cyan", 
        [6] = "Turquoise", 
        [7] = "Blue", 
        [8] = "Indigo", 
        [9] = "Purple", 
        [10] = "Pink"
    })[v25 + 1];
end):depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v11.home.watermark_gradient
}, {
    [1] = nil, 
    [2] = 0, 
    [1] = v11.home.watermark_gradient_rainbow
});
v11.home.watermark_gradient_saturation = v19:slider("\a[warn]~  \rSaturation", 0, 10, 5):depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v11.home.watermark_gradient
});
v11.home.watermark_gradient_speed = v19:slider("\a[warn]~  \rSpeed", 1, 10, 2, nil, "x"):depend({
    [1] = nil, 
    [2] = 1, 
    [1] = v11.home.watermark_gradient
});
v11.home.config_text = v10.home.products:label("Configs");
v11.home.config_button = v10.home.products:button("Rxdxyxz", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=tDOIP4");
end, true);
v11.home.scripts_text = v10.home.products:label("Scripts");
v11.home.scripts_nyanza = v10.home.products:button("Nyanza", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=s9V6D3");
end, true);
v11.home.scripts_nyanza_beta = v10.home.products:button("Nyanza Beta", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://en.neverlose.cc/market/item?id=nmPxrV");
end, true);
v11.home.project_text_bool = v10.home.products:button("                                    2024 - ?                                    ", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("");
end, true);
v13 = nil;
v11.antiaim.manual_yaw = v10.antiaim.extra:combo("\v\239\129\185  \rManual Yaw", {
    [1] = "Disabled", 
    [2] = "Left", 
    [3] = "Right", 
    [4] = "Forward"
});
v19 = v11.antiaim.manual_yaw:create();
v11.antiaim.block_jitter = v19:switch("\vBlock jitter", true);
v11.antiaim.safe_head_height = v10.antiaim.extra:slider("\v\238\141\186  \rSafe Head", 0, 35, 0, nil, function(v26)
    return v26 == 0 and "Off" or v26 .. "h";
end);
v11.antiaim.safe_head_height:tooltip("\vIf the local player is in air, above the enemy and hittable, function fired to make the head hitbox behind chest.");
v11.antiaim.circumstances = v10.antiaim.circumstances:list("\v\239\131\128  \aDEFAULTSelect the state you want to configure.", v11.states, 7);
v19 = v11.antiaim.circumstances:create();
v11.antiaim.freestanding_bool = v10.antiaim.builder:slider("\v\238\147\129   \rState", 0, 1, 0, nil, function(v27)
    return v27 == 0 and "Off" or "On";
end):depend({
    [1] = nil, 
    [2] = 8, 
    [1] = v11.antiaim.circumstances
});
v11.antiaim.force_break_lagcomp = v10.antiaim.snap_builder:selectable("\a[warn]~  \rForce Break LC", v11.states);
v11.antiaim.force_break_lagcomp:tooltip("\vAttempts to invalidate your backtrack records;\n\nProviding invulnerability against skeet, as skeet lacks a defensive fix.");
for v28, v29 in next, v11.states do
    v11.antiaim[v29] = {};
    local l_builder_0 = v10.antiaim.builder;
    local l_circumstances_0 = v11.antiaim.circumstances;
    v11.antiaim[v29].yaw = l_builder_0:slider("\v- \rYaw", 0, 1, 1, nil, function(v32)
        return v32 == 0 and "Off" or "Backward";
    end):depend({
        [1] = l_circumstances_0, 
        [2] = v28
    });
    v11.antiaim[v29].yaw:tooltip("\vDefault neverlose function.");
    v11.antiaim[v29].yaw_mode = l_builder_0:slider("\v\239\151\189  \rMode", 1, 2, 1, nil, function(v33)
        return v33 == 1 and "1-Way" or "2-Way";
    end):depend({
        [1] = l_circumstances_0, 
        [2] = v28
    }, {
        [1] = nil, 
        [2] = 1, 
        [1] = v11.antiaim[v29].yaw
    });
    v11.antiaim[v29].yaw_mode:tooltip("\vDefault neverlose function.");
    local v34 = v11.antiaim[v29].yaw_mode:create();
    v11.antiaim[v29].yaw_offset = l_builder_0:slider("\v- \rOffset", -180, 180, 0, nil, "\194\176"):depend({
        [1] = l_circumstances_0, 
        [2] = v28
    }, {
        [1] = nil, 
        [2] = 1, 
        [1] = v11.antiaim[v29].yaw
    }, {
        [1] = nil, 
        [2] = 1, 
        [1] = v11.antiaim[v29].yaw_mode
    });
    v11.antiaim[v29].yaw_left_offset = v34:slider("\v\239\132\128  \rLeft", -180, 180, -30, nil, "\194\176"):depend({
        [1] = l_circumstances_0, 
        [2] = v28
    }, {
        [1] = nil, 
        [2] = 1, 
        [1] = v11.antiaim[v29].yaw
    }, {
        [1] = nil, 
        [2] = 2, 
        [1] = v11.antiaim[v29].yaw_mode
    });
    v11.antiaim[v29].yaw_right_offset = v34:slider("\v\239\132\129  \rRight", -180, 180, 40, nil, "\194\176"):depend({
        [1] = l_circumstances_0, 
        [2] = v28
    }, {
        [1] = nil, 
        [2] = 1, 
        [1] = v11.antiaim[v29].yaw
    }, {
        [1] = nil, 
        [2] = 2, 
        [1] = v11.antiaim[v29].yaw_mode
    });
    v11.antiaim[v29].yaw_delay_bool = v34:slider("\a[warn]\238\138\156  \rDelay", 0, 1, 0, nil, function(v35)
        return v35 == 0 and "Off" or "On";
    end):depend({
        [1] = l_circumstances_0, 
        [2] = v28
    }, {
        [1] = nil, 
        [2] = 1, 
        [1] = v11.antiaim[v29].yaw
    }, {
        [1] = nil, 
        [2] = 2, 
        [1] = v11.antiaim[v29].yaw_mode
    });
    v11.antiaim[v29].yaw_delay_method = v34:slider("\v\239\139\185  \rMethod", 1, 3, 1, nil, function(v36)
        if v36 == 1 then
            return "Default";
        elseif v36 == 2 then
            return "Random";
        else
            return "Custom";
        end;
    end):depend({
        [1] = l_circumstances_0, 
        [2] = v28
    }, {
        [1] = nil, 
        [2] = 1, 
        [1] = v11.antiaim[v29].yaw
    }, {
        [1] = nil, 
        [2] = 2, 
        [1] = v11.antiaim[v29].yaw_mode
    }, {
        [1] = nil, 
        [2] = 1, 
        [1] = v11.antiaim[v29].yaw_delay_bool
    });
    v11.antiaim[v29].delay_numbers = v34:slider("\v\238\144\149  \rSliders", 2, 6, 4, nil):depend({
        [1] = l_circumstances_0, 
        [2] = v28
    }, {
        [1] = nil, 
        [2] = 1, 
        [1] = v11.antiaim[v29].yaw
    }, {
        [1] = nil, 
        [2] = 2, 
        [1] = v11.antiaim[v29].yaw_mode
    }, {
        [1] = nil, 
        [2] = 1, 
        [1] = v11.antiaim[v29].yaw_delay_bool
    }, {
        [1] = nil, 
        [2] = 3, 
        [1] = v11.antiaim[v29].yaw_delay_method
    });
    do
        local l_v29_0 = v29;
        for v38 = 1, 6 do
            local v39 = v34:slider("\v- \r[" .. v38 .. "]", 1, 20, 2, nil, "t");
            do
                local l_v38_0 = v38;
                v39:depend({
                    [1] = v11.antiaim[l_v29_0].delay_numbers, 
                    [2] = function()
                        -- upvalues: l_v38_0 (ref), v11 (ref), l_v29_0 (ref)
                        return l_v38_0 <= v11.antiaim[l_v29_0].delay_numbers:get();
                    end
                }, {
                    [1] = nil, 
                    [2] = 1, 
                    [1] = v11.antiaim[l_v29_0].yaw
                }, {
                    [1] = nil, 
                    [2] = 2, 
                    [1] = v11.antiaim[l_v29_0].yaw_mode
                }, {
                    [1] = nil, 
                    [2] = 1, 
                    [1] = v11.antiaim[l_v29_0].yaw_delay_bool
                }, {
                    [1] = nil, 
                    [2] = 3, 
                    [1] = v11.antiaim[l_v29_0].yaw_delay_method
                });
                v11.antiaim[l_v29_0]["delay_" .. l_v38_0] = v39;
            end;
        end;
        v11.antiaim[l_v29_0].modifier_reset = v34:button("\aF44336FF\239\128\145 Reset", function()
            -- upvalues: v11 (ref), l_v29_0 (ref)
            for v41 = 1, 6 do
                v11.antiaim[l_v29_0]["delay_" .. v41]:set(2);
            end;
        end, true):depend({
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].yaw
        }, {
            [1] = nil, 
            [2] = 2, 
            [1] = v11.antiaim[l_v29_0].yaw_mode
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].yaw_delay_bool
        }, {
            [1] = nil, 
            [2] = 3, 
            [1] = v11.antiaim[l_v29_0].yaw_delay_method
        });
        v11.antiaim[l_v29_0].yaw_delay_min = v34:slider("\a[warn]\239\128\151  \rMin. Timing", 1, 20, 1, nil, "t"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].yaw
        }, {
            [1] = nil, 
            [2] = 2, 
            [1] = v11.antiaim[l_v29_0].yaw_mode
        }, {
            [1] = nil, 
            [2] = 2, 
            [1] = v11.antiaim[l_v29_0].yaw_delay_method
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].yaw_delay_bool
        });
        v11.antiaim[l_v29_0].yaw_delay_max = v34:slider("\a[warn]\239\128\151  \rMax. Timing", 1, 20, 10, nil, "t"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].yaw
        }, {
            [1] = nil, 
            [2] = 2, 
            [1] = v11.antiaim[l_v29_0].yaw_mode
        }, {
            [1] = nil, 
            [2] = 2, 
            [1] = v11.antiaim[l_v29_0].yaw_delay_method
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].yaw_delay_bool
        });
        v11.antiaim[l_v29_0].yaw_delay_multiplier = v34:slider("\a[warn]\239\128\151  \rTiming", 2, 20, 2, nil, "t"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].yaw
        }, {
            [1] = nil, 
            [2] = 2, 
            [1] = v11.antiaim[l_v29_0].yaw_mode
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].yaw_delay_method
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].yaw_delay_bool
        });
        v11.antiaim[l_v29_0].modifier = l_builder_0:slider("\v\239\151\189  \rJitter", 1, 7, 1, nil, function(v42)
            return ({
                [1] = "Off", 
                [2] = "Offset", 
                [3] = "Center", 
                [4] = "Random", 
                [5] = "Spin", 
                [6] = "3-Way", 
                [7] = "5-Way"
            })[v42];
        end):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].yaw
        });
        v11.antiaim[l_v29_0].modifier:tooltip("\vDefault neverlose function.");
        v34 = v11.antiaim[l_v29_0].modifier:create();
        v11.antiaim[l_v29_0].modifier_jitter_offset = v34:slider("\v\239\132\132 \239\132\133  \rOffset", -180, 180, 0, nil, "\194\176");
        v11.antiaim[l_v29_0].modifier_random_jitter = v34:switch("Randomize"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 2, 
            [3] = 7, 
            [1] = v11.antiaim[l_v29_0].modifier
        });
        v11.antiaim[l_v29_0].modifier_method = v34:slider("\v\239\139\185  \rMethod", 1, 2, 1, nil, function(v43)
            return v43 == 1 and "Default" or "Custom";
        end):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].modifier_random_jitter
        }, {
            [1] = nil, 
            [2] = 2, 
            [3] = 7, 
            [1] = v11.antiaim[l_v29_0].modifier
        });
        v11.antiaim[l_v29_0].modifier_minimum_offset = v34:slider("\v- \rMinimum", -180, 180, 0, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].modifier_random_jitter
        }, {
            [1] = nil, 
            [2] = 2, 
            [3] = 7, 
            [1] = v11.antiaim[l_v29_0].modifier
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].modifier_method
        });
        v11.antiaim[l_v29_0].modifier_maximum_offset = v34:slider("\v- \rMaximum", -180, 180, 0, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].modifier_random_jitter
        }, {
            [1] = nil, 
            [2] = 2, 
            [3] = 7, 
            [1] = v11.antiaim[l_v29_0].modifier
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].modifier_method
        });
        v11.antiaim[l_v29_0].modifier_numbers = v34:slider("\v\238\144\149  \rSliders", 2, 6, 4, nil):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].modifier_random_jitter
        }, {
            [1] = nil, 
            [2] = 2, 
            [3] = 7, 
            [1] = v11.antiaim[l_v29_0].modifier
        }, {
            [1] = nil, 
            [2] = 2, 
            [1] = v11.antiaim[l_v29_0].modifier_method
        });
        for v44 = 1, 6 do
            local v45 = v34:slider("\v- \r[" .. v44 .. "]", -180, 180, 0, nil, "\194\176");
            do
                local l_v44_0 = v44;
                v45:depend({
                    [1] = v11.antiaim[l_v29_0].modifier_numbers, 
                    [2] = function()
                        -- upvalues: l_v44_0 (ref), v11 (ref), l_v29_0 (ref)
                        return l_v44_0 <= v11.antiaim[l_v29_0].modifier_numbers:get();
                    end
                }, {
                    [1] = nil, 
                    [2] = true, 
                    [1] = v11.antiaim[l_v29_0].modifier_random_jitter
                }, {
                    [1] = nil, 
                    [2] = 2, 
                    [3] = 7, 
                    [1] = v11.antiaim[l_v29_0].modifier
                }, {
                    [1] = nil, 
                    [2] = 2, 
                    [1] = v11.antiaim[l_v29_0].modifier_method
                });
                v11.antiaim[l_v29_0]["modifier_" .. l_v44_0] = v45;
            end;
        end;
        v11.antiaim[l_v29_0].modifier_reset = v34:button("\aF44336FF\239\128\145 Reset", function()
            -- upvalues: v11 (ref), l_v29_0 (ref)
            for v47 = 1, 6 do
                v11.antiaim[l_v29_0]["modifier_" .. v47]:set(0);
            end;
        end, true):depend({
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].modifier_random_jitter
        }, {
            [1] = nil, 
            [2] = 2, 
            [3] = 7, 
            [1] = v11.antiaim[l_v29_0].modifier
        }, {
            [1] = nil, 
            [2] = 2, 
            [1] = v11.antiaim[l_v29_0].modifier_method
        });
        v11.antiaim[l_v29_0].modifier_jitter_offset:depend({
            [1] = nil, 
            [2] = false, 
            [1] = v11.antiaim[l_v29_0].modifier_random_jitter
        });
        v11.antiaim[l_v29_0].desync = l_builder_0:slider("\v\239\151\189  \rBody", 0, 1, 0, nil, function(v48)
            return v48 == 0 and "Off" or "On";
        end):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        });
        v11.antiaim[l_v29_0].desync:tooltip("\vDefault neverlose function.");
        v34 = v11.antiaim[l_v29_0].desync:create();
        v11.antiaim[l_v29_0].desync_inverter = v34:switch("Inverter"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].yaw_delay_multiplier
        });
        v11.antiaim[l_v29_0].desync_tweaks = l_builder_0:selectable("\v- \rOptions", "Avoid Overlap", "Jitter", "Randomize Jitter", "Anti Bruteforce"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        });
        v11.antiaim[l_v29_0].desync_tweaks:tooltip("\vDefault neverlose function.");
        v11.antiaim[l_v29_0].desync_mode = v34:slider("\v- \rMode", 1, 3, 1, nil, function(v49)
            return ({
                [1] = "Static", 
                [2] = "Ticks", 
                [3] = "Random"
            })[v49];
        end):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        });
        v11.antiaim[l_v29_0].desync_mode:tooltip("\vIf the value is not static, then interacts with desync by toggling it on and off depending on the set ticks or multiplier;\n\nCan be used in combination with the force break lc function.");
        v11.antiaim[l_v29_0].desync_delay = v34:slider("", 3, 16, 4, nil, "t"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 2, 
            [1] = v11.antiaim[l_v29_0].desync_mode
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        });
        v11.antiaim[l_v29_0].desync_multiplier = v34:slider("", 4, 16, 4, nil, "x"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 3, 
            [1] = v11.antiaim[l_v29_0].desync_mode
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        });
        v11.antiaim[l_v29_0].desync_freestanding = v34:slider("\v- \rFreestanding", 1, 3, 1, nil, function(v50)
            return ({
                [1] = "Disabled", 
                [2] = "Default", 
                [3] = "Reversed"
            })[v50];
        end):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        });
        v11.antiaim[l_v29_0].desync_freestanding:tooltip("\vDefault neverlose function.");
        v11.antiaim[l_v29_0].desync_limit_mode = v34:slider("\v- \rLimit Mode", 1, 4, 1, nil, function(v51)
            return ({
                [1] = "Static", 
                [2] = "Random", 
                [3] = "From/To", 
                [4] = "Distortion"
            })[v51];
        end):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        });
        v11.antiaim[l_v29_0].desync_min = v34:slider("\v- \rMinimum", 0, 60, 28, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 2, 
            [1] = v11.antiaim[l_v29_0].desync_limit_mode
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        });
        v11.antiaim[l_v29_0].desync_max = v34:slider("\v- \rMaximum", 0, 60, 58, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 2, 
            [1] = v11.antiaim[l_v29_0].desync_limit_mode
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        });
        v11.antiaim[l_v29_0].desync_from = v34:slider("\v- \rFrom", 0, 60, 28, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 3, 
            [1] = v11.antiaim[l_v29_0].desync_limit_mode
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        });
        v11.antiaim[l_v29_0].desync_to = v34:slider("\v- \rTo", 0, 60, 58, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 3, 
            [1] = v11.antiaim[l_v29_0].desync_limit_mode
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        });
        v11.antiaim[l_v29_0].desync_left = v34:slider("\v- \rLeft", 0, 60, 58, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync_limit_mode
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        });
        v11.antiaim[l_v29_0].desync_right = v34:slider("\v- \rRight", 0, 60, 58, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync_limit_mode
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        });
        v11.antiaim[l_v29_0].desync_range_from = v34:slider("\v- \rRange", 1, 60, 58, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 4, 
            [1] = v11.antiaim[l_v29_0].desync_limit_mode
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        });
        v11.antiaim[l_v29_0].desync_speed_to = v34:slider("\v- \rSpeed", 1, 10, 5, nil, "t"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 4, 
            [1] = v11.antiaim[l_v29_0].desync_limit_mode
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].desync
        });
        v11.antiaim[l_v29_0].snap = v10.antiaim.snap_builder:switch("\v\239\161\190  \rSnap \vAnti Aim"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        });
        v34 = v11.antiaim[l_v29_0].snap:create();
        v11.antiaim[l_v29_0].snap_pitch = v10.antiaim.snap_builder:combo("\v\239\161\150  \rPitch", {
            [1] = "Down", 
            [2] = "Up", 
            [3] = "Semi-Down", 
            [4] = "Semi-Up", 
            [5] = "Spectrum", 
            [6] = "Random", 
            [7] = "Zero", 
            [8] = "Offset", 
            [9] = "Flick"
        }):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        });
        local v52 = v11.antiaim[l_v29_0].snap_pitch:create();
        v11.antiaim[l_v29_0].snap_pitch_from = v52:slider("\v- \rFlick From", -89, 89, -89, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        }, {
            [1] = nil, 
            [2] = "Flick", 
            [1] = v11.antiaim[l_v29_0].snap_pitch
        });
        v11.antiaim[l_v29_0].snap_pitch_to = v52:slider("\v- \rFlick To", -89, 89, 89, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        }, {
            [1] = nil, 
            [2] = "Flick", 
            [1] = v11.antiaim[l_v29_0].snap_pitch
        });
        v11.antiaim[l_v29_0].snap_pitch_offset = v10.antiaim.snap_builder:slider("\v- \rOffset", -89, 89, 0, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        }, {
            [1] = nil, 
            [2] = "Offset", 
            [1] = v11.antiaim[l_v29_0].snap_pitch
        });
        v11.antiaim[l_v29_0].snap_random = v52:slider("\v- \rFrom", -89, 89, -89, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        }, {
            [1] = nil, 
            [2] = "Random", 
            [1] = v11.antiaim[l_v29_0].snap_pitch
        });
        v11.antiaim[l_v29_0].snap_random2 = v52:slider("\v- \rTo", -89, 89, 89, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        }, {
            [1] = nil, 
            [2] = "Random", 
            [1] = v11.antiaim[l_v29_0].snap_pitch
        });
        v11.antiaim[l_v29_0].snap_yaw = v10.antiaim.snap_builder:combo("\v\239\161\191  \rYaw", {
            [1] = "Sideways", 
            [2] = "Spin", 
            [3] = "Spectrum", 
            [4] = "Opposite", 
            [5] = "Random", 
            [6] = "Offset", 
            [7] = "Distortion", 
            [8] = "L&R"
        }):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        });
        local v53 = v11.antiaim[l_v29_0].snap_yaw:create();
        v11.antiaim[l_v29_0].snap_offset = v10.antiaim.snap_builder:slider("\v- \rOffset", -180, 180, 0, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        }, {
            [1] = nil, 
            [2] = "Offset", 
            [1] = v11.antiaim[l_v29_0].snap_yaw
        });
        v11.antiaim[l_v29_0].snap_left_offset = v53:slider("\v- \rLeft", -180, 180, 0, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        }, {
            [1] = nil, 
            [2] = "L&R", 
            [1] = v11.antiaim[l_v29_0].snap_yaw
        });
        v11.antiaim[l_v29_0].snap_right_offset = v53:slider("\v- \rRight", -180, 180, 0, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        }, {
            [1] = nil, 
            [2] = "L&R", 
            [1] = v11.antiaim[l_v29_0].snap_yaw
        });
        v11.antiaim[l_v29_0].snap_distortion_range = v53:slider("\v- \rRange", 1, 180, 180, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        }, {
            [1] = nil, 
            [2] = "Distortion", 
            [1] = v11.antiaim[l_v29_0].snap_yaw
        });
        v11.antiaim[l_v29_0].snap_distortion_speed = v53:slider("\v- \rSpeed", 1, 10, 5, nil, "t"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        }, {
            [1] = nil, 
            [2] = "Distortion", 
            [1] = v11.antiaim[l_v29_0].snap_yaw
        });
        v11.antiaim[l_v29_0].snap_spin_range = v53:slider("\v- \rRange", 1, 180, 180, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        }, {
            [1] = nil, 
            [2] = "Spin", 
            [1] = v11.antiaim[l_v29_0].snap_yaw
        });
        v11.antiaim[l_v29_0].snap_spin_speed = v53:slider("\v- \rSpeed", 1, 10, 5, nil, "t"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        }, {
            [1] = nil, 
            [2] = "Spin", 
            [1] = v11.antiaim[l_v29_0].snap_yaw
        });
        v11.antiaim[l_v29_0].snap_yaw_random = v53:slider("\v- \rFrom", -180, 180, -180, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        }, {
            [1] = nil, 
            [2] = "Random", 
            [1] = v11.antiaim[l_v29_0].snap_yaw
        });
        v11.antiaim[l_v29_0].snap_yaw_random2 = v53:slider("\v- \rTo", -180, 180, 180, nil, "\194\176"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        }, {
            [1] = nil, 
            [2] = "Random", 
            [1] = v11.antiaim[l_v29_0].snap_yaw
        });
        v11.antiaim[l_v29_0].snap_disablers = v34:selectable("\v\239\151\190  \rDisablers", {
            [1] = "Manual Yaw"
        }):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        });
        v11.antiaim[l_v29_0].snap_disablers:tooltip("\vConditional");
        v11.antiaim[l_v29_0].snap_only_when_hittable = v34:switch("\vHittable \a[warn]~", nil):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].snap
        });
        v11.antiaim[l_v29_0].snap_only_when_hittable:tooltip("\vAllows snap anti aim to work only when the local player is hittable;\n\nConditional.");
        v11.antiaim[l_v29_0].neverlose_mode = v10.antiaim.snap_builder:slider("\a[warn]Tickbase", 0, 1, 0, nil, function(v54)
            return v54 == 0 and "Neverlose" or "Nyanza";
        end):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = v11.antiaim.force_break_lagcomp, 
            [2] = l_v29_0
        });
        v11.antiaim[l_v29_0].random_choke = v11.antiaim[l_v29_0].neverlose_mode:create():switch("\v- \rRandom Choke", nil):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].neverlose_mode
        });
        v11.antiaim[l_v29_0].choke_method = v11.antiaim[l_v29_0].neverlose_mode:create():slider("\v\239\139\185  \rMethod", 1, 2, 1, nil, function(v55)
            return ({
                [1] = "Default", 
                [2] = "Custom"
            })[v55];
        end):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].neverlose_mode
        }, v11.antiaim[l_v29_0].random_choke);
        v11.antiaim[l_v29_0].choke_numbers = v11.antiaim[l_v29_0].neverlose_mode:create():slider("\v\238\144\149  \rSliders", 2, 6, 6, nil):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].random_choke
        }, {
            [1] = nil, 
            [2] = 2, 
            [1] = v11.antiaim[l_v29_0].choke_method
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].neverlose_mode
        });
        for v56 = 1, 6 do
            local v57 = v11.antiaim[l_v29_0].neverlose_mode:create():slider("\v- \r[" .. v56 .. "]", 1, 22, 16, nil, "t");
            do
                local l_v56_0 = v56;
                v57:depend({
                    [1] = v11.antiaim[l_v29_0].choke_numbers, 
                    [2] = function()
                        -- upvalues: l_v56_0 (ref), v11 (ref), l_v29_0 (ref)
                        return l_v56_0 <= v11.antiaim[l_v29_0].choke_numbers:get();
                    end
                }, {
                    [1] = nil, 
                    [2] = 1, 
                    [1] = v11.antiaim[l_v29_0].neverlose_mode
                }, {
                    [1] = nil, 
                    [2] = true, 
                    [1] = v11.antiaim[l_v29_0].random_choke
                }, {
                    [1] = nil, 
                    [2] = 2, 
                    [1] = v11.antiaim[l_v29_0].choke_method
                });
                v11.antiaim[l_v29_0]["tickbase_" .. l_v56_0] = v57;
            end;
        end;
        v11.antiaim[l_v29_0].modifier_reset = v11.antiaim[l_v29_0].neverlose_mode:create():button("\aF44336FF\239\128\145 Reset", function()
            -- upvalues: v11 (ref), l_v29_0 (ref)
            for v59 = 1, 6 do
                v11.antiaim[l_v29_0]["tickbase_" .. v59]:set(16);
            end;
        end, true):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].neverlose_mode
        }, {
            [1] = nil, 
            [2] = true, 
            [1] = v11.antiaim[l_v29_0].random_choke
        }, {
            [1] = nil, 
            [2] = 2, 
            [1] = v11.antiaim[l_v29_0].choke_method
        });
        v11.antiaim[l_v29_0].choke_slider = v11.antiaim[l_v29_0].neverlose_mode:create():slider("\v- \rChoke from \a[warn]~", 1, 22, 16, nil, "t"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].neverlose_mode
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].choke_method
        }, v11.antiaim[l_v29_0].random_choke);
        v11.antiaim[l_v29_0].choke_slider2 = v11.antiaim[l_v29_0].neverlose_mode:create():slider("\v- \rChoke to \a[warn]~", 1, 22, 16, nil, "t"):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].neverlose_mode
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].choke_method
        }, v11.antiaim[l_v29_0].random_choke);
        v11.antiaim[l_v29_0].random_choke:tooltip("\vChoking ticks by using \"Choke\" slider.");
        v11.antiaim[l_v29_0].ticks_to = v11.antiaim[l_v29_0].neverlose_mode:create():slider("\v- \rChoke", 2, 22, 16, nil, function(v60)
            return ({
                [1] = nil, 
                [2] = "Sharp", 
                [16] = "Default", 
                [22] = "Smooth"
            })[v60] or v60 .. "t";
        end):depend({
            [1] = l_circumstances_0, 
            [2] = v28
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.antiaim[l_v29_0].neverlose_mode
        }, {
            [1] = nil, 
            [2] = false, 
            [1] = v11.antiaim[l_v29_0].random_choke
        });
        v11.antiaim[l_v29_0].ticks_to:tooltip("\vPlease note that the neverlose value is set to 16;\n\nValues lower than 16 are considered experimental.");
    end;
end;
v11.antiaim.hs_mode = v10.antiaim.snap_builder:combo("\a[warn]\239\131\167  \rHide Shots", {
    [1] = "Favor Fire Rate", 
    [2] = "Favor Fake Lag", 
    [3] = "Break LC"
});
v11.antiaim.freestanding = v10.antiaim.builder:switch("\v\238\147\129  \rFreestanding");
v19 = v11.antiaim.freestanding:create();
v11.antiaim.freestand_modifiers = v19:slider("\v- \rOptions", 0, 3, 0, nil, function(v61)
    if v61 == 0 then
        return "Off";
    elseif v61 == 1 then
        return "Disable Jitter";
    elseif v61 == 2 then
        return "Body FS";
    elseif v61 == 3 then
        return "On";
    else
        return nil;
    end;
end);
v11.antiaim.freestand_disablers = v19:listable("\v\239\131\128  \rDisablers", {
    [1] = "\v\239\134\131     \rStanding", 
    [2] = "\v\239\156\140    \rRunning", 
    [3] = "\v\239\149\148     \rSlowing", 
    [4] = "\v\239\134\147   \rCrouching", 
    [5] = "\v\238\139\142    \rSneaking", 
    [6] = "\v\238\149\134    \rAir", 
    [7] = "\v\238\149\135  \rAir Crouching"
});
v11.antiaim.avoid_backstab = v10.antiaim.extra:switch("\v\239\155\181  \rAvoid Backstab");
v11.antiaim.avoid_backstab:tooltip("\vTurns the local player model to face the opponent with a knife to avoid being backstabbed.");
v11.antiaim.airlag = v10.antiaim.extra:switch("\v\239\156\174   \rAirlag");
v11.antiaim.airlag:tooltip("\vDepends on defensive ticks.");
v11.antiaim.fluctuate = v10.antiaim.extra:slider("\v\239\131\133   \rFluctuate Fakelag", 0, 2, 0, nil, function(v62)
    return ({
        [0] = "Off", 
        [1] = "On", 
        [2] = "R8"
    })[v62];
end);
v11.antiaim.tweaks = v10.antiaim.extra:slider("\v\239\128\147   \rState", 0, 3, 0, nil, function(v63)
    return ({
        [0] = "Off", 
        [1] = "Warmup", 
        [2] = "No Enemies", 
        [3] = "On"
    })[v63];
end);
v19 = v11.antiaim.tweaks:create();
v11.antiaim.disabler_pitch = v19:combo("Pitch", {
    [1] = "Disabled", 
    [2] = "Down"
}):depend({
    [1] = nil, 
    [2] = 1, 
    [3] = 3, 
    [1] = v11.antiaim.tweaks
});
v11.antiaim.disabler_yaw = v19:combo("Yaw", {
    [1] = "Spin", 
    [2] = "Distortion", 
    [3] = "L&R"
}):depend({
    [1] = nil, 
    [2] = 1, 
    [3] = 3, 
    [1] = v11.antiaim.tweaks
});
v11.antiaim.disabler_range = v19:slider("Range", 1, 180, 180, nil, "\194\176"):depend({
    [1] = nil, 
    [2] = 1, 
    [3] = 3, 
    [1] = v11.antiaim.tweaks
}, {
    [1] = nil, 
    [2] = "L&R", 
    [3] = true, 
    [1] = v11.antiaim.disabler_yaw
});
v11.antiaim.disabler_speed = v19:slider("Speed", 1, 10, 2, nil, "t"):depend({
    [1] = nil, 
    [2] = 1, 
    [3] = 3, 
    [1] = v11.antiaim.tweaks
}, {
    [1] = nil, 
    [2] = "L&R", 
    [3] = true, 
    [1] = v11.antiaim.disabler_yaw
});
v11.antiaim.disabler_left_offset = v19:slider("Left Offset", -180, 180, -30, nil, "\194\176"):depend({
    [1] = nil, 
    [2] = 1, 
    [3] = 3, 
    [1] = v11.antiaim.tweaks
}, {
    [1] = nil, 
    [2] = "L&R", 
    [1] = v11.antiaim.disabler_yaw
});
v11.antiaim.disabler_right_offset = v19:slider("Right Offset", -180, 180, 30, nil, "\194\176"):depend({
    [1] = nil, 
    [2] = 1, 
    [3] = 3, 
    [1] = v11.antiaim.tweaks
}, {
    [1] = nil, 
    [2] = "L&R", 
    [1] = v11.antiaim.disabler_yaw
});
v19 = nil;
v20 = v10.other.player_animations;
v11.other.player_animations_warn = v20:label("\a[warn]\239\129\177   \rWorks only on the clientside.");
v11.other.player_animations = v20:selectable("\v\239\151\189    \rAnimations", {
    [1] = "\238\142\177  Earthquake", 
    [2] = "\239\134\131    Leaning On Standing", 
    [3] = "\239\159\133   Skating On Groung"
});
v11.other.player_animations:tooltip("\v\"Earthquake\" Jittering out local player lean and fall animations. Depends on the \"Leaning\" and \"Falling\" sliders;\n\n\"Leaning On Standing\" Allow the local player to perform a leaning animation when standing.");
v11.other.player_animations_interpolating = v20:slider("\v\239\149\155  \rInterpolating", 0, 16, 0, nil, function(v64)
    if v64 == 0 then
        return "Default";
    elseif v64 == 8 then
        return "Medium";
    elseif v64 == 16 then
        return "Extreme";
    else
        return v64 .. "t";
    end;
end);
v11.other.player_animations_interpolating:tooltip("\vPorted from \"\vArc Project\v\";\n\nSmooths out local player animations in order to make them look nicer. It replicates some of the \vgamesense \vanimation fix logic.");
v11.other.player_animations_leaning = v20:slider("\v\239\134\131     \rLeaning", 0, 100, 0, 0.01, function(v65)
    if v65 == 0 then
        return "Neverlose";
    elseif v65 == 35 then
        return "Small";
    elseif v65 == 50 then
        return "Medium";
    elseif v65 == 75 then
        return "High";
    elseif v65 == 100 then
        return "Extreme";
    else
        return v65 .. "%";
    end;
end);
v11.other.player_animations_falling = v20:slider("\v\238\149\134    \rFalling", 0, 10, 0, 0.1, function(v66)
    if v66 == 0 then
        return "Default";
    elseif v66 == 5 then
        return "Force";
    elseif v66 == 10 then
        return "Maximum";
    else
        return v66 .. "x";
    end;
end);
v11.other.player_animations_walking = v20:slider("\v\239\149\148     \rWalking", 0, 2, 0, nil, function(v67)
    if v67 == 0 then
        return "Default";
    elseif v67 == 1 then
        return "Force";
    elseif v67 == 2 then
        return "Jitter";
    else
        return nil;
    end;
end):depend({
    [1] = nil, 
    [2] = 3, 
    [3] = true, 
    [1] = v11.other.player_animations
});
v11.other.no_fall_damage = v10.other.movement:switch("\v\238\149\135   \rNo Fall Damage", nil);
v11.other.no_fall_damage:tooltip("\vAllows to safely fall from heights without taking any damage, providing a gameplay advantage;\n\nBad movement can cause the function to fail, as the source game engine does not allow for accurate calculation of landing time.");
v11.other.fast_ladder = v10.other.movement:switch("\v\239\151\133    \rFast Ladder", nil);
v11.other.fast_ladder:tooltip("\vAbuses the ladder movement mechanic and makes you move a little faster.");
v11.other.log_events = v10.other.other:label("\v\238\145\178   \rLog Events");
local v68 = v11.other.log_events:create();
v11.other.log_color = v68:color_picker("Accent", color(255, 255, 255, 255));
v11.other.log_aimbot = v68:switch("Damage Dealt", nil);
v11.other.log_purchases = v68:switch("Purchases", nil);
v11.other.log_guide = v68:switch("Quick Tips for custom prefix", nil);
v11.other.log_prefix = v68:input("Prefix", "");
v11.other.unlock_fake_latency = v10.other.aimbot:switch("\v\239\163\157   \rUnlock Fake Latency", nil);
v11.other.unlock_fake_latency:tooltip("\vFake your ping to the server to shift your backtracking window;\n\nMaximum value for fake latency in neverlose is 100ms, this function extends it to 200ms;\n\nFun fact: if value is 200ms you can still backtrack up to 400ms.");
v11.other.teammate_aimbot = v10.other.aimbot:switch("\v\239\129\173    \rForce Teammate Aimbot", nil);
v11.other.teammate_aimbot:tooltip("\vForces the aimbot to shoot teammates, so you can ruin matches.");
v11.other.freezetimefd = v10.other.aimbot:switch("\v\239\155\152    \rFreezetime Fakeduck", nil);
v11.other.freezetimefd:tooltip("\vAllow you to fakeduck on freezetime, may be useful on de_bank.");
v11.other.aspect_ratio = v10.other.visuals:switch("\v\239\148\176  \rAspect Ratio", nil);
v68 = v11.other.aspect_ratio:create();
local v69 = render.screen_size();
v11.other.aspect_ratio_method = v68:slider("\v\239\139\185  \rMethod", 1, 3, 1, nil, function(v70)
    if v70 == 1 then
        return "Default";
    elseif v70 == 2 then
        return "Custom #1";
    elseif v70 == 3 then
        return "Custom #2";
    else
        return nil;
    end;
end):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v11.other.aspect_ratio
});
v11.other.aspect_ratio_slider = v68:slider("\v\239\129\135  \rAspect", 50, 300, 177, 0.01, function(v71)
    if v71 == 177 then
        return "16:9";
    elseif v71 == 161 then
        return "16:10";
    elseif v71 == 150 then
        return "3:2";
    elseif v71 == 133 then
        return "4:3";
    elseif v71 == 125 then
        return "5:4";
    else
        return nil;
    end;
end):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v11.other.aspect_ratio
}, {
    [1] = nil, 
    [2] = 1, 
    [1] = v11.other.aspect_ratio_method
});
v11.other.aspect_ratio_list = v68:combo("", {
    [1] = "16:9 (1920x1080)", 
    [2] = "16:10 (1728x1080)", 
    [3] = "3:2 (1620x1080)", 
    [4] = "4:3 (1024x768)", 
    [5] = "5:4 (1280x1024)"
}):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v11.other.aspect_ratio
}, {
    [1] = nil, 
    [2] = 2, 
    [1] = v11.other.aspect_ratio_method
});
v11.other.aspect_ratio_width = v68:slider("\v\239\140\183  \rWidth", 1, v69.x, v69.x, 1, "w"):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v11.other.aspect_ratio
}, {
    [1] = nil, 
    [2] = 3, 
    [1] = v11.other.aspect_ratio_method
});
v11.other.aspect_ratio_height = v68:slider(" \v\239\140\184   \rHeight", 1, v69.y, v69.y, 1, "h"):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v11.other.aspect_ratio
}, {
    [1] = nil, 
    [2] = 3, 
    [1] = v11.other.aspect_ratio_method
});
local v72 = {
    [161] = "16:10", 
    [177] = "16:9", 
    [125] = "5:4", 
    [150] = "3:2", 
    [133] = "4:3"
};
local v73 = 0;
for v74, v75 in pairs(v72) do
    v73 = v73 + 1;
    do
        local l_v74_0 = v74;
        local _ = v11.other.aspect_ratio:create():button(v75, function()
            -- upvalues: v11 (ref), l_v74_0 (ref)
            v11.other.aspect_ratio_slider:set(l_v74_0);
        end):depend({
            [1] = nil, 
            [2] = true, 
            [1] = v11.other.aspect_ratio
        }, {
            [1] = nil, 
            [2] = 1, 
            [1] = v11.other.aspect_ratio_method
        });
    end;
end;
v11.other.viewmodel = v10.other.visuals:switch("\v\238\149\142  \rViewmodel");
local v78 = v11.other.viewmodel:create();
v11.other.fov = v78:slider("Field of View", -100, 100, 68, 1):depend(v11.other.viewmodel);
v11.other.x = v78:slider("Offset X", -150, 150, 0, 0.1):depend(v11.other.viewmodel);
v11.other.y = v78:slider("Offset Y", -150, 150, 0, 0.1):depend(v11.other.viewmodel);
v11.other.z = v78:slider("Offset Z", -150, 150, 0, 0.1):depend(v11.other.viewmodel);
v11.other.fig = v78:button("Default Viewmodel Config", function()
    -- upvalues: v11 (ref)
    v11.other.fov:set(52);
    v11.other.x:set(11);
    v11.other.y:set(7);
    v11.other.z:set(7);
end):depend(v11.other.viewmodel);
v11.other.manual_arrows = v10.other.visuals:switch("\v\239\129\185  \rManual Arrows", false);
v78 = v11.other.manual_arrows;
local v79 = v78:create();
v11.other.manual_arrows_left = v79:input("Left", "<"):depend(v78);
v11.other.manual_arrows_right = v79:input("Right", ">"):depend(v78);
v11.other.manual_arrows_forward = v79:input("Forward", "^"):depend(v78);
v11.other.manual_arrows_font = v79:slider("", 1, 4, 1, nil, function(v80)
    if v80 == 1 then
        return "Default";
    elseif v80 == 2 then
        return "Pixel";
    elseif v80 == 3 then
        return "Console";
    elseif v80 == 4 then
        return "Bold";
    else
        return nil;
    end;
end):depend(v78);
v11.other.manual_arrows_clr = v79:color_picker("Accent", color(189, 189, 189, 255)):depend(v78);
v11.other.keeptransparency = v10.other.visuals:switch("\v\238\145\191   \rKeep Model Transparency");
v11.other.keeptransparency:tooltip("\vKeeps the local player model transparent after shooting with bolt-action sniper rifles and adds an extra fade-in/out animation;\n\nThis is 1:1 replica from gamesense.");
v11.other.debug_text = v10.other.visuals:switch("\v\239\159\185   \rDebug Text");
v11.other.highlight = v10.other.visuals:switch("\v\239\150\145   \rHighlight Model Hitboxes");
v11.other.highlight:tooltip("\vHighlights the hitboxes of local player model when Peek Assist is enabled.");
v78 = v11.other.highlight;
v11.other.highlight_color = v78:color_picker("", color(203, 186, 255, 112)):depend(v78);
v11.other.addons = v10.other.visuals:selectable("\v\239\132\174   \rAddons", {
    [1] = "\v\239\149\139  \rDisable Foot Shadows", 
    [2] = "\v\238\150\149  \rFix Chams Color", 
    [3] = "\v\238\143\135  \rNo Sleeves", 
    [4] = "\v\239\139\177   \rLegacy Desync"
});
v11.other.custom_scope_overlay = v10.other.other_visuals:switch("\v\239\129\155  \rCustom Scope Overlay");
v78 = v11.other.custom_scope_overlay:create();
v11.other.scope_color = v78:color_picker("Accent Color", color("868686FF")):depend(v11.other.custom_scope_overlay);
v11.other.scope_size = v78:slider("Size", 0, 300, 206):depend(v11.other.custom_scope_overlay):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v11.other.custom_scope_overlay
});
v11.other.scope_gap = v78:slider("Gap", 0, 300, 10):depend(v11.other.custom_scope_overlay):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v11.other.custom_scope_overlay
});
v11.other.scope_extra = v78:selectable("", {
    [1] = "Inverted", 
    [2] = "Rotated"
}, 3):depend({
    [1] = nil, 
    [2] = true, 
    [1] = v11.other.custom_scope_overlay
});
v11.other.damage_indicator = v10.other.other_visuals:switch("\v\239\155\130  \rDamage Override Indicator");
v11.other.hitmarkers = v10.other.other_visuals:selectable("\v\239\153\136   \rHitmarkers", {
    [1] = "Skeet", 
    [2] = "Kibit"
}, 2);
v78 = v11.other.hitmarkers:create();
v11.other.kibit_colorx = v78:color_picker("Kibit x", color(0, 255, 255, 255)):depend({
    [1] = nil, 
    [2] = "Kibit", 
    [1] = v11.other.hitmarkers
});
v11.other.kibit_colory = v78:color_picker("Kibit y", color(0, 255, 0, 255)):depend({
    [1] = nil, 
    [2] = "Kibit", 
    [1] = v11.other.hitmarkers
});
v12 = ui.get_position();
v13 = 0;
v19 = color(255, 255, 255, 255);
v20 = function(v81)
    -- upvalues: v12 (ref), v13 (ref), v19 (ref)
    local v82 = ui.get_size();
    local v83 = (ui.get_position() - v12) * 0.05;
    v12 = v12 + v83;
    local v84 = vector(250, 150);
    local v85 = v12 + vector(v82.x + 10, v82.y - v84.y - 155);
    local v86 = color(30, 30, 30, 200 * v81 * v13);
    local v87 = color(50, 50, 50, 255 * v81 * v13);
    render.rect(v85, v85 + v84, v86, 5);
    render.rect_outline(v85, v85 + v84, v87, 1, 5);
    local v88 = {
        [1] = "Commands:", 
        [2] = "p= \226\128\148 Set custom prefix", 
        [3] = "nh \226\128\148 Disable color", 
        [4] = "b=() \226\128\148 Use round brackets", 
        [5] = "nb \226\128\148 Remove brackets", 
        [6] = "np \226\128\148 Disable prefix", 
        [7] = "Example: p=NYANZA nh b=()"
    };
    local v89 = v85 + vector(10, 10);
    local v90 = 1;
    local v91 = color(v19.r, v19.g, v19.b, v19.a * v81 * v13);
    for _, v93 in ipairs(v88) do
        render.text(v90, v89, v91, nil, v93);
        v89.y = v89.y + 20;
    end;
end;
v68 = function(_)
    -- upvalues: v11 (ref)
    local v95 = v11.other.log_color:get():to_hex();
    local v96 = v11.other.log_prefix:get();
    local v97 = {};
    for v98 in v96:gmatch("%S+") do
        if v98 == "nh" then
            v97.use_hex = false;
        elseif v98 == "nb" then
            v97.use_brackets = false;
        elseif v98 == "np" then
            v97.use_prefix = false;
        elseif v98:match("p=") then
            v97.custom_prefix = v98:match("p=(.+)");
        elseif v98:match("b=") then
            v97.bracket_type = v98:match("b=(.+)");
        end;
    end;
    local v99 = {
        use_prefix = true, 
        use_brackets = true, 
        bracket_type = "[]", 
        use_hex = true, 
        custom_prefix = "NYANZA"
    };
    for v100, v101 in pairs(v99) do
        if v97[v100] == nil then
            v97[v100] = v101;
        end;
    end;
    local v102 = "";
    if v97.use_prefix then
        local l_custom_prefix_0 = v97.custom_prefix;
        if v97.use_hex then
            l_custom_prefix_0 = "\a" .. v95 .. l_custom_prefix_0 .. "\aDEFAULT";
        end;
        if v97.use_brackets then
            v102 = v97.bracket_type:sub(1, 1) .. l_custom_prefix_0 .. v97.bracket_type:sub(2, 2);
        else
            v102 = l_custom_prefix_0;
        end;
    end;
    return v102 .. " Hit \a" .. v95 .. "Yanni \aDEFAULTin the \a" .. v95 .. "stomach \aDEFAULTfor \a" .. v95 .. "106\aDEFAULT damage (hc: \a" .. v95 .. "89%\aDEFAULT \194\183 bt: \a" .. v95 .. "0t\aDEFAULT)";
end;
v69 = function()
    -- upvalues: v11 (ref), v13 (ref), v68 (ref), v12 (ref), v19 (ref), v20 (ref)
    local v104 = ui.get_alpha();
    if v11.other.log_guide:get() then
        v13 = v13 + (1 - v13) * 0.1;
    else
        v13 = v13 + (0 - v13) * 0.1;
    end;
    if v104 > 0 and v13 > 0 then
        local v105 = v68(v104);
        local v106 = v12 + vector(ui.get_size().x + 15, ui.get_size().y - 330);
        local v107 = 1;
        local v108 = color(v19.r, v19.g, v19.b, v19.a * v104 * v13);
        render.text(v107, v106, v108, nil, v105);
        v20(v104);
    end;
end;
events.render(v69);
events.round_start:set(function()
    -- upvalues: v11 (ref)
    local v109 = entity.get_local_player();
    if v109 and v109:is_alive() then
        if v11.other.addons:get(4) then
            cvar.sv_legacy_desync:int(1);
        else
            cvar.sv_legacy_desync:int(0);
        end;
    end;
end);
events.draw_model:set(function(v110)
    -- upvalues: v11 (ref)
    local v111 = entity.get_local_player();
    if v111 and v111:is_alive() and v11.other.addons:get(3) then
        return not v110.name:find("sleeve");
    else
        return;
    end;
end);
v72 = function()
    -- upvalues: v11 (ref)
    local v112 = entity.get_local_player();
    if not v112 or not v112:is_alive() then
        return;
    else
        local v113 = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"):get();
        local v114 = ui.find("Visuals", "World", "Main", "Force Thirdperson"):get();
        if v11.other.highlight:get() and v113 and v114 then
            render.highlight_hitbox(v112, 19, v11.other.highlight_color:get());
        end;
        return;
    end;
end;
events.render(v72);
v73 = 0;
v78 = false;
v79 = function(v115)
    -- upvalues: v11 (ref), v9 (ref), v73 (ref), v78 (ref)
    local v116 = entity.get_local_player();
    if not v116 or not v116:is_alive() then
        return;
    else
        local v117 = entity.get_game_rules().m_bFreezePeriod == true;
        if v11.other.freezetimefd:get() and v117 and v9.antiaim.misc.fake_duck:get() then
            v9.rage.main.dt:override(false);
            v9.rage.main.hs:override(false);
            v115.send_packet = false;
            fakelag_should = false;
            if v73 % 14 == 0 then
                v78 = true;
            elseif v73 % 14 == 6 then
                v115.send_packet = true;
            elseif v73 % 14 == 7 then
                v78 = false;
            end;
            if v78 then
                v115.in_duck = true;
            else
                v115.in_duck = false;
            end;
            v73 = v73 + 1;
        else
            v9.rage.main.dt:override();
            v9.rage.main.hs:override();
            v78 = false;
            v73 = 0;
            fakelag_should = true;
        end;
        return;
    end;
end;
events.createmove(v79);
events.override_view:set(function(v118)
    -- upvalues: v11 (ref), v9 (ref)
    local v119 = entity.get_local_player();
    if not v119 or not v119:is_alive() then
        return;
    else
        local v120 = entity.get_game_rules().m_bFreezePeriod == true;
        if v11.other.freezetimefd:get() and v120 and v9.antiaim.misc.fake_duck:get() then
            v118.camera.z = v119:get_origin().z + 64;
        end;
        return;
    end;
end);
local _ = {
    FL_ONGROUND = bit.lshift(1, 0), 
    FL_FROZEN = bit.lshift(1, 5)
};
local v122 = {};
local v123 = 0.45;
local v124 = 0;
local v125 = 0;
v122.flags = 0;
v122.packets = 0;
v122.packets_other = 0;
v122.velocity = 0;
v122.is_crouched = false;
v122.is_moving = false;
v122.is_airborne = false;
last_flick_at = 0;
flicker = not flicker;
do
    local l_v124_0, l_v125_0 = v124, v125;
    v122.pre_predict_command = function(_)
        -- upvalues: l_v124_0 (ref)
        l_v124_0 = entity.get_local_player().m_fFlags;
    end;
    v122.predict_command = function(_)
        -- upvalues: l_v125_0 (ref)
        l_v125_0 = entity.get_local_player().m_fFlags;
    end;
    v122.render_packets = function(v130)
        -- upvalues: v122 (ref), v11 (ref)
        local v131 = entity.get_local_player();
        if not v131 or not v131:is_alive() then
            return;
        else
            local l_m_fFlags_0 = v131.m_fFlags;
            v122.flags = l_m_fFlags_0;
            v122.velocity = v131.m_vecVelocity:length2d();
            v122.packets_other = v122.packets_other or 0;
            v122.tick_base = v122.tick_base or globals.tickcount;
            v122.is_freestanding = v11.antiaim.freestanding:get();
            v122.is_crouched = v131.m_flDuckAmount > 0.45;
            v122.is_moving = v122.velocity > 3.63;
            v122.is_airborne = v130.in_jump or bit.band(l_m_fFlags_0, bit.lshift(1, 0)) == 0;
            if globals.choked_commands == 0 then
                v122.packets = v122.packets + 1;
            end;
            return;
        end;
    end;
    events.createmove(v122.pre_predict_command);
    events.createmove_run(v122.predict_command);
    events.createmove(v122.render_packets);
end;
events.render:set(function()
    -- upvalues: v11 (ref)
    local _ = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage");
    local v134 = render.screen_size();
    local v135 = entity.get_local_player();
    if not v135 or v135.m_iHealth <= 0 or not v11.other.damage_indicator:get() then
        return;
    else
        for _, v137 in pairs(ui.get_binds()) do
            if v137.name == "Min. Damage" and v137.active then
                render.text(1, vector(v134.x / 2 + 4, v134.y / 2 - 15), color(), "", v137.value);
                break;
            end;
        end;
        return;
    end;
end);
v123 = {};
v124 = {};
v125 = v9.antiaim.angles;
local v138 = {};
local v139 = {};
for v140, v141 in next, v125 do
    local v142 = type(v141) == "table";
    v139[v140] = v142;
    if v142 then
        v138[v140] = {};
        for v143, _ in next, v141 do
            v138[v140][v143] = {
                [1] = 0, 
                [2] = -1
            };
        end;
    else
        v138[v140] = {
            [1] = 0, 
            [2] = -1
        };
    end;
end;
local v145 = -1;
do
    local l_v124_1, l_v125_1, l_v138_0, l_v139_0, l_v145_0 = v124, v125, v138, v139, v145;
    local v158 = {
        run = function(v151)
            -- upvalues: l_v145_0 (ref), l_v138_0 (ref), l_v139_0 (ref)
            l_v145_0 = math.max(v151.layer, l_v145_0);
            for v152, v153 in next, v151.overrides do
                local v154 = l_v138_0[v152];
                if l_v139_0[v152] then
                    for v155, v156 in next, v153 do
                        if v155 ~= "__mt" and v154[v155][2] <= v151.layer then
                            v154[v155][1] = v156;
                            v154[v155][2] = v151.layer;
                        end;
                    end;
                else
                    v154[1] = v153;
                    v154[2] = v151.layer;
                end;
            end;
        end, 
        tick = function(v157)
            v157.overrides = {};
        end
    };
    local v167 = {
        __newindex = function(v159, v160, v161)
            -- upvalues: l_v139_0 (ref)
            if l_v139_0[v160] ~= nil then
                if not l_v139_0[v160] then
                    v159.overrides[v160] = v161;
                end;
            else
                print("[ctx] failed to index ", v160);
            end;
        end, 
        __index = function(v162, v163)
            -- upvalues: v158 (ref), l_v139_0 (ref)
            if v158[v163] then
                return v158[v163];
            else
                if l_v139_0[v163] ~= nil then
                    if l_v139_0[v163] then
                        if v162.overrides[v163] == nil then
                            v162.overrides[v163] = {};
                            v162.overrides[v163].__mt = setmetatable({}, {
                                __newindex = function(_, v165, v166)
                                    -- upvalues: v162 (ref), v163 (ref)
                                    v162.overrides[v163][v165] = v166;
                                end
                            });
                        end;
                        return v162.overrides[v163].__mt;
                    end;
                else
                    print("[ctx] failed to index", v163);
                end;
                return;
            end;
        end
    };
    local v168 = {};
    v123.new = function(_, v170, v171)
        -- upvalues: l_v124_1 (ref), v168 (ref), v167 (ref)
        assert(l_v124_1[v170] == nil, "aa name already used");
        assert(v168[v171] == nil, "aa layer already used");
        v168[v171] = true;
        l_v124_1[v170] = {
            name = v170, 
            layer = v171, 
            overrides = {}
        };
        return setmetatable(l_v124_1[v170], v167);
    end;
    v123.on_cm = function(_)
        -- upvalues: l_v125_1 (ref), l_v138_0 (ref), l_v139_0 (ref), l_v145_0 (ref)
        for _, v174 in next, l_v125_1 do
            if type(v174) ~= "table" then
                v174:override();
            end;
        end;
        for v175, v176 in next, l_v138_0 do
            if l_v139_0[v175] then
                for v177, v178 in next, v176 do
                    if v178[2] ~= -1 then
                        l_v125_1[v175][v177]:override(v178[1]);
                        v178[2] = -1;
                    else
                        l_v125_1[v175][v177]:override();
                    end;
                end;
            elseif v176[2] ~= -1 then
                l_v125_1[v175]:override(v176[1]);
                v176[2] = -1;
            else
                l_v125_1[v175]:override();
            end;
        end;
        l_v145_0 = -1;
    end;
    events.createmove:set(function()
        -- upvalues: v123 (ref)
        v123:on_cm();
    end);
    v123.condition = function(_)
        -- upvalues: v11 (ref), v122 (ref), v9 (ref)
        local _ = v11.states;
        if v11.antiaim.freestanding_bool:get() == 1 and v122.is_freestanding then
            return v11.states[8];
        elseif v122.is_airborne then
            return v11.states[v122.is_crouched and 7 or 6];
        elseif v122.is_moving then
            local v181 = v9.antiaim.misc.slow_walk:get();
            return v11.states[v122.is_crouched and 5 or v181 and 3 or 2];
        else
            return v11.states[v122.is_crouched and 4 or 1];
        end;
    end;
    v123.freestanding_states = function(_)
        -- upvalues: v11 (ref), v122 (ref), v9 (ref)
        local _ = v11.states;
        if v122.is_airborne then
            return v11.states[v122.is_crouched and 7 or 6];
        elseif v122.is_moving then
            local v184 = v9.antiaim.misc.slow_walk:get();
            return v11.states[v122.is_crouched and 5 or v184 and 3 or 2];
        else
            return v11.states[v122.is_crouched and 4 or 1];
        end;
    end;
    get_aimbot_targets = function()
        local v185 = {};
        local v186 = entity.get_player_resource();
        for v187 = 1, globals.max_players do
            local v188 = entity.get(v187);
            if v188 ~= nil and v186.m_bConnected[v187] and v188:is_enemy() and v188:is_alive() then
                table.insert(v185, v188);
            end;
        end;
        return v185;
    end;
end;
v124 = 255;
v125 = 10;
v138 = function()
    -- upvalues: v11 (ref), v124 (ref), v125 (ref)
    local v189 = entity.get_local_player();
    local v190 = v189:get_player_weapon();
    if v190 == nil then
        return;
    else
        local v191 = v190 and v190:get_classname();
        if v189 == nil or not v189:is_alive() or not v11.other.keeptransparency:get() or v191:find("Grenade") or v191:find("Flashbang") then
            return;
        else
            local v192 = v189.m_bIsScoped or v189.m_bResumeZoom;
            if v192 and v124 > 60 then
                v124 = v124 - v125;
                if v124 < 60 then
                    v124 = 60;
                end;
            elseif not v192 and v124 < 255 then
                v124 = v124 + v125;
                if v124 > 255 then
                    v124 = 255;
                end;
            end;
            return v124;
        end;
    end;
end;
events.localplayer_transparency:set(v138);
v139 = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Enabled");
v145 = -1;
local v193 = 16;
local function v199(v194)
    -- upvalues: v9 (ref), v11 (ref), v139 (ref), v8 (ref), v145 (ref), v193 (ref)
    local v195 = entity.get_local_player();
    if not v195 then
        return;
    else
        local v196 = v195:get_player_weapon();
        if not v196 then
            return;
        else
            local v197 = v196:get_weapon_index() == 64;
            local v198 = entity.get_game_rules().m_bFreezePeriod == true;
            if v195.m_iShotsFired > 0 or rage.exploit:get() > 0 or v9.rage.main.dt:get() or v9.antiaim.misc.fake_duck:get() or v11.antiaim.fluctuate:get() ~= 1 and v11.antiaim.fluctuate:get() ~= 2 or v198 then
                v139:override();
                v8.fakelag = nil;
                return;
            else
                if v11.antiaim.fluctuate:get() == 1 then
                    if v145 < v193 then
                        v194.send_packet = false;
                        v8.fakelag = "entity:custom_fakelag() -> (current choke: \aBD5B5BFF" .. v145 .. "t\aDEFAULT)";
                    else
                        v194.send_packet = true;
                        v145 = -1;
                        v8.fakelag = "entity:custom_fakelag() -> (current choke: \aBABD5BFF" .. v145 .. "t\aDEFAULT)";
                    end;
                    v145 = v145 + 1;
                    v139:override(false);
                elseif v11.antiaim.fluctuate:get() == 2 then
                    if v197 then
                        if v145 < v193 then
                            v194.send_packet = false;
                            v8.fakelag = "entity:custom_fakelag() -> (current choke: \aBD5B5BFF" .. v145 .. "t\aDEFAULT)";
                        else
                            v194.send_packet = true;
                            v145 = -1;
                            v8.fakelag = "entity:custom_fakelag() -> (current choke: \aBABD5BFF" .. v145 .. "t\aDEFAULT)";
                        end;
                        v145 = v145 + 1;
                        v139:override(false);
                    else
                        v8.fakelag = nil;
                        v139:override(true);
                    end;
                end;
                return;
            end;
        end;
    end;
end;
events.createmove:set(v199);
local v213 = {
    lag_timer = 0, 
    ground_timer = 0, 
    in_air = function(v200, v201)
        if not v201 then
            return false;
        else
            local l_m_fFlags_1 = v201.m_fFlags;
            if bit.band(l_m_fFlags_1, 1) ~= 0 then
                if v200.ground_timer == 6 then
                    return false;
                else
                    v200.ground_timer = v200.ground_timer + 1;
                end;
            else
                v200.ground_timer = 0;
            end;
            return true;
        end;
    end, 
    sneaking = function(_, v204)
        local l_m_vecVelocity_0 = v204.m_vecVelocity;
        return math.sqrt(l_m_vecVelocity_0.x * l_m_vecVelocity_0.x + l_m_vecVelocity_0.y * l_m_vecVelocity_0.y) > 2;
    end, 
    slowing = function(_, v207)
        return v207.m_bDucked;
    end, 
    get_state = function(v208, v209)
        -- upvalues: v8 (ref)
        local v210 = v208:sneaking(v209);
        local v211 = v208:slowing(v209);
        local v212 = v208:in_air(v209);
        v8.get_state = nil;
        if ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"):get() and not v212 and not v211 then
            v8.get_state = "entity:get_state() -> (\aBABD5BFF1 << 18\aDEFAULT)";
            return "Slowing";
        elseif v212 then
            if v211 then
                v8.get_state = "entity:get_state() -> (\aBABD5BFF1 << 1/1\aDEFAULT)";
                return "Air Crouching";
            else
                v8.get_state = "entity:get_state() -> (\aBABD5BFF1 << 1\aDEFAULT)";
                return "Air";
            end;
        elseif v211 and v210 and not v212 then
            v8.get_state = "entity:get_state() -> (\aBABD5BFF1 << 12/1\aDEFAULT)";
            return "Sneaking";
        elseif v211 and not v212 then
            v8.get_state = "entity:get_state() -> (\aBABD5BFF1 << 1\aDEFAULT)";
            return "Crouching";
        elseif v210 then
            v8.get_state = "entity:get_state() -> (\aBABD5BFF1 << 12\aDEFAULT)";
            return "Running";
        elseif not v210 then
            v8.get_state = "entity:get_state() -> (\aBABD5BFF1 << 0\aDEFAULT)";
            return "Standing";
        else
            return "none";
        end;
    end
};
local v214 = {
    airlag_done = false, 
    legacy_desync = false, 
    latency_unlock_done = false, 
    teammate_aimbot_done = false, 
    exposure_toggle_done = false, 
    shadow_toggle_done = false
};
local function v219()
    -- upvalues: v4 (ref), v213 (ref), v11 (ref), v214 (ref)
    local v215 = entity.get_local_player();
    local v216 = v4.get_snapshot(v215);
    local v217 = v213:get_state(v215);
    if not (v217 == "Air" or v217 == "Air Crouching") then
        ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):override();
        return;
    elseif v216 == nil then
        return;
    else
        local l_no_entry_0 = v216.command.no_entry;
        if l_no_entry_0.x == 0 and l_no_entry_0.y == 0 then
            return;
        else
            if v11.antiaim.airlag:get() then
                if rage.exploit:get() > 0 then
                    if l_no_entry_0.x == l_no_entry_0.y and not v214.airlag_done then
                        ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):override(true);
                        v214.airlag_done = true;
                    elseif l_no_entry_0.x ~= l_no_entry_0.y and v214.airlag_done then
                        v214.airlag_done = false;
                    end;
                else
                    ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"):override();
                end;
            end;
            return;
        end;
    end;
end;
local function v220()
    -- upvalues: v214 (ref), v11 (ref)
    if entity.get_local_player().m_iShotsFired > 0 then
        cvar.sv_legacy_desync:int(0);
        v214.legacy_desync = false;
        return;
    else
        if not v214.legacy_desync and v11.other.addons:get(4) then
            cvar.sv_legacy_desync:int(1);
            v214.legacy_desync = true;
        elseif v214.legacy_desync and not v11.other.addons:get(4) then
            cvar.sv_legacy_desync:int(0);
            v214.legacy_desync = false;
        end;
        return;
    end;
end;
local function v221()
    -- upvalues: v214 (ref), v11 (ref)
    if not v214.shadow_toggle_done and v11.other.addons:get(1) then
        cvar.cl_foot_contact_shadows:int(0);
        cvar.clear:call();
        v214.shadow_toggle_done = true;
    elseif v214.shadow_toggle_done and not v11.other.addons:get(1) then
        cvar.cl_foot_contact_shadows:int(1);
        cvar.clear:call();
        v214.shadow_toggle_done = false;
    end;
    if not v214.exposure_toggle_done and v11.other.addons:get(2) then
        cvar.mat_autoexposure_max_multiplier:int(0);
        v214.exposure_toggle_done = true;
    elseif v214.exposure_toggle_done and not v11.other.addons:get(2) then
        cvar.mat_autoexposure_max_multiplier:int(1);
        v214.exposure_toggle_done = false;
    end;
    if not v214.teammate_aimbot_done and v11.other.teammate_aimbot:get() then
        cvar.mp_teammates_are_enemies:int(1);
        cvar.clear:call();
        v214.teammate_aimbot_done = true;
    elseif v214.teammate_aimbot_done and not v11.other.teammate_aimbot:get() then
        cvar.mp_teammates_are_enemies:int(0);
        cvar.clear:call();
        v214.teammate_aimbot_done = false;
    end;
    if not v214.latency_unlock_done and v11.other.unlock_fake_latency:get() then
        utils.console_exec("sv_maxunlag 0.400");
        v214.latency_unlock_done = true;
    elseif v214.latency_unlock_done and not v11.other.unlock_fake_latency:get() then
        utils.console_exec("sv_maxunlag 0.200");
        v214.latency_unlock_done = false;
    end;
end;
events.createmove:set(v219);
events.createmove:set(v221);
events.createmove:set(v220);
local v225 = {
    register = function(v222, _, v224)
        events[v222]:set(v224);
    end
};
l_ffi_0.cdef("    typedef struct {\n        char  pad_0000[20];\n        int m_nOrder; //0x0014\n        int m_nSequence; //0x0018\n        float m_flPrevCycle; //0x001C\n        float m_flWeight; //0x0020\n        float m_flWeightDeltaRate; //0x0024\n        float m_flPlaybackRate; //0x0028\n        float m_flCycle; //0x002C\n        void *m_pOwner; //0x0030\n        char  pad_0038[4]; //0x0034\n    } CAnimationLayer\n");
local v245 = {
    update = function(v226)
        -- upvalues: v213 (ref), l_ffi_0 (ref), v11 (ref)
        local v227 = entity.get_local_player();
        local v228 = v213:get_state(v227);
        local _ = v228 == "Air Crouching" or v228 == "Air";
        local v230 = ui.find("aimbot", "anti aim", "misc", "leg movement");
        local _ = v227.m_flPoseParameter[11] * 120 - 60 > 0;
        local v232 = l_ffi_0.cast("CAnimationLayer**", l_ffi_0.cast("uintptr_t", v227[0]) + 10640)[0][12];
        local v233 = l_ffi_0.cast("CAnimationLayer**", l_ffi_0.cast("uintptr_t", v227[0]) + 10640)[0][6];
        local _ = v227.m_vecVelocity:length2d();
        if not v227 or v226 ~= v227 then
            return;
        else
            if v11.other.player_animations_interpolating:get() > 0 and rage.antiaim:get_max_desync() ~= 29 and v227.m_iShotsFired < 1 then
                local v235 = rage.antiaim:get_rotation(true);
                local v236 = rage.antiaim:get_rotation(false);
                local v237 = math.abs(v236 - v235);
                print_dev("real: " .. v236 .. " fake: " .. v235 .. " difference: " .. v237 .. " DESYNC: " .. rage.antiaim:get_max_desync());
                if v235 ~= v236 and v237 < rage.antiaim:get_max_desync() then
                    local v238 = v226.m_flPoseParameter[11] * 120 - v237 > 0;
                    local v239 = v11.other.player_animations_interpolating:get() * globals.tickinterval / 1;
                    local v240 = v238 and -v239 or v239;
                    v227.m_flPoseParameter[11] = v227.m_flPoseParameter[11] + v240;
                    v227.m_flPoseParameter[7] = v227.m_flPoseParameter[7] + v240 / 2;
                end;
            end;
            if v11.other.player_animations:get(3) then
                v11.other.player_animations_walking:set(0);
                v11.other.player_animations_walking:disabled(true);
                v230:override("walking");
                v233.m_flCycle = 1;
            else
                v11.other.player_animations_walking:disabled(false);
            end;
            if v11.other.player_animations:get(1) then
                v232.m_flWeight = utils.random_float(0, v11.other.player_animations_leaning:get()) / 100;
                v227.m_flPoseParameter[14] = utils.random_float(0, 1);
                v227.m_flPoseParameter[2] = utils.random_float(0, 1);
                v227.m_flPoseParameter[6] = utils.random_float(0, v11.other.player_animations_falling:get()) / 10;
                v227.m_flPoseParameter[3] = utils.random_float(0, 30);
            end;
            if v227.m_vecVelocity:length() > 3 and not v11.other.player_animations:get(1) then
                if v11.other.player_animations_leaning:get() > 0 then
                    v232.m_flWeight = v11.other.player_animations_leaning:get() / 100;
                end;
            elseif v11.other.player_animations:get(2) and not v11.other.player_animations:get(1) and v11.other.player_animations_leaning:get() > 0 then
                v232.m_flWeight = v11.other.player_animations_leaning:get() / 100;
            end;
            if not v11.other.player_animations:get(1) then
                v227.m_flPoseParameter[6] = v11.other.player_animations_falling:get() / 10;
            end;
            if v11.other.player_animations_walking:get() == 2 then
                local v241 = 50;
                local v242 = 0;
                local v243 = 1 / (globals.tickcount % 8 >= 4 and 200 or 400);
                local v244 = globals.tickcount % 4 >= 2 and v241 or v242;
                v227.m_flPoseParameter[0] = v244 * v243;
                v227.m_flPoseParameter[7] = v244 * v243;
                v230:override(globals.commandack % 3 > 0 and "sliding" or "default");
            elseif v11.other.player_animations_walking:get() == 1 then
                v227.m_flPoseParameter[7] = 0;
                v230:override("walking");
            end;
            return;
        end;
    end
};
v225.register("post_update_clientside_animation", "anim_layer", v245.update);
local v246 = {};
local l_r_aspectratio_0 = cvar.r_aspectratio;
do
    local l_l_r_aspectratio_0_0 = l_r_aspectratio_0;
    v246.update = function()
        -- upvalues: v11 (ref), l_l_r_aspectratio_0_0 (ref)
        if v11.other.aspect_ratio:get() then
            if v11.other.aspect_ratio_method:get() == 3 then
                l_l_r_aspectratio_0_0:float(v11.other.aspect_ratio_width:get() / v11.other.aspect_ratio_height:get() or 0);
            elseif v11.other.aspect_ratio_method:get() == 2 then
                if v11.other.aspect_ratio_list:get() == "16:9 (1920x1080)" then
                    l_l_r_aspectratio_0_0:float(1.7777777777777777);
                elseif v11.other.aspect_ratio_list:get() == "16:10 (1728x1080)" then
                    l_l_r_aspectratio_0_0:float(1.6);
                elseif v11.other.aspect_ratio_list:get() == "3:2 (1620x1080)" then
                    l_l_r_aspectratio_0_0:float(1.5);
                elseif v11.other.aspect_ratio_list:get() == "4:3 (1024x768)" then
                    l_l_r_aspectratio_0_0:float(1.3333333333333333);
                elseif v11.other.aspect_ratio_list:get() == "5:4 (1280x1024)" then
                    l_l_r_aspectratio_0_0:float(1.25);
                end;
            elseif v11.other.aspect_ratio_method:get() == 1 then
                l_l_r_aspectratio_0_0:float(v11.other.aspect_ratio_slider:get() / 100 or 0);
            end;
        else
            l_l_r_aspectratio_0_0:float(0);
        end;
    end;
end;
events.render:set(v246.update);
events.shutdown:set(function()
    cvar.cl_foot_contact_shadows:int(1);
    cvar.mat_autoexposure_max_multiplier:int(1);
    cvar.mp_teammates_are_enemies:int(0);
    cvar.sv_unlag:int(1);
    utils.console_exec("sv_maxunlag 0.200");
    cvar.r_aspectratio:int(0, true);
    cvar.sv_legacy_desync:int(0);
    cvar.sv_outofammo_indicator:int(0);
end);
events.createmove_run:set(function(_)
    -- upvalues: v11 (ref)
    if v11.other.viewmodel:get() then
        local v250 = v11.other.x:get() / 10;
        local v251 = v11.other.y:get() / 10;
        local v252 = v11.other.z:get() / 10;
        local v253 = v11.other.fov:get();
        cvar.viewmodel_offset_x:float(v250, true);
        cvar.viewmodel_offset_y:float(v251, true);
        cvar.viewmodel_offset_z:float(v252, true);
        cvar.viewmodel_fov:float(v253, true);
    else
        cvar.viewmodel_offset_x:float(1, true);
        cvar.viewmodel_offset_y:float(0, true);
        cvar.viewmodel_offset_z:float(0, true);
        cvar.viewmodel_fov:float(68, true);
    end;
end);
l_r_aspectratio_0 = {};
local v254 = {};
local v255 = {};
local v256 = {
    inferno = "Burned", 
    knife = "Knifed", 
    hegrenade = "Naded"
};
local v257 = 0;
local function v259(_)
    -- upvalues: v257 (ref)
    v257 = globals.server_tick;
end;
events.aim_fire(v259);
local function v270(v260)
    -- upvalues: v11 (ref)
    local v261 = v11.other.log_color:get():to_hex();
    local v262 = v11.other.log_prefix:get();
    local v263 = {};
    for v264 in v262:gmatch("%S+") do
        if v264 == "nh" then
            v263.use_hex = false;
        elseif v264 == "nb" then
            v263.use_brackets = false;
        elseif v264 == "np" then
            v263.use_prefix = false;
        elseif v264:match("p=") then
            v263.custom_prefix = v264:match("p=(.+)");
        elseif v264:match("b=") then
            v263.bracket_type = v264:match("b=(.+)");
        end;
    end;
    local v265 = {
        bracket_type = "[]", 
        use_hex = true, 
        use_prefix = true, 
        use_brackets = true
    };
    for v266, v267 in pairs(v265) do
        if v263[v266] == nil then
            v263[v266] = v267;
        end;
    end;
    local v268 = "";
    if v263.use_prefix then
        local v269 = v263.custom_prefix or "NYANZA";
        if v263.use_hex then
            v269 = "\a" .. v261 .. v269 .. "\a";
        end;
        if v263.use_brackets then
            v268 = v263.bracket_type:sub(1, 1) .. v269 .. v263.bracket_type:sub(2, 2);
        else
            v268 = v269;
        end;
    end;
    if v268 ~= "" then
        print_raw(string.format("%s %s", v268, v260));
    else
        print_raw(v260);
    end;
    print_dev(string.format("%s%s", "", v260));
end;
l_r_aspectratio_0.aim_ack = function(_, v272)
    -- upvalues: v11 (ref), v257 (ref), v270 (ref)
    if not v11.other.log_aimbot:get() then
        return;
    else
        local v273 = math.max(globals.server_tick - v257 - 1, 0);
        local l_target_0 = v272.target;
        local v275 = {
            [0] = "generic", 
            [1] = "head", 
            [2] = "chest", 
            [3] = "stomach", 
            [4] = "left arm", 
            [5] = "right arm", 
            [6] = "left leg", 
            [7] = "right leg", 
            [8] = "neck", 
            [9] = "generic", 
            [10] = "gear"
        };
        local l_state_0 = v272.state;
        local v277 = l_target_0:get_name();
        local l_m_iHealth_0 = l_target_0.m_iHealth;
        local l_spread_0 = v272.spread;
        local l_backtrack_0 = v272.backtrack;
        local l_hitchance_0 = v272.hitchance;
        local l_damage_0 = v272.damage;
        local l_wanted_damage_0 = v272.wanted_damage;
        local v284 = v275[v272.hitgroup] or "body";
        local v285 = v275[v272.wanted_hitgroup] or "body";
        local v286 = v11.other.log_color:get():to_hex();
        if not l_target_0 then
            return;
        else
            if l_state_0 == "correction" or l_state_0 == "backtrack failure" then
                l_state_0 = "?";
            end;
            if l_state_0 == "spread" then
                l_state_0 = string.format("\a%sspread\aDEFAULT(\aC6CBD1FF%.2f\194\176\aDEFAULT)", v286, l_spread_0);
            end;
            if not l_state_0 then
                v270(string.format("Hit \a%s%s%s \aDEFAULTin the \a%s%s\aDEFAULT%s for \a%s%d\aDEFAULT%s damage (hc: \a%s%d%%\aDEFAULT \a898989FF\194\183\aDEFAULT bt: \a%s%st\aDEFAULT)%s", v286, v277, l_m_iHealth_0 ~= 0 and string.format("\aDEFAULT(\aC6CBD1FF%shp\aDEFAULT)", l_m_iHealth_0) or "", v286, v284, v285 ~= v284 and string.format("(\aC6CBD1FF%s\aDEFAULT)", v285) or "", v286, l_damage_0, l_wanted_damage_0 ~= l_damage_0 and string.format("(\aC6CBD1FF%d\aDEFAULT)", l_wanted_damage_0) or "", v286, l_hitchance_0, v286, l_backtrack_0, v273 ~= 0 and string.format(" \aDEFAULT(delay=\a%s%.0fms\aDEFAULT)", v286, to_time(v273) * 1000) or ""));
            end;
            if l_state_0 then
                local _ = v270(string.format("\aC6CBD1FFMissed \a%s%s\aDEFAULT's \a%s%s \aDEFAULTdue to \a%s%s \aDEFAULT(hc: \a%s%d%%\aDEFAULT \a898989FF\194\183\aDEFAULT bt: \a%s%dt\aDEFAULT) (damage: \a%s%shp\aDEFAULT)", v286, v277, v286, v285, v286, l_state_0, v286, l_hitchance_0, v286, l_backtrack_0, v286, l_wanted_damage_0));
            end;
            return;
        end;
    end;
end;
v254.player_hurt = function(_, v289)
    -- upvalues: v11 (ref), v256 (ref), v270 (ref)
    if not v11.other.log_aimbot:get() then
        return;
    else
        local v290 = entity.get_local_player();
        local v291 = entity.get(v289.userid, true);
        local v292 = entity.get(v289.attacker, true);
        local _ = v11.other.log_color:get();
        local v294 = v11.other.log_color:get():to_hex();
        if v291 == v290 or v292 ~= v290 or v256[v289.weapon] == nil then
            return;
        else
            local v295 = string.format("\aC6CBD1FF%s \a%s%s%s \aDEFAULTfor \a" .. v294 .. "%s \aDEFAULTdamage", v256[v289.weapon], v294, v291:get_name(), v289.health > 0 and string.format("\aDEFAULT(\aC6CBD1FF%shp\aDEFAULT)", v289.health) or "", v289.dmg_health);
            v270(v295);
            return;
        end;
    end;
end;
v255.item_purchase = function(_, v297)
    -- upvalues: v11 (ref), v270 (ref)
    if not v11.other.log_purchases:get() then
        return;
    else
        local v298 = entity.get(v297.userid, true);
        local v299 = v11.other.log_color:get():to_hex();
        if v298 == nil or not v298:is_enemy() then
            return;
        else
            local l_weapon_0 = v297.weapon;
            if l_weapon_0 == "weapon_unknown" then
                return;
            else
                local v301 = v298:get_name();
                v270(string.format("\a%s%s \aDEFAULTbought \a%s%s\aDEFAULT", v299, v301, v299, l_weapon_0));
                return;
            end;
        end;
    end;
end;
events.aim_ack:set(function(v302)
    -- upvalues: l_r_aspectratio_0 (ref)
    l_r_aspectratio_0:aim_ack(v302);
end);
events.player_hurt:set(function(v303)
    -- upvalues: v254 (ref)
    v254:player_hurt(v303);
end);
events.item_purchase:set(function(v304)
    -- upvalues: v255 (ref)
    v255:item_purchase(v304);
end);
events.createmove:set(function()
    -- upvalues: v11 (ref)
    local v305 = ui.find("Miscellaneous", "Main", "Other", "Log Events");
    if v11.other.log_aimbot:get() or v11.other.log_purchases:get() then
        v305:override("");
    else
        v305:override();
    end;
    v11.other.player_animations_interpolating:disabled(true);
    v11.other.player_animations_interpolating:set(0);
    v11.other.debug_text:disabled(true);
    v11.other.debug_text:set(false);
end);
local v306 = false;
local v307 = false;
local v308 = false;
local function v312(v309)
    local v310 = entity.get_local_player();
    if not v310 then
        return false;
    else
        local v311 = v310:get_origin();
        return utils.trace_line(v311, v311 + vector(0, 0, -v309), v310).fraction < 1;
    end;
end;
events.createmove:set(function(v313)
    -- upvalues: v11 (ref), v312 (ref), v307 (ref), v306 (ref), v308 (ref)
    local v314 = entity.get_local_player();
    if not v11.other.no_fall_damage:get() then
        return;
    elseif not v314 then
        return;
    else
        local v315 = v314:get_anim_state();
        if not v315 then
            return;
        else
            local v316 = v314.m_vecVelocity.z < -350 and not v312(15);
            if v316 ~= v307 then
                v306 = v316;
            end;
            v307 = v316;
            if v314.m_vecVelocity.z < -550 then
                v313.in_duck = v306 and 1 or 0;
                ui.find("Miscellaneous", "Main", "Movement", "Air Strafe", "Smoothing"):override(v306 and 100 or 50);
                v308 = v306;
            else
                ui.find("Miscellaneous", "Main", "Movement", "Air Strafe", "Smoothing"):override();
            end;
            if v308 and v315.landed_on_ground_this_frame then
                v313.in_jump = 1;
                v308 = false;
            end;
            return;
        end;
    end;
end);
events.createmove:set(function(v317)
    -- upvalues: v11 (ref)
    if v11.other.fast_ladder:get() then
        local v318 = entity.get_local_player();
        if v318 == nil then
            return;
        elseif v318.m_MoveType == 9 then
            v317.view_angles.y = math.floor(v317.view_angles.y + 0.5);
            if v317.forwardmove > 0 then
                if v317.view_angles.x < 45 then
                    v317.view_angles.x = 89;
                    v317.in_moveright = 1;
                    v317.in_moveleft = 0;
                    v317.in_forward = 0;
                    v317.in_back = 1;
                    if v317.sidemove == 0 then
                        v317.view_angles.y = v317.view_angles.y + 90;
                    end;
                    if v317.sidemove < 0 then
                        v317.view_angles.y = v317.view_angles.y + 150;
                    end;
                    if v317.sidemove > 0 then
                        v317.view_angles.y = v317.view_angles.y + 30;
                    end;
                end;
            elseif v317.forwardmove < 0 then
                v317.view_angles.x = 89;
                v317.in_moveleft = 1;
                v317.in_moveright = 0;
                v317.in_forward = 1;
                v317.in_back = 0;
                if v317.sidemove == 0 then
                    v317.view_angles.y = v317.view_angles.y + 90;
                end;
                if v317.sidemove > 0 then
                    v317.view_angles.y = v317.view_angles.y + 150;
                end;
                if v317.sidemove < 0 then
                    v317.view_angles.y = v317.view_angles.y + 30;
                end;
            end;
        end;
    end;
end);
local v319 = {};
local v320 = v123:new("safe_head", 5);
do
    local l_v320_0 = v320;
    v319.update = function()
        -- upvalues: v213 (ref), v11 (ref), l_v320_0 (ref)
        local v322 = entity.get_local_player();
        local v323 = entity.get_threat(true);
        local v324 = v322:get_player_weapon();
        local v325 = v213:get_state(v322);
        local v326 = v325 == "Air" or v325 == "Air Crouching";
        if v11.antiaim.safe_head_height:get() == 0 then
            return;
        elseif v11.antiaim.manual_yaw:get() ~= "Disabled" or v11.antiaim.freestanding:get() then
            return;
        elseif not v322 or v322 == nil then
            return;
        elseif not v326 then
            return;
        elseif not (function()
            -- upvalues: v11 (ref)
            local v327 = entity.get_local_player();
            local _, _, _ = v327:get_origin();
            local v331 = entity.get_threat(false);
            local v332 = v331 ~= nil and v331:get_origin() or vector();
            local l_z_0 = v327:get_origin().z;
            local l_z_1 = v332.z;
            return l_z_0 - 35 - v11.antiaim.safe_head_height:get() > l_z_1 + 0;
        end)() then
            return;
        elseif not v324 or v324 == nil then
            return;
        else
            local v335 = v324:get_weapon_info();
            if not v323 or v323 == nil then
                return;
            else
                if v335.weapon_type == 0 then
                    l_v320_0:tick();
                    l_v320_0.extract_yaw.offset = 3;
                    l_v320_0.extract_modifier.mode = "Disabled";
                    l_v320_0.extract_desync.left_limit = 0;
                    l_v320_0.extract_desync.right_limit = 0;
                    rage.antiaim:inverter(false);
                    l_v320_0.extract_yaw.snap = false;
                    l_v320_0:run();
                else
                    l_v320_0:tick();
                    l_v320_0.extract_yaw.offset = 22;
                    l_v320_0.extract_modifier.mode = "Disabled";
                    l_v320_0.extract_desync.left_limit = 60;
                    l_v320_0.extract_desync.right_limit = 60;
                    rage.antiaim:inverter(false);
                    l_v320_0.extract_yaw.snap = false;
                    l_v320_0:run();
                end;
                return;
            end;
        end;
    end;
end;
v320 = false;
local v336 = 0;
local v337 = {};
local v338 = v123:new("antiaimbot", 1);
v337.yaw = function(_, v340)
    -- upvalues: v11 (ref), v123 (ref), v336 (ref), v320 (ref), v122 (ref)
    local v341 = entity.get_local_player();
    if not v341 or not v341:is_alive() then
        return;
    else
        ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"):override(true);
        ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"):override(false);
        local _ = v341.m_flPoseParameter[11] * 120 - 60 > 0;
        local v343 = v11.antiaim[v123:condition()];
        local v344 = v343.yaw_offset:get();
        local v345 = v343.yaw_left_offset:get();
        local v346 = v343.yaw_right_offset:get();
        local v347 = v343.yaw_mode:get();
        local v348 = v343.yaw_delay_multiplier:get();
        local _ = v348 * 2;
        local v350 = v343.yaw_delay_min:get();
        local v351 = v343.yaw_delay_max:get();
        local v352 = v343.yaw_delay_method:get();
        local v353 = v343.yaw_delay_bool:get();
        if not v336 then
            v336 = 0;
        end;
        if not v320 then
            v320 = false;
        end;
        if v347 == 2 then
            if v353 ~= 0 then
                if v352 == 1 then
                    if v348 <= v122.packets - v336 then
                        v320 = not v320;
                        v336 = v122.packets;
                    end;
                    rage.antiaim:inverter(v320);
                    v344 = v320 and v345 or v346;
                elseif v352 == 2 then
                    if v122.packets - v336 >= math.random(v350, v351) then
                        v320 = not v320;
                        v336 = v122.packets;
                    end;
                    rage.antiaim:inverter(v320);
                    v344 = v320 and v345 or v346;
                elseif v352 == 3 then
                    local v354 = {};
                    for v355 = 1, v343.delay_numbers:get() do
                        table.insert(v354, v343["delay_" .. v355]:get());
                    end;
                    local v356 = math.random(1, v343.delay_numbers:get());
                    if v122.packets - v336 >= v354[v356] then
                        v320 = not v320;
                        v336 = v122.packets;
                    end;
                    rage.antiaim:inverter(v320);
                    v344 = v320 and v345 or v346;
                end;
            else
                v344 = v341.m_flPoseParameter[11] * 120 - 60 > 0 and v345 or v346;
            end;
        end;
        v340.pitch = "Down";
        v340.extract_yaw.base = "At Target";
        v340.extract_yaw.offset = v344;
        return;
    end;
end;
v337.yaw_modifier = function(_, v358)
    -- upvalues: v11 (ref), v123 (ref)
    local v359 = v11.antiaim[v123:condition()];
    v358.extract_yaw.yaw = v359.yaw:get() == 1 and "Backward" or v359.yaw:get() == 2 and "Static" or "Disabled";
    local v360 = v359.modifier:get() == 2 and "Offset" or v359.modifier:get() == 3 and "Center" or v359.modifier:get() == 4 and "Random" or v359.modifier:get() == 5 and "Spin" or v359.modifier:get() == 6 and "3-way" or v359.modifier:get() == 7 and "5-way" or "Disabled";
    local v361 = v359.modifier_jitter_offset:get();
    local v362 = v359.modifier_random_jitter:get();
    local v363 = v359.modifier_minimum_offset:get();
    local v364 = v359.modifier_maximum_offset:get();
    local v365 = v359.modifier_method:get();
    if v362 then
        if v365 == 1 then
            v358.extract_modifier.offset = math.random(v363, v364);
        elseif v365 == 2 then
            local v366 = {};
            for v367 = 1, v359.modifier_numbers:get() do
                table.insert(v366, v359["modifier_" .. v367]:get());
            end;
            local v368 = math.random(1, v359.modifier_numbers:get());
            v358.extract_modifier.offset = v366[v368];
        end;
    else
        v358.extract_modifier.offset = v361;
    end;
    v358.extract_modifier.mode = v360;
end;
v337.body_yaw = function(_, v370)
    -- upvalues: v11 (ref), v123 (ref)
    local v371 = v11.antiaim[v123:condition()];
    if v371.desync:get() == 0 then

    end;
    local v372 = v371.desync:get() == 1;
    local v373 = v371.desync_freestanding:get();
    local v374 = v371.desync_limit_mode:get();
    local v375 = v371.desync_left:get();
    local v376 = v371.desync_right:get();
    local v377 = v371.desync_min:get();
    local v378 = v371.desync_max:get();
    local v379 = v371.desync_from:get();
    local v380 = v371.desync_to:get();
    local v381 = v371.desync_range_from:get();
    local v382 = v371.desync_speed_to:get();
    local v383 = v371.desync_mode:get();
    local v384 = v371.desync_delay:get();
    local v385 = v371.desync_multiplier:get();
    local v386 = v371.desync_tweaks:get();
    local v387 = v371.desync_inverter:get();
    if v372 then
        v370.extract_desync.freestanding = v373 == 2 and "Peek fake" or v373 == 3 and "Peek real" or "Off";
        if v374 == 1 then
            v370.extract_desync.left_limit = v375;
            v370.extract_desync.right_limit = v376;
        elseif v374 == 2 then
            v370.extract_desync.left_limit = utils.random_int(0, 1) == 1 and v377 or v378;
            v370.extract_desync.right_limit = utils.random_int(0, 1) == 1 and v377 or v378;
        elseif v374 == 4 then
            v370.extract_desync.left_limit = math.sin(globals.curtime * v382) * v381;
            v370.extract_desync.right_limit = math.sin(globals.curtime * v382) * v381;
        else
            local v388 = globals.tickcount % 4 > 1;
            v370.extract_desync.left_limit = v388 and v379 or v380;
            v370.extract_desync.right_limit = v388 and v379 or v380;
        end;
        if v372 then
            if v383 == 1 then
                v370.extract_desync.switch = true;
            elseif v383 == 2 then
                v370.extract_desync.switch = globals.tickcount % v384 > 1;
            else
                v370.extract_desync.switch = utils.random_int(0, v385) == v385;
            end;
        end;
    else
        v370.extract_desync.switch = v372;
    end;
    v370.extract_desync.tweaks = v386;
    v370.extract_desync.inverter = v387;
end;
v337.hidden = function(_, v390)
    -- upvalues: v11 (ref), v123 (ref)
    local v391 = entity.get_game_rules().m_bWarmupPeriod == true;
    local v392 = get_aimbot_targets();
    local v393 = {
        Zero = 0, 
        ["Semi-Up"] = -49, 
        ["Semi-Down"] = 49, 
        Up = -89, 
        Down = 89, 
        Spectrum = math.map(math.abs(globals.realtime % 0.3 - 0.15), 0, 0.15, -89, 89), 
        Random = math.random(v11.antiaim[v123:condition()].snap_random:get(), v11.antiaim[v123:condition()].snap_random2:get()), 
        Offset = v11.antiaim[v123:condition()].snap_pitch_offset:get(), 
        Flick = globals.tickcount % 3 > 0 and v11.antiaim[v123:condition()].snap_pitch_from:get() or v11.antiaim[v123:condition()].snap_pitch_to:get()
    };
    local v394 = {
        Opposite = 180, 
        Sideways = globals.realtime % 0.2 >= 0.1 and 90 or -90, 
        Spin = -math.fmod(globals.curtime * (v11.antiaim[v123:condition()].snap_spin_speed:get() * 360), v11.antiaim[v123:condition()].snap_spin_range:get() * 2) + v11.antiaim[v123:condition()].snap_spin_range:get(), 
        Spectrum = math.map(math.abs(globals.realtime % 360 - 0.15), 0, 0.15, 0, globals.tickcount % 4 > 1 and -40 or 40), 
        Random = utils.random_float(v11.antiaim[v123:condition()].snap_yaw_random:get(), v11.antiaim[v123:condition()].snap_yaw_random2:get()), 
        Offset = v11.antiaim[v123:condition()].snap_offset:get(), 
        Distortion = math.sin(globals.curtime * v11.antiaim[v123:condition()].snap_distortion_speed:get()) * v11.antiaim[v123:condition()].snap_distortion_range:get(), 
        ["L&R"] = globals.realtime % 0.2 >= 0.1 and v11.antiaim[v123:condition()].snap_left_offset:get() or v11.antiaim[v123:condition()].snap_right_offset:get()
    };
    if not v11.antiaim[v123:condition()].snap:get() then
        v390.extract_yaw.snap = false;
        return;
    elseif v11.antiaim.manual_yaw:get() ~= "Disabled" and v11.antiaim.freestanding:get() and v11.antiaim[v123:condition()].snap_disablers:get(2) then
        return;
    elseif v11.antiaim.tweaks:get() == 1 and v391 then
        return;
    elseif v11.antiaim.tweaks:get() == 2 and #v392 == 0 then
        return;
    elseif v11.antiaim.tweaks:get() == 3 and (v391 or #v392 == 0) then
        return;
    else
        if v11.antiaim.force_break_lagcomp:get(v123:condition()) then
            if v11.antiaim[v123:condition()].snap_only_when_hittable:get() then
                if entity.get_threat(true) then
                    v390.extract_yaw.snap = true;
                    rage.antiaim:override_hidden_pitch(v393[v11.antiaim[v123:condition()].snap_pitch:get()]);
                    rage.antiaim:override_hidden_yaw_offset(v394[v11.antiaim[v123:condition()].snap_yaw:get()]);
                else
                    v390.extract_yaw.snap = false;
                end;
            else
                v390.extract_yaw.snap = true;
                rage.antiaim:override_hidden_pitch(v393[v11.antiaim[v123:condition()].snap_pitch:get()]);
                rage.antiaim:override_hidden_yaw_offset(v394[v11.antiaim[v123:condition()].snap_yaw:get()]);
            end;
        end;
        return;
    end;
end;
do
    local l_v338_0 = v338;
    v337.update = function(_, _)
        -- upvalues: l_v338_0 (ref), v337 (ref)
        local v398 = entity.get_local_player();
        if not v398 or v398 == nil or not v398:is_alive() then
            return;
        else
            l_v338_0:tick();
            v337:yaw(l_v338_0);
            v337:yaw_modifier(l_v338_0);
            v337:body_yaw(l_v338_0);
            v337:hidden(l_v338_0);
            l_v338_0:run();
            return;
        end;
    end;
end;
v338 = {};
local v399 = v123:new("tweaks", 6);
do
    local l_v399_0 = v399;
    v338.update = function(_)
        -- upvalues: v11 (ref), l_v399_0 (ref)
        local v402 = entity.get_local_player();
        if not v402 or not v402:is_alive() then
            return;
        else
            local v403 = entity.get_game_rules().m_bWarmupPeriod == true;
            local v404 = get_aimbot_targets();
            local v405 = v11.antiaim.disabler_pitch:get();
            local v406 = v11.antiaim.disabler_yaw:get();
            local v407 = v11.antiaim.disabler_speed:get();
            local v408 = v11.antiaim.disabler_range:get();
            local v409 = v11.antiaim.disabler_left_offset:get();
            local v410 = v11.antiaim.disabler_right_offset:get();
            if v11.antiaim.tweaks:get() == 0 then
                return;
            else
                l_v399_0:tick();
                if v11.antiaim.tweaks:get() == 1 and v403 then
                    l_v399_0.pitch = v405;
                    if v406 == "Spin" then
                        l_v399_0.extract_yaw.offset = -math.fmod(globals.curtime * (v407 * 360), v408 * 2) + v408;
                    elseif v406 == "Distortion" then
                        l_v399_0.extract_yaw.offset = math.sin(globals.curtime * v407) * v408;
                    else
                        l_v399_0.extract_yaw.offset = globals.realtime % 0.2 >= 0.1 and v409 or v410;
                    end;
                    l_v399_0.extract_desync.switch = false;
                    l_v399_0.extract_modifier.mode = "Disabled";
                elseif v11.antiaim.tweaks:get() == 2 and #v404 == 0 then
                    l_v399_0.pitch = v405;
                    if v406 == "Spin" then
                        l_v399_0.extract_yaw.offset = -math.fmod(globals.curtime * (v407 * 360), v408 * 2) + v408;
                    elseif v406 == "Distortion" then
                        l_v399_0.extract_yaw.offset = math.sin(globals.curtime * v407) * v408;
                    else
                        l_v399_0.extract_yaw.offset = globals.realtime % 0.2 >= 0.1 and v409 or v410;
                    end;
                    l_v399_0.extract_desync.switch = false;
                    l_v399_0.extract_modifier.mode = "Disabled";
                elseif v11.antiaim.tweaks:get() == 3 and (v403 or #v404 == 0) then
                    l_v399_0.pitch = v405;
                    if v406 == "Spin" then
                        l_v399_0.extract_yaw.offset = -math.fmod(globals.curtime * (v407 * 360), v408 * 2) + v408;
                    elseif v406 == "Distortion" then
                        l_v399_0.extract_yaw.offset = math.sin(globals.curtime * v407) * v408;
                    else
                        l_v399_0.extract_yaw.offset = globals.realtime % 0.2 >= 0.1 and v409 or v410;
                    end;
                    l_v399_0.extract_desync.switch = false;
                    l_v399_0.extract_modifier.mode = "Disabled";
                else
                    return;
                end;
                l_v399_0:run();
                return;
            end;
        end;
    end;
end;
v399 = {};
local v411 = v123:new("freestanding", 9);
v399.update = function(_)
    -- upvalues: v11 (ref), v123 (ref), v9 (ref)
    local v413 = entity.get_local_player();
    if not v413 or v413 == nil or not v413:is_alive() then
        return;
    else
        local v414 = v11.antiaim.manual_yaw:get();
        if v11.antiaim.freestand_disablers:get(v123:freestanding_states()) then
            v9.antiaim.angles.extract_freestanding.switch:set(false);
            return;
        else
            if v414 == "Disabled" and v11.antiaim.freestanding:get() then
                v9.antiaim.angles.extract_freestanding.switch:set(true);
                if v11.antiaim.freestand_modifiers:get() == 1 then
                    v9.antiaim.angles.extract_freestanding.disable_jitter:override(true);
                    v9.antiaim.angles.extract_freestanding.body:override(false);
                elseif v11.antiaim.freestand_modifiers:get() == 2 then
                    v9.antiaim.angles.extract_freestanding.disable_jitter:override(false);
                    v9.antiaim.angles.extract_freestanding.body:override(true);
                elseif v11.antiaim.freestand_modifiers:get() == 3 then
                    v9.antiaim.angles.extract_freestanding.disable_jitter:override(true);
                    v9.antiaim.angles.extract_freestanding.body:override(true);
                else
                    v9.antiaim.angles.extract_freestanding.disable_jitter:override(false);
                    v9.antiaim.angles.extract_freestanding.body:override(false);
                end;
            else
                v9.antiaim.angles.extract_freestanding.switch:set(false);
            end;
            return;
        end;
    end;
end;
v411 = {};
local v415 = v123:new("manual_direction", 2);
local v416 = {
    Forward = 180, 
    Right = 90, 
    Left = -90
};
v411.working = false;
do
    local l_v415_0, l_v416_0 = v415, v416;
    v411.update = function(_)
        -- upvalues: v11 (ref), l_v416_0 (ref), v411 (ref), l_v415_0 (ref)
        local v420 = entity.get_local_player();
        if not v420 or v420 == nil or not v420:is_alive() then
            return;
        else
            local v421 = v11.antiaim.manual_yaw:get();
            local v422 = l_v416_0[v421];
            v411.working = v421 ~= "Disabled";
            l_v415_0:tick();
            if v422 and v421 ~= "Disabled" then
                if v11.antiaim.block_jitter:get() then
                    l_v415_0.extract_desync.tweaks = {};
                    l_v415_0.extract_desync.left_limit = 60;
                    l_v415_0.extract_desync.right_limit = 60;
                    l_v415_0.extract_modifier.mode = "Disabled";
                    rage.antiaim:inverter(true);
                end;
                l_v415_0.extract_yaw.yaw = "Backward";
                l_v415_0.extract_yaw.offset = v422;
                l_v415_0.extract_yaw.base = "Local view";
            end;
            l_v415_0:run();
            return;
        end;
    end;
end;
v415 = {
    think = function(_, _)
        -- upvalues: v9 (ref), v11 (ref)
        v9.antiaim.angles.extract_yaw.avoid_backstab:override(v11.antiaim.avoid_backstab:get() and true or nil);
    end
};
v416 = {
    update = function(_)

    end
};
events.createmove:set(function(v426)
    -- upvalues: v337 (ref), v415 (ref)
    v337:update(v426);
    v415:think(v426);
end);
events.createmove:set(v338.update);
events.createmove:set(v399.update);
events.createmove:set(v411.update);
events.createmove:set(v319.update);
events.createmove:set(v416.update);
events.createmove:set(function(v427)
    -- upvalues: v11 (ref), v123 (ref), v9 (ref)
    local v428 = entity.get_local_player();
    if not v428 or v428 == nil or not v428:is_alive() then
        return;
    else
        local _ = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit");
        local l_force_break_lagcomp_0 = v11.antiaim.force_break_lagcomp;
        local v431 = v11.antiaim[v123:condition()].choke_method:get();
        if rage.exploit:get() > 0 then
            local v432 = nil;
            local v433 = {};
            if l_force_break_lagcomp_0:get(v123:condition()) then
                v9.rage.main.dt_lag:override("Always on");
                if v11.antiaim[v123:condition()].neverlose_mode:get() == 1 then
                    if v11.antiaim[v123:condition()].random_choke:get() then
                        if v431 == 1 then
                            v432 = math.random(v11.antiaim[v123:condition()].choke_slider:get(), v11.antiaim[v123:condition()].choke_slider2:get());
                            v427.force_defensive = v427.command_number % v432 == 0;
                        elseif v431 == 2 then
                            for v434 = 1, v11.antiaim[v123:condition()].choke_numbers:get() do
                                table.insert(v433, v11.antiaim[v123:condition()]["tickbase_" .. v434]:get());
                            end;
                            v432 = v433[math.random(1, v11.antiaim[v123:condition()].choke_numbers:get())];
                            v427.force_defensive = v427.command_number % v432 == 0;
                        end;
                    else
                        v427.force_defensive = v427.command_number % v11.antiaim[v123:condition()].ticks_to:get() == 0;
                    end;
                    v9.rage.main.dt_lag:override("On Peek");
                else
                    v427.force_defensive = false;
                end;
            else
                v9.rage.main.dt_lag:override("On Peek");
            end;
        end;
        v9.rage.main.hs_lag:set(v11.antiaim.hs_mode:get());
        return;
    end;
end);
math.difference = function(v435, v436)
    return math.abs(v435 - v436);
end;
math.color_lerp = function(v437, v438, v439)
    local v440 = globals.frametime * 100;
    return v437:lerp(v438, v439 * math.min(v440, math.max_lerp_low_fps));
end;
math.max_lerp_low_fps = 2.2222222222222223;
math.lerp = function(v441, v442, v443)
    if v441 == v442 then
        return v442;
    else
        v443 = v443 * (globals.frametime * 170);
        local v444 = v441 + (v442 - v441) * v443;
        if math.abs(v444 - v442) < 0.01 then
            return v442;
        else
            return v444;
        end;
    end;
end;
math.normalize_yaw = math.normalize_yaw;
local _ = {
    data = {}
};
local v446 = {
    base_speed = 0.095, 
    _list = {}
};
v446.new = function(v447, v448, v449, v450)
    -- upvalues: v11 (ref), v446 (ref)
    if v11.other.scope_extra:get(3) then
        if not v449 then
            v449 = 1;
        end;
    elseif not v449 then
        v449 = 0.095;
    end;
    local v451 = type(v448) == "userdata";
    if v446._list[v447] == nil then
        v446._list[v447] = v450 and v450 or v451 and colors.white or 0;
    end;
    local v452 = nil;
    if v451 then
        v452 = math.color_lerp;
    else
        v452 = math.lerp;
    end;
    v446._list[v447] = v452(v446._list[v447], v448, v449);
    return v446._list[v447];
end;
getmetatable(color()).override = function(v453, v454, v455)
    local v456 = v453:clone();
    v456[v454] = v455;
    return v456;
end;
local function v470()
    -- upvalues: v11 (ref), v446 (ref)
    local v457 = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay");
    local v458 = v11.other.custom_scope_overlay:get();
    local v459 = v11.other.scope_extra:get(1);
    local v460 = v11.other.scope_extra:get(2);
    local v461 = v11.other.scope_size:get();
    local v462 = v11.other.scope_gap:get();
    local v463 = v11.other.scope_color:get();
    if v458 then
        v457:override("Remove All");
    else
        v457:override();
    end;
    local v464 = entity.get_local_player();
    if v464 == nil then
        return;
    else
        local v465 = v464:get_player_weapon();
        if v465 == nil then
            return;
        else
            local l_m_bIsScoped_0 = v464.m_bIsScoped;
            local v467 = {
                main = v446.new("scope_overlay", v458 and l_m_bIsScoped_0 and 1 or 0), 
                default = v446.new("scope_overlay_default", (not (v458 and l_m_bIsScoped_0) or v459) and 0 or 255), 
                inverted = v446.new("scope_overlay_inverted", v458 and l_m_bIsScoped_0 and v459 and 255 or 0), 
                rotated = v446.new("scope_overlay_rotated", v460 and 45 or 0), 
                spread = spread_dependensy and v446.new("scope_overlay_spread_dependensy", v465:get_inaccuracy() * 75) + v462 or v462
            };
            local v468 = {
                v463:override("a", v467.default), 
                v463:override("a", v467.inverted)
            };
            v461 = v461 * v467.main;
            local v469 = render.screen_size() / 2;
            if v467.rotated ~= 0 then
                render.push_rotation(v467.rotated, render.screen_size() / 2);
            end;
            render.gradient(v469 - vector(-1, v461 + v467.spread), v469 - vector(0, v467.spread), v468[2], v468[2], v468[1], v468[1]);
            render.gradient(v469 + vector(1, v461 + v467.spread), v469 + vector(0, v467.spread), v468[2], v468[2], v468[1], v468[1]);
            render.gradient(v469 + vector(v461 + v467.spread, 1), v469 + vector(v467.spread, 0), v468[2], v468[1], v468[2], v468[1]);
            render.gradient(v469 - vector(v461 + v467.spread, -1), v469 - vector(v467.spread, 0), v468[2], v468[1], v468[2], v468[1]);
            if v467.rotated ~= 0 then
                render.pop_rotation();
            end;
            return;
        end;
    end;
end;
events.render:set(v470);
events.shutdown:set(function()
    ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"):override();
end);
local v471 = {};
local function v474(v472, v473)
    return (math.abs((math.sin(globals.realtime * (v473 or 1) % math.pi + (v472 or 0)))));
end;
local function v476(v475)
    while v475 > 1 do
        v475 = v475 - 1;
    end;
    while v475 < 0 do
        v475 = v475 + 1;
    end;
    return v475;
end;
do
    local l_v474_0, l_v476_0 = v474, v476;
    v471.update = function()
        -- upvalues: v11 (ref), l_v474_0 (ref), l_v476_0 (ref)
        if not globals.is_in_game or v11.home.watermark_input:get() == "" then
            return;
        else
            local v479 = #v11.home.watermark_input:get() + 1;
            local v480 = v11.home.watermark_input:get();
            local v481 = render.screen_size() / 2;
            local v482 = v11.home.watermark_font:get();
            local v483 = vector(v481.x, v481.y * 2 - 10);
            local v484 = "c";
            local _ = v480;
            local _ = v479;
            local _ = l_v474_0;
            local _ = l_v476_0;
            local v489 = "";
            local _, _, v492 = color(255, 255, 255, 255):to_hsv();
            if v11.home.watermark_gradient:get() == 1 then
                for v493 = 1, v479 do
                    local v494 = v480:sub(v493, v493);
                    local v495 = l_v474_0((v493 - 1) / v479 * 2, v11.home.watermark_gradient_speed:get());
                    local v496 = 0.5;
                    local v497 = nil;
                    if v11.home.watermark_gradient_rainbow:get() == 1 then
                        v497 = (v493 - 1) / v479;
                    else
                        v497 = v11.home.watermark_gradient_hue:get() / 10;
                    end;
                    local v498 = v11.home.watermark_gradient_saturation:get() / 10;
                    local v499 = color():as_hsv(v497, v498, v492 * (v496 + (1 - v496) * (1 - v495))):to_hex();
                    if v493 == 1 then
                        CLR = v499;
                    end;
                    v489 = v489 .. string.format("\a%s%s", v499, v494);
                end;
                render.text(v482, v483, color(), v484, v489);
            else
                render.text(v482, v483, v11.home.watermark_accent:get(), v484, v480);
            end;
            return;
        end;
    end;
end;
events.render:set(v471.update);
v474 = {};
v476 = 0;
do
    local l_v476_1 = v476;
    v474.update = function(_)
        -- upvalues: v11 (ref), l_v476_1 (ref), v8 (ref)
        local v502 = entity.get_local_player();
        if v502 == nil then
            return;
        elseif v502.m_lifeState ~= 0 then
            return;
        else
            if v11.other.debug_text:get() then
                l_v476_1 = 0;
                screen = render.screen_size();
                for _, v504 in next, v8 do
                    render.text(1, vector(screen.x / 2 + 450, 15 + l_v476_1), color(255, 255, 255, 255), "", tostring(v504));
                    l_v476_1 = l_v476_1 + 15;
                end;
            end;
            return;
        end;
    end;
end;
events.render:set(v474.update);
v476 = false;
local v505 = 1;
local v506 = 0.25;
local v507 = 0.25;
local function v512(v508)
    -- upvalues: v476 (ref), v506 (ref), v507 (ref), v505 (ref)
    if entity.get_local_player() == entity.get(v508.attacker, true) then
        local v509 = true;
        local v510 = 0.25;
        local v511 = 0.25;
        v505 = 1;
        v507 = v511;
        v506 = v510;
        v476 = v509;
    end;
end;
local function v517(v513)
    -- upvalues: v506 (ref), v507 (ref), v505 (ref), v476 (ref)
    if entity.get_local_player() == entity.get(v513.userid, true) then
        local v514 = 0.25;
        local v515 = 0.5;
        local v516 = 1;
        v476 = false;
        v505 = v516;
        v507 = v515;
        v506 = v514;
    end;
end;
local function v522()
    -- upvalues: v11 (ref), v476 (ref), v507 (ref), v505 (ref), v506 (ref)
    if not v11.other.hitmarkers:get(1) or not globals.is_in_game then
        return;
    else
        if v476 then
            local v518 = render.screen_size();
            v507 = v507 - globals.frametime;
            if v507 <= 0 then
                v505 = v505 - globals.frametime / v506;
            end;
            local v519 = v518.x / 2;
            local v520 = v518.y / 2;
            local v521 = color(255, 255, 255, 255 * v505);
            render.line(vector(v519 + 5, v520 + 5), vector(v519 + 10, v520 + 10), v521);
            render.line(vector(v519 - 5, v520 + 5), vector(v519 - 10, v520 + 10), v521);
            render.line(vector(v519 - 5, v520 - 5), vector(v519 - 10, v520 - 10), v521);
            render.line(vector(v519 + 5, v520 - 5), vector(v519 + 10, v520 - 10), v521);
        end;
        return;
    end;
end;
local v523 = {};
local _ = 0.5;
local _ = 1;
local function v542()
    -- upvalues: v11 (ref), v523 (ref), v506 (ref)
    if not v11.other.hitmarkers:get(2) then
        return;
    else
        for v526, v527 in pairs(v523) do
            if v527.FadeTime <= 0 then
                v523[v526] = nil;
            else
                v527.WaitTime = v527.WaitTime - globals.frametime;
                if v527.WaitTime <= 0 then
                    v527.FadeTime = v527.FadeTime - globals.frametime / v506;
                end;
                if v527.Position and not v527.Reason then
                    local v528 = render.world_to_screen(vector(v527.Position.x, v527.Position.y, v527.Position.z));
                    local v529 = v11.other.kibit_colorx:get();
                    local l_r_0 = v529.r;
                    local l_g_0 = v529.g;
                    local l_b_0 = v529.b;
                    local v533 = v529.a or 255;
                    local v534 = v11.other.kibit_colory:get();
                    local l_r_1 = v534.r;
                    local l_g_1 = v534.g;
                    local l_b_1 = v534.b;
                    local v538 = v534.a or 255;
                    if v528 then
                        local l_x_0 = v528.x;
                        local l_y_0 = v528.y;
                        local _ = render.screen_size();
                        render.rect(vector(l_x_0 - 1, l_y_0 - 5), vector(l_x_0 + 1, l_y_0 + 5), color(l_r_1, l_g_1, l_b_1, v538 * v527.FadeTime), 0, true);
                        render.rect(vector(l_x_0 - 5, l_y_0 - 1), vector(l_x_0 + 5, l_y_0 + 1), color(l_r_0, l_g_0, l_b_0, v533 * v527.FadeTime), 0, true);
                    end;
                end;
            end;
        end;
        return;
    end;
end;
local function v544(v543)
    -- upvalues: v523 (ref), v507 (ref)
    v523[v543.id] = {
        FadeTime = 1, 
        Position = v543.aim, 
        WaitTime = v507, 
        Reason = v543.state
    };
end;
events.aim_ack:set(v544);
events.round_start:set(function()
    -- upvalues: v476 (ref), v505 (ref), v506 (ref), v507 (ref), v523 (ref)
    local v545 = false;
    local v546 = 1;
    local v547 = 0.25;
    local v548 = 0.25;
    v523 = {};
    v507 = v548;
    v506 = v547;
    v505 = v546;
    v476 = v545;
end);
events.player_spawned:set(function(v549)
    -- upvalues: v517 (ref), v523 (ref)
    v517(v549);
    v523 = {};
end);
events.render:set(v542);
events.render:set(v522);
events.player_hurt:set(v512);
local v550 = {};
local v551 = 40;
local v552 = color(0, 0, 0, 127);
do
    local l_v551_0 = v551;
    v550.render = function()
        -- upvalues: v11 (ref), l_v551_0 (ref)
        local v554 = entity.get_local_player();
        if v554 == nil or not v554:is_alive() then
            return;
        elseif not v11.other.manual_arrows:get() then
            return;
        else
            local v555 = v11.antiaim.manual_yaw:get();
            local v556 = v11.other.manual_arrows_clr:get() or color(255, 255, 255, 255);
            local v557 = v11.other.manual_arrows_font:get();
            local v558 = render.screen_size() * 0.5;
            local v559, v560, v561 = v556:to_hsv();
            local v562 = math.abs(math.sin(globals.realtime * 2));
            local v563 = color():as_hsv(v559, v560, v561 * (0.5 + 0.5 * v562));
            if v555 == "Left" then
                local v564 = v11.other.manual_arrows_left:get();
                local v565 = render.measure_text(v557, "c", v564);
                local v566 = vector(v558.x - v565.x - l_v551_0 + 1, v558.y - v565.y * 0.5 + 5);
                render.text(v557, v566, v563, "c", v564);
            end;
            if v555 == "Right" then
                local v567 = v11.other.manual_arrows_right:get();
                local v568 = render.measure_text(v557, "c", v567);
                local v569 = vector(v558.x + l_v551_0, v558.y - v568.y * 0.5 + 5);
                render.text(v557, v569, v563, "c", v567);
            end;
            if v555 == "Forward" then
                local v570 = v11.other.manual_arrows_forward:get();
                local v571 = render.measure_text(v557, "c", v570);
                local v572 = vector(v558.x, v558.y - v571.y * 0.5 - 15);
                render.text(v557, v572, v563, "c", v570);
            end;
            return;
        end;
    end;
end;
events.render:set(v550.render);
v551 = "Nyanza";
v552 = "paw";
local v573 = #v551 + 1;
local function v576(v574, v575)
    return (math.abs((math.sin(globals.realtime * (v575 or 1) % math.pi + (v574 or 0)))));
end;
local function v578(v577)
    while v577 > 1 do
        v577 = v577 - 1;
    end;
    while v577 < 0 do
        v577 = v577 + 1;
    end;
    return v577;
end;
local _ = v551;
local _ = v552;
local _ = v573;
local _ = v576;
local _ = v578;
events.render:set(function()
    -- upvalues: v11 (ref), v573 (ref), v551 (ref), v576 (ref), v552 (ref)
    if ui.get_alpha() <= 0 then
        return;
    else
        v11.home.load_line:set(math.sin(globals.curtime * 1) * 80);
        local v584 = "";
        local v585, v586, v587 = ui.get_style("Link Active"):to_hsv();
        for v588 = 1, v573 do
            local v589 = v551:sub(v588, v588);
            local v590 = v576((v588 - 1) / v573 * 2, 2);
            local v591 = 0.5;
            local v592 = color():as_hsv(v585, v586, v587 * (v591 + (1 - v591) * (1 - v590))):to_hex();
            if v588 == 1 then
                CLR = v592;
            end;
            v584 = v584 .. string.format("\a%s%s", v592, v589);
        end;
        ui.sidebar(v584, string.format("\a%s%s", CLR, ui.get_icon(v552)));
        return;
    end;
end);
local v641 = {
    init = function(v593)
        -- upvalues: l_pui_0 (ref), v11 (ref)
        v593.database = db.nyanza_classic1337 or {};
        v593.system_presets = {
            l_pui_0.string("Default  \v\239\129\181"), 
            l_pui_0.string("Delayed  \v\239\130\134"), 
            l_pui_0.string("Snappy  \v\239\130\134"), 
            l_pui_0.string("Snap  \v\239\130\134"), 
            l_pui_0.string("Aggressive  \v\239\129\181")
        };
        v593.separator = l_pui_0.string("\v\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128\226\148\128");
        if not v593.database[l_pui_0.string("Default  \v\239\129\181")] or #v593.database == 0 then
            v593.database[l_pui_0.string("Default  \v\239\129\181")] = "eyJhbnRpYWltIjp7Ilx1MDAwN3tMaW5rIEFjdGl2ZX3ui44gICAgXHUwMDA3REVGQVVMVFNuZWFraW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6Ny4wLCJjaG9rZV9zbGlkZXIyIjoxNi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjQuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjYwLjAsImRlc3luY19saW1pdF9tb2RlIjoxLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjo0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6MS4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21ldGhvZCI6MS4wLCJtb2RpZmllcl9taW5pbXVtX29mZnNldCI6MC4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOmZhbHNlLCJuZXZlcmxvc2VfbW9kZSI6MC4wLCJyYW5kb21fY2hva2UiOnRydWUsInNuYXAiOmZhbHNlLCJzbmFwX2Rpc2FibGVycyI6WyJ+Il0sInNuYXBfZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsInNuYXBfZGlzdG9ydGlvbl9zcGVlZCI6NS4wLCJzbmFwX2xlZnRfb2Zmc2V0IjowLjAsInNuYXBfb2Zmc2V0IjowLjAsInNuYXBfb25seV93aGVuX2hpdHRhYmxlIjp0cnVlLCJzbmFwX3BpdGNoIjoiVXAiLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTg5LjAsInNuYXBfcmFuZG9tMiI6ODkuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiT2Zmc2V0Iiwic25hcF95YXdfcmFuZG9tIjotMTgwLjAsInNuYXBfeWF3X3JhbmRvbTIiOjE4MC4wLCJ0aWNrYmFzZV8xIjoxNi4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrc190byI6MTYuMCwieWF3IjoxLjAsInlhd19kZWxheV9ib29sIjowLjAsInlhd19kZWxheV9tYXgiOjEwLjAsInlhd19kZWxheV9tZXRob2QiOjEuMCwieWF3X2RlbGF5X21pbiI6MS4wLCJ5YXdfZGVsYXlfbXVsdGlwbGllciI6Mi4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0yMi4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjQ0LjB9LCJcdTAwMDd7TGluayBBY3RpdmV97pOBICAgXHUwMDA3REVGQVVMVEZyZWVzdGFuZGluZyI6eyJjaG9rZV9tZXRob2QiOjEuMCwiY2hva2VfbnVtYmVycyI6Ni4wLCJjaG9rZV9zbGlkZXIiOjE2LjAsImNob2tlX3NsaWRlcjIiOjE2LjAsImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6Mi4wLCJkZWxheV8zIjoyLjAsImRlbGF5XzQiOjIuMCwiZGVsYXlfNSI6Mi4wLCJkZWxheV82IjoyLjAsImRlbGF5X251bWJlcnMiOjQuMCwiZGVzeW5jIjoxLjAsImRlc3luY19kZWxheSI6NC4wLCJkZXN5bmNfZnJlZXN0YW5kaW5nIjozLjAsImRlc3luY19mcm9tIjoyOC4wLCJkZXN5bmNfaW52ZXJ0ZXIiOmZhbHNlLCJkZXN5bmNfbGVmdCI6NjAuMCwiZGVzeW5jX2xpbWl0X21vZGUiOjEuMCwiZGVzeW5jX21heCI6NTguMCwiZGVzeW5jX21pbiI6MjguMCwiZGVzeW5jX21vZGUiOjEuMCwiZGVzeW5jX211bHRpcGxpZXIiOjQuMCwiZGVzeW5jX3JhbmdlX2Zyb20iOjU4LjAsImRlc3luY19yaWdodCI6NjAuMCwiZGVzeW5jX3NwZWVkX3RvIjo1LjAsImRlc3luY190byI6NTguMCwiZGVzeW5jX3R3ZWFrcyI6WyJBdm9pZCBPdmVybGFwIiwiSml0dGVyIiwifiJdLCJtb2RpZmllciI6MS4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21ldGhvZCI6MS4wLCJtb2RpZmllcl9taW5pbXVtX29mZnNldCI6MC4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOmZhbHNlLCJuZXZlcmxvc2VfbW9kZSI6MC4wLCJyYW5kb21fY2hva2UiOmZhbHNlLCJzbmFwIjpmYWxzZSwic25hcF9kaXNhYmxlcnMiOlsifiJdLCJzbmFwX2Rpc3RvcnRpb25fcmFuZ2UiOjE4MC4wLCJzbmFwX2Rpc3RvcnRpb25fc3BlZWQiOjUuMCwic25hcF9sZWZ0X29mZnNldCI6MC4wLCJzbmFwX29mZnNldCI6MC4wLCJzbmFwX29ubHlfd2hlbl9oaXR0YWJsZSI6ZmFsc2UsInNuYXBfcGl0Y2giOiJEb3duIiwic25hcF9waXRjaF9mcm9tIjotODkuMCwic25hcF9waXRjaF9vZmZzZXQiOjAuMCwic25hcF9waXRjaF90byI6ODkuMCwic25hcF9yYW5kb20iOi04OS4wLCJzbmFwX3JhbmRvbTIiOjg5LjAsInNuYXBfcmlnaHRfb2Zmc2V0IjowLjAsInNuYXBfc3Bpbl9yYW5nZSI6MTgwLjAsInNuYXBfc3Bpbl9zcGVlZCI6NS4wLCJzbmFwX3lhdyI6IlNpZGV3YXlzIiwic25hcF95YXdfcmFuZG9tIjotMTgwLjAsInNuYXBfeWF3X3JhbmRvbTIiOjE4MC4wLCJ0aWNrYmFzZV8xIjoxNi4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrc190byI6MTYuMCwieWF3IjoxLjAsInlhd19kZWxheV9ib29sIjowLjAsInlhd19kZWxheV9tYXgiOjEwLjAsInlhd19kZWxheV9tZXRob2QiOjEuMCwieWF3X2RlbGF5X21pbiI6MS4wLCJ5YXdfZGVsYXlfbXVsdGlwbGllciI6Mi4wLCJ5YXdfbGVmdF9vZmZzZXQiOjAuMCwieWF3X21vZGUiOjEuMCwieWF3X29mZnNldCI6Ni4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjowLjB9LCJcdTAwMDd7TGluayBBY3RpdmV97pWGICAgIFx1MDAwN0RFRkFVTFRBaXIiOnsiY2hva2VfbWV0aG9kIjoxLjAsImNob2tlX251bWJlcnMiOjYuMCwiY2hva2Vfc2xpZGVyIjo1LjAsImNob2tlX3NsaWRlcjIiOjE1LjAsImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6Mi4wLCJkZWxheV8zIjoyLjAsImRlbGF5XzQiOjIuMCwiZGVsYXlfNSI6Mi4wLCJkZWxheV82IjoyLjAsImRlbGF5X251bWJlcnMiOjQuMCwiZGVzeW5jIjoxLjAsImRlc3luY19kZWxheSI6NC4wLCJkZXN5bmNfZnJlZXN0YW5kaW5nIjoxLjAsImRlc3luY19mcm9tIjoyOC4wLCJkZXN5bmNfaW52ZXJ0ZXIiOmZhbHNlLCJkZXN5bmNfbGVmdCI6NjAuMCwiZGVzeW5jX2xpbWl0X21vZGUiOjEuMCwiZGVzeW5jX21heCI6NTguMCwiZGVzeW5jX21pbiI6MjguMCwiZGVzeW5jX21vZGUiOjEuMCwiZGVzeW5jX211bHRpcGxpZXIiOjQuMCwiZGVzeW5jX3JhbmdlX2Zyb20iOjU4LjAsImRlc3luY19yaWdodCI6NjAuMCwiZGVzeW5jX3NwZWVkX3RvIjo1LjAsImRlc3luY190byI6NTguMCwiZGVzeW5jX3R3ZWFrcyI6WyJKaXR0ZXIiLCJ+Il0sIm1vZGlmaWVyIjoxLjAsIm1vZGlmaWVyXzEiOjAuMCwibW9kaWZpZXJfMiI6MC4wLCJtb2RpZmllcl8zIjowLjAsIm1vZGlmaWVyXzQiOjAuMCwibW9kaWZpZXJfNSI6MC4wLCJtb2RpZmllcl82IjowLjAsIm1vZGlmaWVyX2ppdHRlcl9vZmZzZXQiOjAuMCwibW9kaWZpZXJfbWF4aW11bV9vZmZzZXQiOjExLjAsIm1vZGlmaWVyX21ldGhvZCI6MS4wLCJtb2RpZmllcl9taW5pbXVtX29mZnNldCI6LTExLjAsIm1vZGlmaWVyX251bWJlcnMiOjQuMCwibW9kaWZpZXJfcmFuZG9tX2ppdHRlciI6dHJ1ZSwibmV2ZXJsb3NlX21vZGUiOjAuMCwicmFuZG9tX2Nob2tlIjp0cnVlLCJzbmFwIjpmYWxzZSwic25hcF9kaXNhYmxlcnMiOlsifiJdLCJzbmFwX2Rpc3RvcnRpb25fcmFuZ2UiOjE4MC4wLCJzbmFwX2Rpc3RvcnRpb25fc3BlZWQiOjUuMCwic25hcF9sZWZ0X29mZnNldCI6MC4wLCJzbmFwX29mZnNldCI6MC4wLCJzbmFwX29ubHlfd2hlbl9oaXR0YWJsZSI6ZmFsc2UsInNuYXBfcGl0Y2giOiJEb3duIiwic25hcF9waXRjaF9mcm9tIjotODkuMCwic25hcF9waXRjaF9vZmZzZXQiOjAuMCwic25hcF9waXRjaF90byI6ODkuMCwic25hcF9yYW5kb20iOi04OS4wLCJzbmFwX3JhbmRvbTIiOjg5LjAsInNuYXBfcmlnaHRfb2Zmc2V0IjowLjAsInNuYXBfc3Bpbl9yYW5nZSI6MTgwLjAsInNuYXBfc3Bpbl9zcGVlZCI6NS4wLCJzbmFwX3lhdyI6IlNpZGV3YXlzIiwic25hcF95YXdfcmFuZG9tIjotMTgwLjAsInNuYXBfeWF3X3JhbmRvbTIiOjE4MC4wLCJ0aWNrYmFzZV8xIjoxNi4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrc190byI6MTYuMCwieWF3IjoxLjAsInlhd19kZWxheV9ib29sIjowLjAsInlhd19kZWxheV9tYXgiOjEwLjAsInlhd19kZWxheV9tZXRob2QiOjEuMCwieWF3X2RlbGF5X21pbiI6MS4wLCJ5YXdfZGVsYXlfbXVsdGlwbGllciI6Mi4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0yOS4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjM1LjB9LCJcdTAwMDd7TGluayBBY3RpdmV97pWHICBcdTAwMDdERUZBVUxUQWlyIENyb3VjaGluZyI6eyJjaG9rZV9tZXRob2QiOjEuMCwiY2hva2VfbnVtYmVycyI6Ni4wLCJjaG9rZV9zbGlkZXIiOjUuMCwiY2hva2Vfc2xpZGVyMiI6MTUuMCwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwiZGVsYXlfbnVtYmVycyI6NC4wLCJkZXN5bmMiOjEuMCwiZGVzeW5jX2RlbGF5IjoxNC4wLCJkZXN5bmNfZnJlZXN0YW5kaW5nIjoxLjAsImRlc3luY19mcm9tIjoyOC4wLCJkZXN5bmNfaW52ZXJ0ZXIiOmZhbHNlLCJkZXN5bmNfbGVmdCI6NjAuMCwiZGVzeW5jX2xpbWl0X21vZGUiOjEuMCwiZGVzeW5jX21heCI6NTguMCwiZGVzeW5jX21pbiI6MjguMCwiZGVzeW5jX21vZGUiOjEuMCwiZGVzeW5jX211bHRpcGxpZXIiOjE0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6MS4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjoyMi4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi0yMi4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjowLjAsInJhbmRvbV9jaG9rZSI6dHJ1ZSwic25hcCI6ZmFsc2UsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOmZhbHNlLCJzbmFwX3BpdGNoIjoiRG93biIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJTaWRld2F5cyIsInNuYXBfeWF3X3JhbmRvbSI6LTE4MC4wLCJzbmFwX3lhd19yYW5kb20yIjoxODAuMCwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjE2LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MC4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjoxLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjIuMCwieWF3X2xlZnRfb2Zmc2V0IjotMTguMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0Ijo0NC4wfSwiXHUwMDA3e0xpbmsgQWN0aXZlfe+GgyAgICAgXHUwMDA3REVGQVVMVFN0YW5kaW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6MTYuMCwiY2hva2Vfc2xpZGVyMiI6MTYuMCwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwiZGVsYXlfbnVtYmVycyI6NC4wLCJkZXN5bmMiOjEuMCwiZGVzeW5jX2RlbGF5Ijo0LjAsImRlc3luY19mcmVlc3RhbmRpbmciOjEuMCwiZGVzeW5jX2Zyb20iOjI4LjAsImRlc3luY19pbnZlcnRlciI6ZmFsc2UsImRlc3luY19sZWZ0Ijo2MC4wLCJkZXN5bmNfbGltaXRfbW9kZSI6MS4wLCJkZXN5bmNfbWF4Ijo1OC4wLCJkZXN5bmNfbWluIjoyOC4wLCJkZXN5bmNfbW9kZSI6MS4wLCJkZXN5bmNfbXVsdGlwbGllciI6NC4wLCJkZXN5bmNfcmFuZ2VfZnJvbSI6NTguMCwiZGVzeW5jX3JpZ2h0Ijo2MC4wLCJkZXN5bmNfc3BlZWRfdG8iOjUuMCwiZGVzeW5jX3RvIjo1OC4wLCJkZXN5bmNfdHdlYWtzIjpbIkppdHRlciIsIn4iXSwibW9kaWZpZXIiOjQuMCwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfaml0dGVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9tYXhpbXVtX29mZnNldCI6NS4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi01LjAsIm1vZGlmaWVyX251bWJlcnMiOjQuMCwibW9kaWZpZXJfcmFuZG9tX2ppdHRlciI6dHJ1ZSwibmV2ZXJsb3NlX21vZGUiOjAuMCwicmFuZG9tX2Nob2tlIjpmYWxzZSwic25hcCI6ZmFsc2UsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOmZhbHNlLCJzbmFwX3BpdGNoIjoiRmxpY2siLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTg5LjAsInNuYXBfcmFuZG9tMiI6ODkuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiUmFuZG9tIiwic25hcF95YXdfcmFuZG9tIjotMTgwLjAsInNuYXBfeWF3X3JhbmRvbTIiOjE4MC4wLCJ0aWNrYmFzZV8xIjoxNi4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrc190byI6Ny4wLCJ5YXciOjEuMCwieWF3X2RlbGF5X2Jvb2wiOjAuMCwieWF3X2RlbGF5X21heCI6MTAuMCwieWF3X2RlbGF5X21ldGhvZCI6MS4wLCJ5YXdfZGVsYXlfbWluIjoxLjAsInlhd19kZWxheV9tdWx0aXBsaWVyIjoyLjAsInlhd19sZWZ0X29mZnNldCI6LTI0LjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6NDEuMH0sIlx1MDAwN3tMaW5rIEFjdGl2ZX3vhpMgICBcdTAwMDdERUZBVUxUQ3JvdWNoaW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6NS4wLCJjaG9rZV9zbGlkZXIyIjoxNi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjMuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjYwLjAsImRlc3luY19saW1pdF9tb2RlIjozLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjoxNi4wLCJkZXN5bmNfcmFuZ2VfZnJvbSI6NTguMCwiZGVzeW5jX3JpZ2h0Ijo2MC4wLCJkZXN5bmNfc3BlZWRfdG8iOjUuMCwiZGVzeW5jX3RvIjo1OC4wLCJkZXN5bmNfdHdlYWtzIjpbIkppdHRlciIsIn4iXSwibW9kaWZpZXIiOjEuMCwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfaml0dGVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9tYXhpbXVtX29mZnNldCI6MjIuMCwibW9kaWZpZXJfbWV0aG9kIjoxLjAsIm1vZGlmaWVyX21pbmltdW1fb2Zmc2V0IjotMjIuMCwibW9kaWZpZXJfbnVtYmVycyI6NC4wLCJtb2RpZmllcl9yYW5kb21faml0dGVyIjp0cnVlLCJuZXZlcmxvc2VfbW9kZSI6MC4wLCJyYW5kb21fY2hva2UiOmZhbHNlLCJzbmFwIjpmYWxzZSwic25hcF9kaXNhYmxlcnMiOlsifiJdLCJzbmFwX2Rpc3RvcnRpb25fcmFuZ2UiOjE4MC4wLCJzbmFwX2Rpc3RvcnRpb25fc3BlZWQiOjUuMCwic25hcF9sZWZ0X29mZnNldCI6MC4wLCJzbmFwX29mZnNldCI6MC4wLCJzbmFwX29ubHlfd2hlbl9oaXR0YWJsZSI6ZmFsc2UsInNuYXBfcGl0Y2giOiJEb3duIiwic25hcF9waXRjaF9mcm9tIjotODkuMCwic25hcF9waXRjaF9vZmZzZXQiOjAuMCwic25hcF9waXRjaF90byI6ODkuMCwic25hcF9yYW5kb20iOi04OS4wLCJzbmFwX3JhbmRvbTIiOjg5LjAsInNuYXBfcmlnaHRfb2Zmc2V0IjowLjAsInNuYXBfc3Bpbl9yYW5nZSI6MTgwLjAsInNuYXBfc3Bpbl9zcGVlZCI6NS4wLCJzbmFwX3lhdyI6IlNpZGV3YXlzIiwic25hcF95YXdfcmFuZG9tIjotMTgwLjAsInNuYXBfeWF3X3JhbmRvbTIiOjE4MC4wLCJ0aWNrYmFzZV8xIjoxNi4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrc190byI6MTYuMCwieWF3IjoxLjAsInlhd19kZWxheV9ib29sIjowLjAsInlhd19kZWxheV9tYXgiOjEwLjAsInlhd19kZWxheV9tZXRob2QiOjEuMCwieWF3X2RlbGF5X21pbiI6MS4wLCJ5YXdfZGVsYXlfbXVsdGlwbGllciI6Mi4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0zMi4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0Ijo2LjAsInlhd19yaWdodF9vZmZzZXQiOjQ2LjB9LCJcdTAwMDd7TGluayBBY3RpdmV975WUICAgICBcdTAwMDdERUZBVUxUU2xvd2luZyI6eyJjaG9rZV9tZXRob2QiOjEuMCwiY2hva2VfbnVtYmVycyI6Ni4wLCJjaG9rZV9zbGlkZXIiOjQuMCwiY2hva2Vfc2xpZGVyMiI6MTYuMCwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwiZGVsYXlfbnVtYmVycyI6NC4wLCJkZXN5bmMiOjEuMCwiZGVzeW5jX2RlbGF5Ijo0LjAsImRlc3luY19mcmVlc3RhbmRpbmciOjEuMCwiZGVzeW5jX2Zyb20iOjI4LjAsImRlc3luY19pbnZlcnRlciI6ZmFsc2UsImRlc3luY19sZWZ0Ijo2MC4wLCJkZXN5bmNfbGltaXRfbW9kZSI6Mi4wLCJkZXN5bmNfbWF4Ijo1OC4wLCJkZXN5bmNfbWluIjoyOC4wLCJkZXN5bmNfbW9kZSI6MS4wLCJkZXN5bmNfbXVsdGlwbGllciI6NC4wLCJkZXN5bmNfcmFuZ2VfZnJvbSI6NTguMCwiZGVzeW5jX3JpZ2h0Ijo2MC4wLCJkZXN5bmNfc3BlZWRfdG8iOjUuMCwiZGVzeW5jX3RvIjo1OC4wLCJkZXN5bmNfdHdlYWtzIjpbIkppdHRlciIsIn4iXSwibW9kaWZpZXIiOjEuMCwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfaml0dGVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9tYXhpbXVtX29mZnNldCI6MTAuMCwibW9kaWZpZXJfbWV0aG9kIjoxLjAsIm1vZGlmaWVyX21pbmltdW1fb2Zmc2V0IjotMTAuMCwibW9kaWZpZXJfbnVtYmVycyI6NC4wLCJtb2RpZmllcl9yYW5kb21faml0dGVyIjp0cnVlLCJuZXZlcmxvc2VfbW9kZSI6MC4wLCJyYW5kb21fY2hva2UiOnRydWUsInNuYXAiOmZhbHNlLCJzbmFwX2Rpc2FibGVycyI6WyJ+Il0sInNuYXBfZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsInNuYXBfZGlzdG9ydGlvbl9zcGVlZCI6NS4wLCJzbmFwX2xlZnRfb2Zmc2V0IjowLjAsInNuYXBfb2Zmc2V0IjowLjAsInNuYXBfb25seV93aGVuX2hpdHRhYmxlIjpmYWxzZSwic25hcF9waXRjaCI6IkRvd24iLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTg5LjAsInNuYXBfcmFuZG9tMiI6ODkuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiU2lkZXdheXMiLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tzX3RvIjoxNi4wLCJ5YXciOjEuMCwieWF3X2RlbGF5X2Jvb2wiOjAuMCwieWF3X2RlbGF5X21heCI6MTAuMCwieWF3X2RlbGF5X21ldGhvZCI6MS4wLCJ5YXdfZGVsYXlfbWluIjoxLjAsInlhd19kZWxheV9tdWx0aXBsaWVyIjoyLjAsInlhd19sZWZ0X29mZnNldCI6LTIyLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6NDQuMH0sIlx1MDAwN3tMaW5rIEFjdGl2ZX3vnIwgICAgXHUwMDA3REVGQVVMVFJ1bm5pbmciOnsiY2hva2VfbWV0aG9kIjoxLjAsImNob2tlX251bWJlcnMiOjYuMCwiY2hva2Vfc2xpZGVyIjo3LjAsImNob2tlX3NsaWRlcjIiOjIyLjAsImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6Mi4wLCJkZWxheV8zIjoyLjAsImRlbGF5XzQiOjIuMCwiZGVsYXlfNSI6Mi4wLCJkZWxheV82IjoyLjAsImRlbGF5X251bWJlcnMiOjQuMCwiZGVzeW5jIjoxLjAsImRlc3luY19kZWxheSI6MTMuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjYwLjAsImRlc3luY19saW1pdF9tb2RlIjoxLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjYwLjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjoxMy4wLCJkZXN5bmNfcmFuZ2VfZnJvbSI6NTguMCwiZGVzeW5jX3JpZ2h0Ijo2MC4wLCJkZXN5bmNfc3BlZWRfdG8iOjUuMCwiZGVzeW5jX3RvIjo1OC4wLCJkZXN5bmNfdHdlYWtzIjpbIkppdHRlciIsIn4iXSwibW9kaWZpZXIiOjEuMCwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfaml0dGVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9tYXhpbXVtX29mZnNldCI6MTAuMCwibW9kaWZpZXJfbWV0aG9kIjoxLjAsIm1vZGlmaWVyX21pbmltdW1fb2Zmc2V0IjotMTAuMCwibW9kaWZpZXJfbnVtYmVycyI6NC4wLCJtb2RpZmllcl9yYW5kb21faml0dGVyIjp0cnVlLCJuZXZlcmxvc2VfbW9kZSI6MC4wLCJyYW5kb21fY2hva2UiOnRydWUsInNuYXAiOmZhbHNlLCJzbmFwX2Rpc2FibGVycyI6WyJ+Il0sInNuYXBfZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsInNuYXBfZGlzdG9ydGlvbl9zcGVlZCI6NS4wLCJzbmFwX2xlZnRfb2Zmc2V0IjowLjAsInNuYXBfb2Zmc2V0IjowLjAsInNuYXBfb25seV93aGVuX2hpdHRhYmxlIjpmYWxzZSwic25hcF9waXRjaCI6IkRvd24iLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTg5LjAsInNuYXBfcmFuZG9tMiI6ODkuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiU2lkZXdheXMiLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tzX3RvIjoxNi4wLCJ5YXciOjEuMCwieWF3X2RlbGF5X2Jvb2wiOjAuMCwieWF3X2RlbGF5X21heCI6MTAuMCwieWF3X2RlbGF5X21ldGhvZCI6MS4wLCJ5YXdfZGVsYXlfbWluIjoxLjAsInlhd19kZWxheV9tdWx0aXBsaWVyIjoyLjAsInlhd19sZWZ0X29mZnNldCI6LTI0LjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjYuMCwieWF3X3JpZ2h0X29mZnNldCI6MzcuMH0sImFpcmxhZyI6ZmFsc2UsImF2b2lkX2JhY2tzdGFiIjp0cnVlLCJibG9ja19qaXR0ZXIiOnRydWUsImNpcmN1bXN0YW5jZXMiOjguMCwiZGlzYWJsZXJfbGVmdF9vZmZzZXQiOi0zMC4wLCJkaXNhYmxlcl9waXRjaCI6IkRpc2FibGVkIiwiZGlzYWJsZXJfcmFuZ2UiOjE4MC4wLCJkaXNhYmxlcl9yaWdodF9vZmZzZXQiOjMwLjAsImRpc2FibGVyX3NwZWVkIjoyLjAsImRpc2FibGVyX3lhdyI6IlNwaW4iLCJmbHVjdHVhdGUiOjIuMCwiZm9yY2VfYnJlYWtfbGFnY29tcCI6WyJcdTAwMDd7TGluayBBY3RpdmV974aDICAgICBcdTAwMDdERUZBVUxUU3RhbmRpbmciLCJcdTAwMDd7TGluayBBY3RpdmV975yMICAgIFx1MDAwN0RFRkFVTFRSdW5uaW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe+VlCAgICAgXHUwMDA3REVGQVVMVFNsb3dpbmciLCJcdTAwMDd7TGluayBBY3RpdmV974aTICAgXHUwMDA3REVGQVVMVENyb3VjaGluZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3ui44gICAgXHUwMDA3REVGQVVMVFNuZWFraW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe6VhiAgICBcdTAwMDdERUZBVUxUQWlyIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe6VhyAgXHUwMDA3REVGQVVMVEFpciBDcm91Y2hpbmciLCJcdTAwMDd7TGluayBBY3RpdmV97pOBICAgXHUwMDA3REVGQVVMVEZyZWVzdGFuZGluZyIsIn4iXSwiZnJlZXN0YW5kX2Rpc2FibGVycyI6WyJ+Il0sImZyZWVzdGFuZF9tb2RpZmllcnMiOjMuMCwiZnJlZXN0YW5kaW5nIjpmYWxzZSwiZnJlZXN0YW5kaW5nX2Jvb2wiOjEuMCwiaHNfbW9kZSI6IkZhdm9yIEZpcmUgUmF0ZSIsIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsInNhZmVfaGVhZF9oZWlnaHQiOjAuMCwidHdlYWtzIjowLjB9LCJob21lIjp7ImFib3V0X2xpc3QiOjEuMCwibG9hZF9saW5lIjozMi4wLCJwcmVzZXRfaW5wdXQiOiJEZWZhdWx0ICBcdTAwMDd7TGluayBBY3RpdmV974G1IiwicHJlc2V0X2xpc3QiOjcuMCwid2F0ZXJtYXJrX2FjY2VudCI6IiNGRkZGRkY3QSIsIndhdGVybWFya19mb250IjoxLjAsIndhdGVybWFya19ncmFkaWVudCI6MC4wLCJ3YXRlcm1hcmtfZ3JhZGllbnRfaHVlIjowLjAsIndhdGVybWFya19ncmFkaWVudF9yYWluYm93IjoxLjAsIndhdGVybWFya19ncmFkaWVudF9zYXR1cmF0aW9uIjo1LjAsIndhdGVybWFya19ncmFkaWVudF9zcGVlZCI6Mi4wLCJ3YXRlcm1hcmtfaW5wdXQiOiJkZXN5bmMubWF4Iiwid2F0ZXJtYXJrX3Bvc2l0aW9uIjoxLjAsIndhdGVybWFya194IjoxMjgwLjAsIndhdGVybWFya195IjoxNDMwLjB9LCJvdGhlciI6eyIqaGlnaGxpZ2h0IjoiI0ZGRkZGRkZGIiwiYWRkb25zIjpbIlx1MDAwN3tMaW5rIEFjdGl2ZX3vlYsgIFx1MDAwN0RFRkFVTFREaXNhYmxlIEZvb3QgU2hhZG93cyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3vi7EgICBcdTAwMDdERUZBVUxUTGVnYWN5IERlc3luYyIsIn4iXSwiYXNwZWN0X3JhdGlvIjp0cnVlLCJhc3BlY3RfcmF0aW9faGVpZ2h0IjoxNDQwLjAsImFzcGVjdF9yYXRpb19saXN0IjoiNDozICgxMDI0eDc2OCkiLCJhc3BlY3RfcmF0aW9fbWV0aG9kIjoxLjAsImFzcGVjdF9yYXRpb19zbGlkZXIiOjEzMy4wLCJhc3BlY3RfcmF0aW9fd2lkdGgiOjI1NjAuMCwiY3VzdG9tX3Njb3BlX292ZXJsYXkiOnRydWUsImRhbWFnZV9pbmRpY2F0b3IiOnRydWUsImRlYnVnX3RleHQiOmZhbHNlLCJmYXN0X2xhZGRlciI6ZmFsc2UsImZvdiI6NjMuMCwiZnJlZXpldGltZWZkIjp0cnVlLCJoaWdobGlnaHQiOmZhbHNlLCJoaWdobGlnaHRfY29sb3IiOiIjRkZGRkZGRkYiLCJoaXRtYXJrZXJzIjpbIlNrZWV0IiwiS2liaXQiLCJ+Il0sImtlZXB0cmFuc3BhcmVuY3kiOnRydWUsImtpYml0X2NvbG9yeCI6IiNGRkZGRkZGRiIsImtpYml0X2NvbG9yeSI6IiNGRkZGRkZGRiIsImxvZ19haW1ib3QiOnRydWUsImxvZ19jb2xvciI6IiNGRkZGRkZGRiIsImxvZ19wdXJjaGFzZXMiOnRydWUsIm1hbnVhbF9hcnJvd3MiOmZhbHNlLCJtYW51YWxfYXJyb3dzX2NsciI6IiNCREJEQkRGRiIsIm1hbnVhbF9hcnJvd3NfZm9udCI6MS4wLCJtYW51YWxfYXJyb3dzX2ZvcndhcmQiOiJeIiwibWFudWFsX2Fycm93c19sZWZ0IjoiPCIsIm1hbnVhbF9hcnJvd3NfcmlnaHQiOiI+Iiwibm9fZmFsbF9kYW1hZ2UiOmZhbHNlLCJwbGF5ZXJfYW5pbWF0aW9ucyI6WyJ+Il0sInBsYXllcl9hbmltYXRpb25zX2ZhbGxpbmciOjAuMCwicGxheWVyX2FuaW1hdGlvbnNfaW50ZXJwb2xhdGluZyI6MC4wLCJwbGF5ZXJfYW5pbWF0aW9uc19sZWFuaW5nIjo1MC4wLCJwbGF5ZXJfYW5pbWF0aW9uc193YWxraW5nIjowLjAsInNjb3BlX2NvbG9yIjoiIzg2ODY4NkZGIiwic2NvcGVfZXh0cmEiOlsifiJdLCJzY29wZV9nYXAiOjEwLjAsInNjb3BlX3NpemUiOjIwNi4wLCJ0ZWFtbWF0ZV9haW1ib3QiOmZhbHNlLCJ1bmxvY2tfZmFrZV9sYXRlbmN5Ijp0cnVlLCJ2aWV3bW9kZWwiOnRydWUsIngiOi05LjAsInkiOjEyLjAsInoiOjEyLjB9fQ==";
        end;
        if not v593.database[l_pui_0.string("Delayed  \v\239\130\134")] or #v593.database == 0 then
            v593.database[l_pui_0.string("Delayed  \v\239\130\134")] = "eyJhbnRpYWltIjp7Ilx1MDAwN3tMaW5rIEFjdGl2ZX3ui44gICAgXHUwMDA3REVGQVVMVFNuZWFraW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6Ny4wLCJjaG9rZV9zbGlkZXIyIjoyMi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjQuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjU4LjAsImRlc3luY19saW1pdF9tb2RlIjoyLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjo0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjU4LjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6Ny4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21ldGhvZCI6MS4wLCJtb2RpZmllcl9taW5pbXVtX29mZnNldCI6MC4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOmZhbHNlLCJuZXZlcmxvc2VfbW9kZSI6MS4wLCJyYW5kb21fY2hva2UiOnRydWUsInNuYXAiOmZhbHNlLCJzbmFwX2Rpc2FibGVycyI6WyJ+Il0sInNuYXBfZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsInNuYXBfZGlzdG9ydGlvbl9zcGVlZCI6NS4wLCJzbmFwX2xlZnRfb2Zmc2V0IjowLjAsInNuYXBfb2Zmc2V0IjowLjAsInNuYXBfb25seV93aGVuX2hpdHRhYmxlIjpmYWxzZSwic25hcF9waXRjaCI6IkRvd24iLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTg5LjAsInNuYXBfcmFuZG9tMiI6ODkuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiU2lkZXdheXMiLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tzX3RvIjoxNi4wLCJ5YXciOjEuMCwieWF3X2RlbGF5X2Jvb2wiOjEuMCwieWF3X2RlbGF5X21heCI6OC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjoyLjAsInlhd19kZWxheV9taW4iOjQuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjEwLjAsInlhd19sZWZ0X29mZnNldCI6LTI3LjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6NDQuMH0sIlx1MDAwN3tMaW5rIEFjdGl2ZX3uk4EgICBcdTAwMDdERUZBVUxURnJlZXN0YW5kaW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6MTYuMCwiY2hva2Vfc2xpZGVyMiI6MTYuMCwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwiZGVsYXlfbnVtYmVycyI6NC4wLCJkZXN5bmMiOjAuMCwiZGVzeW5jX2RlbGF5Ijo0LjAsImRlc3luY19mcmVlc3RhbmRpbmciOjEuMCwiZGVzeW5jX2Zyb20iOjI4LjAsImRlc3luY19pbnZlcnRlciI6ZmFsc2UsImRlc3luY19sZWZ0Ijo1OC4wLCJkZXN5bmNfbGltaXRfbW9kZSI6MS4wLCJkZXN5bmNfbWF4Ijo1OC4wLCJkZXN5bmNfbWluIjoyOC4wLCJkZXN5bmNfbW9kZSI6MS4wLCJkZXN5bmNfbXVsdGlwbGllciI6NC4wLCJkZXN5bmNfcmFuZ2VfZnJvbSI6NTguMCwiZGVzeW5jX3JpZ2h0Ijo1OC4wLCJkZXN5bmNfc3BlZWRfdG8iOjUuMCwiZGVzeW5jX3RvIjo1OC4wLCJkZXN5bmNfdHdlYWtzIjpbIkppdHRlciIsIn4iXSwibW9kaWZpZXIiOjEuMCwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfaml0dGVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9tYXhpbXVtX29mZnNldCI6MC4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfbnVtYmVycyI6NC4wLCJtb2RpZmllcl9yYW5kb21faml0dGVyIjpmYWxzZSwibmV2ZXJsb3NlX21vZGUiOjAuMCwicmFuZG9tX2Nob2tlIjpmYWxzZSwic25hcCI6ZmFsc2UsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOmZhbHNlLCJzbmFwX3BpdGNoIjoiRG93biIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJTaWRld2F5cyIsInNuYXBfeWF3X3JhbmRvbSI6LTE4MC4wLCJzbmFwX3lhd19yYW5kb20yIjoxODAuMCwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjE2LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MC4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjoxLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjIuMCwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RlIjoxLjAsInlhd19vZmZzZXQiOjYuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wfSwiXHUwMDA3e0xpbmsgQWN0aXZlfe6VhiAgICBcdTAwMDdERUZBVUxUQWlyIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6Mi4wLCJjaG9rZV9zbGlkZXIyIjoyMi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjQuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjU4LjAsImRlc3luY19saW1pdF9tb2RlIjoyLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjo0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjU4LjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6Ny4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjoxMS4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi0xMS4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjoxLjAsInJhbmRvbV9jaG9rZSI6dHJ1ZSwic25hcCI6ZmFsc2UsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOmZhbHNlLCJzbmFwX3BpdGNoIjoiRG93biIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJTaWRld2F5cyIsInNuYXBfeWF3X3JhbmRvbSI6LTE4MC4wLCJzbmFwX3lhd19yYW5kb20yIjoxODAuMCwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjE2LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MS4wLCJ5YXdfZGVsYXlfbWF4Ijo1LjAsInlhd19kZWxheV9tZXRob2QiOjIuMCwieWF3X2RlbGF5X21pbiI6NC4wLCJ5YXdfZGVsYXlfbXVsdGlwbGllciI6Ni4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0yMS4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjMzLjB9LCJcdTAwMDd7TGluayBBY3RpdmV97pWHICBcdTAwMDdERUZBVUxUQWlyIENyb3VjaGluZyI6eyJjaG9rZV9tZXRob2QiOjEuMCwiY2hva2VfbnVtYmVycyI6Ni4wLCJjaG9rZV9zbGlkZXIiOjIuMCwiY2hva2Vfc2xpZGVyMiI6MjIuMCwiZGVsYXlfMSI6NC4wLCJkZWxheV8yIjo1LjAsImRlbGF5XzMiOjMuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwiZGVsYXlfbnVtYmVycyI6My4wLCJkZXN5bmMiOjEuMCwiZGVzeW5jX2RlbGF5IjoxNC4wLCJkZXN5bmNfZnJlZXN0YW5kaW5nIjoxLjAsImRlc3luY19mcm9tIjoyOC4wLCJkZXN5bmNfaW52ZXJ0ZXIiOmZhbHNlLCJkZXN5bmNfbGVmdCI6NTguMCwiZGVzeW5jX2xpbWl0X21vZGUiOjIuMCwiZGVzeW5jX21heCI6NTguMCwiZGVzeW5jX21pbiI6MjguMCwiZGVzeW5jX21vZGUiOjIuMCwiZGVzeW5jX211bHRpcGxpZXIiOjE0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjU4LjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6Ny4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjoyMi4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi0yMi4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjoxLjAsInJhbmRvbV9jaG9rZSI6dHJ1ZSwic25hcCI6ZmFsc2UsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOmZhbHNlLCJzbmFwX3BpdGNoIjoiRG93biIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJTaWRld2F5cyIsInNuYXBfeWF3X3JhbmRvbSI6LTE4MC4wLCJzbmFwX3lhd19yYW5kb20yIjoxODAuMCwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjE2LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MS4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjozLjAsInlhd19kZWxheV9taW4iOjMuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjUuMCwieWF3X2xlZnRfb2Zmc2V0IjotMTUuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjozNS4wfSwiXHUwMDA3e0xpbmsgQWN0aXZlfe+GgyAgICAgXHUwMDA3REVGQVVMVFN0YW5kaW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6MTYuMCwiY2hva2Vfc2xpZGVyMiI6MTYuMCwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwiZGVsYXlfbnVtYmVycyI6NC4wLCJkZXN5bmMiOjEuMCwiZGVzeW5jX2RlbGF5Ijo0LjAsImRlc3luY19mcmVlc3RhbmRpbmciOjEuMCwiZGVzeW5jX2Zyb20iOjI4LjAsImRlc3luY19pbnZlcnRlciI6ZmFsc2UsImRlc3luY19sZWZ0Ijo1OC4wLCJkZXN5bmNfbGltaXRfbW9kZSI6Mi4wLCJkZXN5bmNfbWF4Ijo1OC4wLCJkZXN5bmNfbWluIjoyOC4wLCJkZXN5bmNfbW9kZSI6MS4wLCJkZXN5bmNfbXVsdGlwbGllciI6NC4wLCJkZXN5bmNfcmFuZ2VfZnJvbSI6NTguMCwiZGVzeW5jX3JpZ2h0Ijo1OC4wLCJkZXN5bmNfc3BlZWRfdG8iOjUuMCwiZGVzeW5jX3RvIjo1OC4wLCJkZXN5bmNfdHdlYWtzIjpbIkppdHRlciIsIn4iXSwibW9kaWZpZXIiOjYuMCwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfaml0dGVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9tYXhpbXVtX29mZnNldCI6MjcuMCwibW9kaWZpZXJfbWV0aG9kIjoxLjAsIm1vZGlmaWVyX21pbmltdW1fb2Zmc2V0IjotMTYuMCwibW9kaWZpZXJfbnVtYmVycyI6NC4wLCJtb2RpZmllcl9yYW5kb21faml0dGVyIjp0cnVlLCJuZXZlcmxvc2VfbW9kZSI6MS4wLCJyYW5kb21fY2hva2UiOmZhbHNlLCJzbmFwIjpmYWxzZSwic25hcF9kaXNhYmxlcnMiOlsifiJdLCJzbmFwX2Rpc3RvcnRpb25fcmFuZ2UiOjE4MC4wLCJzbmFwX2Rpc3RvcnRpb25fc3BlZWQiOjUuMCwic25hcF9sZWZ0X29mZnNldCI6MC4wLCJzbmFwX29mZnNldCI6MC4wLCJzbmFwX29ubHlfd2hlbl9oaXR0YWJsZSI6ZmFsc2UsInNuYXBfcGl0Y2giOiJGbGljayIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJSYW5kb20iLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tzX3RvIjo3LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MS4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjoxLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjEwLjAsInlhd19sZWZ0X29mZnNldCI6LTE2LjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6MzMuMH0sIlx1MDAwN3tMaW5rIEFjdGl2ZX3vhpMgICBcdTAwMDdERUZBVUxUQ3JvdWNoaW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6NS4wLCJjaG9rZV9zbGlkZXIyIjoxNi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjQuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjU4LjAsImRlc3luY19saW1pdF9tb2RlIjoyLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjo0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjU4LjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6Ny4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjoyMi4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi0yMi4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjowLjAsInJhbmRvbV9jaG9rZSI6ZmFsc2UsInNuYXAiOmZhbHNlLCJzbmFwX2Rpc2FibGVycyI6WyJ+Il0sInNuYXBfZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsInNuYXBfZGlzdG9ydGlvbl9zcGVlZCI6NS4wLCJzbmFwX2xlZnRfb2Zmc2V0IjowLjAsInNuYXBfb2Zmc2V0IjowLjAsInNuYXBfb25seV93aGVuX2hpdHRhYmxlIjpmYWxzZSwic25hcF9waXRjaCI6IkRvd24iLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTg5LjAsInNuYXBfcmFuZG9tMiI6ODkuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiU2lkZXdheXMiLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tzX3RvIjoxNi4wLCJ5YXciOjEuMCwieWF3X2RlbGF5X2Jvb2wiOjEuMCwieWF3X2RlbGF5X21heCI6NS4wLCJ5YXdfZGVsYXlfbWV0aG9kIjoyLjAsInlhd19kZWxheV9taW4iOjMuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjguMCwieWF3X2xlZnRfb2Zmc2V0IjotMjIuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6Ni4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjozOC4wfSwiXHUwMDA3e0xpbmsgQWN0aXZlfe+VlCAgICAgXHUwMDA3REVGQVVMVFNsb3dpbmciOnsiY2hva2VfbWV0aG9kIjoxLjAsImNob2tlX251bWJlcnMiOjYuMCwiY2hva2Vfc2xpZGVyIjo0LjAsImNob2tlX3NsaWRlcjIiOjE2LjAsImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6Mi4wLCJkZWxheV8zIjoyLjAsImRlbGF5XzQiOjIuMCwiZGVsYXlfNSI6Mi4wLCJkZWxheV82IjoyLjAsImRlbGF5X251bWJlcnMiOjQuMCwiZGVzeW5jIjoxLjAsImRlc3luY19kZWxheSI6NC4wLCJkZXN5bmNfZnJlZXN0YW5kaW5nIjoxLjAsImRlc3luY19mcm9tIjoyOC4wLCJkZXN5bmNfaW52ZXJ0ZXIiOmZhbHNlLCJkZXN5bmNfbGVmdCI6NTguMCwiZGVzeW5jX2xpbWl0X21vZGUiOjIuMCwiZGVzeW5jX21heCI6NTguMCwiZGVzeW5jX21pbiI6MjguMCwiZGVzeW5jX21vZGUiOjEuMCwiZGVzeW5jX211bHRpcGxpZXIiOjQuMCwiZGVzeW5jX3JhbmdlX2Zyb20iOjU4LjAsImRlc3luY19yaWdodCI6NTguMCwiZGVzeW5jX3NwZWVkX3RvIjo1LjAsImRlc3luY190byI6NTguMCwiZGVzeW5jX3R3ZWFrcyI6WyJKaXR0ZXIiLCJ+Il0sIm1vZGlmaWVyIjo3LjAsIm1vZGlmaWVyXzEiOjAuMCwibW9kaWZpZXJfMiI6MC4wLCJtb2RpZmllcl8zIjowLjAsIm1vZGlmaWVyXzQiOjAuMCwibW9kaWZpZXJfNSI6MC4wLCJtb2RpZmllcl82IjowLjAsIm1vZGlmaWVyX2ppdHRlcl9vZmZzZXQiOjAuMCwibW9kaWZpZXJfbWF4aW11bV9vZmZzZXQiOjEwLjAsIm1vZGlmaWVyX21ldGhvZCI6MS4wLCJtb2RpZmllcl9taW5pbXVtX29mZnNldCI6LTEwLjAsIm1vZGlmaWVyX251bWJlcnMiOjQuMCwibW9kaWZpZXJfcmFuZG9tX2ppdHRlciI6dHJ1ZSwibmV2ZXJsb3NlX21vZGUiOjEuMCwicmFuZG9tX2Nob2tlIjp0cnVlLCJzbmFwIjpmYWxzZSwic25hcF9kaXNhYmxlcnMiOlsifiJdLCJzbmFwX2Rpc3RvcnRpb25fcmFuZ2UiOjE4MC4wLCJzbmFwX2Rpc3RvcnRpb25fc3BlZWQiOjUuMCwic25hcF9sZWZ0X29mZnNldCI6MC4wLCJzbmFwX29mZnNldCI6MC4wLCJzbmFwX29ubHlfd2hlbl9oaXR0YWJsZSI6ZmFsc2UsInNuYXBfcGl0Y2giOiJEb3duIiwic25hcF9waXRjaF9mcm9tIjotODkuMCwic25hcF9waXRjaF9vZmZzZXQiOjAuMCwic25hcF9waXRjaF90byI6ODkuMCwic25hcF9yYW5kb20iOi04OS4wLCJzbmFwX3JhbmRvbTIiOjg5LjAsInNuYXBfcmlnaHRfb2Zmc2V0IjowLjAsInNuYXBfc3Bpbl9yYW5nZSI6MTgwLjAsInNuYXBfc3Bpbl9zcGVlZCI6NS4wLCJzbmFwX3lhdyI6IlNpZGV3YXlzIiwic25hcF95YXdfcmFuZG9tIjotMTgwLjAsInNuYXBfeWF3X3JhbmRvbTIiOjE4MC4wLCJ0aWNrYmFzZV8xIjoxNi4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrc190byI6MTYuMCwieWF3IjoxLjAsInlhd19kZWxheV9ib29sIjoxLjAsInlhd19kZWxheV9tYXgiOjEwLjAsInlhd19kZWxheV9tZXRob2QiOjEuMCwieWF3X2RlbGF5X21pbiI6MS4wLCJ5YXdfZGVsYXlfbXVsdGlwbGllciI6MTAuMCwieWF3X2xlZnRfb2Zmc2V0IjotMjcuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjozOS4wfSwiXHUwMDA3e0xpbmsgQWN0aXZlfe+cjCAgICBcdTAwMDdERUZBVUxUUnVubmluZyI6eyJjaG9rZV9tZXRob2QiOjEuMCwiY2hva2VfbnVtYmVycyI6Ni4wLCJjaG9rZV9zbGlkZXIiOjcuMCwiY2hva2Vfc2xpZGVyMiI6MjIuMCwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjUuMCwiZGVsYXlfNCI6MTAuMCwiZGVsYXlfNSI6MTUuMCwiZGVsYXlfNiI6MjAuMCwiZGVsYXlfbnVtYmVycyI6Ni4wLCJkZXN5bmMiOjEuMCwiZGVzeW5jX2RlbGF5IjoxNC4wLCJkZXN5bmNfZnJlZXN0YW5kaW5nIjoxLjAsImRlc3luY19mcm9tIjoyOC4wLCJkZXN5bmNfaW52ZXJ0ZXIiOmZhbHNlLCJkZXN5bmNfbGVmdCI6NTguMCwiZGVzeW5jX2xpbWl0X21vZGUiOjIuMCwiZGVzeW5jX21heCI6NTguMCwiZGVzeW5jX21pbiI6MjguMCwiZGVzeW5jX21vZGUiOjIuMCwiZGVzeW5jX211bHRpcGxpZXIiOjEzLjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjU4LjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6NC4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjoxMC4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi0xMC4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjoxLjAsInJhbmRvbV9jaG9rZSI6dHJ1ZSwic25hcCI6ZmFsc2UsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOmZhbHNlLCJzbmFwX3BpdGNoIjoiRG93biIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJTaWRld2F5cyIsInNuYXBfeWF3X3JhbmRvbSI6LTE4MC4wLCJzbmFwX3lhd19yYW5kb20yIjoxODAuMCwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjE2LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MS4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjozLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjEwLjAsInlhd19sZWZ0X29mZnNldCI6LTM4LjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjYuMCwieWF3X3JpZ2h0X29mZnNldCI6MzguMH0sImFpcmxhZyI6ZmFsc2UsImF2b2lkX2JhY2tzdGFiIjp0cnVlLCJibG9ja19qaXR0ZXIiOnRydWUsImNpcmN1bXN0YW5jZXMiOjguMCwiZGlzYWJsZXJfbGVmdF9vZmZzZXQiOi0zMC4wLCJkaXNhYmxlcl9waXRjaCI6IkRpc2FibGVkIiwiZGlzYWJsZXJfcmFuZ2UiOjE4MC4wLCJkaXNhYmxlcl9yaWdodF9vZmZzZXQiOjMwLjAsImRpc2FibGVyX3NwZWVkIjoyLjAsImRpc2FibGVyX3lhdyI6IlNwaW4iLCJmbHVjdHVhdGUiOjIuMCwiZm9yY2VfYnJlYWtfbGFnY29tcCI6WyJcdTAwMDd7TGluayBBY3RpdmV974aDICAgICBcdTAwMDdERUZBVUxUU3RhbmRpbmciLCJcdTAwMDd7TGluayBBY3RpdmV975yMICAgIFx1MDAwN0RFRkFVTFRSdW5uaW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe+VlCAgICAgXHUwMDA3REVGQVVMVFNsb3dpbmciLCJcdTAwMDd7TGluayBBY3RpdmV974aTICAgXHUwMDA3REVGQVVMVENyb3VjaGluZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3ui44gICAgXHUwMDA3REVGQVVMVFNuZWFraW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe6VhiAgICBcdTAwMDdERUZBVUxUQWlyIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe6VhyAgXHUwMDA3REVGQVVMVEFpciBDcm91Y2hpbmciLCJ+Il0sImZyZWVzdGFuZF9kaXNhYmxlcnMiOlsifiJdLCJmcmVlc3RhbmRfbW9kaWZpZXJzIjozLjAsImZyZWVzdGFuZGluZyI6ZmFsc2UsImZyZWVzdGFuZGluZ19ib29sIjowLjAsImhzX21vZGUiOiJGYXZvciBGaXJlIFJhdGUiLCJtYW51YWxfeWF3IjoiRGlzYWJsZWQiLCJzYWZlX2hlYWRfaGVpZ2h0IjowLjAsInR3ZWFrcyI6MC4wfSwiaG9tZSI6eyJhYm91dF9saXN0IjoxLjAsImxvYWRfbGluZSI6OC4wLCJwcmVzZXRfaW5wdXQiOiJEZWxheWVkICBcdTAwMDd7TGluayBBY3RpdmV974KGIiwicHJlc2V0X2xpc3QiOjcuMCwid2F0ZXJtYXJrX2FjY2VudCI6IiNGRkZGRkZGRiIsIndhdGVybWFya19mb250IjoyLjAsIndhdGVybWFya19ncmFkaWVudCI6MC4wLCJ3YXRlcm1hcmtfZ3JhZGllbnRfaHVlIjowLjAsIndhdGVybWFya19ncmFkaWVudF9yYWluYm93IjoxLjAsIndhdGVybWFya19ncmFkaWVudF9zYXR1cmF0aW9uIjo1LjAsIndhdGVybWFya19ncmFkaWVudF9zcGVlZCI6Mi4wLCJ3YXRlcm1hcmtfaW5wdXQiOiJBTUJBTkkgUkVCT1JOIiwid2F0ZXJtYXJrX3Bvc2l0aW9uIjoxLjAsIndhdGVybWFya194IjoxMjgwLjAsIndhdGVybWFya195IjoxNDMwLjB9LCJvdGhlciI6eyIqaGlnaGxpZ2h0IjoiI0ZGRkZGRkZGIiwiYWRkb25zIjpbIlx1MDAwN3tMaW5rIEFjdGl2ZX3vlYsgIFx1MDAwN0RFRkFVTFREaXNhYmxlIEZvb3QgU2hhZG93cyIsIn4iXSwiYXNwZWN0X3JhdGlvIjp0cnVlLCJhc3BlY3RfcmF0aW9faGVpZ2h0IjoxNDQwLjAsImFzcGVjdF9yYXRpb19saXN0IjoiNDozICgxMDI0eDc2OCkiLCJhc3BlY3RfcmF0aW9fbWV0aG9kIjoxLjAsImFzcGVjdF9yYXRpb19zbGlkZXIiOjEzMy4wLCJhc3BlY3RfcmF0aW9fd2lkdGgiOjI1NjAuMCwiY3VzdG9tX3Njb3BlX292ZXJsYXkiOmZhbHNlLCJkYW1hZ2VfaW5kaWNhdG9yIjp0cnVlLCJkZWJ1Z190ZXh0IjpmYWxzZSwiZmFzdF9sYWRkZXIiOmZhbHNlLCJmb3YiOjYzLjAsImZyZWV6ZXRpbWVmZCI6dHJ1ZSwiaGlnaGxpZ2h0IjpmYWxzZSwiaGlnaGxpZ2h0X2NvbG9yIjoiI0ZGRkZGRkZGIiwiaGl0bWFya2VycyI6WyJTa2VldCIsIktpYml0IiwifiJdLCJrZWVwdHJhbnNwYXJlbmN5Ijp0cnVlLCJraWJpdF9jb2xvcngiOiIjRkZGRkZGRkYiLCJraWJpdF9jb2xvcnkiOiIjRkZGRkZGRkYiLCJsb2dfYWltYm90Ijp0cnVlLCJsb2dfY29sb3IiOiIjRkZGRkZGRkYiLCJsb2dfcHVyY2hhc2VzIjp0cnVlLCJtYW51YWxfYXJyb3dzIjpmYWxzZSwibWFudWFsX2Fycm93c19jbHIiOiIjQkRCREJERkYiLCJtYW51YWxfYXJyb3dzX2ZvbnQiOjEuMCwibWFudWFsX2Fycm93c19mb3J3YXJkIjoiXiIsIm1hbnVhbF9hcnJvd3NfbGVmdCI6IjwiLCJtYW51YWxfYXJyb3dzX3JpZ2h0IjoiPiIsIm5vX2ZhbGxfZGFtYWdlIjpmYWxzZSwicGxheWVyX2FuaW1hdGlvbnMiOlsifiJdLCJwbGF5ZXJfYW5pbWF0aW9uc19mYWxsaW5nIjoyLjAsInBsYXllcl9hbmltYXRpb25zX2ludGVycG9sYXRpbmciOjAuMCwicGxheWVyX2FuaW1hdGlvbnNfbGVhbmluZyI6NTAuMCwicGxheWVyX2FuaW1hdGlvbnNfd2Fsa2luZyI6Mi4wLCJzY29wZV9jb2xvciI6IiM4Njg2ODZGRiIsInNjb3BlX2V4dHJhIjpbIn4iXSwic2NvcGVfZ2FwIjoxMC4wLCJzY29wZV9zaXplIjoyMDYuMCwidGVhbW1hdGVfYWltYm90IjpmYWxzZSwidW5sb2NrX2Zha2VfbGF0ZW5jeSI6dHJ1ZSwidmlld21vZGVsIjp0cnVlLCJ4IjotOS4wLCJ5IjoxMi4wLCJ6IjoxMi4wfX0=";
        end;
        if not v593.database[l_pui_0.string("Snappy  \v\239\130\134")] or #v593.database == 0 then
            v593.database[l_pui_0.string("Snappy  \v\239\130\134")] = "eyJhbnRpYWltIjp7Ilx1MDAwN3tMaW5rIEFjdGl2ZX3ui44gICAgXHUwMDA3REVGQVVMVFNuZWFraW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6Ny4wLCJjaG9rZV9zbGlkZXIyIjoxNi4wLCJkZWxheV8xIjoxLjAsImRlbGF5XzIiOjEuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoxLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjE2LjAsImRlc3luY19mcmVlc3RhbmRpbmciOjEuMCwiZGVzeW5jX2Zyb20iOjI4LjAsImRlc3luY19pbnZlcnRlciI6ZmFsc2UsImRlc3luY19sZWZ0Ijo2MC4wLCJkZXN5bmNfbGltaXRfbW9kZSI6MS4wLCJkZXN5bmNfbWF4Ijo1OC4wLCJkZXN5bmNfbWluIjoyOC4wLCJkZXN5bmNfbW9kZSI6Mi4wLCJkZXN5bmNfbXVsdGlwbGllciI6NC4wLCJkZXN5bmNfcmFuZ2VfZnJvbSI6NTguMCwiZGVzeW5jX3JpZ2h0Ijo2MC4wLCJkZXN5bmNfc3BlZWRfdG8iOjUuMCwiZGVzeW5jX3RvIjo1OC4wLCJkZXN5bmNfdHdlYWtzIjpbIkppdHRlciIsIn4iXSwibW9kaWZpZXIiOjYuMCwibW9kaWZpZXJfMSI6LTMuMCwibW9kaWZpZXJfMiI6LTMuMCwibW9kaWZpZXJfMyI6MS4wLCJtb2RpZmllcl80IjoxLjAsIm1vZGlmaWVyXzUiOi0yLjAsIm1vZGlmaWVyXzYiOjUuMCwibW9kaWZpZXJfaml0dGVyX29mZnNldCI6MS4wLCJtb2RpZmllcl9tYXhpbXVtX29mZnNldCI6MC4wLCJtb2RpZmllcl9tZXRob2QiOjIuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfbnVtYmVycyI6Ni4wLCJtb2RpZmllcl9yYW5kb21faml0dGVyIjp0cnVlLCJuZXZlcmxvc2VfbW9kZSI6MC4wLCJyYW5kb21fY2hva2UiOnRydWUsInNuYXAiOmZhbHNlLCJzbmFwX2Rpc2FibGVycyI6WyJ+Il0sInNuYXBfZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsInNuYXBfZGlzdG9ydGlvbl9zcGVlZCI6NS4wLCJzbmFwX2xlZnRfb2Zmc2V0IjowLjAsInNuYXBfb2Zmc2V0IjowLjAsInNuYXBfb25seV93aGVuX2hpdHRhYmxlIjpmYWxzZSwic25hcF9waXRjaCI6IkRvd24iLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTg5LjAsInNuYXBfcmFuZG9tMiI6ODkuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiU2lkZXdheXMiLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tzX3RvIjoxNi4wLCJ5YXciOjEuMCwieWF3X2RlbGF5X2Jvb2wiOjEuMCwieWF3X2RlbGF5X21heCI6NC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjozLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjIuMCwieWF3X2xlZnRfb2Zmc2V0IjotMjAuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0IjozMy4wfSwiXHUwMDA3e0xpbmsgQWN0aXZlfe6TgSAgIFx1MDAwN0RFRkFVTFRGcmVlc3RhbmRpbmciOnsiY2hva2VfbWV0aG9kIjoxLjAsImNob2tlX251bWJlcnMiOjYuMCwiY2hva2Vfc2xpZGVyIjoxNi4wLCJjaG9rZV9zbGlkZXIyIjoxNi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjQuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6My4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjYwLjAsImRlc3luY19saW1pdF9tb2RlIjoxLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjo0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiQXZvaWQgT3ZlcmxhcCIsIkppdHRlciIsIn4iXSwibW9kaWZpZXIiOjEuMCwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfaml0dGVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9tYXhpbXVtX29mZnNldCI6MC4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfbnVtYmVycyI6NC4wLCJtb2RpZmllcl9yYW5kb21faml0dGVyIjpmYWxzZSwibmV2ZXJsb3NlX21vZGUiOjAuMCwicmFuZG9tX2Nob2tlIjpmYWxzZSwic25hcCI6ZmFsc2UsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOmZhbHNlLCJzbmFwX3BpdGNoIjoiRG93biIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJTaWRld2F5cyIsInNuYXBfeWF3X3JhbmRvbSI6LTE4MC4wLCJzbmFwX3lhd19yYW5kb20yIjoxODAuMCwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjE2LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MC4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjoxLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjIuMCwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RlIjoxLjAsInlhd19vZmZzZXQiOjYuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wfSwiXHUwMDA3e0xpbmsgQWN0aXZlfe6VhiAgICBcdTAwMDdERUZBVUxUQWlyIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6NS4wLCJjaG9rZV9zbGlkZXIyIjoxNS4wLCJkZWxheV8xIjoxLjAsImRlbGF5XzIiOjEuMCwiZGVsYXlfMyI6MS4wLCJkZWxheV80IjoxLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6MjAuMCwiZGVsYXlfbnVtYmVycyI6Ni4wLCJkZXN5bmMiOjEuMCwiZGVzeW5jX2RlbGF5Ijo0LjAsImRlc3luY19mcmVlc3RhbmRpbmciOjEuMCwiZGVzeW5jX2Zyb20iOjI4LjAsImRlc3luY19pbnZlcnRlciI6ZmFsc2UsImRlc3luY19sZWZ0Ijo2MC4wLCJkZXN5bmNfbGltaXRfbW9kZSI6MS4wLCJkZXN5bmNfbWF4Ijo1OC4wLCJkZXN5bmNfbWluIjoyOC4wLCJkZXN5bmNfbW9kZSI6MS4wLCJkZXN5bmNfbXVsdGlwbGllciI6NC4wLCJkZXN5bmNfcmFuZ2VfZnJvbSI6NTguMCwiZGVzeW5jX3JpZ2h0Ijo2MC4wLCJkZXN5bmNfc3BlZWRfdG8iOjUuMCwiZGVzeW5jX3RvIjo1OC4wLCJkZXN5bmNfdHdlYWtzIjpbIkppdHRlciIsIn4iXSwibW9kaWZpZXIiOjEuMCwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfaml0dGVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9tYXhpbXVtX29mZnNldCI6MTEuMCwibW9kaWZpZXJfbWV0aG9kIjoxLjAsIm1vZGlmaWVyX21pbmltdW1fb2Zmc2V0IjotMTEuMCwibW9kaWZpZXJfbnVtYmVycyI6NC4wLCJtb2RpZmllcl9yYW5kb21faml0dGVyIjp0cnVlLCJuZXZlcmxvc2VfbW9kZSI6MC4wLCJyYW5kb21fY2hva2UiOnRydWUsInNuYXAiOmZhbHNlLCJzbmFwX2Rpc2FibGVycyI6WyJ+Il0sInNuYXBfZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsInNuYXBfZGlzdG9ydGlvbl9zcGVlZCI6NS4wLCJzbmFwX2xlZnRfb2Zmc2V0IjowLjAsInNuYXBfb2Zmc2V0IjowLjAsInNuYXBfb25seV93aGVuX2hpdHRhYmxlIjpmYWxzZSwic25hcF9waXRjaCI6IkRvd24iLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTg5LjAsInNuYXBfcmFuZG9tMiI6ODkuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiU2lkZXdheXMiLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tzX3RvIjoxNi4wLCJ5YXciOjEuMCwieWF3X2RlbGF5X2Jvb2wiOjEuMCwieWF3X2RlbGF5X21heCI6MTAuMCwieWF3X2RlbGF5X21ldGhvZCI6My4wLCJ5YXdfZGVsYXlfbWluIjoxLjAsInlhd19kZWxheV9tdWx0aXBsaWVyIjoyLjAsInlhd19sZWZ0X29mZnNldCI6MTAuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0Ijo3LjB9LCJcdTAwMDd7TGluayBBY3RpdmV97pWHICBcdTAwMDdERUZBVUxUQWlyIENyb3VjaGluZyI6eyJjaG9rZV9tZXRob2QiOjEuMCwiY2hva2VfbnVtYmVycyI6Ni4wLCJjaG9rZV9zbGlkZXIiOjUuMCwiY2hva2Vfc2xpZGVyMiI6MTUuMCwiZGVsYXlfMSI6MS4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjMuMCwiZGVsYXlfNCI6My4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwiZGVsYXlfbnVtYmVycyI6My4wLCJkZXN5bmMiOjEuMCwiZGVzeW5jX2RlbGF5IjoxNC4wLCJkZXN5bmNfZnJlZXN0YW5kaW5nIjoxLjAsImRlc3luY19mcm9tIjoyOC4wLCJkZXN5bmNfaW52ZXJ0ZXIiOmZhbHNlLCJkZXN5bmNfbGVmdCI6NjAuMCwiZGVzeW5jX2xpbWl0X21vZGUiOjEuMCwiZGVzeW5jX21heCI6NTguMCwiZGVzeW5jX21pbiI6MjguMCwiZGVzeW5jX21vZGUiOjEuMCwiZGVzeW5jX211bHRpcGxpZXIiOjE0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6MS4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjoyMi4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi0yMi4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjowLjAsInJhbmRvbV9jaG9rZSI6dHJ1ZSwic25hcCI6ZmFsc2UsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOmZhbHNlLCJzbmFwX3BpdGNoIjoiRG93biIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJTaWRld2F5cyIsInNuYXBfeWF3X3JhbmRvbSI6LTE4MC4wLCJzbmFwX3lhd19yYW5kb20yIjoxODAuMCwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjE2LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MS4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjozLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjIuMCwieWF3X2xlZnRfb2Zmc2V0IjotMTkuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0Ijo0My4wfSwiXHUwMDA3e0xpbmsgQWN0aXZlfe+GgyAgICAgXHUwMDA3REVGQVVMVFN0YW5kaW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6MTYuMCwiY2hva2Vfc2xpZGVyMiI6MTYuMCwiZGVsYXlfMSI6MS4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjE1LjAsImRlbGF5XzQiOjIwLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjQuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjYwLjAsImRlc3luY19saW1pdF9tb2RlIjoxLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjo0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6NC4wLCJtb2RpZmllcl8xIjotMy4wLCJtb2RpZmllcl8yIjozLjAsIm1vZGlmaWVyXzMiOjIuMCwibW9kaWZpZXJfNCI6LTIuMCwibW9kaWZpZXJfNSI6MC4wLCJtb2RpZmllcl82IjowLjAsIm1vZGlmaWVyX2ppdHRlcl9vZmZzZXQiOjAuMCwibW9kaWZpZXJfbWF4aW11bV9vZmZzZXQiOjUuMCwibW9kaWZpZXJfbWV0aG9kIjoyLjAsIm1vZGlmaWVyX21pbmltdW1fb2Zmc2V0IjotNS4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjowLjAsInJhbmRvbV9jaG9rZSI6ZmFsc2UsInNuYXAiOmZhbHNlLCJzbmFwX2Rpc2FibGVycyI6WyJ+Il0sInNuYXBfZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsInNuYXBfZGlzdG9ydGlvbl9zcGVlZCI6NS4wLCJzbmFwX2xlZnRfb2Zmc2V0IjowLjAsInNuYXBfb2Zmc2V0IjowLjAsInNuYXBfb25seV93aGVuX2hpdHRhYmxlIjpmYWxzZSwic25hcF9waXRjaCI6IkZsaWNrIiwic25hcF9waXRjaF9mcm9tIjotODkuMCwic25hcF9waXRjaF9vZmZzZXQiOjAuMCwic25hcF9waXRjaF90byI6ODkuMCwic25hcF9yYW5kb20iOi04OS4wLCJzbmFwX3JhbmRvbTIiOjg5LjAsInNuYXBfcmlnaHRfb2Zmc2V0IjowLjAsInNuYXBfc3Bpbl9yYW5nZSI6MTgwLjAsInNuYXBfc3Bpbl9zcGVlZCI6NS4wLCJzbmFwX3lhdyI6IlJhbmRvbSIsInNuYXBfeWF3X3JhbmRvbSI6LTE4MC4wLCJzbmFwX3lhd19yYW5kb20yIjoxODAuMCwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjcuMCwieWF3IjoxLjAsInlhd19kZWxheV9ib29sIjoxLjAsInlhd19kZWxheV9tYXgiOjEwLjAsInlhd19kZWxheV9tZXRob2QiOjMuMCwieWF3X2RlbGF5X21pbiI6MS4wLCJ5YXdfZGVsYXlfbXVsdGlwbGllciI6Mi4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0zMy4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjQxLjB9LCJcdTAwMDd7TGluayBBY3RpdmV974aTICAgXHUwMDA3REVGQVVMVENyb3VjaGluZyI6eyJjaG9rZV9tZXRob2QiOjEuMCwiY2hva2VfbnVtYmVycyI6Ni4wLCJjaG9rZV9zbGlkZXIiOjUuMCwiY2hva2Vfc2xpZGVyMiI6MTYuMCwiZGVsYXlfMSI6MS4wLCJkZWxheV8yIjoxLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6My4wLCJkZWxheV81IjoxLjAsImRlbGF5XzYiOjEuMCwiZGVsYXlfbnVtYmVycyI6Ni4wLCJkZXN5bmMiOjEuMCwiZGVzeW5jX2RlbGF5Ijo0LjAsImRlc3luY19mcmVlc3RhbmRpbmciOjEuMCwiZGVzeW5jX2Zyb20iOjQ4LjAsImRlc3luY19pbnZlcnRlciI6ZmFsc2UsImRlc3luY19sZWZ0Ijo2MC4wLCJkZXN5bmNfbGltaXRfbW9kZSI6My4wLCJkZXN5bmNfbWF4Ijo1OC4wLCJkZXN5bmNfbWluIjo0OC4wLCJkZXN5bmNfbW9kZSI6MS4wLCJkZXN5bmNfbXVsdGlwbGllciI6NC4wLCJkZXN5bmNfcmFuZ2VfZnJvbSI6NTguMCwiZGVzeW5jX3JpZ2h0Ijo2MC4wLCJkZXN5bmNfc3BlZWRfdG8iOjUuMCwiZGVzeW5jX3RvIjo1OC4wLCJkZXN5bmNfdHdlYWtzIjpbIkppdHRlciIsIn4iXSwibW9kaWZpZXIiOjEuMCwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfaml0dGVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9tYXhpbXVtX29mZnNldCI6MjIuMCwibW9kaWZpZXJfbWV0aG9kIjoxLjAsIm1vZGlmaWVyX21pbmltdW1fb2Zmc2V0IjotMjIuMCwibW9kaWZpZXJfbnVtYmVycyI6NC4wLCJtb2RpZmllcl9yYW5kb21faml0dGVyIjp0cnVlLCJuZXZlcmxvc2VfbW9kZSI6MC4wLCJyYW5kb21fY2hva2UiOmZhbHNlLCJzbmFwIjpmYWxzZSwic25hcF9kaXNhYmxlcnMiOlsifiJdLCJzbmFwX2Rpc3RvcnRpb25fcmFuZ2UiOjE4MC4wLCJzbmFwX2Rpc3RvcnRpb25fc3BlZWQiOjUuMCwic25hcF9sZWZ0X29mZnNldCI6MC4wLCJzbmFwX29mZnNldCI6MC4wLCJzbmFwX29ubHlfd2hlbl9oaXR0YWJsZSI6ZmFsc2UsInNuYXBfcGl0Y2giOiJEb3duIiwic25hcF9waXRjaF9mcm9tIjotODkuMCwic25hcF9waXRjaF9vZmZzZXQiOjAuMCwic25hcF9waXRjaF90byI6ODkuMCwic25hcF9yYW5kb20iOi04OS4wLCJzbmFwX3JhbmRvbTIiOjg5LjAsInNuYXBfcmlnaHRfb2Zmc2V0IjowLjAsInNuYXBfc3Bpbl9yYW5nZSI6MTgwLjAsInNuYXBfc3Bpbl9zcGVlZCI6NS4wLCJzbmFwX3lhdyI6IlNpZGV3YXlzIiwic25hcF95YXdfcmFuZG9tIjotMTgwLjAsInNuYXBfeWF3X3JhbmRvbTIiOjE4MC4wLCJ0aWNrYmFzZV8xIjoxNi4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrc190byI6MTYuMCwieWF3IjoxLjAsInlhd19kZWxheV9ib29sIjoxLjAsInlhd19kZWxheV9tYXgiOjUuMCwieWF3X2RlbGF5X21ldGhvZCI6My4wLCJ5YXdfZGVsYXlfbWluIjoxLjAsInlhd19kZWxheV9tdWx0aXBsaWVyIjoyLjAsInlhd19sZWZ0X29mZnNldCI6LTIyLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjYuMCwieWF3X3JpZ2h0X29mZnNldCI6MzMuMH0sIlx1MDAwN3tMaW5rIEFjdGl2ZX3vlZQgICAgIFx1MDAwN0RFRkFVTFRTbG93aW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6NC4wLCJjaG9rZV9zbGlkZXIyIjoxNi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjQuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjYwLjAsImRlc3luY19saW1pdF9tb2RlIjoxLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjo0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6MS4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjoxMC4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi0xMC4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjowLjAsInJhbmRvbV9jaG9rZSI6dHJ1ZSwic25hcCI6ZmFsc2UsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOmZhbHNlLCJzbmFwX3BpdGNoIjoiRG93biIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJTaWRld2F5cyIsInNuYXBfeWF3X3JhbmRvbSI6LTE4MC4wLCJzbmFwX3lhd19yYW5kb20yIjoxODAuMCwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjE2LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MS4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjoyLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjMuMCwieWF3X2xlZnRfb2Zmc2V0IjotMzguMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0Ijo0NS4wfSwiXHUwMDA3e0xpbmsgQWN0aXZlfe+cjCAgICBcdTAwMDdERUZBVUxUUnVubmluZyI6eyJjaG9rZV9tZXRob2QiOjEuMCwiY2hva2VfbnVtYmVycyI6Ni4wLCJjaG9rZV9zbGlkZXIiOjcuMCwiY2hva2Vfc2xpZGVyMiI6MjIuMCwiZGVsYXlfMSI6MS4wLCJkZWxheV8yIjoxMC4wLCJkZWxheV8zIjoxNS4wLCJkZWxheV80IjoyMC4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwiZGVsYXlfbnVtYmVycyI6NC4wLCJkZXN5bmMiOjEuMCwiZGVzeW5jX2RlbGF5IjoxMy4wLCJkZXN5bmNfZnJlZXN0YW5kaW5nIjoxLjAsImRlc3luY19mcm9tIjoyOC4wLCJkZXN5bmNfaW52ZXJ0ZXIiOmZhbHNlLCJkZXN5bmNfbGVmdCI6NjAuMCwiZGVzeW5jX2xpbWl0X21vZGUiOjEuMCwiZGVzeW5jX21heCI6NTguMCwiZGVzeW5jX21pbiI6NjAuMCwiZGVzeW5jX21vZGUiOjEuMCwiZGVzeW5jX211bHRpcGxpZXIiOjEzLjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6MS4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjoxMC4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi0xMC4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjowLjAsInJhbmRvbV9jaG9rZSI6dHJ1ZSwic25hcCI6ZmFsc2UsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOmZhbHNlLCJzbmFwX3BpdGNoIjoiRG93biIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJTaWRld2F5cyIsInNuYXBfeWF3X3JhbmRvbSI6LTE4MC4wLCJzbmFwX3lhd19yYW5kb20yIjoxODAuMCwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjE2LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MC4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjozLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjIuMCwieWF3X2xlZnRfb2Zmc2V0IjotMjUuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6Ni4wLCJ5YXdfcmlnaHRfb2Zmc2V0Ijo0Mi4wfSwiYWlybGFnIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOnRydWUsImJsb2NrX2ppdHRlciI6dHJ1ZSwiY2lyY3Vtc3RhbmNlcyI6Ny4wLCJkaXNhYmxlcl9sZWZ0X29mZnNldCI6LTMwLjAsImRpc2FibGVyX3BpdGNoIjoiRGlzYWJsZWQiLCJkaXNhYmxlcl9yYW5nZSI6MTgwLjAsImRpc2FibGVyX3JpZ2h0X29mZnNldCI6MzAuMCwiZGlzYWJsZXJfc3BlZWQiOjIuMCwiZGlzYWJsZXJfeWF3IjoiU3BpbiIsImZsdWN0dWF0ZSI6Mi4wLCJmb3JjZV9icmVha19sYWdjb21wIjpbIlx1MDAwN3tMaW5rIEFjdGl2ZX3vhoMgICAgIFx1MDAwN0RFRkFVTFRTdGFuZGluZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3vnIwgICAgXHUwMDA3REVGQVVMVFJ1bm5pbmciLCJcdTAwMDd7TGluayBBY3RpdmV975WUICAgICBcdTAwMDdERUZBVUxUU2xvd2luZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3vhpMgICBcdTAwMDdERUZBVUxUQ3JvdWNoaW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe6LjiAgICBcdTAwMDdERUZBVUxUU25lYWtpbmciLCJcdTAwMDd7TGluayBBY3RpdmV97pWGICAgIFx1MDAwN0RFRkFVTFRBaXIiLCJcdTAwMDd7TGluayBBY3RpdmV97pWHICBcdTAwMDdERUZBVUxUQWlyIENyb3VjaGluZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3uk4EgICBcdTAwMDdERUZBVUxURnJlZXN0YW5kaW5nIiwifiJdLCJmcmVlc3RhbmRfZGlzYWJsZXJzIjpbIn4iXSwiZnJlZXN0YW5kX21vZGlmaWVycyI6My4wLCJmcmVlc3RhbmRpbmciOmZhbHNlLCJmcmVlc3RhbmRpbmdfYm9vbCI6MS4wLCJoc19tb2RlIjoiRmF2b3IgRmlyZSBSYXRlIiwibWFudWFsX3lhdyI6IkRpc2FibGVkIiwic2FmZV9oZWFkX2hlaWdodCI6MC4wLCJ0d2Vha3MiOjAuMH0sImhvbWUiOnsiYWJvdXRfbGlzdCI6MS4wLCJsb2FkX2xpbmUiOjEuMCwicHJlc2V0X2lucHV0IjoiYXNkIiwicHJlc2V0X2xpc3QiOjcuMCwid2F0ZXJtYXJrX2FjY2VudCI6IiNGRkZGRkY3QSIsIndhdGVybWFya19mb250IjoxLjAsIndhdGVybWFya19ncmFkaWVudCI6MC4wLCJ3YXRlcm1hcmtfZ3JhZGllbnRfaHVlIjowLjAsIndhdGVybWFya19ncmFkaWVudF9yYWluYm93IjoxLjAsIndhdGVybWFya19ncmFkaWVudF9zYXR1cmF0aW9uIjo1LjAsIndhdGVybWFya19ncmFkaWVudF9zcGVlZCI6Mi4wLCJ3YXRlcm1hcmtfaW5wdXQiOiJkZXN5bmMubWF4Iiwid2F0ZXJtYXJrX3Bvc2l0aW9uIjoxLjAsIndhdGVybWFya194IjoxMjgwLjAsIndhdGVybWFya195IjoxNDMwLjB9LCJvdGhlciI6eyIqaGlnaGxpZ2h0IjoiI0ZGRkZGRkZGIiwiYWRkb25zIjpbIlx1MDAwN3tMaW5rIEFjdGl2ZX3vlYsgIFx1MDAwN0RFRkFVTFREaXNhYmxlIEZvb3QgU2hhZG93cyIsIn4iXSwiYXNwZWN0X3JhdGlvIjp0cnVlLCJhc3BlY3RfcmF0aW9faGVpZ2h0IjoxNDQwLjAsImFzcGVjdF9yYXRpb19saXN0IjoiNDozICgxMDI0eDc2OCkiLCJhc3BlY3RfcmF0aW9fbWV0aG9kIjoxLjAsImFzcGVjdF9yYXRpb19zbGlkZXIiOjEzMy4wLCJhc3BlY3RfcmF0aW9fd2lkdGgiOjI1NjAuMCwiY3VzdG9tX3Njb3BlX292ZXJsYXkiOnRydWUsImRhbWFnZV9pbmRpY2F0b3IiOnRydWUsImRlYnVnX3RleHQiOmZhbHNlLCJmYXN0X2xhZGRlciI6ZmFsc2UsImZvdiI6NjMuMCwiZnJlZXpldGltZWZkIjp0cnVlLCJoaWdobGlnaHQiOmZhbHNlLCJoaWdobGlnaHRfY29sb3IiOiIjRkZGRkZGRkYiLCJoaXRtYXJrZXJzIjpbIlNrZWV0IiwiS2liaXQiLCJ+Il0sImtlZXB0cmFuc3BhcmVuY3kiOnRydWUsImtpYml0X2NvbG9yeCI6IiNGRkZGRkZGRiIsImtpYml0X2NvbG9yeSI6IiNGRkZGRkZGRiIsImxvZ19haW1ib3QiOnRydWUsImxvZ19jb2xvciI6IiNGRkZGRkZGRiIsImxvZ19wdXJjaGFzZXMiOnRydWUsIm1hbnVhbF9hcnJvd3MiOmZhbHNlLCJtYW51YWxfYXJyb3dzX2NsciI6IiNCREJEQkRGRiIsIm1hbnVhbF9hcnJvd3NfZm9udCI6MS4wLCJtYW51YWxfYXJyb3dzX2ZvcndhcmQiOiJeIiwibWFudWFsX2Fycm93c19sZWZ0IjoiPCIsIm1hbnVhbF9hcnJvd3NfcmlnaHQiOiI+Iiwibm9fZmFsbF9kYW1hZ2UiOnRydWUsInBsYXllcl9hbmltYXRpb25zIjpbIn4iXSwicGxheWVyX2FuaW1hdGlvbnNfZmFsbGluZyI6MC4wLCJwbGF5ZXJfYW5pbWF0aW9uc19pbnRlcnBvbGF0aW5nIjowLjAsInBsYXllcl9hbmltYXRpb25zX2xlYW5pbmciOjEwMC4wLCJwbGF5ZXJfYW5pbWF0aW9uc193YWxraW5nIjowLjAsInNjb3BlX2NvbG9yIjoiIzg2ODY4NkZGIiwic2NvcGVfZXh0cmEiOlsifiJdLCJzY29wZV9nYXAiOjEwLjAsInNjb3BlX3NpemUiOjIwNi4wLCJ0ZWFtbWF0ZV9haW1ib3QiOmZhbHNlLCJ1bmxvY2tfZmFrZV9sYXRlbmN5Ijp0cnVlLCJ2aWV3bW9kZWwiOnRydWUsIngiOi05LjAsInkiOjEyLjAsInoiOjEyLjB9fQ==";
        end;
        if not v593.database[l_pui_0.string("Snap  \v\239\130\134")] or #v593.database == 0 then
            v593.database[l_pui_0.string("Snap  \v\239\130\134")] = "eyJhbnRpYWltIjp7Ilx1MDAwN3tMaW5rIEFjdGl2ZX3ui44gICAgXHUwMDA3REVGQVVMVFNuZWFraW5nIjp7ImNob2tlX21ldGhvZCI6Mi4wLCJjaG9rZV9udW1iZXJzIjo0LjAsImNob2tlX3NsaWRlciI6Ny4wLCJjaG9rZV9zbGlkZXIyIjoxNi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjQuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjYwLjAsImRlc3luY19saW1pdF9tb2RlIjoxLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjo0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiQXZvaWQgT3ZlcmxhcCIsIkppdHRlciIsIlJhbmRvbWl6ZSBKaXR0ZXIiLCJ+Il0sIm1vZGlmaWVyIjo2LjAsIm1vZGlmaWVyXzEiOi01LjAsIm1vZGlmaWVyXzIiOjUuMCwibW9kaWZpZXJfMyI6LTguMCwibW9kaWZpZXJfNCI6OC4wLCJtb2RpZmllcl81IjotNy4wLCJtb2RpZmllcl82Ijo3LjAsIm1vZGlmaWVyX2ppdHRlcl9vZmZzZXQiOjAuMCwibW9kaWZpZXJfbWF4aW11bV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfbWV0aG9kIjoyLjAsIm1vZGlmaWVyX21pbmltdW1fb2Zmc2V0IjowLjAsIm1vZGlmaWVyX251bWJlcnMiOjYuMCwibW9kaWZpZXJfcmFuZG9tX2ppdHRlciI6dHJ1ZSwibmV2ZXJsb3NlX21vZGUiOjEuMCwicmFuZG9tX2Nob2tlIjp0cnVlLCJzbmFwIjp0cnVlLCJzbmFwX2Rpc2FibGVycyI6WyJ+Il0sInNuYXBfZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsInNuYXBfZGlzdG9ydGlvbl9zcGVlZCI6NS4wLCJzbmFwX2xlZnRfb2Zmc2V0IjowLjAsInNuYXBfb2Zmc2V0IjowLjAsInNuYXBfb25seV93aGVuX2hpdHRhYmxlIjpmYWxzZSwic25hcF9waXRjaCI6IlNlbWktVXAiLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTg5LjAsInNuYXBfcmFuZG9tMiI6ODkuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiU2lkZXdheXMiLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjcuMCwidGlja2Jhc2VfMiI6OC4wLCJ0aWNrYmFzZV8zIjo2LjAsInRpY2tiYXNlXzQiOjkuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjE2LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MC4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjoxLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjIuMCwieWF3X2xlZnRfb2Zmc2V0IjotMjIuMCwieWF3X21vZGUiOjEuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0Ijo0NC4wfSwiXHUwMDA3e0xpbmsgQWN0aXZlfe6TgSAgIFx1MDAwN0RFRkFVTFRGcmVlc3RhbmRpbmciOnsiY2hva2VfbWV0aG9kIjoxLjAsImNob2tlX251bWJlcnMiOjYuMCwiY2hva2Vfc2xpZGVyIjoxNi4wLCJjaG9rZV9zbGlkZXIyIjoxNi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjQuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6My4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjYwLjAsImRlc3luY19saW1pdF9tb2RlIjoxLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjo0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiQXZvaWQgT3ZlcmxhcCIsIkppdHRlciIsIn4iXSwibW9kaWZpZXIiOjEuMCwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfaml0dGVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9tYXhpbXVtX29mZnNldCI6MC4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfbnVtYmVycyI6Ni4wLCJtb2RpZmllcl9yYW5kb21faml0dGVyIjpmYWxzZSwibmV2ZXJsb3NlX21vZGUiOjAuMCwicmFuZG9tX2Nob2tlIjpmYWxzZSwic25hcCI6ZmFsc2UsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOmZhbHNlLCJzbmFwX3BpdGNoIjoiRG93biIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJTaWRld2F5cyIsInNuYXBfeWF3X3JhbmRvbSI6LTE4MC4wLCJzbmFwX3lhd19yYW5kb20yIjoxODAuMCwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjE2LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MC4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjoxLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjIuMCwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RlIjoxLjAsInlhd19vZmZzZXQiOjYuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wfSwiXHUwMDA3e0xpbmsgQWN0aXZlfe6VhiAgICBcdTAwMDdERUZBVUxUQWlyIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6Mi4wLCJjaG9rZV9zbGlkZXIyIjoyMi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjQuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjYwLjAsImRlc3luY19saW1pdF9tb2RlIjoxLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjo0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6MS4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjoxMS4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi0xMS4wLCJtb2RpZmllcl9udW1iZXJzIjo2LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjoxLjAsInJhbmRvbV9jaG9rZSI6dHJ1ZSwic25hcCI6dHJ1ZSwic25hcF9kaXNhYmxlcnMiOlsifiJdLCJzbmFwX2Rpc3RvcnRpb25fcmFuZ2UiOjE4MC4wLCJzbmFwX2Rpc3RvcnRpb25fc3BlZWQiOjUuMCwic25hcF9sZWZ0X29mZnNldCI6MC4wLCJzbmFwX29mZnNldCI6MC4wLCJzbmFwX29ubHlfd2hlbl9oaXR0YWJsZSI6ZmFsc2UsInNuYXBfcGl0Y2giOiJEb3duIiwic25hcF9waXRjaF9mcm9tIjotODkuMCwic25hcF9waXRjaF9vZmZzZXQiOjAuMCwic25hcF9waXRjaF90byI6ODkuMCwic25hcF9yYW5kb20iOi04OS4wLCJzbmFwX3JhbmRvbTIiOjg5LjAsInNuYXBfcmlnaHRfb2Zmc2V0IjowLjAsInNuYXBfc3Bpbl9yYW5nZSI6MTgwLjAsInNuYXBfc3Bpbl9zcGVlZCI6NS4wLCJzbmFwX3lhdyI6Ik9wcG9zaXRlIiwic25hcF95YXdfcmFuZG9tIjotMTgwLjAsInNuYXBfeWF3X3JhbmRvbTIiOjE4MC4wLCJ0aWNrYmFzZV8xIjoyLjAsInRpY2tiYXNlXzIiOjEwLjAsInRpY2tiYXNlXzMiOjkuMCwidGlja2Jhc2VfNCI6MTQuMCwidGlja2Jhc2VfNSI6MjAuMCwidGlja2Jhc2VfNiI6MTcuMCwidGlja3NfdG8iOjE2LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MC4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjoxLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjEwLjAsInlhd19sZWZ0X29mZnNldCI6LTIyLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjYuMCwieWF3X3JpZ2h0X29mZnNldCI6MzMuMH0sIlx1MDAwN3tMaW5rIEFjdGl2ZX3ulYcgIFx1MDAwN0RFRkFVTFRBaXIgQ3JvdWNoaW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjoyLjAsImNob2tlX3NsaWRlciI6Mi4wLCJjaG9rZV9zbGlkZXIyIjoyMi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjE0LjAsImRlc3luY19mcmVlc3RhbmRpbmciOjEuMCwiZGVzeW5jX2Zyb20iOjI4LjAsImRlc3luY19pbnZlcnRlciI6ZmFsc2UsImRlc3luY19sZWZ0Ijo2MC4wLCJkZXN5bmNfbGltaXRfbW9kZSI6MS4wLCJkZXN5bmNfbWF4Ijo1OC4wLCJkZXN5bmNfbWluIjoyOC4wLCJkZXN5bmNfbW9kZSI6MS4wLCJkZXN5bmNfbXVsdGlwbGllciI6MTQuMCwiZGVzeW5jX3JhbmdlX2Zyb20iOjU4LjAsImRlc3luY19yaWdodCI6NjAuMCwiZGVzeW5jX3NwZWVkX3RvIjo1LjAsImRlc3luY190byI6NTguMCwiZGVzeW5jX3R3ZWFrcyI6WyJKaXR0ZXIiLCJ+Il0sIm1vZGlmaWVyIjo0LjAsIm1vZGlmaWVyXzEiOjAuMCwibW9kaWZpZXJfMiI6MC4wLCJtb2RpZmllcl8zIjowLjAsIm1vZGlmaWVyXzQiOjAuMCwibW9kaWZpZXJfNSI6MC4wLCJtb2RpZmllcl82IjowLjAsIm1vZGlmaWVyX2ppdHRlcl9vZmZzZXQiOjAuMCwibW9kaWZpZXJfbWF4aW11bV9vZmZzZXQiOjIyLjAsIm1vZGlmaWVyX21ldGhvZCI6MS4wLCJtb2RpZmllcl9taW5pbXVtX29mZnNldCI6LTIyLjAsIm1vZGlmaWVyX251bWJlcnMiOjYuMCwibW9kaWZpZXJfcmFuZG9tX2ppdHRlciI6dHJ1ZSwibmV2ZXJsb3NlX21vZGUiOjEuMCwicmFuZG9tX2Nob2tlIjp0cnVlLCJzbmFwIjp0cnVlLCJzbmFwX2Rpc2FibGVycyI6WyJ+Il0sInNuYXBfZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsInNuYXBfZGlzdG9ydGlvbl9zcGVlZCI6NS4wLCJzbmFwX2xlZnRfb2Zmc2V0IjowLjAsInNuYXBfb2Zmc2V0IjowLjAsInNuYXBfb25seV93aGVuX2hpdHRhYmxlIjpmYWxzZSwic25hcF9waXRjaCI6IkRvd24iLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTg5LjAsInNuYXBfcmFuZG9tMiI6ODkuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiT3Bwb3NpdGUiLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjcuMCwidGlja2Jhc2VfMiI6MTMuMCwidGlja2Jhc2VfMyI6MjEuMCwidGlja2Jhc2VfNCI6OS4wLCJ0aWNrYmFzZV81IjoxNC4wLCJ0aWNrYmFzZV82Ijo3LjAsInRpY2tzX3RvIjoxNi4wLCJ5YXciOjEuMCwieWF3X2RlbGF5X2Jvb2wiOjAuMCwieWF3X2RlbGF5X21heCI6MTAuMCwieWF3X2RlbGF5X21ldGhvZCI6MS4wLCJ5YXdfZGVsYXlfbWluIjoxLjAsInlhd19kZWxheV9tdWx0aXBsaWVyIjo4LjAsInlhd19sZWZ0X29mZnNldCI6LTE4LjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6NDQuMH0sIlx1MDAwN3tMaW5rIEFjdGl2ZX3vhoMgICAgIFx1MDAwN0RFRkFVTFRTdGFuZGluZyI6eyJjaG9rZV9tZXRob2QiOjEuMCwiY2hva2VfbnVtYmVycyI6Ni4wLCJjaG9rZV9zbGlkZXIiOjE2LjAsImNob2tlX3NsaWRlcjIiOjE2LjAsImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6Mi4wLCJkZWxheV8zIjoyLjAsImRlbGF5XzQiOjIuMCwiZGVsYXlfNSI6Mi4wLCJkZWxheV82IjoyLjAsImRlbGF5X251bWJlcnMiOjQuMCwiZGVzeW5jIjoxLjAsImRlc3luY19kZWxheSI6NC4wLCJkZXN5bmNfZnJlZXN0YW5kaW5nIjoxLjAsImRlc3luY19mcm9tIjoyOC4wLCJkZXN5bmNfaW52ZXJ0ZXIiOmZhbHNlLCJkZXN5bmNfbGVmdCI6NjAuMCwiZGVzeW5jX2xpbWl0X21vZGUiOjIuMCwiZGVzeW5jX21heCI6NDkuMCwiZGVzeW5jX21pbiI6NDkuMCwiZGVzeW5jX21vZGUiOjEuMCwiZGVzeW5jX211bHRpcGxpZXIiOjQuMCwiZGVzeW5jX3JhbmdlX2Zyb20iOjU4LjAsImRlc3luY19yaWdodCI6NjAuMCwiZGVzeW5jX3NwZWVkX3RvIjo1LjAsImRlc3luY190byI6NTguMCwiZGVzeW5jX3R3ZWFrcyI6WyJBdm9pZCBPdmVybGFwIiwiSml0dGVyIiwiUmFuZG9taXplIEppdHRlciIsIn4iXSwibW9kaWZpZXIiOjEuMCwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfaml0dGVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9tYXhpbXVtX29mZnNldCI6NS4wLCJtb2RpZmllcl9tZXRob2QiOjIuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi01LjAsIm1vZGlmaWVyX251bWJlcnMiOjYuMCwibW9kaWZpZXJfcmFuZG9tX2ppdHRlciI6dHJ1ZSwibmV2ZXJsb3NlX21vZGUiOjEuMCwicmFuZG9tX2Nob2tlIjpmYWxzZSwic25hcCI6dHJ1ZSwic25hcF9kaXNhYmxlcnMiOlsifiJdLCJzbmFwX2Rpc3RvcnRpb25fcmFuZ2UiOjE4MC4wLCJzbmFwX2Rpc3RvcnRpb25fc3BlZWQiOjUuMCwic25hcF9sZWZ0X29mZnNldCI6MC4wLCJzbmFwX29mZnNldCI6MC4wLCJzbmFwX29ubHlfd2hlbl9oaXR0YWJsZSI6ZmFsc2UsInNuYXBfcGl0Y2giOiJTZW1pLVVwIiwic25hcF9waXRjaF9mcm9tIjotODkuMCwic25hcF9waXRjaF9vZmZzZXQiOjAuMCwic25hcF9waXRjaF90byI6ODkuMCwic25hcF9yYW5kb20iOi04OS4wLCJzbmFwX3JhbmRvbTIiOjg5LjAsInNuYXBfcmlnaHRfb2Zmc2V0IjowLjAsInNuYXBfc3Bpbl9yYW5nZSI6MTgwLjAsInNuYXBfc3Bpbl9zcGVlZCI6NS4wLCJzbmFwX3lhdyI6IlNpZGV3YXlzIiwic25hcF95YXdfcmFuZG9tIjotMTgwLjAsInNuYXBfeWF3X3JhbmRvbTIiOjE4MC4wLCJ0aWNrYmFzZV8xIjoxNi4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrc190byI6Ny4wLCJ5YXciOjEuMCwieWF3X2RlbGF5X2Jvb2wiOjAuMCwieWF3X2RlbGF5X21heCI6MTAuMCwieWF3X2RlbGF5X21ldGhvZCI6MS4wLCJ5YXdfZGVsYXlfbWluIjoxLjAsInlhd19kZWxheV9tdWx0aXBsaWVyIjoyLjAsInlhd19sZWZ0X29mZnNldCI6LTI0LjAsInlhd19tb2RlIjoxLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6NDEuMH0sIlx1MDAwN3tMaW5rIEFjdGl2ZX3vhpMgICBcdTAwMDdERUZBVUxUQ3JvdWNoaW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6NS4wLCJjaG9rZV9zbGlkZXIyIjoxNi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjMuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjQ1LjAsImRlc3luY19saW1pdF9tb2RlIjoxLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjoxNi4wLCJkZXN5bmNfcmFuZ2VfZnJvbSI6NTguMCwiZGVzeW5jX3JpZ2h0Ijo0NS4wLCJkZXN5bmNfc3BlZWRfdG8iOjUuMCwiZGVzeW5jX3RvIjo1OC4wLCJkZXN5bmNfdHdlYWtzIjpbIkF2b2lkIE92ZXJsYXAiLCJKaXR0ZXIiLCJSYW5kb21pemUgSml0dGVyIiwifiJdLCJtb2RpZmllciI6MS4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjoyMi4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi0yMi4wLCJtb2RpZmllcl9udW1iZXJzIjo2LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjoxLjAsInJhbmRvbV9jaG9rZSI6ZmFsc2UsInNuYXAiOnRydWUsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOmZhbHNlLCJzbmFwX3BpdGNoIjoiU2VtaS1VcCIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJTaWRld2F5cyIsInNuYXBfeWF3X3JhbmRvbSI6LTE4MC4wLCJzbmFwX3lhd19yYW5kb20yIjoxODAuMCwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjcuMCwieWF3IjoxLjAsInlhd19kZWxheV9ib29sIjowLjAsInlhd19kZWxheV9tYXgiOjEwLjAsInlhd19kZWxheV9tZXRob2QiOjEuMCwieWF3X2RlbGF5X21pbiI6MS4wLCJ5YXdfZGVsYXlfbXVsdGlwbGllciI6Mi4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0zMi4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjQ2LjB9LCJcdTAwMDd7TGluayBBY3RpdmV975WUICAgICBcdTAwMDdERUZBVUxUU2xvd2luZyI6eyJjaG9rZV9tZXRob2QiOjIuMCwiY2hva2VfbnVtYmVycyI6Ni4wLCJjaG9rZV9zbGlkZXIiOjQuMCwiY2hva2Vfc2xpZGVyMiI6MTYuMCwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwiZGVsYXlfbnVtYmVycyI6NC4wLCJkZXN5bmMiOjEuMCwiZGVzeW5jX2RlbGF5Ijo0LjAsImRlc3luY19mcmVlc3RhbmRpbmciOjEuMCwiZGVzeW5jX2Zyb20iOjI4LjAsImRlc3luY19pbnZlcnRlciI6ZmFsc2UsImRlc3luY19sZWZ0Ijo0OS4wLCJkZXN5bmNfbGltaXRfbW9kZSI6MS4wLCJkZXN5bmNfbWF4Ijo1OC4wLCJkZXN5bmNfbWluIjoyOC4wLCJkZXN5bmNfbW9kZSI6MS4wLCJkZXN5bmNfbXVsdGlwbGllciI6NC4wLCJkZXN5bmNfcmFuZ2VfZnJvbSI6NTguMCwiZGVzeW5jX3JpZ2h0Ijo1MC4wLCJkZXN5bmNfc3BlZWRfdG8iOjUuMCwiZGVzeW5jX3RvIjo1OC4wLCJkZXN5bmNfdHdlYWtzIjpbIkF2b2lkIE92ZXJsYXAiLCJKaXR0ZXIiLCJSYW5kb21pemUgSml0dGVyIiwifiJdLCJtb2RpZmllciI6MS4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjoxMC4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi0xMC4wLCJtb2RpZmllcl9udW1iZXJzIjo2LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjoxLjAsInJhbmRvbV9jaG9rZSI6dHJ1ZSwic25hcCI6dHJ1ZSwic25hcF9kaXNhYmxlcnMiOlsifiJdLCJzbmFwX2Rpc3RvcnRpb25fcmFuZ2UiOjE4MC4wLCJzbmFwX2Rpc3RvcnRpb25fc3BlZWQiOjUuMCwic25hcF9sZWZ0X29mZnNldCI6MC4wLCJzbmFwX29mZnNldCI6MC4wLCJzbmFwX29ubHlfd2hlbl9oaXR0YWJsZSI6ZmFsc2UsInNuYXBfcGl0Y2giOiJSYW5kb20iLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTYwLjAsInNuYXBfcmFuZG9tMiI6MjAuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiU2lkZXdheXMiLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjcuMCwidGlja2Jhc2VfMiI6OC4wLCJ0aWNrYmFzZV8zIjo5LjAsInRpY2tiYXNlXzQiOjkuMCwidGlja2Jhc2VfNSI6OC4wLCJ0aWNrYmFzZV82Ijo3LjAsInRpY2tzX3RvIjoxNi4wLCJ5YXciOjEuMCwieWF3X2RlbGF5X2Jvb2wiOjAuMCwieWF3X2RlbGF5X21heCI6MTAuMCwieWF3X2RlbGF5X21ldGhvZCI6MS4wLCJ5YXdfZGVsYXlfbWluIjoxLjAsInlhd19kZWxheV9tdWx0aXBsaWVyIjoyLjAsInlhd19sZWZ0X29mZnNldCI6LTI3LjAsInlhd19tb2RlIjoxLjAsInlhd19vZmZzZXQiOjAuMCwieWF3X3JpZ2h0X29mZnNldCI6NDQuMH0sIlx1MDAwN3tMaW5rIEFjdGl2ZX3vnIwgICAgXHUwMDA3REVGQVVMVFJ1bm5pbmciOnsiY2hva2VfbWV0aG9kIjoxLjAsImNob2tlX251bWJlcnMiOjYuMCwiY2hva2Vfc2xpZGVyIjo3LjAsImNob2tlX3NsaWRlcjIiOjIyLjAsImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6Mi4wLCJkZWxheV8zIjoyLjAsImRlbGF5XzQiOjIuMCwiZGVsYXlfNSI6Mi4wLCJkZWxheV82IjoyLjAsImRlbGF5X251bWJlcnMiOjQuMCwiZGVzeW5jIjoxLjAsImRlc3luY19kZWxheSI6MTMuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjYwLjAsImRlc3luY19saW1pdF9tb2RlIjoxLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjYwLjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjoxMy4wLCJkZXN5bmNfcmFuZ2VfZnJvbSI6NTguMCwiZGVzeW5jX3JpZ2h0Ijo2MC4wLCJkZXN5bmNfc3BlZWRfdG8iOjUuMCwiZGVzeW5jX3RvIjo1OC4wLCJkZXN5bmNfdHdlYWtzIjpbIkppdHRlciIsIn4iXSwibW9kaWZpZXIiOjUuMCwibW9kaWZpZXJfMSI6LTUuMCwibW9kaWZpZXJfMiI6NS4wLCJtb2RpZmllcl8zIjoxMS4wLCJtb2RpZmllcl80IjotMTEuMCwibW9kaWZpZXJfNSI6MC4wLCJtb2RpZmllcl82IjowLjAsIm1vZGlmaWVyX2ppdHRlcl9vZmZzZXQiOjAuMCwibW9kaWZpZXJfbWF4aW11bV9vZmZzZXQiOjEwLjAsIm1vZGlmaWVyX21ldGhvZCI6Mi4wLCJtb2RpZmllcl9taW5pbXVtX29mZnNldCI6LTEwLjAsIm1vZGlmaWVyX251bWJlcnMiOjQuMCwibW9kaWZpZXJfcmFuZG9tX2ppdHRlciI6dHJ1ZSwibmV2ZXJsb3NlX21vZGUiOjAuMCwicmFuZG9tX2Nob2tlIjp0cnVlLCJzbmFwIjp0cnVlLCJzbmFwX2Rpc2FibGVycyI6WyJ+Il0sInNuYXBfZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsInNuYXBfZGlzdG9ydGlvbl9zcGVlZCI6NS4wLCJzbmFwX2xlZnRfb2Zmc2V0IjowLjAsInNuYXBfb2Zmc2V0IjowLjAsInNuYXBfb25seV93aGVuX2hpdHRhYmxlIjp0cnVlLCJzbmFwX3BpdGNoIjoiVXAiLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTg5LjAsInNuYXBfcmFuZG9tMiI6ODkuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiT2Zmc2V0Iiwic25hcF95YXdfcmFuZG9tIjotMTgwLjAsInNuYXBfeWF3X3JhbmRvbTIiOjE4MC4wLCJ0aWNrYmFzZV8xIjoxNi4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrc190byI6MTYuMCwieWF3IjoxLjAsInlhd19kZWxheV9ib29sIjowLjAsInlhd19kZWxheV9tYXgiOjEwLjAsInlhd19kZWxheV9tZXRob2QiOjEuMCwieWF3X2RlbGF5X21pbiI6MS4wLCJ5YXdfZGVsYXlfbXVsdGlwbGllciI6Mi4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0yMi4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0Ijo2LjAsInlhd19yaWdodF9vZmZzZXQiOjI4LjB9LCJhaXJsYWciOmZhbHNlLCJhdm9pZF9iYWNrc3RhYiI6dHJ1ZSwiYmxvY2tfaml0dGVyIjp0cnVlLCJjaXJjdW1zdGFuY2VzIjo3LjAsImRpc2FibGVyX2xlZnRfb2Zmc2V0IjotMzAuMCwiZGlzYWJsZXJfcGl0Y2giOiJEaXNhYmxlZCIsImRpc2FibGVyX3JhbmdlIjoxODAuMCwiZGlzYWJsZXJfcmlnaHRfb2Zmc2V0IjozMC4wLCJkaXNhYmxlcl9zcGVlZCI6Mi4wLCJkaXNhYmxlcl95YXciOiJTcGluIiwiZmx1Y3R1YXRlIjoyLjAsImZvcmNlX2JyZWFrX2xhZ2NvbXAiOlsiXHUwMDA3e0xpbmsgQWN0aXZlfe+GgyAgICAgXHUwMDA3REVGQVVMVFN0YW5kaW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe+cjCAgICBcdTAwMDdERUZBVUxUUnVubmluZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3vlZQgICAgIFx1MDAwN0RFRkFVTFRTbG93aW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe+GkyAgIFx1MDAwN0RFRkFVTFRDcm91Y2hpbmciLCJcdTAwMDd7TGluayBBY3RpdmV97ouOICAgIFx1MDAwN0RFRkFVTFRTbmVha2luZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3ulYYgICAgXHUwMDA3REVGQVVMVEFpciIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3ulYcgIFx1MDAwN0RFRkFVTFRBaXIgQ3JvdWNoaW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe6TgSAgIFx1MDAwN0RFRkFVTFRGcmVlc3RhbmRpbmciLCJ+Il0sImZyZWVzdGFuZF9kaXNhYmxlcnMiOlsifiJdLCJmcmVlc3RhbmRfbW9kaWZpZXJzIjozLjAsImZyZWVzdGFuZGluZyI6ZmFsc2UsImZyZWVzdGFuZGluZ19ib29sIjoxLjAsImhzX21vZGUiOiJCcmVhayBMQyIsIm1hbnVhbF95YXciOiJEaXNhYmxlZCIsInNhZmVfaGVhZF9oZWlnaHQiOjAuMCwidHdlYWtzIjowLjB9LCJob21lIjp7ImFib3V0X2xpc3QiOjEuMCwibG9hZF9saW5lIjoxLjAsInByZXNldF9pbnB1dCI6IlNuYXAgIFx1MDAwN3tMaW5rIEFjdGl2ZX3vgoYiLCJwcmVzZXRfbGlzdCI6Ny4wLCJ3YXRlcm1hcmtfYWNjZW50IjoiI0ZGRkZGRjdBIiwid2F0ZXJtYXJrX2ZvbnQiOjEuMCwid2F0ZXJtYXJrX2dyYWRpZW50IjowLjAsIndhdGVybWFya19ncmFkaWVudF9odWUiOjAuMCwid2F0ZXJtYXJrX2dyYWRpZW50X3JhaW5ib3ciOjEuMCwid2F0ZXJtYXJrX2dyYWRpZW50X3NhdHVyYXRpb24iOjUuMCwid2F0ZXJtYXJrX2dyYWRpZW50X3NwZWVkIjoyLjAsIndhdGVybWFya19pbnB1dCI6ImRlc3luYy5tYXgiLCJ3YXRlcm1hcmtfcG9zaXRpb24iOjEuMCwid2F0ZXJtYXJrX3giOjEyODAuMCwid2F0ZXJtYXJrX3kiOjE0MzAuMH0sIm90aGVyIjp7IipoaWdobGlnaHQiOiIjRkZGRkZGRkYiLCJhZGRvbnMiOlsiXHUwMDA3e0xpbmsgQWN0aXZlfe+ViyAgXHUwMDA3REVGQVVMVERpc2FibGUgRm9vdCBTaGFkb3dzIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe+LsSAgIFx1MDAwN0RFRkFVTFRMZWdhY3kgRGVzeW5jIiwifiJdLCJhc3BlY3RfcmF0aW8iOnRydWUsImFzcGVjdF9yYXRpb19oZWlnaHQiOjE0NDAuMCwiYXNwZWN0X3JhdGlvX2xpc3QiOiI0OjMgKDEwMjR4NzY4KSIsImFzcGVjdF9yYXRpb19tZXRob2QiOjEuMCwiYXNwZWN0X3JhdGlvX3NsaWRlciI6MTMzLjAsImFzcGVjdF9yYXRpb193aWR0aCI6MjU2MC4wLCJjdXN0b21fc2NvcGVfb3ZlcmxheSI6dHJ1ZSwiZGFtYWdlX2luZGljYXRvciI6dHJ1ZSwiZGVidWdfdGV4dCI6ZmFsc2UsImZhc3RfbGFkZGVyIjpmYWxzZSwiZm92Ijo2My4wLCJmcmVlemV0aW1lZmQiOnRydWUsImhpZ2hsaWdodCI6ZmFsc2UsImhpZ2hsaWdodF9jb2xvciI6IiNGRkZGRkZGRiIsImhpdG1hcmtlcnMiOlsiU2tlZXQiLCJLaWJpdCIsIn4iXSwia2VlcHRyYW5zcGFyZW5jeSI6dHJ1ZSwia2liaXRfY29sb3J4IjoiI0ZGRkZGRkZGIiwia2liaXRfY29sb3J5IjoiI0ZGRkZGRkZGIiwibG9nX2FpbWJvdCI6dHJ1ZSwibG9nX2NvbG9yIjoiI0ZGRkZGRkZGIiwibG9nX3B1cmNoYXNlcyI6dHJ1ZSwibWFudWFsX2Fycm93cyI6ZmFsc2UsIm1hbnVhbF9hcnJvd3NfY2xyIjoiI0JEQkRCREZGIiwibWFudWFsX2Fycm93c19mb250IjoxLjAsIm1hbnVhbF9hcnJvd3NfZm9yd2FyZCI6Il4iLCJtYW51YWxfYXJyb3dzX2xlZnQiOiI8IiwibWFudWFsX2Fycm93c19yaWdodCI6Ij4iLCJub19mYWxsX2RhbWFnZSI6ZmFsc2UsInBsYXllcl9hbmltYXRpb25zIjpbIn4iXSwicGxheWVyX2FuaW1hdGlvbnNfZmFsbGluZyI6MC4wLCJwbGF5ZXJfYW5pbWF0aW9uc19pbnRlcnBvbGF0aW5nIjowLjAsInBsYXllcl9hbmltYXRpb25zX2xlYW5pbmciOjUwLjAsInBsYXllcl9hbmltYXRpb25zX3dhbGtpbmciOjAuMCwic2NvcGVfY29sb3IiOiIjODY4Njg2RkYiLCJzY29wZV9leHRyYSI6WyJ+Il0sInNjb3BlX2dhcCI6MTAuMCwic2NvcGVfc2l6ZSI6MjA2LjAsInRlYW1tYXRlX2FpbWJvdCI6ZmFsc2UsInVubG9ja19mYWtlX2xhdGVuY3kiOnRydWUsInZpZXdtb2RlbCI6dHJ1ZSwieCI6LTkuMCwieSI6MTIuMCwieiI6MTIuMH19";
        end;
        if not v593.database[l_pui_0.string("Aggressive  \v\239\129\181")] or #v593.database == 0 then
            v593.database[l_pui_0.string("Aggressive  \v\239\129\181")] = "eyJhbnRpYWltIjp7Ilx1MDAwN3tMaW5rIEFjdGl2ZX3ui44gICAgXHUwMDA3REVGQVVMVFNuZWFraW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6Ny4wLCJjaG9rZV9zbGlkZXIyIjoxNi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjQuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjYwLjAsImRlc3luY19saW1pdF9tb2RlIjoxLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjo0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6My4wLCJtb2RpZmllcl8xIjotNzEuMCwibW9kaWZpZXJfMiI6LTY3LjAsIm1vZGlmaWVyXzMiOi02NS4wLCJtb2RpZmllcl80IjotNDkuMCwibW9kaWZpZXJfNSI6LTc2LjAsIm1vZGlmaWVyXzYiOi00OS4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjoxLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21ldGhvZCI6Mi4wLCJtb2RpZmllcl9taW5pbXVtX29mZnNldCI6MC4wLCJtb2RpZmllcl9udW1iZXJzIjo2LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjowLjAsInJhbmRvbV9jaG9rZSI6dHJ1ZSwic25hcCI6ZmFsc2UsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOnRydWUsInNuYXBfcGl0Y2giOiJVcCIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJPZmZzZXQiLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tzX3RvIjoxNi4wLCJ5YXciOjEuMCwieWF3X2RlbGF5X2Jvb2wiOjAuMCwieWF3X2RlbGF5X21heCI6MTAuMCwieWF3X2RlbGF5X21ldGhvZCI6MS4wLCJ5YXdfZGVsYXlfbWluIjoxLjAsInlhd19kZWxheV9tdWx0aXBsaWVyIjoyLjAsInlhd19sZWZ0X29mZnNldCI6LTIyLjAsInlhd19tb2RlIjoxLjAsInlhd19vZmZzZXQiOjkuMCwieWF3X3JpZ2h0X29mZnNldCI6NDQuMH0sIlx1MDAwN3tMaW5rIEFjdGl2ZX3uk4EgICBcdTAwMDdERUZBVUxURnJlZXN0YW5kaW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6MTYuMCwiY2hva2Vfc2xpZGVyMiI6MTYuMCwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwiZGVsYXlfbnVtYmVycyI6NC4wLCJkZXN5bmMiOjEuMCwiZGVzeW5jX2RlbGF5Ijo0LjAsImRlc3luY19mcmVlc3RhbmRpbmciOjMuMCwiZGVzeW5jX2Zyb20iOjI4LjAsImRlc3luY19pbnZlcnRlciI6ZmFsc2UsImRlc3luY19sZWZ0Ijo2MC4wLCJkZXN5bmNfbGltaXRfbW9kZSI6MS4wLCJkZXN5bmNfbWF4Ijo1OC4wLCJkZXN5bmNfbWluIjoyOC4wLCJkZXN5bmNfbW9kZSI6MS4wLCJkZXN5bmNfbXVsdGlwbGllciI6NC4wLCJkZXN5bmNfcmFuZ2VfZnJvbSI6NTguMCwiZGVzeW5jX3JpZ2h0Ijo2MC4wLCJkZXN5bmNfc3BlZWRfdG8iOjUuMCwiZGVzeW5jX3RvIjo1OC4wLCJkZXN5bmNfdHdlYWtzIjpbIkF2b2lkIE92ZXJsYXAiLCJKaXR0ZXIiLCJ+Il0sIm1vZGlmaWVyIjoxLjAsIm1vZGlmaWVyXzEiOjAuMCwibW9kaWZpZXJfMiI6MC4wLCJtb2RpZmllcl8zIjowLjAsIm1vZGlmaWVyXzQiOjAuMCwibW9kaWZpZXJfNSI6MC4wLCJtb2RpZmllcl82IjowLjAsIm1vZGlmaWVyX2ppdHRlcl9vZmZzZXQiOjAuMCwibW9kaWZpZXJfbWF4aW11bV9vZmZzZXQiOjAuMCwibW9kaWZpZXJfbWV0aG9kIjoxLjAsIm1vZGlmaWVyX21pbmltdW1fb2Zmc2V0IjowLjAsIm1vZGlmaWVyX251bWJlcnMiOjQuMCwibW9kaWZpZXJfcmFuZG9tX2ppdHRlciI6ZmFsc2UsIm5ldmVybG9zZV9tb2RlIjowLjAsInJhbmRvbV9jaG9rZSI6ZmFsc2UsInNuYXAiOmZhbHNlLCJzbmFwX2Rpc2FibGVycyI6WyJ+Il0sInNuYXBfZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsInNuYXBfZGlzdG9ydGlvbl9zcGVlZCI6NS4wLCJzbmFwX2xlZnRfb2Zmc2V0IjowLjAsInNuYXBfb2Zmc2V0IjowLjAsInNuYXBfb25seV93aGVuX2hpdHRhYmxlIjpmYWxzZSwic25hcF9waXRjaCI6IkRvd24iLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTg5LjAsInNuYXBfcmFuZG9tMiI6ODkuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiU2lkZXdheXMiLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tzX3RvIjoxNi4wLCJ5YXciOjEuMCwieWF3X2RlbGF5X2Jvb2wiOjAuMCwieWF3X2RlbGF5X21heCI6MTAuMCwieWF3X2RlbGF5X21ldGhvZCI6MS4wLCJ5YXdfZGVsYXlfbWluIjoxLjAsInlhd19kZWxheV9tdWx0aXBsaWVyIjoyLjAsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfbW9kZSI6MS4wLCJ5YXdfb2Zmc2V0Ijo2LjAsInlhd19yaWdodF9vZmZzZXQiOjAuMH0sIlx1MDAwN3tMaW5rIEFjdGl2ZX3ulYYgICAgXHUwMDA3REVGQVVMVEFpciI6eyJjaG9rZV9tZXRob2QiOjEuMCwiY2hva2VfbnVtYmVycyI6Ni4wLCJjaG9rZV9zbGlkZXIiOjUuMCwiY2hva2Vfc2xpZGVyMiI6MTUuMCwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwiZGVsYXlfbnVtYmVycyI6NC4wLCJkZXN5bmMiOjEuMCwiZGVzeW5jX2RlbGF5Ijo0LjAsImRlc3luY19mcmVlc3RhbmRpbmciOjEuMCwiZGVzeW5jX2Zyb20iOjI4LjAsImRlc3luY19pbnZlcnRlciI6ZmFsc2UsImRlc3luY19sZWZ0Ijo2MC4wLCJkZXN5bmNfbGltaXRfbW9kZSI6MS4wLCJkZXN5bmNfbWF4Ijo1OC4wLCJkZXN5bmNfbWluIjoyOC4wLCJkZXN5bmNfbW9kZSI6MS4wLCJkZXN5bmNfbXVsdGlwbGllciI6NC4wLCJkZXN5bmNfcmFuZ2VfZnJvbSI6NTguMCwiZGVzeW5jX3JpZ2h0Ijo2MC4wLCJkZXN5bmNfc3BlZWRfdG8iOjUuMCwiZGVzeW5jX3RvIjo1OC4wLCJkZXN5bmNfdHdlYWtzIjpbIkppdHRlciIsIn4iXSwibW9kaWZpZXIiOjEuMCwibW9kaWZpZXJfMSI6MC4wLCJtb2RpZmllcl8yIjowLjAsIm1vZGlmaWVyXzMiOjAuMCwibW9kaWZpZXJfNCI6MC4wLCJtb2RpZmllcl81IjowLjAsIm1vZGlmaWVyXzYiOjAuMCwibW9kaWZpZXJfaml0dGVyX29mZnNldCI6MC4wLCJtb2RpZmllcl9tYXhpbXVtX29mZnNldCI6MTEuMCwibW9kaWZpZXJfbWV0aG9kIjoxLjAsIm1vZGlmaWVyX21pbmltdW1fb2Zmc2V0IjotMTEuMCwibW9kaWZpZXJfbnVtYmVycyI6NC4wLCJtb2RpZmllcl9yYW5kb21faml0dGVyIjp0cnVlLCJuZXZlcmxvc2VfbW9kZSI6MC4wLCJyYW5kb21fY2hva2UiOnRydWUsInNuYXAiOmZhbHNlLCJzbmFwX2Rpc2FibGVycyI6WyJ+Il0sInNuYXBfZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsInNuYXBfZGlzdG9ydGlvbl9zcGVlZCI6NS4wLCJzbmFwX2xlZnRfb2Zmc2V0IjowLjAsInNuYXBfb2Zmc2V0IjowLjAsInNuYXBfb25seV93aGVuX2hpdHRhYmxlIjpmYWxzZSwic25hcF9waXRjaCI6IkRvd24iLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTg5LjAsInNuYXBfcmFuZG9tMiI6ODkuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiU2lkZXdheXMiLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tzX3RvIjoxNi4wLCJ5YXciOjEuMCwieWF3X2RlbGF5X2Jvb2wiOjAuMCwieWF3X2RlbGF5X21heCI6MTAuMCwieWF3X2RlbGF5X21ldGhvZCI6MS4wLCJ5YXdfZGVsYXlfbWluIjoxLjAsInlhd19kZWxheV9tdWx0aXBsaWVyIjoyLjAsInlhd19sZWZ0X29mZnNldCI6MC4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0Ijo2LjAsInlhd19yaWdodF9vZmZzZXQiOjAuMH0sIlx1MDAwN3tMaW5rIEFjdGl2ZX3ulYcgIFx1MDAwN0RFRkFVTFRBaXIgQ3JvdWNoaW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6NS4wLCJjaG9rZV9zbGlkZXIyIjoxNS4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjE0LjAsImRlc3luY19mcmVlc3RhbmRpbmciOjEuMCwiZGVzeW5jX2Zyb20iOjI4LjAsImRlc3luY19pbnZlcnRlciI6ZmFsc2UsImRlc3luY19sZWZ0Ijo2MC4wLCJkZXN5bmNfbGltaXRfbW9kZSI6MS4wLCJkZXN5bmNfbWF4Ijo1OC4wLCJkZXN5bmNfbWluIjoyOC4wLCJkZXN5bmNfbW9kZSI6MS4wLCJkZXN5bmNfbXVsdGlwbGllciI6MTQuMCwiZGVzeW5jX3JhbmdlX2Zyb20iOjU4LjAsImRlc3luY19yaWdodCI6NjAuMCwiZGVzeW5jX3NwZWVkX3RvIjo1LjAsImRlc3luY190byI6NTguMCwiZGVzeW5jX3R3ZWFrcyI6WyJKaXR0ZXIiLCJ+Il0sIm1vZGlmaWVyIjoxLjAsIm1vZGlmaWVyXzEiOjAuMCwibW9kaWZpZXJfMiI6MC4wLCJtb2RpZmllcl8zIjowLjAsIm1vZGlmaWVyXzQiOjAuMCwibW9kaWZpZXJfNSI6MC4wLCJtb2RpZmllcl82IjowLjAsIm1vZGlmaWVyX2ppdHRlcl9vZmZzZXQiOjAuMCwibW9kaWZpZXJfbWF4aW11bV9vZmZzZXQiOjIyLjAsIm1vZGlmaWVyX21ldGhvZCI6MS4wLCJtb2RpZmllcl9taW5pbXVtX29mZnNldCI6LTIyLjAsIm1vZGlmaWVyX251bWJlcnMiOjQuMCwibW9kaWZpZXJfcmFuZG9tX2ppdHRlciI6dHJ1ZSwibmV2ZXJsb3NlX21vZGUiOjAuMCwicmFuZG9tX2Nob2tlIjp0cnVlLCJzbmFwIjpmYWxzZSwic25hcF9kaXNhYmxlcnMiOlsifiJdLCJzbmFwX2Rpc3RvcnRpb25fcmFuZ2UiOjE4MC4wLCJzbmFwX2Rpc3RvcnRpb25fc3BlZWQiOjUuMCwic25hcF9sZWZ0X29mZnNldCI6MC4wLCJzbmFwX29mZnNldCI6MC4wLCJzbmFwX29ubHlfd2hlbl9oaXR0YWJsZSI6ZmFsc2UsInNuYXBfcGl0Y2giOiJEb3duIiwic25hcF9waXRjaF9mcm9tIjotODkuMCwic25hcF9waXRjaF9vZmZzZXQiOjAuMCwic25hcF9waXRjaF90byI6ODkuMCwic25hcF9yYW5kb20iOi04OS4wLCJzbmFwX3JhbmRvbTIiOjg5LjAsInNuYXBfcmlnaHRfb2Zmc2V0IjowLjAsInNuYXBfc3Bpbl9yYW5nZSI6MTgwLjAsInNuYXBfc3Bpbl9zcGVlZCI6NS4wLCJzbmFwX3lhdyI6IlNpZGV3YXlzIiwic25hcF95YXdfcmFuZG9tIjotMTgwLjAsInNuYXBfeWF3X3JhbmRvbTIiOjE4MC4wLCJ0aWNrYmFzZV8xIjoxNi4wLCJ0aWNrYmFzZV8yIjoxNi4wLCJ0aWNrYmFzZV8zIjoxNi4wLCJ0aWNrYmFzZV80IjoxNi4wLCJ0aWNrYmFzZV81IjoxNi4wLCJ0aWNrYmFzZV82IjoxNi4wLCJ0aWNrc190byI6MTYuMCwieWF3IjoxLjAsInlhd19kZWxheV9ib29sIjowLjAsInlhd19kZWxheV9tYXgiOjEwLjAsInlhd19kZWxheV9tZXRob2QiOjEuMCwieWF3X2RlbGF5X21pbiI6MS4wLCJ5YXdfZGVsYXlfbXVsdGlwbGllciI6Mi4wLCJ5YXdfbGVmdF9vZmZzZXQiOi0xOC4wLCJ5YXdfbW9kZSI6Mi4wLCJ5YXdfb2Zmc2V0IjowLjAsInlhd19yaWdodF9vZmZzZXQiOjQ0LjB9LCJcdTAwMDd7TGluayBBY3RpdmV974aDICAgICBcdTAwMDdERUZBVUxUU3RhbmRpbmciOnsiY2hva2VfbWV0aG9kIjoxLjAsImNob2tlX251bWJlcnMiOjYuMCwiY2hva2Vfc2xpZGVyIjoxNi4wLCJjaG9rZV9zbGlkZXIyIjoxNi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjQuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjYwLjAsImRlc3luY19saW1pdF9tb2RlIjoxLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjo0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6MS4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0Ijo1LjAsIm1vZGlmaWVyX21ldGhvZCI6MS4wLCJtb2RpZmllcl9taW5pbXVtX29mZnNldCI6LTUuMCwibW9kaWZpZXJfbnVtYmVycyI6NC4wLCJtb2RpZmllcl9yYW5kb21faml0dGVyIjp0cnVlLCJuZXZlcmxvc2VfbW9kZSI6MC4wLCJyYW5kb21fY2hva2UiOmZhbHNlLCJzbmFwIjpmYWxzZSwic25hcF9kaXNhYmxlcnMiOlsifiJdLCJzbmFwX2Rpc3RvcnRpb25fcmFuZ2UiOjE4MC4wLCJzbmFwX2Rpc3RvcnRpb25fc3BlZWQiOjUuMCwic25hcF9sZWZ0X29mZnNldCI6MC4wLCJzbmFwX29mZnNldCI6MC4wLCJzbmFwX29ubHlfd2hlbl9oaXR0YWJsZSI6ZmFsc2UsInNuYXBfcGl0Y2giOiJGbGljayIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJSYW5kb20iLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tzX3RvIjo3LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MC4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjoxLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjIuMCwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjYuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wfSwiXHUwMDA3e0xpbmsgQWN0aXZlfe+GkyAgIFx1MDAwN0RFRkFVTFRDcm91Y2hpbmciOnsiY2hva2VfbWV0aG9kIjoxLjAsImNob2tlX251bWJlcnMiOjYuMCwiY2hva2Vfc2xpZGVyIjo1LjAsImNob2tlX3NsaWRlcjIiOjE2LjAsImRlbGF5XzEiOjIuMCwiZGVsYXlfMiI6Mi4wLCJkZWxheV8zIjoyLjAsImRlbGF5XzQiOjIuMCwiZGVsYXlfNSI6Mi4wLCJkZWxheV82IjoyLjAsImRlbGF5X251bWJlcnMiOjQuMCwiZGVzeW5jIjoxLjAsImRlc3luY19kZWxheSI6My4wLCJkZXN5bmNfZnJlZXN0YW5kaW5nIjoxLjAsImRlc3luY19mcm9tIjoyOC4wLCJkZXN5bmNfaW52ZXJ0ZXIiOmZhbHNlLCJkZXN5bmNfbGVmdCI6NjAuMCwiZGVzeW5jX2xpbWl0X21vZGUiOjEuMCwiZGVzeW5jX21heCI6NTguMCwiZGVzeW5jX21pbiI6MjguMCwiZGVzeW5jX21vZGUiOjEuMCwiZGVzeW5jX211bHRpcGxpZXIiOjE2LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6MS4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjoyMi4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi0yMi4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjowLjAsInJhbmRvbV9jaG9rZSI6ZmFsc2UsInNuYXAiOmZhbHNlLCJzbmFwX2Rpc2FibGVycyI6WyJ+Il0sInNuYXBfZGlzdG9ydGlvbl9yYW5nZSI6MTgwLjAsInNuYXBfZGlzdG9ydGlvbl9zcGVlZCI6NS4wLCJzbmFwX2xlZnRfb2Zmc2V0IjowLjAsInNuYXBfb2Zmc2V0IjowLjAsInNuYXBfb25seV93aGVuX2hpdHRhYmxlIjpmYWxzZSwic25hcF9waXRjaCI6IkRvd24iLCJzbmFwX3BpdGNoX2Zyb20iOi04OS4wLCJzbmFwX3BpdGNoX29mZnNldCI6MC4wLCJzbmFwX3BpdGNoX3RvIjo4OS4wLCJzbmFwX3JhbmRvbSI6LTg5LjAsInNuYXBfcmFuZG9tMiI6ODkuMCwic25hcF9yaWdodF9vZmZzZXQiOjAuMCwic25hcF9zcGluX3JhbmdlIjoxODAuMCwic25hcF9zcGluX3NwZWVkIjo1LjAsInNuYXBfeWF3IjoiU2lkZXdheXMiLCJzbmFwX3lhd19yYW5kb20iOi0xODAuMCwic25hcF95YXdfcmFuZG9tMiI6MTgwLjAsInRpY2tiYXNlXzEiOjE2LjAsInRpY2tiYXNlXzIiOjE2LjAsInRpY2tiYXNlXzMiOjE2LjAsInRpY2tiYXNlXzQiOjE2LjAsInRpY2tiYXNlXzUiOjE2LjAsInRpY2tiYXNlXzYiOjE2LjAsInRpY2tzX3RvIjoxNi4wLCJ5YXciOjEuMCwieWF3X2RlbGF5X2Jvb2wiOjAuMCwieWF3X2RlbGF5X21heCI6MTAuMCwieWF3X2RlbGF5X21ldGhvZCI6MS4wLCJ5YXdfZGVsYXlfbWluIjoxLjAsInlhd19kZWxheV9tdWx0aXBsaWVyIjoyLjAsInlhd19sZWZ0X29mZnNldCI6LTMyLjAsInlhd19tb2RlIjoxLjAsInlhd19vZmZzZXQiOjYuMCwieWF3X3JpZ2h0X29mZnNldCI6NDYuMH0sIlx1MDAwN3tMaW5rIEFjdGl2ZX3vlZQgICAgIFx1MDAwN0RFRkFVTFRTbG93aW5nIjp7ImNob2tlX21ldGhvZCI6MS4wLCJjaG9rZV9udW1iZXJzIjo2LjAsImNob2tlX3NsaWRlciI6NC4wLCJjaG9rZV9zbGlkZXIyIjoxNi4wLCJkZWxheV8xIjoyLjAsImRlbGF5XzIiOjIuMCwiZGVsYXlfMyI6Mi4wLCJkZWxheV80IjoyLjAsImRlbGF5XzUiOjIuMCwiZGVsYXlfNiI6Mi4wLCJkZWxheV9udW1iZXJzIjo0LjAsImRlc3luYyI6MS4wLCJkZXN5bmNfZGVsYXkiOjQuMCwiZGVzeW5jX2ZyZWVzdGFuZGluZyI6MS4wLCJkZXN5bmNfZnJvbSI6MjguMCwiZGVzeW5jX2ludmVydGVyIjpmYWxzZSwiZGVzeW5jX2xlZnQiOjYwLjAsImRlc3luY19saW1pdF9tb2RlIjoyLjAsImRlc3luY19tYXgiOjU4LjAsImRlc3luY19taW4iOjI4LjAsImRlc3luY19tb2RlIjoxLjAsImRlc3luY19tdWx0aXBsaWVyIjo0LjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6MS4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjoxMC4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi0xMC4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjowLjAsInJhbmRvbV9jaG9rZSI6dHJ1ZSwic25hcCI6ZmFsc2UsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOmZhbHNlLCJzbmFwX3BpdGNoIjoiRG93biIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJTaWRld2F5cyIsInNuYXBfeWF3X3JhbmRvbSI6LTE4MC4wLCJzbmFwX3lhd19yYW5kb20yIjoxODAuMCwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjE2LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MC4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjoxLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjIuMCwieWF3X2xlZnRfb2Zmc2V0IjotMjcuMCwieWF3X21vZGUiOjIuMCwieWF3X29mZnNldCI6MC4wLCJ5YXdfcmlnaHRfb2Zmc2V0Ijo0NC4wfSwiXHUwMDA3e0xpbmsgQWN0aXZlfe+cjCAgICBcdTAwMDdERUZBVUxUUnVubmluZyI6eyJjaG9rZV9tZXRob2QiOjEuMCwiY2hva2VfbnVtYmVycyI6Ni4wLCJjaG9rZV9zbGlkZXIiOjcuMCwiY2hva2Vfc2xpZGVyMiI6MjIuMCwiZGVsYXlfMSI6Mi4wLCJkZWxheV8yIjoyLjAsImRlbGF5XzMiOjIuMCwiZGVsYXlfNCI6Mi4wLCJkZWxheV81IjoyLjAsImRlbGF5XzYiOjIuMCwiZGVsYXlfbnVtYmVycyI6NC4wLCJkZXN5bmMiOjEuMCwiZGVzeW5jX2RlbGF5IjoxMy4wLCJkZXN5bmNfZnJlZXN0YW5kaW5nIjoxLjAsImRlc3luY19mcm9tIjoyOC4wLCJkZXN5bmNfaW52ZXJ0ZXIiOmZhbHNlLCJkZXN5bmNfbGVmdCI6NjAuMCwiZGVzeW5jX2xpbWl0X21vZGUiOjEuMCwiZGVzeW5jX21heCI6NTguMCwiZGVzeW5jX21pbiI6NjAuMCwiZGVzeW5jX21vZGUiOjEuMCwiZGVzeW5jX211bHRpcGxpZXIiOjEzLjAsImRlc3luY19yYW5nZV9mcm9tIjo1OC4wLCJkZXN5bmNfcmlnaHQiOjYwLjAsImRlc3luY19zcGVlZF90byI6NS4wLCJkZXN5bmNfdG8iOjU4LjAsImRlc3luY190d2Vha3MiOlsiSml0dGVyIiwifiJdLCJtb2RpZmllciI6MS4wLCJtb2RpZmllcl8xIjowLjAsIm1vZGlmaWVyXzIiOjAuMCwibW9kaWZpZXJfMyI6MC4wLCJtb2RpZmllcl80IjowLjAsIm1vZGlmaWVyXzUiOjAuMCwibW9kaWZpZXJfNiI6MC4wLCJtb2RpZmllcl9qaXR0ZXJfb2Zmc2V0IjowLjAsIm1vZGlmaWVyX21heGltdW1fb2Zmc2V0IjoxMC4wLCJtb2RpZmllcl9tZXRob2QiOjEuMCwibW9kaWZpZXJfbWluaW11bV9vZmZzZXQiOi0xMC4wLCJtb2RpZmllcl9udW1iZXJzIjo0LjAsIm1vZGlmaWVyX3JhbmRvbV9qaXR0ZXIiOnRydWUsIm5ldmVybG9zZV9tb2RlIjowLjAsInJhbmRvbV9jaG9rZSI6dHJ1ZSwic25hcCI6ZmFsc2UsInNuYXBfZGlzYWJsZXJzIjpbIn4iXSwic25hcF9kaXN0b3J0aW9uX3JhbmdlIjoxODAuMCwic25hcF9kaXN0b3J0aW9uX3NwZWVkIjo1LjAsInNuYXBfbGVmdF9vZmZzZXQiOjAuMCwic25hcF9vZmZzZXQiOjAuMCwic25hcF9vbmx5X3doZW5faGl0dGFibGUiOmZhbHNlLCJzbmFwX3BpdGNoIjoiRG93biIsInNuYXBfcGl0Y2hfZnJvbSI6LTg5LjAsInNuYXBfcGl0Y2hfb2Zmc2V0IjowLjAsInNuYXBfcGl0Y2hfdG8iOjg5LjAsInNuYXBfcmFuZG9tIjotODkuMCwic25hcF9yYW5kb20yIjo4OS4wLCJzbmFwX3JpZ2h0X29mZnNldCI6MC4wLCJzbmFwX3NwaW5fcmFuZ2UiOjE4MC4wLCJzbmFwX3NwaW5fc3BlZWQiOjUuMCwic25hcF95YXciOiJTaWRld2F5cyIsInNuYXBfeWF3X3JhbmRvbSI6LTE4MC4wLCJzbmFwX3lhd19yYW5kb20yIjoxODAuMCwidGlja2Jhc2VfMSI6MTYuMCwidGlja2Jhc2VfMiI6MTYuMCwidGlja2Jhc2VfMyI6MTYuMCwidGlja2Jhc2VfNCI6MTYuMCwidGlja2Jhc2VfNSI6MTYuMCwidGlja2Jhc2VfNiI6MTYuMCwidGlja3NfdG8iOjE2LjAsInlhdyI6MS4wLCJ5YXdfZGVsYXlfYm9vbCI6MC4wLCJ5YXdfZGVsYXlfbWF4IjoxMC4wLCJ5YXdfZGVsYXlfbWV0aG9kIjoxLjAsInlhd19kZWxheV9taW4iOjEuMCwieWF3X2RlbGF5X211bHRpcGxpZXIiOjIuMCwieWF3X2xlZnRfb2Zmc2V0IjowLjAsInlhd19tb2RlIjoyLjAsInlhd19vZmZzZXQiOjYuMCwieWF3X3JpZ2h0X29mZnNldCI6MC4wfSwiYWlybGFnIjpmYWxzZSwiYXZvaWRfYmFja3N0YWIiOnRydWUsImJsb2NrX2ppdHRlciI6dHJ1ZSwiY2lyY3Vtc3RhbmNlcyI6Ny4wLCJkaXNhYmxlcl9sZWZ0X29mZnNldCI6LTMwLjAsImRpc2FibGVyX3BpdGNoIjoiRGlzYWJsZWQiLCJkaXNhYmxlcl9yYW5nZSI6MTgwLjAsImRpc2FibGVyX3JpZ2h0X29mZnNldCI6MzAuMCwiZGlzYWJsZXJfc3BlZWQiOjIuMCwiZGlzYWJsZXJfeWF3IjoiU3BpbiIsImZsdWN0dWF0ZSI6Mi4wLCJmb3JjZV9icmVha19sYWdjb21wIjpbIlx1MDAwN3tMaW5rIEFjdGl2ZX3vlZQgICAgIFx1MDAwN0RFRkFVTFRTbG93aW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe+GkyAgIFx1MDAwN0RFRkFVTFRDcm91Y2hpbmciLCJcdTAwMDd7TGluayBBY3RpdmV97ouOICAgIFx1MDAwN0RFRkFVTFRTbmVha2luZyIsIlx1MDAwN3tMaW5rIEFjdGl2ZX3ulYcgIFx1MDAwN0RFRkFVTFRBaXIgQ3JvdWNoaW5nIiwiXHUwMDA3e0xpbmsgQWN0aXZlfe6TgSAgIFx1MDAwN0RFRkFVTFRGcmVlc3RhbmRpbmciLCJ+Il0sImZyZWVzdGFuZF9kaXNhYmxlcnMiOlsifiJdLCJmcmVlc3RhbmRfbW9kaWZpZXJzIjozLjAsImZyZWVzdGFuZGluZyI6ZmFsc2UsImZyZWVzdGFuZGluZ19ib29sIjoxLjAsImhzX21vZGUiOiJGYXZvciBGaXJlIFJhdGUiLCJtYW51YWxfeWF3IjoiRGlzYWJsZWQiLCJzYWZlX2hlYWRfaGVpZ2h0IjowLjAsInR3ZWFrcyI6MC4wfSwiaG9tZSI6eyJhYm91dF9saXN0IjoxLjAsImxvYWRfbGluZSI6MzIuMCwicHJlc2V0X2lucHV0IjoiQWdncmVzc2l2ZSAgXHUwMDA3e0xpbmsgQWN0aXZlfe+BtSIsInByZXNldF9saXN0Ijo3LjAsIndhdGVybWFya19hY2NlbnQiOiIjRkZGRkZGRkYiLCJ3YXRlcm1hcmtfZm9udCI6MS4wLCJ3YXRlcm1hcmtfZ3JhZGllbnQiOjAuMCwid2F0ZXJtYXJrX2dyYWRpZW50X2h1ZSI6MC4wLCJ3YXRlcm1hcmtfZ3JhZGllbnRfcmFpbmJvdyI6MS4wLCJ3YXRlcm1hcmtfZ3JhZGllbnRfc2F0dXJhdGlvbiI6NS4wLCJ3YXRlcm1hcmtfZ3JhZGllbnRfc3BlZWQiOjIuMCwid2F0ZXJtYXJrX2lucHV0Ijoi4oKK4oCiLsKwLuKLhkxVQVNFTlNF4ouGLsKwLuKAouKCiiIsIndhdGVybWFya19wb3NpdGlvbiI6MS4wLCJ3YXRlcm1hcmtfeCI6MTI4MC4wLCJ3YXRlcm1hcmtfeSI6MTQzMC4wfSwib3RoZXIiOnsiKmhpZ2hsaWdodCI6IiNGRkZGRkZGRiIsImFkZG9ucyI6WyJcdTAwMDd7TGluayBBY3RpdmV975WLICBcdTAwMDdERUZBVUxURGlzYWJsZSBGb290IFNoYWRvd3MiLCJcdTAwMDd7TGluayBBY3RpdmV974uxICAgXHUwMDA3REVGQVVMVExlZ2FjeSBEZXN5bmMiLCJ+Il0sImFzcGVjdF9yYXRpbyI6dHJ1ZSwiYXNwZWN0X3JhdGlvX2hlaWdodCI6MTQ0MC4wLCJhc3BlY3RfcmF0aW9fbGlzdCI6IjQ6MyAoMTAyNHg3NjgpIiwiYXNwZWN0X3JhdGlvX21ldGhvZCI6MS4wLCJhc3BlY3RfcmF0aW9fc2xpZGVyIjoxMzMuMCwiYXNwZWN0X3JhdGlvX3dpZHRoIjoyNTYwLjAsImN1c3RvbV9zY29wZV9vdmVybGF5Ijp0cnVlLCJkYW1hZ2VfaW5kaWNhdG9yIjp0cnVlLCJkZWJ1Z190ZXh0IjpmYWxzZSwiZmFzdF9sYWRkZXIiOmZhbHNlLCJmb3YiOjYzLjAsImZyZWV6ZXRpbWVmZCI6dHJ1ZSwiaGlnaGxpZ2h0IjpmYWxzZSwiaGlnaGxpZ2h0X2NvbG9yIjoiI0ZGRkZGRkZGIiwiaGl0bWFya2VycyI6WyJTa2VldCIsIktpYml0IiwifiJdLCJrZWVwdHJhbnNwYXJlbmN5Ijp0cnVlLCJraWJpdF9jb2xvcngiOiIjRkZGRkZGRkYiLCJraWJpdF9jb2xvcnkiOiIjRkZGRkZGRkYiLCJsb2dfYWltYm90Ijp0cnVlLCJsb2dfY29sb3IiOiIjRkZGRkZGRkYiLCJsb2dfcHVyY2hhc2VzIjp0cnVlLCJtYW51YWxfYXJyb3dzIjpmYWxzZSwibWFudWFsX2Fycm93c19jbHIiOiIjQkRCREJERkYiLCJtYW51YWxfYXJyb3dzX2ZvbnQiOjEuMCwibWFudWFsX2Fycm93c19mb3J3YXJkIjoiXiIsIm1hbnVhbF9hcnJvd3NfbGVmdCI6IjwiLCJtYW51YWxfYXJyb3dzX3JpZ2h0IjoiPiIsIm5vX2ZhbGxfZGFtYWdlIjpmYWxzZSwicGxheWVyX2FuaW1hdGlvbnMiOlsifiJdLCJwbGF5ZXJfYW5pbWF0aW9uc19mYWxsaW5nIjowLjAsInBsYXllcl9hbmltYXRpb25zX2ludGVycG9sYXRpbmciOjAuMCwicGxheWVyX2FuaW1hdGlvbnNfbGVhbmluZyI6NTAuMCwicGxheWVyX2FuaW1hdGlvbnNfd2Fsa2luZyI6MC4wLCJzY29wZV9jb2xvciI6IiM4Njg2ODZGRiIsInNjb3BlX2V4dHJhIjpbIn4iXSwic2NvcGVfZ2FwIjoxMC4wLCJzY29wZV9zaXplIjoyMDYuMCwidGVhbW1hdGVfYWltYm90IjpmYWxzZSwidW5sb2NrX2Zha2VfbGF0ZW5jeSI6dHJ1ZSwidmlld21vZGVsIjp0cnVlLCJ4IjotOS4wLCJ5IjoxMi4wLCJ6IjoxMi4wfX0=";
        end;
        v11.home.preset_input:set("");
        v593:update();
        v11.home.save:set_callback(function()
            -- upvalues: v593 (ref)
            v593:save();
        end);
        v11.home.load:set_callback(function()
            -- upvalues: v593 (ref)
            v593:load();
        end);
        v11.home.delete:set_callback(function()
            -- upvalues: v593 (ref)
            v593:delete();
        end);
        v11.home.export:set_callback(function()
            -- upvalues: v593 (ref)
            v593:export();
        end);
        v11.home.import:set_callback(function()
            -- upvalues: v593 (ref)
            v593:import();
        end);
        v11.home.create:set_callback(function()
            -- upvalues: v593 (ref)
            v593:create();
        end);
        v11.home.preset_list:set_callback(function(v594)
            -- upvalues: v593 (ref)
            v593:update();
            local v595 = v594:get();
            local _ = v594:list()[v595];
        end);
    end, 
    update = function(v597)
        -- upvalues: v11 (ref)
        local v598 = {};
        for _, v600 in ipairs(v597.system_presets) do
            v598[v600] = v600;
        end;
        for v601 in pairs(v597.database) do
            if not v598[v601] then
                v598[v601] = v601;
            end;
        end;
        local v602 = {};
        for v603 in pairs(v598) do
            table.insert(v602, v603);
        end;
        table.sort(v602);
        local v604 = {};
        for _, v606 in ipairs(v597.system_presets) do
            table.insert(v604, v606);
        end;
        table.insert(v604, v597.separator);
        for _, v608 in ipairs(v602) do
            if not v597:is_system_preset(v608) then
                table.insert(v604, v608);
            end;
        end;
        v11.home.preset_list:update(v604);
    end, 
    is_system_preset = function(v609, v610)
        for _, v612 in ipairs(v609.system_presets) do
            if v610 == v612 then
                return true;
            end;
        end;
        return false;
    end, 
    is_separator = function(v613, v614)
        return v614 == v613.separator;
    end, 
    save = function(v615)
        -- upvalues: v11 (ref), l_base64_0 (ref), l_pui_0 (ref)
        local v616 = v11.home.preset_list:get();
        local v617 = v11.home.preset_list:list()[v616];
        if v615:is_separator(v617) then
            common.add_notify("Failed", "Cannot save a separator.");
            return;
        elseif not v617 or v617 == "" then
            common.add_notify("Failed", "Invalid preset name.");
            return;
        else
            for _, v619 in ipairs(v615.system_presets) do
                if v617 == v619 then
                    common.add_notify("Failed", string.format("%s\aDEFAULT, you are not the creator of this config.", v617));
                    return;
                end;
            end;
            if not v615.database[v617] then
                common.add_notify("Failed", "Preset does not exist.");
                return;
            else
                local v620 = l_base64_0.encode(json.stringify(l_pui_0.save()));
                v615.database[v617] = v620;
                common.add_notify("Success", "Preset saved successfully.");
                v615:update();
                return;
            end;
        end;
    end, 
    load = function(v621)
        -- upvalues: v11 (ref), l_base64_0 (ref), l_pui_0 (ref)
        local v622 = v11.home.preset_list:get();
        local v623 = v11.home.preset_list:list()[v622];
        if v621:is_separator(v623) then
            common.add_notify("Failed", "Cannot load a separator.");
            return;
        elseif not v623 or not v621.database[v623] then
            common.add_notify("Failed", string.format("Failed to load: %s", v623 or "unknown"));
            return;
        else
            local v624 = json.parse(l_base64_0.decode(v621.database[v623]));
            l_pui_0.load(v624);
            v11.home.preset_input:set(v623);
            common.add_notify("Success", "Preset loaded successfully.");
            return;
        end;
    end, 
    delete = function(v625)
        -- upvalues: v11 (ref)
        local v626 = v11.home.preset_list:get();
        local v627 = v11.home.preset_list:list()[v626];
        if v625:is_separator(v627) then
            common.add_notify("Failed", "Cannot delete a separator.");
            return;
        elseif not v627 or v627 == "" then
            common.add_notify("Failed", "Invalid preset name.");
            return;
        else
            for _, v629 in ipairs(v625.system_presets) do
                if v627 == v629 then
                    common.add_notify("Failed", string.format("%s\aDEFAULT is a system preset.", v627));
                    return;
                end;
            end;
            if not v625.database[v627] then
                common.add_notify("Failed", "Preset does not exist.");
                return;
            else
                v625.database[v627] = nil;
                common.add_notify("Success", string.format("Preset %s\aDEFAULT has been deleted.", v627));
                v625:update();
                return;
            end;
        end;
    end, 
    export = function(v630)
        -- upvalues: v11 (ref), l_clipboard_0 (ref)
        local v631 = v11.home.preset_list:get();
        local v632 = v11.home.preset_list:list()[v631];
        if v630:is_separator(v632) then
            common.add_notify("Failed", "Cannot export a separator.");
            return;
        elseif not v632 or not v630.database[v632] then
            common.add_notify("Failed", "Preset does not exist.");
            return;
        else
            l_clipboard_0.set(v630.database[v632]);
            common.add_notify("Success", string.format("Preset '%s\aDEFAULT' has been exported to clipboard.", v632));
            return;
        end;
    end, 
    import = function(v633)
        -- upvalues: l_clipboard_0 (ref), v11 (ref)
        if l_clipboard_0.get() == nil then
            common.add_notify("Failed", "Clipboard is empty, copy the config again.");
            return;
        else
            local v634 = v11.home.preset_list:get();
            local v635 = v11.home.preset_list:list()[v634];
            if v633:is_separator(v635) then
                common.add_notify("Failed", "Cannot import to a separator.");
                return;
            else
                for _, v637 in ipairs(v633.system_presets) do
                    if v635 == v637 then
                        common.add_notify("Failed", "You are not the creator of this config.");
                        return;
                    end;
                end;
                v633.database[v635] = l_clipboard_0.get();
                common.add_notify("Success", "Preset imported successfully.");
                v633:update();
                return;
            end;
        end;
    end, 
    create = function(v638)
        -- upvalues: v11 (ref), l_base64_0 (ref), l_pui_0 (ref)
        local v639 = v11.home.preset_input:get();
        if v638:is_separator(preset_name) then
            common.add_notify("Failed", "Cannot delete a separator.");
            return;
        elseif v639 == "" then
            common.add_notify("Failed", "Invalid preset name.");
            return;
        else
            v638.database[v639] = l_base64_0.encode(json.stringify(l_pui_0.save()));
            common.add_notify("Success", string.format("Preset '%s\aDEFAULT' has been created.", v639));
            v638:update();
            return;
        end;
    end, 
    shutdown = function(v640)
        db.nyanza_classic1337 = v640.database;
    end
};
v641:init();
events.shutdown:set(function()
    -- upvalues: v641 (ref)
    v641:shutdown();
end);
l_pui_0.setup(v11);