module ApplicationHelper

  def on_front_page?
    return params[:controller] == "pages" && params[:action] == "home"
  end

end
