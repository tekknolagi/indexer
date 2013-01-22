class Brightswipe::Magnet < Brightswipe
  get '/:id' do
    if params[:id]
      t = Torrent.by_id params[:id]
      unless t[:downloads]
        t[:downloads] = 1
      else
        t[:downloads] += 1
      end
      t.save!
      redirect t[:magnet]
    else
      @error = "No id parameter passed."
      erb :error
    end
  end
end
