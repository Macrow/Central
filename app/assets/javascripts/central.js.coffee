# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  # Avatar
  new AvatarCropper()
  
  # Tag Selector
  new TagSelector()
  
  # Group Operator
  new GroupOperator()
  
  # Date Picker
  $('#user_birthday').datepicker
    format: 'yyyy-mm-dd'
    
  # Chosen
  $('.chzn-select').chosen()
  
  # Tag Edit Mode in Admin  
  $('input:checkbox#tag_edit').on 'click', ->
    if this.checked
      $('.tag_edit').removeClass('hide')
    else
      $('.tag_edit').addClass('hide')

# Avatar
class AvatarCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 250, 250]
      onSelect: @update
      onChage:  @update
    
  update: (c) =>
    $('#user_crop_x').val(c.x)
    $('#user_crop_y').val(c.y)
    $('#user_crop_w').val(c.w)
    $('#user_crop_h').val(c.h)
    @updatePreview(c)
  
  updatePreview: (c) =>
    if parseInt(c.w) > 0
      @updateBox(c, 'min_preview', 32)
      @updateBox(c, 'mid_preview', 48)
      @updateBox(c, 'max_preview', 96)
      
  updateBox: (c, box, size) =>
    $("##{box}").css
      width: Math.round(size/c.w * $('#cropbox').width()) + 'px',
      height: Math.round(size/c.h * $('#cropbox').height()) + 'px',
      marginLeft: '-' + Math.round(size/c.w * c.x) + 'px',
      marginTop: '-' + Math.round(size/c.h * c.y) + 'px'

# Tag Selector
class TagSelector
  constructor: (@text_field_box_id = '#user_tag_text', @tagged_class = 'btn-info', @max_tag_count = 3) ->
    $('#list_tags a').on 'click', @update_list_tags
    $('#user_tags').on 'click', 'a', @update_user_tags
    @splitter = $('#tag_splitter').data('splitter')
    
  update_list_tags: (e) =>
    event.preventDefault()
    if $(e.target).attr('class').search(@tagged_class) == -1
      if @get_true_element($(@text_field_box_id).val().split(@splitter)).length < @max_tag_count
        $(@text_field_box_id).val($(@text_field_box_id).val() + @splitter + "#{$(e.target).html()}")
        $('#user_tags').append("<a href='#' class='btn #{@tagged_class}'>#{$(e.target).html()}</a>")
        $(e.target).addClass(@tagged_class)
      else
        $('#flash').html(flash_html('notice', '注意', "最多只能选择#{@max_tag_count}个标签！"));
  
  update_user_tags: (e) =>
    event.preventDefault()
    tags = []
    for tag in @get_true_element($(@text_field_box_id).val().split(@splitter))
      tags.push(tag) unless tag == $(e.target).html()
    $(@text_field_box_id).val(tags.join(@splitter))
    $("#list_tags a##{$(e.target).html().replace(/\ /g, '_')}").removeClass(@tagged_class)
    $(e.target).fadeOut()
  
  get_true_element: (array) ->
    new_array = []
    for e in array
      new_array.push e if e != '' && new_array.indexOf(e) == -1 
    new_array

# Group Operator
class GroupOperator
  constructor: ->
    $('input:checkbox#group_operation').on 'change', @group_select
    $('input:checkbox#group_operation, td.group_operation input:checkbox').on 'change', @display_tools
    $('a.group_operation_submit_button').on 'click', @group_submit
    
  group_select: ->
    $('td.group_operation input:checkbox').prop('checked', this.checked)
  
  display_tools: ->
    select_count = $('td.group_operation input:checkbox:checked:visible').length
    if select_count > 0
      $('.group_operation_tools').fadeIn(300)
      $('.group_operation_tools .badge').html(select_count)
    else
    	$('.group_operation_tools').fadeOut(300)
  
  group_submit: (e) ->
    e.preventDefault()
    if confirm('确定删除选中内容？')
      ids = []
      $('input[name=thread_checkbox]:visible').each -> ids.push(this.value) if this.checked
      $('input#submit_ids').val(ids);
      $('form#group_operation_form').submit()

@flash_html = (key, title, content) -> "<div class='alert alert-#{key}'><a href='#', class='close' data-dismiss='alert'>×</a><strong>#{title}</strong> : #{content}</div>"

@show_all_users = ->
  $.ajax
    url: '/users/all.js'
    dataType: 'script'
    beforeSend: ->
      $('#all_users .show_link').hide()
      $('#loading').show()
    complete: ->
      $('#loading').hide()

@show_all_receivers = (ids) ->
  $.ajax
    url: '/admin/users/fetch.js'
    dataType: 'script'
    data:
      'ids': ids.split(',')
    beforeSend: ->
      $('#loading').show()
    complete: ->
      $('#loading').hide()
