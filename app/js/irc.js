// FUBAR
hljs.registerLanguage('irc', function(hljs) {
  return {
    aliases: ['irc'],
    k: 'Joins: Quits:',
    c: [
      {
        cN: 'string',
        b: '\\<',
        e: '\\>'
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
      }
    ]
  };
});
