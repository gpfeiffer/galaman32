#############################################################################
##
##  Standard Data Interchange Format  Ver. 3.0 (official) April 28, 1998
##
##

#############################################################################
class Format
  def self.checksum line
    (line[0, 2] == 'D0' ? 'NN' : ' N') + 
      ("%02d" % ((line[0, 156].bytes.inject(:+) + 211) / 19 % 100)).reverse
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
class RecordA0 < Format
  attr_reader :orgc, :vers, :filc, :gap0, :snam, :sver, :cnam, :cpho, :date, :gap1, :subm, :gap2

  def initialize text
    @orgc = text[2, 1]         # 3/1       M2*   CODE   ORG Code 001, table checked
    @vers = text[3, 8].strip   # 4/8              ALPHA  SDIF version number
    @filc = text[11, 2]        # 12/2      M1*   CODE   FILE Code 003, table checked
    @gap0 = text[13, 30]       # 14/30                  future use: 'Meet Results                  '
    @snam = text[43, 20].strip # 44/20      *    ALPHA  software name
    @sver = text[63, 10].strip # 64/10      *    ALPHA  software version
    @cnam = text[73, 20].strip # 74/20     M1*   ALPHA  contact name
    @cpho = text[93, 12].strip # 94/12     M1*   PHONE  contact phone
    @date = text[105, 8]       # 106/8     M1*   DATE   file creation or update
    @gap1 = text[113, 42]      # 114/42                 future use: "                                    MM40  "
    @subm = text[155, 2]       # 156/2           ALPHA  submitted by LSC - for Top 16
    @gap2 = text[157, 3]       # 158/3                  future use: checksum
  end

  def to_s
    "A0%1s%-8s%2s%-30s%-20s%-10s%-20s%-12s%8s%-42s%2s%3s" % [orgc, vers, filc, gap0, snam, sver, cnam, cpho, date, gap1, subm, gap2]
  end
end

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
class RecordB1 < Format
  attr_reader :orgc, :gap0, :name, :adr1, :adr2, :city, :stat, :zipc, :ctry, :meet, :dat0, :dat1, :alti, :gap1, :crse, :gap2

  def initialize text
    @orgc = text[2, 1]          # 3/1      M2     CODE   ORG Code 001, table checked
    @gap0 = text [3, 8]         # 4/8                    future use
    @name = text[11, 30].strip  # 12/30    M1     ALPHA  meet name
    @adr1 = text[41, 22].strip  # 42/22           ALPHA  meet address line one
    @adr2 = text[63, 22].strip  # 64/22           ALPHA  meet address line two
    @city = text[85, 20].strip  # 86/20    M2     ALPHA  meet city
    @stat = text[105, 2]        # 106/2    M2     USPS   meet state
    @zipc = text[107, 10].strip # 108/10          ALPHA  Postal Code, meet zip or foreign code
    @ctry = text[117, 3]        # 118/3           CODE   COUNTRY Code 004, table checked
    @meet = text[120, 1]        # 121/1    M2     CODE   MEET Code 005, table checked
    @dat0 = text[121, 8]        # 122/8    M1     DATE   meet start
    @dat1 = text[129, 8]        # 130/8    M2     DATE   meet end
    @alti = text[137, 4]        # 138/4           INT    altitude of pool in feet above sea level
    @gap1 = text[141, 8]        # 142/8                  future use
    @crse = text[149, 1]        # 150/1           CODE   COURSE Code 013, table checked
    @gap2 = text[150, 10]       # 151/10                 future use
  end

  def to_s
    "B1%1s%8s%-30s%-22s%-22s%-20s%2s%-10s%3s%1s%8s%8s%4s%8s%1s%10s" % [orgc, gap0, name, adr1, adr2, city, stat, zipc, ctry, meet, dat0, dat1, alti, gap1, crse, gap2]
  end

  def competition
    HyCompetition.new name, adr1, dat0
  end
end

class HyCompetition
  attr_reader :name, :location, :date

  def initialize name, location, date
    @name = name
    @location = location
    @date = date
  end
