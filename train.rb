require_relative 'car'
require_relative 'cargo_car'
require_relative 'cargo_train'
require_relative 'interface'
require_relative 'passenger_car'
require_relative 'passenger_train'
require_relative 'route'
require_relative 'station'
require_relative 'train'

class Train
  attr_reader :type
  attr_accessor :speed, :curr_station

  def initialize(number, type)
    @number = number
    @type = type
    @route = nil
  end

  def stop
    self.speed = 0
  end

  def add_car
    stop
  end

  def delete_car
    stop
  end

  def accept_route(route)
    @route = route
    self.curr_station = @route.stations[0]
  end

  def forward
    self.curr_station = next_station if next_station
  end

  def backward
    self.curr_station = prev_station if prev_station
  end

  def prev_station
    index = @route.stations.find_index(curr_station)

    if index.zero?
      puts "There is no previous station. The train is at the departure '#{@route.stations[0]}'!"
    else
      @route.stations[index - 1]
    end
  end

  def next_station
    index = @route.stations.find_index(curr_station)

    if index == @route.stations.length - 1
      puts "There is no next station. The train is at the destination '#{@route.stations[-1]}'!"
    else
      @route.stations[index + 1]
    end
  end
end