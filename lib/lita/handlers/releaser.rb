require 'json'
require 'base64'
require 'octokit'
require 'pry'

module Lita
  module Handlers
    class Releaser < Handler

      config :org
      config :token

      route (/releaser ship ([a-zA-Z-]+)?/i), :ship, command: true, help: {
              'releaser ship <project_name>' => 'Merges develop into master for <project_name>'
            }

      route (/releaser last_version ([a-zA-Z-]+)?/i), :last_version, command: true, help: {
              'releaser last_version <project_name>' => 'Gets last version of a project'
            }

      route (/releaser release ([a-zA-Z-]+)? (v[0-9]{1,}\.[0-9]{1,}\.[0-9]{1,}) (.*)/i), :release, command: true, help: {
              'releaser release <project_name> <version> <release description>' => "Publishes a new release on github for <project_name> with <version> and <description>"
            }

      def last_version(response)
        m = response.matches[0]
        repo = m[0]
        repo_path = "#{config.org}/#{repo}"
        begin
          resp = client.latest_release(repo_path)
          response.reply "Latest release: Name: #{resp.name} | Tag: #{resp.tag_name} | Link: #{resp.html_url}"
        rescue => e
          response.reply "Error: #{e}"
        end
      end

      def release(response)
        m = response.matches[0]
        repo = m[0]
        version = m[1]
        description = m[2]
        repo_path = "#{config.org}/#{repo}"

        begin
          resp = client.create_release(repo_path, version, {body: description, name: version})
          response.reply "Release created for https://github.com/#{config.org}/#{repo}"
        rescue => e
          response.reply "Error: #{e}"
        end
      end

      def ship(response)
        repo = response.matches.first.last
        date = Time.now.strftime('%Y/%m/%d')
        title = "#{date} Release"
        body = "Created by #{response.user.name}"
        repo_path = "#{config.org}/#{repo}"
        begin
          resp = client.create_pull_request(repo_path, "master", "develop", title, body)
          pr_number = resp['number']
          client.merge_pull_request(repo_path, pr_number)
          response.reply "Release shipped: #{title} [ #{resp['url']} ]"
        rescue => e
          response.reply "Release already exists: #{e}"
        end
      end

      def client
        Octokit::Client.new(access_token: config.token)
      end

      Lita.register_handler(Releaser)
    end
  end
end
