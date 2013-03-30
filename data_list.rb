require 'data_list/helper'

module C140
  module DataList
    @@data_list_tag = :ol
    @@list_tag      = :ul
  end
end

ActionView::Base.send :include, C140::DataList::Helper
