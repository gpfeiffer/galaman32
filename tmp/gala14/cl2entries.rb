#############################################################################
##
##  Standard Data Interchange Format  Ver. 3.0 (official) April 28, 1998
##
##

SDIF = {}

#############################################################################
class Format
  attr_reader :tokens

  def self.checksum(line)
    (line[0, 2] == 'D0' ? 'N' : ' ') + 
      ("N%02d" % ((line[0, 156].bytes.inject(:+) + 211) / 19 % 100)).reverse
  end

  def initialize line
    format = SDIF[line[0,2]]
    @tokens = {}
    pos = 0
    if format
      format[:keys].each_with_index do |key, i|
        d = format[:lens][i]
        @tokens[key] = line[pos, d]
        pos += d
      end
    else
      @tokens[:mark] = line[0, 2]
    end
  end

  def mark
    tokens[:mark]
  end

  def join
    format = SDIF[@tokens[:mark]]
    format ? format[:keys].map { |key| @tokens[key] }.join : @tokens[:mark]
  end

  def self.parse_date date
    Date.strptime date, '%m%d%Y'
  end

  def self.parse_time time
    return 0 if time.strip == "NT"
    parts = time.split(/[\.\:]/).map(&:to_i).reverse
    parts[0] + 100 * (parts[1] + (parts[2].present? ? 60 * parts[2] : 0))
  end

  def self.last_first name
    last, first = name.split(",").map(&:strip)
  end

  def text
    case mark 
    when "A0" 
      "This is a '#{tokens[:gap0]}' file."
    when "B1"
      "Competition: #{tokens[:name]}, #{tokens[:dat0]} (#{tokens[:city]})"
    when "C1"
      "Club: #{tokens[:name]} (#{tokens[:team] + tokens[:five]})"
    when "D0"
      "Entry: #{tokens[:name]} #{tokens[:ssex]} #{tokens[:dofb]} Id:#{tokens[:siid]} for event #{tokens[:evnt]}. #{tokens[:dist]}#{tokens[:stro]}#{tokens[:esex]}#{tokens[:ages]} with seed #{tokens[:tim0]}#{tokens[:crs0]}: #{tokens[:plc1]}. #{tokens[:tim1]}#{tokens[:crs1]}P #{tokens[:plc2]}. ##{tokens[:tim3]}#{tokens[:crs3]}F"
    when "D3"
      "Swimmer: #{tokens[:siid]}"
    else
      "???"
    end
  end

  def self.read_entry_file name
    formats = []

    File.open(name, :encoding => 'iso-8859-1').each do |line|
      formats << Format.new(line)
    end
    
    swimmers = []
    events = []
    entries = []
    club = ""
    competition = ""
    
    formats.each do |format|
      tokens = format.tokens
      case format.mark
      when "B1"
        competition = {
          name: tokens[:name].strip,
          location: tokens[:city].strip,
          date: Format.parse_date(tokens[:dat0]),
        }
      when "C1"
        club = {
          full_name: tokens[:name].strip,
          symbol: (tokens[:team] + tokens[:five]).strip
        }
      when "D0"
        swimmer = {
          :number => tokens[:siid].strip,
          :gender => tokens[:ssex].downcase,
          :birthday => Format.parse_date(tokens[:dofb]),
        }
        swimmer[:last], swimmer[:first] = Format.last_first tokens[:name]
        swimmers << swimmer if not swimmers.include? swimmer
        event = {
          pos: tokens[:evnt].to_i,
          distance: tokens[:dist].to_i,
          stroke: tokens[:stro].to_i,
          gender: tokens[:esex],
        }
        events << event if not events.include? event
        entry = {
          swimmer: swimmers.index(swimmer),
          event: events.index(event),
          time: Format.parse_time(tokens[:tim0])
        }
        entries << entry
      else
        0
      end
    end

    # now find corresponding objects in the database.
    object = Competition.where(competition).first
    puts "Found competition: #{competition.inspect} => #{object.inspect}"
    competition[:object] = object

    events.each do |event|
      event[:competition_id] = competition[:object].id
      object = Event.where(event.slice(:competition_id, :pos)).first
      puts "Found event: #{event.inspect} => #{object.inspect}"
      event[:object] = object
    end

    object = Club.where(club.slice(:symbol)).first
    puts "Found club: #{club.inspect} => #{object.inspect}"
    club[:object] = object

    invitation = {
      competition_id: competition[:object].id,
      club_id: club[:object].id,
    }
    object = Invitation.where(invitation).first
    if object
      puts "Found invitation: #{invitation.inspect} => #{object.inspect}" 
      invitation[:object] = object
    else
      puts "WARNING: invitation not found!"
    end

    swimmers.each do |swimmer|
      object = nil
      swimmer[:club_id] = club[:object].id
      if swimmer[:number].present?
        object = Swimmer.where(swimmer.slice(:number)).first
        if object
          puts "Found swimmer by id: #{swimmer.inspect} => #{object.inspect}" 
          swimmer[:object] = object
        end
      end
      if not object
        object = Swimmer.where(swimmer.slice(:birthday, :gender)).select { |s|
s.first.downcase == swimmer[:first].downcase and s.last.downcase == swimmer[:last].downcase }.first
        if object
          puts "Found swimmer by name: #{swimmer[:first]} #{swimmer[:last]} (#{swimmer[:birthday]})\n                    => #{object.first_last} (#{object.birthday})" 
          swimmer[:object] = object
          if swimmer[:number].present? and object.number.blank?
            puts "Update SSID: #{swimmer[:number]}"
            swimmer[:object].update_attribute(:number, swimmer[:number])
          end
        end
      end
      # check swimmmer data and suggest update
      if object
        if swimmer[:club_id] != club[:object].id
          puts "Update club id  #{club[:object].id} => #{swimmer[:club_id]}"
          swimmer[:object].update_attribute(:club_id, swimmer[:club_id])
        end
      else
        swimmer[:club_id] = club[:object].id
        puts "Create new Swimmer: #{swimmer.inspect}"
        object = Swimmer.create(swimmer)
        swimmer[:object] = object
      end

      docket = {
        swimmer_id: swimmer[:object].id,
        invitation_id: invitation[:object].id,
        age: swimmer[:object].age(competition[:date]),
      }
      puts "Create new docket #{docket.inspect}"
      object = Docket.create(docket)
      docket[:object] = object
      swimmer[:docket_id] = docket[:object].id
    end

    entries.each do |entry|
      entry[:event_id] = events[entry[:event]][:object].id
      entry[:subject_id] = swimmers[entry[:swimmer]][:docket_id]
      entry[:subject_type] = "Docket"
      puts "Create new entry #{entry.slice(:event_id, :subject_id, :subject_type, :time).inspect}"
      object = Entry.create(entry.slice(:event_id, :subject_id, :subject_type, :time))
      entry[:object] = object
    end
  end

  def self.read_result_file name
    formats = []

    File.open(name, :encoding => 'iso-8859-1').each do |line|
      formats << Format.new(line)
    end
    
    swimmers = []
    events = []
    entries = []
    club = ""
    competition = ""
    
    formats.each do |format|
      tokens = format.tokens
      case format.mark
      when "B1"
        competition = {
          name: tokens[:name].strip,
          location: tokens[:city].strip,
          date: Format.parse_date(tokens[:dat0]),
        }
      when "C1"
        club = {
          name: tokens[:name].strip,
          symbol: (tokens[:team] + tokens[:five]).strip
        }
      when "D0"
        swimmer = {
          :number => tokens[:siid].strip,
          :gender => tokens[:ssex].downcase,
          :birthday => Format.parse_date(tokens[:dofb]),
        }
        swimmer[:last], swimmer[:first] = Format.last_first tokens[:name]
        swimmers << swimmer if not swimmers.include? swimmer
        entry = {
          swimmer: swimmers.index(swimmer),
          event: tokens[:evnt].to_i
        }
        entries << entry
        event = {
          pos: tokens[:evnt].to_i,
          distance: tokens[:dist].to_i,
          stroke: tokens[:stro].to_i,
          gender: tokens[:esex],
        }
        events << event if not events.include? event
        puts format.text
      else
        0
      end
    end
  end
