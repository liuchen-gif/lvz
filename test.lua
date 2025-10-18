local function clearAndSetRange()
    gg.clearResults()
    gg.setRanges(32)
end

local function searchRefineSet(searchPattern, refineValue, setList)
    gg.searchNumber(searchPattern, gg.TYPE_DWORD)
    gg.refineNumber(refineValue, gg.TYPE_DWORD)
    local results = gg.getResults(100)
    if #results == 0 then
        gg.alert("未找到目标地址")
        return false
    end
    for _, v in ipairs(setList) do
        gg.setValues({{address = results[1].address + v.offset, flags = gg.TYPE_DWORD, value = v.value}})
    end
    gg.clearResults()
    return true
end

local function clearAndSetRange(range)
    gg.clearResults()
    gg.setRanges(range or 32)
end

local function searchNumber(pattern, type)
    gg.searchNumber(pattern, type or gg.TYPE_DWORD)
end

local function refineNumber(value, type)
    gg.refineNumber(value, type or gg.TYPE_DWORD)
end

local function getResults(count)
    return gg.getResults(count or 100)
end

local function setValues(list)
    gg.setValues(list)
end

local function prompt(fields, defaults, types)
    return gg.prompt(fields, defaults, types)
end

local function alert(msg)
    gg.alert(msg)
end

local function toast(msg)
    gg.toast(msg)
end

local function Main0()
    local menu = {
        "一 修改奖杯游戏时间",
        "二 解锁森林商城",
        "三 抽原理图合泰坦",
        "四 通行证奖励",
        "五 昵称颜色258",
        "六 加速",
        "七 58赛季通行证会员",
        "八 公会商店",
        "九 公会商店7级石"
    }
    local SN = gg.choice(menu, nil, "我是一个默默无闻的公告")
    if SN then
        local funcMap = {
            [1] = HS1,
            [2] = HS2,
            [3] = HS3,
            [4] = HS4,
            [5] = HS5,
            [6] = HS6,
            [7] = HS7,
            [8] = HS8,
            [9] = HS9
        }
        funcMap[SN]()
    end
end

function HS1()
    clearAndSetRange()
    local input = gg.prompt({"输入目前奖杯数:"}, {"0"}, {"number"})
    if not input then gg.alert("已取消操作"); return end

    local searchValue = input[1] .. ";9;-1;9::30"
    gg.searchNumber(searchValue, gg.TYPE_DWORD)
    gg.refineNumber("-1", gg.TYPE_DWORD)
    local results = gg.getResults(100)
    if #results == 0 then gg.alert("未找到目标地址"); return end

    local target = results[1].address
    gg.setValues({
        {address = target - 8, flags = gg.TYPE_DWORD, value = 7852187},
        {address = target + 8, flags = gg.TYPE_DWORD, value = 3777777}
    })
    gg.alert("完成！")
    gg.clearResults()
end

function HS2()
    clearAndSetRange()
    local function searchAndSet(pattern, value)
        searchNumber(pattern)
        local res = getResults()
        for _, v in ipairs(res) do
            setValues({{address = v.address, value = value, flags = gg.TYPE_DWORD}})
        end
        gg.clearResults()
    end
    searchAndSet("1000000;9000", 0)
    searchAndSet("800;1000::17", 0)
end

function HS3()
    clearAndSetRange()
    searchNumber("500;0;2000;0;2000;0::100")
    local res = getResults()
    for _, v in ipairs(res) do
        if v.value == 500 then
            setValues({{address = v.address, value = -200000, flags = gg.TYPE_DWORD}})
        elseif v.value == 2000 then
            setValues({{address = v.address, value = -200000, flags = gg.TYPE_DWORD}})
        end
    end
    gg.clearResults()
end

