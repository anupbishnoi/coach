beforeEach ->
  this.addMatchers
    toBeType: (expected) ->
      this.message = -> "#{this.actual}#{if this.isNot then " not" else ""} of type: #{expected}"
      its expected, this.actual

# Language Helpers

describe "Json", ->
  it "stringifies numbers", ->
    expect(Json 9).toBe("9")
    expect(Json 0).toBe("0")
    expect(Json -1).toBe("-1")

  it "prints objects pretty with a tab space of 2", ->
    expect(Json haha:true).toBe("{\n  \"haha\": true\n}")

  it "handles null", ->
    expect(Json null).toBe("null")

  it "leaves undefined as is", ->
    expect(Json undefined).toBe(undefined)

  it "handles quotes", ->
    expect(Json 'hello "madam"').toBe("hello \"madam\"")
    expect(Json "hello 'madam'").toBe("hello 'madam'")

  it "ugly prints objects, with a flag", ->
    expect(Json haha:"yess", true).toBe("{\"haha\":\"yess\"}")


describe "Ensure", ->
  it "returns true when a type condition is satisfied", ->
    expect(Ensure "true", true).toBe(true)

  it "throws TypeException when a type condition is false", ->
    try Ensure "true", false catch e
      expect(e.type).toBe("TypeException")

  it "throws AssertException for a failed test with a message", ->
    try Ensure "true", false, "Assertion Error Message" catch e
      expect(e.type).toBe("AssertException")

  it "works the same for a message function as with a message", ->
    try
      Ensure "true", false
      , -> "Assertion Error Message"
    catch e
      expect(e.type).toBe("AssertException")

  it "puts Ensure.inside calls into a stack", ->
    func_name = "Function Name"
    Ensure.inside func_name
    expect(Ensure.stack 1).toBe("inside: #{func_name}")

  it "returns the last n calls in reverse chronological order
  with Ensure.stack(n), default value of n is 20", ->
    func_name = "Function Name"
    func2_name = "Another Function"
    Ensure.inside func_name
    Ensure.inside func2_name
    expect(Ensure.stack 2).toBe("inside: #{func2_name}\n-----\ninside: #{func_name}")

    Ensure.inside "func_#{i}" for i in [1..30]
    expect(Ensure.stack().split("-----").length).toBe(20)

  it "forgets the last n calls with Ensure.stack.forget(n), default value of n is 1", ->
    last_stack_call = Ensure.stack 1

    Ensure.inside "Some Function"
    Ensure.stack.forget()
    expect(Ensure.stack 1).toBe(last_stack_call)

    Ensure.inside "func_#{i}" for i in [1..30]
    Ensure.stack.forget 30
    expect(Ensure.stack 1).toBe(last_stack_call)

  it "puts arguments to Ensure.inside into the stack as well", ->
    func_name = "Function Name"
    args = [1, 2]
    Ensure.inside func_name, args
    expect(Ensure.stack 1).toBe("inside: #{func_name}\nwith: [\n  1,\n  2\n]")
    Ensure.stack.forget(1)

describe "Match", ->
  it "returns an array matching a specification, matching things in the specification
  left to right, placing null in places with no matching argument", ->
    matched = Match [ 1, "hello", true ]
              , [ "positive_integer", "non_empty_string", "function", "boolean" ]
    expect(matched).toEqual([ 1, "hello", null, true ])


describe "KeyValueAdder", ->
  it "returns a function that can take in key-value pairs with a specified value type 
  and attach the pair to a passed resource", ->
    resource = {}
    add = KeyValueAdder resource, "non_empty_string"
    [ key, value ] = [ "key", "value" ]
    add key, value
    expect(resource[key]).toBe(value)


describe "Arr", ->
  it ".initialDefined() returns array values until a null or undefined", ->
    expect(Arr.initialDefined [ 1, 0, false, undefined, "hello" ]).toEqual([ 1, 0, false ])

  it ".truthy() returns all truthy array values", ->
    expect(Arr.truthy [ 1, 0, false, undefined, "hello" ]).toEqual([ 1, "hello" ])

  it ".sum() returns sum of numbers in array", ->
    expect(Arr.sum [ 1, 2, 3 ]).toBe(6)

  it ".evenOdd() returns two arrays, made of values at
  even and odd indices in the passed array, respectively", ->
    expect(Arr.evenOdd [ 0, 1, 2, 3, 4 ]).toEqual([ [ 0, 2, 4 ], [ 1, 3 ] ])

  it ".objectify() returns an object with keys and
  corresponding values taken from arrays passed as arguments", ->
    expect(Arr.objectify [ "key" ], [ "value" ]).toEqual("key": "value")


