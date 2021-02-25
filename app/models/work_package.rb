require 'open-uri'
require 'nokogiri'

class WorkPackage < ActiveRecord::Base
  
  belongs_to :parliamentary_procedure

  def web_link_meta_tags
    # Rails.cache.fetch([web_link], :expires => 1.hour) do
      Nokogiri::HTML(URI.open(self.web_link)).xpath('//meta')
    # end
  end

  def web_link_links
    # Rails.cache.fetch([web_link], :expires => 1.hour) do
    Nokogiri::HTML(URI.open(self.web_link)).xpath('//link')
    # end
  end
  
  def business_items_that_have_happened
    BusinessItem.all.where( 'work_package_id = ?', self).where( 'date <= ?', Date.today ).order( 'date' )
  end

  def business_items_that_have_happened_number
    case business_items_that_have_happened.length
    when 0
      "none"
    when 1
      "one"
    when 2
      "two"
    when 3
      "three"
    when 4
      "four"
    when 5
      "five"
    when 6
      "six"
    when 7
      "seven"
    when 8
      "eight"
    when 9
      "nine"
    else
      business_items_that_have_happened.to_s
    end
  end

  def business_items_that_are_scheduled_to_happen
    BusinessItem.all.where( 'work_package_id = ?', self).where( 'date > ?', Date.today ).order( 'date' )
  end


  def business_items_that_are_scheduled_to_happen_number
    case business_items_that_are_scheduled_to_happen.length
    when 0
      "none"
    when 1
      "one"
    when 2
      "two"
    when 3
      "three"
    when 4
      "four"
    when 5
      "five"
    when 6
      "six"
    when 7
      "seven"
    when 8
      "eight"
    when 9
      "nine"
    else
      business_items_that_are_scheduled_to_happen.to_s
    end
  end
  
  def business_items_unknown
    BusinessItem.all.where( 'work_package_id = ?', self).where( 'date is null' ).order( 'date' )
  end

  def business_items_unknown_number
    case business_items_unknown.length
    when 0
      "none"
    when 1
      "one"
    when 2
      "two"
    when 3
      "three"
    when 4
      "four"
    when 5
      "five"
    when 6
      "six"
    when 7
      "seven"
    when 8
      "eight"
    when 9
      "nine"
    else
      business_items_unknown.to_s
    end
  end
end
