# meta
Experimenting with a repo to manage the project-wide, meta todos.

## Scripting track PRs

Here's the basic pattern

```
#!/usr/bin/env ruby

require_relative '../meta/lib/pr_script'

tracks_path = File.absolute_path(File.join('..', '..', 'tracks'), __FILE__)

branch = "rm-config-redundancy"
PRScript.new(tracks_path: tracks_path).each do |track|
  track.reset

  if track.has_branch?(branch)
    next
  end

  track.checkout(branch)

  # do work
  # git add whatever files you changed

  if track.unchanged?
    track.reset
    track.delete(branch)
    next
  end

  msg = <<-MSG
Summary of change.

A detailed explanation.
  MSG

  track.commit(msg)

  msg << "\n\nSee LINK TO TRACKING ISSUE"
  track.submit(branch, msg)
  sleep 5 # avoid abuse rate limits
end

```
