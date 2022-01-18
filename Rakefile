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

  desc 'build two composer.json and update PLUGINS.md (default)'
  task :build do
    File.open('PLUGINS.md', 'w') do |md|
      md.puts "# List of Plugins\n\n"
      md.puts <<~EOL
      ## From WordPress Plugin Directory

      | Name | Slug | Version | Full only? | Homepage |
      | --- | --- | --- | --- | --- |
      EOL

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
        body = JSON.load(URI.open(WP_PLUGIN_API % plugin['name']).read)
        md.puts(
          "| [%s](https://wordpress.org/plugins/%s/) | %s | %s | %s | [%s](%s) |" %
          [body['name'], body['slug'], body['slug'], body['version'].to_s, plugin['full'] ? "True" : "", body['homepage'], body['homepage']]
        )
      end

      # github
      md.puts <<~EOL

      ## From Github Repository

      | Name | Version/Tag | Full only? | Repo |
      | --- | --- | --- | --- |
      EOL
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
          puts(plugin['name'], plugin['arg'] )
          plugin['version'] = plugin['arg']
        when 'prerelease_src'
          obj_repo[:package][:dist][:type] = 'tar'
          body = JSON.load URI.open(GITHUB_RELEASE_API % plugin['repo']).read
          puts(plugin['name'], body[0]['name'] )
          obj_repo[:package][:dist][:url] = body[0]['tarball_url']
          plugin['version'] = body[0]['tag_name']
        when 'release_src'
          obj_repo[:package][:dist][:type] = 'tar'
          body = JSON.load URI.open(GITHUB_RELEASE_API % plugin['repo']).read
          puts(plugin['name'], body[0]['name'] )
          obj_repo[:package][:dist][:url] = body[0]['tarball_url']
          plugin['version'] = body[0]['tag_name']
        end
        composer_base['repositories'].append(obj_repo)
        md.puts(
          "| %s | %s | %s | [https://github.com/%s](https://github.com/%s) |" %
          [plugin['name'], plugin['version'], plugin['full'] ? "True" : "", plugin['repo'], plugin['repo']]
        )
      end

      # custom install
      md.puts <<~EOL

      ## Others

      | Name | Version/Tag | Full only? | Website |
      | --- | --- | --- | --- |
      EOL
      plugins['custom'].each do |plugin|
        obj_repo = {
          type: 'package',
          package: {
            version: 'dev-master',
            type: 'wordpress-plugin',
            name: plugin['name'],
            dist: {
              type: 'zip'
            }
          }
        }
        case plugin['name']
        when 'wpe-headless'
          metadata_url = 'https://wp-product-info.wpesvc.net/v1/plugins/wpe-headless'
          metadata = JSON.parse(URI.open(metadata_url).read)
          # obj_repo[:package][:dist][:url] = metadata['download_link']
          obj_repo[:package][:dist][:url] = "https://github.com/digitalcube/shifter-headless-plugins/releases/download/tmp-wpe-headpess/wpe-0.6.1.zip"
          puts(plugin['name'], metadata['stable_tag'] )
          plugin['version'] = metadata['stable_tag']
        else
          raise
        end
        composer_base['repositories'].append(obj_repo)
        md.puts(
          "| %s | %s | %s | [%s](%s) |" %
          [ plugin['name'],
            plugin['version'],
            plugin['full'] ? "True" : "",
            plugin['website_name'],
            plugin['website_url']
          ]
        )
      end

      File.open('build/lite/composer.json', 'w') do |f|
        composer_lite = composer_base.dup
        plugins['wordpress'].map{|x| x['name'] unless x['full']}.compact.each do |name|
          composer_lite['require']['wordpress/' + name] = 'dev-master'
        end
        plugins['github'].map{|x| x['repo'] unless x['full']}.compact.each do |repo|
          composer_lite['require'][repo] = 'dev-master'
        end
        plugins['custom'].map{|x| x['name'] unless x['full']}.compact.each do |repo|
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
        plugins['custom'].map{|x| x['name']}.compact.each do |repo|
          composer_full['require'][repo] = 'dev-master'
        end
        f.puts(JSON.pretty_generate(composer_full))
      end
    end
  end
end
