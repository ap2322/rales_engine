%w[
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
].each { |path| Spring.watch(path) }

# config/environments/test.rb sets config.cache_classes = true (equivalent to
# enable_reloading = false), which Spring >= 3 refuses to preload against by
# default: "Spring reloads, and therefore needs the application to have
# reloading enabled." Since test.rb's no-reload setting is intentional
# (single-shot RSpec runs, not a long-lived reloading server), opt in to the
# documented escape hatch instead of flipping enable_reloading for the whole
# test environment.
Spring.dangerously_allow_disabling_reloading = true
