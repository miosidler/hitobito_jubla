# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

module Jubla::EventDecorator
  extend ActiveSupport::Concern

  def multiple_contact_groups?
    possible_contact_groups.count > 1 ? true : false
  end

  def labeled_bsv_attr(key)
    h.labeled(Export::Csv::Events::BsvList.new([]).attribute_labels.fetch(key), bsv_field(key))
  end

  def remarks_with_default(default)
    (model.is_a?(Event::Course) && remarks.blank?) ? default : remarks
  end

  private

  def bsv_field(key)
    value = bsv_info.send(key).to_s
    value += " #{warning(key)}" if bsv_info.warnings[key]
    value.html_safe
  end

  def warning(key)
    content_tag(:i, '', class: 'icon icon-warning-sign', title: bsv_info.error(key))
  end

  def bsv_info
    @bsv_info ||= Bsv::Info.new(model)
  end

end
