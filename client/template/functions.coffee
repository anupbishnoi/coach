Template.searchinput.placeholder = ->
  assert.stack.push "Template.searchinput.placeholder"
  str = get App.session.searchfor
  ensure "non_empty_string", str
  _s.humanize str

Template.resultlist.resultitems = (query)->
  App.searchfor (get App.session.searchfor),
      resultsview: (get App.session.resultsview)
      searchquery: (get App.session.searchquery)