end

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
class RecordC1 < Format
  attr_reader :orgc, :gap0, :team, :name, :abbr, :adr1, :adr2, :city, :stat, :zipc, :ctry, :rgon, :gap1, :five, :gap2

  def initialize text
    @orgc = text[2, 1]         # 3/1      M2     CODE   ORG Code 001, table checked
    @gap0 = text[3,8]          # 4/8                    future use
    @team = text[11, 6]        # 12/6     M1     CODE   TEAM Code 006
    @name = text[17, 30].strip # 18/30    M1     ALPHA  full team name
    @abbr = text[47, 16].strip # 48/16           ALPHA  abbreviated team name
    @adr1 = text[63, 22]       # 64/22           ALPHA  team address line one
    @adr2 = text[85, 22]       # 86/22           ALPHA  team address line two
    @city = text[107, 20]      # 108/20          ALPHA  team city
    @stat = text[127, 2]       # 128/2           USPS   team state
    @zipc = text[129, 10]      # 130/10          ALPHA  Postal Code, team zip or foreign code
    @ctry = text[139, 3]       # 140/3           CODE   COUNTRY Code 004, table checked
    @rgon = text[142, 1]       # 143/1           CODE   REGION Code 007, table checked
    @gap1 = text[143,6]        # 144/6                  future use
    @five = text[149, 1]       # 150/1           ALPHA  optional 5th char of team code
    @gap2 = text[150, 10]      # 151/10                  future use
  end

  def code
    (team[2..-1] + five).strip
  end

  def contact
    "#{adr1}\n#{adr2}\n#{city}\n#{zipc}\n#{ctry}"
  end

  def club
    HyClub.new name, abbr, code, contact
  end
end


class HyClub
  @@all = []

  def self.all
    @@all
  end

  def index
    @@all.index self
  end

  def initialize name, abbr, code, contact
    @name = name
    @abbr = abbr
    @code = code
    @contact = contact
  end

  def self.find name
    club = self.new name
    if pos = club.index
      club = self.all[pos]
    else
      self.all << club
    end
    return club 
  end

  attr_reader :name

  def == other
    self.name == other.name
  end
end


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
class SwimmerRecord
  attr_reader :name, :siid, :atch, :citz, :dofb, :agen, :ssex

  def initialize(name, siid, dofb, agen, ssex, atch = 'A', citz = '')
    @name = name
    @siid = siid
    @atch = atch
    @citz = citz
    @dofb = dofb
    @agen = agen
    @ssex = ssex
  end


  ##  FIXME:  what do we do if the input is not as expected?
  def self.parse text
    name = text[11-11, 28].strip  # 12/28    M1     NAME   swimmer name 
    siid = text[39-11, 12].strip  # 40/12    M2     ALPHA  USS#
    atch = text[51-11, 1].strip   # 52/1            CODE   ATTACH Code 016, table checked
    citz = text[52-11, 3].strip   # 53/3            CODE   CITIZEN Code 009, table checked 
    dofb = text[55-11, 8]         # 56/8     M2     DATE   swimmer birth date
    agen = text[63-11, 2].to_i    # 64/2            ALPHA  swimmer age or class (such as Jr or Sr)
    ssex = text[65-11, 1].strip   # 66/1     M1     CODE   SEX Code 010, table checked
    new(name, siid, Date.strptime(dofb , '%m%d%Y'), agen, ssex, atch, citz)
  end

  def to_text
    text = ""
    text += "%-28s" % name[0,28]
    text += "%-12s" % siid[0,12]
    text += "%1s" % atch[0,1]
    text += "%3s" % citz[0,3]
    text += dofb.strftime('%m%d%Y')
    text += "%2d" % agen
    text += "%1s" % ssex[0,1]
  end
end

