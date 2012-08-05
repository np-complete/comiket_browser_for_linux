view_circles = (day, page, conditions = {}) ->
    conditions['day'] = day
    conditions['page'] = page
    $.ajax '/circles',
        type: 'GET',
        data: conditions,
        success: (data) ->
            update(data)

update = (data) ->
    for circle, i in data['circles']
        $("#box_#{i}").html("<img src='/images/circle_cuts/#{circle['id']}.png' />")

init = ->
    view_circles(1, 1)
$(document).ready ->
    init()
