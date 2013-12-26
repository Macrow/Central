# -*- encoding : utf-8 -*-
module ApplicationHelper
  def display_flash
    output = ActiveSupport::SafeBuffer.new
    flash.each do |key, msg|
      output << content_tag(:div, (link_to('×', '#', class: 'close', 'data-dismiss' => 'alert', 'aria-hidden' => 'true') + content_tag(:strong, t("flash.#{key}")) + ' : ' + msg), class: "alert alert-#{key} fade in")
    end
    output.html_safe
  end
  
  def user_name_and_notification(user)
    if unread_notifications_count > 0
      (user.name + ' ' + badge_icon(unread_notifications_count)).html_safe
    else
      user.name
    end
  end
  
  def badge_icon(number)
    content_tag(:span, number, class: "badge")
  end
  
  def tab_link_to(name, link, c_name, a_names = nil)
    css_class = (controller_name == c_name and (a_names.nil? ? true : a_names.split.include?(action_name))) ? 'active' : ''
    content_tag :li, link_to(name, link), class: css_class
  end
  
  def dropdown_link(text, c_name, a_names)
    active = (controller_name == c_name and a_names.split.include?(action_name)) ? 'active' : ''
    output = content_tag :ul, class: 'dropdown-menu' do
      yield
    end
    output = link_to("#{text}<b class='caret'></b>".html_safe, '#', 'data-toggle' => 'dropdown', class: 'dropdown-toggle') + output
    output = content_tag :li, output, class: "dropdown #{active}"
    output.html_safe
  end
  
  def display_labels(labels)
    output = ActiveSupport::SafeBuffer.new
    labels.each do |label|
      output << content_tag(:span, label, class: 'label label-default')
    end
    output.html_safe
  end
  
  def display_user_link(user, options = {})
    if user
      link_to user.name, (options[:admin] ? [:admin, user] : user)
    else
      content_tag :span, '该用户已被删除', class: 'label label-default'
    end
  end
end
