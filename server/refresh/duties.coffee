refreshDuties = ->
  collection.remove({}) for collection in [
    CenterCoordinatorDuty
  ]

  vmc = Org.findOne doc_id: "vmc"
  pp = Center.findOne doc_id: "vmc/center/pp"
  xiip05 = Batch.findOne doc_id: "vmc/batch/12p2005"
  xiip1 = Group.findOne doc_id: "vmc/group/pp/12p2005/1"
  class1 = Class.findOne
      doc_id: "vmc/class/pp/12p2005/1/physics/force_and_momentum/1"
  sujeet_coordinator = CenterCoordinator.findOne doc_id: "vmc/center_coordinator/pp/2"
  anirudh_teacher = Teacher.findOne doc_id: "vmc/teacher/pp/physics/1"
  physics_module = StudyMaterial.findOne
    doc_id: "vmc/study_material/12p2005/physics/module/1"
  psingh_vendor = Vendor.findOne doc_id: "vmc/vendor/1"

  CenterCoordinatorDuty.insert
    doc_id: "vmc/center_coordinator_duty/pp/2/print/1"

    org: vmc.doc_id
    doc_type: "center_coordinator_duty"
    center_coordinator: sujeet_coordinator.doc_id
    duty_type: "print"
    id: 1

    doc_name: "Print Attendance List for XIIth Pass 1 (Room 3)"
    on: class1.from
    done: false
  duty_print = CenterCoordinatorDuty.findOne
    doc_id: "vmc/center_coordinator_duty/pp/2/print/1"

  # one time duty
  CenterCoordinatorDuty.insert
    doc_id: "vmc/center_coordinator_duty/pp/2/arrange/2"

    org: vmc.doc_id
    doc_type: "center_coordinator_duty"
    center_coordinator: sujeet_coordinator.doc_id
    duty_type: "arrange"
    id: 2

    doc_name: "Arrange 23 copies of Physics Module 1 (2005)"
    on: class1.from
    class: class1.doc_id
    group: xiip1.doc_id
    room: class1.room
    vendor: psingh_vendor.doc_id
    done: false
  duty_arrange = CenterCoordinatorDuty.findOne
    doc_id: "vmc/center_coordinator_duty/pp/2/arrange/2"

  CenterCoordinatorDuty.insert
    doc_id: "vmc/center_coordinator_duty/pp/2/distribute/pp/12p2005/1/12p2005/physics/module/1"

    org: vmc.doc_id
    doc_type: "center_coordinator_duty"
    center_coordinator: sujeet_coordinator.doc_id
    duty_type: "distribute"
    group: xiip1.doc_id
    study_material: physics_module.doc_id

    doc_name: "Distribute Physics Module 1 (2005) in XIIth Pass 1 on 20 May 2004, 3:30 PM"
    class: class1.doc_id
    on: class1.from
    center: pp.doc_id
    batch: xiip05.doc_id
    done: false
  duty_distribute = CenterCoordinatorDuty.findOne
    doc_id: "vmc/center_coordinator_duty/pp/2/distribute/pp/12p2005/1/12p2005/physics/module/1"

