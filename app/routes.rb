require 'date'
require 'stringio'

module ChatLogger
  module Routes extend self
    LOGSTAMP_FMT = '%Y%m%d'
    WEBSTAMP_FMT = '%Y-%m-%d %H:%M'

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
        now = Time.now.strftime('%Y-%m-%d')
        vars = {channel: channel}
        if from = params[:from]
          unless from.match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/)
            return {error: 'Garbled from date.'}
          end
          vars[:from] = from
        else
          vars[:from] = "#{now} 00:00"
        end
        if to = params[:to]
          unless from.match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/)
            return {error: 'Garbled to date.'}
          end
          vars[:to] = to
        else
          vars[:to] = "#{now} 23:59"
        end
        vars
      end

      def common_str(a, b)
        a = a.dup
        while a.length > 0
          return a if b.start_with? a
          a = a.slice(0, a.length - 1)
        end
        ''
      end

      def log_for(args)
        STDERR.puts ">> #{args[:from]}"
        STDERR.flush
        from_date = DateTime.parse(args[:from])
        to_date = DateTime.parse(args[:to])
        from_str = from_date.strftime(LOGSTAMP_FMT)
        to_str = to_date.strftime(LOGSTAMP_FMT)
        matcher = "default_#{args[:channel]}_#{common_str(from_str, to_str)}*.log"
        STDERR.puts ">> #{matcher}"
        STDERR.flush
        in_timespan = false
        we_done = false
        out = StringIO.new
        Dir.glob(File.join(settings.log_path, matcher)).each do |p|
          STDERR.puts p
          STDERR.flush
          break if we_done
          fname = File.basename(p)
          if in_timespan
            we_done = true if fname.match(/#{to_str}/)
            out.puts ">>> #{fname}"
            out.write(File.read(p))
          else
            next unless fname.match(/#{from_str}/)
            in_timespan = true
            out.puts ">>> #{fname}"
            out.write(File.read(p))
          end
        end
        out.string
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
        redirect "/#{params[:channel]}/#{from.strftime(WEBSTAMP_FMT)}/#{to.strftime(WEBSTAMP_FMT)}"
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
