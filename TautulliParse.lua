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
    if rawData == "" then return end

    -- Stream counts
    local streamCount = rawData:match('"stream_count":%s*"(%d+)"') or "0"
    local transcodeCount = rawData:match('"stream_count_transcode":%s(%d+)') or "0"
    
    local headerText = streamCount .. " Playing"
    if tonumber(transcodeCount) > 0 then
        headerText = headerText .. " (" .. transcodeCount .. " Transcoding)"
    end
    SKIN:Bang('!SetOption', 'MeterStreamCount', 'Text', headerText)

    -- Sessions list
    local sessionsBlock = rawData:match('"sessions":%s*%[(.*)%]')
    local count = 0

    if sessionsBlock then
        -- Loop sessions
        for sessionObject in sessionsBlock:gmatch('(%b{})') do
            count = count + 1
            if count > 5 then break end

            -- Session details
            local user = sessionObject:match('"friendly_name":%s*"(.-)"') or "User"
            local state = sessionObject:match('"state":%s*"(.-)"') or "playing"
            local progressPct = sessionObject:match('"progress_percent":%s*"(.-)"') or "0"
            local mediaType = sessionObject:match('"media_type":%s*"(.-)"') or "movie"
            
            -- Time values
            local viewOffset = sessionObject:match('"view_offset":%s*"(.-)"')
            local duration = sessionObject:match('"duration":%s*"(.-)"')
            
            -- Video details
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
            tipText = tipText .. "#CRLF#Time: " .. timeNow .. " / " .. timeTotal .. " (" .. progressPct .. "%)"
            tipText = tipText .. "#CRLF#Player: " .. player .. " (" .. ip .. ")"
            tipText = tipText .. "#CRLF#Quality: " .. videoRes .. " (" .. videoDecision .. ")"
            if state == "paused" then tipText = tipText .. "#CRLF#Status: PAUSED" end

            -- Update meters
            SKIN:Bang('!SetOption', 'User'..count..'Name', 'Text', user)
            SKIN:Bang('!SetOption', 'User'..count..'Details', 'Text', truncatedTitle)
            
            SKIN:Bang('!SetOption', 'User'..count..'Hitbox', 'ToolTipTitle', toolTipTitle)
            SKIN:Bang('!SetOption', 'User'..count..'Hitbox', 'ToolTipText', tipText)

            local progressNum = tonumber(progressPct) or 0
            -- Clamp progress to avoid overshooting the bar on bad/early values
            if progressNum < 0 then progressNum = 0 end
            if progressNum > 100 then progressNum = 100 end
            
            local barWidth = math.floor(290 * (progressNum / 100))
            SKIN:Bang('!SetOption', 'User'..count..'Bar', 'W', barWidth)

            local color = SKIN:GetVariable('ColorPlay')
            if videoDecision == "transcode" then color = SKIN:GetVariable('ColorTranscode') end
            if state == "paused" then color = SKIN:GetVariable('ColorPause') end
            
            SKIN:Bang('!SetOption', 'User'..count..'Bar', 'SolidColor', color)
            SKIN:Bang('!ShowMeterGroup', 'Row'..count)
        end
    end

    for i = count + 1, 5 do
        SKIN:Bang('!HideMeterGroup', 'Row'..i)
    end
    
    SKIN:Bang('!' .. (count == 0 and 'Show' or 'Hide') .. 'Meter', 'MeterNoOneWatching')
    
    -- Background size
    local bgHeight = 50
    
    if count == 0 then
        bgHeight = 80
    elseif count == 1 then
        bgHeight = 120
    elseif count > 1 then
        bgHeight = 38 + (count * 65)
    end
    
    SKIN:Bang('!SetVariable', 'BgHeight', bgHeight)
    SKIN:Bang('!UpdateMeter', '*')
    SKIN:Bang('!Redraw')
end