end



#############################################################################
##
##	  A0 -- File Description Record
##
##	       Purpose:  Identify the file and the type of data to be
##			 transmitted.  Contact person and phone number
##			 included to assist with use of information on the
##			 file.
##
##	  This record is mandatory for each transfer of data within this
##	  file structure.  Each file begins with this record and each file
##	  has only one record of this type.  
##
##	  start/   
##	  length   Mand   Type   Description
##	 ----------------------------------------------------------------
##	  1/2       M1*   CONST  "A0"
##
##	  3/1       M2*   CODE   ORG Code 001, table checked
##
##	  4/8             ALPHA  SDIF version number (same format as the 
##				 version number from the title page)
##
##	  12/2      M1*   CODE   FILE Code 003, table checked
##
##	  14/30                  future use
##
##	  44/20      *    ALPHA  software name
##
##	  64/10      *    ALPHA  software version
##
##	  74/20     M1*   ALPHA  contact name (person supplying or
##				 sending data)
##
##	  94/12     M1*   PHONE  contact phone (area code and phone
##				 number of contact name in 74/20)
##
##	  106/8     M1*   DATE   file creation or update
##
##	  114/42                 future use
##	  
##	  156/2           ALPHA  submitted by LSC - for Top 16
##
##	  158/3                  future use
##
##
##	  * required field for submission of registration data to LSC
##
SDIF["A0"] = { 
  keys: [:mark, :orgc, :vers, :filc, :gap0, :snam, :sver, :cnam, :cpho, :date, :gap1, :subm, :gap2],
  lens: [    2,     1,     8,     2,    30,    20,    10,    20,    12,     8,    42,     2,     3],
}

