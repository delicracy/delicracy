module ApplicationHelper
  def glyphicon(name, label: nil, **options)
    classes = "glyphicon glyphicon-#{name}"
    if options.has_key?(:class)
      classes += " #{options[:class]}"
      options.delete(:class)
    end
    content_tag :span, nil, { class: classes, 'aria-hidden' => true, 'aria-label' => label }.merge(options)
  end

  def scaled_number(number, precision: 0, delimiter: ',', scale: MY_APP[:price_scale_number])
    number_with_precision number * scale, precision: precision, delimiter: delimiter
  end

  def with_no_contents(collection, text = 'No contents', &block)
    unless collection.empty?
      capture(collection, &block) if block_given?
    else
      content_tag :p, text
    end
  end

  def template_path(class_name)
    "#{class_name.tableize}/#{class_name.underscore}"
  end

  def localtime(datetime)
    datetime.localtime.strftime("%b %e '%y %H:%M")
  end

  def youtube_iframe(youtube_id)
    content_tag :div, class: 'embed-responsive embed-responsive-16by9' do
      content_tag :iframe, nil, class: 'embed-responsive-item center-block',
        src: "https://www.youtube.com/embed/#{youtube_id}?rel=0", allowfullscreen: true
    end
  end

  def active_class(path)
    'active' if current_page?(path)
  end

  def main_logo_link
    link_to root_path do
      image_tag('logos/BI_white_full.png', height: '25px')
    end 
  end

  def price_with_format(price, unit: true)
    if unit
      number_to_percentage price, precision: 1
    else
      number_with_precision price, precision: 0, delimiter: ','
    end
  end

  def volume_with_format(volume)
    number_with_precision volume, precision: 0, delimiter: ','
  end

  def lot_with_format(lot)
    number_with_precision lot, precision: 0, delimiter: ','
  end

end
