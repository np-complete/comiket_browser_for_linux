ComiketBrowser.controllers :circles do

  get :index, :map => '/circles' do
    content_type :json
    nums = 16
    page = (params[:page] || 0).to_i
    day = (params[:day] || 1).to_i
    block_id = params[:block_id].try(:to_i)

    offset = nums * page
    circles = Circle.includes([:block, :checklist]).order('block_id, space_no').where(comiket_no: Comiket::No, day: day)

    circles = circles.where(block_id: block_id) if block_id
    total_count = circles.count
    circles = circles.limit(nums).offset(offset)

    cond = {
      :next => (total_count <= offset + nums ?
        {page: 0, day: day, block_id: block_id.try(:+, 1)} : {page: page + 1, day: day, block_id: block_id}).reject{|k, v| v.nil?},
      :prev => (page == 0 ?
        {page: 0, day: day, block_id: block_id.try(:-, 1)} : {page: page - 1, day: day, block_id: block_id}).reject{|k, v| v.nil?}
    }

    info = { block: Block.find(circles.first.block_id).name, day: day }
    {info: info, cond: cond, circles: circles}.to_json(:include => [:checklist, :block])
  end

end
