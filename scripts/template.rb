require 'json'
require 'pathname'
require 'ostruct'

class Track
  attr_reader :id, :root
  def initialize(id, root)
    @id = id
    @root = root
  end

  def config
    @config ||= JSON.parse(File.read(config_filename), object_class: OpenStruct)
  end

  def config_filename
    "config.json"
  end

  def has_branch?(name)
    system("git branch | grep -q %s" % name)
  end

  def unchanged?
    %x(git status --short | wc -l).strip.to_i.zero?
  end

  def commit(msg)
    system("git commit -m \"%s\"" % msg)
  end

  def submit(branch, msg)
    system("git push origin %s" % branch)
    %x{hub pull-request -m \"#{msg}\"}
  end
end

class PRScript
  include Enumerable

  attr_reader :tracks
  def initialize(tracks_path:, track_ids: nil)
    track_ids ||= Dir.glob('%s/*' % tracks_path).map {|path|
      Pathname.new(path).basename.to_s
    }
    @tracks = track_ids.map {|track_id| Track.new(track_id, File.join(tracks_path, track_id))}
  end

  def each(&block)
    tracks.each do |track|
      yield track
    end
  end
end

if ARGV.empty?
  STDERR.puts "call with branch name as argument"
end

branch = ARGV.first
tracks_path = File.absolute_path(File.join('..', '..', 'tracks'), __FILE__)

root = Dir.pwd
PRScript.new(tracks_path: tracks_path).each do |track|
  Dir.chdir root
  Dir.chdir File.join(tracks_path, track.id)

  system("git checkout master && git fetch origin master && git reset --hard origin/master")
  if track.has_branch?(branch)
    system("git checkout %s" % branch)
  else
    system("git checkout -b %s" % branch)
  end

  # Do the work.
  # Add the files.

  next if track.unchanged?

  msg = <<-MSG
TITLE

BODY
  MSG
  track.commit(msg)

  msg << "\nSee TRACKING_ISSUE"

  track.submit(branch, msg)
  # Avoid abuse rate limits.
  sleep 3
end
