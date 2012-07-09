refreshDuties = ->
  App.collection(name).remove({}) for name in [
    "duty_type"
    "center_coordinator_duty"
  ]

  duty_type = App.find.one "doc_type", doc_id: "duty_type"
  center_coordinator_duty = App.find.one "doc_type", doc_id: "center_coordinator_duty"
  vmc = App.find.one "org", doc_id: "org/vmc"
  pp = App.find.one "center", doc_id: "center/vmc/pp"
  xiip05 = App.find.one "batch", doc_id: "batch/vmc/12p2005"
  xiip1 = App.find.one "group", doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/1"
  class1 = App.find.one "study_class",
      doc_id: "study_class/vmc/[vmc/[vmc/pp].[vmc/12p2005]/1].[vmc/physics/force_and_momentum]/1"
      
  sujeet_coordinator = App.find.one "center_coordinator", doc_id: "center_coordinator/vmc/pp/2"
  anirudh_teacher = App.find.one "teacher", doc_id: "teacher/vmc/1"
  physics_module = App.find.one "study_material",
    doc_id: "study_material/vmc/[vmc/12p2005].[vmc/physics].[vmc/module]/1"
  psingh_vendor = App.find.one "vendor", doc_id: "vendor/vmc/1"

  App.collection("duty_type").insert
    doc_id: "duty_type/vmc/print"

    doc_type: duty_type.doc_id
    org: vmc.doc_id
    id: "print"
    active: true
  print = App.find.one "duty_type", doc_id: "duty_type/vmc/print"

  App.collection("duty_type").insert
    doc_id: "duty_type/vmc/arrange"

    doc_type: duty_type.doc_id
    org: vmc.doc_id
    id: "arrange"
    active: true
  arrange = App.find.one "duty_type", doc_id: "duty_type/vmc/arrange"

  App.collection("duty_type").insert
    doc_id: "duty_type/vmc/distribute"

    doc_type: duty_type.doc_id
    org: vmc.doc_id
    id: "distribute"
    active: true
  distribute = App.find.one "duty_type", doc_id: "duty_type/vmc/distribute"

  App.collection("center_coordinator_duty").insert
    doc_id: "center_coordinator_duty/[vmc/pp/2].[vmc/print]/1"

    doc_type: center_coordinator_duty.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    center_coordinator: sujeet_coordinator.doc_id
    duty_type: print.doc_id
    id: "1"

    doc_name: "Print Attendance List for XIIth Pass 1 (Room 3)"
    on: class1.from
    done: false
    active: true
  duty_print = App.find.one "center_coordinator_duty",
    doc_id: "center_coordinator_duty/[vmc/pp/2].[vmc/print]/1"

  # one time duty
  App.collection("center_coordinator_duty").insert
    doc_id: "center_coordinator_duty/[vmc/pp/2].[vmc/arrange]/2"

    doc_type: center_coordinator_duty.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    center_coordinator: sujeet_coordinator.doc_id
    duty_type: arrange.doc_id
    id: "2"

    doc_name: "Arrange 23 copies of Physics Module 1 (2005)"
    on: class1.from
    study_class: class1.doc_id
    group: xiip1.doc_id
    room: class1.room
    vendor: psingh_vendor.doc_id
    done: false
    active: true
  duty_arrange = App.find.one "center_coordinator_duty",
    doc_id: "center_coordinator_duty/[vmc/pp/2].[vmc/arrange]/2"

  App.collection("center_coordinator_duty").insert
    doc_id: "center_coordinator_duty/[vmc/pp/2].[vmc/distribute]/1"

    doc_type: center_coordinator_duty.doc_id
    org: vmc.doc_id
    center: pp.doc_id
    center_coordinator: sujeet_coordinator.doc_id
    duty_type: distribute.doc_id
    id: "1"

    doc_name: "Distribute Physics Module 1 (2005) in XIIth Pass 1 on 20 May 2004, 3:30 PM"
    study_material: physics_module.doc_id
    group: xiip1.doc_id
    study_class: class1.doc_id
    on: class1.from
    done: false
    active: true
  duty_distribute = App.find.one "center_coordinator_duty",
    doc_id: "center_coordinator_duty/[vmc/pp/2].[vmc/distribute]/1"