class RecordD0
  attr_reader :orgc, :gap0, :name, :siid, :atch, :citz, :dofb, :agen, :ssex, :esex, :dist, :stro, :evnt, :ages, :date, :tim0, :crs0, :tim1, :crs1, :tim2, :crs2, :tim3, :crs3, :hea1, :lan1, :hea2, :lan2, :plc1, :plc2, :pnts, :strd, :flgh, :gap1

  def initialize text
    @orgc = text[2, 1] # 3/1      M2     CODE   ORG Code 001, table checked
    @gap0 = text[3, 8] # 4/8                    future use
    @name = text[11, 28] # 12/28    M1     NAME   swimmer name 
    @siid = text[39, 12] # 40/12    M2     ALPHA  USS#
    @atch = text[51, 1] # 52/1            CODE   ATTACH Code 016, table checked
    @citz = text[52, 3] # 53/3            CODE   CITIZEN Code 009, table checked
    @dofb = text[55, 8] # 56/8     M2     DATE   swimmer birth date
    @agen = text[63, 2] # 64/2            ALPHA  swimmer age or class (such as Jr or Sr)
    @ssex = text[65, 1] # 66/1     M1     CODE   SEX Code 010, table checked
    @esex = text[66, 1] # 67/1     M1#    CODE   EVENT SEX Code 011, table checked
    @dist = text[67, 4] # 68/4     M1#    INT    event distance
    @stro = text[71, 1] # 72/1     M1#    CODE   STROKE Code 012, table checked
    @evnt = text[72, 4] # 73/4            ALPHA  Event Number
    @ages = text[76, 4] # 77/4     M1#    CODE   EVENT AGE Code 025, table checked
    @date = text[80, 8] # 81/8     M2     DATE   date of swim
    @tim0 = text[88, 8] # 89/8            TIME   seed time
    @crs0 = text[96, 1] # 97/1      *     CODE   COURSE Code 013, table checked
    @tim1 = text[97, 8] # 98/8            TIME   prelim time
    @crs1 = text[105, 1] # 106/1     *     CODE   COURSE Code 013, table checked
    @tim2 = text[106, 8] # 107/8           TIME   swim-off time
    @crs2 = text[114, 1] # 115/1     *     CODE   COURSE Code 013, table checked
    @tim3 = text[115, 8] # 116/8           TIME   finals time
    @crs3 = text[123, 1] # 124/1     *     CODE   COURSE Code 013, table checked
    @hea1 = text[124, 2] # 125/2           INT    prelim heat number
    @lan1 = text[126, 2] # 127/2           INT    prelim lane number
    @hea2 = text[128, 2] # 129/2           INT    finals heat number
    @lan2 = text[130, 2] # 131/2           INT    finals lane number
    @plc1 = text[132, 3] # 133/3     **    INT    prelim place ranking
    @plc2 = text[135, 3] # 136/3     **    INT    finals place ranking
    @pnts = text[138, 4] # 139/4     **    DEC    points scored from finals
    @strd = text[142, 2] # 143/2           CODE   EVENT TIME CLASS Code 014, table checked
    @flgh = text[144, 1] # 145/1           ALPHA  flight status of swimmer
    @gap1 = text[145, 15] # 146/15                 future use
  end
end


class HyDiscipline
  def initialize distance, stroke
  end
end


class HyEvent

  def initialize pos, discipline
    @pos = pos
    @discipline = discipline
  end
end



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
class RecordD3
  attr_reader :siid, :frst, :ethn, :rest

  def initialize text
    @siid = text[2, 14] # 3/14     M2     USSNUM  USS# (new)
    @frst = text[16, 15] # 17/15           ALPHA   preferred first name
    @ethn = text[31, 2] # 32/2      *     CODE    ethnicity code 026
    @rest = text[33, 127]
    # ... logical fields omitted ...
  end
end

