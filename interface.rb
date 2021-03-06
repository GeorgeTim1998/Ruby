class Interface
  def initialize
    @stations = []
    @trains = []
    @routes = []
    show_commands
    init_action
  end

  private

  # здесь лежат методы, которые касаются только внутренней логики класса Interface:
  # проверка введенных данных, усправление объектами других классов и т.д.
  # Пользователь не должен иметь к этому доступ
  attr_accessor :action, :stations, :trains, :routes

  def show_commands
    puts "\nDo one of the following:".blue

    puts 'Create station'.light_blue
    puts "\tPass '0' to create station;"

    puts 'Create train:'.light_blue
    puts "\tPass '1a' to create cargo train;"
    puts "\tPass '1b' to create passenger train;"

    puts 'Manage routes:'.light_blue
    puts "\tPass '2a' to create route;"
    puts "\tPass '2b' to add waypoint to route;"
    puts "\tPass '2c' to delete a waypoint from route;"
    puts "\tPass '2d' to assign route to train;"

    puts 'Car managment:'.light_blue
    puts "\tPass '3ac' to add cars to cargo train;"
    puts "\tPass '3ap' to add cars to passenger train;"
    puts "\tPass '3bc' to delete cars from cargo train;"
    puts "\tPass '3bp' to delete cars from passenger train;"
    puts "\tPass '3cc' to occupy volume in a cargo car;"
    puts "\tPass '3cp' to take a seat in a passenger car;"

    puts 'Move trains:'.light_blue
    puts "\tPass '4a' to move train forward;"
    puts "\tPass '4b' to move train backward;"

    puts 'Show info:'.light_blue
    puts "\tPass '5a' to list available stations;"
    puts "\tPass '5b' to list trains at the station;"
    puts "\tPass '5c' to list trains cars."

    puts "\nPass 'exit' to stop."

    puts "\n"
  end

  def init_action
    loop do
      interface_gets
      break if exit?

      do_action
    end
  end

  def do_action
    case action
    when '0'
      create_station
    when '1a'
      create_cargo_train
    when '1b'
      create_pass_train
    when '2a'
      create_route
    when '2b'
      add_waypoint
    when '2c'
      delete_waypoint
    when '2d'
      assign_route
    when '3ac'
      add_cars_to_cargo
    when '3ap'
      add_cars_to_pass
    when '3bc'
      del_cars_from_cargo
    when '3bp'
      del_cars_from_pass
    when '3cc'
      occupy_volume
    when '3cp'
      take_seat
    when '4a'
      train_go
    when '4b'
      train_back
    when '5a'
      available_stations
    when '5b'
      trains_at_station
    when '5c'
      trains_cars
    when 'commands'
      show_commands
    else
      warning!
    end
  end

  def interface_gets
    puts 'Your action is: '.blue
    self.action = gets.chomp
  end

  def exit?
    action == 'exit'
  end

  def warning!
    puts "WARNING! There is no such action! Pass 'commands' to see what's available.\n".yellow
  end

  def create_station
    puts 'Input stations name:'.light_blue
    station_name = gets.chomp
    stations << Station.new(station_name)
    puts "Station #{stations[-1].inspect} created!".green
  rescue RuntimeError => e
    puts e.inspect.red
    retry
  end
  
  def create_cargo_train
    trains << CargoTrain.new(input_train)
    puts "Cargo train #{trains[-1].inspect} created!".green
  rescue RuntimeError => e
    puts e.inspect.red
    retry
  end
  
  def create_pass_train
    trains << PassengerTrain.new(input_train)
    puts "Passenger train #{trains[-1].inspect} created!".green
  rescue RuntimeError => e
    puts e.inspect.red
    retry
  end
  
  def input_train
    puts 'How would you name your train?'.cyan
    train = gets.chomp
  end
  
  def list_stations
    puts 'Stations:'.green
    stations.each_with_index { |item, index| puts "index: #{index} for #{item.name}" }
  end
  
  def create_route
    puts 'Input departure:'.cyan
    destination = gets.chomp
    puts 'Input destination:'.cyan
    departure = gets.chomp
    routes << Route.new(destination, departure)
    puts "Route #{routes[-1].inspect} created!".green
  rescue RuntimeError => e
    puts e.inspect.red
    retry
  end

  def add_waypoint
    available_routes

    puts 'Select route to add waypoint to:'.cyan
    route_num = gets.chomp.to_i

    puts 'Input waypoint name'.cyan
    waypoint = gets.chomp

    routes[route_num].add_waypoint(waypoint) if action_possible(routes, route_num)
  end

  def delete_waypoint
    available_routes

    puts 'Select route to delete waypoint from:'.cyan
    route_num = gets.chomp.to_i

    puts 'Input waypoint name'.cyan
    waypoint = gets.chomp

    routes[route_num].delete_waypoint(waypoint) if action_possible(routes, route_num)
  end

  def available_routes
    puts 'Available routes:'.cyan
    routes.each_with_index { |item, index| puts "index: #{index} for #{item.stations}" }
  end

  def available_trains
    puts 'Available trains:'.cyan
    @trains.each_with_index { |item, index| puts "index: #{index} for #{item.inspect}" }
  end

  def available_cars(train)
    puts 'Available cars:'.cyan
    train.cars.each_with_index { |item, index| puts "index: #{index} for #{item.inspect}" }
  end

  def available_trains_type(type)
    puts "Available '#{type}' trains:".cyan
    @trains_type = trains.select { |train| train.type == type }
    @trains_type.each_with_index { |item, index| puts "index: #{index} for #{item.inspect}" }
  end

  def action_possible(array, number)
    array.length - 1 >= number and number >= 0
  end

  def assign_route
    available_trains
    puts 'Select train:'.cyan
    train_num = gets.chomp.to_i

    available_routes
    puts 'Select route:'.cyan
    route_num = gets.chomp.to_i

    @trains[train_num].accept_route(@routes[route_num]) \
    if action_possible(@trains, train_num) && action_possible(@routes, route_num)
  end

  def available_stations
    puts 'Available stations:'.cyan
    stations.each_with_index { |item, index| puts "index: #{index} for #{item.name}" }
  end

  def train_go
    available_trains

    puts 'Select train:'.cyan
    train_num = gets.chomp.to_i

    trains[train_num].forward if action_possible(trains, train_num)
  end

  def train_back
    available_trains

    puts 'Select train:'.cyan
    train_num = gets.chomp.to_i

    trains[train_num].backward if action_possible(trains, train_num)
  end

  def add_cars_to_cargo
    available_trains_type('cargo')

    puts 'Assign volume:'.cyan
    volume = gets.chomp.to_i
    
    puts 'Select train:'.cyan
    train_num = gets.chomp.to_i
    
    @trains_type[train_num].add_car(CargoCar.new(volume)) if action_possible(@trains_type, train_num)
  rescue RuntimeError => e
    puts e.inspect.red
    retry
  end
  
  def add_cars_to_pass
    available_trains_type('passenger')
    
    puts 'Assign seats amount:'.cyan
    seats_amount = gets.chomp.to_i

    puts 'Select train:'.cyan
    train_num = gets.chomp.to_i

    @trains_type[train_num].add_car(PassCar.new(seats_amount)) if action_possible(@trains_type, train_num)
  rescue RuntimeError => e
    puts e.inspect.red
    retry
  end

  def trains_at_station
    available_routes

    puts 'Select station:'.cyan
    station_select = gets.chomp

    trains_select = trains.select { |train| train.curr_station == station_select }
    
    show_trains(trains_select) { |train| puts "Train: #{train.number} #{train.type} #{train.cars.length}" }
  end

  def show_trains(trains_select, &block)
    trains_select.each{ |train| block.call(train) }
  end

  def del_cars_from_cargo
    available_trains_type('cargo')

    puts 'Select train:'.cyan
    train_num = gets.chomp.to_i

    @trains_type[train_num].delete_car if action_possible(@trains_type, train_num)
  end

  def del_cars_from_pass
    available_trains_type('passenger')

    puts 'Select train:'.cyan
    train_num = gets.chomp.to_i
    
    @trains_type[train_num].delete_car if action_possible(@trains_type, train_num)
  end
  
  def trains_cars
    available_trains
    puts 'Select train:'.cyan
    train_num = gets.chomp.to_i
    
    if @trains[train_num].instance_of? PassengerTrain
      @trains[train_num].all_cars { |car| puts "Car: #{car.type} #{car.free_seats} #{car.taken_seats}" }
    else
      @trains[train_num].all_cars { |car| puts "Car: #{car.type} #{car.free_volume} #{car.used_volume}" }
    end
  end 
  
  def occupy_volume
    train_num = train_info_and_request
    
    available_cars(@trains[train_num]) if action_possible(@train, train_num)
    puts 'Select car:'.cyan
    car_num = gets.chomp.to_i
    
    puts 'Volume to occupy:'.cyan
    volume = gets.chomp.to_i

    @trains[train_num].cars[car_num].occupy_volume(volume) if action_possible(@trains[train_num].cars, car_num)
  end
  
  def take_seat
    train_num = train_info_and_request
    
    available_cars(@trains[train_num]) if action_possible(@train, train_num)
    puts 'Select car:'.cyan
    car_num = gets.chomp.to_i
  
    @trains[train_num].cars[car_num].take_seat if action_possible(@trains[train_num].cars, car_num)
  end

  def train_info_and_request
    available_trains
    puts 'Select train:'.cyan
    gets.chomp.to_i
  end
end