#############################################################################
##
##	  B1 -- Meet Record
##
##	       Purpose:  Identify the meet name, address, and dates.
##
##	  This record is used to identify the meet name and address.  The
##	  meet name is required, plus the city, state, meet type, start
##	  and end dates.  Additional fields provide for the street address,
##	  postal code and country code.  Each file may only have one
##	  record of this type.
##
##	  start/   
##	  length   Mand   Type   Description
##	 ----------------------------------------------------------------
##	  1/2      M1     CONST  "B1"
##
##	  3/1      M2     CODE   ORG Code 001, table checked
##
##	  4/8                    future use
##
##	  12/30    M1     ALPHA  meet name
##
##	  42/22           ALPHA  meet address line one
##
##	  64/22           ALPHA  meet address line two
##
##	  86/20    M2     ALPHA  meet city
##
##	  106/2    M2     USPS   meet state
##
##	  108/10          ALPHA  Postal Code, meet zip or foreign code
##
##	  118/3           CODE   COUNTRY Code 004, table checked
##
##	  121/1    M2     CODE   MEET Code 005, table checked
##
##	  122/8    M1     DATE   meet start
##
##	  130/8    M2     DATE   meet end
##
##	  138/4           INT    altitude of pool in feet above sea level
##
##	  142/8                  future use
##
##	  150/1           CODE   COURSE Code 013, table checked, default
##				 course set up in exporting software
##
##	  151/10                 future use
##
SDIF["B1"] = {
  keys: [:mark, :orgc, :gap0, :name, :adr1, :adr2, :city, :stat, :zipc, :ctry, :meet, :dat0, :dat1, :alti, :gap1, :crse, :gap2],
  lens: [    2,     1,     8,    30,    22,    22,    20,     2,    10,     3,     1,     8,     8,     4,     8,     1,    10],
}

#############################################################################
##
##	  C1 -- Team Id Record
##
##	       Purpose:  Identify the team name, code and address.  Region
##			 code defines USS region for team.
##
##	  This record is used to identify the team name, team code, plus
##	  region.  When used, more than one team record can be transmitted
##	  for a single meet.  The team name, USS team code and team
##	  abbreviation are required.  The USS region code is also required.
##	  Additional fields provide for the street address, city, state,
##	  postal code, and country code.
##
##	  start/   
##	  length   Mand   Type   Description
##	 ----------------------------------------------------------------
##	  1/2      M1     CONST  "C1"
##
##	  3/1      M2     CODE   ORG Code 001, table checked
##
##	  4/8                    future use
##
##	  12/6     M1     CODE   TEAM Code 006
##
##	  18/30    M1     ALPHA  full team name
##
##	  48/16           ALPHA  abbreviated team name
##
##	  64/22           ALPHA  team address line one
##
##	  86/22           ALPHA  team address line two
##
##	  108/20          ALPHA  team city
##
##	  128/2           USPS   team state
##
##	  130/10          ALPHA  Postal Code, team zip or foreign code
##
##	  140/3           CODE   COUNTRY Code 004, table checked
##
##	  143/1           CODE   REGION Code 007, table checked
##
##	  144/6                  future use
##
##	  150/1           ALPHA  optional 5th char of team code
##
##	  151/10                  future use
##
##	  TEAM Code 006     LSC and Team code
##	       Supplied from USS Headquarters files upon request.
##	       Concatenation of two-character LSC code and four-character
##	       Team code, in that order (e.g., Colorado's FAST would be
##	       COFAST).  The code for Unattached should always be UN, and
##	       not any other abbreviation.  (Florida Gold's unattached
##	       would be FG  UN.)
##
SDIF["C1"] = {
  keys: [:mark, :orgc, :gap0, :team, :name, :abbr, :adr1, :adr2, :city, :stat, :zipc, :ctry, :rgon, :gap1, :five, :gap2],
  lens: [    2,     1,     8,     6,    30,    16,    22,    22,    20,     2,    10,     3,     1,     6,     1,    10],
}

