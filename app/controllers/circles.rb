ComiketBrowser.controllers :circles do

  get :index, :map => '/circles' do
    content_type :json
    nums = 16
    page = (params[:page] || 0).to_i
    day = (params[:day] || 1).to_i
    block_id = params[:block_id].try(:to_i)

    block = block_id ? Block.find(block_id) : nil

    return 400 if page < 0 || day < 1

    offset = nums * page
    circles = Circle.includes([:block, :checklist]).order('block_id, space_no').where(comiket_no: Comiket::No, day: day)
    circles = circles.where(block_id: block_id) if block_id
    total_count = circles.count
    circles = circles.limit(nums).offset(offset)

    prev_cond = if page == 0
                  block ?  {page: 0, day: day, block_id: block.prev_block_id(day)} : nil
                else
                  {page: page - 1, day: day, block_id: block_id}.reject{ |k,v| v.nil? }
                end

    next_cond = if total_count <= offset + nums
                  block ? {page: 0, day: day, block_id: block.next_block_id(day)} : nil
                else
                  {page: page + 1, day: day, block_id: block_id}.reject{ |k,v| v.nil? }
                end

    cond = {:next => next_cond, :prev => prev_cond}

    info = { block: Block.find(circles.first.block_id).name, day: day }
    {info: info, cond: cond, circles: circles}.to_json(:include => [:checklist, :block])
  end

end
