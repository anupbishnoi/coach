## Language Helpers

# Json
describe "json"
, ->
    it "stringifies numbers"
    , ->
        expect(Json 9).toBe("9")
        expect(Json 0).toBe("0")
        expect(Json -1).toBe("-1")

    it "prints objects pretty"
    , -> expect(Json haha:true).toBe("{\n  \"haha\": true\n}")

    it "handles null"
    , -> expect(Json null).toBe("null")

    it "leaves undefined as is"
    , -> expect(Json undefined).toBe(undefined)

    it "handles quotes"
    , ->
        expect(Json 'hello "madam"').toBe("hello \"madam\"")
        expect(Json "hello 'madam'").toBe("hello 'madam'")

    it "ugly prints objects, with a flag"
    , -> expect(Json haha:"yess", true).toBe("{\"haha\":\"yess\"}")

# Ensure
describe "ensure"
, -> 
    #it ""