#############################################################################
##
##	  G0 -- Splits Record
##
##	       Purpose:  Identify the athletes in an event by name and USS
##			 registration number.  Identify the split distance,
##			 number of splits and the split times of the swims.
##
##	  This record is used to identify the athletes in an event and the
##	  split times.  When used, one splits record would be submitted for
##	  each event that an athlete entered in a meet.  The athlete name,
##	  USS registration code, and split distance are required.    
##	  A split type code is required to identify the split
##	  as an interval or cumulative time.  Ten time fields are provided
##	  to record the splits, and multiple records may be used to
##	  complete all splits for a long-distance event.
##
##	  NOTE:  Splits records must be preceded by at least one D0 
##	  individual event record or one F0 relay name record.  If this 
##	  record is missing, there is no way to connect the splits with
##	  the swim.
##
##	  start/   
##	  length   Mand   Type   Description
##	 ----------------------------------------------------------------
##	  1/2      M1     CONST  "G0"
##
##	  3/1      M2     CODE   ORG Code 001, table checked
##
##	  4/12                   future use
##
##	  16/28           NAME   swimmer name.  If name is not available,
##				 enter "NO SWIMMER NAME" or some other
##				 meaningful string
##
##	  44/12           ALPHA  USS#
##
##	  56/1     M1     INT    sequence number to order multiple splits
##				 records for one athlete and one event
##
##	  57/2     M1     INT    total number of splits for this event,
##	  
##	  59/4     M1     INT    split distance
##
##	  63/1     M1     CODE   SPLIT Code 015, table checked
##
##	  64/8            TIME   split time
##
##	  72/8            TIME   split time
##
##	  80/8            TIME   split time
##
##	  88/8            TIME   split time
##
##	  96/8            TIME   split time
##
##	  104/8           TIME   split time
##
##	  112/8           TIME   split time
##
##	  120/8           TIME   split time
##
##	  128/8           TIME   split time
##
##	  136/8           TIME   split time
##
##	  144/1           CODE   PRELIMS/FINALS Code 019, table checked
##
##	  145/16                 future use
##
class RecordG0
  attr_reader :orgc, :gap0, :name, :siid, :seqn, :totl, :dist, :cori, :tim0, :tim1, :tim2, :tim3, :tim4, :tim5, :tim6, :tim7, :tim8, :tim9, :porf, :gap1

  def initialize text
    @orgc = text[2, 1] # 3/1      M2     CODE   ORG Code 001, table checked
    @gap0 = text[3, 12] # 4/12                   future use
    @name = text[15, 28] # 16/28           NAME   swimmer name.  
    @siid = text[43, 12] # 44/12           ALPHA  USS#
    @seqn = text[55, 1] # 56/1     M1     INT    sequence number 
    @totl = text[56, 2] # 57/2     M1     INT    total number of splits for this event,
    @dist = text[58, 4] # 59/4     M1     INT    split distance
    @cori = text[62, 1] # 63/1     M1     CODE   SPLIT Code 015, table checked: Cumulative or Interval
    @tim0 = text[63, 8] # 64/8            TIME   split time
    @tim1 = text[71, 8] # 72/8            TIME   split time
    @tim2 = text[79, 8] # 80/8            TIME   split time
    @tim3 = text[87, 8] # 88/8            TIME   split time
    @tim4 = text[95, 8] # 96/8            TIME   split time
    @tim5 = text[103, 8] # 104/8           TIME   split time
    @tim6 = text[111, 8] # 112/8           TIME   split time
    @tim7 = text[119, 8] # 120/8           TIME   split time
    @tim8 = text[127, 8] # 128/8           TIME   split time
    @tim9 = text[135, 8] # 136/8           TIME   split time
    @porf = text[143, 1] # 144/1           CODE   PRELIMS/FINALS Code 019, table checked
    @gap1 = text[144, 16] # 145/16                 future use
  end
