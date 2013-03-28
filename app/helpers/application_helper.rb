module ApplicationHelper

  def on_front_page?
    return params[:controller] == "pages" && params[:action] == "home"
  end

  def gravatar_for(user)
    unless user
      return
    end
    img = forem_avatar user, :size => 80
    content_tag :span, img, :class => "user_icon_container"
  end

end
