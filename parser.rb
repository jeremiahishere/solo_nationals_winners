require 'csv'

class Parser
  def initialize
  end

  def run
    files.each do |filename|
      puts filename
      csv_data = parse_file(filename)
      
      csv_data.each do |row|
        puts row.inspect
      end

      write_csv(filename, csv_data)
    end
  end

  def write_csv(filename, csv_data)
    output_filename = filename.gsub("raw", "parsed")
    FileUtils.mkdir_p(File.dirname(output_filename))

    CSV.open(output_filename, 'wb', { force_quotes: true }) do |csv|
      csv_data.each do |row|
        csv << row.values
      end
    end
  end
    
  def parse_file(filename)
    contents = File.read(filename)
    lines = contents.split("\n")

    lines.collect do |line|
      parse_line(line)
    end
  end

  def parse_line(line)
    c = line.split(' ')

    # canadian location
    if c[3].include?(',') && c[4].include?(',')
      return {
        year: c[0],
        name: "#{c[1]} #{c[2]}",
        location: "#{c[3]} #{c[4]} #{c[5]}",
        car: c[6..-1].join(' ')
      }
    # two word name, two word location
    elsif c[3].include?(',')
      return {
        year: c[0],
        name: "#{c[1]} #{c[2]}",
        location: "#{c[3]} #{c[4]}",
        car: c[5..-1].join(' ')
      }
    # three word name or three word location
    elsif c[4].include?(',')
      # three word location
      if potential_city_first_names.include?(c[3])
        return {
          year: c[0],
          name: "#{c[1]} #{c[2]}",
          location: "#{c[3]} #{c[4]} #{c[5]}",
          car: c[6..-1].join(' ')
        }
      # three word name
      else
        return {
          year: c[0],
          name: "#{c[1]} #{c[2]} #{c[3]}",
          location: "#{c[4]} #{c[5]}",
          car: c[6..-1].join(' ')
        }
      end
    elsif c[5].include?(',')
      # two word name and four word location
      if potential_city_first_names.include?(c[3])
        return {
          year: c[0],
          name: "#{c[1]} #{c[2]}",
          location: "#{c[3]} #{c[4]} #{c[5]} #{c[6]}",
          car: c[7..-1].join(' ')
        }
      # three word name and three word location
      else
        return {
          year: c[0],
          name: "#{c[1]} #{c[2]} #{c[3]}",
          location: "#{c[4]} #{c[5]} #{c[6]}",
          car: c[7..-1].join(' ')
        }
      end
    else
      raise "Could not be parsed: #{c.inspect}"
    end
  end

  def potential_city_first_names
    [
      "San",
      "Glen",
      "Auburn",
      "Rancho",
      "Alta",
      "Las",
      "La",
      "Los",
      "Fort",
      "Ft",
      "New",
      "Seeleys",
      "State",
      "Clifton",
      "Menlo",
      "Litchfield",
      "Bay",
      "Huntington",
      "Colorado",
      "Garden",
      "Lake",
      "Seal",
      "Simi",
      "Redondo",
      "Morgan",
      "West", # could be a problem
      "W",
      "White", # could be a problem
      "Canal",
      "Beacon",
      "Chino",
      "Valley",
      "Shelby", #could be a problem
      "Heber",
      "Grand",
      "Overland",
      "Union",
      "Pleasant",
      "Morris",
      "Sierra",
      "Apple",
      "Kansas",
      "Sterling",
      "N",
      "Federal",
      "Newport",
      "Coto",
      "Mountain",
      "Mount",
      "Mt",
      "St",
      "St.",
      "Saint",
      "Santa",
      "Big",
      "Des",
      "Oklahoma",
      "Bowling",
      "Elmwood",
      "Beacon",
      "Hermosa",
      "Long",
      "Sioux",
      "Lagrange",
      "Elmwood",
      "South",
      "S",
      "Blue",
      "Wichita",
      "Rohnert",
      "Jacksonville",
      "Broad",
      "Mission",
      "Fall",
      "China",
      "Fountain",
      "Land",
      "Mill",
      "Commerce",
      "Red",
      "Atlantic",
      "Melbourne",
      "Salt"
    ]
  end
    
  def files
    Dir.glob("#{File.dirname(__FILE__)}/raw/**/*").select { |f| f.include?('result') }
  end
end

Parser.new.run
