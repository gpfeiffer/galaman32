class Rating < ActiveRecord::Base
  COMPONENTS = [
    { :name => :coach_ability, :description => "willingness  to learn and share the coaching process." },
    { :name => :athletes_knowledge, :description => "Ability to understand sports specific Information" },
    { :name => :technical_competency, :description => "skill acquisition ability to technically change things." },
    { :name => :physical_conditioning, :description => "Aerobic, overall general fitness" },
    { :name => :strength, :description => "The extent to which muscles can exert force by contracting against resistance, Skill and strength ability to hold specific movements" },
    { :name => :power, :description => "The ability to exert maximum muscular contraction instantly in an explosive burst of movements (Jumping or sprint starting)" },
    { :name => :agility, :description => "The ability to perform a series of explosive power movements in rapid succession in opposing directions (ZigZag running or cutting movements)" },
    { :name => :balance, :description => "The ability to control the body's position, either stationary (e.g. a handstand) or while moving (e.g. a gymnastics stunt)" },
    { :name => :team_work, :description => "Ability to work with a team or partner" },
    { :name => :sustainable_power, :description => "Ability to hold a high power over 3 minutes" },
    { :name => :confidence, :description => "confidence in what you do as a person." },
    { :name => :time_management, :description => "Getting the best from the time available." },
    { :name => :communication, :description => "good  communication with your  support team to allow engagement in all areas of  life that will allow  you to enjoy and reach  your goals as a athlete. " },
    { :name => :motivation, :description => "Enjoys the challenge, accepts the task, and has the patience to to understance the time necessary for reaching full potential " },
    { :name => :health_managment, :description => "Understanding what is best practise (hygiene, injury, and illness)" },
    { :name => :nutrition, :description => "Understanding the requirements of a young growing developing athlete in a your sport" },
    { :name => :recovery, :description => "Understanding the importance of recovery as a factor of your development" },
    { :name => :flexibility, :description => "The ability to achieve an extended range of motion without being impeded by excess tissue, i.e. fat or muscle (Executing a leg split)" },
    { :name => :local_muscle_endurance, :description => "A single muscle's ability to perform sustained work (Rowing or cycling)" },
    { :name => :cardiovascular_endurance, :description => "The heart's ability to deliver blood to working muscles and their ability to use it (Running long distances)" },
    { :name => :strength_endurance, :description => "A muscle's ability to perform a maximum contracture time after time (Continuous explosive rebounding through an entire basketball game)" },
    { :name => :coordination, :description => " The ability to integrate the above listed components so that effective movements are achieved" },
    { :name => :psychological_skills, :description => "amplication of error, goal setting, Imagerie, Positive approach, be able to take critiscism" },
  ]

  args = COMPONENTS.map { |x| x[:name] } + [ :presence => true ]
  validates(*args)

end
