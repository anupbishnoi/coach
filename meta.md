Code Structure
==============

## App

* _app/_
  * __app.coffee__  
    * App
      - _[session]_  
        Set or get session data
      - _searchfor_  
        Maps common app-level queries to mongo queries.
        Client runs them on browser's minimongo, and the server runs
        them on Mongo (as of now) on the backend.

  * __models.coffee__  
    - Person
    - Center
    - InOut

  * _helpers/_

    * __language_helpers.coffee__

      * __s_  
        String manipulation helpers

      * _assert_  
        `(exp, message, OptionalExceptionType)`  
        Throws Exception with message if exp is not true
        - stack  
          List of names of selected functions called in order.

      * _defaults_  
        `(argobj, defaults_obj)`  
        Return argobj filled in with default values from defaults_obj if needed

      * _ensure_  
        `(type, v)`  
        Ensure that the given argument is of given type
        Accepted types:
        - "string"
        - "string_if_defined"
        - "non_empty_string"

      * _get_  
        Sugar to write `some.value()` as `(get some.value)`

    * __exceptions.coffee__
      - AssertException
      - TypeException  
      - NoSuchQuery


* _client/_

  * __main.coffee__  
    Client startup code

  * _template/_

    * __events.coffee__  
      Registered template events

    * __functions.coffee__  
      Registered template helper functions

* _server/_
  * __startup.coffee__
  * __access.coffee__
  * __publish.coffee__

* _lib/_
  - underscore.string.js

* _public/_
  - vmc_logo.gif

## HTML

* __main.html__  
* __main.less__  

* * *

## Session

`(get App.session.searchfor)` and `App.session.searchfor("student")`

* _searchfor_  
  Search for what?
  - student
  - teacher
  - class
  - center

* _resultsview_  
  Search results as seen by?
  - center_manager
  - class_coordinator
  - front_desk
  - teacher

* _searchquery_  
  Query in the search input box


* * *
[app]: #app "App Code"
[models]: #models "Models Code"
[exceptions]: #exceptions "Exceptions Code"
[helpers]: #helpers "Helpers Code"
[db]: #mongo "Mongo API"
[session]: #session "Session Variables"

