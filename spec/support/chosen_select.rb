# -*- encoding : utf-8 -*-
# Support for multiple selects (just call select_from_chosen as many times as required):
module ChosenSelect
  def select_from_chosen(item_text, options)
    field = find_field(options[:from])
    option_value = page.evaluate_script("$(\"##{field[:id]} option:contains('#{item_text}')\").val()")
    page.execute_script("value = ['#{option_value}']\; if ($('##{field[:id]}').val()) {$.merge(value, $('##{field[:id]}').val())}")
    option_value = page.evaluate_script("value")
    page.execute_script("$('##{field[:id]}').val(#{option_value})")
    page.execute_script("$('##{field[:id]}').trigger('liszt:updated').trigger('change')")
  end  
end

RSpec.configure do |config|
  config.include ChosenSelect
end
