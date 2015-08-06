$(function() {
  var pickerOpts = {format: 'YYYY-MM-DD HH:mm', showTodayButton: true};
  var maxDays = 5;

  var $content = $('#content');
  var $help = $('#help');

  var Controller = React.createClass({
    getInitialState: function() {
      return cl_data;
    },
    componentDidMount: function () {
      $('#fromPicker').datetimepicker(pickerOpts);
      $('#toPicker').datetimepicker(pickerOpts);
      $('#fromPicker').on('dp.change', function (e) {
        $('#toPicker').data('DateTimePicker').minDate(e.date);
        $('#toPicker').data('DateTimePicker').maxDate(Object.create(e.date).add(maxDays, 'days'));
      });
      $('#toPicker').on('dp.change', function (e) {
        $('#fromPicker').data('DateTimePicker').maxDate(e.date);
        $('#fromPicker').data('DateTimePicker').minDate(Object.create(e.date).subtract(maxDays, 'days'));
      });
      $('pre code').each(function(i, block) {
        hljs.highlightBlock(block);
      });
    },
    btnInfo: function () {
      $help.toggle('slow');
    },
    btnFetch: function () {
      var channel = encodeURIComponent($('#channel').val()),
          from    = $('#from').val(),
          to      = $('#to').val();
      window.open ('/' + channel + '/' + from + '/' + to, '_self', false);
    },
    btnBackward: function () {
      var fdate = $('#fromPicker').data('DateTimePicker').date();
      var tdate = $('#toPicker').data('DateTimePicker').date();
      console.log("BACK");
      $('#fromPicker').data('DateTimePicker').date(fdate.subtract(1, 'days'));
      $('#toPicker').data('DateTimePicker').date(tdate.subtract(1, 'days'));
    },
    btnForward: function () {
      var fdate = $('#fromPicker').data('DateTimePicker').date();
      var tdate = $('#toPicker').data('DateTimePicker').date();
      console.log("FORE");
      $('#fromPicker').data('DateTimePicker').date(fdate.add(1, 'days'));
      $('#toPicker').data('DateTimePicker').date(tdate.add(1, 'days'));
    },
    render: function() {
      return (
        <div className='navbar navbar-inverse navbar-fixed-top' role='navigation'>
          <div className='container'>
            <div className='navbar-header'>
              <button className='navbar-toggle' data-target='.navbar-collapse' data-toggle='collapse' type='button'>
                <span className='sr-only'>Toggle navigation</span>
                <span className='icon-bar'></span>
                <span className='icon-bar'></span>
                <span className='icon-bar'></span>
              </button>
            </div>
            <div className='collapse navbar-collapse'>
              <div className='navbar-form'>
                <button className='btn btn-default' onClick={this.btnInfo}>
                  <span className='glyphicon glyphicon-question-sign'></span>
                </button>
                &nbsp;
                &nbsp;
                <div className='form-group'>
                  <div className='input-group'>
                    <div className='input-group-addon'>Channel</div>
                    <select className='form-control' id='channel' defaultValue={this.state.channel}>
                      {Object(this.state.channels).sort().map(function (channel) {
                        return (
                          <option key={channel} value={channel}>{channel}</option>
                        );
                      }, this)}
                      <option key='' value=''>Select...</option>
                    </select>
                  </div>
                  &nbsp;
                  &nbsp;
                  <button className='btn btn-default' onClick={this.btnBackward}>
                    <span className='glyphicon glyphicon-backward'></span>
                  </button>
                  <div className='input-group date' id='fromPicker'>
                    <div className='input-group-addon'>From</div>
                    <input className='form-control' type='text' id='from' defaultValue={this.state.from}></input>
                    <span className='input-group-addon'>
                      <span className='glyphicon glyphicon-calendar'></span>
                    </span>
                  </div>
                  &nbsp;
                  &nbsp;
                  <div className='input-group date' id='toPicker'>
                    <div className='input-group-addon'>To</div>
                    <input className='form-control' type='text' id='to' defaultValue={this.state.to}></input>
                    <span className='input-group-addon'>
                      <span className='glyphicon glyphicon-calendar'></span>
                    </span>
                  </div>
                  <button className='btn btn-default' onClick={this.btnForward}>
                    <span className='glyphicon glyphicon-forward'></span>
                  </button>
                  &nbsp;
                  &nbsp;
                  <button className='btn btn-success' onClick={this.btnFetch}>Fetch</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      );
    },
  });

  React.render(<Controller />, document.getElementById('controller'));
});
