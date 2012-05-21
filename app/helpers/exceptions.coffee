exceptionText = -> this.type +
  if this.message then ": #{this.message}" else ""

AssertException = (whatswrong)->
  this.type = "AssertException"
  this.message = whatswrong
AssertException.prototype.toString = exceptionText

TypeException = (message)->
  this.type = "TypeException"
  this.message = message
TypeException.prototype.toString = exceptionText

NoSuchQuery = (query)->
  this.type = "NoSuchQuery"
  this.message = query
NoSuchQuery.prototype.toString = exceptionText
