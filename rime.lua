function date_translator(input, seg)
    if (input == "date") then
        --- Candidate(type, start, end, text, comment)
        local dateTab = {'一', '二', '三', '四', '五', '六', '七', '八', '九', '十', '十一', '十二',
                         '十三', '十四', '十五', '十六', '十七', '十八', '十九', '二十', '二十一',
                         '二十二', '二十三', '二十四', '二十五', '二十六', '二十七', '二十八',
                         '二十九', '三十', '三十一'}
        local yearTab = {
            [0] = '〇',
            '一',
            '二',
            '三',
            '四',
            '五',
            '六',
            '七',
            '八',
            '九'
        }
        local year_tbl = ""
        for i = 1, 4 do
            year_tbl = year_tbl .. yearTab[tonumber(string.sub(os.date("%Y"), i, i))]
        end
        yield(Candidate("date", seg.start, seg._end, os.date("%Y.%m.%d"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), ""))
        yield(Candidate("date", seg.start, seg._end, year_tbl .. "年" .. dateTab[tonumber(os.date("%m"))] .. "月" ..
            dateTab[tonumber(os.date("%d"))] .. "日", ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%m-%d"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), ""))
    end
    if (input == "week") then
        local weakTab = {'日', '一', '二', '三', '四', '五', '六'}
        yield(Candidate("week", seg.start, seg._end, "周" .. weakTab[tonumber(os.date("%w") + 1)], ""))
        yield(Candidate("week", seg.start, seg._end, "星期" .. weakTab[tonumber(os.date("%w") + 1)], ""))
        yield(Candidate("week", seg.start, seg._end, "礼拜" .. weakTab[tonumber(os.date("%w") + 1)], ""))
    end
    if (input == "time") then
        yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%H:%M:%S"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%H:%M"), ""))
    end
    if (input == "ydt") then
        yield(Candidate("date", seg.start, seg._end, os.date("%Y.%m%d.%H%M"), ""))
    end
end

--- 过滤器：单字在先
function single_char_first_filter(input)
    local l = {}
    for cand in input:iter() do
        if (utf8.len(cand.text) == 1) then
            yield(cand)
        else
            table.insert(l, cand)
        end
    end
    for cand in ipairs(l) do
        yield(cand)
    end
end
