ComiketBrowser.controllers :checklist do

  get '/checklists' do
    content_type :json
    Checklist.all.to_json(root: nil, :only => [:circle_id, :color_id, :memo])
  end

  put '/checklists/:id/:color_id' do
    content_type :json
    if Checklist.exists?(:circle_id => params[:id])
      checklist = Checklist.find_by_circle_id(params[:id])
      checklist.update_attributes(color_id: params[:color_id])
    else
      checklist = Checklist.create(circle_id: params[:id], color_id: params[:color_id], comiket_no: COMIKET_NUMBER)
    end
    checklist.to_json
  end

  delete '/checklists/:id' do
    content_type :json
    checklist = Checklist.find_by_circle_id(params[:id])
    checklist.destroy if checklist
    checklist.to_json
  end
end
