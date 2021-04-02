require "option_parser"

module PropertyInterface
  abstract def brick_count : Int32
  abstract def create_string : String
end

class ArbiterProperties
  include PropertyInterface
  def initialize(options)
    @replcount = 2
    @arbitercount = 1
    @distribute = DistributeProperties.new(options)
  end
  
  def brick_count : Int32
    return (@replcount + @arbitercount) * @distribute.brick_count
  end

  def create_string : String
    "replica #{@replcount + @arbitercount} arbiter 1"
  end
end

class ReplicaProperties
  include PropertyInterface
  def initialize(options)
    @replcount = options["replcount"].as(Int32)
    @distribute = DistributeProperties.new(options)
  end
  
  def brick_count : Int32
    return @replcount * @distribute.brick_count
  end

  def create_string : String
    "replica #{@replcount}"
  end
end

class DistributeProperties
  include PropertyInterface
  @dhtcount = 1
  def initialize(options)
    if options.has_key?("dhtcount")
      @dhtcount = options["dhtcount"].as(Int32)
    end
  end

  def brick_count : Int32
    return @dhtcount
  end

  def create_string : String
    ""
  end
end

class DisperseProperties
  include PropertyInterface
  def initialize(options)
    @dispersecount = options["dispersecount"].as(Int32)
    @redundancycount = options["redundancycount"].as(Int32)
    @distribute = DistributeProperties.new(options)
  end

  def brick_count : Int32
    return @dispersecount * @distribute.brick_count
  end

  def create_string : String
    "disperse #{@dispersecount} redundancy #{@redundancycount}"
  end
end

module Properties
  def self.get_properties(options) : PropertyInterface
    if options.has_key?("arbiter")
      return ArbiterProperties.new(options)
    elsif options.has_key?("replcount")
      return ReplicaProperties.new(options)
    elsif options.has_key?("dispersecount")
      return DisperseProperties.new(options)
    end
    return DistributeProperties.new(options)
  end
end

class Vol
  property :volname, :dhtcount, :replcount
  @volname = "gv0"
  def initialize(options)
    @volname = options["volname"].as(String)
    @vol_properties = Properties.get_properties(options)
  end

  def hostname
    "localhost.localdomain"
  end

  def paths
    base_brick_path = "/home/gfs/"

    paths = ""
    brick_count = @vol_properties.brick_count
    (0..(brick_count - 1)).each do |i|
      paths += hostname + ":" + base_brick_path + @volname + "_" + i.to_s + " "
    end
    paths
  end

  def create
    Utils.execute(Utils.gluster_command + "volume create #{@volname} #{@vol_properties.create_string} #{paths}")
  end

  def start
    Utils.execute(Utils.gluster_command + "volume start #{@volname}")
  end

  def stop
    Utils.execute(Utils.gluster_command + "volume stop #{@volname}")
  end

  def mount
    Utils.execute("mount -t glusterfs #{hostname}:/#{@volname} /mnt/#{@volname}")
  end
end

class Utils
  def self.execute(cmd)
    puts cmd
    puts `#{cmd}`
    if ! $?.success?
      abort "execution failed: #{$?}"
    end
  end

  def self.start_glusterd
    if `pgrep glusterd` == ""
      execute("glusterd")
    end
  end

  def self.gluster_command
    "gluster --mode=script --wignore "
  end

  def self.abort_non_root
    me = `whoami`.chomp
    if me != "root"
      abort "You are " + me + " Only root can execute this script"
    end
  end

  def self.abort_on_missing_args(options)
    if options["command"].nil?
      abort "Missing --command"
    elsif options["command"] != 'i' && ! options.has_key?("volname")
      abort "Missing --volname"
    end
  end

  def self.abort_on_wrong_execution(options)
    abort_non_root
    abort_on_missing_args options
  end
end

Utils.start_glusterd
vol = Vol.new({"volname" => "r3", "dhtcount" => 2, "replcount" => 3})
vol.create
vol.start
vol = Vol.new({"volname" => "ec2", "dispersecount" => 3, "redundancycount" => 1})
vol.create
vol.start
vol = Vol.new({"volname" => "arb", "arbiter" => 1})
vol.create
vol.start
vol = Vol.new({"volname" => "d5", "dhtcount" => 5})
vol.create
vol.start
options = {"command" => "s", "volname" => "r3"}
Utils.abort_on_wrong_execution options
