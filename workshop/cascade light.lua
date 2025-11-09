-- declares
local bit_band, bit_rshift = bit.band, bit.rshift;

-- includes
local vector = require "vector";

local int32_to_rgb = function(int32)
    if not int32 then
        return
    end

    local limit = 0xff;

    local r = bit_band(bit_rshift(int32, 16), limit);
    local g = bit_band(bit_rshift(int32, 8), limit);
    local b = bit_band(int32, limit);

    return r, g, b;
end

local rgb_to_int32 = function(r, g, b)
    return r * (256 * 256) + g * 256 + b;
end

local cascade = {}; do
    -- @private
    local tab, container = "Visuals", "Effects";

    local function get_cascade_light()
        return entity.get_all("CCascadeLight")[1];
    end

    local function get_shadow_direction(ent)
        return entity.get_prop(ent, "m_envLightShadowDirection");
    end

    local function get_shadow_distance(ent)
        return entity.get_prop(ent, "m_flMaxShadowDist");
    end

    local function get_shadow_color(ent)
        return entity.get_prop(ent, "m_LightColor");
    end

    local function set_shadow_direction(ent, ...)
        entity.set_prop(ent, "m_envLightShadowDirection", ...);
    end

    local function set_shadow_distance(ent, ...)
        entity.set_prop(ent, "m_flMaxShadowDist", ...);
    end

    local function set_shadow_color(ent, ...)
        entity.set_prop(ent, "m_LightColor", ...);
    end

    local valid = false;

    local x, y, z, dist, color; do
        local ent = get_cascade_light();

        if ent ~= nil then
            x, y, z = get_shadow_direction(ent);
            dist = get_shadow_distance(ent);
            color = get_shadow_color(ent);

            valid = true;
        end
    end

    -- @public
    cascade.master = ui.new_checkbox(tab, container, "Light manipulation\n shadow");

    cascade.x = ui.new_slider(tab, container, "X\n shadow", -180, 180, x or 2, true, "°");
    cascade.y = ui.new_slider(tab, container, "Y\n shadow", -180, 180, y or 0, true, "°");
    cascade.z = ui.new_slider(tab, container, "Z\n shadow", -180, 180, z or 0, true, "°");
    cascade.dist = ui.new_slider(tab, container, "Distance\n shadow", 0, 1200, dist or 400, true, "ft", 1, {[0] = "Default"});

    cascade.colorize = ui.new_checkbox(tab, container, "Color modulation\n shadow");
    cascade.color = ui.new_color_picker(tab, container, "\n shadow", unpack(color and {int32_to_rgb(color)} or {164, 211, 251}));

    function cascade:is_active()
        return ui.get(self.master);
    end

    function cascade:is_coloring()
        return ui.get(self.colorize);
    end

    function cascade:get_direction()
        return ui.get(self.x), ui.get(self.y), ui.get(self.z);
    end

    function cascade:get_distance()
        return ui.get(self.dist);
    end

    function cascade:get_color()
        return ui.get(self.color);
    end

    function cascade:on_master_changed(item)
        local val = ui.get(item);

        if not val then
            cascade:on_shutdown();
        end

        ui.set_visible(self.x, val);
        ui.set_visible(self.y, val);
        ui.set_visible(self.z, val);
        ui.set_visible(self.dist, val);


        ui.set_visible(self.colorize, val);
        ui.set_visible(self.color, val);
    end

    function cascade:on_shutdown()
        local ent = get_cascade_light();

        if ent == nil then
            return;
        end

        set_shadow_direction(ent, x, y, z);
        set_shadow_distance(ent, dist);
        set_shadow_color(ent, color);

        valid = false;
    end

    function cascade:on_level_init()
        valid = false;
    end

    function cascade:update()
        if not self:is_active() then
            return;
        end

        local me = entity.get_local_player();
        local ent = get_cascade_light();

        if me == nil or ent == nil then
            return;
        end

        if not valid then
            x, y, z = get_shadow_direction(ent);
            dist = get_shadow_distance(ent);
            color = get_shadow_color(ent);

            valid = true;
        end

        set_shadow_direction(ent, self:get_direction());
        set_shadow_distance(ent, self:get_distance());
        set_shadow_color(ent, self:is_coloring() and rgb_to_int32(self:get_color()) or color);
    end
end

client.set_event_callback("shutdown", function()
    cascade:on_shutdown();
end);

client.set_event_callback("level_init", function()
    cascade:on_level_init();
end);

client.set_event_callback("net_update_start", function()
    cascade:update();
end);

ui.set_callback(cascade.master, function(item)
    cascade:on_master_changed(item);
end);

cascade:on_master_changed(cascade.master);