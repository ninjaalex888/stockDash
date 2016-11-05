#!/usr/bin/env ruby
require 'net/http'
require 'csv'

# Track the Stock Value of a company by it’s stock quote shortcut using the 
# official yahoo stock quote api
# 
# This will record all current values and changes to all stock indizes you
# indicate in the `yahoo_stockquote_symbols` array. Each value is then available
# in the `yahoo_stock_quote_[symbol_slug]` variables and combined in a list
# `yahoo_stock_quote_list` which contains them all.

# Config
# ------
# Symbols of all indizes you want to track
yahoo_stockquote_symbols = [
  'AAPL',      # will become `yahoo_stock_quote_appl`
  'GOOG',      
  'YHOO',      
  'FB',        
  'ZNGA',
  'EBAY',
  'AMZN',
  'MSFT',
  'ORCL',
  'DELL',
  'CSCO',
  'QCOM'
]
# #s = yahoo_stockquote_symbols.join(',').upcase



Dashing.scheduler.every '15s', :first_in => 0 do

  # aapl = StockQuote::Stock.quote("aapl")
  # puts aapl.symbol
  # puts aapl.ask
  # puts aapl.change
  # puts aapl.name




  #obj values for Stock quote
  # symbol, ask, average_daily_volume, bid, ask_realtime, bid_realtime, book_value, change_percent_change, 
  # change, commission, change_realtime, after_hours_change_realtime, dividend_share, last_trade_date, trade_date, 
  # earnings_share, error_indicationreturnedforsymbolchangedinvalid, eps_estimate_current_year, eps_estimate_next_year, 
  # eps_estimate_next_quarter, days_low, days_high, year_low, year_high, holdings_gain_percent, annualized_gain, holdings_gain, 
  # holdings_gain_percent_realtime, holdings_gain_realtime, more_info, order_book_realtime, market_capitalization, 
  # market_cap_realtime, ebitda, change_from_year_low, percent_change_from_year_low, last_trade_realtime_with_time, 
  # change_percent_realtime, change_from_year_high, percent_change_from_year_high, last_trade_with_time, last_trade_price_only, 
  # high_limit, low_limit, days_range, days_range_realtime, fiftyday_moving_average, two_hundredday_moving_average, 
  # change_from_two_hundredday_moving_average, percent_change_from_two_hundredday_moving_average, change_from_fiftyday_moving_average, 
  # percent_change_from_fiftyday_moving_average, name, notes, open, previous_close, price_paid, changein_percent, price_sales, price_book, 
  # ex_dividend_date, pe_ratio, dividend_pay_date, pe_ratio_realtime, peg_ratio, price_eps_estimate_current_year, price_eps_estimate_next_year, 
  # symbol, shares_owned, short_ratio, last_trade_time, ticker_trend, oneyr_target_price, volume, holdings_value, holdings_value_realtime, 
  # year_range, days_value_change, days_value_change_realtime, stock_exchange, dividend_yield, percent_change, 
  # error_indicationreturnedforsymbolchangedinvalid, date, open, high, low, close, adj_close
  

  stocklist = Array.new
  yahoo_stockquote_symbols.each do |s|

    if stock.response_code == 200
      sname = stock.name
      symbol = stock.symbol
      current = stock.ask
      change = stock.change
      puts "****"
      puts sname
      puts symbol
      puts current
      puts change
      puts "****"

    #puts current.class


  #   # iterate over different stock symbols and create
  #   # the list and single values to be pushed to the frontend
  #   data.each do |line|
  #     sname = line[0]
  #     symbol = line[1]
  #     current = line[2].to_f
  #     change = line[3].to_f

  

      # add data to list

      stocklist.push({
        label: sname,
        value: current
        })

      # send single value and change to dashboard
      widgetVarname = "yahoo_stock_quote_" + symbol.gsub(/[^A-Za-z0-9]+/, '_').downcase
      widgetData = {
        current: current
      }
      if change != 0.0
        widgetData[:last] = current + change
      end
      if defined?(Dashing.send_event)
        Dashing.send_event(widgetVarname, widgetData)
      else
        print "current: #{symbol} #{current} #{change} #{widgetVarname}\n"
      end
    end
  end

    # send list to dashboard
    if defined?(Dashing.send_event)
      Dashing.send_event('yahoo_stock_quote_list', { items: stocklist })
    else
      print stocklist
      print "neext"
    end
end



# #http://download.finance.yahoo.com/d/quotes.csv?s=AAPL+GOOG+MSFT
  # http = Net::HTTP.new("download.finance.yahoo.com")
  # response = http.request(Net::HTTP::Get.new("/d/quotes.csv?s=AAPL"))
  # puts response.code
  # if response.code != "200"
  #   puts "yahoo stock quote communication error (status-code: #{response.code})\n#{response.body}"
  # else
  #   puts 'got response'
  #   puts response.body
  #   # read data from csv
  #   data = CSV.parse(response.body)
  #   puts data