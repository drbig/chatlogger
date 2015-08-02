$(function() {
  var pickerOpts = {format: 'YYYY-MM-DD HH:mm', showTodayButton: true};
  var maxDays = 5;

  var $content = $('#content');

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
    btnFetch: function () {
      var data = {
        channel:  $('#channel').val(),
        from:     $('#from').val(),
        to:       $('#to').val(),
      };
      console.log(data);
    },
    btnBackward: function () {
      console.log("BACK");
    },
    btnForward: function () {
      console.log("FORE");
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
                    <input className='form-control' type='text' id='from'>{this.state.from}</input>
                    <span className='input-group-addon'>
                      <span className='glyphicon glyphicon-calendar'></span>
                    </span>
                  </div>
                  &nbsp;
                  &nbsp;
                  <div className='input-group date' id='toPicker'>
                    <div className='input-group-addon'>To</div>
                    <input className='form-control' type='text' id='to'>{this.state.to}</input>
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
