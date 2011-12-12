# encoding: UTF-8
module ApplicationHelper
  def logo
    image_tag("esquire-logo.png", :alt => "Esquire", :class => "round")
  end
  
  def title
    base_title = "Esquire HUB" 
    if @title.nil? 
      base_title
    else
      "#{base_title} | #{@title}"
    end 
  end
  
  def is_active?(controller, action)
    "active" if params[:controller]==controller && params[:action] == action
  end
end
