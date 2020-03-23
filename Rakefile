# require 'bundler/gem_tasks'
require 'json'
require 'yaml'
require 'open-uri'
task default: %i[composer:build]

desc 'Run rubocop'
task :rubocop do
  sh 'rubocop'
end


namespace :composer do
  WP_PLUGIN_API='https://api.wordpress.org/plugins/info/1.0/%s.json?fields=-sections,-tags,-rating,-ratings'
  GITHUB_RELEASE_API='https://api.github.com/repos/%s/releases'

  composer_base = YAML.load_file('./composer.yml')
  plugins = YAML.load_file('./plugins.yml')

  desc 'build two composer.json (default)'
  task :build do
    # wordpress
    plugins['wordpress'].each do |plugin|
      obj_repo = {
        type: 'package',
        package: {
          version: 'dev-master',
          type: 'wordpress-plugin',
          name: 'wordpress/' + plugin['name'],
          dist: {
            type: 'zip'
          }
        }
      }
      body = JSON.load(URI.open(WP_PLUGIN_API % plugin['name']).read)
      obj_repo[:package][:dist][:url] = body['download_link']
      puts(plugin['name'], body['version'] )
      composer_base['repositories'].append(obj_repo)
    end

    # github
    plugins['github'].each do |plugin|
      obj_repo = {
        type: 'package',
        package: {
          version: 'dev-master',
          type: 'wordpress-plugin',
          name: plugin['repo'],
          dist: {
            type: 'tar'
          }
        }
      }
      case plugin['type']
      when 'branch'
        obj_repo[:package][:dist][:type] = 'zip'
        obj_repo[:package][:dist][:url] = ['https://github.com', plugin['repo'], 'archive', plugin['arg'] + '.zip'].join('/')
      when 'prerelease_src'
        obj_repo[:package][:dist][:type] = 'tar'
        body = JSON.load URI.open(GITHUB_RELEASE_API % plugin['repo']).read
        puts(plugin['name'], body[0]['name'] )
        obj_repo[:package][:dist][:url] = body[0]['tarball_url']
      end
      composer_base['repositories'].append(obj_repo)
    end

    File.open('build/lite/composer.json', 'w') do |f|
      composer_lite = composer_base.dup
      plugins['wordpress'].map{|x| x['name'] unless x['full']}.compact.each do |name|
        composer_lite['require']['wordpress/' + name] = 'dev-master'
      end
      plugins['github'].map{|x| x['repo'] unless x['full']}.compact.each do |repo|
        composer_lite['require'][repo] = 'dev-master'
      end
      f.puts(JSON.pretty_generate(composer_lite))
    end

    File.open('build/full/composer.json', 'w') do |f|
      composer_full = composer_base.dup
      plugins['wordpress'].map{|x| x['name']}.compact.each do |name|
        composer_full['require']['wordpress/' + name] = 'dev-master'
      end
      plugins['github'].map{|x| x['repo']}.compact.each do |repo|
        composer_full['require'][repo] = 'dev-master'
      end
      f.puts(JSON.pretty_generate(composer_full))
    end
  end
end
