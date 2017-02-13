#############################################################################
##
##  Standard Data Interchange Format  Ver. 3.0 (official) April 28, 1998
##
##
SDIF = {}

#############################################################################
##
##        A0 -- File Description Record
##
##             Purpose:  Identify the file and the type of data to be
##                       transmitted.  Contact person and phone number
##                       included to assist with use of information on the
##                       file.
##
##        This record is mandatory for each transfer of data within this
##        file structure.  Each file begins with this record and each file
##        has only one record of this type.
##
##        start/
##        length   Mand   Type   Description
##       ----------------------------------------------------------------
##        1/2       M1*   CONST  "A0"
##
##        3/1       M2*   CODE   ORG Code 001, table checked
##
##        4/8             ALPHA  SDIF version number (same format as the
##                               version number from the title page)
##
##        12/2      M1*   CODE   FILE Code 003, table checked
##
##        14/30                  future use
##
##        44/20      *    ALPHA  software name
##
##        64/10      *    ALPHA  software version
##
##        74/20     M1*   ALPHA  contact name (person supplying or
##                               sending data)
##
##        94/12     M1*   PHONE  contact phone (area code and phone
##                               number of contact name in 74/20)
##
##        106/8     M1*   DATE   file creation or update
##
##        114/42                 future use
##
##        156/2           ALPHA  submitted by LSC - for Top 16
##
##        158/3                  future use
##
##
##        * required field for submission of registration data to LSC
##
SDIF["A0"] = {
  keys: [:mark, :orgc, :vers, :filc, :gap0, :snam, :sver, :cnam, :cpho, :date, :gap1, :subm, :gap2],
  lens: [    2,     1,     8,     2,    30,    20,    10,    20,    12,     8,    42,     2,     3],
}

#############################################################################
##
##        B1 -- Meet Record
##
##             Purpose:  Identify the meet name, address, and dates.
##
##        This record is used to identify the meet name and address.  The
##        meet name is required, plus the city, state, meet type, start
##        and end dates.  Additional fields provide for the street address,
##        postal code and country code.  Each file may only have one
##        record of this type.
##
##        start/
##        length   Mand   Type   Description
##       ----------------------------------------------------------------
##        1/2      M1     CONST  "B1"
##
##        3/1      M2     CODE   ORG Code 001, table checked
##
##        4/8                    future use
##
##        12/30    M1     ALPHA  meet name
##
##        42/22           ALPHA  meet address line one
##
##        64/22           ALPHA  meet address line two
##
##        86/20    M2     ALPHA  meet city
##
##        106/2    M2     USPS   meet state
##
##        108/10          ALPHA  Postal Code, meet zip or foreign code
##
##        118/3           CODE   COUNTRY Code 004, table checked
##
##        121/1    M2     CODE   MEET Code 005, table checked
##
##        122/8    M1     DATE   meet start
##
##        130/8    M2     DATE   meet end
##
##        138/4           INT    altitude of pool in feet above sea level
##
##        142/8                  future use
##
##        150/1           CODE   COURSE Code 013, table checked, default
##                               course set up in exporting software
##
##        151/10                 future use
##
SDIF["B1"] = {
  keys: [:mark, :orgc, :gap0, :name, :adr1, :adr2, :city, :stat, :zipc, :ctry, :meet, :dat0, :dat1, :alti, :gap1, :crse, :gap2],
  lens: [    2,     1,     8,    30,    22,    22,    20,     2,    10,     3,     1,     8,     8,     4,     8,     1,    10],
}

