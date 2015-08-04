// FUBAR
hljs.registerLanguage('irc', function(hljs) {
  return {
    aliases: ['irc'],
    c: [
      {
        cN: 'string',
        v: [{
          b: '\\<',
          e: '\\>'
        },{
          b: /\* \w+/,
          e: ' '
        }]
      },
      {
        cN: 'number',
        b: '\\[',
        e: '\\]',
      },
      {
        cN: 'comment',
        b: '\\*\\*\\*',
        e: /$/
      },
      {
        cN: 'comment',
        b: /-\w+-/,
        e: /$/
      },
      {
        cN: 'request',
        b: '---------\>',
        e: /$/
      }
    ]
  };
});
