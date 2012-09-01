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

# App stuff
DocFilter.addSearchable
  "student": [ "id"
               "doc_name"
               "email"
               "phone"
               "address"
               "center/doc_name"
               "center/id"
               "org/doc_name"
               "batch/doc_name"
               "batch/id" ]
  "study_class": [ "center/doc_name"
                   "center/id"
                   "batch/doc_name"
                   "batch/id"
                   "group/doc_name"
                   "subject/doc_name"
                   "topic/doc_name"
                   "teacher/doc_name"
                   "room/doc_name" ]

DocMap.add
  "result_list/student/center_manager":
    identification:
      main: "doc_name"
      secondary: "id"
      more: [ "phone"
              "address" ]
    information:
      "Center": "center/doc_name"
      "Group": "group/doc_name"
      "Due": "due_installment"
      "Last Paid": "last_paid_on"
    action: [ "'pay_installment'" ]

  "result_list/study_class/center_manager":
    identification:
      main: "topic_and_id"
      secondary: "teacher/doc_name"
      more: [ "from_and_to"
              "subject_and_batch" ]
    information:
      "Center": "center/doc_name"
      "Group": "group/doc_name"
      "Room": "room/doc_name"
    action: [ "'nothing'" ]


# Session
Meteor.session = Session
Session = (->
  types =
    look_in_editing: "boolean"
    search_query: "string"
    user_details: "object"

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

# User
UserDetails = ->
  user_details = Session "user_details"
  return user_details if not _.isEmpty user_details

  return {} if not all_subscriptions_loaded
  user_doc = Find "person/9"
  view_as = Get "role.0", user_doc, true
  role_doc = Find view_as
  Ensure "object", role_doc
  , -> "Role document not found for: #{Json user_doc}"
  view_as_type = Str.uptilFirst "/", view_as
  Ensure view_as_type, view_as
  , -> "Invalid role (#{Json view_as}) in user doc:\n#{Json user_doc}"
  search_for_list = Get "can_search_for", role_doc, true
  for item in search_for_list
    Ensure "type", item
    , -> "'#{item}' not a valid type to search for, in role doc: #{Json role_doc}"
  search_for = Get "ui.search_for", role_doc
  search_for ?= "student"
  look_in_selected = Get "ui.look_in.selected", role_doc
  look_in_selected ?= []
  look_in_order_obj = Get "ui.look_in.order", role_doc, true
  look_in_order = look_in_order_obj[search_for]
  look_in_order ?= [ "batch"
                     "group" ]
  user_details = { user_doc, view_as, view_as_type, role_doc, search_for
                   search_for_list, look_in_selected, look_in_order }
  Session "user_details", user_details
  user_details

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