#############################################################################
##
##        C1 -- Team Id Record
##
##             Purpose:  Identify the team name, code and address.  Region
##                       code defines USS region for team.
##
##        This record is used to identify the team name, team code, plus
##        region.  When used, more than one team record can be transmitted
##        for a single meet.  The team name, USS team code and team
##        abbreviation are required.  The USS region code is also required.
##        Additional fields provide for the street address, city, state,
##        postal code, and country code.
##
##        start/
##        length   Mand   Type   Description
##       ----------------------------------------------------------------
##        1/2      M1     CONST  "C1"
##
##        3/1      M2     CODE   ORG Code 001, table checked
##
##        4/8                    future use
##
##        12/6     M1     CODE   TEAM Code 006
##
##        18/30    M1     ALPHA  full team name
##
##        48/16           ALPHA  abbreviated team name
##
##        64/22           ALPHA  team address line one
##
##        86/22           ALPHA  team address line two
##
##        108/20          ALPHA  team city
##
##        128/2           USPS   team state
##
##        130/10          ALPHA  Postal Code, team zip or foreign code
##
##        140/3           CODE   COUNTRY Code 004, table checked
##
##        143/1           CODE   REGION Code 007, table checked
##
##        144/6                  future use
##
##        150/1           ALPHA  optional 5th char of team code
##
##        151/10                  future use
##
##        TEAM Code 006     LSC and Team code
##             Supplied from USS Headquarters files upon request.
##             Concatenation of two-character LSC code and four-character
##             Team code, in that order (e.g., Colorado's FAST would be
##             COFAST).  The code for Unattached should always be UN, and
##             not any other abbreviation.  (Florida Gold's unattached
##             would be FG  UN.)
##
SDIF["C1"] = {
  keys: [:mark, :orgc, :gap0, :team, :name, :abbr, :adr1, :adr2, :city, :stat, :zipc, :ctry, :rgon, :gap1, :five, :gap2],
  lens: [    2,     1,     8,     6,    30,    16,    22,    22,    20,     2,    10,     3,     1,     6,     1,    10],
}

#############################################################################
##
##        D0 -- Individual Event Record
##
##             Purpose:  Identify the athlete by name, registration number,
##                       birth date and gender.  Identify the stroke,
##                       distance, event number and time of the swims.
##
##        This record is used to identify the athlete and the individual
##        event.  When used, one individual event record would be
##        submitted for each swimmer entered in an individual event.  The
##        athlete name, USS registration number, birth date and gender
##        code are required.  Fields for the stroke, distance, event
##        number, age range, and date of swim are also required.
##        Additional fields provide for the citizenship, age or class,
##        seed time, prelim time, swim off time, finals time and pool
##        lanes used in competition.
##
##        NOTE:  Individual event records must be preceded by at least one
##        C1 team ID record and one C2 team entry record.  If these two
##        records are missing, the individual is assumed to be attached
##        to the previous "team" that has proper coding.  Athlete
##        registration data is not available to meet management programs
##        and proper coding is essential.
##
##        start/
##        length   Mand   Type   Description
##       ----------------------------------------------------------------
##        1/2      M1     CONST  "D0"
##
##        3/1      M2     CODE   ORG Code 001, table checked
##
##        4/8                    future use
##
##        12/28    M1     NAME   swimmer name
##
##        40/12    M2     ALPHA  USS#
##
##        52/1            CODE   ATTACH Code 016, table checked
##
##        53/3            CODE   CITIZEN Code 009, table checked
##
##        56/8     M2     DATE   swimmer birth date
##
##        64/2            ALPHA  swimmer age or class (such as Jr or Sr)
##
##        66/1     M1     CODE   SEX Code 010, table checked
##
##        67/1     M1#    CODE   EVENT SEX Code 011, table checked
##
##        68/4     M1#    INT    event distance
##
##        72/1     M1#    CODE   STROKE Code 012, table checked
##
##        73/4            ALPHA  Event Number
##
##        77/4     M1#    CODE   EVENT AGE Code 025, table checked
##
##        81/8     M2     DATE   date of swim
##
##        89/8            TIME   seed time
##
##        97/1      *     CODE   COURSE Code 013, table checked
##
##        98/8            TIME   prelim time
##
##        106/1     *     CODE   COURSE Code 013, table checked
##
##        107/8           TIME   swim-off time
##
##        115/1     *     CODE   COURSE Code 013, table checked
##
##        116/8           TIME   finals time
##
##        124/1     *     CODE   COURSE Code 013, table checked
##
##        125/2           INT    prelim heat number
##
##        127/2           INT    prelim lane number
##
##        129/2           INT    finals heat number
##
##        131/2           INT    finals lane number
##
##        133/3     **    INT    prelim place ranking
##
##        136/3     **    INT    finals place ranking
##
##        139/4     **    DEC    points scored from finals
##
##        143/2           CODE   EVENT TIME CLASS Code 014, table checked
##
##        145/1           ALPHA  flight status of swimmer (subdivision
##                               of Time Standard)
##
##        146/15                 future use
##
##
##        *  This field is mandatory IF the immediately preceding time
##           field is NOT blank
##
##        ** This field is mandatory (M1) if a championship meet
##           (MEET Code 005 - 6,7)
##
##        #  Event age code 025, event sex code 011, event distance,
##           stroke code 012 and seed time are not mandatory (M1)
##           for relay only swimmers.
##
##        Note - An additional record type will be used for open water
##                swimming.  Multiple swim offs require multiple records.
##
SDIF["D0"] = {
  keys: [:mark, :orgc, :gap0, :name, :siid, :atch, :citz, :dofb, :agen, :ssex, :esex, :dist, :stro, :evnt, :ages, :date, :tim0, :crs0, :tim1, :crs1, :tim2, :crs2, :tim3, :crs3, :hea1, :lan1, :hea2, :lan2, :plc1, :plc2, :pnts, :strd, :flgh, :gap1],
  lens: [    2,     1,     8,    28,    12,     1,     3,     8,     2,     1,     1,     4,     1,     4,     4,     8,     8,     1,     8,     1,     8,     1,     8,     1,     2,     2,     2,     2,     3,     3,     4,     2,     1,    15],
}

