module ApplicationHelper

  def on_front_page?
    params[:controller] == "pages" && params[:action] == "home"
  end

  def gravatar_for(user)
    return unless user
    img = forem_avatar user, :size => 80
    content_tag :span, img, :class => "user_icon_container"
  end

end
