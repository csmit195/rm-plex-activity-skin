-- Convert milliseconds to mm:ss or hh:mm:ss
function FormatTime(ms)
    if not ms then return "00:00" end
    local totalSeconds = math.floor(tonumber(ms) / 1000)
    local hours = math.floor(totalSeconds / 3600)
    local mins = math.floor((totalSeconds % 3600) / 60)
    local secs = totalSeconds % 60
    
    if hours > 0 then
        return string.format("%d:%02d:%02d", hours, mins, secs)
    else
        return string.format("%02d:%02d", mins, secs)
    end
end

-- Truncate text
function Truncate(str, max)
    if not str then return "" end
    if string.len(str) > max then
        return string.sub(str, 1, max) .. "..."
    end
    return str
end

function UpdateFromLua()
    local rawData = SKIN:GetMeasure('MeasurePlexPy'):GetStringValue()
    
    -- Reset Errors
    SKIN:Bang('!HideMeter', 'MeterError')
    
    -- 1. Check for Empty Data (Possible Connection Failure logic fallback)
    if rawData == "" then 
        return 
    end

    -- 2. Check for API Error Response
    -- Pattern looks for "result": "error"
    if rawData:match('"result":%s*"error"') then
        local msg = rawData:match('"message":%s*"(.-)"') or "Invalid API Key"
        SKIN:Bang('!SetOption', 'MeterError', 'Text', msg)
        SKIN:Bang('!ShowMeter', 'MeterError')
        SKIN:Bang('!HideMeter', 'MeterNoOneWatching')
        
        -- Hide all rows
        for i = 1, 5 do SKIN:Bang('!HideMeterGroup', 'Row'..i) end
        SKIN:Bang('!HideMeter', 'MeterMoreStreams')
        
        -- Set height to min
        local minH = tonumber(SKIN:GetVariable('MinHeight')) or 80
        SKIN:Bang('!SetVariable', 'BgHeight', minH)
        SKIN:Bang('!UpdateMeter', '*')
        SKIN:Bang('!Redraw')
        return
    end

    -- Stream counts
    local streamCount = rawData:match('"stream_count":%s*"(%d+)"') or "0"
    local transcodeCount = rawData:match('"stream_count_transcode":%s(%d+)') or "0"
    
    local headerText = streamCount .. " Playing"
    if tonumber(transcodeCount) > 0 then
        headerText = headerText .. " (" .. transcodeCount .. " Transcoding)"
    end
    SKIN:Bang('!SetOption', 'MeterStreamCount', 'Text', headerText)

    -- 3. Parse and Filter Sessions
    local sessionsBlock = rawData:match('"sessions":%s*%[(.*)%]')
    local validSessions = {}

    if sessionsBlock then
        for sessionObject in sessionsBlock:gmatch('(%b{})') do
            local state = sessionObject:match('"state":%s*"(.-)"') or "playing"
            local progressPct = tonumber(sessionObject:match('"progress_percent":%s*"(.-)"')) or 0
            
            -- FIX: Skip if paused at 99% or higher (Android TV post-play bug)
            local isFinished = (state == "paused" and progressPct >= 99)
            
            if not isFinished then
                table.insert(validSessions, {
                    obj = sessionObject, 
                    state = state, 
                    progress = progressPct
                })
            end
        end
    end

    -- 4. Calculate Display Limitations
    local maxHeight = tonumber(SKIN:GetVariable('MaxHeight')) or 2000
    local currentHeight = 50 -- Header start Y
    local rowHeight = 65     -- Approx height of one user row
    local displayedCount = 0
    local totalValid = #validSessions
    
    -- Loop through valid sessions
    for i, sessionData in ipairs(validSessions) do
        -- Check if adding this row exceeds MaxHeight OR exceeds skin hard limit (5)
        local projectedHeight = currentHeight + rowHeight
        
        if projectedHeight > maxHeight or i > 5 then
            -- Stop rendering, the rest are overflow
            break
        end

        displayedCount = displayedCount + 1
        currentHeight = projectedHeight
        
        local sessionObject = sessionData.obj
        local state = sessionData.state
        local progressNum = sessionData.progress

        -- Parse Details
        local user = sessionObject:match('"friendly_name":%s*"(.-)"') or "User"
        local mediaType = sessionObject:match('"media_type":%s*"(.-)"') or "movie"
        local viewOffset = sessionObject:match('"view_offset":%s*"(.-)"')
        local duration = sessionObject:match('"duration":%s*"(.-)"')
        local videoDecision = sessionObject:match('"video_decision":%s*"(.-)"') or "direct play"
        local videoRes = sessionObject:match('"video_full_resolution":%s*"(.-)"') or 
                         sessionObject:match('"video_resolution":%s*"(.-)"') or "SD"
        local player = sessionObject:match('"player":%s*"(.-)"') or "Unknown Player"
        local ip = sessionObject:match('"ip_address":%s*"(.-)"') or "0.0.0.0"

        -- Title formatting
        local displayTitle = ""
        local toolTipTitle = ""
        local year = sessionObject:match('"year":%s*"(.-)"') or ""
        
        if mediaType == "episode" then
            local show = sessionObject:match('"grandparent_title":%s*"(.-)"') or ""
            local parentIndex = tonumber(sessionObject:match('"parent_media_index":%s*"(.-)"')) or 0
            local index = tonumber(sessionObject:match('"media_index":%s*"(.-)"')) or 0
            local epTitle = sessionObject:match('"title":%s*"(.-)"') or ""
            
            local sString = string.format("S%02d", parentIndex)
            local eString = string.format("E%02d", index)
            
            displayTitle = show .. " - " .. sString .. eString .. " - " .. epTitle
            toolTipTitle = show
        else
            local title = sessionObject:match('"title":%s*"(.-)"') or "Unknown"
            displayTitle = title .. " (" .. year .. ")"
            toolTipTitle = title .. " (" .. year .. ")"
        end
        
        local maxLen = tonumber(SKIN:GetVariable('MaxTitleLength')) or 40
        local truncatedTitle = Truncate(displayTitle, maxLen)

        -- Tooltip text
        local timeNow = FormatTime(viewOffset)
        local timeTotal = FormatTime(duration)
        
        local tipText = "Title: " .. displayTitle
        tipText = tipText .. "#CRLF#Time: " .. timeNow .. " / " .. timeTotal .. " (" .. progressNum .. "%)"
        tipText = tipText .. "#CRLF#Player: " .. player .. " (" .. ip .. ")"
        tipText = tipText .. "#CRLF#Quality: " .. videoRes .. " (" .. videoDecision .. ")"
        if state == "paused" then tipText = tipText .. "#CRLF#Status: PAUSED" end

        -- Update meters
        SKIN:Bang('!SetOption', 'User'..i..'Name', 'Text', user)
        SKIN:Bang('!SetOption', 'User'..i..'Details', 'Text', truncatedTitle)
        
        SKIN:Bang('!SetOption', 'User'..i..'Hitbox', 'ToolTipTitle', toolTipTitle)
        SKIN:Bang('!SetOption', 'User'..i..'Hitbox', 'ToolTipText', tipText)

        -- Clamp progress
        if progressNum < 0 then progressNum = 0 end
        if progressNum > 100 then progressNum = 100 end
        
        local barWidth = math.floor(290 * (progressNum / 100))
        SKIN:Bang('!SetOption', 'User'..i..'Bar', 'W', barWidth)

        local color = SKIN:GetVariable('ColorPlay')
        if videoDecision == "transcode" then color = SKIN:GetVariable('ColorTranscode') end
        if state == "paused" then color = SKIN:GetVariable('ColorPause') end
        
        SKIN:Bang('!SetOption', 'User'..i..'Bar', 'SolidColor', color)
        SKIN:Bang('!ShowMeterGroup', 'Row'..i)
    end

    -- Hide unused rows
    for i = displayedCount + 1, 5 do
        SKIN:Bang('!HideMeterGroup', 'Row'..i)
    end
    
    -- Handle "No one is watching" visibility
    SKIN:Bang('!' .. (displayedCount == 0 and 'Show' or 'Hide') .. 'Meter', 'MeterNoOneWatching')
    
    -- Handle Overflow text (... 2 more streams)
    local overflowCount = totalValid - displayedCount
    if overflowCount > 0 then
        SKIN:Bang('!SetOption', 'MeterMoreStreams', 'Text', '... ' .. overflowCount .. ' more streams')
        SKIN:Bang('!ShowMeter', 'MeterMoreStreams')
        currentHeight = currentHeight + 20 -- Add padding for the overflow text
    else
        SKIN:Bang('!HideMeter', 'MeterMoreStreams')
    end

    -- Calculate Final Background Height
    local minHeight = tonumber(SKIN:GetVariable('MinHeight')) or 80
    
    -- Add a little bottom padding if rows exist
    if displayedCount > 0 then
        currentHeight = currentHeight + 10
    end
    
    local finalHeight = currentHeight
    if finalHeight < minHeight then finalHeight = minHeight end
    
    SKIN:Bang('!SetVariable', 'BgHeight', finalHeight)
    SKIN:Bang('!UpdateMeter', '*')
    SKIN:Bang('!Redraw')
end