#############################################################################
##
##        D3 -- Individual Information Record
##
##             Purpose: Contains additional information that is not
##                      included in pre version 3 SDI formats.
##
##        This record provides space for the new USS# as well as the
##        swimmers preferred first name. For meet files this record will
##        follow the D0 record and the F0 record if relays are included.
##        A swimmer with multiple D0 records will have one D3 record
##        following his/her first D0 record.
##
##        start/
##        length   Mand   Type    Description
##       ----------------------------------------------------------------
##        1/2      M1     CONST   "D3"
##
##        3/14     M2     USSNUM  USS# (new)
##
##        17/15           ALPHA   preferred first name
##
##        32/2      *     CODE    ethnicity code 026
##
##        34/1      *     LOGICAL Junior High School
##
##        35/1      *     LOGICAL Senior High School
##
##        36/1      *     LOGICAL YMCA/YWCA
##
##        37/1      *     LOGICAL College
##
##        38/1      *     LOGICAL Summer Swim League
##
##        39/1      *     LOGICAL Masters
##
##        40/1      *     LOGICAL Disabled Sports Organizations
##
##        41/1      *     LOGICAL Water Polo
##
##        42/1      *     LOGICAL None
##
##        43/118                  future use
##
##        * Required for submission of registration data to an LSC
##
SDIF["D3"] = {
  keys: [:mark, :siid, :frst, :ethn, :junr, :senr, :ymca, :coll, :summ, :mstr, :dabl, :polo, :none, :gap0],
  lens: [    2,    14,    15,     2,     1,     1,     1,     1,     1,     1,     1,     1,     1,   118],
}

