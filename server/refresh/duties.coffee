refreshDuties = ->
  (Collection name).remove({}) for name in [
    "duty_type"
    "center_coordinator_duty"
  ]

  duty_type = Find.one "doc_type", doc_id: "duty_type"
  center_coordinator_duty = Find.one "doc_type", doc_id: "center_coordinator_duty"
  vmc = Find.one "org", doc_id: "org/vmc"
  pp = Find.one "center", doc_id: "center/vmc/pp"
  xiip05 = Find.one "batch", doc_id: "batch/vmc/12p2005"
  xiip1 = Find.one "group", doc_id: "group/vmc/[vmc/pp].[vmc/12p2005]/1"
  class1 = Find.one "study_class",
      doc_id: "study_class/vmc/[vmc/[vmc/pp].[vmc/12p2005]/1].[vmc/physics/force_and_momentum]/1"
      
  sujeet_coordinator = Find.one "center_coordinator", doc_id: "center_coordinator/vmc/pp/2"
  anirudh_teacher = Find.one "teacher", doc_id: "teacher/vmc/1"
  physics_module = Find.one "study_material",
    doc_id: "study_material/vmc/[vmc/12p2005].[vmc/physics].[vmc/module]/1"
  psingh_vendor = Find.one "vendor", doc_id: "vendor/vmc/1"

  (Collection "duty_type").insert
    doc_id: "duty_type/vmc/print"

    doc_type: duty_type.doc_id
    org: vmc.doc_id
    id: "print"
    active: true
  print = Find.one "duty_type", doc_id: "duty_type/vmc/print"

  (Collection "duty_type").insert
    doc_id: "duty_type/vmc/arrange"

    doc_type: duty_type.doc_id
    org: vmc.doc_id
    id: "arrange"
    active: true
  arrange = Find.one "duty_type", doc_id: "duty_type/vmc/arrange"

  (Collection "duty_type").insert
    doc_id: "duty_type/vmc/distribute"

    doc_type: duty_type.doc_id
    org: vmc.doc_id
    id: "distribute"
    active: true
  distribute = Find.one "duty_type", doc_id: "duty_type/vmc/distribute"

  (Collection "center_coordinator_duty").insert
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
  duty_print = Find.one "center_coordinator_duty",
    doc_id: "center_coordinator_duty/[vmc/pp/2].[vmc/print]/1"

  # one time duty
  (Collection "center_coordinator_duty").insert
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
  duty_arrange = Find.one "center_coordinator_duty",
    doc_id: "center_coordinator_duty/[vmc/pp/2].[vmc/arrange]/2"

  (Collection "center_coordinator_duty").insert
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
  duty_distribute = Find.one "center_coordinator_duty",
    doc_id: "center_coordinator_duty/[vmc/pp/2].[vmc/distribute]/1"
