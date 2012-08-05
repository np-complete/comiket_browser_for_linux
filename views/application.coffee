view_circles = (cond = {}) ->
    $.ajax '/circles',
        type: 'GET',
        data: cond,
        success: (data) ->
            update(data)

image = (id) ->
    $("<img>").attr("src", "/images/circle_cuts/#{id}.png")

update = (data) ->
    for circle, i in data['circles']
        update_cell(i, circle)
    reset_bind data['cond']

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
                cond['page'] += 1
                view_circles cond
            when "P"
                cond['page'] -= 1
                view_circles cond

view = (circle) ->
    $("#circle_name").html circle['name']
    $("#circle_description").html circle['description']
    $("#circle_cut").html image(circle['id'])

init = ->
    cond = {day: 1, page: 0}
    view_circles(cond)
$(document).ready ->
    init()