#############################################################################
##
##        E0 -- Relay Event Record
##
##             Purpose:  Identify the relay team by name, USS team code,
##                       and gender.  Identify the stroke, distance, event
##                       number, date and time of the swims.
##
##        This record is used to identify the team and the relay event.
##        When used, one relay event record would be submitted for each
##        relay squad entered in a relay event.  The relay team name, USS
##        team code, and gender code are required.  Fields for the stroke,
##        distance, event number, age range, and date of swim, are also
##        required.  Additional fields provide for the age or class, seed
##        time, prelim time, swim off time, finals time, and pool lanes
##        used in competition.
##
##        start/
##        length   Mand   Type   Description
##       ----------------------------------------------------------------
##        1/2      M1     CONST  "E0"
##
##        3/1      M2     CODE   ORG Code 001, table checked
##
##        4/8                    future use
##
##        12/1     M1     ALPHA  relay team name:  one alpha char to
##                               concatenate with the abbreviated team
##                               name (48/16) in record C1 -- creates such
##                               names as "Dolphins A"
##
##        13/6     M1     CODE   TEAM Code 006
##
##        19/2            INT    number of F0 relay name records to follow
##
##        21/1     M1     CODE   EVENT SEX Code 011, table checked
##
##        22/4     M1     INT    distance of relay
##
##        26/1     M1     CODE   STROKE Code 012, table checked
##
##        27/4            ALPHA  Event Number
##
##        31/4     M1     CODE   EVENT AGE Code 025, table checked
##
##        35/3            INT    total age of all athletes in this event
##
##        38/8     M2     DATE   date of swim
##
##        46/8            TIME   seed time
##
##        54/1      *     CODE   COURSE Code 013, table checked
##
##        55/8            TIME   prelim time
##
##        63/1      *     CODE   COURSE Code 013, table checked
##
##        64/8            TIME   swim-off time
##
##        72/1      *     CODE   COURSE Code 013, table checked
##
##        73/8            TIME   finals time
##
##        81/1      *     CODE   COURSE Code 013, table checked
##
##        82/2            INT    prelim heat number
##
##        84/2            INT    prelim lane number
##
##        86/2            INT    finals heat number
##
##        88/2            INT    finals lane number
##
##        90/3      **    INT    prelim place ranking
##
##        93/3      **    INT    finals place ranking
##
##        96/4      **    DEC    points scored from finals
##
##        100/2           CODE   EVENT TIME CLASS Code 014, table checked
##
##        103/59                 future use
##
##        *  This field is mandatory IF the immediately preceding time
##           field is NOT blank
##
##        ** This field is mandatory (M1) if a championship meet
##           (MEET Code 005 - 6,7)
##
SDIF["E0"] = {
  keys: [:mark, :orgc, :gap0, :name, :team, :size, :esex, :dist, :stro, :evnt, :ages, :agen, :date, :tim0, :crs0, :tim1, :crs1, :tim2, :crs2, :tim3, :crs3, :hea1, :lan1, :hea2, :lan2, :plc1, :plc2, :pnts, :strd, :gap1],
  lens: [    2,     1,     8,     1,     6,     2,     1,     4,     1,     4,     4,     3,     8,     8,     1,     8,     1,     8,     1,     8,     1,     2,     2,     2,     2,     3,     3,     4,     2,    59],
}

#############################################################################
##
##        Z0 -- File Terminator Record
##
##             Purpose:  Identify the logical end of file for a file
##                       transmission.  Record statistics and swim
##                       statistics are listed for convenience.
##
##        This record is mandatory in each file.  Each file ends with this
##        record and each file has only one record of this type.  The first
##        four fields are mandatory.  Additional fields provide for text
##        and record counts.
##
##        start/
##        length   Mand   Type   Description
##       ----------------------------------------------------------------
##        1/2      M1     CONST  "Z0"
##
##        3/1      M2     CODE   ORG Code 001, table checked
##
##        4/8                    future use
##
##        12/2     M1     CODE   FILE Code 003, table checked
##
##        14/30           ALPHA  notes (additional file info)
##
##        44/3            INT    number of B records
##
##        47/3            INT    number of different meets
##
##        50/4            INT    number of C records
##
##        54/4            INT    number of different teams
##
##        58/6            INT    number of D records
##
##        64/6            INT    number of different swimmers
##
##        70/5            INT    number of E records
##
##        75/6            INT    number of F records
##
##        81/6            INT    number of G records
##
##        87/5            INT    batch number
##
##        92/3            INT    number of new members
##
##        95/3            INT    number of renew members
##
##        98/3            INT    number of member changes
##
##        101/3           INT    number of member deletes
##
##        104/57                 future use
##
SDIF["Z0"] = {
  keys: [:mark, :orgc, :gap0, :filc, :note, :nrbs, :nrms, :nrcs, :nrts, :nrds, :nrss, :nres, :nrfs, :nrgs, :btch, :news, :rens, :chgs, :dels, :gap1],
  lens: [    2,     1,     8,     2,    30,     3,     3,     4,     4,     6,     6,     5,     6,     6,     5,     3,     3,     3,     3,    57],
}