end

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
class RecordZ0
  attr_reader :orgc, :gap0, :filc, :note, :nrbs, :nrms, :nrcs, :nrts, :nrds, :nrss, :nres, :nrfs, :nrgs, :btch, :news, :rens, :chgs, :dels, :gap1

  def initialize text
    @orgc = text[2, 1] # 3/1      M2     CODE   ORG Code 001, table checked
    @gap0 = text[3, 8] # 4/8                    future use
    @filc = text[11, 1] # 12/2     M1     CODE   FILE Code 003, table checked
    @note = text[13, 30] # 14/30           ALPHA  notes (additional file info)
    @nrbs = text[43, 3] # 44/3            INT    number of B records
    @nrms = text[46, 3] # 47/3            INT    number of different meets
    @nrcs = text[49, 4] # 50/4            INT    number of C records
    @nrts = text[53, 4] # 54/4            INT    number of different teams
    @nrds = text[57, 6] # 58/6            INT    number of D records
    @nrss = text[63, 6] # 64/6            INT    number of different swimmers
    @nres = text[69, 5] # 70/5            INT    number of E records
    @nrfs = text[74, 6] # 75/6            INT    number of F records
    @nrgs = text[80, 6] # 81/6            INT    number of G records
    @btch = text[86, 5] # 87/5            INT    batch number
    @news = text[91, 3] # 92/3            INT    number of new members
    @rens = text[94, 3] # 95/3            INT    number of renew members
    @chgs = text[97, 3] # 98/3            INT    number of member changes
    @dels = text[100, 3] # 101/3           INT    number of member deletes
    @gap1 = text[103, 57] # 104/57                 future use
  end
end


class HySwimmer
  @@all = []

  def self.all
    @@all
  end

  def index
    @@all.index self
  end

  def initialize first, last, age, club
    @first  = first.strip
    @last = last.strip
    @age = age.to_i
    @club = club
  end

  def self.find first, last, age, club 
    swimmer = self.new  first, last, age, club
    if pos = swimmer.index
      swimmer = self.all[pos]
    else
      self.all << swimmer
    end
    return swimmer 
  end

  attr_reader :first, :last, :age, :club

  def == other 
    self.first == other.first and
      self.last == other.last and
      self.age == other.age and
      self.club == other.club
  end

  def name 
    "#{first} #{last}"
  end
end

class HyDiscipline
  @@all = []

  def self.all
    @@all
  end

  def index
    @@all.index self
  end

  def initialize stroke, gender, distance, course
    @stroke = stroke.strip
    @gender = gender.strip
    @distance = distance.to_i
    @course = course.strip
  end

  attr_reader :stroke, :gender, :distance, :course

  def == other
    self.stroke == other.stroke and
      self.distance == other.distance and
      self.course == other.course
  end

  def to_s
    "#{distance}m #{stroke} #{gender}"
  end

end

class HyEvent
  @@all = []

  def self.all
    @@all
  end

  def index
    @@all.index self
  end

  def initialize pos, discipline, ages
    @pos = pos.to_i
    @discipline = discipline
    @ages = ages # should be a range
  end

  attr_reader :pos, :discipline, :ages

  def == other
    @pos == other.pos and
      @discipline == other.discipline and
      @ages == other.ages
  end

  def to_s
    "#{pos} #{discipline} (#{ages})"
  end
end


class HyResult
  def initialize event, swimmer, time, plc
    @event = event
    @swimmer = swimmer
    @time = time
    @plc = plc
  end

  attr_reader :event, :swimmer, :time, :plc

  def to_str
    "#{event} #{time} (#{plc}.)"
  end

end

# how to turn 'mm:ss.cc' into centiseconds or 0
def centiseconds string
  sum = 0
  string.split(/[:\.]/).reverse.each_with_index do |digit, index|
    sum += digit.to_i * [1, 100, 6000][index]
  end
  sum
end

def time_to_s time
  ss, cc = time.divmod 100
  mm, ss = ss.divmod 60
  (mm > 0 ? '%2d:%02d' % [mm, ss] : '%5d' % ss) + '.%02d' % cc
end

def age_to_s age
  case age
  when 0
    "UN"
  when 99
    "OV"
  else
    "%02d" % age
  end
end