function HS4()
    clearAndSetRange()
    local input = prompt({"输入已领取通行证多少级："}, {"0"}, {"number"})
    if not input then alert("已取消操作"); return end
    local n = tonumber(input[1])
    local target = n + 1

    searchNumber("100;" .. target .. ";1000::13")
    local res = getResults()
    for _, v in ipairs(res) do
        if v.value == target then
            setValues({{address = v.address, value = 0, flags = gg.TYPE_DWORD}})
        end
    end
    gg.clearResults()

    local choice = gg.choice({"金币", "钻石", "英雄"}, nil, "请选择修改类型")
    if not choice then alert("已取消操作"); return end

    local value
    if choice == 1 or choice == 2 then
        local input2 = prompt({"请输入数量:"}, {"0"}, {"number"})
        if not input2 then alert("已取消操作"); return end
        value = tonumber(input2[1])
    end

    searchNumber("6;500;5;400;4;300;3;200;2;100::")
    refineNumber("6;5;4;3;2::")
    local results = getResults()
    for _, v in ipairs(results) do
        local offset = v.address
        setValues({
            {address = offset, value = v.value - 1, flags = gg.TYPE_DWORD},
            {address = offset + 4, value = 0, flags = gg.TYPE_DWORD},
            {address = offset + 8, value = (choice == 1 and 0) or (choice == 2 and 1) or 21, flags = gg.TYPE_DWORD},
            {address = offset + 12, value = (choice == 3 and 1) or value, flags = gg.TYPE_DWORD}
        })
    end
    gg.clearResults()
end

function HS5()
    clearAndSetRange()
    searchNumber("7;-1;7;0;7;3:25")
    refineNumber("3")
    local results = getResults()
    local function generateAddresses(base)
        local offsets = {0,4,64,68,128,132,192,196,256,260,320,324,384,388,448,452,512,516,576,580,640,644,704,708,768,772,832,836,896,900,960,964,1024,1028,1088,1092,1152,1156,1216,1220,1280,1284,1344,1348,1408,1412,1472,1476,1536,1540,1600,1604,1664,1668,1728,1732,1792,1796,1856,1860,1920,1924,1984,1988,2048,2052,2112,2116,2176,2180,2240,2244,2304,2308,2368,2372,2432,2436,2496,2500,2560,2564,2624,2628,2688,2692,2752,2756,2816,2820,2880,2884,2944,2948,3008,3012,3072,3076,3136,3140,3200,3204,3264,3268,3328,3332,3392,3396,3456,3460,3520,3524,3584,3588,3648,3652,3712,3716,3776,3780,3840,3844,3904,3908,3968,3972,4032,4036,4096,4100,4160,4164,4224,4228,4288,4292,4352,4356,4416,4420,4480,4484,4544,4548,4608,4612,4672,4676,4736,4740,4800,4804,4864,4868,4928,4932,4992,4996,5056,5060,5120,5124,5184,5188,5248,5252,5312,5316,5376,5380,5440,5444,5504,5508,5568,5572,5632,5636,5696,5700,5760,5764,5824,5828,5888,5892,5952,5956,6016,6020,6080,6084,6144,6148,6208,6212,6272,6276,6336,6340,6400,6404,6464,6468,6528,6532,6592,6596,6656,6660,6720,6724,6784,6788,6848,6852,6912,6916,6976,6980,7040,7044,7104,7108,7168,7172,7232,7236,7296,7300,7360,7364,7424,7428,7488,7492,7552,7556,7616,7620,7680,7684,7744,7748,7808,7812,7872,7876,7936,7940,8000,8004,8064,8068,8128,8132,8192,8196,8256,8260,8320,8324,8384,8388,8448,8452,8512,8516,8576,8580,8640,8644,8704,8708,8768,8772,8832,8836,8896,8900,8960,8964,9024,9028,9088,9092,9152,9156,9216,9220,9280,9284,9344,9348,9408,9412,9472,9476,9536,9540,9600,9604,9664,9668,9728,9732,9792,9796,9856,9860,9920,9924,9984,9988,10048,10052,10112,10116,10176,10180,10240,10244,10304,10308,10368,10372,10432,10436,10496,10500,10560,10564,10624,10628,10688,10692,10752,10756,10816,10820,10880,10884,10944,10948,11008,11012,11072,11076,11136,11140,11200,11204,11264,11268,11328,11332,11392,11396,11456,11460,11520,11524,11584,11588,11648,11652,11712,11716,11776,11780,11840,11844,11904,11908,11968,11972,12032,12036,12096,12100,12160,12164,12224,12228,12288,12292,12352,12356,12416,12420,12480,12484,12544,12548,12608,12612,12672,12676,12736,12740,12800,12804,12864,12868,12928,12932,12992,12996,13056,13060,13120,13124,13184,13188,13248,13252,13312,13316,13376,13380,13440,13444,13504,13508,13568,13572,13632,13636,13696,13700,13760,13764,13824,13828,13888,13892,13952,13956,14016,14020,14080,14084,14144,14148,14208,14212,14272,14276,14336,14340,14400,14404,14464,14468,14528,14532,14592,14596,14656,14660,14720,14724,14784,14788,14848,14852,14912,14916,14976,14980,15040,15044,15104,15108,15168,15172,15232,15236,15296,15300,15360,15364,15424,15428,15488,15492,15552,15556,15616,15620,15680,15684,15744,15748,15808,15812,15872,15876,15936,15940,16000,16004,16064,16068,16128,16132,16192,16196,16256,16260,16320,16324,16384,16388,16448,16452,16512,16516}
        local t = {}
        for _, o in ipairs(offsets) do
            table.insert(t, {address = base + o, value = 1, flags = gg.TYPE_DWORD})
        end
        return t
    end

    local all = {}
    for _, r in ipairs(results) do
        local t = generateAddresses(r.address)
        for _, addr in ipairs(t) do table.insert(all, addr) end
    end
    setValues(all)
    gg.clearResults()
