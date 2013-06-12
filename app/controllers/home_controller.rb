# coding: utf-8

class HomeController < ApplicationController
  require 'nokogiri'
  require 'open-uri'

  def index
    params[:c] ||= {}
    doc = Nokogiri::HTML(open("http://vk.com/search?" + params.to_param))
    @persons = []
    doc.css('#results .clear_fix').each do |person|
      link = 'http://vk.com' + person.css('.name a').first['href']
      account = Nokogiri::HTML(open(link))
      @persons << {
        name: person.css('.name a').first.text,
        link: link,
        inst: person.css('.labeled').last.text,
        birthday: account.css('dd').first.try(:text),
        photo: person.css('.search_item_img').first.attributes['src'].text
      }
    end

    @countries = ['Россия', 'Украина', 'Беларусь', 'Казазстан', 'Азербайджан', 'Армения', 'Грузия']
    @countries = @countries.map{|c| [c, @countries.index(c)]}
  end

end
