class SortableController < ApplicationController
  #
  # post /sortable/reorder, :klass => ["1", "3", "2"]
  #
  def reorder
    klass, ids = parse_params
    attr = klass.sort_attribute
    models = klass.order(attr => :asc).to_a
    ids.each_with_index do |id, new_sort|
      model = models.find {|m| m.id.to_s == id }
      model.update_sort!(new_sort) if model.read_attribute(attr) != new_sort
    end
    head :ok
  end

private

  def parse_params
    klass_name = params.keys.first
    ids = params[klass_name].map {|id| id.to_s }
    [ klass_name.constantize, ids ]
  end
end
