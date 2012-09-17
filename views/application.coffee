rows = 1


prev_circles = current_circles = next_circles = null
prev_cond = current_cond = next_cond = null
prev_info = current_info = next_info = null

cursor = 0

update_circle_view = ->
    $("#page_info").html $("<h1>").html("Day#{current_info.day}: #{current_info.block}")
    if current_circles
        for circle, i in current_circles
            update_cell(i, circle)

fetch_circles_as_next = (cond = {}) ->
    fetch_circles cond, (data) ->
        next_circles = data.circles
        next_cond = data.cond
        next_info = data.info

fetch_circles_as_prev = (cond = {}) ->
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
        update_circle_view()
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
        update_circle_view()
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
        update_circle_view()
        reset_cursor

move_cursor = (dir) ->
    console.log dir

reset_cursor = ->
    cursor = 0

image = (id) ->
    $("<img>").attr("src", "/images/circle_cuts/#{id}.png")

update = (data) ->
    selected = null
    update_page_info data.info
    for circle, i in data.circles
        update_cell(i, circle)

update_cell = (num, circle) ->
    img = image circle.id
    a = $("<a>").attr("href", "#").html img
    box = $("<div>").append(a).append("#{circle.block.name} #{circle.space_no} #{circle.author}")
    $("#box_#{num}").html(box)
    a.click ->
        view(circle)
    box.css("background-color", "#{colors[circle.checklist.color_id]}") if circle.checklist

coloring_circle_info = (color) ->
    $("#circle_info").css('border-color', "#{color}")

checker_event = (e) ->
    if selected
        key = e.which
        if 49 <= key && key <= 57 # number
            color_id = key - 48
            coloring_circle_info colors[color_id]
            console.log color_id
            $.ajax "/checklists/#{selected}/#{color_id}",
                type: 'PUT',
                success: (data) ->
        else if key == 27 || key == 8 || key == 48 # del , escape, 0
            coloring_circle_info ''
            $.ajax "/checklists/#{selected}",
                type: 'DELETE',
                success: (data) ->
selected = null

bind_keys = (cond) ->
    $("body").keydown (e) ->
        c = String.fromCharCode e.which
        switch c
            when "N"
                move_next()
            when "P"
                move_prev()
            when "J"
                move_cursor "down"
            when "K"
                move_cursor "up"
            when "H"
                move_cursor "left"
            when "L"
                move_cursor "right"
    $("body").keydown checker_event

view = (circle) ->
    selected = circle.id
    $("body").unbind('keydown', 'checker_event')
    $("#circle_name").html circle.name
    if circle.checklist
        coloring_circle_info colors[circle.checklist.color_id]
    else
        coloring_circle_info ''
    $("#circle_description").html circle.description
    $("#circle_cut").html image(circle.id)
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