##  Code Tables
SDIF[:tables] = {}

##        ORG Code 001      Organization code
##             1    USS                        6    NCAA Div III
##             2    Masters                    7    YMCA
##             3    NCAA                       8    FINA
##             4    NCAA Div I                 9    High School
##             5    NCAA Div II

SDIF[:tables]["001"] = "ORG"
SDIF["001"] = {
  "1" => "USS",
  "2" => "Masters",
  "3" => "NCAA",
  "4" => "NCAA Div I",
  "5" => "NCAA Div II",
  "6" => "NCAA Div III",
  "7" => "YMCA",
  "8" => "FINA",
  "9" => "High School",
}

##        LSC Code 002      Local Swimming Committee code
##             AD   Adirondack                 MV    Missouri Valley
##             AK   Alaska                     MW    Midwestern
##             AM   Allegheny Mountain         NC    North Carolina
##             AR   Arkansas                   ND    North Dakota
##             AZ   Arizona                    NE    New England
##             BD   Border                     NI    Niagara
##             CA   Southern California        NJ    New Jersey
##             CC   Central California         NM    New Mexico
##             CO   Colorado                   NT    North Texas
##             CT   Connecticut                OH    Ohio
##             FG   Florida Gold Coast         OK    Oklahoma
##             FL   Florida                    OR    Oregon
##             GA   Georgia                    OZ    Ozark
##             GU   Gulf                       PC    Pacific
##             HI   Hawaii                     PN    Pacific Northwest
##             IA   Iowa                       PV    Potomac Valley
##             IE   Inland Empire              SC    South Carolina
##             IL   Illinois                   SD    South Dakota
##             IN   Indiana                    SE    Southeastern
##             KY   Kentucky                   SI    San Diego Imperial
##             LA   Louisiana                  SN    Sierra Nevada
##             LE   Lake Erie                  SR    Snake River
##             MA   Middle Atlantic            ST    South Texas
##             MD   Maryland                   UT    Utah
##             ME   Maine                      VA    Virginia
##             MI   Michigan                   WI    Wisconsin
##             MN   Minnesota                  WT    West Texas
##             MR   Metropolitan               WV    West Virginia
##             MS   Mississippi                WY    Wyoming
##             MT   Montana

SDIF[:tables]["002"] = "LSC"
SDIF["002"] = {
  "AD" => "Adirondack",
  "AK" => "Alaska",
  "AM" => "Allegheny Mountain",
  "AR" => "Arkansas",
  "AZ" => "Arizona",
  "BD" => "Border",
  "CA" => "Southern California",
  "CC" => "Central California",
  "CO" => "Colorado",
  "CT" => "Connecticut",
  "FG" => "Florida Gold Coast",
  "FL" => "Florida",
  "GA" => "Georgia",
  "GU" => "Gulf",
  "HI" => "Hawaii",
  "IA" => "Iowa",
  "IE" => "Inland Empire",
  "IL" => "Illinois",
  "IN" => "Indiana",
  "KY" => "Kentucky",
  "LA" => "Louisiana",
  "LE" => "Lake Erie",
  "MA" => "Middle Atlantic",
  "MD" => "Maryland",
  "ME" => "Maine",
  "MI" => "Michigan",
  "MN" => "Minnesota",
  "MR" => "Metropolitan",
  "MS" => "Mississippi",
  "MT" => "Montana",
  "MV" => "Missouri Valley",
  "MW" => "Midwestern",
  "NC" => "North Carolina",
  "ND" => "North Dakota",
  "NE" => "New England",
  "NI" => "Niagara",
  "NJ" => "New Jersey",
  "NM" => "New Mexico",
  "NT" => "North Texas",
  "OH" => "Ohio",
  "OK" => "Oklahoma",
  "OR" => "Oregon",
  "OZ" => "Ozark",
  "PC" => "Pacific",
  "PN" => "Pacific Northwest",
  "PV" => "Potomac Valley",
  "SC" => "South Carolina",
  "SD" => "South Dakota",
  "SE" => "Southeastern",
  "SI" => "San Diego Imperial",
  "SN" => "Sierra Nevada",
  "SR" => "Snake River",
  "ST" => "South Texas",
  "UT" => "Utah",
  "VA" => "Virginia",
  "WI" => "Wisconsin",
  "WT" => "West Texas",
  "WV" => "West Virginia",
  "WY" => "Wyoming",
}

