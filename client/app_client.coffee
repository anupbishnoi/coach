App.map.add "result_list/student/center_manager",
  "identification":
    "main": "#doc_name"
    "secondary": "#id"
    "more": ["#phone", "#address"]
  "information":
    "Center": "#center/doc_name"
    "Group": "#group/doc_name"
    "Due": "#due_installment"
    "Last Paid": "#last_paid_on"
  "action": ["pay_installment"]

App.map.add "search_for/student/center_manager",
  "type_id": "#doc_id"
  "type_name": "#doc_name"

App.session = (->
  format =
    "view_as": "string"
    "search_for": "string"
    "look_in": "object"
    "data.look_in_selected": "array"

  keys = []

  fn = (key, value)->
    ensure.inside "App.session", arguments
    ensure "string", key, "Session variable key must be a string"

    ensure "exists", format[key],
      "Invalid session variable, no such found: #{key}"
    unless ensure.test "exists", value
      value = Session.get key
      ensure format[key], value,
        "Invalid value stored in '#{key}': #{json value}"
      value
    else
      ensure format[key], value,
        "Invalid value specified for '#{key}': #{json value}" +
        "\nShould have been: #{format[key]}"
      keys.push key
      Session.set key, value
      Session.get key

  fn.all = -> _.objectify keys, (Session.get(k) for k in keys)
    
  fn
)()
