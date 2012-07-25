((log, json, ensure, its, inside, error)->

  App.filter.addSearchable
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

  App.map.add
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

    "search_for/center_manager":
      type_id: "doc_id"
      type_name: "doc_name"

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

  App.ui.add
    "result_list/study_class/center_manager":
      (argobj)->
        argobj = {} if its.not "object", argobj
        {look_in, query} = _.defaults argobj
                           , look_in: ""
                           , query: ""
        seq = [ "subject"
                "subject"
                "group" ]

    "result_list/student/center_manager":
      (argobj)->
        argobj = {} if its.not "object", argobj
        {look_in, query} = _.defaults argobj
                           , look_in: ""
                           , query: ""
        seq = [ "center"
                "batch"
                "group" ]
        selector = App.docIdfy _.objectify seq
                               , (look_in.split "/")
                               , "non_empty_string"
                               , true

        docs = App.find.filter "student"
               , selector
               , App.filter query

        breakApartInformation = (doc)->
          doc.information =
            _.breakApart doc.information
            , "field"
            , "value"
          doc
        stringifyPhone = (doc)->
          try
            doc.identification.more[0] =
              doc.identification.more[0].join ", "
          doc
        App.map docs
        , "result_list/student/center_manager"
        , breakApartInformation
        , stringifyPhone

    "search_for/center_manager":
      (search_for)->
        options = [ "student"
                    "study_class"
                    "teacher" ]
        docs = _.onlyDefined _.map options
                             , (option)->
                               App.find.one "doc_type"
                               , doc_id: option
        App.map docs
        , "search_for/center_manager"
        , (doc)->
            if doc.type_id is search_for
              doc.ui_active = "active"
            doc

    "look_in/selected/student/center_manager":
      (look_in)->
        ensure "string", look_in
        , "look_in needs to be a string"
        seq = [ "center"
                "batch"
                "group" ]
        ids = look_in.split "/"
        _.initialDefined (
          _.map (_.filter ids, (id)-> its "non_empty_string", id)
          , (id, i)->
            selector = App.docIdfy _.objectify seq[0..i]
                                   , ids[0..i]
                                   , "non_empty_string"
                                   , true
            field = seq[i]
            if its "non_empty_string", selector[field]
              App.find.one field
              , doc_id: selector[field]
        )

    "look_in/options/student/center_manager":
      (selected)->
        seq = [ "center"
                "batch"
                "group" ]
        if selected.length >= seq.length
          []
        else
          selector = {}
          for v, i in selected
            selector[seq[i]] = selected[i].doc_id
          App.find seq[selected.length]
          , selector

)(_.log, _.json, _.ensure, _.ensure.test, _.ensure.inside, _.ensure.error)
