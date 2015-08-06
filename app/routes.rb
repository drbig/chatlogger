# encoding: utf-8

require 'date'
require 'stringio'
require 'uri'

module ChatLogger
  module Routes extend self
    LOGSTAMP_FMT = '%Y%m%d'
    WEBSTAMP_FMT = '%Y-%m-%d %H:%M'

    module Helpers
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
        from = DateTime.parse(vars[:from])
        to = DateTime.parse(vars[:to])
        if (to - from).abs.ceil > 5
          return {error: 'Maximum timespan is 5 days.'}
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

      def print_log(out, path, skip = false, opts = {})
        log_date = Date.parse(path.match(/\d{8}/).to_s)
        stamp = log_date.strftime('%Y-%m-%d')
        out.puts "---------> At #{stamp}"
        unless skip
          out.write(File.read(path))
        else
          skip_from = (log_date - opts[:from]).ceil == 0
          skip_to = (log_date - opts[:to]).ceil == 0
          from_stamp = opts[:from].strftime('%H:%M')
          to_stamp = opts[:to].strftime('%H:%M')

          File.open(path).each_line do |line|
            line_stamp = line.slice(1, 5)
            if skip_from
              next unless line_stamp >= from_stamp
              skip_from = false
            elsif skip_to
              break if line_stamp > to_stamp
            end
            out.puts line
          end
        end
      end

      def log_for(args)
        from_date = DateTime.parse(args[:from])
        to_date = DateTime.parse(args[:to])
        from_str = from_date.strftime(LOGSTAMP_FMT)
        to_str = to_date.strftime(LOGSTAMP_FMT)
        matcher = "default_#{args[:channel]}_#{common_str(from_str, to_str)}*.log"
        in_timespan = from_str == to_str
        we_done = false
        out = StringIO.new
        Dir.glob(File.join(settings.log_path, matcher)).each do |p|
          break if we_done
          fname = File.basename(p)
          skip = nil
          if in_timespan
            we_done = true if fname.match(/#{to_str}/)
            skip = true
          else
            next unless fname.match(/#{from_str}/)
            in_timespan = true
            skip = true
          end
          unless skip
            print_log(out, p)
          else
            print_log(out, p, skip, from: from_date, to: to_date)
          end
        end
        out.puts 'Nothing found for this timespan.' if out.length == 0
        out.string.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
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
        redirect "/#{URI.encode(params[:channel])}/#{from.strftime(WEBSTAMP_FMT)}/#{to.strftime(WEBSTAMP_FMT)}"
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