describe "Obj", ->
  it ".breakApart() returns an array of objects with key and value fields
  for each key-value pair of original object", ->
    expect(Obj.breakApart { "key1": "value1", "key2": "value2" }, "K", "V")
      .toEqual([ { "K": "key1", "V": "value1" }, { "K": "key2", "V": "value2" } ])


describe "Keywords", ->
  it "returns a list of keywords (alpha-numeric words of minimum length 3),
  given an object or array of string, boolean or numbers", ->
    expect((Keywords { haha: true, yo: [ "hello", "ji" ], thisone: 23556 }).sort())
      .toEqual([ "haha", "true", "hello", "thisone", "23556" ].sort())


# App Helpers

describe "Collection", ->
  it "returns a meteor_collection for a passed name", ->
    expect(Collection "doc_type").toBeType("meteor_collection")

  it ".add() makes a new collection", ->
    Collection.add "test", true
    expect(Collection "test").toBeType("meteor_collection")

  it ".reset() removes all docs in the collection", ->
    (Collection "test").insert haha: true
    noOfDocs = -> Collection("test").find({}).fetch().length
    expect(noOfDocs()).toBe(1)
    Collection.reset "test"
    expect(noOfDocs()).toBe(0)


describe "Find", ->
  it "returns the document with the supplied doc_id", ->
    (Collection "test").insert doc_id: "test/loji", doc_type: "test"
    expect((Find "test/loji").doc_id).toBe("test/loji")

  describe "returns a single document matching the supplied selector if the selector has a doc_id field", ->
    it "when the selector is the first argument with a doc_type field in it", ->
      expect(Find doc_type: "test", doc_id: "test/loji").toBeType("object")
    it "when the first argument is the collection name and the second argument is the selector", ->
      expect(Find "test", doc_id: "test/loji").toBeType("object")

  it "throws if Find was passed enforce_found as true and the document wasn't found", ->
    expect(-> Find "lalala/lololo", true).toThrow()

  it "is idempotent", ->
    expect(Find Find "test/loji").toEqual(Find "test/loji")

describe "Get", ->
  it "returns the value of the specified field in the doc passed in", ->
    (Collection "test").insert doc_id: "test/yoyoyo", doc_type: "test", obj: arr: [ ref: "test/nonono" ]
    (Collection "test").insert doc_id: "test/nonono", doc_type: "test", value: text: "Hadippa!"
    expect(Get "obj.arr.0.ref/value.text", Find "test/yoyoyo").toBe("Hadippa!")


describe "Update", ->
  it "updates the given doc with the specified mongo modifier", ->
    expect((Find "test/nonono").value.text).toBe("Hadippa!")
    Update (Find "test/nonono")
    , $set: "value.text": "Harappa."
    expect((Find "test/nonono").value.text).toBe("Harappa.")


describe "DocIdfy", ->
  it "converts all 'id's in passed selector to 'doc_id's", ->
    expect(DocIdfy org: "vmc").toEqual(org: "org/vmc")
    expect(DocIdfy center: "pp", org:"vmc").toEqual(center: "center/vmc/pp", org: "org/vmc")
    expect( DocIdfy center: "pp"
                  , batch: "12p2005"
                  , group: "1"
                  , org: "vmc"
                  , topic: "f_and_m"
                  , subject: "physics"
                  , study_class: "2" )
      .toEqual( center: "center/vmc/pp"
              , batch: "batch/vmc/12p2005"
              , group: "group/[center/vmc/pp].[batch/vmc/12p2005]/1"
              , org: "org/vmc"
              , topic: "topic/vmc/physics/f_and_m"
              , subject: "subject/vmc/physics"
              , study_class: "study_class/[group/[center/vmc/pp].[batch/vmc/12p2005]/1].[topic/vmc/physics/f_and_m]/2" )


describe "DocMap", ->
  it ".add() a doc map with a specification object against a key", ->
    expect(-> DocMap.add "test_map", group: field: [ "'constant'", "doc_type", value: "obj.arr.0.ref/value.text" ])
      .not.toThrow()

  it "returns all docs mapped to new values using the provided specification", ->
    expect(DocMap "test_map", [ Find "test/yoyoyo" ])
      .toEqual([ group: field: [ "constant", "test", value: "Harappa." ] ])


describe "QueryFilter", ->
  it ".addSearchable() to specify searchable values in documents of a particular doc_type", ->
    expect(-> QueryFilter.addSearchable "test": [ "value.text" ])
      .not.toThrow()

  it "returns a function that matches (with AND predicate) the passed doc with the query specified to QueryFilter", ->
    expect(_.filter [ (Find "test/yoyoyo"), (Find "test/nonono") ], QueryFilter "harappa")
      .toEqual([ Find "test/nonono" ])
    
