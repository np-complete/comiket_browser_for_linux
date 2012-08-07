view_circles = (cond = {}) ->
    $.ajax '/circles',
        type: 'GET',
        data: cond,
        success: (data) ->
            update(data)

image = (id) ->
    $("<img>").attr("src", "/images/circle_cuts/#{id}.png")

update = (data) ->
    selected = null
    update_page_info data.info
    for circle, i in data.circles
        update_cell(i, circle)
    reset_bind data.cond

update_page_info = (info) ->
    $("#page_info").html $("<h1>").html("Day#{info.day}: #{info.block}")

update_cell = (num, circle) ->
    img = image circle.id
    a = $("<a>").attr("href", "#").html img
    box = $("<div>").append(a).append("#{circle.block.name} #{circle.space_no} #{circle.author}")
    $("#box_#{num}").html(box)
    a.click ->
        view(circle)
    box.css("background-color", "##{colors[circle.checklist.color_id]}") if circle.checklist

checker_event = (e) ->
    if selected
        key = e.which
        if 49 <= key && key <= 57 # number
            color_id = key - 48
            $.ajax "/checklists/#{selected}/#{color_id}",
                type: 'PUT',
                success: (data) ->
                    $("#circle_name").css('background-color', "##{colors[color_id]}")
        else if key == 27 || key == 8 || key == 48 # del , escape, 0
            $.ajax "/checklists/#{selected}",
                type: 'DELETE',
                success: (data) ->
                    $("#circle_name").css('background-color', '#ffffff')
selected = null

reset_bind = (cond) ->
    $("body").unbind('keydown')
    $("body").keydown (e) ->
        c = String.fromCharCode e.which
        switch c
            when "N"
                view_circles cond.next
            when "P"
                view_circles cond.prev
    $("body").keydown checker_event

view = (circle) ->
    selected = circle.id
    $("body").unbind('keydown', 'checker_event')
    $("#circle_name").html circle.name
    color = if circle.checklist
        colors[circle.checklist.color_id]
    else
        "ffffff"
    $("#circle_name").css("background-color", "##{color}")
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
                $("#colors").append $("<div>").css("border", "4px solid ##{color.color}").html("#{color_id} #{color.title}")

init = ->
    cond = {day: 1, page: 0}
    load_colors()
    generate_links()
    view_circles(cond)
$(document).ready ->
    init()
