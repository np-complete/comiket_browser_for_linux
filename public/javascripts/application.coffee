columns = 4

prev_circles = current_circles = next_circles = null
prev_cond = current_cond = next_cond = null
prev_info = current_info = next_info = null

cursor = 0

update_circles_view = ->
    $("#page_info").html $("<h1>").html("Day#{current_info.day}: #{current_info.block}")
    if current_circles
        $("#circles").html("")
        for circle, i in current_circles
            $("#circles").append generate_cell(i, circle)
        reset_cursor()

fetch_circles_as_next = (cond = null) ->
    if cond
        fetch_circles cond, (data) ->
            next_circles = data.circles
            next_cond = data.cond
            next_info = data.info

fetch_circles_as_prev = (cond = null) ->
    if cond
        fetch_circles cond, (data) ->
            prev_circles = data.circles
            prev_cond = data.cond
            prev_info = data.info

fetch_circles_as_current = (cond = {}, func = null) ->
    fetch_circles cond, (data) ->
        current_circles = data.circles
        current_info = data.info
        current_cond = data.cond
        func(data) if func

view_circles = (cond = {}) ->
    fetch_circles_as_current cond, (data) ->
        update_circles_view()
        fetch_circles_as_prev current_cond.prev
        fetch_circles_as_next current_cond.next

fetch_circles = (cond = {}, func) ->
    $.ajax '/circles',
        type: 'GET',
        data: cond,
        success: (data) ->
            func(data)

move_next = ->
    if next_circles
        prev_circles = current_circles
        current_circles = next_circles
        fetch_circles_as_next next_cond.next
        next_circles = null
        prev_info = current_info
        prev_cond = current_cond
        current_info = next_info
        current_cond = next_cond
        update_circles_view()
        reset_cursor

move_prev = ->
    if prev_circles
        next_circles = current_circles
        current_circles = prev_circles
        fetch_circles_as_prev prev_cond.prev
        prev_circles = null
        next_info = current_info
        next_cond = current_cond
        current_info = prev_info
        current_cond = prev_cond
        update_circles_view()
        reset_cursor

move_cursor = (dir) ->
    switch dir
        when "up"
            if cursor >= columns
                select_cursor(cursor - columns)
            else
                move_prev()
        when "down"
            if cursor + columns < current_circles.length
                select_cursor(cursor + columns)
            else
                move_next()
        when "left"
            if cursor > 0
                select_cursor(cursor - 1)
            else
                move_prev()
        when "right"
            if cursor + 1 < current_circles.length
                select_cursor(cursor + 1)
            else
                move_next()

reset_cursor = ->
    select_cursor 0

select_cursor = (num) ->
    cursor = num
    $(".circle-box").removeClass "selected-circle"
    $("#circle_index_#{num} .circle-box").addClass "selected-circle"
    view current_circles[cursor]

circle_cut_tag = (circle) ->
    $("<img>").attr("src", "/images/circle_cuts/c#{circle.comiket_no}/#{circle.circle_id}.png")

generate_cell = (num, circle) ->
    container = $("<div>").attr("class", "span2").attr("id", "circle_index_#{num}")
    info = $("<div>").attr("class", "circle-info").html("#{circle.block.name} #{circle.space_no} #{circle.author}")
    a = $("<a>").attr("href", "#").append circle_cut_tag(circle)
    box = $("<div>").attr("class", "circle-box").append(a).append(info)
    container.html(box)
    a.click ->
        select_cursor(num)
    box.css("background-color", "#{colors[circle.checklist.color_id]}") if circle.checklist
    container

coloring_circle_info = (color) ->
    $("#circle_info").css('border-color', "#{color}")

checker_event = (e) ->
    circle = current_circles[cursor]
    key = e.which
    if 49 <= key && key <= 57 # number
        color_id = key - 48
        coloring_circle_info colors[color_id]
        $.ajax "/checklists/#{circle.id}/#{color_id}",
            type: 'PUT',
            success: (data) ->
    else if key == 27 || key == 8 || key == 48 # del , escape, 0
        coloring_circle_info ''
        $.ajax "/checklists/#{circle.id}",
            type: 'DELETE',
            success: (data) ->

bind_keys = (cond) ->
    $("body").keydown (e) ->
        key_code = e.which
        key_code = String.fromCharCode e.which unless key_code >= 37 && key_code <= 40
        switch key_code
            when "N"
                move_next()
            when "P"
                move_prev()
            when "J", "S", 40
                move_cursor "down"
            when "K", "W", 38
                move_cursor "up"
            when "H", "A", 37
                move_cursor "left"
            when "L", "D", 39
                move_cursor "right"
    $("body").keydown checker_event

view = (circle) ->
    $("body").unbind('keydown', 'checker_event')
    $("#circle_name").html circle.name
    if circle.checklist
        coloring_circle_info colors[circle.checklist.color_id]
    else
        coloring_circle_info ''
    $("#circle_description").html circle.description
    $("#circle_cut").html circle_cut_tag(circle)
    $("#circle_author").html circle.author
    $("#circle_space").html "Day #{circle.day}: #{circle.block.name}#{circle.space_no}"

generate_links = ->
    $.ajax '/areas',
        success: (data) ->
            build = (day, area, block_id) ->
                a = $("<a>").attr("href", "#")
                a.html(area)
                a.click ->
                    view_circles {day: day, page: 0, block_id: block_id}
                $("#links").append(a).append(" ")
            for day in [1,2,3]
                $("#links").append("Day #{day}: ")
                for area, block of data
                    build day, area, block
    $.ajax '/blocks',
        success: (blocks) ->
            select = $("#select_block")
            for block in blocks
               select.append $("<option>").attr("value", block[0]).html(block[1])
    $("form#selects").change ->
        view_circles {day: $("#select_day").val(), block_id: $("#select_block").val()}

colors = {}
load_colors = ->
     $.ajax '/colors',
        success: (res) ->
            for color_id, color of res
                colors[color_id] = color.color
                $("#colors").append $("<div>").css("border", "4px solid #{color.color}").html("#{color_id} #{color.title}")

init = ->
    cond = {day: 1, page: 0}
    load_colors()
    generate_links()
    view_circles cond
    bind_keys()
$(document).ready ->
    init()
