all_subscriptions_loaded = false
subscriptions_onComplete =
  _.after Collection.list().length
  , ->
      all_subscriptions_loaded = true
      jasmine.getEnv().addReporter(new jasmine.ConsoleReporter());
      jasmine.getEnv().execute()
      UserDetails()

# Subscriptions
Meteor.subscribe name, subscriptions_onComplete for name in Collection.list()


# Session
Meteor.session = Session
Session = (->
  types =
    look_in_editing:  "boolean"
    search_query:     "string"
    user_details:     "object"
    user_name:        "string"

  _.each types, (type, name) ->
    Ensure.types "session_#{name}"
    , (v) -> its type, v

  fn = ->
    [ key, value ] =
      Match arguments
      , [ "non_empty_string"
          null ]
      , 1
      , "Session"

    Ensure "defined", types[key]
    , "No such session variable: #{key}"

    if value?
      Ensure "session_#{key}", value
      , -> "Invalid value specified for '#{key}': #{Json value}" +
           "\nShould have been of type: session_#{key}"
      Meteor.session.set key, value
    else
      value = Meteor.session.get key
      Ensure "session_#{key}", value
      , -> "Invalid value stored in session variable '#{key}': #{Json value}"
      value
  fn
)()

# Startup
Session "look_in_editing", no
Session "search_query", ""
Session "user_details", {}
Session "user_name", "Madan Lal"

# User
UserDetails = (->
  fn = ->
    user_details = Session "user_details"
    return user_details if not _.isEmpty user_details

    return {} if not all_subscriptions_loaded
    user_doc = Find.one "person", doc_name: Session "user_name"
    view_as = Get "role.0", user_doc, true
    role_doc = Find view_as, true
    view_as_type = Str.uptilFirst "/", view_as
    Ensure view_as_type, view_as
    , -> "Invalid role (#{Json view_as}) in user doc:\n#{Json user_doc}"
    search_for_list = Get "can_search_for", role_doc, true
    for item in search_for_list
      Ensure "type", item
      , -> "'#{item}' not a valid type to search for, in role doc: #{Json role_doc}"

    ui_options = Get "ui", role_doc
    if its.not "object", ui_options
      ui_options ?= {}
      Update role_doc
      , "ui": ui_options
    search_for = Get "ui.search_for", role_doc
    if not search_for?
      search_for ?= "student"
      ui_options.search_for = search_for

    look_in_selected = Get "ui.look_in_selected", role_doc
    if not look_in_selected?
      ui_options.look_in_selected = look_in_selected = {}

    selected = look_in_selected[search_for]
    if not selected?
      ui_options.look_in_selected[search_for] = selected = []

    look_in_order = Get "ui.look_in_order", role_doc
    if not look_in_order?
      ui_options.look_in_order = look_in_order = {}

    order = look_in_order[search_for]
    if not order?
      ui_options.look_in_order[search_for] = order = [ "batch", "group" ]

    Update role_doc
    , $set: "ui": ui_options

    user_details = { user_doc, view_as, view_as_type, role_doc, search_for
                     search_for_list, look_in_selected, look_in_order }
    Session "user_details", user_details
    user_details

  fn.reset = -> Session "user_details", {}
  fn
)()

AppRouter = Backbone.Router.extend
  routes:
    "navigate/*query": "navigate"
  navigate: (query) ->
    parts = query.split "/"
    [ keys, values ] = Arr.evenOdd parts
    parsed = Arr.objectify keys
             , values
             , "non_empty_string"

Router = null
Meteor.startup ->
  Router = new AppRouter()
  Backbone.history.start pushState: true