class HyTime

  attr_reader :time, :comm, :sorl

  # make one from a 9 letter text mm:ss.ccC
  def initialize text
    mm, ss, cc = (0..2).map { |n| text[3*n, 2].to_i }
    @time =  100 * (60 * mm + ss) + cc
    @comm = (@time == 0 ? text[0..7].strip : "")
    @sorl = text[8..-1] # 'S'hort or 'L'ong
  end

  def to_s
    (time == 0 ? "%8s" % comm : time_to_s(time)) + sorl
  end
end


class HyD
  attr_reader :name, :siid, :dofb, :agen, :ffmm, :dist, :stro, :evnt, :ages, :date, :seed, :rslt, :cmmt, :heat, :lane, :plce, :plht

  # build an object from a line in a cl2 file
  def initialize line
    if line[1, 2] == '08' 
      @gap0 = line[3, 8] # unused?
      name = line[11, 28].split(",") # last, first
      @frst = name[1].strip
      @last = name[0].strip
      @siid = line[39, 8] # Swim Ireland ID
      @gap1 = line[47, 8] # => '    A   '
      @dofb = line[55, 8] # date of birth ddmmyyyy
      @agen = line[63, 2].to_i # age at gala
      @ffmm = line[65, 2] # gender, why double letters?
      @dist = line[67, 4].to_i # distance in meters
      @stro = line[71, 1].to_i # stroke 1 = free, ..., 5 = medley
      @evnt = line[72, 4].strip # event number seea: s=session or empty, ee=event no, a=age group
      amin = line[76, 2] # minimum age, UN = 0 
      amin = (amin == 'UN' ? 0 : amin.to_i)
      amax = line[78, 2] # maximum age, OV = 99
      amax = (amax == 'OV' ? 99 : amax.to_i)
      @ages = (amin..amax)
      @date = line[80, 8] # date of event
      @seed = HyTime.new line[88, 9] # can be empty (= NT)
      @tim1 = HyTime.new line[97, 9] # prelim time?
      @tim2 = HyTime.new line[106, 9] # another time?
      @rslt = HyTime.new line[115, 9] # time or DQ, DNF, NS, ...
      @hea0 = line[124, 2].to_i # prelim heat
      @lan0 = line[126, 2].to_i # prelim lane
      @heat = line[128, 2].to_i
      @lane = line[130, 2].to_i
      @plc0 = line[132, 4].to_i # prelim place
      @plce = line[136, 2].to_i
      @plht = line[138, 8].to_i # place in heat.
      # line[146, 3] => 400 ????
      # line[149, 1] => @stro ????
      # line[150, 6] => '      '
      # line[156, 4] checksum?
    end
  end

  # reproduce original text
  def to_s
    text = 'D08' +
      ' ' * 8 + 
      "%-28s" % "#{@last}, #{@frst}" + 
      @siid +
      '    A   ' +
      @dofb +
      "%2d" % @agen + 
      @ffmm + 
      "%4d" % @dist +
      "%1d" % @stro +
      "%4s" % @evnt +
      age_to_s(@ages.min) + 
      age_to_s(@ages.max) +
      @date +
      time_to_s(@seed)
  end
  
  # how to calculate the checksum
  def checksum line
    (line[0, 2] == 'D0' ? 'N' : ' ') + 
      ("N%02d" % ((line[0, 156].bytes.inject(:+) + 211) / 19 % 100)).reverse
  end


end


# how to parse results file.
def read_results
  if ARGV.count > 0
    f = File.open(ARGV[0])
  else
    f = File.open("input.cl2")
  end

  records = []

  f.lines.each do |line|
    case line[0, 2]
    when 'A0'
      records << RecordA0.new(line)
    when 'B1'
      records << RecordB1.new(line)
    when 'C1'
      records << RecordC1.new(line)
    when 'D0'
      records << RecordD0.new(line)
    when 'D3'
      records << RecordD3.new(line)
    when 'G0'
      records << RecordG0.new(line)
    when 'Z0'
      records << RecordZ0.new(line)
    else
      puts 'record type #{line[0, 2]} unknown'
    end
  end

  lines = File.readlines("input.cl2")

  f.close
  [records, lines]
end  

#records = read_results
