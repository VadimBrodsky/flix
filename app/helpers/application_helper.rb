module ApplicationHelper
  def page_title
    title_string = if content_for?(:title)
      "#{content_for(:title)} | Flix  a better IMDB"
    else
      "Flix  a better IMDB"
    end
    content_tag(:title, title_string)
  end

  def title(title)
    content_for(:title, title)
  end
end
