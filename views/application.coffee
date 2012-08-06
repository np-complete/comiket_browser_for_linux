view_circles = (cond = {}) ->
    $.ajax '/circles',
        type: 'GET',
        data: cond,
        success: (data) ->
            update(data)

image = (id) ->
    $("<img>").attr("src", "/images/circle_cuts/#{id}.png")

update = (data) ->
    update_page_info data['info']
    for circle, i in data['circles']
        update_cell(i, circle)
    reset_bind data['cond']

update_page_info = (info) ->
    $("#page_info").html $("<h1>").html("Day#{info['day']}: #{info['block']}")

update_cell = (num, circle) ->
        img = image circle['id']
        a = $("<a>").attr("href", "#").html img
        $("#box_#{num}").html a
        a.click ->
            view(circle)

reset_bind = (cond) ->
    $("body").unbind('keydown')
    $("body").keydown (e) ->
        c = String.fromCharCode e.which
        switch c
            when "N"
                view_circles cond['next']
            when "P"
                view_circles cond['prev']

view = (circle) ->
    $("#circle_name").html circle['name']
    $("#circle_description").html circle['description']
    $("#circle_cut").html image(circle['id'])

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
                $("#links").append("Day#{day}: ")
                for area, block of data
                    build day, area, block
    $.ajax '/blocks',
        success: (blocks) ->
            select = $("#select_block")
            for block in blocks
               select.append $("<option>").attr("value", block[0]).html(block[1])
    $("form#selects").change ->
        view_circles {day: $("#select_day").val(), block_id: $("#select_block").val()}
init = ->
    cond = {day: 1, page: 0}
    generate_links()
    view_circles(cond)
$(document).ready ->
    init()
