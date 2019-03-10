#!/usr/bin/ruby

require 'date'
require 'active_support/time'
require 'sinatra'

def chart(t1,t2,dur, where)
    puts where
    duration = dur
    time_ws = t1
    time_we = t2
    previous = 15 * 60
    after = 20 * 60
    start_time_cinema = 15 * 60
    time_start = DateTime.parse("10:30 am").min
    window1 = time_we.to_i - time_ws.to_i
    pnt_date = time_we
    pnt_epoc =  pnt_date.to_i
    i=0
    arr = []
    loop do
        if i == 0
            pnt_date = pnt_date - (duration) 
        else
            pnt_date = pnt_date - (previous + duration + after)
        end
        if (pnt_date).to_i < time_ws.to_i + start_time_cinema
            break
        end
        minutes = pnt_date.min
        if minutes.to_s.length == 1
            minute = minutes
            if minute > 0 and minute < 5
                pnt_date = pnt_date.to_datetime.change(min: 0).to_time
                #puts '0<x<5' + pnt_date.to_s
            elsif minute > 5 and minute < 10
                pnt_date = pnt_date.to_datetime.change(min: 5).to_time
                #puts '5<x<10' + pnt_date.to_s
            else
                pnt_date = pnt_date
            end
        else
            minute = minutes.to_s[1].to_i
            if minute > 0 and minute < 5
                minute2 = (minutes.to_s[0] + '0').to_i
                pnt_date = pnt_date.to_datetime.change(min: minute2).to_time
                #puts '0<x<5' + pnt_date.to_s
            elsif minute > 5 and minute < 10
                minute2 = (minutes.to_s[0] + '5').to_i
                pnt_date = pnt_date.to_datetime.change(min: minute2).to_time
                #puts '5<x<10' + pnt_date.to_s
            else
                pnt_date = pnt_date
            end
        end
        i = i + 1
        arr << [pnt_date.strftime("%I:%M %p"), (pnt_date + duration).strftime("%I:%M %p")]
    end
    arr.reverse.each do |t|
        puts '    ' + t[0].to_s + ' - ' + t[1].to_s
    end
    return arr.reverse
end

movie = 'Liar Liar (1997). Rated PG-13. 86 minutes'
#puts "Insert movie name ( Liar Liar (1997). Rated PG-13. 86 minutes [ENTER] ): "
#movie = gets.chomp
if movie.empty?
    movie = 'Liar Liar (1997). Rated PG-13. 86 minutes'
end
name = movie.split('.')[0]
dur = movie.split('.')[2].split()[0].to_i * 60
#puts name
time_ws = Time.new(2019,02,15,11,0,0)
time_we = Time.new(2019,02,15,23,0,0)
time_fs = Time.new(2019,02,15,10,30,0)
time_fe = Time.new(2019,02,16,0,0,0)
#chart(time_ws, time_we, dur, "  Weekday")
#chart(time_fs, time_fe, dur, "  Weekend")

get '/' do
    erb :index
end
post '/cine' do
    puts params
    unless params['name'].empty? or params['name'] == "" or params['name'].split('.').length < 3
        @name = params['name'].split('.')[0]
        dur = params['name'].split('.')[2].split()[0].to_i * 60
        @chart1 = chart(time_ws, time_we, dur, "  Weekday")
        @chart2 = chart(time_fs, time_fe, dur, "  Weekend")
        erb :cine
    else
        redirect '/'
    end
end
    