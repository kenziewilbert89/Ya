-- OVERDRIVE H - FULLY FIXED / SCOPE RESTRUCTURED
-- The original outer function had hundreds of locals.
-- Top-level state is stored in Context (C), while nested functions keep their own locals.

_G.OverdriveH = (function()
    -- Scope-reduction context: keeps the outer chunk far below Luau's local-register limit.
    local C = {}
    -- ============================================
    -- OVERDRIVE H UI - COMPLETE VERSION
    -- ============================================

    -- Setup environment
    C.u1 = game
    C.u2 = tostring
    C.u3 = tonumber
    C._min = math.min
    C._max = math.max
    C._rad = math.rad
    C._floor = math.floor
    C._random = math.random
    C._insert = table.insert
    C._remove = table.remove
    C._concat = table.concat
    C.u12 = unpack or table.unpack
    C.u13 = type
    C.u14 = typeof
    C.u15 = pcall
    C.u16 = setmetatable
    C.v17 = getmetatable
    C._wrap = coroutine.wrap
    C.v19 = print
    C.u20 = error
    C.v21 = (getgenv and getgenv()) or _G


    C.u22 = tick or os.clock or function() return 0 end
    C._date = os.date
    C._time = os.time
    C.u25 = pairs
    C._char = string.char
    C._sub = string.sub
    C._len = string.len
    C._format = string.format
    C._gsub = string.gsub
    C._find = string.find
    C._match = string.match
    C._lower = string.lower
    C._upper = string.upper
    C._byte = string.byte
    C._gmatch = string.gmatch
    C.u37 = {}

    C.u22()

    C.u38 = {}
    C.u39 = {}
    C.u40 = {}
    -- u41 is used as a shared state/method table (e.g. u41.d and u41.Coroutine).
    C.u41 = {}
    C.u42 = debug
    C.u43 = 'function'

    -- Compatibility layer for values that were outer locals in the decompiled source.
    C.u77 = {
        t = C.u13,
        f = (isfunction or function(v) return C.u13(v) == 'function' end),
        c = (iscclosure or is_c_closure or function(_) return false end),
        s = (isstring or function(v) return C.u13(v) == 'string' end),
        b = function(v) return C.u13(v) == 'boolean' end,
        ls = loadstring,
        sp = (string.split or function(value, sep)
            local out = {}
            if C.u13(value) ~= 'string' then return out end
            sep = sep or '\n'
            if sep == '' then return {value} end
            local pattern = '([^' .. sep:gsub('([%%%^%$%(%)%.%[%]%*%+%-%?])','%%%1') .. ']+)'
            for item in string.gmatch(value, pattern) do
                C._insert(out, item)
            end
            return out
        end),
    }

    C.u150 = {}
    C.u157 = function(signal, callback)
        if signal and signal.Connect then
            return signal:Connect(callback)
        end
    end
    C.u142 = writefile
    C.u143 = makefolder
    C.u144 = readfile
    C.u145 = isfile
    C.u164 = function(callback, ...)
        if C.u45(callback) then
            local args = {...}
            return C.u130(function()
                callback(C.u12(args))
            end)
        end
    end
    C.v148 = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or 'Unknown'

    -- HTTP/JSON fallbacks used by the original module-loading path.
    C._HttpService = C.u1:GetService('HttpService')
    C.u202 = request or http_request or (syn and syn.request) or (http and http.request) or (Xeno and Xeno.request)
    C.u40 = C.u40 or {}
    function C.u40.HttpRequest(_, url, method, headers, body)
        if C.u202 then
            local ok, response = C.u15(C.u202, {
                Url = url,
                Method = method or 'GET',
                Headers = headers,
                Body = body,
            })
            if ok and response then
                return response.Body or response.body or response
            end
        end
        if C._HttpGet and (method == nil or method == 'GET') then
            local ok, result = C.u15(C._HttpGet, C.u1, url)
            if ok then return result end
        end
        return nil
    end
    function C.u40.JSEncode(_, value)
        local ok, result = C.u15(C._HttpService.JSONEncode, C._HttpService, value)
        return ok and result or nil
    end
    function C.u40.JSDecode(_, value)
        if C.u13(value) ~= 'string' then return nil end
        local ok, result = C.u15(C._HttpService.JSONDecode, C._HttpService, value)
        return ok and result or nil
    end

    C.u45 = function(p44)
        return C.u13(p44) == C.u43
    end

    C.u46 = 'table'

    C.u48 = function(p47)
        return C.u13(p47) == C.u46
    end

    C.u49 = 'number'

    C.v51 = function(p50)
        return C.u13(p50) == C.u49
    end

    C.u52 = 'string'

    C.v54 = function(p53)
        return C.u13(p53) == C.u52
    end

    C.u55 = 'boolean'

    C.v57 = function(p56)
        return C.u13(p56) == C.u55
    end

    C.u58 = 'userdata'

    C.v60 = function(p59)
        return C.u14(p59) == C.u58
    end

    C.u61 = {
        '[^',
        ']+',
    }

    C.v70 = function(p62, p63)
        local v64 = C._insert
        local v65 = C.u61
        local v66, v67, v68 = C._gmatch(p62, v65[1] .. p63 .. v65[2])
        local v69 = {}

        while true do
            v68 = v66(v67, v68)

            if v68 == nil then
                break
            end

            v64(v69, v68)
        end

        return v69
    end

    if not C.v21 then
        return
    end

    C.v21.OVERDRIVE_H_IS_HERE = true

    C._RunService = C.u1:GetService('RunService')
    C._ReplicatedStorage = C.u1:GetService('ReplicatedStorage')
    C._TextChatService = C.u1:GetService('TextChatService')
    C._UserInputService = C.u1:GetService('UserInputService')
    C._MarketplaceService = C.u1:GetService('MarketplaceService')
    C._VirtualInputManager = C.u1:GetService('VirtualInputManager')
    C._GuiService = C.u1:GetService('GuiService')
    C._CoreGui = C.u1:GetService('CoreGui')
    C._VirtualUser = C.u1:GetService('VirtualUser')
    C._Lighting = C.u1:GetService('Lighting')
    C._Stats = C.u1:GetService('Stats')
    C._Players = C.u1:GetService('Players')
    C._Heartbeat = C._RunService.Heartbeat
    C._RenderStepped = C._RunService.RenderStepped
    C._Stepped = C._RunService.Stepped
    C.u94 = workspace
    C.v95 = Vector3
    C.v96 = CFrame
    C._new = C.v95.new
    C._zero = C.v95.zero
    C.u99 = C._new(math.huge, math.huge, math.huge)
    C._new2 = C.v96.new
    C._Angles = C.v96.Angles
    C._lookAt = C.v96.lookAt
    C._new3 = Vector2.new
    C._new4 = UDim2.new
    C._new5 = UDim.new
    C._new6 = TweenInfo.new
    C._fromRGB = Color3.fromRGB
    C._Platform = Enum.Platform
    C._Font = Enum.Font
    C._TextXAlignment = Enum.TextXAlignment
    C._TextYAlignment = Enum.TextYAlignment
    C._HumanoidStateType = Enum.HumanoidStateType
    C._ZIndexBehavior = Enum.ZIndexBehavior
    C._HighlightDepthMode = Enum.HighlightDepthMode
    C._RaycastFilterType = Enum.RaycastFilterType
    C.__discard1 = Enum.UserInputState
    C._KeyCode = Enum.KeyCode
    C._EasingStyle = Enum.EasingStyle
    C._EasingDirection = Enum.EasingDirection
    C._AutomaticSize = Enum.AutomaticSize
    C._PartType = Enum.PartType
    C._Material = Enum.Material
    C._SortOrder = Enum.SortOrder
    C._HorizontalAlignment = Enum.HorizontalAlignment
    C._new7 = RaycastParams.new
    C._new8 = PhysicalProperties.new
    C._CurrentCamera = C.u94.CurrentCamera
    C._WorldToViewportPoint = C._CurrentCamera.WorldToViewportPoint
    C._WorldToScreenPoint = C._CurrentCamera.WorldToScreenPoint
    C._DataPing = C._Stats.Network.ServerStatsItem['Data Ping']
    C.u130 = task and task.spawn or spawn
    C.u131 = task and task.wait or wait
    C._LocalPlayer = C._Players.LocalPlayer
    C._Name = C._LocalPlayer.Name
    C.u134, C.u135 = C._LocalPlayer:GetMouse()
    C._UserId = C._LocalPlayer.UserId
    C.u137 = nil
    C.u138 = nil
    C.u139 = nil

    repeat
        C.u131()
        local v140 = C.u22()
    until C.u1:IsLoaded()

    C.u141 = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set) or function(_) end

    if not getconnections then
        local _ = get_signal_cons
    end

    C.__discard2 = hookfunction
    C.__discard3 = isfolder
    C.u146 = delfolder or deletefolder

    C.u153 = function(p151, p152)
        if p151 then
            C.u150[p151] = p152
        end
    end

    C.u155 = function(p154)
        if p154 then
            return C.u150[p154]
        end
    end

    C.u158 = {
        'FeaturesDebugging',
        'Notify',
        'Callback Error: <font color="rgb(255, 0, 0)">',
        '</font>',
    }
    C._f = C.u77.f

    C.u165 = '%x'

    C.u167 = function(p166)
        return C._format(C.u165, C._byte(p166) * 2)
    end

    C.u168 = '.'

    function C.u40.HexEncode(_, p169)
        return C._gsub(p169, C.u168, C.u167)
    end

    C.u170 = 'Overdrive H: '

    function C.u40.Error(_, p171)
        return C.u20(C.u170 .. p171)
    end

    function C.u40.DestroyGui(_)
        local _ScreenGui = C.u155('ScreenGui')
        if _ScreenGui then
            C.u41.d = _ScreenGui
            C.u153('ScreenGui')
        end
    end

    C._DestroyGui = C.u40.DestroyGui
    C._Kick = C._LocalPlayer.Kick
    C._WaitForChild = C._LocalPlayer.WaitForChild

    C.u184 = {
        'Sound Effect',
        'Play',
    }

    function C.u40.PlayTouchSoundEffect()
        local v185 = C.u184
        local v186 = C.u155(v185[1])
        if v186 then
            v186[v185[2]](v186)
        end
    end

    C.u187 = 'Using Http Spy'
    C._HttpGet = C.u1.HttpGet

    C.u194 = 'string'
    C.u195 = C.u13
    C.u196 = C.u14

    C.u199 = ''
    C.u200 = C.v17

    C.u202 = C.u202 or ((not (request or http_request or (http and http.request) or (syn and syn.request))) and (not HttpPost and Xeno))
    if C.u202 and C.u202 == Xeno then
        C.u202 = Xeno.request
    elseif not C.u202 then
        C.u202 = function(_)
            return nil
        end
    end

    C.u203 = {
        'Url',
        'Method',
        'Headers',
        'Body',
    }
    C._t = C.u77.t

    C.u215 = 'Parent'
    C._new9 = Instance.new

    function C.u40.MakeInstance(_, p217, p218, p219, ...)
        if p217 and p218 then
            local v220 = C._new9(p217)
            local v221 = C.u25
            local v222, v223, v224 = v221(p218)

            while true do
                local v225
                v224, v225 = v222(v223, v224)
                if v224 == nil then break end
                v220[v224] = v225
            end

            if p219 then
                local v226 = C.u215
                local v227, v228, v229 = v221({p219, ...})

                while true do
                    local v230
                    v229, v230 = v227(v228, v229)
                    if v229 == nil then break end
                    v230[v226] = v220
                end
            end

            return v220
        end
    end

    function C.u40.AppendInstance(_, p231, p232)
        if p231 and p232 then
            local v233, v234, v235 = C.u25(p232)

            while true do
                local v236
                v235, v236 = v233(v234, v235)
                if v235 == nil then break end
                p231[v235] = v236
            end
            return p231
        end
    end

    function C.u40.AnimateRichText(_, p237, p238)
        if p237 and p238 then
            local u239 = {
                '<[^<>]->',
                '/',
                '([</>])',
                '',
                ' ',
                '</',
                '>',
                'Text',
            }

            function C.u41.Coroutine()
                local v240 = u239
                local v241 = C._len
                local v242 = p238
                local v243 = p237
                local v244 = C.u131
                local v245 = C._find
                local v246 = C._match
                local v247 = C._sub
                local v248 = C._gsub
                local v249 = C._remove
                local v250 = C._insert
                local v251 = v240[1]
                local v252 = v240[2]
                local v253 = v240[3]
                local v254 = v240[4]
                local v255 = v240[5]
                local v256 = v240[6]
                local v257 = v240[7]
                local v258 = v240[8]
                local v259 = v241(v242)
                local v260 = 1
                local v261 = {}
                local v262 = nil
                local v263 = nil

                while v260 <= v259 do
                    local v264, v265 = v245(v242, v251, v260)

                    if v264 or v265 then
                        if v264 == v262 or v265 == v263 then
                            v265 = v263
                            v264 = v262
                        else
                            v261[v264] = {
                                v246(v247(v242, v264, v265), v252) and true or false,
                                v248(v247(v242, v264, v265), v253, v254),
                            }
                        end
                    else
                        v260 = v259
                        v265 = v263
                        v264 = v262
                    end

                    v260 = v260 + 1
                    v263 = v265
                    v262 = v264
                end

                v244(0.05)

                local v266 = 1
                local v267 = {}

                while true do
                    if v266 > v259 then
                        v244()
                        v243[v258] = v242
                        return
                    end

                    local v268 = v261[v266]

                    if not v268 then
                        break
                    end

                    if v268[1] then
                        v249(v267, v268[3])
                        v266 = v266 + v241(v268[2]) + 1
                    else
                        local v269 = v266 + 1
                        local v270

                        while true do
                            local v271 = v261[v269]
                            if v271 then break end
                            v270 = v254
                            v269 = v269 + 1
                            v254 = v270
                        end

                        local v272 = v268[2]

                        if v272 then
                            local v273 = v241(v272)
                            v270 = v254
                            local v274 = 1

                            while v274 <= v273 do
                                local v275 = v247(v272, v274, v274)

                                if v275 == v255 then
                                    v274 = v273
                                else
                                    v254 = v254 .. v275
                                end

                                v274 = v274 + 1
                            end
                        else
                            v270 = v254
                            v254 = nil
                        end

                        if v271[2] ~= v254 or not v271[1] then
                        end

                        v250(v267, v254)
                        v271[3] = #v267
                        v266 = v266 + v241(v268[2]) + 1
                        v254 = v270
                    end

                    v266 = v266 + 1
                end

                if not v261[v266 + 1] then
                    local v276 = v247(v242, 1, v266)

                    for v277 = #v267, 1, -1 do
                        v276 = v276 .. v256 .. v267[v277] .. v257
                    end

                    v244(0.07)
                    v243[v258] = v276
                end
            end
        end
    end

    C.u278 = {
        '<br%s*/>',
        '\n',
        '<[^<>]->',
        '',
    }

    function C.u40.RemoveRichText(_, p279)
        local v280 = C.u278
        local v281 = C._gsub
        local v282 = v281(p279, v280[1], v280[2]) and v281(p279, v280[3], v280[4])
        if v282 then
            return v282
        end
    end

    C.u283 = {
        ' ',
        '\n',
        '\t',
    }

    function C.u40.RemoveIndent(_, p284)
        local v285 = C.u283
        local v286 = C._len
        local v287 = C._sub
        local v288 = v285[1]
        local v289 = v285[2]
        local v290 = v285[3]
        local v291 = v286(p284)
        local v292 = p284

        for v293 = 1, v291 do
            local v294 = v287(p284, v293, v293)

            if v294 ~= v288 and v294 ~= v289 and v294 ~= v290 then
                break
            end

            v292 = v287(p284, v293 + 1, v291)
        end

        local v295 = v292

        for v296 = v286(v292), 1, -1 do
            local v297 = v287(v292, v296, v296)

            if v297 ~= v288 and v297 ~= v289 and v297 ~= v290 then
                break
            end

            v295 = v287(v292, 1, v296 - 1)
        end

        return v295
    end

    C._month = C._date('*t', C._time()).month
    C.v299 = C._month == 11 and 'Halloween' or (C._month == 12 and 'Christmas' or (C._month == 2 and 'Valentine' or nil))

    C.u40.ThemeList = C.v299 and {
        C.v299,
        'Amethyst',
        'Amoled',
        'Crimson',
        'Dark',
        'NEO',
    } or {
        'Amethyst',
        'Amoled',
        'Crimson',
        'Dark',
        'NEO',
    }

    C._DestroyGui3 = C.u40.DestroyGui
    C._shutdown = C.u1.shutdown

    function C.u40.ForceShutdown(p302)
        local v303 = C.u15
        local v304 = C.u1
        local v305 = C._DestroyGui3
        local v306 = C._shutdown

        v305(p302)
        v303(v306, v304)
        C.u131(3)

        while true do
            v305(p302)
            v303(v306, v304)
        end
    end

    function C.u40.RandomString(_, p307)
        local v308 = C._random
        local v309 = C._char
        local v310 = {}

        for v311 = 1, p307 or v308(1, 10) do
            v310[v311] = v309(v308(32, 126))
        end

        return C._concat(v310)
    end

    -- UI COMPONENTS
    C.u312 = {
        Name = 'Notification',
        BackgroundTransparency = 1,
        BackgroundColor3 = C._fromRGB(20, 20, 20),
        Size = C._new4(0, 250, 0, 0),
        ClipsDescendants = true,
    }
    C.u313 = {
        Name = 'UICorner',
        CornerRadius = C._new5(0, 5),
    }
    C.u314 = {
        Name = 'UIStroke',
        Transparency = 0.55,
        ApplyStrokeMode = 'Border',
        Thickness = 2,
        Enabled = true,
    }
    C.u315 = {
        Name = 'Title',
        BackgroundTransparency = 1,
        Position = C._new4(0, 10, 0, 5),
        Size = C._new4(1, -20, 0, 25),
        RichText = true,
        Font = C._Font.Gotham,
        Text = '<font color="rgb(0, 0, 255)">Overdrive H</font> Says:',
        TextSize = 14,
        TextColor3 = C._fromRGB(255, 255, 255),
        TextXAlignment = C._TextXAlignment.Left,
    }
    C.u316 = {
        Name = 'Description',
        BackgroundTransparency = 1,
        Position = C._new4(0, 10, 0, 30),
        Size = C._new4(1, -20, 0, 0),
        RichText = true,
        Font = C._Font.Gotham,
        TextSize = 11,
        TextColor3 = C._fromRGB(255, 255, 255),
        TextWrapped = true,
        TextXAlignment = C._TextXAlignment.Left,
        TextYAlignment = C._TextYAlignment.Top,
    }
    C.u317 = C._new6(1, C._EasingStyle.Quint)
    C.u318 = {
        BackgroundTransparency = 1,
        Size = C._new4(0, 250, 0, 0),
    }

    function C.u40.Notify(p319, p320)
        local _ScreenGui2 = C.u155('ScreenGui')

        if _ScreenGui2 then
            local v322 = C._fromRGB
            local u323 = C._new4
            local v324 = C.u139
            local v325 = C.u312
            local v326 = C.u314
            local v327 = C.u316
            local u328 = C.u317
            local _MakeInstance = p319.MakeInstance
            local _PlayTween = p319.PlayTween

            v325.Parent = _ScreenGui2.NotificationContainer
            v326.Color = v324 and v324.getTheme.USC or v322(20, 20, 20)
            v327.Text = p319:TranslateMatchs(p320)

            local u331 = _MakeInstance(p319, 'Frame', v325, _MakeInstance(p319, 'UICorner', C.u313), _MakeInstance(p319, 'UIStroke', v326), _MakeInstance(p319, 'TextLabel', C.u315), _MakeInstance(p319, 'TextLabel', v327))
            local u332 = {
                'Description',
                'Size',
                'TextBounds',
                'Y',
            }
            local u338 = C.u157(u331.Description:GetPropertyChangedSignal('TextBounds'), function()
                local v333 = u332
                local v334 = u323
                local v335 = u331[v333[1] ]
                local v336 = v335[v333[3] ][v333[4] ]
                local v337 = v333[2]

                v335[v337] = v334(1, -20, 0, v336)

                _PlayTween(p319, u331, u328, {
                    [v337] = v334(0, 250, 0, 40 + v336),
                })
            end)

            _PlayTween(p319, u331, u328, {
                BackgroundTransparency = 0.5,
                Size = u323(0, 250, 0, 40 + u331.Description.TextBounds.Y),
            })

            local u339 = {
                'd',
                'Disconnect',
            }

            function C.u41.Coroutine()
                local v340 = u339
                local v341 = u331
                local v342 = C.u131

                v342(5)
                _PlayTween(p319, v341, u328, C.u318)
                v342(0.5)

                C.u41[v340[1] ] = v341

                if u338 then
                    u338[v340[2] ](u338)
                    u338 = nil
                end
            end
        end
    end

    function C.u40.CheckDirFile(_, p343, p344)
        if p343 and (p344 and not C.u145(p343)) then
            C.u142(p343, p344)
        end
    end

    C.u345 = '/signature.txt'
    C._CheckDirFile = C.u40.CheckDirFile
    C._RandomString = C.u40.RandomString

    function C.u40.CheckDirFolder(p348, p349)
        if p349 then
            C.u143(p349)
            C._CheckDirFile(p348, p349 .. C.u345, C._RandomString(p348, 60))
        end
    end

    function C.u40.RemoveDirFile(_, p350)
        if p350 and C.u145(p350) then
            C.u146(p350)
        end
    end

    C.u351 = {
        'Overdrive-H',
        'Overdrive-H/Users',
        'Overdrive-H/Users/',
        '/',
        'GameConfig',
        '-configs.json',
        'JSEncode',
    }
    C._CheckDirFolder = C.u40.CheckDirFolder

    function C.u40.SaveConfigurations(p353)
        local v354 = C.u351
        local v355 = C._CheckDirFolder
        local v356 = v354[3] .. C._Name

        v355(p353, v354[1])
        v355(p353, v354[2])
        v355(p353, v356)
        C.u142(v356 .. v354[4] .. p353[v354[5] ] .. v354[6], p353[v354[7] ](p353, C.u38))
    end

    C.u357 = {
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
    }
    C._CheckDirFolder2 = C.u40.CheckDirFolder

    function C.u40.Debug(p359, p360, p361)
        C._CheckDirFolder2(p359, 'Overdrive-H')

        local _t2 = C._date('*t', C._time())
        local _hour = _t2.hour
        local v364 = nil

        if _hour == 12 then
            v364 = true
        elseif _hour > 12 then
            _hour = _hour - 12
            v364 = true
        end

        C._insert(C.u37, {
            Type = p360,
            Text = '[' .. C.u357[_t2.month] .. ' ' .. _t2.day .. ', ' .. _t2.year .. ' at ' .. _hour .. ':' .. _t2.min .. ':' .. _t2.sec .. ' ' .. (v364 and 'PM' or 'AM') .. ']: ' .. p361,
        })
    end

    C.u372 = nil
    C.u373 = nil
    C.u374 = {
        '@everyone',
        'xlp1c2',
        '@',
        '<font color="rgb(0, 255, 0)">',
        '</font>',
    }

    C.u378 = function(p375)
        local v376 = C.u374
        local v377 = v376[1]

        if p375 == v377 and C.u372 ~= v376[2] then
            return p375
        end
        if p375 == v376[3] .. C._Name or p375 == v377 then
            C.u373 = true
        end

        return v376[4] .. p375 .. v376[5]
    end

    C.u379 = '@[%w_]+'

    function C.u40.CheckForMentions(_, p380, p381)
        C.u372 = p381
        C.u373 = false

        return C._gsub(p380, C.u379, C.u378), C.u373
    end

    function C.u40.ApplyTouchEffect(_, p382)
        local _MakeInstance2 = C.u40.MakeInstance
        local _PlayTween2 = C.u40.PlayTween
        local _Wait = C._Heartbeat.Wait
        local u386 = {
            Name = 'TouchEffect',
            Parent = p382,
            BackgroundTransparency = 0.9999,
            AnchorPoint = C._new3(0.5, 0.5),
            Size = C._new4(0, 0, 0, 0),
        }
        local u387 = {
            Name = 'UICorner',
            CornerRadius = C._new5(0, 15),
        }
        local u388 = {
            Name = 'UIStroke',
            Transparency = 0,
            Color = C._fromRGB(255, 255, 255),
            Thickness = 1.5,
            Enabled = true,
        }
        local u389 = C._new6(0.75, C._EasingStyle.Quad)
        local u390 = {Transparency = 1}
        local u391 = {}
        local u392 = {
            'Position',
            'X',
            'AbsolutePosition',
            'Y',
            'Frame',
            'UICorner',
            'Size',
            'UIStroke',
            'Offset',
            'Completed',
            'd',
        }

        C.u157(p382.MouseButton1Click, function()
            local v393 = C.u40
            local v394 = u392
            local v395 = C.u134
            local v396 = _MakeInstance2
            local v397 = _PlayTween2
            local v398 = C._new4
            local v399 = p382
            local v400 = u386
            local v401 = u389
            local v402 = u391
            local v403 = v394[2]
            local v404 = v394[4]
            local v405 = v394[7]
            local v406 = v394[9]
            local v407 = v399[v394[3] ]
            local v408 = v399[v405]
            local v409 = v395[v403]
            local v410 = v395[v404]

            v400[v394[1] ] = v398(0, v409 - v407[v403], 0, v410 - v407[v404])

            local v411 = v396(v393, v394[8], u388)
            local v412 = v396(v393, v394[5], v400, v396(v393, v394[6], u387), v411)

            v397(v393, v411, v401, u390)

            v402[v405] = v398(0, v408[v403][v406] + v409, 0, v408[v404][v406] + v410)

            _Wait(v397(v393, v412, v401, v402)[v394[10] ])

            C.u41[v394[11] ] = v412
        end)
    end

    C._Debug = C.u40.Debug
    C.u414 = {}

    C._Debug(C.u40, 'Neutral', 'Fetching Module Scripts...')

    function C.u40.RegisterModule(p415, p416, p417)
        local v418 = C._Debug
        local v419 = C.u414[p416]

        if v419 then
            local v420 = C.u77

            if p417 and v420.t(p417) then
                v418(p415, 'Neutral', "pairing '" .. p416 .. "' module script...")

                local _f2 = v420.f
                local _c = v420.c

                for v423 = 1, #p417 do
                    local v424 = p417[v423]

                    if v424 then
                        local v425 = v419[v424]

                        if not (v425 and _f2(v425)) or _c(v425) then
                            v418(p415, 'Failure', '[' .. p416 .. "]: '" .. v424 .. "' must be a function, got " .. C.u13(v425) .. '!')
                            return
                        end

                        p415[v424] = v425
                    end
                end

                v418(p415, 'Success', "'" .. p416 .. "' module has been loaded!")
            else
                v418(p415, 'Failure', "Couldn't load '" .. p416 .. "' module!")
            end
        else
            v418(p415, 'Failure', "'" .. p416 .. "' module is missing!")
        end
    end

    C._CheckDirFile2 = C.u40.CheckDirFile
    C._RemoveDirFile = C.u40.RemoveDirFile
    C._HttpRequest = C.u40.HttpRequest
    C._ls = C.u77.ls
    C._t4 = C.u77.t
    C.v431 = 'https://raw.githubusercontent.com/ItsJiDy/Overdrive-H/main/Modules/'
    C.v432 = C._HttpRequest(C.u40, C.v431 .. '/moduleList.txt')
    C.v433 = C.u77.sp(C.v432, '\n')

    C._Debug(C.u40, 'Success', 'Found ' .. #C.v433 .. ' Module Scripts!')

    C.v434 = C.u414

    for v435 = 1, #C.v433 do
        local v436 = C.v433[v435]

        if v436 then
            if v436 ~= '' then
                local v437 = C._HttpRequest(C.u40, C.v431 .. '/' .. v436 .. '.lua')

                if v437 then
                    local v438, v439 = C._ls(v437)

                    if v438 and not v439 then
                        C._CheckDirFile2(C.u40, 'Overdrive-H/Modules/' .. v436 .. '.lua', v437)

                        local v440 = v438()

                        if v440 and C._t4(v440) then
                            C.v434[v440.ClassName or 'Untitled Module'] = v440
                        else
                            C._Debug(C.u40, 'Failure', "Invalid module type, expected: 'table' got '" .. C.u13(v440) .. "'!")
                        end
                    else
                        local v441 = C._gsub(v436, v436, '^%l', C._upper)

                        C._RemoveDirFile(C.u40, 'Overdrive-H/Modules/' .. v436 .. '.lua')
                        C._Debug(C.u40, 'Failure', "An error occurred on module '" .. v441 .. "', expected error: " .. v439 .. '!')
                    end
                end
            end
        end
    end

    C._RegisterModule = C.u40.RegisterModule

    C._RegisterModule(C.u40, 'JSON', {
        'JSEncode',
        'JSDecode',
    })
    C._RegisterModule(C.u40, 'Tasker', {
        'IsExistingTask',
        'MakeTask',
        'RemoveTask',
    })
    C._RegisterModule(C.u40, 'PlayTween', {
        'PlayTween',
    })

    C._Debug(C.u40, 'Neutral', 'Fetching HWID...')

    C.u443 = C.u40:HexEncode(C.u2(C._UserId))

    C.u39[C.u443] = {
        Toggle = {},
        TextBox = {},
        Keybind = {},
        Dropdown = {},
        Slider = {},
    }

    C._Debug(C.u40, 'Success', "HWID Fetched Successfully '" .. C.u443 .. "'!")
    C._Debug(C.u40, 'Neutral', 'Fetching Game...')

    C._PlaceId = C.u1.PlaceId

    if C._PlaceId ~= 142823291 then
        if C._PlaceId ~= 70876832253163 then
            if C._PlaceId ~= 16732694052 then
                local _GetProductInfo = C._MarketplaceService.GetProductInfo
                local v446 = nil

                while true do
                    local v447, v448 = C.u15(_GetProductInfo, C._MarketplaceService, C._PlaceId)

                    if v447 and v448 then
                        v446 = v448.Name
                        break
                    end

                    C.u131()

                    if false then
                        break
                    end
                end

                if C._match(v446, 'Blade Ball') then
                    C.u40.Game = 'Blade Ball'
                    C.u40.GameConfig = 'bladeball'
                    C._Debug(C.u40, 'Success', "Game Fetched Successfully '" .. v446 .. "'")
                else
                    C._Debug(C.u40, 'Failure', "'" .. v446 .. "' is not supported :(")
                end

                C.u40.GameConfig = 'unsupported'
            else
                C.u40.Game = 'Fisch'
                C.u40.GameConfig = 'fisch'
                C._Debug(C.u40, 'Success', "Game Fetched Successfully '" .. C.u40.Game .. "'")
            end
        else
            C.u40.Game = 'Dead Rails'
            C.u40.GameConfig = 'deadrails'
            C._Debug(C.u40, 'Success', "Game Fetched Successfully '" .. C.u40.Game .. "'")
        end
    else
        C.u40.Game = 'Murder Mystery 2'
        C.u40.GameConfig = 'mm2'
        C._Debug(C.u40, 'Success', "Game Fetched Successfully '" .. C.u40.Game .. "'")
    end

    C._Debug(C.u40, 'Neutral', 'Welcome ' .. C._Name .. '!')

    C._CheckDirFolder3 = C.u40.CheckDirFolder
    C._CheckDirFile3 = C.u40.CheckDirFile
    C._Debug2 = C.u40.Debug
    C._t5 = C.u77.t

    C._CheckDirFolder3(C.u40, 'Overdrive-H')
    C._CheckDirFolder3(C.u40, 'Overdrive-H/Users')
    C._CheckDirFolder3(C.u40, 'Overdrive-H/Plugins')
    C._CheckDirFolder3(C.u40, 'Overdrive-H/Analysis')
    C._CheckDirFolder3(C.u40, 'Overdrive-H/Modules')
    C._CheckDirFolder3(C.u40, 'Overdrive-H/Language')
    C._CheckDirFolder3(C.u40, 'Overdrive-H/Users/' .. C._Name)
    C._CheckDirFile3(C.u40, 'Overdrive-H/important.txt', 'This script project is owned by @elfandtears_ndk!\n\nScript Id: 3114683f-c570-4046-bae1-3c56dd8a04b2')
    C._CheckDirFile3(C.u40, 'Overdrive-H/version-resolver.txt', 'path=.../Modules/{$MODULE_NAME}.lua\nversion=null')

    C.v453 = C.u40

    C._CheckDirFile3(C.u40, 'Overdrive-H/realtime-api.txt', 'url={$URL}\napi-key=' .. C.u40.RandomString(C.v453, 40) .. '\nprocessor=c++')
    C._CheckDirFile3(C.u40, 'Overdrive-H/Analysis/modulescript.txt', 'yes')
    C._CheckDirFile3(C.u40, 'Overdrive-H/Language/en-us.json', '[]')
    C._CheckDirFile3(C.u40, 'Overdrive-H/Language/preference.txt', 'en-us')
    C._CheckDirFile3(C.u40, 'Overdrive-H/Plugins/README.txt', 'this thing is fake fr')
    C._CheckDirFile3(C.u40, 'Overdrive-H/Plugins/start.lua', "loadmodules()\nloadconfigs()\nloadgui()\n\nif not lowPerformanceMode then\n\tsetawaitrendering(true)\nend\n\nif getProperty('isDeviceCanHandleUltraGraphics') then\n\tloadadaptivegraphics()\nend")
    C._CheckDirFile3(C.u40, 'Overdrive-H/Plugins/discord.lua', '--[=[\n\treturn {\n\t\t{\n\t\t\tName = "Join Discord",\n\t\t\tType = "Button",\n\t\t\tCallback = function()\n\t\t\t\tscript:LoadDiscordGui()\n\t\t\tend\n\t\t}\n\t}\n]=]\n\nreturn')
    C._CheckDirFile3(C.u40, 'Overdrive-H/suslogs.txt', '[#]: This is the start of your suspicious logs :P')
    C._CheckDirFile3(C.u40, 'Overdrive-H/cache.lua', "-- This file is licensed with Luarmor. You must use the actual loadstring to execute this script. Do not run this file directly. Always use the loadstring.\n\nif not is_from_loader then\n\twarn('Use the loadstring, do not run this directly')\n\treturn\nend;\n\nif LRM_LOAD then\n\tLRM_LOAD()\nelse\n\tLRM_CLEARCACHE()\nend")
    C._CheckDirFile3(C.u40, 'Overdrive-H/Users/' .. C._Name .. '/data.txt', 'ClientId=' .. C.u443 .. '\nExecutor=' .. C.v148)

    C.v454 = C.u40

    C._CheckDirFile3(C.u40, 'Overdrive-H/Users/' .. C._Name .. '/' .. C.u40.GameConfig .. '-configs.json', C.u40.JSEncode(C.v454, C.u39))

    C.v455 = C.u40
    C.v456 = C.u40.JSDecode(C.v455, C.u144('Overdrive-H/Users/' .. C._Name .. '/' .. C.u40.GameConfig .. '-configs.json'))
    C.v457 = nil; C.u458 = nil

    if C.v456 then
        C.v457 = C.v456

        if C.v457[C.u443] and C._t5(C.v457[C.u443]) then
            C.u153('Configurations', C.v457[C.u443])

            local _Configurations = C.u155('Configurations')

            if _Configurations.Toggle and C._t5(_Configurations.Toggle) and (_Configurations.TextBox and C._t5(_Configurations.TextBox)) and (_Configurations.Dropdown and C._t5(_Configurations.Dropdown and (_Configurations.Keybind and C._t5(_Configurations.Keybind)))) and (_Configurations.Slider and C._t5(_Configurations.Slider)) then
                C.u458 = C.v457
            else
                C.u153('Configurations', C.u39[C.u443])
                C.v457 = C.u39
                local v460 = C.u40
                C.u40.SaveConfigurations(v460)
                C._Debug2(C.u40, 'Neutral', C._Name .. "'s configuration has been revoked due to a decompiling failure!")
                C.u458 = C.v457
            end
        else
            C.u153('Configurations', C.u39[C.u443])
            C.v457 = C.u39
            local v461 = C.u40
            C.u40.SaveConfigurations(v461)
            C._Debug2(C.u40, 'Neutral', C._Name .. "'s configuration has been revoked due to a decompiling failure!")
            C.u458 = C.v457
        end
    else
        C.u153('Configurations', C.u39[C.u443])
        C.v457 = C.u39
        local v462 = C.u40
        C.u40.SaveConfigurations(v462)
        C._Debug2(C.u40, 'Neutral', C._Name .. "'s configuration has been revoked due to a decompiling failure!")
        C.u458 = C.v457
    end

    C._Debug2(C.u40, 'Success', C._Name .. "'s Configuration has been loaded!")

    C._Debug2(C.u40, 'Success', 'Your executor (' .. C.v148 .. ') is supported!')

    C.u464 = {
        'Callback',
        'Args',
        'Coroutine',
        'Spawn',
        'Invalid Args Type!',
        'Invalid Callback Closure!',
        'd',
        'Invalid Closure Type!',
    }
    C._t6 = C.u77.t
    C._f3 = C.u77.f
    C._Error = C.u40.Error
    C._GetDescendants = C._LocalPlayer.GetDescendants
    C._Destroy = C._LocalPlayer.Destroy
    C.u479 = C.u16({}, {
        __newindex = function(_, p470, p471)
            local v472 = C.u464

            if p471 then
                local v473 = C._t6

                if v473(p471) then
                    local v474 = p471[v472[1] ]

                    if v474 and C._f3(v474) then
                        local v475 = p471[v472[2] ]

                        if v475 and v473(v475) then
                            if p470 ~= v472[3] then
                                if p470 == v472[4] then
                                    C.u130(v474, C.u12(v475))
                                end
                            else
                                C._wrap(v474)(C.u12(v475))
                            end
                        else
                            C._Error(C.u40, v472[5])
                        end
                    else
                        Args = nil

                        C._Error(C.u40, v472[6])
                    end
                elseif C._f3(p471) then
                    if p470 ~= v472[3] then
                        if p470 == v472[4] then
                            C.u130(p471)
                        end
                    else
                        C._wrap(p471)()
                    end
                elseif p470 ~= v472[7] then
                    C._Error(C.u40, v472[8])
                elseif p471 then
                    local v476 = C._Destroy
                    local v477 = C._GetDescendants(p471)

                    for v478 = 1, #v477 do
                        v476(v477[v478])
                    end

                    v476(p471)
                end
            end
        end,
    })

    C._HttpRequest2 = C.u40.HttpRequest
    C._JSDecode = C.u40.JSDecode
    C._Debug3 = C.u40.Debug
    C.u483 = {
        'en-us',
        'pt-br',
        'es-hn',
    }
    C.u484 = {}

    for v485 = 1, #C.u483 do
        local v486 = C.u483[v485]

        if v486 then
            local v487 = C._HttpRequest2(C.u40, 'https://raw.githubusercontent.com/ItsJiDy/Overdrive-H/refs/heads/main/lang/' .. v486 .. '.json')

            if v487 then
                local v488 = C._JSDecode(C.u40, v487)

                if v488 then
                    C.u484[v486] = v488
                    C._Debug3(C.u40, 'Success', "'" .. v486 .. "' language has been loaded!")
                end
            else
                C._Debug3(C.u40, 'Failure', "Failed to load '" .. v486 .. "' language.")
            end
        end
    end

    C.u489 = 'en-us'
    C.u490 = 'en-us'

    function C.u40.SelectLanguage(_, p491)
        local v492 = C.u483

        for v493 = 1, #v492 do
            local v494 = v492[v493]

            if v494 == p491 then
                C.u489 = v494
                return
            end
        end

        C.u489 = C.u490
    end

    C.u495 = {
        '%.',
        '-.',
        '%f[%w]',
        '%f[%W]',
    }

    function C.u40.TranslateMatchs(_, p496)
        local v497 = C.u484[C.u489]
        local v498 = v497[p496]

        if v498 then
            return v498
        end

        local v499 = C._gsub
        local v500 = C.u495[1]
        local v501 = C.u495[2]
        local v502 = C.u495[3]
        local v503 = C.u495[4]
        local v504, v505, v506 = C.u25(v497)

        while true do
            local v507
            v506, v507 = v504(v505, v506)

            if v506 == nil then
                break
            end

            p496 = v499(p496, v502 .. v499(v506, v500, v501) .. v503, v507)
        end

        return p496
    end

    C._CheckDirFolder4 = C.u40.CheckDirFolder

    C._CheckDirFolder4(C.u40, 'Overdrive-H')
    C._CheckDirFolder4(C.u40, 'Overdrive-H/Language')

    C.__discard4, C.v509 = C.u15(C.u144, 'Overdrive-H/Language/preference.txt')

    if C.v509 and C.u77.s(C.v509) then
        C.u40:SelectLanguage(C.v509)
    end

    C._MakeInstance3 = C.u40.MakeInstance
    C.u511 = C._MakeInstance3(C.u40, 'RemoteEvent', {})
    C.u512 = C._MakeInstance3(C.u40, 'RemoteFunction', {})
    C.u513 = 'Using Remote Spy'

    do
        local u519 = UpvalueString
        local _FireServer = C.u511.FireServer
        local _InvokeServer = C.u512.InvokeServer

        function C.u40.Fire(_, p522, ...)
            return _FireServer(p522, ...)
        end

        function C.u40.Invoke(_, p523, ...)
            return _InvokeServer(p523, ...)
        end
    end

    C._MakeInstance4 = C.u40.MakeInstance
    C._Debug4 = C.u40.Debug
    C.v531 = C._MakeInstance4(C.u40, 'ScreenGui', {
        Name = '\2\1Unproxified\0; \nRagnarok Envy\0' .. C.u40:RandomString(25),
        ZIndexBehavior = C._ZIndexBehavior.Sibling,
    }, C._MakeInstance4(C.u40, 'TextButton', {
        Name = 'Shindeiru p\0\1AxueoNe',
        BackgroundColor3 = C._fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Position = C._new4(0.005, 0, 0.05, 0),
        Size = C._new4(0, 35, 0, 35),
        Font = C._Font.GothamBold,
        Text = 'ODH',
        TextColor3 = C._fromRGB(255, 255, 255),
        TextSize = 14,
        TextWrapped = true,
        Draggable = true,
        Active = true,
        Visible = false,
    }, C._MakeInstance4(C.u40, 'UICorner', {
        Name = 'UICorner',
        CornerRadius = C._new5(0, 20),
    }), C._MakeInstance4(C.u40, 'UIStroke', {
        Name = 'UIStroke',
        Transparency = 0.55,
        Color = C._fromRGB(0, 0, 255),
        ApplyStrokeMode = 'Border',
        Thickness = 2,
        Enabled = true,
    })), C._MakeInstance4(C.u40, 'Frame', {
        Name = 'NotificationContainer',
        BackgroundTransparency = 1,
        AnchorPoint = C._new3(0, 1),
        Position = C._new4(0, 10, 1, -10),
        Size = C._new4(0, 250, 0, 0),
    }, C._MakeInstance4(C.u40, 'UIListLayout', {
        Name = 'Layout',
        SortOrder = C._SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = C._new5(0, 5),
    })))

    C.u153('Sound Effect', C._MakeInstance4(C.u40, 'Sound', {
        Name = '\2\3\0\2\bAshyejpNec; \0absolute Awndo',
        Parent = C.u94,
        SoundId = 'rbxassetid://3868133279',
    }))
    C._MakeInstance4(C.u40, 'Folder', {
        Name = 'if you are reading this, go fuck yourself -- Reina',
        Parent = C.u94,
    })

    do
        local u532 = {
            'StarterFrame',
            'UIScale',
            'Visible',
            'Scale',
            'UIStroke',
            'Transparency',
            'GroupTransparency',
            'Completed',
        }
    end

    do
    C.u40.__ToggleGUIBusy = false

    function C.u40.ToggleGUI()
        C.u40.PlayTouchSoundEffect()

        if C.u40.__ToggleGUIBusy then
            return
        end

        C.u40.__ToggleGUIBusy = true

        local v538 = u532
        local v542 = C.u138[v538[1]]
        local v543 = v542[v538[2]]
        local v544 = v542[v538[3]]

        local v545
        local v546
        local v547

        if v544 then
            v545 = v543[v538[4]] - 0.15
            v546 = 1
            v547 = 1
        else
            v545 = v543[v538[4]] + 0.15
            v546 = 0.55
            v547 = 0
            v542[v538[3]] = true
        end

        C.u40.PlayTween(
            C.u40,
            v543,
            C._new6(0.25),
            {
                [v538[4]] = v545
            }
        )

        C.u40.PlayTween(
            C.u40,
            v542[v538[5]],
            C._new6(0.25),
            {
                [v538[6]] = v546
            }
        )

        C.u40.PlayTween(
            C.u40,
            v542,
            C._new6(0.25),
            {
                [v538[7]] = v547
            }
        )[v538[8]]:Wait()

        if v544 then
            v542[v538[3]] = false
        end

        C.u40.__ToggleGUIBusy = false
    end
end

    C.u157(C.v531['Shindeiru p\0\1AxueoNe'].MouseButton1Click, C.u40.ToggleGUI)
    C.u153('ScreenGui', C.v531)
    C.u153('DrawingFolderGui', C._MakeInstance4(C.u40, 'ScreenGui', {
        Name = 'ODH Drawing Folder (\0fuck you; do not touch\0)',
        Parent = C.v531,
        IgnoreGuiInset = true,
    }))
    C._Debug4(C.u40, 'Success', 'Gui & Touch (Splash and Sound) Effect has been loaded!')
    C._Debug4(C.u40, 'Success', 'Overdrive UI has been loaded!')

do
    C.u40.__DebugStats = {
        Failure = 0,
        Success = 0,
        Neutral = 0,
    }

    C.u40.__DebugMessage =
        'Contact Owner on Discord: @elfandtears_ndk!\n' ..
        'Overdrive H Debugs Loader ---------->'

    if #C.u37 <= 0 then
        C.u40.__DebugMessage =
            C.u40.__DebugMessage ..
            '\nNo debug logs have been captured!'
    else
        for i = 1, #C.u37 do
            if C.u37[i] then
                if C.u37[i].Type then
                    C.u40.__DebugStats[C.u37[i].Type] =
                        (C.u40.__DebugStats[C.u37[i].Type] or 0) + 1

                    if C.u37[i].Text then
                        C.u40.__DebugMessage =
                            C.u40.__DebugMessage ..
                            '\n[' .. C.u37[i].Type .. '] ' ..
                            C.u37[i].Text
                    end
                end
            end
        end
    end

    C.u40.__DebugMessage =
        C.u40.__DebugMessage ..
        '\n<----------\nDebug Stats:' ..
        '\n\tFailure: ' .. C.u40.__DebugStats.Failure ..
        '\n\tSuccess: ' .. C.u40.__DebugStats.Success ..
        '\n\tNeutral: ' .. C.u40.__DebugStats.Neutral

    if C.u40.__DebugStats.Failure > 0 then
        print(
            C.u40.__DebugMessage ..
            '\nmaybe show this to the owner?\nExit Code: ' ..
            C.u40.__DebugStats.Failure
        )

        C.u40:DestroyGui()
        return
    end

    print(C.u40.__DebugMessage)
end

C.u40.__Bindables = {}

C.u153('Bindables', C.u40.__Bindables)

C.u570 = function(p562, p563)
    if p562 and C.u77.t(p563) then
        local v567 = C.u40.MakeInstance(
            C.u40,
            'TextButton',
            {
                Name = '\1\0AxyPed028+\0',
                Parent = C.u155('ScreenGui'),
                BackgroundColor3 = C._fromRGB(255, 255, 255),
                BackgroundTransparency = 0.99,
                AnchorPoint = C._new3(0.5, 0.5),
                Position = p563.Position,
                Size = C._new4(0, 35, 0, 35),
                Font = C._Font.Gotham,
                Text = p563.OriginalName,
                TextSize = 10,
                TextWrapped = true,
                TextColor3 = C._fromRGB(255, 255, 255),
                Active = true,
                Draggable = not C.u155('UndraggableBindableButtons'),
            },
            C.u40.MakeInstance(
                C.u40,
                'UIStroke',
                {
                    Name = 'UIStroke',
                    Transparency = 0.55,
                    Color = C.u137.getTheme.USC,
                    Thickness = 2,
                    ApplyStrokeMode = 'Border',
                    Enabled = true,
                }
            ),
            C.u40.MakeInstance(
                C.u40,
                'UICorner',
                {
                    Name = 'UICorner',
                    CornerRadius = C._new5(0, 20),
                }
            )
        )

        C.u157(v567.MouseButton1Click, function()
            C.u40.PlayTouchSoundEffect(C.u40)
            p563.Callback()
        end)

        C.u40.__Bindables[p562] = v567

        C._insert(C.u137.getStrokes, v567.UIStroke)
    end
end

    C.u571 = 'd'

C.u40.__FindChild = function(parent, name, className)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == name then
            if not className or child.ClassName == className then
                return child
            end
        end
    end

    return nil
end

C.u40.__GetPlayers = function()
    return C._Players:GetPlayers()
end

    C.u592 = firetouchinterest

C.u40.__FireTouch = function(p593, p594)
    if p593 and p594 then
        firetouchinterest(p593, p594, 0)
        firetouchinterest(p594, p593, 0)
        firetouchinterest(p593, p594, 1)
        firetouchinterest(p594, p593, 1)
    end
end

C.u40.__RegisterTouch = function(...)
    C.u479.Spawn = {
        Callback = C.u40.__FireTouch,
        Args = {...},
    }
end

C.u40.__SendChat = function(message)
    C.channels = C.u40.__FindChild(C._TextChatService, 'TextChannels')

    if C.channels and C.channels.RBXGeneral then
        C.channels.RBXGeneral:SendAsync(message)
    end
end

C.u40.__GetRootPart = function(character)
    return character and character.HumanoidRootPart
end

    C.u608 = 'Character'

    C.u613 = function(p609)
        local v610 = p609[C.u608]

        if v610 then
            local v611, v612 = C.u15(C.u40.__GetRootPart, v610)

            if v611 then
                return v612
            end
        end
    end

    C.u614 = 'Magnitude'

    C.u617 = function(p615, p616)
        return (p615 - p616)[C.u614]
    end

    C.u618 = 'Unit'

    C.u621 = function(p619, p620)
        return (p619 - p620)[C.u618]
    end

    C.u622 = {
        'BasePart',
        'Transparency',
        'Position',
    }
    C._GetDescendants2 = C._LocalPlayer.GetDescendants
    C._IsA = C._LocalPlayer.IsA

    C.u639 = function(p625, p626)
        local v627 = C.u622
        local v628 = C._IsA
        local v629 = C.u617
        local v630 = v627[1]
        local v631 = v627[2]
        local v632 = v627[3]
        local v633 = C._GetDescendants2(p626)
        local v634 = math.huge
        local v635 = nil

        for v636 = 1, #v633 do
            local v637 = v633[v636]

            if v628(v637, v630) then
                if v637[v631] ~= 1 then
                    local v638 = v629(p625, v637[v632])

                    if v638 < v634 then
                        v635 = v637
                        v634 = v638
                    end
                end
            end
        end

        return v635
    end

    C.u640 = {
        '',
        'Name',
    }

    C.u653 = function(p641, p642)
        local v643 = C.u640

        if p641 and (p641 ~= v643[1] and not C.u3(p641)) then
            local v644 = v643[2]

            if p642 then
                local v645 = C.u40.__GetPlayers()

                for v646 = 1, #v645 do
                    local v647 = v645[v646]

                    if v647[v644] == p641 then
                        return v647
                    end
                end
            else
                local v648 = C._match
                local v649 = C._lower
                local v650 = C.u40.__GetPlayers()

                for v651 = 1, #v650 do
                    local v652 = v650[v651]

                    if v648(v649(v652[v644]), v649(p641)) then
                        return v652
                    end
                end
            end
        end
    end

    C.u664 = function(p654, p655)
        if p654 and p655 then
            local u656 = {
                'Backpack',
                'Character',
            }
            local _WaitForChild2 = C._LocalPlayer.WaitForChild
            local _Wait3 = C._Heartbeat.Wait

            C.u40:MakeTask(p654, C._LocalPlayer.CharacterAdded, function()
                local v659 = u656
                local v660 = _Wait3
                local v661 = C._Heartbeat
                local v662 = v659[2]

                _WaitForChild2(C._LocalPlayer, v659[1], 10)

                while true do
                    local v663 = C._LocalPlayer[v662]

                    if v663 then
                        break
                    end

                    v660(v661)

                    if false then
                        break
                    end
                end

                C.u135 = v663

                p655(v663)
            end)
        end
    end

    C._ScreenGui3 = C.u155('ScreenGui')
    C.v666 = get_hidden_gui or gethui
    C.v667 = syn

    if C._ScreenGui3 then
        if C.v666 then
            C._ScreenGui3.Parent = C.v666()
        elseif is_sirhurt_closure or not C.v667 or not (C.v667.protect_gui and C.u77.f(C.v667.protect_gui)) then
            local v668 = C.u40.__FindChild(C._CoreGui, 'RobloxGui')

            if v668 then
                C._ScreenGui3.Parent = v668
            else
                C._ScreenGui3.Parent = C._CoreGui
            end
        else
            C.v667.protect_gui(C._ScreenGui3)

            C._ScreenGui3.Parent = C._CoreGui
        end
    end

    function C.u40.RequireDrawing(p669, p670)
        local u671 = {
            Box = {},
            Tracer = {},
            ESP = {},
            Skeleton = {},
        }
        local u672 = {
            Name = '\nSnxUnedPak\n',
            Parent = C.u155('DrawingFolderGui'),
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            AnchorPoint = C._new3(0.5, 0.5),
            ZIndex = 0,
            Visible = false,
        }
        local _MakeInstance6 = p669.MakeInstance
        local _deg = math.deg
        local _atan2 = math.atan2
        local u676 = C._new2
        local _Position = u676(2.4975, 4.725, 0).Position
        local _Position2 = u676(-2.4975, 4.725, 0).Position
        local _Position3 = u676(2.4975, -4.725, 0).Position
        local _Position4 = u676(-2.4975, -4.725, 0).Position
        local u681 = {
            'Character',
            'Position',
            'CFrame',
            'X',
            'Y',
            'BackgroundColor3',
            'Rotation',
            'Size',
            'Magnitude',
            'Visible',
        }
        local _Box = u671.Box

        local function v737(p683)
            local v684 = _Box
            local _Name2 = p683.Name

            if not v684[_Name2] then
                local _ = AH
                local u686 = _MakeInstance6(p669, 'Frame', u672)
                local u687 = _MakeInstance6(p669, 'Frame', u672)
                local u688 = _MakeInstance6(p669, 'Frame', u672)
                local u689 = _MakeInstance6(p669, 'Frame', u672)

                v684[_Name2] = {
                    TopLeft = u686,
                    TopRight = u687,
                    BottomLeft = u688,
                    BottomRight = u689,
                    Service = C.u157(C._Heartbeat, function()
                        local v690 = u686
                        local v691 = u687
                        local v692 = u688
                        local v693 = u689

                        if v690 and (v691 and v692) and v693 then
                            local v694 = u681
                            local v695 = v694[10]

                            if p683 and p683[v694[1] ] then
                                local v696 = C.u613(p683)

                                if v696 then
                                    local v697 = v694[2]
                                    local v698 = v694[3]
                                    local v699 = v694[4]
                                    local v700 = v694[5]
                                    local v701 = v694[6]
                                    local v702 = v694[7]
                                    local v703 = v694[8]
                                    local v704 = v694[9]
                                    local v705 = C._WorldToViewportPoint
                                    local v706 = C._CurrentCamera
                                    local v707 = C._new3
                                    local v708 = _deg
                                    local v709 = _atan2
                                    local v710 = C._new4
                                    local v711 = C._lookAt(v696[v697], v706[v698][v697])
                                    local v712, v713 = v705(v706, v711 * _Position)
                                    local v714, v715 = v705(v706, v711 * _Position2)
                                    local v716, v717 = v705(v706, v711 * _Position3)
                                    local v718, v719 = v705(v706, v711 * _Position4)
                                    local v720 = p670(p683)

                                    if v713 then
                                        local v721 = v707(v712[v699], v712[v700])
                                        local v722 = v707(v714[v699], v714[v700])
                                        local v723 = v722 - v721
                                        local v724 = (v722 + v721) / 2

                                        v690[v701] = v720
                                        v690[v697] = v710(0, v724[v699], 0, v724[v700])
                                        v690[v702] = v708(v709(v723[v700], v723[v699]))
                                        v690[v703] = v710(0, v723[v704], 0, 1)
                                    end

                                    v690[v695] = v713

                                    if v715 then
                                        local v725 = v707(v714[v699], v714[v700])
                                        local v726 = v707(v718[v699], v718[v700])
                                        local v727 = v726 - v725
                                        local v728 = (v726 + v725) / 2

                                        v691[v701] = v720
                                        v691[v697] = v710(0, v728[v699], 0, v728[v700])
                                        v691[v702] = v708(v709(v727[v700], v727[v699]))
                                        v691[v703] = v710(0, v727[v704], 0, 1)
                                    end

                                    v691[v695] = v715

                                    if v717 then
                                        local v729 = v707(v716[v699], v716[v700])
                                        local v730 = v707(v712[v699], v712[v700])
                                        local v731 = v730 - v729
                                        local v732 = (v730 + v729) / 2

                                        v692[v701] = v720
                                        v692[v697] = v710(0, v732[v699], 0, v732[v700])
                                        v692[v702] = v708(v709(v731[v700], v731[v699]))
                                        v692[v703] = v710(0, v731[v704], 0, 1)
                                    end

                                    v692[v695] = v717

                                    if v719 then
                                        local v733 = v707(v718[v699], v718[v700])
                                        local v734 = v707(v716[v699], v716[v700])
                                        local v735 = v734 - v733
                                        local v736 = (v734 + v733) / 2

                                        v693[v701] = v720
                                        v693[v697] = v710(0, v736[v699], 0, v736[v700])
                                        v693[v702] = v708(v709(v735[v700], v735[v699]))
                                        v693[v703] = v710(0, v735[v704], 0, 1)
                                    end

                                    v693[v695] = v719
                                else
                                    v690[v695] = false
                                    v691[v695] = false
                                    v692[v695] = false
                                    v693[v695] = false
                                end
                            else
                                v690[v695] = false
                                v691[v695] = false
                                v692[v695] = false
                                v693[v695] = false
                            end
                        end
                    end),
                }
            end
        end

        local function v743(p738)
            local _Box2 = u671.Box
            local _Name3 = p738.Name
            local v741 = _Box2[_Name3]

            if v741 then
                local v742 = C.u479

                v741.Service:Disconnect()

                v742.d = v741.TopLeft
                v742.d = v741.TopRight
                v742.d = v741.BottomLeft
                v742.d = v741.BottomRight
                _Box2[_Name3] = nil
            end
        end

        local u744 = {
            'Character',
            'Position',
            'ViewportSize',
            'X',
            'Y',
            'BackgroundColor3',
            'Rotation',
            'Size',
            'Magnitude',
            'Visible',
        }
        local _Tracer = u671.Tracer

        local function v766(p746)
            local v747 = _Tracer
            local _Name4 = p746.Name

            if not v747[_Name4] then
                local u749 = _MakeInstance6(p669, 'Frame', u672)

                v747[_Name4] = {
                    Line = u749,
                    Service = C.u157(C._Heartbeat, function()
                        local v750 = u749

                        if v750 then
                            local v751 = u744

                            if p746 and p746[v751[1] ] then
                                local v752 = C.u613(p746)

                                if v752 then
                                    local v753 = C._CurrentCamera
                                    local v754 = v751[2]
                                    local v755, v756 = C._WorldToViewportPoint(v753, v752[v754])

                                    if v756 then
                                        local v757 = C._new3
                                        local v758 = C._new4
                                        local v759 = v751[4]
                                        local v760 = v751[5]
                                        local v761 = v753[v751[3] ]
                                        local v762 = v757(v761[v759] / 2, v761[v760])
                                        local v763 = v757(v755[v759], v755[v760])
                                        local v764 = v763 - v762
                                        local v765 = (v763 + v762) / 2

                                        v750[v751[6] ] = p670(p746)
                                        v750[v754] = v758(0, v765[v759], 0, v765[v760])
                                        v750[v751[7] ] = _deg(_atan2(v764[v760], v764[v759]))
                                        v750[v751[8] ] = v758(0, v764[v751[9] ], 0, 1)
                                    end

                                    v750[v751[10] ] = v756
                                else
                                    v750[v751[10] ] = false
                                end
                            else
                                v750[v751[10] ] = false
                            end
                        end
                    end),
                }
            end
        end

        local function v771(p767)
            local _Tracer2 = u671.Tracer
            local _Name5 = p767.Name
            local v770 = _Tracer2[_Name5]

            if v770 then
                v770.Service:Disconnect()

                C.u479.d = v770.Line
                _Tracer2[_Name5] = nil
            end
        end

        local _ESP = u671.ESP
        local u773 = {
            Name = '\n\nPawjN\n\n\n\0\n',
            Parent = C.u94,
            AlwaysOnTop = true,
            ExtentsOffset = C._new(0, 3.5, 0),
            Size = C._new4(0, 200, 0, 50),
        }
        local u774 = {
            Name = 'TXT',
            BackgroundTransparency = 1,
            Size = C._new4(0, 200, 0, 50),
            Font = C._Font.Code,
            TextSize = 13,
            TextColor3 = C._fromRGB(255, 255, 255),
        }
        local u775 = {
            Name = 'UIStroke',
            Transparency = 0.55,
            Thickness = 2,
            Enabled = true,
        }

        local function v790(p776)
            local v777 = _ESP
            local _Name6 = p776.Name

            if not v777[_Name6] then
                local v779 = C.u40
                local v780 = _MakeInstance6
                local v781 = u774

                v781.Text = _Name6

                local u782 = v780(v779, 'UIStroke', u775)
                local u783 = v780(v779, 'TextLabel', v781, u782)
                local u784 = v780(v779, 'BillboardGui', u773, u783)

                v777[_Name6] = {
                    Text = u784,
                    Service = C.u157(C._Heartbeat, function()
                        local v785 = u784

                        if v785 then
                            local v786 = p776

                            if v786 and v786.Character then
                                local v787 = C.u613
                                local v788 = v787(v786)

                                if v788 then
                                    u782.Color = p670(v786)

                                    if C.u155('DisplayDistanceOnESP') then
                                        local v789 = v787(C._LocalPlayer)

                                        if v789 then
                                            u783.Text = _Name6 .. '\nDistance: ' .. C._floor(C.u617(v789.Position, v788.Position))
                                        end
                                    else
                                        u783.Text = _Name6
                                    end

                                    v785.Adornee = v788
                                end
                            end
                        end
                    end),
                }
            end
        end

        local function v795(p791)
            local _ESP2 = u671.ESP
            local _Name7 = p791.Name
            local v794 = _ESP2[_Name7]

            if v794 then
                v794.Service:Disconnect()

                C.u479.d = v794.Text
                _ESP2[_Name7] = nil
            end
        end

        local v796 = C._LocalPlayer
        local u797 = {
            'Visible',
            'Character',
            'Name',
            'HumanoidRootPart',
            'BasePart',
            'Motor6D',
            'Part0',
            'Part1',
            'Position',
            'X',
            'Y',
            'BackgroundColor3',
            'Rotation',
            'Size',
            'Magnitude',
            'Frame',
        }
        local _Skeleton = u671.Skeleton
        local _GetChildren2 = v796.GetChildren
        local _IsA2 = v796.IsA

        return {
            CreateBox = v737,
            ClearBox = v743,
            CreateTracer = v766,
            ClearTracer = v771,
            CreateESP = v790,
            ClearESP = v795,
            CreateSkeleton = function(p801)
                local v802 = _Skeleton
                local _Name8 = p801.Name

                if not v802[_Name8] then
                    local v804 = C.u157
                    local u805 = _GetChildren2
                    local u806 = _IsA2
                    local u807 = {}

                    v802[_Name8] = {
                        Lines = u807,
                        Service = v804(C._Heartbeat, function()
                            local v808 = u807

                            if v808 then
                                local v809 = u797[1]
                                local v810 = p801[u797[2] ]

                                if v810 then
                                    local v811 = u805
                                    local v812 = u806
                                    local v813 = u672
                                    local v814 = C._CurrentCamera
                                    local v815 = p670
                                    local v816 = C._WorldToViewportPoint
                                    local v817 = C._new3
                                    local v818 = C._new4
                                    local v819 = _deg
                                    local v820 = _atan2
                                    local v821 = u797[3]
                                    local v822 = u797[4]
                                    local v823 = u797[5]
                                    local v824 = u797[6]
                                    local v825 = u797[7]
                                    local v826 = u797[8]
                                    local v827 = u797[9]
                                    local v828 = u797[10]
                                    local v829 = u797[11]
                                    local v830 = u797[12]
                                    local v831 = u797[13]
                                    local v832 = u797[14]
                                    local v833 = u797[15]
                                    local v834 = u797[16]
                                    local v835 = v811(v810)

                                    for v836 = 1, #v835 do
                                        local v837 = v835[v836]

                                        if v837[v821] ~= v822 then
                                            if v812(v837, v823) then
                                                local v838 = v815(p801)
                                                local v839 = v811(v837)

                                                for v840 = 1, #v839 do
                                                    local v841 = v839[v840]

                                                    if v812(v841, v824) then
                                                        local v842 = v808[v841]

                                                        if v842 then
                                                            local v843 = v841[v825]
                                                            local v844 = v841[v826]

                                                            if v843 and v844 then
                                                                local v845, v846 = v816(v814, v843[v827])

                                                                if v846 then
                                                                    local v847, v848 = v816(v814, v844[v827])

                                                                    if v848 then
                                                                        local v849 = v817(v845[v828], v845[v829])
                                                                        local v850 = v817(v847[v828], v847[v829])
                                                                        local v851 = v850 - v849
                                                                        local v852 = (v850 + v849) / 2

                                                                        v842[v830] = v838
                                                                        v842[v827] = v818(0, v852[v828], 0, v852[v829])
                                                                        v842[v831] = v819(v820(v851[v829], v851[v828]))
                                                                        v842[v832] = v818(0, v851[v833], 0, 1)
                                                                    end

                                                                    v842[v809] = v848
                                                                else
                                                                    v842[v809] = false
                                                                end
                                                            else
                                                                v842[v809] = false
                                                            end
                                                        else
                                                            v808[v841] = _MakeInstance6(p669, v834, v813)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                else
                                    local v853, v854, v855 = C.u25(v808)

                                    while true do
                                        local v856
                                        v855, v856 = v853(v854, v855)

                                        if v855 == nil then
                                            break
                                        end
                                        if v856 then
                                            v856[v809] = false
                                        end
                                    end
                                end
                            end
                        end),
                        Service2 = v804(p801.CharacterAdded, function()
                            local v857 = u807

                            if v857 then
                                local v858, v859, v860 = C.u25(v857)

                                while true do
                                    local v861
                                    v860, v861 = v858(v859, v860)

                                    if v860 == nil then
                                        break
                                    end

                                    v861:Remove()

                                    v857[v860] = nil
                                end
                            end
                        end),
                    }
                end
            end,
            ClearSkeleton = function(p862)
                local _Skeleton2 = u671.Skeleton
                local _Name9 = p862.Name
                local v865 = _Skeleton2[_Name9]

                if v865 then
                    local v866 = C.u479

                    v865.Service:Disconnect()
                    v865.Service2:Disconnect()

                    local v867, v868, v869 = C.u25(v865.Lines)

                    while true do
                        local v870
                        v869, v870 = v867(v868, v869)

                        if v869 == nil then
                            break
                        end
                        if v870 then
                            v866.d = v870
                        end
                    end

                    _Skeleton2[_Name9] = nil
                end
            end,
            Settings = u671,
        }
    end

    C._HttpRequest3 = C.u40.HttpRequest
    C._JSDecode2 = C.u40.JSDecode
    C.u873 = C._new6(0.5, C._EasingStyle.Sine)

    -- ============================================
    -- CORE UI FUNCTION
    -- ============================================

    C.v1655 = function()
        local u906 = C.u40
        local u907 = C.u155
        local u908 = C.u131
        local u909 = C._fromRGB
        local u910 = C._new4
        local u911 = C._new3
        local u912 = C._new5
        local u913 = C._insert
        local u914 = C.u479
        local u915 = C._new6
        local u916 = C._EasingStyle
        local _MakeInstance8 = u906.MakeInstance
        local _TranslateMatchs2 = u906.TranslateMatchs
        local _PlayTween5 = u906.PlayTween
        local _Wait5 = C._Heartbeat.Wait
        local u921 = _MakeInstance8(u906, 'CanvasGroup', {
            Name = 'StarterFrame',
            Parent = u907('ScreenGui'),
            BackgroundColor3 = u909(255, 255, 255),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            GroupColor3 = u909(255, 255, 255),
            GroupTransparency = 0,
            Position = u910(0.5, 0, -0.5, 0),
            Size = u910(0, 30, 0, 30),
            AnchorPoint = u911(0.5, 0.5),
            Draggable = true,
            Active = true,
        }, _MakeInstance8(u906, 'UIScale', {
            Name = 'UIScale',
            Scale = 1,
        }), _MakeInstance8(u906, 'UICorner', {
            Name = 'UICorner',
            CornerRadius = u912(0, 10),
        }), _MakeInstance8(u906, 'UIStroke', {
            Name = 'UIStroke',
            Transparency = 0.55,
            Color = u909(0, 0, 255),
            Thickness = 2,
            Enabled = true,
        }), _MakeInstance8(u906, 'ImageLabel', {
            Name = 'MainFrame',
            BackgroundTransparency = 0.5,
            BackgroundColor3 = u909(30, 30, 30),
            Position = u910(0.5, 0, 0.5, 0),
            Size = u910(1, 0, 1, 0),
            AnchorPoint = u911(0.5, 0.5),
        }, _MakeInstance8(u906, 'TextLabel', {
            Name = 'Title',
            BackgroundTransparency = 0.8,
            BackgroundColor3 = u909(0, 0, 225),
            Position = u910(0.5, 0, 0.045, 0),
            Size = u910(0, 600, 0, 20),
            AnchorPoint = u911(0.5, 0.5),
            Font = C._Font.Gotham,
            Text = '',
            TextSize = 12,
            TextTransparency = 1,
            TextColor3 = u909(255, 255, 255),
            RichText = true,
            TextXAlignment = C._TextXAlignment.Left,
        }, _MakeInstance8(u906, 'UICorner', {
            Name = 'UICorner',
            CornerRadius = u912(0, 10),
        })), _MakeInstance8(u906, 'ScrollingFrame', {
            Name = 'TabFrame',
            BackgroundTransparency = 0.95,
            BackgroundColor3 = u909(30, 30, 30),
            Position = u910(0.125, 0, 1.5, 0),
            Size = u910(0, 140, 0, 270),
            AnchorPoint = u911(0.5, 0.5),
            CanvasSize = u910(0, 0, 0, 0),
            AutomaticCanvasSize = C._AutomaticSize.Y,
            Visible = false,
            ScrollBarThickness = 0,
        }, _MakeInstance8(u906, 'UICorner', {
            Name = 'UICorner',
            CornerRadius = u912(0, 5),
        }), _MakeInstance8(u906, 'UIListLayout', {
            Name = 'UIListLayout',
            HorizontalAlignment = C._HorizontalAlignment.Center,
            SortOrder = C._SortOrder.LayoutOrder,
            Padding = u912(0, 8),
        }))))
        local _MainFrame = u921.MainFrame
        local u923 = {
            Christmas = {
                IMG = 'rbxassetid://113441398369454',
                MBG = u909(192, 192, 192),
                MTG = u909(191, 191, 191),
                USC = u909(190, 190, 190),
                UFB = u909(200, 200, 200),
            },
            Valentine = {
                IMG = 'rbxassetid://109467000240160',
                MBG = u909(255, 105, 180),
                MTG = u909(254, 104, 179),
                USC = u909(255, 100, 190),
                UFB = u909(250, 100, 178),
            },
            Halloween = {
                IMG = 'rbxassetid://76882543451266',
                MBG = u909(255, 215, 0),
                MTG = u909(255, 20, 0),
                USC = u909(255, 216, 0),
                UFB = u909(255, 0, 0),
            },
            Amethyst = {
                MBG = u909(0, 0, 225),
                MTG = u909(0, 0, 225),
                USC = u909(0, 0, 225),
                UFB = u909(0, 0, 225),
            },
            Amoled = {
                MBG = u909(35, 35, 35),
                MTG = u909(35, 35, 35),
                USC = u909(35, 35, 35),
                UFB = u909(40, 40, 40),
            },
            Crimson = {
                MBG = u909(220, 20, 60),
                MTG = u909(225, 20, 60),
                USC = u909(230, 20, 60),
                UFB = u909(220, 25, 60),
            },
            Dark = {
                MBG = u909(60, 60, 60),
                MTG = u909(60, 60, 60),
                USC = u909(60, 60, 60),
                UFB = u909(60, 60, 60),
            },
            NEO = {
                MBG = u909(220, 20, 60),
                MTG = u909(225, 20, 60),
                USC = u909(230, 20, 60),
                UFB = u909(220, 25, 60),
            },
        }
        local _Configurations2 = u907('Configurations')
        local _ScreenGui5 = u907('ScreenGui')
        local v926 = {}
        local u927 = {}
        local u928 = {}
        local u929 = {}
        local u930 = true
        local u931 = '1.9'
        local u932 = nil
        local u933 = nil
        local u934 = nil
        local u935 = nil
        local u936 = true
        local u937 = true
        local u938 = {}

        u913(u929, _MainFrame)
        u913(u928, u921.UIStroke)
        u913(u928, _ScreenGui5['Shindeiru p\0\1AxueoNe'].UIStroke)

        local u939 = {
            'Visible',
            'Rotation',
        }

        function u914.Coroutine()
            local v940 = u939
            local v941 = u908
            local v942 = _MainFrame
            local v943 = v940[1]
            local v944 = v940[2]
            local v945 = nil

            while true do
                repeat
                    v941(0.0055)

                    local v946 = u933
                until v946 and (u937 and v942[v943])

                local v947 = v946[v944]

                if v945 then
                    if v947 < 16 then
                        v946[v944] = v947 + 2
                    else
                        v945 = false
                    end
                elseif v947 > -16 then
                    v946[v944] = v947 - 2
                else
                    v945 = true
                end
            end
        end

        local u948 = {
            'Position',
            'Completed',
            'd',
        }
        local _PlayTween6 = u906.PlayTween
        local _Wait6 = C._Heartbeat.Wait
        local u951 = u915(0.5)
        local u952 = {}
        local u953 = {ImageTransparency = 1}

        local function u963(p954, p955, p956)
            local v957 = u948
            local v958 = u906
            local v959 = _PlayTween6
            local v960 = _Wait6
            local v961 = u952
            local v962 = v957[2]

            v961[v957[1] ] = u910(p956 / 100, 0, 1, 0)

            v960(v959(v958, p954, u915(p955), v961)[v962])
            v960(v959(v958, p954, u951, u953)[v962])

            u914[v957[3] ] = p954
        end

        function v926.ApplySetting(p964, p965, p966)
            if p965 == 'GuiScale' then
                local v967 = C.u40.__FindChild(u921, 'UIScale')

                if v967 then
                    v967.Scale = p966
                end
            elseif p965 == 'KeybindsEnabled' then
                u936 = p966
            elseif p965 == 'SpinningTabIcons' then
                u937 = p966

                if u933 then
                    u933.Rotation = 0
                end
            elseif p965 == 'Theme' and u932 ~= p966 then
                local u968 = u906

                u935 = u923[p966]

                if not u935 then
                    p964:ApplySetting(p965, u968.ThemeList[1])

                    return
                end

                local u969 = _MainFrame
                local v970 = u915
                local v971 = u916
                local v972 = _PlayTween5
                local u973 = u911
                local u974 = _MakeInstance8
                local u975 = u914
                local v976 = C.u40.__FindChild

                u932 = p966

                if p966 == 'Amethyst' or p966 == 'Crimson' or (p966 == 'Dark' or p966 == 'NEO') then
                    local _t8 = C._date('*t', C._time())

                    u969.ImageRectSize = u973(0, 0)
                    u969.ImageRectOffset = u973(0, 0)
                    u969.ImageTransparency = 0
                    u969.Image = ''

                    u908()

                    if _t8.month == 4 and _t8.day == 1 then
                        u969.Image = 'rbxassetid://110466491587898'
                        u969.ImageRectSize = u973(143, 125)

                        function u975.Coroutine()
                            local v978 = u908
                            local v979 = u973
                            local v980 = u969

                            while u932 == 'Amethyst' or (u932 == 'Crimson' or u932 == 'Dark') or p966 == 'NEO' do
                                v978(0.1)

                                local v981 = 0
                                local v982 = 0

                                for _ = 1, 54 do
                                    v978(0.015)

                                    v980.ImageRectOffset = v979(140 * v981, v982)

                                    if v981 == 6 then
                                        v982 = v982 + 125
                                        v981 = -1
                                    end

                                    v981 = v981 + 1
                                end
                            end
                        end
                    end
                elseif p966 == 'Amoled' then
                    local v983 = nil

                    u969.ImageTransparency = 0.1
                    u969.ImageRectSize = u973(200, 112)

                    local u984 = getcustomasset or getsynasset

                    if u984 then
                        local _httpsrawgithubusercontentcomItsJiDyOverdriveHrefsheadsmainimagesAmoled_Theme_Spritesrv = u968:HttpRequest('https://raw.githubusercontent.com/ItsJiDy/Overdrive-H/refs/heads/main/images/Amoled_Theme_Sprites.rv')

                        if _httpsrawgithubusercontentcomItsJiDyOverdriveHrefsheadsmainimagesAmoled_Theme_Spritesrv then
                            local u986 = 'ODH-' .. C._random(1, 9999999) * 9999 .. '.png'

                            C.u142(u986, _httpsrawgithubusercontentcomItsJiDyOverdriveHrefsheadsmainimagesAmoled_Theme_Spritesrv)

                            local v987, v988 = C.u15(function()
                                return u984(u986)
                            end)

                            if v987 and v988 and C.u77.s(v988) then
                                local v989 = deletefile or delfile

                                if v989 then
                                    v989(u986)

                                    v983 = v988
                                else
                                    v983 = v988
                                end
                            else
                                u968:Notify('Failed to load the animated background.')
                            end
                        end
                    else
                        u968:Notify('Failed to load the animated background.')
                    end
                    if v983 then
                        u969.Image = v983

                        function u975.Coroutine()
                            local v990 = u908
                            local v991 = u973

                            while true do
                                if u932 ~= 'Amoled' then
                                    return
                                end

                                v990()

                                local v992 = 0
                                local v993 = 0
                                local v994 = 5

                                for _ = 1, 145 do
                                    if u932 ~= 'Amoled' then
                                        break
                                    end

                                    v992 = v992 + 1
                                    v993 = v992 == 0 and 5 or (v992 == 1 and 215 or (v992 == 2 and 425 or (v992 == 3 and 635 or (v992 == 4 and 845 or v993))))
                                    u969.ImageRectOffset = v991(v993, v994)

                                    if v992 == 4 then
                                        v994 = v994 + 122
                                        v992 = -1
                                    end

                                    v990(0.03)
                                end
                            end
                        end
                    end
                else
                    u969.ImageRectSize = u973(0, 0)
                    u969.ImageRectOffset = u973(0, 0)
                    u969.ImageTransparency = 0
                    u969.Image = u935.IMG or ''

                    if p966 == 'Christmas' then
                        function u975.Coroutine()
                            local v995 = u968
                            local v996 = u908
                            local v997 = C._random
                            local v998 = u910
                            local v999 = u975
                            local v1000 = u963
                            local v1001 = u974
                            local v1002 = {
                                Name = 'Falling Snowflake',
                                Parent = u969,
                                BackgroundTransparency = 1,
                                BackgroundColor3 = u909(255, 255, 255),
                                AnchorPoint = u973(0.5, 0.5),
                                Image = 'rbxassetid://125703738613290',
                            }
                            local v1003 = {
                                Callback = v1000,
                                Args = {},
                            }
                            local _Args = v1003.Args

                            while u932 == 'Christmas' do
                                v996(v997(1, 50) / 100)

                                local v1005 = v997(8, 19)
                                local v1006 = v997(10, 95)
                                local v1007 = v997(3, 8)

                                v1002.Position = v998(v1006 / 100, 0, -0.1, 0)
                                v1002.Size = v998(0, v1005, 0, v1005)
                                _Args[1] = v1001(v995, 'ImageLabel', v1002)
                                _Args[2] = v1007
                                _Args[3] = v1006
                                v999.Coroutine = v1003
                            end
                        end
                    elseif p966 == 'Valentine' then
                        function u975.Coroutine()
                            local v1008 = u968
                            local v1009 = u908
                            local v1010 = C._random
                            local v1011 = u910
                            local v1012 = u975
                            local v1013 = u963
                            local v1014 = u974
                            local v1015 = {
                                Name = 'Falling Heart',
                                Parent = u969,
                                BackgroundTransparency = 1,
                                BackgroundColor3 = u909(255, 255, 255),
                                AnchorPoint = u973(0.5, 0.5),
                            }
                            local v1016 = {
                                Callback = v1013,
                                Args = {},
                            }
                            local _Args2 = v1016.Args

                            while u932 == 'Valentine' do
                                v1009(v1010(1, 50) / 100)

                                local v1018 = v1010(8, 19)
                                local v1019 = v1010(10, 95)
                                local v1020 = v1010(3, 8)
                                local v1021 = v1010(1, 3)
                                local v1022 = v1021 == 1 and 'rbxassetid://96737420241051' or (v1021 == 2 and 'rbxassetid://101695571661044' or (v1021 == 3 and 'rbxassetid://121995545202141' or nil))

                                v1015.Position = v1011(v1019 / 100, 0, -0.1, 0)
                                v1015.Size = v1011(0, v1018, 0, v1018)
                                v1015.Image = v1022
                                _Args2[1] = v1014(v1008, 'ImageLabel', v1015)
                                _Args2[2] = v1020
                                _Args2[3] = v1019
                                v1012.Coroutine = v1016
                            end
                        end
                    end
                end

                local v1023 = v970(0.5, v971.Sine)
                local v1024 = {
                    BackgroundColor3 = u935.MBG,
                }

                v972(u968, u969, v1023, v1024)

                v1024.BackgroundColor3 = u935.MTG

                v972(u968, u969.Title, v1023, v1024)

                local v1025 = C._remove
                local v1026 = u928
                local v1027 = u929
                local _USC = u935.USC
                local _UFB = u935.UFB

                if p966 == 'NEO' then
                    local _new10 = ColorSequenceKeypoint.new
                    local v1031 = {
                        Name = 'UIGradient',
                        Color = ColorSequence.new({
                            _new10(0, u909(255, 0, 0)),
                            _new10(0.45, u909(20, 20, 0)),
                            _new10(1, u909(20, 20, 20)),
                        }),
                        Rotation = 45,
                        Enabled = true,
                    }
                    local v1032, v1033, v1034 = C.u25(v1026)
                    local v1035 = {Color = _USC}

                    while true do
                        local v1036

                        v1034, v1036 = v1032(v1033, v1034)

                        if v1034 == nil then
                            break
                        end
                        if v1036 then
                            v1031.Parent = v1036

                            u974(u968, 'UIGradient', v1031)

                            if v1036.Color ~= _USC then
                                v972(u968, v1036, v1023, v1035)
                            end
                        else
                            v1025(v1026, v1034)
                        end
                    end

                    local v1037, v1038, v1039 = C.u25(v1027)
                    local v1040 = {BackgroundColor3 = _UFB}

                    while true do
                        local v1041

                        v1039, v1041 = v1037(v1038, v1039)

                        if v1039 == nil then
                            break
                        end
                        if v1041 then
                            v1031.Parent = v1041

                            u974(u968, 'UIGradient', v1031)

                            if v1041.BackgroundColor3 ~= _UFB then
                                v972(u968, v1041, v1023, v1040)
                            end
                        else
                            v1025(v1027, v1039)
                        end
                    end

                    local u1042 = u907

                    if not u1042('IsLoaded') then
                        function u975.Coroutine()
                            while not u1042('IsLoaded') do
                                u908()

                                if false then
                                    break
                                end
                            end

                            local _ApplySetting = p964.ApplySetting

                            u908(3)
                            _ApplySetting(p964, p965, 'Crimson')
                            _ApplySetting(p964, p965, 'NEO')
                        end
                    end
                else
                    local v1044, v1045, v1046 = C.u25(v1026)
                    local v1047 = {Color = _USC}

                    while true do
                        local v1048

                        v1046, v1048 = v1044(v1045, v1046)

                        if v1046 == nil then
                            break
                        end
                        if v1048 then
                            local v1049 = v976(v1048, 'UIGradient')

                            if v1049 then
                                u975.d = v1049
                            end
                            if v1048.Color ~= _USC then
                                v972(u968, v1048, v1023, v1047)
                            end
                        else
                            v1025(v1026, v1046)
                        end
                    end

                    local v1050, v1051, v1052 = C.u25(v1027)
                    local v1053 = {BackgroundColor3 = _UFB}

                    while true do
                        local v1054

                        v1052, v1054 = v1050(v1051, v1052)

                        if v1052 == nil then
                            break
                        end
                        if v1054 then
                            local v1055 = v976(v1054, 'UIGradient')

                            if v1055 then
                                u975.d = v1055
                            end
                            if v1054.BackgroundColor3 ~= _UFB then
                                v972(u968, v1054, v1023, v1053)
                            end
                        else
                            v1025(v1027, v1052)
                        end
                    end
                end
            end
        end

        local u1056 = _TranslateMatchs2(u906, 'Press Any Key!')
        local _GetStringForKeyCode = C._UserInputService.GetStringForKeyCode
        local _Notify = u906.Notify
        local _SaveConfigurations = u906.SaveConfigurations
        local _Wait7 = C._Heartbeat.Wait

        C.u157(C._UserInputService.InputBegan, function(p1061, p1062)
            if not p1062 and (p1061.KeyCode ~= C._KeyCode.Unknown and u936) then
                local _Configurations3 = u907('Configurations')
                local v1064 = u938

                if _Configurations3 and v1064 then
                    local v1065 = u906
                    local v1066 = _GetStringForKeyCode(C._UserInputService, p1061.KeyCode)
                    local v1067 = u1056
                    local v1068 = true

                    for v1069 = 1, #v1064 do
                        local v1070 = v1064[v1069]
                        local _Holder = Kebind.Holder

                        if _Holder.Text == v1067 then
                            local v1072 = _Notify

                            for v1073 = 1, #v1064 do
                                if v1064[v1073].Holder.Text == v1066 then
                                    v1072(v1065, 'The keybind <font color="rgb(0, 255, 0)">' .. v1066 .. '</font> is already taken.')

                                    return
                                end
                            end

                            _Holder.Text = v1066
                            _Configurations3.Keybind[v1070.Name] = v1066

                            _SaveConfigurations(v1065)

                            return
                        end
                        if v1070.Holder.Text == v1066 then
                            v1068 = v1070.Callback

                            break
                        end
                    end

                    if v1068 then
                        _Wait7(C._Heartbeat)
                        C.u164(v1068)
                    end
                end
            end
        end)

        local v1074 = u915(0.5, u916.Sine)
        local _ThemeList = u906.ThemeList

        v926:ApplySetting('Theme', _ThemeList[C.u3(_Configurations2.Dropdown['Select Theme']) or 1] or _ThemeList[1])
        _Wait5(_PlayTween5(u906, u921, v1074, {
            Position = u910(0.5, 0, 0.5, 0),
        }).Completed)
        u908(0.5)
        _Wait5(_PlayTween5(u906, u921, v1074, {
            Size = u910(0, 500, 0, 200),
        }).Completed)

        local u1076 = {
            Name = 'Status',
            Parent = _MainFrame,
            BackgroundTransparency = 1,
            Size = u910(0, 350, 0, 30),
        }
        local u1077 = {
            Name = 'LoadingCircle',
            BackgroundTransparency = 1,
            Position = u910(0, 0, 0, 3),
            Size = u910(0, 25, 0, 25),
            ImageTransparency = 1,
            Image = 'rbxassetid://4965945816',
        }
        local u1078 = {
            Name = 'StatusText',
            BackgroundTransparency = 1,
            Position = u910(0, 40, 0, 0),
            Size = u910(0, 300, 0, 30),
            Font = C._Font.Gotham,
            TextSize = 16,
            TextColor3 = u909(255, 255, 255),
            TextXAlignment = C._TextXAlignment.Left,
            TextTransparency = 1,
        }
        local u1079 = u915(0.5)
        local u1080 = {ImageTransparency = 0}
        local u1081 = {TextTransparency = 0}

        local function v1091(p1082, p1083)
            local v1084 = u906
            local v1085 = _MakeInstance8
            local v1086 = _PlayTween5
            local v1087 = u1076
            local v1088 = u1078
            local v1089 = u1079

            v1087.Position = u910(0, 25, 0, p1083)
            v1088.Text = p1082

            local v1090 = v1085(v1084, 'Frame', v1087, v1085(v1084, 'ImageLabel', u1077), v1085(v1084, 'TextLabel', v1088))

            v1086(v1084, v1090.LoadingCircle, v1089, u1080)
            v1086(v1084, v1090.StatusText, v1089, u1081)
            u908(0.25)

            return v1090
        end

        local _Connectingtoserver = v1091('Connecting to server...', 50)
        local _Waitingforyoutowhitelist = v1091('Waiting for you to whitelist...', 90)
        local _Initializing = v1091('Initializing...', 130)
        local _LoadingCircle = _Connectingtoserver.LoadingCircle
        local u1096 = 'Rotation'

        function u914.Coroutine()
            local v1097 = u1096
            local v1098 = u908

            while true do
                v1098(0.005)

                local v1099 = _LoadingCircle

                if not v1099 then
                    break
                end

                v1099[v1097] = v1099[v1097] + 2
            end
        end

        local u1100 = {
            'https://api.overdrivehub.xyz/v1/script/server/request?i=',
            ' ',
            'POST',
        }
        local _HexEncode = u906.HexEncode
        local _HttpRequest4 = u906.HttpRequest

        local v1107 = u906

        u906.WebServerSend(v1107, 'disconnect')

        u906.WebServerSend(v1110, u1109)
        u908(1)

        _Connectingtoserver.StatusText.Text = 'Waiting for the server to respond...'

        u908(1)

        local function u1165(p1111, p1112, p1113, p1114, p1115, p1116, p1117)
            local v1118 = C.u139
            local v1119 = C._date
            local _getStrokes = v1118.getStrokes
            local _getFlags = v1118.getFlags
            local v1122 = u909
            local v1123 = u906
            local v1124 = u910
            local v1125 = u912
            local v1126 = C._Font
            local v1127 = C._TextXAlignment
            local v1128 = C._TextYAlignment
            local v1129 = C._AutomaticSize
            local v1130 = u913
            local _MakeInstance9 = v1123.MakeInstance
            local v1132 = v1122(0, 200, 0)

            if p1114 == 0 then
                v1132 = v1122(255, 0, 0)
            elseif p1114 == 3 then
                v1132 = v1122(15, 152, 186)
            elseif p1114 == 2 then
                v1132 = v1122(0, 255, 0)
            elseif p1114 == 1 then
                v1132 = v1122(0, 0, 255)
            end

            local _getHUD = v1118.getHUD
            local _getTheme = v1118.getTheme
            local v1135 = p1111 or C._Name

            if #v1135 > 50 then
                v1135 = C._sub(v1135, 1, 50) .. '...'
            end

            local _t9 = v1119('*t', p1116)
            local v1137 = C._time()
            local _t10 = v1119('*t', v1137)
            local v1139

            if _t10.day ~= _t9.day or _t10.month ~= _t9.month or _t10.year ~= _t9.year then
                local _t11 = v1119('*t', v1137 - 86400)

                v1139 = _t11.day == _t9.day and _t11.month == _t9.month and _t11.year == _t9.year and 'Yesterday at ' or _t9.month .. '/' .. _t9.day .. '/' .. _t9.year .. ' at '
            else
                v1139 = 'Today at '
            end

            local _hour3 = _t9.hour
            local _min2 = _t9.min
            local v1143 = 'AM'

            if _min2 < 10 then
                _min2 = '0' .. _min2
            end

            local v1144 = _hour3 > 11 and 'PM' or v1143

            if _hour3 > 12 then
                _hour3 = _hour3 - 12
            end

            local u1145 = _MakeInstance9(v1123, 'Frame', {
                Name = 'Message',
                Parent = _getHUD,
                BackgroundTransparency = 0.75,
                BackgroundColor3 = _getTheme.UFB,
                Size = v1124(0, 435, 0, 30),
                AutomaticSize = v1129.Y,
            }, _MakeInstance9(v1123, 'UICorner', {
                Name = 'UICorner',
                CornerRadius = v1125(0, 5),
            }), _MakeInstance9(v1123, 'UIStroke', {
                Name = 'UIStroke',
                Transparency = 0.55,
                Color = p1115 and v1122(0, 255, 0) or _getTheme.USC,
                Thickness = 2,
                Enabled = true,
            }), _MakeInstance9(v1123, 'ImageLabel', {
                Name = 'Avatar',
                BackgroundTransparency = 1,
                Position = v1124(0, 15, 0, 7.5),
                Size = v1124(0, 30, 0, 30),
                Image = 'rbxthumb://type=AvatarHeadShot&id=' .. p1112 .. '&w=100&h=100',
            }, _MakeInstance9(v1123, 'UICorner', {
                Name = 'UICorner',
                CornerRadius = v1125(0, 15),
            }), _MakeInstance9(v1123, 'UIStroke', {
                Name = 'UIStroke',
                Transparency = 0.55,
                Color = v1132,
                Thickness = 2,
                Enabled = true,
            })), _MakeInstance9(v1123, 'TextButton', {
                Name = 'User',
                BackgroundTransparency = 1,
                Position = v1124(0, 55, 0, 13.5),
                Size = v1124(0, 100, 0, 10),
                Font = v1126.Gotham,
                Text = v1135,
                TextSize = 15,
                TextColor3 = v1132,
                TextXAlignment = v1127.Left,
                TextYAlignment = v1128.Top,
                RichText = true,
            }), _MakeInstance9(v1123, 'TextLabel', {
                Name = 'Time',
                BackgroundTransparency = 1,
                Position = v1124(0, 290, 0, 13.5),
                Size = v1124(0, 100, 0, 10),
                Font = v1126.Gotham,
                Text = v1139 .. _hour3 .. ':' .. _min2 .. ' ' .. v1144,
                TextSize = 11,
                TextColor3 = v1122(255, 255, 255),
                TextXAlignment = v1127.Left,
                TextYAlignment = v1128.Top,
                RichText = true,
            }), _MakeInstance9(v1123, 'TextLabel', {
                Name = 'Text',
                BackgroundTransparency = 1,
                Position = v1124(0, 15, 0, 50),
                Size = v1124(0, 400, 0, 10),
                Font = v1126.Gotham,
                Text = p1113 .. '\n',
                TextSize = 13,
                TextWrapped = true,
                TextColor3 = v1122(255, 255, 255),
                TextXAlignment = v1127.Left,
                TextYAlignment = v1128.Top,
                AutomaticSize = v1129.Y,
                RichText = true,
            }))
            local u1146 = C.u40.__FindChild(_getHUD.Parent, 'Enter Message')
            local u1147 = {
                'Text',
                '@',
                ' ',
            }

            C.u157(u1145.User.MouseButton1Click, function()
                if u1146 then
                    local v1148 = u1147
                    local v1149 = v1148[1]

                    u1146[v1149] = u1146[v1149] .. v1148[2] .. p1111 .. v1148[3]
                end
            end)
            v1130(_getStrokes, u1145.UIStroke)
            v1130(_getFlags, u1145)

            local v1150 = nil
            local u1151 = nil

            if p1114 == 0 then
                v1150 = 'rbxassetid://115975092499176'
                u1151 = 45
            elseif p1114 == 3 then
                v1150 = 'rbxassetid://98163105905575'
                u1151 = 48
            elseif p1114 == 2 then
                v1150 = 'rbxassetid://96509635143788'
                u1151 = 47
            elseif p1114 == 1 then
                v1150 = 'rbxassetid://77246024315687'
                u1151 = 47
            end
            if v1150 and u1151 and p1117 then
                local u1152 = _MakeInstance9(v1123, 'ImageLabel', {
                    Name = 'Decoration',
                    Parent = u1145.Avatar,
                    BackgroundTransparency = 1,
                    AnchorPoint = u911(0.5, 0.5),
                    Position = v1124(0.5, 0, 0.5, 0),
                    Size = v1124(0, 40, 0, 40),
                    Image = v1150,
                    ImageRectSize = u911(143, 143),
                    ImageRectOffset = u911(0, 0),
                })
                local u1153 = {
                    'DisableAnimatedDecorations',
                    'ImageRectOffset',
                }

                function u914.Coroutine()
                    local v1154 = u1153
                    local v1155 = u908
                    local v1156 = u1152
                    local v1157 = u1145
                    local v1158 = u1151
                    local v1159 = u907
                    local v1160 = u911
                    local v1161 = v1154[1]
                    local v1162 = v1154[2]

                    while v1156 and v1157 do
                        v1155()

                        if not v1159(v1161) then
                            local v1163 = 0
                            local v1164 = 0

                            for _ = 1, v1158 do
                                v1155(0.015)

                                if v1157 then
                                    if v1156 then
                                        v1156[v1162] = v1160(143 * v1164, v1163)

                                        if v1164 == 6 then
                                            v1163 = v1163 + 143
                                            v1164 = -1
                                        end

                                        v1164 = v1164 + 1
                                    end
                                end
                            end
                        end

                        v1155()
                    end
                end
            end

            return u1145
        end

        local u1166 = ''

        local function u1173(p1167, p1168, p1169)
            local v1170 = u1166
            local v1171 = #p1167

            for v1172 = p1168, v1171 do
                v1170 = v1170 .. p1167[v1172]

                if v1172 ~= v1171 then
                    v1170 = v1170 .. p1169
                end
            end

            return v1170
        end

        local u1174 = nil

        local v1232 = u921
        local u1233 = u911
        local u1234 = u916
        local u1235 = u928
        local u1236 = u933
        local u1237 = u935
        local u1238 = _MainFrame
        local u1239 = u929
        local u1240 = u914
        local u1241 = u1056
        local u1242 = u910
        local v1243 = _MakeInstance8
        local u1244 = u938
        local u1245 = u908

        if not C.u135 then
            while true do
                C.u135 = C._LocalPlayer.Character

                if C.u135 then
                    break
                end

                u1245()

                if false then
                    break
                end
            end
        end

        local v1246 = u915(1)
        local _LoadingCircle2 = _Connectingtoserver.LoadingCircle
        local _StatusText = _Connectingtoserver.StatusText

        _StatusText.Text = 'Connected to Server!'
        _StatusText.TextColor3 = u909(0, 255, 0)

        _Wait5(_PlayTween5(u906, _LoadingCircle2, v1246, {ImageTransparency = 1}).Completed)

        _LoadingCircle = _Waitingforyoutowhitelist.LoadingCircle
        _LoadingCircle2.Rotation = 0
        _LoadingCircle2.Image = 'rbxassetid://6031094667'

        _PlayTween5(u906, _LoadingCircle2, v1246, {ImageTransparency = 0})

        if u907('IsPremium') then
            u1245(1)
        else
            local v1249 = v1243(u906, 'TextButton', {
                Name = 'EnterKey',
                Parent = u1238,
                BackgroundColor3 = u1237.UFB,
                BackgroundTransparency = 1,
                AnchorPoint = u1233(0.5, 0.5),
                Position = u1242(0.5, 0, 0.9, 0),
                Size = u1242(0, 480, 0, 25),
                Font = C._Font.Gotham,
                Text = 'Copy Whitelist',
                TextSize = 14,
                TextColor3 = u909(255, 255, 255),
                TextTransparency = 1,
            }, v1243(u906, 'UICorner', {
                Name = 'UICorner',
                CornerRadius = u912(0, 10),
            }))

            C.u157(v1249.MouseButton1Click, function()
                local v1250 = C.u141

                if v1250 then
                    v1250('https://overdrivehub.xyz/whitelist/selections?HWID=' .. C.u443)
                    u906:Notify('Link copied to clipboard | Paste it on your browser.')
                end
            end)

            local v1251 = u915(0.5)

            _PlayTween5(u906, v1249, v1251, {
                BackgroundTransparency = 0.85,
                TextTransparency = 0,
            })

            _PlayTween5(u906, v1249, v1251, {
                BackgroundTransparency = 1,
                TextTransparency = 1,
            })
        end

        local v1252 = u915(1)
        local _LoadingCircle3 = _Waitingforyoutowhitelist.LoadingCircle
        local _StatusText2 = _Waitingforyoutowhitelist.StatusText

        _StatusText2.Text = 'Authenticated!'
        _StatusText2.TextColor3 = u909(0, 255, 0)

        _Wait5(_PlayTween5(u906, _LoadingCircle3, v1252, {ImageTransparency = 1}).Completed)

        _LoadingCircle = _Initializing.LoadingCircle
        _LoadingCircle3.Rotation = 0
        _LoadingCircle3.Image = 'rbxassetid://6031094667'

        _PlayTween5(u906, _LoadingCircle3, v1252, {ImageTransparency = 0})

        local _Game = u906.Game

        while true do
            if _Game == 'Murder Mystery 2' then
                local v1256 = C.u40.__FindChild(C._LocalPlayer, 'PlayerGui')
                local v1257 = v1256 and C.u40.__FindChild(v1256, 'MainGUI')
                local v1258 = v1257 and C.u40.__FindChild(v1257, 'Game')

                if v1258 then
                    C.u153('IsMobile', not C.u40.__FindChild(v1258, 'Inventory'))

                    break
                end
            else
                if _Game ~= 'Blade Ball' then
                    break
                end
                local v1259 = C.u40.__FindChild(C._LocalPlayer, 'PlayerGui')
                local v1260 = v1259 and C.u40.__FindChild(v1259, 'Hotbar')

                if v1260 then

                    local v1261 = C.u40.__FindChild(v1260, 'Ability')
                    local v1262 = C.u40.__FindChild(v1260, 'Block')

                    if v1261 then
                        C.u153('AbilityGradient', C.u40.__FindChild(v1261, 'UIGradient'))
                    end
                    if v1262 then
                        C.u153('BlockGradient', C.u40.__FindChild(v1262, 'UIGradient'))
                    end
                    if v1261 and v1262 then
                        break
                    end
                end
            end

            u1245()
        end

        u1245(1)

        local v1263 = u915(1)
        local _LoadingCircle4 = _Initializing.LoadingCircle
        local _StatusText3 = _Initializing.StatusText

        _StatusText3.Text = 'Ready!'
        _StatusText3.TextColor3 = u909(0, 255, 0)

        _Wait5(_PlayTween5(u906, _LoadingCircle4, v1263, {ImageTransparency = 1}).Completed)

        _LoadingCircle = nil
        _LoadingCircle4.Rotation = 0
        _LoadingCircle4.Image = 'rbxassetid://6031094667'

        _PlayTween5(u906, _LoadingCircle4, v1263, {ImageTransparency = 0})
        u1245(2)

        local v1266 = u915(0.5)
        local v1267 = {ImageTransparency = 1}
        local v1268 = {TextTransparency = 1}

        _PlayTween5(u906, _Connectingtoserver.LoadingCircle, v1266, v1267)
        _PlayTween5(u906, _Connectingtoserver.StatusText, v1266, v1268)
        _PlayTween5(u906, _Waitingforyoutowhitelist.LoadingCircle, v1266, v1267)
        _PlayTween5(u906, _Waitingforyoutowhitelist.StatusText, v1266, v1268)
        _PlayTween5(u906, _Initializing.LoadingCircle, v1266, v1267)
        _Wait5(_PlayTween5(u906, _Initializing.StatusText, v1266, v1268).Completed)

        u1240.d = _Connectingtoserver
        u1240.d = _Waitingforyoutowhitelist
        u1240.d = _Initializing
        u1240.d = CopyWhitelist

        u1245(0.5)
        _Wait5(_PlayTween5(u906, v1232, v1074, {
            Size = u1242(0, 600, 0, 300),
        }).Completed)
        u1245(1)

        u1238.TabFrame.Visible = true

        local v1269 = u915(1)

        _PlayTween5(u906, u1238.TabFrame, v1269, {
            Position = u1242(0.125, 0, 0.535, 0),
        })
        _PlayTween5(u906, u1238.Title, v1269, {
            BackgroundTransparency = 0.35,
            TextTransparency = 0,
        })
        _PlayTween5(u906, u1238, v1269, {BackgroundTransparency = 0.5})

        local v1270 = ''
        local v1271

        if _ThemeList[1] ~= 'Halloween' then
            if _ThemeList[1] ~= 'Christmas' then
                if _ThemeList[1] ~= 'Valentine' then
                    local _t12 = C._date('*t', C._time())

                    v1271 = _t12.month == 4 and _t12.day == 1 and '<font color="rgb(0, 255, 0)">[APRIL FOOLS]</font> ' or v1270
                else
                    v1271 = '<font color="rgb(255, 105, 190)">[VALENTINE]</font> '
                end
            else
                v1271 = '<font color="rgb(0, 0, 255)">[WINTER]</font> '
            end
        else
            v1271 = '<font color="rgb(255, 0, 0)">[HALLOWEEN]</font> '
        end

        u906:AnimateRichText(u1238.Title, ' Overdrive H ' .. v1271 .. '| VER. <u><font color="rgb(0, 255, 0)">' .. u931 .. '</font></u> | <font color="rgb(0, 255, 0)">' .. u906.Game .. '</font>')

        function u1240.Coroutine()
            local v1273 = u906
            local v1274 = u1245
            local v1275 = C.u2
            local _HttpRequest6 = v1273.HttpRequest
            local _JSDecode4 = v1273.JSDecode
            local _Notify3 = v1273.Notify

            while true do
                repeat
                    v1274(10)

                    local v1279 = _HttpRequest6(v1273, 'https://raw.githubusercontent.com/ItsJiDy/Overdrive-H/refs/heads/main/current%20version.json')
                until v1279

                local v1280 = _JSDecode4(v1273, v1279)

                if v1280 and v1280.VERSION ~= u931 then
                    _Notify3(v1273, '<font color="rgb(0, 0, 255)">Overdrive H</font> just got updated, new version: <font color="rgb(0, 255, 0)">' .. v1275(v1280.VERSION) .. '</font>')
                end
            end
        end

        local u1281 = {}

        local function v1285()
            local v1282 = C.u40.__GetPlayers()
            local v1283 = u1281

            for v1284 = 1, #v1283 do
                v1283[v1284](v1282)
            end
        end

        C.u157(C._Players.PlayerAdded, v1285)
        C.u157(C._Players.PlayerRemoving, v1285)

        local u1286 = nil
        local u1287 = nil

        function v926.AddTab(_, p1288, p1289)
            local u1290 = u906
            local u1291 = u1238
            local u1292 = u1242
            local u1293 = u912
            local u1294 = u1233
            local u1295 = C._Font
            local u1296 = u909
            local u1297 = u1281
            local u1298 = u913
            local u1299 = u927
            local u1300 = _Wait5
            local _TranslateMatchs3 = u1290.TranslateMatchs
            local _MakeInstance10 = u1290.MakeInstance
            local _AnimateRichText = u1290.AnimateRichText
            local _ApplyTouchEffect = u1290.ApplyTouchEffect
            local _PlayTouchSoundEffect3 = u1290.PlayTouchSoundEffect
            local u1306 = _MakeInstance10(u1290, 'ImageButton', {
                Name = u1290:RandomString(3) .. '\0Am\0\2',
                Parent = u1291.TabFrame,
                BackgroundTransparency = u930 and 0 or 0.75,
                BackgroundColor3 = u1237.UFB,
                Size = u1292(0, 130, 0, 40),
                ClipsDescendants = true,
            }, _MakeInstance10(u1290, 'UICorner', {
                Name = 'UICorner',
                CornerRadius = u1293(0, 5),
            }), _MakeInstance10(u1290, 'UIStroke', {
                Name = 'UIStroke',
                Transparency = 0.55,
                Color = u1237.USC,
                Thickness = 2,
                Enabled = true,
            }), _MakeInstance10(u1290, 'ImageLabel', {
                Name = 'Icon',
                BackgroundTransparency = 1,
                Position = u930 and u1292(0.175, 0, 0.5, 0) or u1292(0.15, 0, 0.5, 0),
                Size = u1292(0, 28, 0, 28),
                AnchorPoint = u1294(0.5, 0.5),
                Image = p1289 or '',
                Rotation = 0,
            }), _MakeInstance10(u1290, 'TextLabel', {
                Name = 'Title',
                BackgroundTransparency = 1,
                Position = u930 and u1292(0.55, 0, 0.5, 0) or u1292(0.525, 0, 0.5, 0),
                Size = u1292(0, 100, 0, 20),
                AnchorPoint = u1294(0.5, 0.5),
                Font = u1295.Gotham,
                Text = '',
                TextSize = 11,
                TextColor3 = u1296(255, 255, 255),
            }))
            local u1307 = _MakeInstance10(u1290, 'CanvasGroup', {
                Name = p1288 .. ' Group',
                Parent = u930 and u1291 and u1291 or nil,
                BackgroundColor3 = u1296(255, 255, 255),
                BackgroundTransparency = 1,
                GroupColor3 = u1296(255, 255, 255),
                GroupTransparency = u930 and 0 or 1,
                Position = u1292(0.6115, 0, 0.535, 0),
                Size = u1292(0, 455, 0, 270),
                AnchorPoint = u1294(0.5, 0.5),
                Visible = u930,
            }, _MakeInstance10(u1290, 'ScrollingFrame', {
                Name = 'Sleeker',
                BackgroundTransparency = 0.95,
                BackgroundColor3 = u1296(15, 15, 15),
                Position = u1292(0.51, 0, 0.5, 0),
                Size = u1292(0, 455, 0, 270),
                AnchorPoint = u1294(0.5, 0.5),
                CanvasSize = u1292(0, 0, 0, 0),
                AutomaticCanvasSize = C._AutomaticSize.Y,
                ScrollBarThickness = 0,
            }, _MakeInstance10(u1290, 'UICorner', {
                Name = 'UICorner',
                CornerRadius = u1293(0, 5),
            }), _MakeInstance10(u1290, 'TextLabel', {
                Name = p1288,
                BackgroundTransparency = 0.65,
                BackgroundColor3 = u1296(0, 255, 15),
                Size = u1292(0, 435, 0, 25),
                Font = u1295.Gotham,
                Text = _TranslateMatchs3(u1290, p1288),
                TextSize = 14,
                TextColor3 = u1296(255, 255, 255),
                RichText = true,
            }, _MakeInstance10(u1290, 'UICorner', {
                Name = 'UICorner',
                CornerRadius = u1293(0, 5),
            })), _MakeInstance10(u1290, 'UIListLayout', {
                Name = 'UIListLayout',
                HorizontalAlignment = C._HorizontalAlignment.Center,
                SortOrder = C._SortOrder.LayoutOrder,
                Padding = u1293(0, 8),
            })))
            local u1308 = #u1299 + 1
            local u1309 = {}

            u1299[u1308] = {
                Holder = u1307,
                Container = u1306,
            }

            if u930 then
                u1236 = u1306.Icon
                u1307.Position = u1292(0.6115, 0, 0.835, 0)

                _PlayTween5(u1290, u1307, u915(1), {
                    Position = u1292(0.6115, 0, 0.535, 0),
                })

                u1286 = u1306
                u1287 = u1299[u1308]
            end

            u930 = false

            u1298(u1235, u1306.UIStroke)
            u1298(u1239, u1306)
            _AnimateRichText(u1290, u1306.Title, _TranslateMatchs3(u1290, p1288))

            local u1310 = u915(0.3, u1234.Sine)
            local u1311 = {Transparency = 0.75}
            local u1312 = {
                Position = u1292(0.525, 0, 0.5, 0),
            }
            local u1313 = {
                Position = u1292(0.15, 0, 0.5, 0),
            }
            local u1314 = {Transparency = 0}
            local u1315 = {
                Position = u1292(0.55, 0, 0.5, 0),
            }
            local u1316 = {
                Position = u1292(0.175, 0, 0.5, 0),
            }
            local u1317 = {GroupTransparency = 0}

            C.u157(u1306.MouseButton1Click, function()
                local v1318 = u1290
                local v1319 = u1306

                _PlayTouchSoundEffect3(v1318)

                if not u934 and u1286 ~= v1319 then
                    local v1320 = u1310
                    local v1321 = _PlayTween5
                    local v1322 = u1307

                    u1286 = v1319
                    u934 = true
                    u1236.Rotation = 0
                    u1236 = v1319.Icon

                    local v1323 = u1287
                    local _Container = v1323.Container
                    local _Holder2 = v1323.Holder

                    v1321(v1318, _Container, v1320, u1311)
                    v1321(v1318, _Container.Title, v1320, u1312)
                    v1321(v1318, _Container.Icon, v1320, u1313)

                    _Holder2.GroupTransparency = 1
                    _Holder2.Visible = false
                    _Holder2.Parent = nil
                    v1322.Parent = u1291
                    v1322.Visible = true

                    v1321(v1318, v1319, v1320, u1314)
                    v1321(v1318, v1319.Title, v1320, u1315)
                    v1321(v1318, v1319.Icon, v1320, u1316)
                    u1300(v1321(v1318, v1322, v1320, u1317).Completed)

                    u1287 = u1299[u1308]
                    u934 = false
                end
            end)
            _ApplyTouchEffect(u1290, u1306)

            local u1326 = {}
            local u1327 = {
                __NOTICE = "i don't know how'd you get in here but buzz off!",
            }
            local u1328 = C._gsub(C.u2(u1327), 'table', 'odh')

            function u1327.__ONREGISTER()
                u1290:Kick(u1327.__NOTICE)
            end
            function u1240.Coroutine()
                local v1329 = u1326
                local u1330 = C._Heartbeat
                local v1331 = u1309
                local v1332 = u1307
                local v1333 = u1295
                local u1334 = u1292
                local u1335 = u1296
                local u1336 = C._TextXAlignment
                local v1337 = u1294
                local v1338 = u1298
                local v1339 = u1237
                local v1340 = u1235
                local u1341 = u907
                local u1342 = C._min
                local v1343 = u1239
                local u1344 = _TranslateMatchs3
                local u1345 = _MakeInstance10
                local v1346 = _AnimateRichText
                local v1347 = _ApplyTouchEffect
                local u1348 = _PlayTouchSoundEffect3
                local u1349 = C.u157
                local v1350 = u1297
                local u1351 = _PlayTween5
                local u1352 = C.u164
                local v1353 = _Configurations2
                local v1354 = C.u77
                local v1355 = C.u2
                local u1356 = C.u3
                local u1357 = C._lower
                local u1358 = u1241
                local _Wait9 = u1330.Wait
                local _Notify4 = u1290.Notify
                local _RemoveRichText = u1290.RemoveRichText
                local _SaveConfigurations2 = u1290.SaveConfigurations
                local _Sleeker = v1332.Sleeker
                local _UserInputState = Enum.UserInputState
                local _UserInputType = Enum.UserInputType
                local _t13 = v1354.t
                local _b = v1354.b
                local _s = v1354.s
                local _Gotham = v1333.Gotham
                local _Dropdown = v1353.Dropdown
                local _Toggle = v1353.Toggle
                local _Slider = v1353.Slider
                local _Keybind = v1353.Keybind                local _TextBox = v1353.TextBox
                local v1375 = v1337(0.5, 0.5)
                local u1376 = u1335(255, 255, 255)
                local v1377 = {
                    Name = 'UICorner',
                    CornerRadius = u1293(0, 5),
                }
                local v1378 = {
                    Name = 'UICorner',
                    CornerRadius = u1293(0, 3),
                }
                local v1379 = {
                    Name = 'UIStroke',
                    Transparency = 0.55,
                    Color = v1339.USC,
                    Thickness = 2,
                    ApplyStrokeMode = 'Border',
                    Enabled = true,
                }
                local v1380 = {
                    Parent = _Sleeker,
                    BackgroundTransparency = 1,
                    Size = u1334(0, 415, 0, 25),
                    Font = _Gotham,
                    Text = '',
                    TextSize = 13,
                    TextColor3 = u1376,
                    TextXAlignment = u1336.Left,
                    RichText = true,
                }
                local v1381 = {
                    Parent = _Sleeker,
                    BackgroundTransparency = 1,
                    Size = u1334(0, 400, 0, 35),
                    Font = _Gotham,
                    Text = '',
                    TextSize = 20,
                    TextColor3 = u1376,
                    TextXAlignment = u1336.Left,
                    RichText = true,
                }
                local v1382 = {
                    Name = 'Underline',
                    BackgroundColor3 = v1339.UFB,
                    Position = u1334(0, 0, 1, 0),
                }
                local v1383 = {
                    Name = 'Glow',
                    BackgroundTransparency = 1,
                    AnchorPoint = v1337(0.5, 0.5),
                    Position = u1334(0.5, 0, 0.5, 0),
                    Size = u1334(1, 10, 1, 10),
                    Image = 'rbxassetid://6014261993',
                    ImageColor3 = v1339.UFB,
                    ImageTransparency = 0.7,
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(49, 49, 450, 450),
                }
                local v1384 = {
                    Name = 'Click',
                    BackgroundTransparency = 1,
                    AnchorPoint = v1375,
                    Position = u1334(0.9, 0, 0.5, 0),
                    Size = u1334(0, 20, 0, 20),
                    Image = 'rbxassetid://109049639340001',
                    ImageColor3 = u1376,
                }
                local v1385 = {
                    Name = 'Activator',
                    BackgroundTransparency = 0,
                    BackgroundColor3 = u1335(255, 0, 0),
                    Position = u1334(0.8, 0, 0.5, 0),
                    Size = u1334(0, 45, 0, 13),
                    AnchorPoint = v1375,
                    ClipsDescendants = true,
                }
                local v1386 = {
                    Name = 'Toggle',
                    BackgroundTransparency = 0,
                    BackgroundColor3 = u1335(100, 100, 100),
                    Position = u1334(0.25, 0, 0.5, 0),
                    AnchorPoint = v1375,
                    Size = u1334(0, 15, 0, 10),
                }
                local v1387 = {
                    Name = 'Arrow',
                    BackgroundTransparency = 1,
                    Position = u1334(1, -40, 0.5, -10),
                    Size = u1334(0, 20, 0, 20),
                    Image = 'rbxassetid://6031091004',
                }
                local v1388 = u1344(u1290, 'Select Player')

                while not u1341('IsLoaded') do
                    _Wait9(u1330)

                    if false then
                        break
                    end
                end
                while true do
                    _Wait9(u1330)

                    for v1638 = 1, #v1329 do
                        local v1390 = v1329[v1638]

                        if v1390 ~= ' * ' then
                            local v1391

                            if _t13(v1390) then
                                local _Type2 = v1390.Type
                                local _Flag = v1390.Flag
                                local _Text2 = v1390.Text
                                local _Callback2 = v1390.Callback

                                if _Type2 == 'Label' then
                                    v1380.Name = _Text2

                                    local u1396 = u1345(u1290, 'TextLabel', v1380)

                                    v1346(u1290, u1396, u1344(u1290, _Text2))

                                    if _Flag then
                                        local u1397 = 'Text'

                                        v1331[_Flag] = function(p1398)
                                            if p1398 then
                                                u1396[u1397] = p1398
                                            end
                                        end
                                        v1391 = v1638
                                    else
                                        v1391 = v1638
                                    end
                                elseif _Type2 == 'Header' then
                                    v1381.Name = _Text2
                                    v1382.Size = u1334(0, #_Text2 * 9, 0, 2)

                                    local v1399 = u1345(u1290, 'Frame', v1382, u1345(u1290, 'UICorner', v1377), u1345(u1290, 'ImageLabel', v1383))

                                    v1346(u1290, u1345(u1290, 'TextLabel', v1381, v1399), u1344(u1290, _Text2))
                                    v1338(v1343, v1399)

                                    v1391 = v1638
                                elseif _Type2 == 'Button' then
                                    local v1400 = u1345(u1290, 'TextLabel', {
                                        Name = 'Title',
                                        BackgroundTransparency = 1,
                                        BackgroundColor3 = u1376,
                                        Size = u1334(0, 435, 0, 30),
                                        Font = _Gotham,
                                        Text = '',
                                        TextSize = 14,
                                        TextColor3 = u1376,
                                        RichText = true,
                                    })
                                    local v1401 = u1345(u1290, 'UIStroke', v1379)
                                    local v1402 = u1345(u1290, 'ImageButton', {
                                        Name = _Text2,
                                        Parent = _Sleeker,
                                        BackgroundTransparency = 0.75,
                                        BackgroundColor3 = v1339.UFB,
                                        Size = u1334(0, 435, 0, 30),
                                        ClipsDescendants = true,
                                    }, u1345(u1290, 'UICorner', v1377), v1401, v1400, u1345(u1290, 'ImageLabel', v1384))

                                    u1349(v1402.MouseButton1Click, function()
                                        u1348(u1290)
                                        u1352(_Callback2)
                                    end)
                                    v1347(u1290, v1402)
                                    v1346(u1290, v1400, u1344(u1290, _Text2))
                                    v1338(v1340, v1401)
                                    v1338(v1343, v1402)

                                    v1391 = v1638
                                elseif _Type2 == 'ImageButton' then
                                    local v1403 = u1345(u1290, 'TextLabel', {
                                        Name = 'Title',
                                        BackgroundColor3 = u1376,
                                        BackgroundTransparency = 1,
                                        Size = u1334(0, 100, 0, 20),
                                        Position = u1334(0.45, 0, 0.1, 0),
                                        Font = _Gotham,
                                        Text = '',
                                        TextSize = 15,
                                        TextColor3 = u1376,
                                        AnchorPoint = v1375,
                                        TextXAlignment = u1336.Left,
                                    })
                                    local _Activator = u1345(u1290, 'Frame', {
                                        Name = _Text2,
                                        Parent = _Sleeker,
                                        BackgroundTransparency = 1,
                                        Size = u1334(0, 435, 0, 70),
                                    }, u1345(u1290, 'ImageLabel', {
                                        Name = 'Icon',
                                        BackgroundTransparency = 1,
                                        BackgroundColor3 = u1335(0, 0, 0),
                                        Size = u1334(0, 50, 0, 50),
                                        Position = u1334(0.15, 0, 0.5, 0),
                                        Image = 'rbxthumb://type=Asset&id=' .. v1390.Icon .. '&w=150&h=150',
                                        AnchorPoint = v1375,
                                    }), v1403, u1345(u1290, 'TextButton', {
                                        Name = 'Activator',
                                        BackgroundTransparency = 0.8,
                                        BackgroundColor3 = v1339.UFB,
                                        Size = u1334(0, 160, 0, 35),
                                        Position = u1334(0.65, 0, 0.55, 0),
                                        Font = _Gotham,
                                        Text = v1390.TextButton,
                                        TextSize = 13,
                                        TextColor3 = u1335(225, 225, 225),
                                        AnchorPoint = v1375,
                                        ClipsDescendants = true,
                                    }, u1345(u1290, 'UICorner', v1377))).Activator

                                    u1349(_Activator.MouseButton1Click, function()
                                        u1348(u1290)
                                        u1352(_Callback2)
                                    end)
                                    v1347(u1290, _Activator)
                                    v1346(u1290, v1403, _Text2)
                                    v1338(v1343, _Activator)

                                    v1391 = v1638
                                elseif _Type2 == 'Toggle' then
                                    local v1405 = u1345(u1290, 'TextLabel', {
                                        Name = 'Title',
                                        BackgroundTransparency = 1,
                                        Position = u1334(0.15, 0, 0.5, 0),
                                        Size = u1334(0, 100, 0, 10),
                                        AnchorPoint = v1375,
                                        Font = _Gotham,
                                        Text = '',
                                        TextSize = 14,
                                        TextColor3 = u1376,
                                        TextXAlignment = u1336.Left,
                                        RichText = true,
                                    })
                                    local u1406 = u1345(u1290, 'Frame', v1386, u1345(u1290, 'UICorner', v1378))
                                    local v1407 = u1345(u1290, 'UIStroke', v1379)
                                    local u1408 = u1345(u1290, 'ImageButton', v1385, v1407, u1345(u1290, 'UICorner', v1378), u1406)

                                    u1345(u1290, 'Frame', {
                                        Name = _Text2,
                                        Parent = _Sleeker,
                                        BackgroundTransparency = 1,
                                        Size = u1334(0, 435, 0, 30),
                                    }, v1405, u1408)

                                    local u1409, u1410 = _RemoveRichText(u1290, _Text2)
                                    local _Restricted = v1390.Restricted
                                    local _Text3 = v1390.Text

                                    if _Restricted == 'Premium' then
                                        _Text3 = _Text3 .. ' <font color="rgb(0, 0, 255)">(Premium)</font>'
                                    elseif _Restricted == 'Exclusive' then
                                        _Text3 = _Text3 .. ' <font color="rgb(0, 255, 0)">(Exclusive)</font>'
                                    end

                                    v1346(u1290, v1405, u1344(u1290, _Text3))

                                    local u1413 = {
                                        'Is',
                                        'Only ',
                                        ' users can use this feature.',
                                        'BackgroundColor3',
                                        'Position',
                                    }
                                    local u1414 = u915(0.25)

                                    local function u1422()
                                        local v1415 = u1290
                                        local v1416 = u1413
                                        local v1417 = _Restricted

                                        if v1417 and not u1341(v1416[1] .. v1417) then
                                            _Notify4(v1415, v1416[2] .. u1357(v1417) .. v1416[3])
                                        else
                                            local v1418 = u1351
                                            local v1419 = u1414

                                            u1410 = not u1410

                                            local v1420, v1421

                                            if u1410 then
                                                v1420 = u1335(0, 255, 0)
                                                v1421 = u1334(0.75, 0, 0.5, 0)
                                            else
                                                v1420 = u1335(255, 0, 0)
                                                v1421 = u1334(0.25, 0, 0.5, 0)
                                            end

                                            v1418(v1415, u1408, v1419, {
                                                [v1416[4]] = v1420,
                                            })
                                            v1418(v1415, u1406, v1419, {
                                                [v1416[5]] = v1421,
                                            })

                                            _Toggle[u1409] = u1410

                                            _SaveConfigurations2(v1415)
                                            u1352(_Callback2, u1410)
                                        end
                                    end

                                    if _Flag then
                                        v1331[_Flag] = u1422
                                    end

                                    u1349(u1408.MouseButton1Click, function()
                                        u1348(u1290)
                                        u1422()
                                    end)
                                    v1338(v1340, v1407)

                                    local v1423 = _Toggle[u1409]

                                    if v1423 and _b(v1423) then
                                        if _Restricted and not u1341('Is' .. _Restricted) then
                                            _Notify4(u1290, 'Only ' .. u1357(_Restricted) .. ' users can use this feature.')

                                            v1391 = v1638
                                        else
                                            u1408.BackgroundColor3 = u1335(0, 255, 0)
                                            u1406.Position = u1334(0.75, 0, 0.5, 0)

                                            local v1424 = true

                                            u1240.Spawn = {
                                                Callback = u1352,
                                                Args = {_Callback2, v1424},
                                            }
                                            v1391 = v1638
                                        end
                                    else
                                        _Toggle[u1409] = false
                                        v1391 = v1638
                                    end
                                elseif _Type2 == 'Slider' then
                                    local v1425 = u1345(u1290, 'UIStroke', v1379)
                                    local v1426 = u1345(u1290, 'TextLabel', {
                                        Name = 'Title',
                                        BackgroundTransparency = 1,
                                        Position = u1334(0.15, 0, 0.335, 0),
                                        Size = u1334(0, 100, 0, 10),
                                        AnchorPoint = v1375,
                                        Font = _Gotham,
                                        Text = '',
                                        TextSize = 14,
                                        TextColor3 = u1376,
                                        TextXAlignment = u1336.Left,
                                        RichText = true,
                                    })
                                    local u1427 = u1345(u1290, 'TextBox', {
                                        Name = 'Value',
                                        BackgroundTransparency = 0,
                                        BackgroundColor3 = u1335(255, 0, 0),
                                        Position = u1334(0.8, 0, 0.335, 0),
                                        Size = u1334(0, 45, 0, 18),
                                        AnchorPoint = v1375,
                                        ClearTextOnFocus = false,
                                        Font = _Gotham,
                                        Text = '',
                                        TextSize = 12,
                                        TextColor3 = u1376,
                                    }, v1425, u1345(u1290, 'UICorner', v1377))
                                    local u1428 = u1345(u1290, 'ImageButton', {
                                        Name = 'Button',
                                        BackgroundTransparency = 0.8,
                                        BackgroundColor3 = u1376,
                                        AnchorPoint = v1375,
                                        Position = u1334(0, 20, 0.5, 0),
                                        Size = u1334(0, 10, 0, 10),
                                    }, u1345(u1290, 'UICorner', v1377))
                                    local u1429 = u1345(u1290, 'Frame', {
                                        Name = 'Filler',
                                        BackgroundTransparency = 0,
                                        BackgroundColor3 = v1339.UFB,
                                        Position = u1334(0, 0, 0.5, 0),
                                        Size = u1334(0, 20, 0, 5),
                                        AnchorPoint = v1337(0, 0.5),
                                    }, u1428, u1345(u1290, 'UICorner', v1377))
                                    local v1430 = u1345(u1290, 'Frame', {
                                        Name = _Text2,
                                        Parent = _Sleeker,
                                        BackgroundTransparency = 1,
                                        Size = u1334(0, 435, 0, 40),
                                    }, v1426, u1427, u1345(u1290, 'Frame', {
                                        Name = 'Fill',
                                        BackgroundTransparency = 0,
                                        BackgroundColor3 = u1335(60, 60, 60),
                                        Position = u1334(0.5, 0, 0.775, 0),
                                        Size = u1334(0, 400, 0, 5),
                                        AnchorPoint = v1375,
                                    }, u1429, u1345(u1290, 'UICorner', v1377)))
                                    local u1431 = _RemoveRichText(u1290, _Text2)
                                    local _Default = v1390.Default
                                    local _Minimum = v1390.Minimum
                                    local _Maximum = v1390.Maximum
                                    local u1435 = {_Callback2}
                                    local u1436 = {
                                        Callback = u1352,
                                        Args = u1435,
                                    }

                                    local function u1444(p1437)
                                        local v1438 = u1334
                                        local v1439 = _Minimum
                                        local v1440 = _Maximum
                                        local v1441 = u1356(p1437) or _Default

                                        if v1440 < v1441 then
                                            v1441 = v1440
                                        elseif v1441 < v1439 then
                                            v1441 = v1439
                                        end

                                        local v1442 = (v1441 - v1439) / (v1440 - v1439) * 400
                                        local v1443 = v1442 > 400 and 400 or (v1442 < 0 and 0 or v1442)

                                        u1428.Position = v1438(0, v1443, 0.5, 0)
                                        u1429.Size = v1438(0, v1443, 0, 5)
                                        u1427.Text = v1441
                                        _Slider[u1431] = v1441
                                        u1435[2] = v1441
                                        u1240.Spawn = u1436

                                        _SaveConfigurations2(u1290)
                                    end

                                    local u1445

                                    if _Maximum < _Default then
                                        _Default = _Maximum
                                        u1445 = _Default
                                    elseif _Default < _Minimum then
                                        _Default = _Minimum
                                        u1445 = _Default
                                    else
                                        u1445 = _Default
                                    end
                                    if _Flag then
                                        v1331[_Flag] = u1444
                                    end

                                    local u1446 = 'Text'

                                    u1349(u1427.FocusLost, function()
                                        local v1447 = u1356(u1427[u1446])

                                        if v1447 then
                                            u1444(v1447)
                                        else
                                            u1444(u1445)
                                        end
                                    end)

                                    local u1448 = nil
                                    local u1449 = nil

                                    u1349(u1428.InputBegan, function(p1450)
                                        local v1451 = _UserInputType

                                        if (p1450.UserInputType == v1451.MouseButton1 or p1450.UserInputType == v1451.Touch) and not (u1448 or u1449) then
                                            local u1452 = u1428
                                            local v1453 = u1349
                                            local u1454 = true
                                            local _ = p1450.Position.X
                                            local _Offset = u1452.Position.X.Offset
                                            local u1456 = u1452.AbsolutePosition.X - _Offset

                                            u1448 = v1453(u1330, function()
                                                if u1454 then
                                                    local v1457 = u1334
                                                    local v1458 = _Minimum
                                                    local v1459 = C.u134.X - u1456 - 3
                                                    local v1460 = v1459 > 400 and 400 or (v1459 < 0 and 0 or v1459)

                                                    u1452.Position = v1457(0, v1460, 0.5, 0)
                                                    u1429.Size = v1457(0, v1460, 0, 5)

                                                    local v1461 = C._floor(v1458 + (_Maximum - v1458) * v1460 / 395)

                                                    if _Maximum >= v1461 then
                                                        if v1461 >= v1458 then
                                                            v1458 = v1461
                                                        end
                                                    else
                                                        v1458 = _Maximum
                                                    end

                                                    u1427.Text = v1458

                                                    u1352(_Callback2, v1458)

                                                    _Slider[u1431] = v1458
                                                else
                                                    u1454 = false

                                                    if u1448 then
                                                        u1448:Disconnect()

                                                        u1448 = nil
                                                    end
                                                    if u1449 then
                                                        u1449:Disconnect()

                                                        u1449 = nil
                                                    end

                                                    _SaveConfigurations2(u1290)
                                                end
                                            end)
                                            u1449 = v1453(p1450.Changed, function()
                                                if p1450.UserInputState == _UserInputState.End then
                                                    u1454 = false

                                                    if u1448 then
                                                        u1448:Disconnect()

                                                        u1448 = nil
                                                    end
                                                    if u1449 then
                                                        u1449:Disconnect()

                                                        u1449 = nil
                                                    end

                                                    _SaveConfigurations2(u1290)
                                                end
                                            end)
                                        end
                                    end)
                                    v1346(u1290, v1426, u1344(u1290, _Text2))
                                    v1338(v1340, v1425)
                                    v1338(v1343, v1430)
                                    v1338(v1343, u1429)

                                    local v1462 = u1356(_Slider[u1431])

                                    if v1462 then
                                        u1444(v1462)

                                        v1391 = v1638
                                    else
                                        _Slider[u1431] = u1445

                                        u1444(u1445)

                                        v1391 = v1638
                                    end
                                elseif _Type2 == 'Keybind' then
                                    local v1463 = u1345(u1290, 'Frame', {
                                        Name = _Text2,
                                        Parent = _Sleeker,
                                        BackgroundTransparency = 1,
                                        Size = u1334(0, 435, 0, 30),
                                    }, u1345(u1290, 'TextLabel', {
                                        Name = 'Title',
                                        BackgroundTransparency = 1,
                                        Position = u1334(0.15, 0, 0.5, 0),
                                        Size = u1334(0, 100, 0, 10),
                                        AnchorPoint = v1375,
                                        Font = _Gotham,
                                        Text = '',
                                        TextSize = 14,
                                        TextColor3 = u1376,
                                        TextXAlignment = u1336.Left,
                                        RichText = true,
                                    }), u1345(u1290, 'TextButton', {
                                        Name = 'Activator',
                                        BackgroundTransparency = 0,
                                        BackgroundColor3 = u1335(255, 0, 0),
                                        Position = u1334(0.8, 0, 0.5, 0),
                                        Size = u1334(0, 75, 0, 15),
                                        AnchorPoint = v1375,
                                        Font = _Gotham,
                                        Text = v1390.Default or u1358,
                                        TextSize = 12,
                                        TextColor3 = u1376,
                                        ClipsDescendants = true,
                                    }, u1345(u1290, 'UIStroke', v1379), u1345(u1290, 'UICorner', v1377)))
                                    local u1464 = _RemoveRichText(u1290, _Text2)
                                    local _Activator2 = v1463.Activator

                                    v1338(u1244, {
                                        Name = u1464,
                                        Holder = _Activator2,
                                        Callback = _Callback2,
                                    })

                                    local u1466 = {
                                        'Text',
                                        '',
                                    }

                                    u1349(_Activator2.MouseButton1Click, function()
                                        local v1467 = u1466
                                        local v1468 = u1290

                                        u1348(v1468)

                                        _Activator2[v1467[1] ] = u1358
                                        _Keybind[u1464] = v1467[2]

                                        _SaveConfigurations2(v1468)
                                    end)
                                    v1346(u1290, v1463.Title, u1344(u1290, _Text2))
                                    v1338(v1340, _Activator2.UIStroke)

                                    local v1469 = _Keybind[u1464]

                                    if v1469 and _s(v1469) and v1469 ~= '' then
                                        _Activator2.Text = _Keybind[u1464]
                                        v1391 = v1638
                                    else
                                        _Keybind[u1464] = v1390.Default or ''
                                        v1391 = v1638
                                    end
                                elseif _Type2 == 'Dropdown' then
                                    local _RemoveRichText2 = u1290.RemoveRichText
                                    local _Selections = v1390.Selections
                                    local _Callback3 = v1390.Callback
                                    local u1473 = _Selections[1]
                                    local u1474 = u1345(u1290, 'ScrollingFrame', {
                                        Name = 'OptionContainer',
                                        BackgroundTransparency = 1,
                                        CanvasSize = u1334(0, 0, 0, 0),
                                        AutomaticCanvasSize = C._AutomaticSize.Y,
                                        ScrollBarThickness = 0,
                                        Size = u1334(1, 0, 1, 0),
                                        ZIndex = 10,
                                    }, u1345(u1290, 'UIListLayout', {
                                        Name = 'UIListLayout',
                                        HorizontalAlignment = C._HorizontalAlignment.Center,
                                        SortOrder = C._SortOrder.LayoutOrder,
                                    }), u1345(u1290, 'UIPadding', {
                                        Name = 'UIPadding',
                                        PaddingTop = u1293(0, 5),
                                        PaddingBottom = u1293(0, 5),
                                    }))
                                    local v1475 = u1345(u1290, 'UIStroke', v1379)
                                    local u1476 = u1345(u1290, 'Frame', {
                                        Name = 'Menu',
                                        BackgroundTransparency = 0.95,
                                        BackgroundColor3 = v1339.UFB,
                                        ClipsDescendants = true,
                                        Position = u1334(0, 0, 1, 3),
                                        Size = u1334(1, 0, 0, 0),
                                        Visible = false,
                                    }, v1475, u1345(u1290, 'UICorner', v1378), u1474)
                                    local u1477 = u1345(u1290, 'ImageLabel', v1387)
                                    local v1478 = u1345(u1290, 'UIStroke', v1379)
                                    local u1479 = u1345(u1290, 'TextButton', {
                                        Name = 'Button',
                                        BackgroundTransparency = 0.95,
                                        BackgroundColor3 = v1339.UFB,
                                        Position = u1334(0, 15, 0, 20),
                                        Size = u1334(1, -25, 0, 30),
                                        RichText = true,
                                        Font = _Gotham,
                                        Text = v1388,
                                        TextSize = 14,
                                        TextColor3 = u1376,
                                        TextXAlignment = u1336.Left,
                                    }, v1478, u1345(u1290, 'UIPadding', {
                                        Name = 'UIPadding',
                                        PaddingLeft = u1293(0, 10),
                                    }), u1345(u1290, 'UICorner', v1377), u1477, u1476)
                                    local v1480 = u1345(u1290, 'TextLabel', {
                                        Name = 'Title',
                                        BackgroundTransparency = 1,
                                        Position = u1334(0, 15, 0, 0),
                                        Size = u1334(1, 0, 0, 20),
                                        RichText = true,
                                        Font = _Gotham,
                                        Text = '',
                                        TextSize = 14,
                                        TextColor3 = u1376,
                                        TextXAlignment = u1336.Left,
                                    })
                                    local u1481 = u1345(u1290, 'Frame', {
                                        Name = _Text2,
                                        Parent = _Sleeker,
                                        BackgroundTransparency = 1,
                                        ClipsDescendants = true,
                                        Size = u1334(0, 435, 0, 60),
                                    }, v1480, u1479)
                                    local u1482 = _RemoveRichText2(u1290, _Text2)
                                    local u1483 = u1342(#_Selections * 25, 150)
                                    local u1484 = nil
                                    local u1485 = nil
                                    local u1486 = nil
                                    local u1487 = {_Callback3}
                                    local u1488 = {
                                        Callback = u1352,
                                        Args = u1487,
                                    }

                                    if _Flag then
                                        v1331[_Flag] = function(p1489)
                                            local v1490 = C.u40.__FindChild(u1474, p1489)

                                            if v1490 then
                                                u1473 = p1489
                                                u1479.Text = u1344(u1290, p1489)
                                                u1485.TextColor3 = u1335(104, 104, 104)
                                                v1490.TextColor3 = u1376
                                                u1485 = v1490
                                                u1487[2] = p1489
                                                u1240.Coroutine = u1488
                                                _Dropdown[u1482] = _

                                                _SaveConfigurations2(u1290)
                                            else
                                                _Notify4(u1290, '<font color="rgb(0, 255, 0)">' .. p1489 .. '</font> is not a valid option.')
                                            end
                                        end
                                    end

                                    local u1491 = u915(0.25)
                                    local u1492 = {}
                                    local u1493 = {Rotation = 180}
                                    local u1494 = {}
                                    local u1495 = {
                                        Size = u1334(1, 0, 0, 0),
                                    }
                                    local u1496 = {Rotation = 0}
                                    local u1497 = {
                                        Size = u1334(0, 435, 0, 60),
                                    }

                                    local function u1505()
                                        if not u1486 then
                                            u1486 = true

                                            local v1498 = u1290
                                            local v1499 = u1351
                                            local _ = Items
                                            local v1500 = u1491

                                            u1484 = not u1484

                                            if u1484 then
                                                local v1501 = u1483
                                                local v1502 = u1492
                                                local v1503 = u1494

                                                u1476.Visible = true
                                                v1502.Size = u1334(1, 0, 0, v1501)

                                                v1499(v1498, u1476, v1500, v1502)
                                                v1499(v1498, u1477, v1500, u1493)

                                                v1503.Size = u1334(0, 435, 0, 60 + v1501)

                                                v1499(v1498, u1481, v1500, v1503).Completed:Wait()
                                            else
                                                local v1504 = v1499(v1498, u1476, v1500, u1495)

                                                v1499(v1498, u1477, v1500, u1496)
                                                v1499(v1498, u1481, v1500, u1497)
                                                v1504.Completed:Wait()

                                                u1476.Visible = false
                                            end

                                            u1486 = false
                                        end
                                    end

                                    v1346(u1290, v1480, u1344(u1290, _Text2))
                                    v1338(v1340, v1478)
                                    v1338(v1340, v1475)
                                    v1338(v1343, u1479)
                                    v1338(v1343, u1476)
                                    v1347(u1290, u1479)

                                    local v1506 = u1356(_Dropdown[u1482])

                                    if v1506 and _Selections[v1506] then
                                        u1473 = _Selections[v1506]
                                    else
                                        _Dropdown[u1482] = 1
                                    end

                                    u1479.Text = u1473

                                    u1349(u1479.MouseButton1Click, function()
                                        u1348(u1290)
                                        u1505()
                                    end)

                                    local v1507 = {
                                        Parent = u1474,
                                        BackgroundTransparency = 1,
                                        Size = u1334(1, -10, 0, 25),
                                        RichText = true,
                                        Font = _Gotham,
                                        TextColor3 = u1335(104, 104, 104),
                                        TextSize = 14,
                                        TextXAlignment = u1336.Left,
                                    }

                                    v1391 = v1638

                                    for v1508 = 1, #_Selections do
                                        local u1509 = v1508
                                        local u1510 = _Selections[u1509]

                                        v1507.Name = u1510
                                        v1507.Text = u1344(u1290, u1510)

                                        local u1511 = u1345(u1290, 'TextButton', v1507)

                                        if u1473 == u1510 then
                                            u1511.TextColor3 = u1376
                                            u1485 = u1511
                                        end

                                        u1349(u1511.MouseButton1Click, function()
                                            if not u1486 then
                                                u1473 = u1510
                                                u1479.Text = u1344(u1290, u1510)
                                                u1485.TextColor3 = u1335(104, 104, 104)
                                                u1511.TextColor3 = u1376
                                                u1485 = u1511
                                                u1487[2] = u1473
                                                u1240.Coroutine = u1488

                                                u1348(u1290)

                                                _Dropdown[u1482] = u1509

                                                _SaveConfigurations2(u1290)
                                                u1505()
                                            end
                                        end)
                                    end

                                    u1487[2] = u1473
                                    u1240.Coroutine = u1488
                                elseif _Type2 == 'Dropdown2' then
                                    local _RemoveRichText3 = u1290.RemoveRichText
                                    local _Selections2 = v1390.Selections
                                    local _Callback4 = v1390.Callback
                                    local u1515 = _Selections2[1]
                                    local u1516 = u1345(u1290, 'ScrollingFrame', {
                                        Name = 'OptionContainer',
                                        BackgroundTransparency = 1,
                                        CanvasSize = u1334(0, 0, 0, 0),
                                        AutomaticCanvasSize = C._AutomaticSize.Y,
                                        ScrollBarThickness = 0,
                                        Size = u1334(1, 0, 1, 0),
                                        ZIndex = 10,
                                    }, u1345(u1290, 'UIListLayout', {
                                        Name = 'UIListLayout',
                                        HorizontalAlignment = C._HorizontalAlignment.Center,
                                        SortOrder = C._SortOrder.LayoutOrder,
                                    }), u1345(u1290, 'UIPadding', {
                                        Name = 'UIPadding',
                                        PaddingTop = u1293(0, 5),
                                        PaddingBottom = u1293(0, 5),
                                    }))
                                    local v1517 = u1345(u1290, 'UIStroke', v1379)
                                    local u1518 = u1345(u1290, 'Frame', {
                                        Name = 'Menu',
                                        BackgroundTransparency = 0.95,
                                        BackgroundColor3 = v1339.UFB,
                                        ClipsDescendants = true,
                                        Position = u1334(0, 0, 1, 3),
                                        Size = u1334(1, 0, 0, 0),
                                        Visible = false,
                                    }, v1517, u1345(u1290, 'UICorner', v1378), u1516)
                                    local u1519 = u1345(u1290, 'ImageLabel', v1387)
                                    local v1520 = u1345(u1290, 'UIStroke', v1379)
                                    local u1521 = u1345(u1290, 'TextButton', {
                                        Name = 'Button',
                                        BackgroundTransparency = 0.95,
                                        BackgroundColor3 = v1339.UFB,
                                        Position = u1334(0, 15, 0, 20),
                                        Size = u1334(1, -25, 0, 30),
                                        RichText = true,
                                        Font = _Gotham,
                                        Text = v1388,
                                        TextSize = 14,
                                        TextColor3 = u1376,
                                        TextXAlignment = u1336.Left,
                                    }, v1520, u1345(u1290, 'UIPadding', {
                                        Name = 'UIPadding',
                                        PaddingLeft = u1293(0, 10),
                                    }), u1345(u1290, 'UICorner', v1377), u1519, u1518)
                                    local v1522 = u1345(u1290, 'TextLabel', {
                                        Name = 'Title',
                                        BackgroundTransparency = 1,
                                        Position = u1334(0, 15, 0, 0),
                                        Size = u1334(1, 0, 0, 20),
                                        RichText = true,
                                        Font = _Gotham,
                                        Text = '',
                                        TextSize = 14,
                                        TextColor3 = u1376,
                                        TextXAlignment = u1336.Left,
                                    })
                                    local u1523 = u1345(u1290, 'Frame', {
                                        Name = _Text2,
                                        Parent = _Sleeker,
                                        BackgroundTransparency = 1,
                                        ClipsDescendants = true,
                                        Size = u1334(0, 435, 0, 60),
                                    }, v1522, u1521)
                                    local u1524 = _RemoveRichText3(u1290, _Text2)
                                    local u1525 = u1342(#_Selections2 * 25, 150)
                                    local u1526 = nil
                                    local u1527 = nil
                                    local u1528 = nil
                                    local u1529 = {_Callback4}
                                    local u1530 = {
                                        Callback = u1352,
                                        Args = u1529,
                                    }
                                    local u1531 = u915(0.25)
                                    local u1532 = {}
                                    local u1533 = {Rotation = 180}
                                    local u1534 = {}
                                    local u1535 = {
                                        Size = u1334(1, 0, 0, 0),
                                    }
                                    local u1536 = {Rotation = 0}
                                    local u1537 = {
                                        Size = u1334(0, 435, 0, 60),
                                    }

                                    local function u1545()
                                        if not u1528 then
                                            u1528 = true

                                            local v1538 = u1290
                                            local v1539 = u1351
                                            local _ = Items
                                            local v1540 = u1531

                                            u1526 = not u1526

                                            if u1526 then
                                                local v1541 = u1525
                                                local v1542 = u1532
                                                local v1543 = u1534

                                                u1518.Visible = true
                                                v1542.Size = u1334(1, 0, 0, v1541)

                                                v1539(v1538, u1518, v1540, v1542)
                                                v1539(v1538, u1519, v1540, u1533)

                                                v1543.Size = u1334(0, 435, 0, 60 + v1541)

                                                v1539(v1538, u1523, v1540, v1543).Completed:Wait()
                                            else
                                                local v1544 = v1539(v1538, u1518, v1540, u1535)

                                                v1539(v1538, u1519, v1540, u1536)
                                                v1539(v1538, u1523, v1540, u1537)
                                                v1544.Completed:Wait()

                                                u1518.Visible = false
                                            end

                                            u1528 = false
                                        end
                                    end

                                    v1346(u1290, v1522, u1344(u1290, _Text2))
                                    v1338(v1340, v1520)
                                    v1338(v1340, v1517)
                                    v1338(v1343, u1521)
                                    v1338(v1343, u1518)
                                    v1347(u1290, u1521)

                                    local v1546 = u1356(_Dropdown[u1524])

                                    if v1546 and _Selections2[v1546] then
                                        u1515 = _Selections2[v1546]
                                    else
                                        _Dropdown[u1524] = 1
                                    end

                                    u1521.Text = u1515

                                    u1349(u1521.MouseButton1Click, function()
                                        u1348(u1290)
                                        u1545()
                                    end)

                                    local v1547 = {
                                        Parent = u1516,
                                        BackgroundTransparency = 1,
                                        Size = u1334(1, -10, 0, 25),
                                        RichText = true,
                                        Font = _Gotham,
                                        TextColor3 = u1335(104, 104, 104),
                                        TextSize = 14,
                                        TextXAlignment = u1336.Left,
                                    }

                                    v1391 = v1638

                                    local u1548 = u1525
                                    local u1549 = u1528

                                    for v1550 = 1, #_Selections2 do
                                        local u1551 = v1550
                                        local u1552 = _Selections2[u1551]

                                        v1547.Name = u1552
                                        v1547.Text = u1344(u1290, u1552)

                                        local u1553 = u1345(u1290, 'TextButton', v1547)

                                        if u1515 == u1552 then
                                            u1553.TextColor3 = u1376
                                            u1527 = u1553
                                        end

                                        u1349(u1553.MouseButton1Click, function()
                                            if not u1549 then
                                                u1515 = u1552
                                                u1521.Text = u1344(u1290, u1552)
                                                u1527.TextColor3 = u1335(104, 104, 104)
                                                u1553.TextColor3 = u1376
                                                u1527 = u1553
                                                u1529[2] = u1515
                                                u1240.Coroutine = u1530

                                                u1348(u1290)

                                                _Dropdown[u1524] = u1551

                                                _SaveConfigurations2(u1290)
                                                u1545()
                                            end
                                        end)
                                    end

                                    if _Flag then
                                        local _GetChildren3 = u1516.GetChildren
                                        local _IsA3 = u1516.IsA

                                        v1331[_Flag] = function(p1556)
                                            local u1557 = u1290
                                            local v1558 = u1516
                                            local v1559 = _IsA3
                                            local v1560 = u1349
                                            local v1561 = u1345
                                            local u1562 = u1335
                                            local u1563 = u1240
                                            local v1564 = {
                                                Parent = v1558,
                                                BackgroundTransparency = 1,
                                                Size = u1334(1, -10, 0, 25),
                                                RichText = true,
                                                Font = _Gotham,
                                                TextColor3 = u1562(104, 104, 104),
                                                TextSize = 14,
                                                TextXAlignment = u1336.Left,
                                            }
                                            local v1565 = _GetChildren3(v1558)

                                            for v1566 = 1, #v1565 do
                                                local v1567 = v1565[v1566]

                                                if v1559(v1567, 'TextButton') then
                                                    u1563.d = v1567
                                                end
                                            end

                                            u1548 = u1342(#p1556 * 25, 150)

                                            for v1568 = 1, #p1556 do
                                                local u1569 = v1568
                                                local u1570 = p1556[u1569]

                                                v1564.Name = u1570
                                                v1564.Text = u1344(u1557, u1570)

                                                local u1571 = v1561(u1557, 'TextButton', v1564)

                                                if u1515 == u1570 then
                                                    u1527 = u1571
                                                    u1571.TextColor3 = u1376
                                                end

                                                v1560(u1571.MouseButton1Click, function()
                                                    if not u1549 then
                                                        u1515 = u1570
                                                        u1521.Text = u1344(u1557, u1570)
                                                        u1527.TextColor3 = u1562(104, 104, 104)
                                                        u1571.TextColor3 = u1376
                                                        u1527 = u1571
                                                        u1529[2] = u1515
                                                        u1563.Coroutine = u1530

                                                        u1348(u1557)

                                                        _Dropdown[u1524] = u1569

                                                        _SaveConfigurations2(u1557)
                                                        u1545()
                                                    end
                                                end)
                                            end
                                        end
                                    end

                                    u1529[2] = u1515
                                    u1240.Coroutine = u1530
                                elseif _Type2 == 'PlayerDropdown' then
                                    local u1572 = u1345(u1290, 'ScrollingFrame', {
                                        Name = 'OptionContainer',
                                        BackgroundTransparency = 1,
                                        CanvasSize = u1334(0, 0, 0, 0),
                                        AutomaticCanvasSize = C._AutomaticSize.Y,
                                        ScrollBarThickness = 0,
                                        Size = u1334(1, 0, 1, 0),
                                        ZIndex = 10,
                                    }, u1345(u1290, 'UIListLayout', {
                                        Name = 'UIListLayout',
                                        HorizontalAlignment = C._HorizontalAlignment.Center,
                                        SortOrder = C._SortOrder.LayoutOrder,
                                    }), u1345(u1290, 'UIPadding', {
                                        Name = 'UIPadding',
                                        PaddingTop = u1293(0, 5),
                                        PaddingBottom = u1293(0, 5),
                                    }))
                                    local v1573 = u1345(u1290, 'UIStroke', v1379)
                                    local u1574 = u1345(u1290, 'Frame', {
                                        Name = 'Menu',
                                        BackgroundTransparency = 0.95,
                                        BackgroundColor3 = v1339.UFB,
                                        ClipsDescendants = true,
                                        Position = u1334(0, 0, 1, 3),
                                        Size = u1334(1, 0, 0, 0),
                                        Visible = false,
                                    }, v1573, u1345(u1290, 'UICorner', v1378), u1572)
                                    local u1575 = u1345(u1290, 'ImageLabel', v1387)
                                    local v1576 = u1345(u1290, 'UIStroke', v1379)
                                    local u1577 = u1345(u1290, 'TextButton', {
                                        Name = 'Button',
                                        BackgroundTransparency = 0.95,
                                        BackgroundColor3 = v1339.UFB,
                                        Position = u1334(0, 15, 0, 20),
                                        Size = u1334(1, -25, 0, 30),
                                        RichText = true,
                                        Font = _Gotham,
                                        Text = v1388,
                                        TextSize = 14,
                                        TextColor3 = u1376,
                                        TextXAlignment = u1336.Left,
                                    }, v1576, u1345(u1290, 'UIPadding', {
                                        Name = 'UIPadding',
                                        PaddingLeft = u1293(0, 10),
                                    }), u1345(u1290, 'UICorner', v1377), u1575, u1574)
                                    local v1578 = u1345(u1290, 'TextLabel', {
                                        Name = 'Title',
                                        BackgroundTransparency = 1,
                                        Position = u1334(0, 15, 0, 0),
                                        Size = u1334(1, 0, 0, 20),
                                        RichText = true,
                                        Font = _Gotham,
                                        Text = '',
                                        TextSize = 14,
                                        TextColor3 = u1376,
                                        TextXAlignment = u1336.Left,
                                    })
                                    local u1579 = u1345(u1290, 'Frame', {
                                        Name = _Text2,
                                        Parent = _Sleeker,
                                        BackgroundTransparency = 1,
                                        ClipsDescendants = true,
                                        Size = u1334(0, 435, 0, 60),
                                    }, v1578, u1577)

                                    _RemoveRichText(u1290, _Text2)

                                    local u1580 = nil
                                    local u1581 = nil
                                    local u1582 = nil
                                    local u1583 = nil
                                    local u1584 = nil
                                    local u1585 = u915(0.25)
                                    local u1586 = {}
                                    local u1587 = {Rotation = 180}
                                    local u1588 = {}
                                    local u1589 = {
                                        Size = u1334(1, 0, 0, 0),
                                    }
                                    local u1590 = {Rotation = 0}
                                    local u1591 = {
                                        Size = u1334(0, 435, 0, 60),
                                    }

                                    local function u1599()
                                        if not u1584 then
                                            u1584 = true

                                            local v1592 = u1290
                                            local v1593 = u1351
                                            local _ = Items
                                            local v1594 = u1585

                                            u1581 = not u1581

                                            if u1581 then
                                                local v1595 = u1580
                                                local v1596 = u1586
                                                local v1597 = u1588

                                                u1574.Visible = true
                                                v1596.Size = u1334(1, 0, 0, v1595)

                                                v1593(v1592, u1574, v1594, v1596)
                                                v1593(v1592, u1575, v1594, u1587)

                                                v1597.Size = u1334(0, 435, 0, 60 + v1595)

                                                v1593(v1592, u1579, v1594, v1597).Completed:Wait()
                                            else
                                                local v1598 = v1593(v1592, u1574, v1594, u1589)

                                                v1593(v1592, u1575, v1594, u1590)
                                                v1593(v1592, u1579, v1594, u1591)
                                                v1598.Completed:Wait()

                                                u1574.Visible = false
                                            end

                                            u1584 = false
                                        end
                                    end

                                    v1346(u1290, v1578, u1344(u1290, _Text2))
                                    v1338(v1340, v1576)
                                    v1338(v1340, v1573)
                                    v1338(v1343, u1577)
                                    v1338(v1343, u1574)
                                    v1347(u1290, u1577)
                                    u1349(u1577.MouseButton1Click, function()
                                        u1348(u1290)
                                        u1599()
                                    end)

                                    local u1600 = {_Callback2}
                                    local u1601 = {
                                        Callback = u1352,
                                        Args = u1600,
                                    }
                                    local _GetChildren4 = u1572.GetChildren

                                    local function v1618(p1603)
                                        local u1604 = u1290
                                        local v1605 = u1345
                                        local v1606 = u1572
                                        local u1607 = u1240
                                        local v1608 = u1349
                                        local _IsA4 = v1606.IsA

                                        u1580 = u1342(#p1603 * 25, 150)

                                        local v1610 = _GetChildren4(v1606)

                                        for v1611 = 1, #v1610 do
                                            local v1612 = v1610[v1611]

                                            if _IsA4(v1612, 'TextButton') then
                                                u1607.d = v1612
                                            end
                                        end

                                        local v1613 = {
                                            Parent = v1606,
                                            BackgroundTransparency = 1,
                                            Size = u1334(1, -10, 0, 25),
                                            RichText = true,
                                            Font = _Gotham,
                                            TextColor3 = u1335(104, 104, 104),
                                            TextSize = 14,
                                            TextXAlignment = u1336.Left,
                                        }

                                        for v1614 = 1, #p1603 do
                                            local u1615 = p1603[v1614]
                                            local _Name10 = u1615.Name

                                            v1613.Name = _Name10
                                            v1613.Text = _Name10

                                            local u1617 = v1605(u1604, 'TextButton', v1613)

                                            if u1583 == u1615 then
                                                u1582 = u1617
                                                u1617.TextColor3 = u1376
                                            end

                                            v1608(u1617.MouseButton1Click, function()
                                                if not u1584 then
                                                    u1583 = _Name10
                                                    u1577.Text = u1583

                                                    if u1582 then
                                                        u1582.TextColor3 = u1335(104, 104, 104)
                                                    end

                                                    u1617.TextColor3 = u1376
                                                    u1582 = u1617
                                                    u1600[2] = u1615
                                                    u1607.Coroutine = u1601

                                                    u1348(u1604)
                                                    u1599()
                                                end
                                            end)
                                        end
                                    end

                                    v1338(v1350, v1618)
                                    v1618(C.u40.__GetPlayers())

                                    v1391 = v1638
                                elseif _Type2 == 'Paragraph' then
                                    local v1619 = u1345(u1290, 'Frame', {
                                        Name = 'Paragraph',
                                        Parent = _Sleeker,
                                        BackgroundTransparency = 1,
                                        Size = u1334(0, 435, 0, 30),
                                        AutomaticSize = C._AutomaticSize.Y,
                                    }, u1345(u1290, 'TextLabel', {
                                        Name = 'Title',
                                        BackgroundTransparency = 1,
                                        Position = u1334(0, 15, 0, 7.5),
                                        Size = u1334(0, 100, 0, 10),
                                        Font = _Gotham,
                                        Text = u1344(u1290, v1390.Title),
                                        TextSize = 15,
                                        TextColor3 = u1376,
                                        TextXAlignment = u1336.Left,
                                        RichText = true,
                                    }), u1345(u1290, 'TextLabel', {
                                        Name = 'Description',
                                        BackgroundTransparency = 1,
                                        Position = u1334(0, 15, 0, 30),
                                        Size = u1334(0, 400, 0, 10),
                                        Font = _Gotham,
                                        Text = u1344(u1290, v1390.Description) .. '\n',
                                        TextSize = 13,
                                        TextWrapped = true,
                                        TextColor3 = u1376,
                                        TextXAlignment = u1336.Left,
                                        TextYAlignment = C._TextYAlignment.Top,
                                        AutomaticSize = C._AutomaticSize.Y,
                                        RichText = true,
                                    }))
                                    local _Title = v1619.Title
                                    local _Description = v1619.Description
                                    local u1622 = {
                                        'Text',
                                        '\n',
                                    }

                                    if _Flag then
                                        v1331[_Flag] = function(p1623, p1624)
                                            local v1625 = u1622
                                            local v1626 = u1290
                                            local v1627 = u1344
                                            local v1628 = v1625[1]

                                            _Title[v1628] = v1627(v1626, p1623)
                                            _Description[v1628] = v1627(v1626, p1624) .. v1625[2]
                                        end
                                        v1391 = v1638
                                    else
                                        v1391 = v1638
                                    end
                                elseif _Type2 == 'TextBox' then
                                    local v1629 = u1345(u1290, 'Frame', {
                                        Name = _Text2,
                                        Parent = _Sleeker,
                                        BackgroundTransparency = 1,
                                        Size = u1334(0, 435, 0, 60),
                                    }, u1345(u1290, 'TextLabel', {
                                        Name = 'Title',
                                        BackgroundTransparency = 1,
                                        Position = u1334(0.15, 0, 0.165, 0),
                                        Size = u1334(0, 100, 0, 10),
                                        AnchorPoint = v1375,
                                        Font = _Gotham,
                                        Text = '',
                                        TextSize = 14,
                                        TextColor3 = u1376,
                                        TextXAlignment = u1336.Left,
                                        RichText = true,
                                    }), u1345(u1290, 'TextBox', {
                                        Name = 'Box',
                                        BackgroundTransparency = 0.75,
                                        BackgroundColor3 = u1335(15, 15, 15),
                                        Position = u1334(0.5, 0, 0.615, 0),
                                        Size = u1334(0, 405, 0, 30),
                                        AnchorPoint = v1375,
                                        ClipsDescendants = true,
                                        Font = _Gotham,
                                        PlaceholderText = u1344(u1290, 'Enter Text...'),
                                        PlaceholderColor3 = u1335(104, 104, 104),
                                        Text = v1390.Default,
                                        TextSize = 13,
                                        TextColor3 = u1376,
                                        TextXAlignment = u1336.Left,
                                    }, u1345(u1290, 'UICorner', v1377), u1345(u1290, 'UIStroke', v1379)))
                                    local u1630 = _RemoveRichText(u1290, _Text2)
                                    local _Box3 = v1629.Box
                                    local u1632 = 'BackgroundColor3'

                                    u1349(_Box3.Focused, function()
                                        u1351(u1290, _Box3, u915(1), {
                                            [u1632] = u1335(70, 70, 70),
                                        })
                                    end)

                                    local u1633 = {
                                        'Text',
                                        'BackgroundColor3',
                                    }

                                    u1349(_Box3.FocusLost, function()
                                        local v1634 = u1633
                                        local v1635 = u1290
                                        local v1636 = _Box3[v1634[1] ]

                                        u1351(v1635, _Box3, u915(1), {
                                            [v1634[2]] = u1335(15, 15, 15),
                                        })

                                        _TextBox[u1630] = u1356(v1636) or v1636

                                        _SaveConfigurations2(v1635)
                                        u1352(_Callback2, v1636)
                                    end)
                                    v1346(u1290, v1629.Title, u1344(u1290, _Text2))
                                    v1338(v1340, _Box3.UIStroke)

                                    local v1637 = _TextBox[u1630]

                                    if v1637 and _s(v1637) then
                                        _Box3.Text = v1355(v1637)
                                    else
                                        _TextBox[u1630] = Default
                                    end

                                    u1240.Spawn = {
                                        Callback = u1352,
                                        Args = {
                                            _Callback2,
                                            _Box3.Text,
                                        },
                                    }
                                    v1391 = v1638
                                else
                                    u1290:Error('invalid property type.')

                                    v1391 = v1638
                                end
                            else
                                u1290:Error('argument must be a table value when registering a property.')

                                v1391 = v1638
                            end

                            v1329[v1638] = ' * '

                            local v1638 = v1391
                        end
                    end
                end
            end

            local u1639 = {
                'getHUD',
                'getTheme',
                'getStrokes',
                'getFlags',
                'LoL?',
            }
            local _Sleeker2 = u1307.Sleeker
            local _Kick4 = u1290.Kick

            local function v1643(_, p1642)
                if p1642 == u1639[1] then
                    return _Sleeker2
                end
                if p1642 == u1639[2] then
                    return u1237
                end
                if p1642 == u1639[3] then
                    return u1235
                end
                if p1642 == u1639[4] then
                    return u1239
                end

                _Kick4(u1290, u1639[5])
            end

            local u1644 = {
                'registerProperty',
                'fireProperty',
                'Spawn',
                'Callback',
                'Args',
                "'",
                "' is not a valid flag property.",
                'invalid value type',
            }
            local _t14 = C.u77.t
            local _Error2 = u1290.Error

            return C.u16(u1327, {
                __tostring = function()
                    return u1328
                end,
                __index = v1643,
                __newindex = function(_, p1647, p1648)
                    local v1649 = u1644

                    if p1647 ~= v1649[1] then
                        if p1647 ~= v1649[2] then
                            _Error2(u1290, v1649[6] .. p1647 .. v1649[7])
                        elseif _t14(p1648) then
                            local v1650 = u1309[p1648[1] ]

                            if v1650 then
                                local v1651 = #p1648

                                if v1651 > 1 then
                                    local v1652 = u1298
                                    local v1653 = {}

                                    for v1654 = 2, v1651 do
                                        v1652(v1653, p1648[v1654])
                                    end

                                    u1240[v1649[3] ] = {
                                        [v1649[4]] = v1650,
                                        [v1649[5]] = v1653,
                                    }
                                else
                                    u1240[v1649[3] ] = v1650
                                end
                            else
                                _Error2(u1290, v1649[6] .. p1648[1] .. v1649[7])
                            end
                        else
                            _Error2(u1290, v1649[8])
                        end
                    else
                        u1298(u1326, p1648)
                    end
                end,
            })
        end

        v926.Frame = u1238
        v926.StarterFrame = v1232

        return v926
    end

    -- ============================================
    -- EXPORT
    -- ============================================

    C.UI = C.v1655()

    print("Overdrive H UI Loaded Successfully!")

    return C.UI
end)()

-- Return the UI object
return _G.OverdriveH