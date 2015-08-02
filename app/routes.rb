module ChatLogger
  module Routes extend self
    module Helpers
      def ajax_do(&blk)
        content_type :json
        begin
          halt({success: true, data: blk.call}.to_json)
        rescue StandardError => e
          halt({success: false, error: e.to_s}.to_json)
        end
      end

      def vars(hsh = {})
        vars = {
          channels: settings.channels,
          channel: '',
          from: '',
          to: '',
        }.merge(hsh)
        'window.cl_data=JSON.parse(\'' + vars.to_json + '\');'
      end

      def log_for(channel, from = nil, to = nil)
        path = Dir.glob("/mnt/array/backup/syncs/insomniac/drbig/.znc/users/freenode/moddata/log/default_#{channel}*.log").last
        File.read(path)
      end
    end

    def registered(app)
      app.helpers Helpers

      app.get('/') do
        @vars = vars
        @content = 'Use the selector above.'
        haml :front
      end

      app.get('/:channel') do
        channel = params[:channel]
        redirect '/' unless settings.channels.member? channel
        @vars = vars({channel: channel})
        @content = log_for(channel)
        haml :front
      end
    end
  end
end
