ComiketBrowser.controllers :checklists do

  get :index, :map => '/checklists' do
    content_type :json
    Checklist.all.to_json(root: nil, :only => [:circle_id, :color_id, :memo])
  end

  put :update, :map => '/checklists/:id/:color_id' do
    content_type :json
    checklist = Checklist.where(:circle_id => params[:id], :comiket_no => Comiket::No).first
    if checklist
      checklist.update_attributes(color_id: params[:color_id])
    else
      checklist = Checklist.create(circle_id: params[:id], color_id: params[:color_id], comiket_no: Comiket::No)
    end
    checklist.to_json
  end

  delete :destroy, :map => '/checklists/:id' do
    content_type :json
    checklist = Checklist.where(:circle_id => params[:id], :comiket_no => Comiket::No).first
    checklist.destroy if checklist
    checklist.to_json
  end
end
