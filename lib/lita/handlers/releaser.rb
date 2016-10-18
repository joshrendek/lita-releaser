require 'json'
require 'base64'
require 'octokit'

module Lita
  module Handlers
    class Releaser < Handler

      config :org
      config :token

      route (/releaser ship (\w+)?/i), :ship, command: true, help: {
              'releaser ship <project_name>' => 'Merges develop into master for <project_name>'
            }

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
