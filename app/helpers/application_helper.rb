module ApplicationHelper

  def logo
    image_tag("mun_shoe.jpg", :alt => "MUN APP", :class => "round")
  end

  #Return a title on a per-page basis.
  def title
    base_title = "MODEL UNITED NATIONS APP OF DOOM"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
