class ItemBestDay
  attr_reader :best_day, :id

  def initialize(id)
    @best_day = Item.best_day(id)
  end
end