#############################################################################
##
##	  D0 -- Individual Event Record
##
##	       Purpose:  Identify the athlete by name, registration number,
##			 birth date and gender.  Identify the stroke,
##			 distance, event number and time of the swims.
##
##	  This record is used to identify the athlete and the individual
##	  event.  When used, one individual event record would be
##	  submitted for each swimmer entered in an individual event.  The
##	  athlete name, USS registration number, birth date and gender
##	  code are required.  Fields for the stroke, distance, event
##	  number, age range, and date of swim are also required.
##	  Additional fields provide for the citizenship, age or class, 
##	  seed time, prelim time, swim off time, finals time and pool
##	  lanes used in competition.
##
##	  NOTE:  Individual event records must be preceded by at least one
##	  C1 team ID record and one C2 team entry record.  If these two 
##	  records are missing, the individual is assumed to be attached
##	  to the previous "team" that has proper coding.  Athlete
##	  registration data is not available to meet management programs
##	  and proper coding is essential.
##
##	  start/   
##	  length   Mand   Type   Description
##	 ----------------------------------------------------------------
##	  1/2      M1     CONST  "D0"
##
##	  3/1      M2     CODE   ORG Code 001, table checked
##
##	  4/8                    future use
##
##	  12/28    M1     NAME   swimmer name 
##
##	  40/12    M2     ALPHA  USS#
##
##	  52/1            CODE   ATTACH Code 016, table checked
##
##	  53/3            CODE   CITIZEN Code 009, table checked
##
##	  56/8     M2     DATE   swimmer birth date
##
##	  64/2            ALPHA  swimmer age or class (such as Jr or Sr)
##	  
##	  66/1     M1     CODE   SEX Code 010, table checked
##
##	  67/1     M1#    CODE   EVENT SEX Code 011, table checked
##
##	  68/4     M1#    INT    event distance
##
##	  72/1     M1#    CODE   STROKE Code 012, table checked
##
##	  73/4            ALPHA  Event Number
##
##	  77/4     M1#    CODE   EVENT AGE Code 025, table checked
##
##	  81/8     M2     DATE   date of swim
##
##	  89/8            TIME   seed time
##
##	  97/1      *     CODE   COURSE Code 013, table checked
##
##	  98/8            TIME   prelim time
##
##	  106/1     *     CODE   COURSE Code 013, table checked
##
##	  107/8           TIME   swim-off time
##
##	  115/1     *     CODE   COURSE Code 013, table checked
##
##	  116/8           TIME   finals time
##
##	  124/1     *     CODE   COURSE Code 013, table checked
##
##	  125/2           INT    prelim heat number
##
##	  127/2           INT    prelim lane number
##
##	  129/2           INT    finals heat number
##
##	  131/2           INT    finals lane number
##
##	  133/3     **    INT    prelim place ranking
##	  
##	  136/3     **    INT    finals place ranking
##
##	  139/4     **    DEC    points scored from finals
##
##	  143/2           CODE   EVENT TIME CLASS Code 014, table checked
##
##	  145/1           ALPHA  flight status of swimmer (subdivision
##				 of Time Standard)
##
##	  146/15                 future use
##	  
##	  
##	  *  This field is mandatory IF the immediately preceding time
##	     field is NOT blank
##	  
##	  ** This field is mandatory (M1) if a championship meet 
##	     (MEET Code 005 - 6,7)         
##
##	  #  Event age code 025, event sex code 011, event distance, 
##	     stroke code 012 and seed time are not mandatory (M1) 
##	     for relay only swimmers.          
##
##	  Note - An additional record type will be used for open water
##		  swimming.  Multiple swim offs require multiple records.
##
SDIF["D0"] = {
  keys: [:mark, :orgc, :gap0, :name, :siid, :atch, :citz, :dofb, :agen, :ssex, :esex, :dist, :stro, :evnt, :ages, :date, :tim0, :crs0, :tim1, :crs1, :tim2, :crs2, :tim3, :crs3, :hea1, :lan1, :hea2, :lan2, :plc1, :plc2, :pnts, :strd, :flgh, :gap1],
  lens: [    2,     1,     8,    28,    12,     1,     3,     8,     2,     1,     1,     4,     1,     4,     4,     8,     8,     1,     8,     1,     8,     1,     8,     1,     2,     2,     2,     2,     3,     3,     4,     2,     1,    15],
}

