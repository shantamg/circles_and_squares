module MenuHelper
  def link_new
    link_to "New", '/', class: 'new check_if_dirty'
  end

  def link_name(name = '', url = '')
    link_to name, url, class: 'check_if_dirty', id: 'name'
  end

  def link_save
    link_to "Save", '', id: 'save'
  end

  def link_browse
    link_to "Browse", drawings_path, class: 'check_if_dirty'
  end
end