end

function HS6()
    clearAndSetRange()
    local input = prompt({"输入加速倍数:"}, {"0"}, {"number"})
    if not input then alert("已取消操作"); return end

    searchNumber("0.33333334327;0.03::5", gg.TYPE_FLOAT)
    if gg.getResultsCount() == 0 then alert("未找到匹配数据"); return end
    refineNumber("0.03", gg.TYPE_FLOAT)
    local results = getResults(1)
    if #results == 0 then alert("精确定位失败"); return end

    local target = results[1].address - 8
    setValues({{address = target, value = tonumber(input[1]), flags = gg.TYPE_FLOAT}})
    toast("修改成功！地址: 0x" .. string.format("%X", target) .. " → " .. input[1])
    gg.clearResults()
end

function HS7()
    clearAndSetRange()
    searchNumber("58;0;-1;0::21")
    refineNumber("-1")
    local results = getResults()
    for _, v in ipairs(results) do
        setValues({{address = v.address + 4, value = 1, flags = gg.TYPE_DWORD}})
    end
    gg.clearResults()
end

function HS8()
    clearAndSetRange(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
    local input = prompt({"请输入 物品代码：", "请输入 数量："}, {nil, nil}, {"number", "number"})
    if not input then toast("已取消，脚本结束"); os.exit() end
    local itemId, qty = input[1], input[2]

    searchNumber("14;100;2;15;5;400;2;25::121")
    refineNumber("25")
    local res = getResults(500)
    if #res == 0 then toast("重启游戏重试！"); os.exit() end

    toast("找到 " .. #res .. " 个结果，开始修改...")
    local write = {}
    for _, r in ipairs(res) do
        local base = r.address
        table.insert(write, {address = base + 40, value = itemId, flags = gg.TYPE_DWORD})
        table.insert(write, {address = base + 44, value = qty, flags = gg.TYPE_DWORD})
        table.insert(write, {address = base + 60, value = 9999, flags = gg.TYPE_DWORD})
        table.insert(write, {address = base + 80, value = 1, flags = gg.TYPE_DWORD})
    end
    setValues(write)
    toast("修改完成！物品ID：" .. itemId .. " 数量：" .. qty)
    gg.clearResults()
end

function HS9()
    clearAndSetRange()
    searchNumber("49;1;7777777;2;3000::41")
    refineNumber("49")
    local r1 = getResults(1)
    if not r1 or not r1[1] then toast("第一次搜索失败！退出游戏重试"); return end
    local base1 = r1[1].address
    local t = gg.getValues({
        {address = base1 - 8, flags = gg.TYPE_DWORD},
        {address = base1 + 8, flags = gg.TYPE_DWORD}
    })
    local vSub8 = t[1] and t[1].value or 0
    local vAdd8 = t[2] and t[2].value or 0

    gg.clearResults()
    searchNumber("14;100;2;15;5;400;2;25::121")
    refineNumber("25")
    local r2 = getResults(1)
    if not r2 or not r2[1] then toast("第二次搜索失败！退出游戏重试"); return end
    local base2 = r2[1].address

    setValues({
        {address = base2 + 32, value = vSub8, flags = gg.TYPE_DWORD},
        {address = base2 + 40, value = 49, flags = gg.TYPE_DWORD},
        {address = base2 + 44, value = 200, flags = gg.TYPE_DWORD},
        {address = base2 + 48, value = vAdd8, flags = gg.TYPE_DWORD},
        {address = base2 + 60, value = 9999, flags = gg.TYPE_DWORD},
        {address = base2 + 80, value = 1, flags = gg.TYPE_DWORD}
    })
    toast("全部完成！")
    gg.clearResults()
end

Main0()