#############################################################################
##
##	  D3 -- Individual Information Record
##
##	       Purpose: Contains additional information that is not 
##			included in pre version 3 SDI formats.
##	  
##	  This record provides space for the new USS# as well as the 
##	  swimmers preferred first name. For meet files this record will 
##	  follow the D0 record and the F0 record if relays are included.
##	  A swimmer with multiple D0 records will have one D3 record 
##	  following his/her first D0 record.
##
##	  start/
##	  length   Mand   Type    Description
##	 ---------------------------------------------------------------- 
##	  1/2      M1     CONST   "D3"
##	  
##	  3/14     M2     USSNUM  USS# (new)
##
##	  17/15           ALPHA   preferred first name
##     
##	  32/2      *     CODE    ethnicity code 026
##	  
##	  34/1      *     LOGICAL Junior High School                
##	  
##	  35/1      *     LOGICAL Senior High School
##	  
##	  36/1      *     LOGICAL YMCA/YWCA
##	  
##	  37/1      *     LOGICAL College
##	  
##	  38/1      *     LOGICAL Summer Swim League
##	  
##	  39/1      *     LOGICAL Masters
##	  
##	  40/1      *     LOGICAL Disabled Sports Organizations
##	  
##	  41/1      *     LOGICAL Water Polo
##	  
##	  42/1      *     LOGICAL None
##	  
##	  43/118                  future use
##
##	  * Required for submission of registration data to an LSC
##
SDIF["D3"] = {
  keys: [:mark, :siid, :frst, :ethn, :junr, :senr, :ymca, :coll, :summ, :mstr, :dabl, :polo, :none, :gap0],
  lens: [    2,    14,    15,     2,     1,     1,     1,     1,     1,     1,     1,     1,     1,   118],
}

#############################################################################
##
##	  Z0 -- File Terminator Record
##
##	       Purpose:  Identify the logical end of file for a file
##			 transmission.  Record statistics and swim
##			 statistics are listed for convenience.
##
##	  This record is mandatory in each file.  Each file ends with this
##	  record and each file has only one record of this type.  The first
##	  four fields are mandatory.  Additional fields provide for text
##	  and record counts.
##
##	  start/   
##	  length   Mand   Type   Description
##	 ----------------------------------------------------------------
##	  1/2      M1     CONST  "Z0"
##
##	  3/1      M2     CODE   ORG Code 001, table checked
##
##	  4/8                    future use
##
##	  12/2     M1     CODE   FILE Code 003, table checked
##
##	  14/30           ALPHA  notes (additional file info)
##
##	  44/3            INT    number of B records
##
##	  47/3            INT    number of different meets
##
##	  50/4            INT    number of C records
##
##	  54/4            INT    number of different teams
##
##	  58/6            INT    number of D records
##
##	  64/6            INT    number of different swimmers
##
##	  70/5            INT    number of E records
##
##	  75/6            INT    number of F records
##
##	  81/6            INT    number of G records
##
##	  87/5            INT    batch number
##	  
##	  92/3            INT    number of new members
##
##	  95/3            INT    number of renew members
##
##	  98/3            INT    number of member changes
##
##	  101/3           INT    number of member deletes
##
##	  104/57                 future use
##
SDIF["Z0"] = {
  keys: [:mark, :orgc, :gap0, :filc, :note, :nrbs, :nrms, :nrcs, :nrts, :nrds, :nrss, :nres, :nrfs, :nrgs, :btch, :news, :rens, :chgs, :dels, :gap1],
  lens: [    2,     1,     8,     2,    30,     3,     3,     4,     4,     6,     6,     5,     6,     6,     5,     3,     3,     3,     3,    57],
}


Format.read_entry_file ARGV[0]


def later
  object = Swimmer.find_by_number(swimmer[:number]) if swimmer[:number].present?
  if object
    puts "Swimmer #{object.name} found by their id. #{swimmer.inspect}"
  else
    object = Swimmer.where(swimmer.slice(:birthday, :first, :gender)).first
    if object
      puts "Swimmer #{object.name} found by their date of birth. #{swimmer.inspect}"
    end
  end
end
