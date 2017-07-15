require 'json'
require 'pathname'

class Track
  attr_reader :id
  def initialize(id)
    @id = id
  end

  def config
    @config ||= JSON.parse(File.read(config_filename))
  end

  def config_filename
    "config.json"
  end

  def reset
    system("git reset --hard && git checkout master && git pull --rebase origin master")
  end

  def has_branch?(name)
    system("git branch | grep -q %s" % name)
  end

  def unchanged?
    %x(git status --short | wc -l).strip.to_i.zero?
  end

  def checkout(branch)
    system("git checkout -b %s" % branch)
  end

  def delete(branch)
    system("git branch -D %s" % branch)
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

  attr_reader :tracks, :root
  def initialize(tracks_path:, track_ids: nil)
    track_ids ||= Dir.glob('%s/*' % tracks_path).map {|path|
      Pathname.new(path).basename.to_s
    }
    @tracks = track_ids.map {|track_id| Track.new(track_id)}
    @root = Dir.pwd
  end

  def each(&block)
    tracks.each do |track|
      Dir.chdir root
      Dir.chdir File.join(root, 'tracks', track.id)

      yield track
    end
  end

  private

  def root
    @root ||= Dir.pwd
  end
end
