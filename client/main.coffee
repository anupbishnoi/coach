# Subscriptions
Meteor.subscribe name for name in Collection.list()

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
  Ensure.types "session_look_in_editing"
  , name: "whether look_in menu is being edited"
  , check: (editing)-> its "boolean", editing

  Ensure.types "session_query"
  , name: "session variable for search query"
  , check: (query)-> its "string", query

  keys = []

  fn = ->
    [ key, value ] =
      Match arguments
      , [ "non_empty_string"
          null ]
      , 1
      , "session"

    if value?
      Ensure "session_#{key}", value
      , "Invalid value specified for '#{key}': #{Json value}" +
        "\nShould have been of type: session_#{key}"
      keys.push key
      Meteor.session.set key, value
    else
      value = Meteor.session.get key
      Ensure "session_#{key}", value
      , "Invalid value stored in session variable '#{key}': #{Json value}"
      value

  fn.all = -> Objectify keys
              , (Meteor.session.get(k) for k in keys)
  fn
)()


# User
UserDetails = ->
  user_doc = Find "person/9"
  view_as = Get "role.0", user_doc
  ensure "type", view_as
  , -> "Invalid role (#{json view_as}) in user doc:\n#{json user_doc}"
  role_doc = Find view_as
  ensure "object", role_doc
  , -> "Role document not found for: #{json user_doc}"
  search_for_list = Get "can_search_for", role_doc
  ensure "array", search_for_list
  , -> "No searchable types specified for: #{json role_doc}"
  for item in search_for_list
    ensure "type", item
    , -> "'#{item}' not a valid type to search_for"
  search_for = Get "ui.search_for", role_doc
  look_in_selected = Get "ui.look_in.selected", role_doc
  look_in_order_obj = Get "ui.look_in.order", role_doc
  ensure "object", look_in_order_obj
  , -> "No look_in.order specified for role doc: #{json role_doc}"
  look_in_order = look_in_order_obj[search_for]
  ensure "array", look_in_order
  , -> "No look_in.order for #{search_for} in: #{json role_doc}"
  search_for ?= "student"
  look_in_selected ?= []
  look_in_order ?= [ "batch"
                     "group" ]
  { user_doc, view_as, role_doc, search_for
    search_for_list, look_in_selected, look_in_order }


# Startup
Session "look_in_editing", false
Session "query", ""

AppRouter = Backbone.Router.extend
  routes:
    "navigate/*query": "navigate"
  navigate: (query)->
    parts = query.split "/"
    [ keys, values ] = Arr.evenOdd parts
    parsed = Arr.objectify keys
             , values
             , "non_empty_string"

Router = null
Meteor.startup ->
  Router = new AppRouter()
  Backbone.history.start pushState: true

  jasmine.getEnv().execute()
