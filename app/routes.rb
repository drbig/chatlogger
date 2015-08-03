require 'stringio'

module ChatLogger
  module Routes extend self
    FULLSTAMP_FMT = '%Y-%m-%d %H:%M'

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
        now = Time.now.strftime('%Y-%m-%d')
        vars = {
          channels: settings.channels,
          channel: '',
          from: "#{now} 00:00",
          to: "#{now} 23:59",
        }.merge(hsh)
        'window.cl_data=JSON.parse(\'' + vars.to_json + '\');'
      end
 
      def parse
        channel = params[:channel]
        unless settings.channels.member? channel
          return {error: 'No such channel.'}
        end
        vars = {channel: channel}
        if from = params[:from]
          unless from.match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/)
            return {error: 'Garbled from date.'}
          end
          vars[:from] = from
        end
        if to = params[:to]
          unless from.match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/)
            return {error: 'Garbled to date.'}
          end
          vars[:to] = to
        end
        vars
      end

      def log_for(args)
        path = Dir.glob("/mnt/array/backup/syncs/insomniac/drbig/.znc/users/freenode/moddata/log/default_#{args[:channel]}*.log").last
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
        from = Date.today.to_time
        to = from + 23*60*60 + 59*60
        redirect "/#{params[:channel]}/#{from.strftime(FULLSTAMP_FMT)}/#{to.strftime(FULLSTAMP_FMT)}"
      end

      app.get('/:channel/:from/:to') do
        args = parse
        @vars = vars(args)
        if args.has_key? :error
          @content = args[:error]
        else
          @content = log_for(args)
        end
        haml :front
      end
    end
  end
end
