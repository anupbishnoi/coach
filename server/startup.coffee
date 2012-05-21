Meteor.startup ->
  if Person.find().count() is 0
    Person.insert
      name: "Anup Bishnoi"
      dob: new Date(1986, 7, 21)
      phone: "+91-9868768262"
      email: [ "pixelsallover@gmail.com"
             , "anup.bishnoi@vidyamandir.com"
             ]
      address: "39/H-33, Sector-3, Rohini, Delhi - 110085"
    Person.insert
      name: "Sujeet Shivhare"
      phone: ["+91-8588801214", "+91-9013926056"]

  anup = Person.findOne name: "Anup Bishnoi"
  sujeet = Person.findOne name: "Sujeet Shivhare"

  if Center.find().count() is 0
    Center.insert
      name: "Pitampura"
      head: anup._id
      coordinator:
        "Sujeet Shivhare": sujeet._id
      course:
        "2015":
          batch:
            "AimIIT":
              group:
                "AimIIT 1":
                  from: new Date(2012, 5, 10)
            "Correspondence":
              from: new Date(2012, 5, 4)
  