##        FILE Code 003     File/Transmission Type code
##             01   Meet Registrations
##             02   Meet Results
##             03   OVC
##             04   National Age Group Record
##             05   LSC Age Group Record
##             06   LSC Motivational List
##             07   National Records and Rankings
##             08   Team Selection
##             09   LSC Best Times
##             10   USS Registration
##             16   Top 16
##             20   Vendor-defined code

SDIF[:tables]["003"] = "FILE"
SDIF["003"] = {
  "01" => "Meet Registrations",
  "02" => "Meet Results",
  "03" => "OVC",
  "04" => "National Age Group Record",
  "05" => "LSC Age Group Record",
  "06" => "LSC Motivational List",
  "07" => "National Records and Rankings",
  "08" => "Team Selection",
  "09" => "LSC Best Times",
  "10" => "USS Registration",
  "16" => "Top 16",
  "20" => "Vendor-defined code",
}

##        COUNTRY Code 004    FINA Country code (effective 1993)
##
##             AFG  Afghanistan                BRN   Bahrain
##             AHO  Antilles Netherlands       BRU   Brunei
##                  (Dutch West Indies)        BUL   Bulgaria
##             ALB  Albania                    BUR   Burkina Faso
##             ALG  Algeria                    CAF   Central African
##             AND  Andorra                          Republic
##             ANG  Angola                     CAN   Canada
##             ANT  Antigua                    CAY   Cayman Islands
##             ARG  Argentina                  CGO   People's Rep. of Congo
##             ARM  Armenia                    CHA   Chad
##             ARU  Aruba                      CHI   Chile
##             ASA  American Samoa             CHN   People's Rep. of China
##             AUS  Australia                  CIV   Ivory Coast
##             AUT  Austria                    CMR   Cameroon
##             AZE  Azerbaijan                 COK   Cook Islands
##             BAH  Bahamas                    COL   Columbia
##             BAN  Bangladesh                 CRC   Costa Rica
##             BAR  Barbados                   CRO   Croatia
##             BEL  Belgium                    CUB   Cuba
##             BEN  Benin                      CYP   Cyprus
##             BER  Bermuda                    DEN   Denmark
##             BHU  Bhutan                     DJI   Djibouti
##             BIZ  Belize                     DOM   Dominican Republic
##             BLS  Belarus                    ECU   Ecuador
##             BOL  Bolivia                    EGY   Arab Republic of Egypt
##             BOT  Botswana                   ESA   El Salvador
##             BRA  Brazil                     ESP   Spain
##
##
##
##
##
##
##
##
##
##
##
##        April 28, 1998                    34
##        !!! SDIF VERSION 3 DOCUMENT !!!
##
##        COUNTRY Code 004    Country code (continued)
##
##             EST   Estonia                   LAO   Laos
##             ETH   Ethiopia                  LAT   Latvia
##             FIJ   Fiji                      LBA   Libya
##             FIN   Finland                   LBR   Liberia
##             FRA   France                    LES   Lesotho
##             GAB   Gabon                     LIB   Lebanon
##             GAM   Gambia                    LIE   Liechtenstein
##             GBR   Great Britain             LIT   Lithuania
##             GER   Germany                   LUX   Luxembourg
##             GEO   Georgia                   MAD   Madagascar
##             GEQ   Equatorial Guinea         MAS   Malaysia
##             GHA   Ghana                     MAR   Morocco
##             GRE   Greece                    MAW   Malawi
##             GRN   Grenada                   MDV   Maldives
##             GUA   Guatemala                 MEX   Mexico
##             GUI   Guinea                    MGL   Mongolia
##             GUM   Guam                      MLD   Moldova
##             GUY   Guyana                    MLI   Mali
##             HAI   Haiti                     MLT   Malta
##             HKG   Hong Kong                 MON   Monaco
##             HON   Honduras                  MOZ   Mozambique
##             HUN   Hungary                   MRI   Mauritius
##             INA   Indonesia                 MTN   Mauritania
##             IND   India                     MYA   Union of Myanmar
##             IRL   Ireland                   NAM   Namibia
##             IRI   Islamic Rep. of Iran      NCA   Nicaragua
##             IRQ   Iraq                      NED   The Netherlands
##             ISL   Iceland                   NEP   Nepal
##             ISR   Israel                    NIG   Niger
##             ISV   Virgin Islands            NGR   Nigeria
##             ITA   Italy                     NOR   Norway
##             IVB   British Virgin Islands    NZL   New Zealand
##             JAM   Jamaica                   OMA   Oman
##             JOR   Jordan                    PAK   Pakistan
##             JPN   Japan                     PAN   Panama
##             KEN   Kenya                     PAR   Paraguay
##             KGZ   Kyrghyzstan               PER   Peru
##             KOR   Korea (South)             PHI   Philippines
##             KSA   Saudi Arabia              PNG   Papau-New Guinea
##             KUW   Kuwait                    POL   Poland
##             KZK   Kazakhstan                POR   Portugal
##
##
##
##
##
##
##
##
##
##
##
##        April 28, 1998                    35
##        !!! SDIF VERSION 3 DOCUMENT !!!
##
##        COUNTRY Code 004    Country code (continued)
##
##             PRK   Democratic People's       SWE   Sweden
##                   Rep. of Korea             SWZ   Swaziland
##             PUR   Puerto Rico               SYR   Syria
##             QAT   Qatar                     TAN   Tanzania
##             ROM   Romania                   TCH   Czechoslovakia
##             RSA   South Africa              TGA   Tonga
##             RUS   Russia                    THA   Thailand
##             RWA   Rwanda                    TJK   Tadjikistan
##             SAM   Western Samoa             TOG   Togo
##             SEN   Senegal                   TPE   Chinese Taipei
##             SEY   Seychelles                TRI   Trinidad & Tobago
##             SIN   Singapore                 TUN   Tunisia
##             SLE   Sierra Leone              TUR   Turkey
##             SLO   Slovenia                  UAE   United Arab Emirates
##             SMR   San Marino                UGA   Uganda
##             SOL   Solomon Islands           UKR   Ukraine
##             SOM   Somalia                   URU   Uruguay
##             SRI   Sri Lanka                 USA   United States of
##             SUD   Sudan                           America
##             SUI   Switzerland               VAN   Vanuatu
##             SUR   Surinam                   VEN   Venezuela
##                                             VIE   Vietnam
##                                             VIN   St. Vincent and the
##                                                   Grenadines
##                                             YEM   Yemen
##                                             YUG   Yugoslavia
##                                             ZAI   Zaire
##                                             ZAM   Zambia
##                                             ZIM   Zimbabwe
##
##
##        MEET Code 005     Meet Type code
##             1    Invitational               8    Seniors
##             2    Regional                   9    Dual
##             3    LSC Championship           0    Time Trials
##             4    Zone                       A    International
##             5    Zone Championship          B    Open
##             6    National Championship      C    League
##             7    Juniors
##
##
##
##
##
##
##
##
##
##
##
##
##
##        April 28, 1998                    36
##        !!! SDIF VERSION 3 DOCUMENT !!!
##
##        TEAM Code 006     LSC and Team code
##             Supplied from USS Headquarters files upon request.
##             Concatenation of two-character LSC code and four-character
##             Team code, in that order (e.g., Colorado's FAST would be
##             COFAST).  The code for Unattached should always be UN, and
##             not any other abbreviation.  (Florida Gold's unattached
##             would be FG  UN.)
##
##        REGION Code 007   Region code
##             1    Region 1                8    Region 8
##             2    Region 2                9    Region 9
##             3    Region 3                A    Region 10
##             4    Region 4                B    Region 11
##             5    Region 5                C    Region 12
##             6    Region 6                D    Region 13
##             7    Region 7                E    Region 14
##
##        USS# Code 008     USS member number code
##             Refer to USS membership files.  These will not be published.
##
##        CITIZEN Code 009  Citizenship code
##             2AL  Dual:  USA and other country
##             FGN  Foreign
##             All codes in COUNTRY Code 004
##
##        SEX Code 010      Swimmer Sex code
##             M    Male
##             F    Female
##
##        EVENT SEX Code 011 Sex of Event code
##             M    Male
##             F    Female
##             X    Mixed
##
##        STROKE Code 012   Event Stroke code
##             1    Freestyle
##             2    Backstroke
##             3    Breaststroke
##             4    Butterfly
##             5    Individual Medley
##             6    Freestyle Relay
##             7    Medley Relay
##
##
##
##
##
##
##
##
##
##
##
##
##        April 28, 1998                    37
##        !!! SDIF VERSION 3 DOCUMENT !!!
##
##        COURSE Code 013   Course/Status code
##             Please note that there are alternatives for the three types
##             of pools.  The alpha characters make the file more readable.
##             Either may be used.
##             1 or S   Short Course Meters
##             2 or Y   Short Course Yards
##             3 or L   Long Course Meters
##             X        Disqualified
##
##        EVENT TIME CLASS Code 014  Event Time Class code
##             The following characters are concatenated to form a 2-byte
##             code for the event time class.  The first character
##             indicates the lower limit; the second character indicates
##             the upper limit.  22 indicates B meets, 23 indicates B-A
##             meets, and 4O indicates AA+ meets.
##             U    no lower limit (left character only)
##             O    no upper limit (right character only)
##             1    Novice times
##             2    B standard times
##             P    BB standard times
##             3    A standard times
##             4    AA standard times
##             5    AAA standard times
##             6    AAAA standard times
##             J    Junior standard times
##             S    Senior standard times
##
##
##        SPLIT Code 015   Split code
##             C    Cumulative splits supplied
##             I    Interval splits supplied
##
##        ATTACH Code 016   Attached code
##             A    Swimmer is attached to team
##             U    Swimmer is swimming unattached
##
##        ZONE Code 017    Zone code
##             E    Eastern Zone
##             S    Southern Zone
##             C    Central Zone
##             W    Western Zone
##
##
##
##
##
##
##
##
##
##
##
##
##
##        April 28, 1998                    38
##        !!! SDIF VERSION 3 DOCUMENT !!!
##
##        COLOR Code 018    Color code
##             GOLD Gold
##             SILV Silver
##             BRNZ Bronze
##             BLUE Blue
##             RED  Red (note that fourth character is a space)
##             WHIT White
##
##        PRELIMS/FINALS Code 019   Prelims/Finals code
##                  P         Prelims
##                  F         Finals
##                  S         Swim-offs
##
##        TIME Code 020     Time explanation code
##             NT   No Time
##             NS   No Swim (or No Show)
##             DNF  Did Not Finish
##             DQ   Disqualified
##             SCR  Scratch
##
##        MEMBER Code 021   Membership transaction type
##             R    Renew
##             N    New
##             C    Change
##             D    Delete
##
##        SEASON Code 022
##             1    Season 1
##             2    Season 2
##             N    Year-round
##
##        ORDER Code 024    relay leg order
##             0    Not on team for this swim
##             1    First leg
##             2    Second leg
##             3    Third leg
##             4    Fourth leg
##             A    Alternate
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##
##        April 28, 1998                   39
##        !!! SDIF VERSION 3 DOCUMENT !!!
##
##        EVENT AGE Code 025
##             first two bytes are lower age limit (digits, or "UN"
##                   for no limit)
##             last two bytes are upper age limit (digits, or "OV"
##                   for no limit)
##             if the age is only one digit, fill with a zero
##                   (no blanks allowed)
##
##        ETHNICITY Code 026
##             The first byte contains the first ethnicity selection.
##             The second byte contains an optional second ethnicity
##                   selection.
##             If the first byte contains a V,W or X then the second
##                   byte must be blank.
##
##             Q    African American
##             R    Asian or Pacific Islander
##               S    Caucasian
##               T    Hispanic
##             U    Native American
##             V    Other
##             W    Decline
##
##
##
